Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaCaRgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:36:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47464 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752932AbaCaRgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:36:13 -0400
Date: Mon, 31 Mar 2014 19:35:37 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pwm: Add Allwinner SoC support
Message-ID: <20140331173537.GJ26751@lukather>
References: <1396267649-18009-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1396267649-18009-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRtZRu2mMGBZ6YQ7"
Content-Disposition: inline
In-Reply-To: <1396267649-18009-2-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRtZRu2mMGBZ6YQ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2014 at 02:07:26PM +0200, Alexandre Belloni wrote:
> This adds a generic PWM framework driver for the PWM controller
> found on Allwinner SoCs.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/pwm/Kconfig     |   9 ++
>  drivers/pwm/Makefile    |   1 +
>  drivers/pwm/pwm-sunxi.c | 325 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 335 insertions(+)
>  create mode 100644 drivers/pwm/pwm-sunxi.c
>=20
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 22f2f2857b82..f7381def0fd2 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -187,6 +187,15 @@ config PWM_SPEAR
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-spear.
> =20
> +config PWM_SUNXI
> +	tristate "Allwinner PWM support"
> +	depends on ARCH_SUNXI
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
> index d8906ec69976..e110259b6c03 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_PWM_PXA)		+=3D pwm-pxa.o
>  obj-$(CONFIG_PWM_RENESAS_TPU)	+=3D pwm-renesas-tpu.o
>  obj-$(CONFIG_PWM_SAMSUNG)	+=3D pwm-samsung.o
>  obj-$(CONFIG_PWM_SPEAR)		+=3D pwm-spear.o
> +obj-$(CONFIG_PWM_SUNXI)		+=3D pwm-sunxi.o
>  obj-$(CONFIG_PWM_TEGRA)		+=3D pwm-tegra.o
>  obj-$(CONFIG_PWM_TIECAP)	+=3D pwm-tiecap.o
>  obj-$(CONFIG_PWM_TIEHRPWM)	+=3D pwm-tiehrpwm.o
> diff --git a/drivers/pwm/pwm-sunxi.c b/drivers/pwm/pwm-sunxi.c
> new file mode 100644
> index 000000000000..be39abee0a24
> --- /dev/null
> +++ b/drivers/pwm/pwm-sunxi.c
> @@ -0,0 +1,325 @@
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
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/slab.h>
> +
> +#define PWM_CTRL_REG		0x0
> +
> +#define PWM_CH_PRD_BASE		0x4
> +#define PWM_CH_PRD_OFF		0x4
> +#define PWM_CH_PRD(x)		(PWM_CH_PRD_BASE + PWM_CH_PRD_OFF * x)
> +
> +#define	PWMCH_OFFSET		15
            ^ That looks odd.

> +#define PWM_PRESCAL_MASK	(BIT(0)|BIT(1)|BIT(2)|BIT(3))
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
> +
> +#define PWM_PRD_ACT_MASK	0xFF
> +#define PWM_PRD(x)		(x << 16)
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

Do you have a reason to not use plain readl/writel?

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
> +

You can drop the extra line here.

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
> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +
> +	if (sunxi_pwm->data->has_rdy && (val & PWM_RDY(pwm->hwpwm)))
> +		return -EBUSY;

clk_disable?

And I'd rather use pm_runtime here.

> +	clk_gate =3D val & BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
> +	val &=3D ~BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);

You probably can test clk_gate here to avoid a write if it's already
disabled.

> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +	val &=3D ~BIT_CH(PWM_PRESCAL_MASK, pwm->hwpwm);
> +	val |=3D i;
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
> +
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CH_PRD(pwm->hwpwm), dty | PWM_PRD(prd));
> +
> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +	val |=3D clk_gate;
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);

And you can test it here too.

> +	clk_disable(sunxi_pwm->clk);
> +	return ret;

return 0; ?

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
> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +
> +	if (polarity !=3D PWM_POLARITY_NORMAL)
> +		val &=3D ~BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
> +	else
> +		val |=3D BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
> +
> +	ret =3D clk_enable(sunxi_pwm->clk);

Hmmm, this should probably be before you access the registers.

> +	if (ret) {
> +		dev_err(chip->dev, "failed to enable PWM clock\n");
> +		return ret;
> +	}
> +
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
> +
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
> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +	val |=3D BIT_CH(PWM_EN, pwm->hwpwm);
> +	val |=3D BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
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
> +	val =3D sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
> +	val &=3D ~BIT_CH(PWM_EN, pwm->hwpwm);
> +	val &=3D ~BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG, val);
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
> +static const struct sunxi_pwm_data sunxi_pwm_data_v1 =3D {
> +	.has_rdy =3D false,
> +};
> +
> +static const struct sunxi_pwm_data sunxi_pwm_data_v2 =3D {
> +	.has_rdy =3D true,
> +};

I'd prefer to see these structures named after the soc they're
associated to.

> +static const struct of_device_id sunxi_pwm_dt_ids[] =3D {
> +	{
> +		.compatible =3D "allwinner,sun4i-pwm",
> +		.data =3D &sunxi_pwm_data_v1,
> +	}, {
> +		.compatible =3D "allwinner,sun7i-pwm",
> +		.data =3D &sunxi_pwm_data_v2,
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
> +	if (pdev->dev.of_node) {

Which will always happen if of_match_device succeeded.

> +		sunxi_pwm->chip.of_xlate =3D of_pwm_xlate_with_flags;
> +		sunxi_pwm->chip.of_pwm_n_cells =3D 3;
> +	}
> +
> +	sunxi_pwm->chip.base =3D -1;
> +	sunxi_pwm->chip.npwm =3D 2;
> +	sunxi_pwm->data =3D match->data;
> +
> +	/* By default, the polarity is inversed, set it to normal */

That comment should be after the clk_enable call.

> +	ret =3D clk_enable(sunxi_pwm->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to enable PWM clock\n");
> +		goto unprepare_clk;
> +	}
> +	sunxi_pwm_writel(sunxi_pwm, PWM_CTRL_REG,
> +			 BIT_CH(PWM_ACT_STATE, 0) |
> +			 BIT_CH(PWM_ACT_STATE, 1));
> +	clk_disable(sunxi_pwm->clk);
> +
> +	ret =3D pwmchip_add(&sunxi_pwm->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add PWM chip %d\n", ret);
> +		goto unprepare_clk;
> +	}
> +
> +	platform_set_drvdata(pdev, sunxi_pwm);
> +
> +

You can drop the extra line.

> +	return ret;
> +
> +unprepare_clk:
> +	clk_unprepare(sunxi_pwm->clk);
> +	return ret;
> +}
> +
> +static int sunxi_pwm_remove(struct platform_device *pdev)
> +{
> +	struct sunxi_pwm_chip *sunxi_pwm =3D platform_get_drvdata(pdev);
> +
> +	clk_unprepare(sunxi_pwm->clk);
> +
> +	return pwmchip_remove(&sunxi_pwm->chip);
> +}
> +
> +static struct platform_driver sunxi_pwm_driver =3D {
> +	.driver =3D {
> +		.name =3D "sunxi-pwm",
> +		.of_match_table =3D of_match_ptr(sunxi_pwm_dt_ids),

You can drop the of_match_ptr. CONFIG_OF is always selected, and you
don't protect the definition of sunxi_pwm_dt_ids by an ifdef anyway.

> +	},
> +	.probe =3D sunxi_pwm_probe,
> +	.remove =3D sunxi_pwm_remove,
> +};
> +module_platform_driver(sunxi_pwm_driver);
> +
> +MODULE_ALIAS("platform:sunxi-pwm");
> +MODULE_AUTHOR("alexandre Belloni <alexandre.belloni@free-electrons.com>"=
);
> +MODULE_DESCRIPTION("Allwinner PWM driver");
> +MODULE_LICENSE("GPL v2");
> --=20
> 1.8.3.2
>=20

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--wRtZRu2mMGBZ6YQ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTOadoAAoJEBx+YmzsjxAgtxsP/35vkN1xFxtCv3OrMJVZztKX
gj6aHsdiiz4kcN5iORUBFr50+930ZXRoha6w4DRXhmO2Xy+pzvOXvOI84CaXeBvQ
n7PV/f+UDEOSOYwqUp9QQB4g+Qj6goD67D98C/6aQq+3HK3bmdu66gx0VZ2OvgWV
hzueXstJgrq6HDUaiYC8R2BfoUnsPTHr3gaSTBkCtnTLDqz9Jt3i6REX12Qmue+a
vcJVbf33Bt7oLfM5x6HQ43JtUK7vCH85iKF+7zY9D23REYUl7eS3AkyWgr8MrQ6F
DMB/4gn4MKQwa4mxDPk64hIfMgYbOm48mIuuZTB3kys6VSLfvJg6pc/czc9j5iQD
JMcGfKPPbpNEO5E9g0XTZa6Npu4VJ9PZvCfcbKNuwkrJJ5J5+QpFwoiUpZVaFj2z
cyKy2jPqe5MAh0Kgpu4DrPbQG/D4BfqNlUvUS0JmYmaWp4c85NFFXWgufj2/T06c
AXukojca91Z9t/B38ZKqEZl+w680nja3Id46vvwZ3CQr6porS+h2THRXdNeN7mLt
09cSthT1m5Wo93bDr3FbwxzX2BAVW6+6fX9fi06lWlWlmlw4OC7nPj7IdCnCTMMS
CdFJ2ESJjTqaUoUAa9BvbRsONdsJ2RUqQSKbzrbcIzdJd4hU7Vgw+gqAouly4wLX
BwgIoZKUf5ja5VHQXLfx
=FXKv
-----END PGP SIGNATURE-----

--wRtZRu2mMGBZ6YQ7--
