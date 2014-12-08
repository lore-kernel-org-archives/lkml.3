Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaLHRlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:41:22 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:42558 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbaLHRlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:41:20 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Mon, 08 Dec 2014 17:41:18 +0000
Message-ID: <5485E2BC.4050001@imgtec.com>
Date: Mon, 8 Dec 2014 17:41:16 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Sifan Naeem <sifan.naeem@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>
Subject: Re: [PATCH 4/5] rc: img-ir: add philips rc5 decoder module
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com> <1417707523-7730-5-git-send-email-sifan.naeem@imgtec.com>
In-Reply-To: <1417707523-7730-5-git-send-email-sifan.naeem@imgtec.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="jXDl2IuiX3Q2AA1JwsbrlJ08ax0wmAK89"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: b93fcccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jXDl2IuiX3Q2AA1JwsbrlJ08ax0wmAK89
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/12/14 15:38, Sifan Naeem wrote:
> Add img-ir module for decoding Philips rc5 protocol.
>=20
> Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
> ---
>  drivers/media/rc/img-ir/Kconfig      |    7 +++
>  drivers/media/rc/img-ir/Makefile     |    1 +
>  drivers/media/rc/img-ir/img-ir-hw.c  |    3 ++
>  drivers/media/rc/img-ir/img-ir-hw.h  |    1 +
>  drivers/media/rc/img-ir/img-ir-rc5.c |   88 ++++++++++++++++++++++++++=
++++++++
>  5 files changed, 100 insertions(+)
>  create mode 100644 drivers/media/rc/img-ir/img-ir-rc5.c
>=20
> diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/=
Kconfig
> index 03ba9fc..b5b114f 100644
> --- a/drivers/media/rc/img-ir/Kconfig
> +++ b/drivers/media/rc/img-ir/Kconfig
> @@ -59,3 +59,10 @@ config IR_IMG_SANYO
>  	help
>  	   Say Y here to enable support for the Sanyo protocol (used by Sanyo=
,
>  	   Aiwa, Chinon remotes) in the ImgTec infrared decoder block.
> +
> +config IR_IMG_RC5
> +	bool "Phillips RC5 protocol support"

I think that should be "Philips" (if wikipedia is anything to go by).

Same elsewhere in this patch and patch 5.

Other than that,
Acked-by: James Hogan <james.hogan@imgtec.com>

(Note, I don't have RC-5/RC-6 capable hardware yet so can't test this
support)

Thanks
James

> +	depends on IR_IMG_HW
> +	help
> +	   Say Y here to enable support for the RC5 protocol in the ImgTec
> +	   infrared decoder block.
> diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir=
/Makefile
> index 92a459d..898b1b8 100644
> --- a/drivers/media/rc/img-ir/Makefile
> +++ b/drivers/media/rc/img-ir/Makefile
> @@ -6,6 +6,7 @@ img-ir-$(CONFIG_IR_IMG_JVC)	+=3D img-ir-jvc.o
>  img-ir-$(CONFIG_IR_IMG_SONY)	+=3D img-ir-sony.o
>  img-ir-$(CONFIG_IR_IMG_SHARP)	+=3D img-ir-sharp.o
>  img-ir-$(CONFIG_IR_IMG_SANYO)	+=3D img-ir-sanyo.o
> +img-ir-$(CONFIG_IR_IMG_RC5)	+=3D img-ir-rc5.o
>  img-ir-objs			:=3D $(img-ir-y)
> =20
>  obj-$(CONFIG_IR_IMG)		+=3D img-ir.o
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img=
-ir/img-ir-hw.c
> index a977467..322cdf8 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -42,6 +42,9 @@ static struct img_ir_decoder *img_ir_decoders[] =3D {=

>  #ifdef CONFIG_IR_IMG_SANYO
>  	&img_ir_sanyo,
>  #endif
> +#ifdef CONFIG_IR_IMG_RC5
> +	&img_ir_rc5,
> +#endif
>  	NULL
>  };
> =20
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img=
-ir/img-ir-hw.h
> index 8578aa7..f124ec5 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.h
> +++ b/drivers/media/rc/img-ir/img-ir-hw.h
> @@ -187,6 +187,7 @@ extern struct img_ir_decoder img_ir_jvc;
>  extern struct img_ir_decoder img_ir_sony;
>  extern struct img_ir_decoder img_ir_sharp;
>  extern struct img_ir_decoder img_ir_sanyo;
> +extern struct img_ir_decoder img_ir_rc5;
> =20
>  /**
>   * struct img_ir_reg_timings - Reg values for decoder timings at clock=
 rate.
> diff --git a/drivers/media/rc/img-ir/img-ir-rc5.c b/drivers/media/rc/im=
g-ir/img-ir-rc5.c
> new file mode 100644
> index 0000000..e1a0829
> --- /dev/null
> +++ b/drivers/media/rc/img-ir/img-ir-rc5.c
> @@ -0,0 +1,88 @@
> +/*
> + * ImgTec IR Decoder setup for Phillips RC-5 protocol.
> + *
> + * Copyright 2012-2014 Imagination Technologies Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y the
> + * Free Software Foundation; either version 2 of the License, or (at y=
our
> + * option) any later version.
> + */
> +
> +#include "img-ir-hw.h"
> +
> +/* Convert RC5 data to a scancode */
> +static int img_ir_rc5_scancode(int len, u64 raw, u64 enabled_protocols=
,
> +				struct img_ir_scancode_req *request)
> +{
> +	unsigned int addr, cmd, tgl, start;
> +
> +	/* Quirk in the decoder shifts everything by 2 to the left. */
> +	raw   >>=3D 2;
> +
> +	start	=3D  (raw >> 13)	& 0x01;
> +	tgl	=3D  (raw >> 11)	& 0x01;
> +	addr	=3D  (raw >>  6)	& 0x1f;
> +	cmd	=3D   raw		& 0x3f;
> +	/*
> +	 * 12th bit is used to extend the command in extended RC5 and has
> +	 * no effect on standard RC5.
> +	 */
> +	cmd	+=3D ((raw >> 12) & 0x01) ? 0 : 0x40;
> +
> +	if (!start)
> +		return -EINVAL;
> +
> +	request->protocol =3D RC_TYPE_RC5;
> +	request->scancode =3D addr << 8 | cmd;
> +	request->toggle   =3D tgl;
> +	return IMG_IR_SCANCODE;
> +}
> +
> +/* Convert RC5 scancode to RC5 data filter */
> +static int img_ir_rc5_filter(const struct rc_scancode_filter *in,
> +				 struct img_ir_filter *out, u64 protocols)
> +{
> +	/* Not supported by the hw. */
> +	return -EINVAL;
> +}
> +
> +/*
> + * RC-5 decoder
> + * see http://www.sbprojects.com/knowledge/ir/rc5.php
> + */
> +struct img_ir_decoder img_ir_rc5 =3D {
> +	.type      =3D RC_BIT_RC5,
> +	.control   =3D {
> +		.bitoriend2	=3D 1,
> +		.code_type	=3D IMG_IR_CODETYPE_BIPHASE,
> +		.decodend2	=3D 1,
> +	},
> +	/* main timings */
> +	.tolerance	=3D 16,
> +	.unit		=3D 888888, /* 1/36k*32=3D888.888microseconds */
> +	.timings	=3D {
> +		/* 10 symbol */
> +		.s10 =3D {
> +			.pulse	=3D { 1 },
> +			.space	=3D { 1 },
> +		},
> +
> +		/* 11 symbol */
> +		.s11 =3D {
> +			.pulse	=3D { 1 },
> +			.space	=3D { 1 },
> +		},
> +
> +		/* free time */
> +		.ft  =3D {
> +			.minlen =3D 14,
> +			.maxlen =3D 14,
> +			.ft_min =3D 5,
> +		},
> +	},
> +
> +	/* scancode logic */
> +	.scancode	=3D img_ir_rc5_scancode,
> +	.filter		=3D img_ir_rc5_filter,
> +};
>=20


--jXDl2IuiX3Q2AA1JwsbrlJ08ax0wmAK89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUheK8AAoJEGwLaZPeOHZ6yUYQAKwrD5cWcPaANx/XRVcq8ctU
FRHndU7EJhyU4ZH04Db8SUhV7ya20UzjYgn1HS5LWvxRllAUHD7vB+4YhwV41OPR
uKngGT6tKOuEWBR1B9p7q8ETg22FIA0exkmeW6dkzbk+HLnHQw4kGqx5E8tHkGpE
DP6NfcoPIZkAPDkPBvfVMlLgFEwdqjUIIGfW0WqaogMd/w8/bF7TR6McfzEZ2ix+
SeGySJv+CtThYYPb2AsR+QvmbfIORSw19ReuI961CeOzOWqOzOes1tOXs89ZctFb
dBVNGdDmb3poTkr3ZXacA2vSyXq0aik3MNVIMaTtyeT6WyL5l890naxG21CFE5GD
h3PXIFx4Z8+CdJDshEQO0EJyrKD2mMrzzzj/ZyXPbFvZoQst5naF+6buTQbKVcTR
67KMPMIhdc796N1qqDGNLHTGMyh1In6rcPphRCofmDEj8KGLGa06WmiYblJPwnCL
jztFoaH/jsFHRHMvVXE8pBDj6wmifuzysnisrO4tdoypd9j590E+g7wpljjtwbsm
yCFobwZizQgXxptFGIzQYlASQhkFDOFyaWgmJaQgnqVFvfXOuANJyMvQkVB/NcQ/
U8NCOeiotvaLH1rgTKEQX56AiiTquu/97kVacHICW3uqwZH2o+Q/fjufWg/DDjqv
Yp4OfESUl0KO4jSGetuW
=f060
-----END PGP SIGNATURE-----

--jXDl2IuiX3Q2AA1JwsbrlJ08ax0wmAK89--
