Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3BCGRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 01:17:30 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48428 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab3BCGR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 01:17:28 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 1/1] depmod: pass -P $CONFIG_SYMBOL_PREFIX
Date: Sun, 3 Feb 2013 01:17:24 -0500
User-Agent: KMail/1.13.7 (Linux/3.7.1; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org,
        "Yoshinori Sato" <ysato@users.sourceforge.jp>,
        uclinux-dist-devel@blackfin.uclinux.org
References: <1359625303-11842-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1359625303-11842-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16008169.e9eXTBbLJr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302030117.26295.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16008169.e9eXTBbLJr
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 31 January 2013 04:41:43 James Hogan wrote:
> --- a/Makefile
> +++ b/Makefile
>=20
> +ifneq ($(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX)),)
> +  depmod_args =3D -P $(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
> +endif
> ...
>  # Run depmod only if we have System.map and depmod is executable
>  quiet_cmd_depmod =3D DEPMOD  $(KERNELRELEASE)
>        cmd_depmod =3D $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPM=
OD) \
> -                   $(KERNELRELEASE)
> +                   $(KERNELRELEASE) $(depmod_args)

scripts/Makefile.lib just does:
	ifdef CONFIG_SYMBOL_PREFIX
so you should do the same

that said, cmd_depmod is just a shell command.  and you're running another=
=20
script helper (depmod.sh).  how about passing it unconditionally ?
	cmd_depmod =3D ... -P "$(CONFIG_SYMBOL_PREFIX)"

since the default will be "no prefix", using -P "" is the same thing.

> --- a/scripts/depmod.sh
> +++ b/scripts/depmod.sh
>=20
>  DEPMOD=3D$1
> -KERNELRELEASE=3D$2
> +shift
> +KERNELRELEASE=3D$1
> +shift

you can do:
	DEPMOD=3D$1
	KERNELRELEASE=3D$2
	shift 2

> +# older versions of depmod don't support -P <symbol-prefix>
> +# support was added in module-init-tools 3.13
> +if test "$1" =3D "-P"; then
> +	release=3D$("$DEPMOD" --version)
> +	package=3D$(echo "$release" | cut -d' ' -f 1)
> +	if test "$package" =3D "module-init-tools"; then
> +		version=3D$(echo "$release" | cut -d' ' -f 2)
> +		later=3D$({ echo "$version"; echo "3.13"; } | sort -V | tail -n 1)

you could do instead:
	later=3D$(printf '%s\n' "$version" "3.13" | sort -V | tail -n 1)

> +		if test "$later" !=3D "$version"; then
> +			# module-init-tools < 3.13, drop the next 2 args
> +			shift
> +			shift
> +		fi

shift 2
=2Dmike

--nextPart16008169.e9eXTBbLJr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJRDgD2AAoJEEFjO5/oN/WBSeUQAM59Ar/tZ/W/DjUqslEnFpFI
7O4xsHCFW9sUP+4w9T3UEipI8PVgXfJZ6EnfU9v3/QRL9jgMqxcEdHeie+3YCSqN
37TeP5En12rqYim3a+ynF55QYo0yFd2s/azD9SBD6Q966aD+mv94euO28skZl0zF
XW3yX/zGjnxl7ikLWOrNRX5/x413prD1D/wZhhMQScFRkpMRAKfOkWPksiNm02Y5
j5scfpYmQc8fJYrCBFobCMWDpIeDevfGWkm5v2Bw7b2qgKeg4a9jCH3lS1GB/qL/
tDIuAZrR6vYu6H83g81afP76ZnKiY4bMafeUuMaJrWD5yJO2q0t2x1q6aR2C3Rhc
SwhyeLHnKegwIJNAqVcoJHbm4q4R6B11ipG2TuNV4e+JJZgTteeIloYUJp762gyz
XaYtbhKYXII2wrwq2UhDbsiRPg4Qo79OqgYBSLSrTkBm5PjwH411HxoMeQtLGEdG
QttVlKzH3ZgDfPtBKuv1Hio2fhUAa4jmYhfd4IeBPPEkeDHPdzRzBO1V7fYaZwxp
h0g/LfbjYy3/nn7GtWH7BdDR3hVUKyCkZqmKMAFLxd35eAXjag/I6Bnpq7It7ZRy
1jIjF3Wa7q6J4IVuWHUIrTMDt5hYfSzxf3OzqEqN6p3+LuW5K0tBxrG+M12eUGER
j9miftJvEMfeWb3SoiQB
=n6PJ
-----END PGP SIGNATURE-----

--nextPart16008169.e9eXTBbLJr--
