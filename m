Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaFAOpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 10:45:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35871 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751360AbaFAOpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 10:45:06 -0400
Date: Fri, 30 May 2014 10:25:27 +0200
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
Subject: Re: [PATCH v8 2/3] [media] rc: add sunxi-ir driver
Message-ID: <20140530082527.GA4730@lukather>
References: <1401056805-2218-1-git-send-email-bay@hackerdom.ru>
 <1401056805-2218-3-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1G2Bc0EDIhoSmEt"
Content-Disposition: inline
In-Reply-To: <1401056805-2218-3-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1G2Bc0EDIhoSmEt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 04:26:44AM +0600, Alexander Bersenev wrote:
> This patch adds driver for sunxi IR controller.
> It is based on Alexsey Shestacov's work based on the original driver
> supplied by Allwinner.
>=20
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
> ---
>  drivers/media/rc/Kconfig     |  10 ++
>  drivers/media/rc/Makefile    |   1 +
>  drivers/media/rc/sunxi-cir.c | 313 +++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 324 insertions(+)
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
> index 0000000..245d8dc
> --- /dev/null
> +++ b/drivers/media/rc/sunxi-cir.c
> @@ -0,0 +1,313 @@
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
> +#define REG_CTL_GEN           BIT(0) /* Global Enable */
> +#define REG_CTL_RXEN          BIT(1) /* RX block enable */
> +#define REG_CTL_MD            (BIT(4)|BIT(5)) /* CIR mode */

You should have a space around the operator here, and one more level
of indentation for the bits definition would be nice.

> +
> +/* Rx Config */
> +#define SUNXI_IR_RXCTL_REG    0x10
> +#define REG_RXCTL_RPPI        BIT(2) /* Pulse Polarity Invert flag */
> +
> +/* Rx Data */
> +#define SUNXI_IR_RXFIFO_REG   0x20
> +
> +/* Rx Interrupt Enable */
> +#define SUNXI_IR_RXINT_REG    0x2C
> +#define REG_RXINT_ROI_EN      BIT(0) /* Rx FIFO Overflow */
> +#define REG_RXINT_RPEI_EN     BIT(1) /* Rx Packet End */
> +#define REG_RXINT_RAI_EN      BIT(4) /* Rx FIFO Data Available */
> +/* Rx FIFO available byte level */

Either put the comments on the same line or on the above line, but
please stick to the choice you're making

> +#define REG_RXINT_RAL(val)    (((val) << 8) & (BIT(8)|BIT(9)|BIT(10)|BIT=
(11)))

Just use the mask directly here, or the GENMASK macro.

> +
> +/* Rx Interrupt Status */
> +#define SUNXI_IR_RXSTA_REG    0x30
> +/* RX FIFO Get Available Counter */
> +#define REG_RXSTA_GET_AC(val) (((val) >> 8) & (BIT(0)|BIT(1)|BIT(2)|BIT(=
3) \
> +			      |BIT(4)|BIT(5)))
> +/* Clear all interrupt status value */
> +#define REG_RXSTA_CLEARALL    0xff
> +
> +/* IR Sample Config */
> +#define SUNXI_IR_CIR_REG      0x34
> +/* CIR_REG register noise threshold */
> +#define REG_CIR_NTHR(val)    (((val) << 2) & (BIT(2)|BIT(3)|BIT(4)|BIT(5=
) \
> +			     |BIT(6)|BIT(7)))
> +/* CIR_REG register idle threshold */
> +#define REG_CIR_ITHR(val)    (((val) << 8) & (BIT(8)|BIT(9)|BIT(10)|BIT(=
11) \
> +			     |BIT(12)|BIT(13)|BIT(14)|BIT(15)))
> +
> +/* Hardware supported fifo size */
> +#define SUNXI_IR_FIFO_SIZE    16
> +/* How many messages in FIFO trigger IRQ */
> +#define TRIGGER_LEVEL         8
> +/* Required frequency for IR0 or IR1 clock in CIR mode */
> +#define SUNXI_IR_BASE_CLK     8000000
> +/* Frequency after IR internal divider  */
> +#define SUNXI_IR_CLK          (SUNXI_IR_BASE_CLK / 64)
> +/* Sample period in ns */
> +#define SUNXI_IR_SAMPLE       (1000000000ul / SUNXI_IR_CLK)
> +/* Noise threshold in samples  */
> +#define SUNXI_IR_RXNOISE      1
> +/* Idle Threshold in samples */
> +#define SUNXI_IR_RXIDLE       20
> +/* Time after which device stops sending data in ms */
> +#define SUNXI_IR_TIMEOUT      120
> +
> +struct sunxi_ir {
> +	spinlock_t      ir_lock;
> +	struct rc_dev   *rc;
> +	void __iomem    *base;
> +	int             irq;
> +	struct clk      *clk;
> +	struct clk      *apb_clk;
> +	const char      *map_name;
> +};
> +
> +static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
> +{
> +	unsigned long status;
> +	unsigned char dt;
> +	unsigned int cnt, rc;
> +	struct sunxi_ir *ir =3D dev_id;
> +	DEFINE_IR_RAW_EVENT(rawir);
> +
> +	spin_lock(&ir->ir_lock);
> +
> +	status =3D readl(ir->base + SUNXI_IR_RXSTA_REG);
> +
> +	/* clean all pending statuses */
> +	writel(status | REG_RXSTA_CLEARALL, ir->base + SUNXI_IR_RXSTA_REG);
> +
> +	if (status & REG_RXINT_RAI_EN) {
> +		/* How many messages in fifo */
> +		rc  =3D REG_RXSTA_GET_AC(status);
> +		/* Sanity check */
> +		rc =3D rc > SUNXI_IR_FIFO_SIZE ? SUNXI_IR_FIFO_SIZE : rc;
> +		/* If we have data */
> +		for (cnt =3D 0; cnt < rc; cnt++) {
> +			/* for each bit in fifo */
> +			dt =3D readb(ir->base + SUNXI_IR_RXFIFO_REG);
> +			rawir.pulse =3D (dt & 0x80) !=3D 0;
> +			rawir.duration =3D ((dt & 0x7f) + 1) * SUNXI_IR_SAMPLE;
> +			ir_raw_event_store_with_filter(ir->rc, &rawir);
> +		}
> +	}
> +
> +	if (status & REG_RXINT_ROI_EN) {
> +		ir_raw_event_reset(ir->rc);
> +	} else if (status & REG_RXINT_RPEI_EN) {
> +		ir_raw_event_set_idle(ir->rc, true);
> +		ir_raw_event_handle(ir->rc);
> +	}
> +
> +	spin_unlock(&ir->ir_lock);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +
> +static int sunxi_ir_probe(struct platform_device *pdev)
> +{
> +	int ret =3D 0;
> +	unsigned long tmp =3D 0;
> +
> +	struct device *dev =3D &pdev->dev;
> +	struct device_node *dn =3D dev->of_node;
> +	struct resource *res;
> +	struct sunxi_ir *ir;
> +
> +	ir =3D devm_kzalloc(dev, sizeof(struct sunxi_ir), GFP_KERNEL);
> +	if (!ir)
> +		return -ENOMEM;
> +
> +	/* Clock */
> +	ir->apb_clk =3D devm_clk_get(dev, "apb");
> +	if (IS_ERR(ir->apb_clk)) {
> +		dev_err(dev, "failed to get a apb clock.\n");
> +		return PTR_ERR(ir->apb_clk);
> +	}

Newline.

> +	ir->clk =3D devm_clk_get(dev, "ir");
> +	if (IS_ERR(ir->clk)) {
> +		dev_err(dev, "failed to get a ir clock.\n");
> +		return PTR_ERR(ir->clk);
> +	}
> +
> +	ret =3D clk_set_rate(ir->clk, SUNXI_IR_BASE_CLK);
> +	if (ret) {
> +		dev_err(dev, "set ir base clock failed!\n");
> +		return ret;
> +	}
> +
> +	if (clk_prepare_enable(ir->apb_clk)) {
> +		dev_err(dev, "try to enable apb_ir_clk failed\n");
> +		return -EINVAL;
> +	}
> +
> +	if (clk_prepare_enable(ir->clk)) {
> +		dev_err(dev, "try to enable ir_clk failed\n");
> +		ret =3D -EINVAL;
> +		goto exit_clkdisable_apb_clk;
> +	}
> +
> +	/* IO */
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +

You can drop the extra line here

> +	ir->base =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(ir->base)) {
> +		dev_err(dev, "failed to map registers\n");
> +		ret =3D PTR_ERR(ir->base);
> +		goto exit_clkdisable_clk;
> +	}
> +
> +	ir->rc =3D rc_allocate_device();
> +	if (!ir->rc) {
> +		dev_err(dev, "failed to allocate device\n");
> +		ret =3D -ENOMEM;
> +		goto exit_clkdisable_clk;
> +	}
> +
> +	ir->rc->priv =3D ir;
> +	ir->rc->input_name =3D SUNXI_IR_DEV;
> +	ir->rc->input_phys =3D "sunxi-ir/input0";
> +	ir->rc->input_id.bustype =3D BUS_HOST;
> +	ir->rc->input_id.vendor =3D 0x0001;
> +	ir->rc->input_id.product =3D 0x0001;
> +	ir->rc->input_id.version =3D 0x0100;
> +	ir->map_name =3D of_get_property(dn, "linux,rc-map-name", NULL);
> +	ir->rc->map_name =3D ir->map_name ?: RC_MAP_EMPTY;
> +	ir->rc->dev.parent =3D dev;
> +	ir->rc->driver_type =3D RC_DRIVER_IR_RAW;
> +	rc_set_allowed_protocols(ir->rc, RC_BIT_ALL);
> +	ir->rc->rx_resolution =3D SUNXI_IR_SAMPLE;
> +	ir->rc->timeout =3D MS_TO_NS(SUNXI_IR_TIMEOUT);
> +	ir->rc->driver_name =3D SUNXI_IR_DEV;
> +
> +	ret =3D rc_register_device(ir->rc);
> +	if (ret) {
> +		dev_err(dev, "failed to register rc device\n");
> +		goto exit_free_dev;
> +	}
> +
> +	platform_set_drvdata(pdev, ir);
> +
> +	/* IRQ */
> +	ir->irq =3D platform_get_irq(pdev, 0);
> +	if (ir->irq < 0) {
> +		dev_err(dev, "no irq resource\n");
> +		ret =3D ir->irq;
> +		goto exit_free_dev;
> +	}
> +
> +	ret =3D devm_request_irq(dev, ir->irq, sunxi_ir_irq, 0, SUNXI_IR_DEV, i=
r);
> +	if (ret) {
> +		dev_err(dev, "failed request irq\n");
> +		goto exit_free_dev;
> +	}
> +
> +	/* Enable CIR Mode */
> +	writel(REG_CTL_MD, ir->base+SUNXI_IR_CTL_REG);
> +
> +	/* Set noise threshold and idle threshold */
> +	writel(REG_CIR_NTHR(SUNXI_IR_RXNOISE)|REG_CIR_ITHR(SUNXI_IR_RXIDLE),
> +	       ir->base + SUNXI_IR_CIR_REG);
> +
> +	/* Invert Input Signal */
> +	writel(REG_RXCTL_RPPI, ir->base + SUNXI_IR_RXCTL_REG);
> +
> +	/* Clear All Rx Interrupt Status */
> +	writel(REG_RXSTA_CLEARALL, ir->base + SUNXI_IR_RXSTA_REG);
> +
> +	/* Enable IRQ on overflow, packet end, FIFO available with trigger
> +	   level */

Multi-line comments should be

	/*
	 * Like
	 * this
	 */

> +	writel(REG_RXINT_ROI_EN | REG_RXINT_RPEI_EN |
> +	       REG_RXINT_RAI_EN | REG_RXINT_RAL(TRIGGER_LEVEL - 1),
> +	       ir->base + SUNXI_IR_RXINT_REG);
> +
> +	/* Enable IR Module */
> +	tmp =3D readl(ir->base + SUNXI_IR_CTL_REG);
> +	writel(tmp | REG_CTL_GEN | REG_CTL_RXEN, ir->base + SUNXI_IR_CTL_REG);
> +
> +	dev_info(dev, "initialized sunXi IR driver\n");
> +	return 0;
> +
> +exit_free_dev:
> +	rc_free_device(ir->rc);
> +exit_clkdisable_clk:
> +	clk_disable_unprepare(ir->clk);
> +exit_clkdisable_apb_clk:
> +	clk_disable_unprepare(ir->apb_clk);
> +
> +	return ret;
> +}
> +
> +static int sunxi_ir_remove(struct platform_device *pdev)
> +{
> +	unsigned long flags;
> +	struct sunxi_ir *ir =3D platform_get_drvdata(pdev);
> +
> +	clk_disable_unprepare(ir->clk);
> +	clk_disable_unprepare(ir->apb_clk);
> +
> +	spin_lock_irqsave(&ir->ir_lock, flags);
> +	/* disable IR IRQ */
> +	writel(0, ir->base + SUNXI_IR_RXINT_REG);
> +	/* clear All Rx Interrupt Status */
> +	writel(REG_RXSTA_CLEARALL, ir->base + SUNXI_IR_RXSTA_REG);
> +	/* disable IR */
> +	writel(0, ir->base + SUNXI_IR_CTL_REG);
> +	spin_unlock_irqrestore(&ir->ir_lock, flags);
> +
> +	rc_unregister_device(ir->rc);
> +	return 0;
> +}
> +
> +static const struct of_device_id sunxi_ir_match[] =3D {
> +	{ .compatible =3D "allwinner,sun7i-a20-ir", },
> +	{},
> +};
> +
> +static struct platform_driver sunxi_ir_driver =3D {
> +	.probe          =3D sunxi_ir_probe,
> +	.remove         =3D sunxi_ir_remove,
> +	.driver =3D {
> +		.name =3D SUNXI_IR_DEV,
> +		.owner =3D THIS_MODULE,
> +		.of_match_table =3D sunxi_ir_match,
> +	},
> +};
> +
> +module_platform_driver(sunxi_ir_driver);
> +
> +MODULE_DESCRIPTION("Allwinner sunXi IR controller driver");
> +MODULE_AUTHOR("Alexsey Shestacov <wingrime@linux-sunxi.org>");
> +MODULE_LICENSE("GPL");
> --=20
> 1.9.3
>=20

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--k1G2Bc0EDIhoSmEt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTiEB3AAoJEBx+YmzsjxAg9vcP/iz3yvKwKTk92DfBkYPIETCW
+kE2yzYEuDyQfSnCzuQ9PJbQMATWZRtcfwJPuanFTCED5waiWRgWKGVZTW+Y6eU8
VgKEjSj0vuImEB500ss45ibwuR4eUJPkCbbcXFVG6qfxScIkgVp3v2q0VWeAJdov
fvEa3cFvwVHASiNhcM2V3M2Zq7/I0GNR+YZfwjmyhuUioLx8ucMAgUtvWJeeJHMW
ET5qj4ST17AU0p/XEAX8RJZ9eRe7wgTRqyLcMqUdVerg2SXn67bZKNld7oS+/oDP
co/5YlgH51x5f34Lssq0Jy7kaom7mfPkSIbIJgoym+vFNmdsbe4rCla+QhiC1ghc
W/1fXdDMN2870eyUM48+io0aP/SYg5HEAgQ2Wo21tGV40xLYL3edv5XOgcbE+16x
nV2vh4ecqT33lwvNEWyTreFKwdLV7onr4lTtOSnZtK2Y12ALf5mhGPdS59pIeKN+
APeNY/TlV3ipH5ICHOaghA6Qb1paZMh9/V6DOlAPw413tzSyrEURlfbUuWwuH8VA
GDu0QbsXCFgU9dqsFBZc9XS0ZuugWOPgTuJ1WQhfzdueg+TLum1iXIHAs4VU6Uhc
QidHlYQsyXvnaVhMpUZvMvFdQx4cIgUyPwTUGDEQFBCzwjDatnLrQXHoHa+utGL1
WSwLpqhi0GVfwPLlddxk
=vtmW
-----END PGP SIGNATURE-----

--k1G2Bc0EDIhoSmEt--
