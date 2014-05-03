Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaECRzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 13:55:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60529 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752193AbaECRzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 13:55:06 -0400
Date: Sat, 3 May 2014 10:53:17 -0700
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
Subject: Re: [PATCH v5 2/3] ARM: sunxi: Add driver for sunxi IR controller
Message-ID: <20140503175317.GC15342@lukather>
References: <1398871010-30681-1-git-send-email-bay@hackerdom.ru>
 <1398871010-30681-3-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <1398871010-30681-3-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2014 at 09:16:49PM +0600, Alexander Bersenev wrote:
> This patch adds driver for sunxi IR controller.
> It is based on Alexsey Shestacov's work based on the original driver
> supplied by Allwinner.
>=20
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
> ---
>  drivers/media/rc/Kconfig    |  10 ++
>  drivers/media/rc/Makefile   |   1 +
>  drivers/media/rc/sunxi-ir.c | 303 ++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 314 insertions(+)
>  create mode 100644 drivers/media/rc/sunxi-ir.c
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
> index f8b54ff..93cdbe9 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -32,4 +32,5 @@ obj-$(CONFIG_IR_GPIO_CIR) +=3D gpio-ir-recv.o
>  obj-$(CONFIG_IR_IGUANA) +=3D iguanair.o
>  obj-$(CONFIG_IR_TTUSBIR) +=3D ttusbir.o
>  obj-$(CONFIG_RC_ST) +=3D st_rc.o
> +obj-$(CONFIG_IR_SUNXI) +=3D sunxi-ir.o
>  obj-$(CONFIG_IR_IMG) +=3D img-ir/
> diff --git a/drivers/media/rc/sunxi-ir.c b/drivers/media/rc/sunxi-ir.c
> new file mode 100644
> index 0000000..f051d94
> --- /dev/null
> +++ b/drivers/media/rc/sunxi-ir.c
> @@ -0,0 +1,303 @@
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
> +/* Bit Definition of IR_RXINTS_REG Register */
> +#define SUNXI_IR_RXINTS_RXOF  BIT(0) /* Rx FIFO Overflow */
> +#define SUNXI_IR_RXINTS_RXPE  BIT(1) /* Rx Packet End */
> +#define SUNXI_IR_RXINTS_RXDA  BIT(4) /* Rx FIFO Data Available */
> +/* Hardware supported fifo size */
> +#define SUNXI_IR_FIFO_SIZE    16
> +/* How much messages in fifo triggers IRQ */
> +#define SUNXI_IR_FIFO_TRIG    8
> +/* Required frequency for IR0 or IR1 clock in CIR mode */
> +#define SUNXI_IR_BASE_CLK     8000000
> +/* Frequency after IR internal divider  */
> +#define SUNXI_IR_CLK          (SUNXI_IR_BASE_CLK / 64)
> +/* Sample period in ns */
> +#define SUNXI_IR_SAMPLE       (1000000000ul / SUNXI_IR_CLK)
> +/* Filter threshold in samples  */
> +#define SUNXI_IR_RXFILT       1
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
> +	spin_lock_irq(&ir->ir_lock);
> +
> +	status =3D readl(ir->base + SUNXI_IR_RXSTA_REG);
> +
> +	/* clean all pending statuses */
> +	writel(status | 0xff, ir->base + SUNXI_IR_RXSTA_REG);
> +
> +	if (status & SUNXI_IR_RXINTS_RXDA) {
> +		/* How much messages in fifo */
> +		rc  =3D (status >> 8) & 0x3f;
> +		/* Sanity check */
> +		rc =3D rc > SUNXI_IR_FIFO_SIZE ? SUNXI_IR_FIFO_SIZE : rc;
> +		/* if we have data */
> +		for (cnt =3D 0; cnt < rc; cnt++) {
> +			/* for each bit in fifo */
> +			dt =3D readb(ir->base + SUNXI_IR_RXFIFO_REG);
> +			rawir.pulse =3D (dt & 0x80) !=3D 0;
> +			rawir.duration =3D (dt & 0x7f) * SUNXI_IR_SAMPLE;
> +			ir_raw_event_store_with_filter(ir->rc, &rawir);
> +		}
> +	}
> +
> +	if (status & SUNXI_IR_RXINTS_RXOF)
> +		ir_raw_event_reset(ir->rc);
> +	else if (status & SUNXI_IR_RXINTS_RXPE) {
> +		ir_raw_event_set_idle(ir->rc, true);
> +		ir_raw_event_handle(ir->rc);
> +	}
> +
> +	spin_unlock_irq(&ir->ir_lock);
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
> +		return -EINVAL;
> +	}
> +	ir->clk =3D devm_clk_get(dev, "ir");
> +	if (IS_ERR(ir->clk)) {
> +		dev_err(dev, "failed to get a ir clock.\n");
> +		return -EINVAL;
> +	}
> +
> +	ret =3D clk_set_rate(ir->clk, SUNXI_IR_BASE_CLK);
> +	if (ret) {
> +		dev_err(dev, "set ir base clock failed!\n");
> +		return -EINVAL;
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
> +	ir->base =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(ir->base)) {
> +		dev_err(dev, "failed to map registers\n");
> +		ret =3D -ENOMEM;
> +		goto exit_clkdisable_clk;
> +	}
> +
> +	/* IRQ */
> +	ir->irq =3D platform_get_irq(pdev, 0);
> +	if (ir->irq < 0) {
> +		dev_err(dev, "no irq resource\n");
> +		ret =3D -EINVAL;
> +		goto exit_clkdisable_clk;
> +	}
> +
> +	ret =3D devm_request_irq(dev, ir->irq, sunxi_ir_irq, 0, SUNXI_IR_DEV, i=
r);
> +	if (ret) {
> +		dev_err(dev, "failed request irq\n");
> +		ret =3D -EINVAL;
> +		goto exit_clkdisable_clk;
> +	}
> +
> +	ir->rc =3D rc_allocate_device();
> +
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
> +		ret =3D -EINVAL;
> +		goto exit_free_dev;
> +	}
> +
> +	platform_set_drvdata(pdev, ir);
> +
> +	/* Enable CIR Mode */
> +	writel(0x3 << 4, ir->base+SUNXI_IR_CTL_REG);
> +
> +	/* Config IR Sample Register */
> +	/* Fsample =3D clk */
> +	tmp =3D 0;
> +	/* Set Filter Threshold */
> +	tmp |=3D (SUNXI_IR_RXFILT & 0x3f) << 2;
> +	/* Set Idle Threshold */
> +	tmp |=3D (SUNXI_IR_RXIDLE & 0xff) << 8;
> +	writel(tmp, ir->base + SUNXI_IR_CIR_REG);
> +
> +	/* Invert Input Signal */
> +	writel(0x1 << 2, ir->base + SUNXI_IR_RXCTL_REG);
> +
> +	/* Clear All Rx Interrupt Status */
> +	writel(0xff, ir->base + SUNXI_IR_RXSTA_REG);
> +
> +	/* Enable IRQ on data, overflow, packed end */
> +	tmp =3D (0x1 << 4) | 0x3;
> +
> +	/* Rx FIFO Threshold */
> +	tmp |=3D (SUNXI_IR_FIFO_TRIG - 1) << 8;
> +
> +	writel(tmp, ir->base + SUNXI_IR_RXINT_REG);
> +
> +	/* Enable IR Module */
> +	tmp =3D readl(ir->base + SUNXI_IR_CTL_REG);
> +
> +	writel(tmp | 0x3, ir->base + SUNXI_IR_CTL_REG);

We don't like magic numbers too much. Please add some #define for
those.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTZS0NAAoJEBx+YmzsjxAgE6IP/A7ebj8AA4APU/h6ZGz97OWL
wogBH3FcuHHQlKeZQQMcrdcGxqaI/mzueLJXyTyZRNPTXNzzdfKIjGQJ0jMhHqm8
DHKckSZ+K71P7QoLnqyI4qbto5p3Yewn0ZT13v/XYeH/WuI/3wtCVmSYu4NSa0ju
JVKKszcCSggcDqGa/pKtjvFDLigw1exvmkEXgKNiUM3Gq1QV65tD11kTfBbDTT1C
qlfhslqcbgUQsLswGmyjqkkanlOkeFN4btnCtO5RDcYY4czjztvXCnloqL+vsXVS
cWoQXLBaGhwi/9oNMet1vJpbJWnJVL+VDlMsAc6wI7YlApls83TXJxL6oDsqgzQx
nweEZpTmRr+Z7SUdiLi7PMhIINykVEvaeTzg8iSybgpQjfFA2qzt6ZqgEQ+r7EK+
2kQA3aBWxNhaNqTxbbFbcPZrerjfJi8gttN4SWP/dpchZxnsENKBawtQMc0/5Bcq
oVnyC43dDQPPVOpijULgbFFcmSngALIXApbhEVVSocdfjiBN1Gfs0szf+YYeMCOw
yKvrfEly08tTOAM6qJrM3RnVk239zUxUHojPCMIr+yb9GDz827xIDFg591/FT0F1
1N98L0E1lSuamtLQf8Idp5HkIkzOUDLLHRo/lMHuRhjxqV8Y+LFmSN63lFaJxMhA
uN4FcOBeqbUgjt87SruC
=u8TD
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
