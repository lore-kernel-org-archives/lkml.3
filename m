Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaLHRpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:45:22 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:45809 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750980AbaLHRpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:45:21 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Mon, 08 Dec 2014 17:45:18 +0000
Message-ID: <5485E3AE.5070200@imgtec.com>
Date: Mon, 8 Dec 2014 17:45:18 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Sifan Naeem <sifan.naeem@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>
Subject: Re: [PATCH 5/5] rc: img-ir: add philips rc6 decoder module
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com> <1417707523-7730-6-git-send-email-sifan.naeem@imgtec.com>
In-Reply-To: <1417707523-7730-6-git-send-email-sifan.naeem@imgtec.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="9lbQqbOvsIgC5KUPOwqlKuthsvGMSUKOJ"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: da4c5968
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9lbQqbOvsIgC5KUPOwqlKuthsvGMSUKOJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/12/14 15:38, Sifan Naeem wrote:
> Add img-ir module for decoding Philips rc6 protocol.
>=20
> Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>

Aside from the "Philips" thing:

Acked-by: James Hogan <james.hogan@imgtec.com>

(It's unpleasant having unexplained timings for RC-6, but it's better
than no RC-6 support, and hopefully in the future it can be improved).

Cheers
James

> ---
>  drivers/media/rc/img-ir/Kconfig      |    8 +++
>  drivers/media/rc/img-ir/Makefile     |    1 +
>  drivers/media/rc/img-ir/img-ir-hw.c  |    3 +
>  drivers/media/rc/img-ir/img-ir-hw.h  |    1 +
>  drivers/media/rc/img-ir/img-ir-rc6.c |  117 ++++++++++++++++++++++++++=
++++++++
>  5 files changed, 130 insertions(+)
>  create mode 100644 drivers/media/rc/img-ir/img-ir-rc6.c
>=20
> diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/=
Kconfig
> index b5b114f..4d3fca9 100644
> --- a/drivers/media/rc/img-ir/Kconfig
> +++ b/drivers/media/rc/img-ir/Kconfig
> @@ -66,3 +66,11 @@ config IR_IMG_RC5
>  	help
>  	   Say Y here to enable support for the RC5 protocol in the ImgTec
>  	   infrared decoder block.
> +
> +config IR_IMG_RC6
> +	bool "Phillips RC6 protocol support"
> +	depends on IR_IMG_HW
> +	help
> +	   Say Y here to enable support for the RC6 protocol in the ImgTec
> +	   infrared decoder block.
> +	   Note: This version only supports mode 0.
> diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir=
/Makefile
> index 898b1b8..8e6d458 100644
> --- a/drivers/media/rc/img-ir/Makefile
> +++ b/drivers/media/rc/img-ir/Makefile
> @@ -7,6 +7,7 @@ img-ir-$(CONFIG_IR_IMG_SONY)	+=3D img-ir-sony.o
>  img-ir-$(CONFIG_IR_IMG_SHARP)	+=3D img-ir-sharp.o
>  img-ir-$(CONFIG_IR_IMG_SANYO)	+=3D img-ir-sanyo.o
>  img-ir-$(CONFIG_IR_IMG_RC5)	+=3D img-ir-rc5.o
> +img-ir-$(CONFIG_IR_IMG_RC6)	+=3D img-ir-rc6.o
>  img-ir-objs			:=3D $(img-ir-y)
> =20
>  obj-$(CONFIG_IR_IMG)		+=3D img-ir.o
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img=
-ir/img-ir-hw.c
> index 322cdf8..3b70dc2 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -45,6 +45,9 @@ static struct img_ir_decoder *img_ir_decoders[] =3D {=

>  #ifdef CONFIG_IR_IMG_RC5
>  	&img_ir_rc5,
>  #endif
> +#ifdef CONFIG_IR_IMG_RC6
> +	&img_ir_rc6,
> +#endif
>  	NULL
>  };
> =20
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img=
-ir/img-ir-hw.h
> index f124ec5..c7b6e1a 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.h
> +++ b/drivers/media/rc/img-ir/img-ir-hw.h
> @@ -188,6 +188,7 @@ extern struct img_ir_decoder img_ir_sony;
>  extern struct img_ir_decoder img_ir_sharp;
>  extern struct img_ir_decoder img_ir_sanyo;
>  extern struct img_ir_decoder img_ir_rc5;
> +extern struct img_ir_decoder img_ir_rc6;
> =20
>  /**
>   * struct img_ir_reg_timings - Reg values for decoder timings at clock=
 rate.
> diff --git a/drivers/media/rc/img-ir/img-ir-rc6.c b/drivers/media/rc/im=
g-ir/img-ir-rc6.c
> new file mode 100644
> index 0000000..bcd0822
> --- /dev/null
> +++ b/drivers/media/rc/img-ir/img-ir-rc6.c
> @@ -0,0 +1,117 @@
> +/*
> + * ImgTec IR Decoder setup for Phillips RC-6 protocol.
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
> +/* Convert RC6 data to a scancode */
> +static int img_ir_rc6_scancode(int len, u64 raw, u64 enabled_protocols=
,
> +				struct img_ir_scancode_req *request)
> +{
> +	unsigned int addr, cmd, mode, trl1, trl2;
> +
> +	/*
> +	 * Due to a side effect of the decoder handling the double length
> +	 * Trailer bit, the header information is a bit scrambled, and the
> +	 * raw data is shifted incorrectly.
> +	 * This workaround effectively recovers the header bits.
> +	 *
> +	 * The Header field should look like this:
> +	 *
> +	 * StartBit ModeBit2 ModeBit1 ModeBit0 TrailerBit
> +	 *
> +	 * But what we get is:
> +	 *
> +	 * ModeBit2 ModeBit1 ModeBit0 TrailerBit1 TrailerBit2
> +	 *
> +	 * The start bit is not important to recover the scancode.
> +	 */
> +
> +	raw	>>=3D 27;
> +
> +	trl1	=3D (raw >>  17)	& 0x01;
> +	trl2	=3D (raw >>  16)	& 0x01;
> +
> +	mode	=3D (raw >>  18)	& 0x07;
> +	addr	=3D (raw >>   8)	& 0xff;
> +	cmd	=3D  raw		& 0xff;
> +
> +	/*
> +	 * Due to the above explained irregularity the trailer bits cannot
> +	 * have the same value.
> +	 */
> +	if (trl1 =3D=3D trl2)
> +		return -EINVAL;
> +
> +	/* Only mode 0 supported for now */
> +	if (mode)
> +		return -EINVAL;
> +
> +	request->protocol =3D RC_TYPE_RC6_0;
> +	request->scancode =3D addr << 8 | cmd;
> +	request->toggle	  =3D trl2;
> +	return IMG_IR_SCANCODE;
> +}
> +
> +/* Convert RC6 scancode to RC6 data filter */
> +static int img_ir_rc6_filter(const struct rc_scancode_filter *in,
> +				 struct img_ir_filter *out, u64 protocols)
> +{
> +	/* Not supported by the hw. */
> +	return -EINVAL;
> +}
> +
> +/*
> + * RC-6 decoder
> + * see http://www.sbprojects.com/knowledge/ir/rc6.php
> + */
> +struct img_ir_decoder img_ir_rc6 =3D {
> +	.type		=3D RC_BIT_RC6_0,
> +	.control	=3D {
> +		.bitorien	=3D 1,
> +		.code_type	=3D IMG_IR_CODETYPE_BIPHASE,
> +		.decoden	=3D 1,
> +		.decodinpol	=3D 1,
> +	},
> +	/* main timings */
> +	.tolerance	=3D 20,
> +	/*
> +	 * Due to a quirk in the img-ir decoder, default header values do
> +	 * not work, the values described below were extracted from
> +	 * successful RTL test cases.
> +	 */
> +	.timings	=3D {
> +		/* leader symbol */
> +		.ldr =3D {
> +			.pulse	=3D { 650 },
> +			.space	=3D { 660 },
> +		},
> +		/* 0 symbol */
> +		.s00 =3D {
> +			.pulse	=3D { 370 },
> +			.space	=3D { 370 },
> +		},
> +		/* 01 symbol */
> +		.s01 =3D {
> +			.pulse	=3D { 370 },
> +			.space	=3D { 370 },
> +		},
> +		/* free time */
> +		.ft  =3D {
> +			.minlen =3D 21,
> +			.maxlen =3D 21,
> +			.ft_min =3D 2666,	/* 2.666 ms */
> +		},
> +	},
> +
> +	/* scancode logic */
> +	.scancode	=3D img_ir_rc6_scancode,
> +	.filter		=3D img_ir_rc6_filter,
> +};
>=20


--9lbQqbOvsIgC5KUPOwqlKuthsvGMSUKOJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUheOuAAoJEGwLaZPeOHZ6AR4P/0p6AVjVOidT5NxKkyGNZMAm
33NrktQ2NdOKAhVvucsTMiC4oYIq+CuiIU/fAKQ8VwLvUsmdCmF8XnTiEyqZIBNe
HdZ5e9e06sQjxEtM/eVZnVtsDbs66EXDlwM2b6zP0jbH7MzT1LHgZvDhWulv0buH
skqb8D5wkAzzBsHBLt9xNNN9vvNZfdwcsD0M7qRrei+zmFjZq89jR3EhQT+EYh2i
nFiiA/uQgqZJ4yFOKIFUWab794w7HdTzpAVbi4z/zpTB0NkJGCOK0NZ3HzF/QO24
WuP7bBWZJUIYWmAzNPZlYKhwUtT0NNZcmWQysCpKAGlPeObFpo3mLQ3F7BoAm2Bm
v0lX+rwG7U1pCCiJyb4WaGH/tve7rIMAvu+IGePIg4m70BCmzgi20Ad1+TUullSn
oDAGjl0NtL1dBewhonvnW4U14kaG7N1D+z6HGtnORHRDtYqVG8ZhmTaHaHkiH1fL
0uoNs4u+aF/VGLjqFNZwvvQDc1jyqPwCAfa5ZFdYWFAf7hRDTMyV1VsOVZ57rlXJ
fqUXD4jo9ycmesnym6Rrv4XspsbKynNwL1jK6NekA12zrRy1BfUGBTTi8Hs+YRU5
uk5dM+oxSC487SMFaH5fCYtD33Y3BalXPMysM4SKOUmn+RuuYe267UOnqeM+9gmg
36emkwr88WcwsAtQOgnF
=y0fq
-----END PGP SIGNATURE-----

--9lbQqbOvsIgC5KUPOwqlKuthsvGMSUKOJ--
