Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaD1TPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:15:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51842 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754817AbaD1TPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:15:07 -0400
Date: Mon, 28 Apr 2014 12:10:24 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/7] pwm: Add Allwinner SoC support
Message-ID: <20140428191024.GB3134@lukather>
References: <1398701834-3719-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1398701834-3719-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <1398701834-3719-2-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 28, 2014 at 06:17:08PM +0200, Alexandre Belloni wrote:
> This adds a generic PWM framework driver for the PWM controller
> found on Allwinner SoCs.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/pwm/Kconfig     |   9 ++
>  drivers/pwm/Makefile    |   1 +
>  drivers/pwm/pwm-sunxi.c | 345 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 355 insertions(+)
>  create mode 100644 drivers/pwm/pwm-sunxi.c
>=20
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 5b34ff29ea38..178b017be827 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -217,6 +217,15 @@ config PWM_SPEAR
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-spear.
> =20
> +config PWM_SUNXI
> +	tristate "Allwinner PWM support"
> +	depends on ARCH_SUNXI || COMPILE_TEST
> +	help
> +	  Generic PWM framework driver for Allwinner SoCs.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-sunxi.
> +
>  config PWM_TEGRA
>  	tristate "NVIDIA Tegra PWM support"
>  	depends on ARCH_TEGRA
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index e57d2c38a794..39997ea2e276 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_PWM_PXA)		+=3D pwm-pxa.o
>  obj-$(CONFIG_PWM_RENESAS_TPU)	+=3D pwm-renesas-tpu.o
>  obj-$(CONFIG_PWM_SAMSUNG)	+=3D pwm-samsung.o
>  obj-$(CONFIG_PWM_SPEAR)		+=3D pwm-spear.o
> +obj-$(CONFIG_PWM_SUNXI)		+=3D pwm-sunxi.o
>  obj-$(CONFIG_PWM_TEGRA)		+=3D pwm-tegra.o
>  obj-$(CONFIG_PWM_TIECAP)	+=3D pwm-tiecap.o
>  obj-$(CONFIG_PWM_TIEHRPWM)	+=3D pwm-tiehrpwm.o
> diff --git a/drivers/pwm/pwm-sunxi.c b/drivers/pwm/pwm-sunxi.c
> new file mode 100644
> index 000000000000..0f2d65e8976b
> --- /dev/null
> +++ b/drivers/pwm/pwm-sunxi.c
> @@ -0,0 +1,345 @@
> +/*
> + * Driver for Allwinner Pulse Width Modulation Controller
> + *
> + * Copyright (C) 2014 Alexandre Belloni <alexandre.belloni@free-electron=
s.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +
> +#define PWM_CTRL_REG		0x0
> +
> +#define PWM_CH_PRD_BASE		0x4
> +#define PWM_CH_PRD_OFF		0x4
> +#define PWM_CH_PRD(x)		(PWM_CH_PRD_BASE + PWM_CH_PRD_OFF * (x))
> +
> +#define PWMCH_OFFSET		15
> +#define PWM_PRESCAL_MASK	GENMASK(3,0)
> +#define PWM_PRESCAL_OFF		0
> +#define PWM_EN			BIT(4)
> +#define PWM_ACT_STATE		BIT(5)
> +#define PWM_CLK_GATING		BIT(6)
> +#define PWM_MODE		BIT(7)
> +#define PWM_PULSE		BIT(8)
> +#define PWM_BYPASS		BIT(9)
> +
> +#define PWM_RDY_BASE		28
> +#define PWM_RDY_OFF		1
> +#define PWM_RDY(x)		BIT(PWM_RDY_BASE + PWM_RDY_OFF * (x))
> +
> +#define PWM_PRD_ACT_MASK	0xFF
> +#define PWM_PRD(x)		((x - 1) << 16)
> +#define PWM_PRD_MASK		0xFF
> +
> +#define	BIT_CH(bit, chan)	(bit << (chan * PWMCH_OFFSET))
> +
> +u32 prescal_table[] =3D { 120, 180, 240, 360, 480, 0, 0, 0,
> +			12000, 24000, 36000, 48000, 72000,
> +			0, 0, 1 };
> +
> +struct sunxi_pwm_data {
> +	bool has_rdy;
> +};
> +
> +struct sunxi_pwm_chip {
> +	struct pwm_chip chip;
> +	struct clk *clk;
> +	void __iomem *base;
> +	struct mutex ctrl_lock;
> +	const struct sunxi_pwm_data *data;
> +};
> +
> +#define to_sunxi_pwm_chip(chip) container_of(chip, struct sunxi_pwm_chip=
, chip)
> +
> +static inline u32 sunxi_pwm_readl(struct sunxi_pwm_chip *chip,
> +				  unsigned long offset)
> +{
> +	return readl_relaxed(chip->base + offset);
> +}
> +
> +static inline void sunxi_pwm_writel(struct sunxi_pwm_chip *chip,
> +				    unsigned long offset, unsigned long val)
> +{
> +	writel_relaxed(val, chip->base + offset);

Actually, this won't work with COMPILE_TEST, since the *_relaxed
functions are not defined for all the architectures.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTXqefAAoJEBx+YmzsjxAgN0IQAJ5i3yYllHpuBq91DLkGvw2P
d8ADQPIRjjkgVeGGqRpzJCRQfvWrcTDQ+E0vuoGy8AbSSd3/jbsA1qhVvLsOnzjF
R255jBgTjvfdvHIudJbStp1reazhvH914KUtbySPZBp+lsy2msdFq1WkNLZybBCL
gRSdpoURFkAQ3soh2Wnmi3wb/hTl09VIZP3R9kZzOrjZsRNaX8nukQOaNbYistol
01lfI+9h2eb6p5CgCHpmSIWYlOsZVRvlGm4PrwdkPpWsPBuK2WLYvNDUjRDGPYz1
Xz0aMd+Vn/0PtAagVvI54VMXVpq+TDHGxt6qm6FXwxRRYKZlsv4Gogbm81QQ/eBP
4Z85tUDN8P2RYuQWrnJ4SEpu1kR0WIm6kx05d9AX/K+15cRdazQczkLzUx6/siA+
dqtv8GVLmgvNeVmuOo2EpBTmEep9GVqNkAldIe+++8Kdlm8AnnfSVs7wg4/XpPnE
1iTKE+orJhk2kcJ5UKAR9chCCUaEb2OUVotJS1YWOdcM0b5LARJhxAEcOWwX+b0s
yksRyx+i1ZMQSWS17/4znXjMkJ9ghdEW6HNR8RMINE0ecskRLOMB3L10HdmzMTIn
hC2EaCBsZsoeSHmEhc/IcUCNaXQ/RCQyF7da/qzHNO8IgaO8Xl4W8NgITjICSGzz
cW/QzsJf8eaDEVr1CIwl
=WWWO
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
