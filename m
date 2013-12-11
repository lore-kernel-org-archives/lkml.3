Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3LKP4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:56:51 -0500
Received: from vm1.sequanux.org ([188.165.36.56]:34695 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab3LKP4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:56:48 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 10:56:48 EST
Date: Wed, 11 Dec 2013 16:46:26 +0100
From: Simon Guinot <simon.guinot@sequanux.org>
To: P J P <ppandit@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] Read CONFIG_RD_ variables for initramfs compression
Message-ID: <20131211154626.GX16823@kw.sim.vm.gnt>
References: <alpine.LFD.2.03.1310152002200.7552@erqung.pbz>
 <20131029151507.8f63dad8e7525e33431d9596@linux-foundation.org>
 <alpine.LFD.2.03.1310301226260.12975@erqung.pbz>
 <20131030150521.ff3fd577a6e506e4278db48c@linux-foundation.org>
 <alpine.LFD.2.03.1310311222150.23774@erqung.pbz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JyUo+2rKuw1VKSUr"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1310311222150.23774@erqung.pbz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JyUo+2rKuw1VKSUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2013 at 12:35:05PM +0530, P J P wrote:
>   Hello Andrew,
>=20
> +-- On Wed, 30 Oct 2013, Andrew Morton wrote --+
> | Isn't there some convenient way of testing for the presence of an=20
> | executable in $PATH?
> |=20
> | The shell-builtin `which' seems to dtrt:
>=20
>   True. Please see an updated patch attached herein.
>=20
> Thank you.
> --
> Prasad J Pandit / Red Hat Security Response Team

> From 352781fd2846c54e92ae0c37dd972dc5fcdfb695 Mon Sep 17 00:00:00 2001
> From: P J P <prasad@redhat.com>
> Date: Thu, 31 Oct 2013 12:03:00 +0530
> Subject: Read CONFIG_RD_ variables for initramfs compression
>=20
> When expert configuration option(CONFIG_EXPERT) is enabled,
> menuconfig offers a choice of compression algorithm to compress
> initial ramfs image; This choice is stored into CONFIG_RD_*
> variables. But usr/Makefile uses earlier INITRAMFS_COMPRESSION_*
> macros to build initial ramfs file. Since none of them is defined,
> resulting 'initramfs_data.cpio' file remains un-compressed.
>=20
> This patch updates the Makefile to use CONFIG_RD_* variables and
> adds support for LZ4 compression algorithm. Also updates the
> 'gen_initramfs_list.sh' script to check whether a selected
> compression command is accessible or not. And fall-back to default
> gzip(1) compression when it is not.
>=20
> Signed-off-by: P J P <prasad@redhat.com>

Hi P J P,

IIUC this patch, the INITRAMFS_COMPRESSION_* options are now
ignored/useless. Don't you think we should remove them from the
usr/Kconfig file ?

Actually, I think this patch makes the initramfs compression
configuration quite confusing. Consider the following configuration
for a 3.13-rc3 kernel:

CONFIG_RD_GZIP=3Dy
CONFIG_RD_LZMA=3Dy
CONFIG_INITRAMFS_COMPRESSION_LZMA=3Dy

This now produces a gzipped initramfs_data.cpio against a lzma one
previously.=20

Regards,

Simon

>=20
> diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
> index b482f16..ef47409 100644
> --- a/scripts/gen_initramfs_list.sh
> +++ b/scripts/gen_initramfs_list.sh
> @@ -240,12 +240,24 @@ case "$arg" in
>  		output_file=3D"$1"
>  		cpio_list=3D"$(mktemp ${TMPDIR:-/tmp}/cpiolist.XXXXXX)"
>  		output=3D${cpio_list}
> -		echo "$output_file" | grep -q "\.gz$" && compr=3D"gzip -n -9 -f"
> -		echo "$output_file" | grep -q "\.bz2$" && compr=3D"bzip2 -9 -f"
> -		echo "$output_file" | grep -q "\.lzma$" && compr=3D"lzma -9 -f"
> -		echo "$output_file" | grep -q "\.xz$" && \
> -				compr=3D"xz --check=3Dcrc32 --lzma2=3Ddict=3D1MiB"
> -		echo "$output_file" | grep -q "\.lzo$" && compr=3D"lzop -9 -f"
> +		echo "$output_file" | grep -q "\.gz$" \
> +                && [ -x "`which gzip 2> /dev/null`" ] \
> +                && compr=3D"gzip -n -9 -f"
> +		echo "$output_file" | grep -q "\.bz2$" \
> +                && [ -x "`which bzip2 2> /dev/null`" ] \
> +                && compr=3D"bzip2 -9 -f"
> +		echo "$output_file" | grep -q "\.lzma$" \
> +                && [ -x "`which lzma 2> /dev/null`" ] \
> +                && compr=3D"lzma -9 -f"
> +		echo "$output_file" | grep -q "\.xz$" \
> +                && [ -x "`which xz 2> /dev/null`" ] \
> +                && compr=3D"xz --check=3Dcrc32 --lzma2=3Ddict=3D1MiB"
> +		echo "$output_file" | grep -q "\.lzo$" \
> +                && [ -x "`which lzop 2> /dev/null`" ] \
> +                && compr=3D"lzop -9 -f"
> +		echo "$output_file" | grep -q "\.lz4$" \
> +                && [ -x "`which lz4 2> /dev/null`" ] \
> +                && compr=3D"lz4 -9 -f"
>  		echo "$output_file" | grep -q "\.cpio$" && compr=3D"cat"
>  		shift
>  		;;
> diff --git a/usr/Makefile b/usr/Makefile
> index 029ffe6..e767f01 100644
> --- a/usr/Makefile
> +++ b/usr/Makefile
> @@ -6,20 +6,23 @@ klibcdirs:;
>  PHONY +=3D klibcdirs
> =20
> =20
> -# Gzip
> -suffix_$(CONFIG_INITRAMFS_COMPRESSION_GZIP)   =3D .gz
> -
>  # Bzip2
> -suffix_$(CONFIG_INITRAMFS_COMPRESSION_BZIP2)  =3D .bz2
> +suffix_$(CONFIG_RD_BZIP2)  =3D .bz2
> =20
>  # Lzma
> -suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZMA)   =3D .lzma
> +suffix_$(CONFIG_RD_LZMA)   =3D .lzma
> =20
>  # XZ
> -suffix_$(CONFIG_INITRAMFS_COMPRESSION_XZ)     =3D .xz
> +suffix_$(CONFIG_RD_XZ)     =3D .xz
> =20
>  # Lzo
> -suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   =3D .lzo
> +suffix_$(CONFIG_RD_LZO)    =3D .lzo
> +
> +# Lz4
> +suffix_$(CONFIG_RD_LZ4)    =3D .lz4
> +
> +# Gzip
> +suffix_$(CONFIG_RD_GZIP)   =3D .gz
> =20
>  AFLAGS_initramfs_data.o +=3D -DINITRAMFS_IMAGE=3D"usr/initramfs_data.cpi=
o$(suffix_y)"
> =20
> @@ -53,7 +56,10 @@ endif
>  quiet_cmd_initfs =3D GEN     $@
>        cmd_initfs =3D $(initramfs) -o $@ $(ramfs-args) $(ramfs-input)
> =20
> -targets :=3D initramfs_data.cpio.gz initramfs_data.cpio.bz2 initramfs_da=
ta.cpio.lzma initramfs_data.cpio.xz initramfs_data.cpio.lzo initramfs_data.=
cpio
> +targets :=3D initramfs_data.cpio.gz initramfs_data.cpio.bz2 \
> +	initramfs_data.cpio.lzma initramfs_data.cpio.xz \
> +	initramfs_data.cpio.lzo initramfs_data.cpio.lz4 \
> +	initramfs_data.cpio
>  # do not try to update files included in initramfs
>  $(deps_initramfs): ;
> =20
> @@ -66,4 +72,3 @@ $(deps_initramfs): klibcdirs
>  $(obj)/initramfs_data.cpio$(suffix_y): $(obj)/gen_init_cpio $(deps_initr=
amfs) klibcdirs
>  	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/.initramfs_data.cpio.d
>  	$(call if_changed,initfs)
> -
> --=20
> 1.8.3.1
>=20


--JyUo+2rKuw1VKSUr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlKoiNIACgkQgtp0PDeOcDrSkACfY81WRw2Z34J1gJaG66WUL512
5GcAnRj/1WD7EuB0cAgZ+SdrHD2cmqZQ
=vMQ8
-----END PGP SIGNATURE-----

--JyUo+2rKuw1VKSUr--
