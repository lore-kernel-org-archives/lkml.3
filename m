Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab3DDIE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:04:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48521 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414Ab3DDIEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:04:52 -0400
Date: Thu, 4 Apr 2013 10:04:55 +0200
From: Anisse Astier <anisse@astier.eu>
To: linux-kbuild@vger.kernel.org
Cc: Anisse Astier <anisse@astier.eu>, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, maximilian attems <max@stro.at>
Subject: Re: [PATCH 1/2] deb-pkg: split debug symbols in their own package
Message-ID: <20130404100455.64367233@serenity>
In-Reply-To: <1363946761-7449-1-git-send-email-anisse@astier.eu>
References: <1363946761-7449-1-git-send-email-anisse@astier.eu>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments ?

Anisse

On Fri, 22 Mar 2013 11:06:00 +0100, Anisse Astier <anisse@astier.eu> wrote :

> This can reduce almost 3 times the size of the linux-image package,
> while keeping the debug symbols available for this particular build, in
> their own package.
> 
> This mimics the way kernels are built in debian, ubuntu, or with
> make-kpkg, and comes at the price of a small slowdown in the building of
> packages.
> 
> Signed-off-by: Anisse Astier <anisse@astier.eu>
> ---
>  scripts/package/builddeb | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index acb8650..7f7a7fd 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -78,17 +78,19 @@ tmpdir="$objtree/debian/tmp"
>  fwdir="$objtree/debian/fwtmp"
>  kernel_headers_dir="$objtree/debian/hdrtmp"
>  libc_headers_dir="$objtree/debian/headertmp"
> +dbg_dir="$objtree/debian/dbgtmp"
>  packagename=linux-image-$version
>  fwpackagename=linux-firmware-image
>  kernel_headers_packagename=linux-headers-$version
>  libc_headers_packagename=linux-libc-dev
> +dbg_packagename=$packagename-dbg
>  
>  if [ "$ARCH" = "um" ] ; then
>  	packagename=user-mode-linux-$version
>  fi
>  
>  # Setup the directory structure
> -rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir"
> +rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir" "$dbg_dir"
>  mkdir -m 755 -p "$tmpdir/DEBIAN"
>  mkdir -p  "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
>  mkdir -m 755 -p "$fwdir/DEBIAN"
> @@ -98,6 +100,8 @@ mkdir -p "$libc_headers_dir/usr/share/doc/$libc_headers_packagename"
>  mkdir -m 755 -p "$kernel_headers_dir/DEBIAN"
>  mkdir -p "$kernel_headers_dir/usr/share/doc/$kernel_headers_packagename"
>  mkdir -p "$kernel_headers_dir/lib/modules/$version/"
> +mkdir -p "$dbg_dir/usr/share/doc/$dbg_packagename"
> +mkdir -m 755 -p "$dbg_dir/DEBIAN"
>  if [ "$ARCH" = "um" ] ; then
>  	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/bin"
>  fi
> @@ -128,8 +132,24 @@ if grep -q '^CONFIG_MODULES=y' .config ; then
>  		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
>  		rmdir "$tmpdir/lib/modules/$version"
>  	fi
> +	# Build debug package
> +	(
> +		cd $tmpdir
> +		for module in $(find lib/modules/ -name *.ko); do
> +			mkdir -p $(dirname $dbg_dir/usr/lib/debug/$module)
> +			# only keep debug symbols in the debug file
> +			objcopy --only-keep-debug $module $dbg_dir/usr/lib/debug/$module
> +			# strip original module from debug symbols
> +			objcopy --strip-debug $module
> +			# then add a link to those
> +			objcopy --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $module
> +		done
> +	)
>  fi
>  
> +mkdir -p $dbg_dir/usr/lib/debug/lib/modules/$version/
> +cp vmlinux $dbg_dir/usr/lib/debug/lib/modules/$version/
> +
>  if [ "$ARCH" != "um" ]; then
>  	$MAKE headers_check KBUILD_SRC=
>  	$MAKE headers_install KBUILD_SRC= INSTALL_HDR_PATH="$libc_headers_dir/usr"
> @@ -297,6 +317,17 @@ if [ "$ARCH" != "um" ]; then
>  	create_package "$libc_headers_packagename" "$libc_headers_dir"
>  fi
>  
> +cat <<EOF >> debian/control
> +
> +Package: $dbg_packagename
> +Section: devel
> +Provides: linux-debug, linux-debug-$version
> +Architecture: any
> +Description: Linux kernel debugging symbols for $version
> + This package will come in handy if you need to debug the kernel.
> +EOF
> +
> +create_package "$dbg_packagename" "$dbg_dir"
>  create_package "$packagename" "$tmpdir"
>  
>  exit 0
