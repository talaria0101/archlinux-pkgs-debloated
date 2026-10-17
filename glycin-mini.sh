#!/bin/sh

set -e

sed -i -e 's|-O2|-Os|' /etc/makepkg.conf

export NOT_IN_REPOS=1
export PKGBUILD_REPO=https://github.com/QaidVoid/glycin-ng.git

get-pkgbuild
cd "$BUILD_DIR"

cat "$PKGBUILD"

# Do not build if this version is already released
if check-upstream-version; then
	makepkg -fs --noconfirm --skippgpcheck
else
	exit 0
fi

ls -la
rm -fv ./*-docs-*.pkg.tar.* ./*-debug-*.pkg.tar.* ./*-demos-*.pkg.tar.*
mv -v ./glycin-ng-*.pkg.tar.zst ../"$PACKAGE"-mini-"$ARCH".pkg.tar.zst

echo "All done!"
