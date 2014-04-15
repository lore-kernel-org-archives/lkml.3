Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaDOMAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:00:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39924 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750790AbaDOMAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:00:07 -0400
Date: Tue, 15 Apr 2014 13:56:23 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/7] pwm: Add Allwinner SoC support
Message-ID: <20140415115623.GC3207@lukather>
References: <1397337959-12408-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1397337959-12408-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Content-Disposition: inline
In-Reply-To: <1397337959-12408-2-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 12, 2014 at 11:25:53PM +0200, Alexandre Belloni wrote:
> This adds a generic PWM framework driver for the PWM controller
> found on Allwinner SoCs.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/pwm/Kconfig     |   9 ++
>  drivers/pwm/Makefile    |   1 +
>  drivers/pwm/pwm-sunxi.c | 345 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 355 insertions(+)
>  create mode 100644 drivers/pwm/pwm-sunxi.c
>=20
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 5b34ff29ea38..32d6f77304f1 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -217,6 +217,15 @@ config PWM_SPEAR
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-spear.
> =20
> +config PWM_SUNXI
> +	tristate "Allwinner PWM support"
> +	depends on ARCH_SUNXI

Can you make it depend on COMPILE_TEST here?

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
> index 000000000000..6d6cbd9a55a7
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
> +#define PWM_CH_PRD(x)		(PWM_CH_PRD_BASE + PWM_CH_PRD_OFF * x)

Just to be safe, you can probably wrap x in brackets.

> +
> +#define PWMCH_OFFSET		15
> +#define PWM_PRESCAL_MASK	0xF

GENMASK?

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
> +#define PWM_RDY(x)		BIT(PWM_RDY_BASE + PWM_RDY_OFF * x)

Ditto.

> +#define PWM_PRD_ACT_MASK	0xFF
> +#define PWM_PRD(x)		((x - 1) << 16)

BIT_WORD?

> +#define PWM_PRD_MASK		0xFF
> +
> +#define	BIT_CH(bit, chan)	(bit << (chan * PWMCH_OFFSET))

Ditto.

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
> +}
> +
> +static int sunxi_pwm_config(struct pwm_chip *chip, struct pwm_device *pw=
m,
> +			    int duty_ns, int period_ns)
> +{
> +	struct sunxi_pwm_chip *sunxi_pwm =3D to_sunxi_pwm_chip(chip);
> +	u32 clk_rate, prd, dty;
> +	u64 div;
> +	u32 val, clk_gate;
> +	int i, ret;
> +
> +	clk_rate =3D clk_get_rate(sunxi_pwm->clk);
> +
> +	/* First, test without any divider */
> +	i =3D PWM_PRESCAL_MASK;
> +	div =3D clk_rate * period_ns;
> +	do_div(div, 1000000000);
> +	if (div > PWM_PRD_MASK) {
> +		/* Then go up from the first divider */
> +		for (i =3D 0; i < PWM_PRESCAL_MASK; i++) {
> +			if (!prescal_table[i])
> +				continue;
> +			div =3D clk_rate / prescal_table[i];
> +			div =3D div * period_ns;
> +			do_div(div, 1000000000);
> +			if (div <=3D PWM_PRD_MASK)
> +				break;
> +		}
> +	}
> +
> +	if (div > PWM_PRD_MASK) {
> +		dev_err(chip->dev, "prescaler exceeds the maximum value\n");
> +		return -EINVAL;
> +	}
> +
> +	prd =3D div;
> +	div *=3D duty_ns;
> +	do_div(div, period_ns);
> +	dty =3D div;
> +
> +	ret =3D clk_enable(sunxi_pwm->clk);
> +	if (ret) {
> +		dev_err(chip->dev, "failed to enable PWM clock\n");
> +		return ret;
> +	}
> +
> +	mutex_lock(&sunxi_pwm->ctrl_lock);
> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +
> +	if (sunxi_pwm->data->has_rdy && (val & PWM_RDY(pwm->hwpwm))) {
> +		mutex_unlock(&sunxi_pwm->ctrl_lock);
> +		clk_disable(sunxi_pwm->clk);
> +		return -EBUSY;
> +	}
> +
> +	clk_gate =3D val & BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
> +	if (clk_gate) {
> +		val &=3D ~BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
> +		sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
> +	}
> +
> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +	val &=3D ~BIT_CH(PWM_PRESCAL_MASK, pwm->hwpwm);
> +	val |=3D i;
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
> +
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CH_PRD(pwm->hwpwm), dty | PWM_PRD(prd));
> +
> +	if (clk_gate) {
> +		val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +		val |=3D clk_gate;
> +		sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
> +	}
> +
> +	mutex_unlock(&sunxi_pwm->ctrl_lock);
> +	clk_disable(sunxi_pwm->clk);
> +
> +	return 0;
> +}
> +
> +static int sunxi_pwm_set_polarity(struct pwm_chip *chip, struct pwm_devi=
ce *pwm,
> +				  enum pwm_polarity polarity)
> +{
> +	struct sunxi_pwm_chip *sunxi_pwm =3D to_sunxi_pwm_chip(chip);
> +	u32 val;
> +	int ret;
> +
> +	ret =3D clk_enable(sunxi_pwm->clk);
> +	if (ret) {
> +		dev_err(chip->dev, "failed to enable PWM clock\n");
> +		return ret;
> +	}
> +
> +	mutex_lock(&sunxi_pwm->ctrl_lock);
> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +
> +	if (polarity !=3D PWM_POLARITY_NORMAL)
> +		val &=3D ~BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
> +	else
> +		val |=3D BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
> +
> +
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
> +
> +	mutex_unlock(&sunxi_pwm->ctrl_lock);
> +	clk_disable(sunxi_pwm->clk);
> +
> +	return 0;
> +}
> +
> +static int sunxi_pwm_enable(struct pwm_chip *chip, struct pwm_device *pw=
m)
> +{
> +	struct sunxi_pwm_chip *sunxi_pwm =3D to_sunxi_pwm_chip(chip);
> +	u32 val;
> +	int ret;
> +
> +	ret =3D clk_enable(sunxi_pwm->clk);
> +	if (ret) {
> +		dev_err(chip->dev, "failed to enable PWM clock\n");
> +		return ret;
> +	}
> +
> +	mutex_lock(&sunxi_pwm->ctrl_lock);
> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +	val |=3D BIT_CH(PWM_EN, pwm->hwpwm);
> +	val |=3D BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
> +	mutex_unlock(&sunxi_pwm->ctrl_lock);
> +
> +	return 0;
> +}
> +
> +static void sunxi_pwm_disable(struct pwm_chip *chip, struct pwm_device *=
pwm)
> +{
> +	struct sunxi_pwm_chip *sunxi_pwm =3D to_sunxi_pwm_chip(chip);
> +	u32 val;
> +
> +	mutex_lock(&sunxi_pwm->ctrl_lock);
> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +	val &=3D ~BIT_CH(PWM_EN, pwm->hwpwm);
> +	val &=3D ~BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
> +	mutex_unlock(&sunxi_pwm->ctrl_lock);
> +
> +	clk_disable(sunxi_pwm->clk);
> +}
> +
> +static const struct pwm_ops sunxi_pwm_ops =3D {
> +	.config =3D sunxi_pwm_config,
> +	.set_polarity =3D sunxi_pwm_set_polarity,
> +	.enable =3D sunxi_pwm_enable,
> +	.disable =3D sunxi_pwm_disable,
> +	.owner =3D THIS_MODULE,
> +};
> +
> +static const struct sunxi_pwm_data sunxi_pwm_data_a10 =3D {
> +	.has_rdy =3D false,
> +};
> +
> +static const struct sunxi_pwm_data sunxi_pwm_data_a20 =3D {
> +	.has_rdy =3D true,
> +};
> +
> +static const struct of_device_id sunxi_pwm_dt_ids[] =3D {
> +	{
> +		.compatible =3D "allwinner,sun4i-a10-pwm",
> +		.data =3D &sunxi_pwm_data_a10,
> +	}, {
> +		.compatible =3D "allwinner,sun7i-a20-pwm",
> +		.data =3D &sunxi_pwm_data_a20,
> +	}, {
> +		/* sentinel */
> +	},
> +};
> +MODULE_DEVICE_TABLE(of, sunxi_pwm_dt_ids);
> +
> +static int sunxi_pwm_probe(struct platform_device *pdev)
> +{
> +	struct sunxi_pwm_chip *sunxi_pwm;
> +	struct resource *res;
> +	int ret;
> +
> +	const struct of_device_id *match;
> +
> +	match =3D of_match_device(sunxi_pwm_dt_ids, &pdev->dev);
> +	if (!match || !match->data)
> +		return -ENODEV;
> +
> +	sunxi_pwm =3D devm_kzalloc(&pdev->dev, sizeof(*sunxi_pwm), GFP_KERNEL);
> +	if (!sunxi_pwm)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sunxi_pwm->base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(sunxi_pwm->base))
> +		return PTR_ERR(sunxi_pwm->base);
> +
> +	sunxi_pwm->clk =3D devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(sunxi_pwm->clk))
> +		return PTR_ERR(sunxi_pwm->clk);
> +
> +	ret =3D clk_prepare(sunxi_pwm->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to prepare PWM clock\n");
> +		return ret;
> +	}
> +
> +	sunxi_pwm->chip.dev =3D &pdev->dev;
> +	sunxi_pwm->chip.ops =3D &sunxi_pwm_ops;
> +
> +	sunxi_pwm->chip.base =3D -1;
> +	sunxi_pwm->chip.npwm =3D 2;
> +	sunxi_pwm->chip.can_sleep =3D true;
> +	sunxi_pwm->chip.of_xlate =3D of_pwm_xlate_with_flags;
> +	sunxi_pwm->chip.of_pwm_n_cells =3D 3;
> +	sunxi_pwm->data =3D match->data;
> +
> +	mutex_init(&sunxi_pwm->ctrl_lock);
> +
> +        ret =3D clk_enable(sunxi_pwm->clk);
> +        if (ret) {
> +                dev_err(&pdev->dev, "failed to enable PWM clock\n");
> +                goto error;
> +        }
> +
> +	/* By default, the polarity is inversed, set it to normal */
> +        sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG,
> +                         BIT_CH(PWM_ACT_STATE, 0) |
> +                         BIT_CH(PWM_ACT_STATE, 1));
> +        clk_disable(sunxi_pwm->clk);

Your indentation looks weird here.

> +
> +	ret =3D pwmchip_add(&sunxi_pwm->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add PWM chip %d\n", ret);
> +		goto error;
> +	}
> +
> +	platform_set_drvdata(pdev, sunxi_pwm);
> +
> +	return ret;
> +
> +error:
> +	mutex_destroy(&sunxi_pwm->ctrl_lock);
> +	clk_unprepare(sunxi_pwm->clk);
> +	return ret;
> +}
> +
> +static int sunxi_pwm_remove(struct platform_device *pdev)
> +{
> +	struct sunxi_pwm_chip *sunxi_pwm =3D platform_get_drvdata(pdev);
> +
> +	mutex_destroy(&sunxi_pwm->ctrl_lock);
> +	clk_unprepare(sunxi_pwm->clk);
> +
> +	return pwmchip_remove(&sunxi_pwm->chip);
> +}
> +
> +static struct platform_driver sunxi_pwm_driver =3D {
> +	.driver =3D {
> +		.name =3D "sunxi-pwm",
> +		.of_match_table =3D sunxi_pwm_dt_ids,
> +	},
> +	.probe =3D sunxi_pwm_probe,
> +	.remove =3D sunxi_pwm_remove,
> +};
> +module_platform_driver(sunxi_pwm_driver);
> +
> +MODULE_ALIAS("platform:sunxi-pwm");
> +MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@free-electrons.com>"=
);
> +MODULE_DESCRIPTION("Allwinner PWM driver");
> +MODULE_LICENSE("GPL v2");
> --=20
> 1.8.3.2
>=20

Looks good, once these nitpicks fixed, you can add my:
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTTR5nAAoJEBx+YmzsjxAgmTQQAKBYIQ/vE+iJqiTatWdSR8mc
nyQCMtUWYoWttCPSRhHuXC6rd+UjqZp1C5HGSZlCTu2O3gvn25+x8YM+2ZToaA/L
91450+T6fgp21n4v2Mfh8dgJUz7EpTjD9/y66ffPjVAnr2czH+BWUxQWlKCLJMwB
oJpkb2HwIFv0Np91++Tkor8ba5YooL/QubsRbDI4Go8bwcrNtUy/T33kVJAkDrxL
qCIlM5B8jhUtM0W5urgSGuHeuXu/DFIeXQYkNtXko6iW9Yx9qoDdp1MjBNGreKe9
dUEYZacRNuwR2WqV0J2wDmbUUeG3TN+fYT6bpqOdqF6Fyzv9lJ/IKz6EpQTjsaVj
MblxX/bmmyfFPsYAl2FrddudIm/rdSxmEd/WssSjdK79NHKznBVx+gl+hXnlIwzo
HXlBL2xXRJFG9qIeBa/aZ8rsMctb2D5pbge+XhGnr0CUGKoFDsbGphNAQGFfSMRR
7++A2wz5EXv1kRGO2tqXOyAbVd8DwYLhWSveHEbO6hDxkOQWGGzUfiONltIvPuSN
im4u/7iBU8lAtDmKkBmUNdNEFcH5nYvd8bN3lq6IYQBo2tw5qZTQxg5u7AT9+ZP/
7sdhvQyMkmByWBqKXXaWO+x9GJLwdxEgXuNDoGzGJZ/dK8j3nADRE5/4qmpfy1d2
j81QgDg63EpbMrBYsgzd
=nDUH
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
