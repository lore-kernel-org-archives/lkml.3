Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaESIVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:21:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49310 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752985AbaESIV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:21:29 -0400
Date: Mon, 19 May 2014 10:17:42 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexander Bersenev <bay@hackerdom.ru>
Cc: linux-sunxi@googlegroups.com, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rdunlap@infradead.org, robh+dt@kernel.org,
        sean@mess.org, srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v7 2/3] [media] rc: add sunxi-ir driver
Message-ID: <20140519081742.GC29466@lukather>
References: <1400104602-16431-1-git-send-email-bay@hackerdom.ru>
 <1400104602-16431-3-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <1400104602-16431-3-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I missed a few things in my first review.

On Thu, May 15, 2014 at 03:56:41AM +0600, Alexander Bersenev wrote:
> This patch adds driver for sunxi IR controller.
> It is based on Alexsey Shestacov's work based on the original driver
> supplied by Allwinner.
>=20
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
> ---
>  drivers/media/rc/Kconfig     |  10 ++
>  drivers/media/rc/Makefile    |   1 +
>  drivers/media/rc/sunxi-cir.c | 334 +++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 345 insertions(+)
>  create mode 100644 drivers/media/rc/sunxi-cir.c
>=20
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 8fbd377..9427fad 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -343,4 +343,14 @@ config RC_ST
> =20
>  	 If you're not sure, select N here.
> =20
> +config IR_SUNXI
> +    tristate "SUNXI IR remote control"
> +    depends on RC_CORE
> +    depends on ARCH_SUNXI
> +    ---help---
> +      Say Y if you want to use sunXi internal IR Controller
> +
> +      To compile this driver as a module, choose M here: the module will
> +      be called sunxi-ir.
> +
>  endif #RC_DEVICES
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index f8b54ff..9ee9ee7 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -32,4 +32,5 @@ obj-$(CONFIG_IR_GPIO_CIR) +=3D gpio-ir-recv.o
>  obj-$(CONFIG_IR_IGUANA) +=3D iguanair.o
>  obj-$(CONFIG_IR_TTUSBIR) +=3D ttusbir.o
>  obj-$(CONFIG_RC_ST) +=3D st_rc.o
> +obj-$(CONFIG_IR_SUNXI) +=3D sunxi-cir.o
>  obj-$(CONFIG_IR_IMG) +=3D img-ir/
> diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
> new file mode 100644
> index 0000000..25eb175
> --- /dev/null
> +++ b/drivers/media/rc/sunxi-cir.c
> @@ -0,0 +1,334 @@
> +/*
> + * Driver for Allwinner sunXi IR controller
> + *
> + * Copyright (C) 2014 Alexsey Shestacov <wingrime@linux-sunxi.org>
> + * Copyright (C) 2014 Alexander Bersenev <bay@hackerdom.ru>
> + *
> + * Based on sun5i-ir.c:
> + * Copyright (C) 2007-2012 Daniel Wang
> + * Allwinner Technology Co., Ltd. <www.allwinnertech.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +#include <media/rc-core.h>
> +
> +#define SUNXI_IR_DEV "sunxi-ir"
> +
> +/* Registers */
> +/* IR Control */
> +#define SUNXI_IR_CTL_REG      0x00
> +/* Rx Config */
> +#define SUNXI_IR_RXCTL_REG    0x10
> +/* Rx Data */
> +#define SUNXI_IR_RXFIFO_REG   0x20
> +/* Rx Interrupt Enable */
> +#define SUNXI_IR_RXINT_REG    0x2C
> +/* Rx Interrupt Status */
> +#define SUNXI_IR_RXSTA_REG    0x30
> +/* IR Sample Config */
> +#define SUNXI_IR_CIR_REG      0x34
> +
> +/* Global Enable for IR_CTL Register */
> +#define REG_CTL_GEN           BIT(0)
> +/* RX block enable for IR_CTL Register */
> +#define REG_CTL_RXEN          BIT(1)
> +/* CIR mode for IR_CTL Register */
> +#define REG_CTL_MD            (BIT(4)|BIT(5))

I usually prefer to have the bits definition declared just below the
defininition of the register itself, something like:

#define SUNXI_CTRL_REG		0x00
#define SUNXI_CTRL_EN			BIT(0)
#define SUNXI_CTRL_RXEN			BIT(1)

etc...

It's easier to read and avoids the comments to say in which register
each bit belongs.

> +/* IR_RXCTL_REG Register Receiver Pulse Polarity Invert flag */
> +#define REG_RXCTL_RPPI        BIT(2)
> +
> +/* IR_RXINT_REG Register fields */
> +#define REG_RXINT_ROI_EN      BIT(0) /* Rx FIFO Overflow */
> +#define REG_RXINT_RPEI_EN     BIT(1) /* Rx Packet End */
> +#define REG_RXINT_RAI_EN      BIT(4) /* Rx FIFO Data Available */
> +/* Rx FIFO available byte level */
> +#define REG_RXINT_RAL__MASK   (BIT(8)|BIT(9)|BIT(10)|BIT(11))
> +#define REG_RXINT_RAL__SHIFT  8
> +static inline uint32_t REG_RXINT_RAL(uint16_t val)
> +{
> +	return (val << REG_RXINT_RAL__SHIFT) & REG_RXINT_RAL__MASK;
> +}

This should be turned either in a macro if you want to keep the upper
case name, or have a lower case name if you want to keep it as a
function.

In both cases, you don't want your function to be declared in the
middle of your defines.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTeb4mAAoJEBx+YmzsjxAgVq8P/3T4CdZJsE0akcQeUP/5Wh1P
M9nL2mNyBAZHC8VDFVJHFyGBATwspRzR0MRvp1t1hZz61D+0ErcUoQfgfrysjcVK
XqQKFMG99tl24jA1WjioiHC7QesudKuJ6l1WGxHQcfJTfSSiAJSw4lHWImorDbo6
UpnTUF4LA1DiWctrUSaOH2O6jG2VHEJT59KpG84ToBaB3XE52IBShPEEsqUdLGyz
Z+B0mFYe8m+pB/1UH23+4LEHMoVsysGABfy3/J6EPyvhRYITJqcxbPnfeS5qg854
jubQAEB2lmHEirywkRxwsvhfeXZXloIlCeFB/jY/3D5Za2y5rhQ/Ovt+ImYssG+z
eY6uOfDrfYHqNNdX0gpb3O68eckkvm4GwRl5KkKgy5+23sBR0c4HqLZVzUJL0chB
XV13QgGK1IMASURDvgOSPXZCsc2NWIKOpUosAVz7sYx/4NcXmAY2gHKIlKanh0QQ
qTKpsvLb1LUMewAknKxu/7euGNxcqF+q6GFB95iL8dPCa0l0Z5z6Ah9LJov4CbsW
pQ+2qZs2gttupwN88Udej7FvLMdgjdL1ThtUKXldZMIEmqDIz0Ps2W/JAfgwSjtK
IXuM6SukCees+BtWqiyqqYArdXxJxPS2j0Ev1xHmBlDcem8tBu9FGiC4J1rhlWb5
zUVedwFRQZHj1cDMmKRb
=tPhT
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
