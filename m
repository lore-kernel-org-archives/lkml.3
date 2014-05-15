Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaEOIgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:36:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53051 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752469AbaEOIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:36:11 -0400
Date: Thu, 15 May 2014 09:24:09 +0200
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
Message-ID: <20140515072409.GM29258@lukather>
References: <1400104602-16431-1-git-send-email-bay@hackerdom.ru>
 <1400104602-16431-3-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1HuzLmPZrG5RH6bG"
Content-Disposition: inline
In-Reply-To: <1400104602-16431-3-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1HuzLmPZrG5RH6bG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

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
> +
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
> +
> +/* CIR_REG register noise threshold */
> +#define REG_CIR_NTHR__MASK   (BIT(2)|BIT(3)|BIT(4)|BIT(5)|BIT(6)|BIT(7))
> +#define REG_CIR_NTHR__SHIFT  2
> +static inline uint32_t REG_CIR_NTHR(uint16_t val)
> +{
> +	return (val << REG_CIR_NTHR__SHIFT) & REG_CIR_NTHR__MASK;
> +}
> +/* CIR_REG register idle threshold */
> +#define REG_CIR_ITHR__MASK   (BIT(8)|BIT(9)|BIT(10)|BIT(11)|BIT(12)|BIT(=
13) \
> +			     |BIT(14)|BIT(15))
> +#define REG_CIR_ITHR__SHIFT  8
> +static inline uint32_t REG_CIR_ITHR(uint16_t val)
> +{
> +	return (val << REG_CIR_ITHR__SHIFT) & REG_CIR_ITHR__MASK;
> +}
> +
> +/* RXSTA_REG Register RX FIFO Available Counter */
> +#define REG_RXSTA_RAC__SHIFT  8
> +#define REG_RXSTA_RAC__MASK   0x3f
> +
> +/* Clear all interrupt status value */
> +#define REG_RXSTA_CLEARALL    0xff
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
> +		rc  =3D (status >> REG_RXSTA_RAC__SHIFT) & REG_RXSTA_RAC__MASK;
> +		/* Sanity check */
> +		rc =3D rc > SUNXI_IR_FIFO_SIZE ? SUNXI_IR_FIFO_SIZE : rc;
> +		/* If we have data */
> +		for (cnt =3D 0; cnt < rc; cnt++) {
> +			/* for each bit in fifo */
> +			dt =3D readb(ir->base + SUNXI_IR_RXFIFO_REG);
> +			rawir.pulse =3D (dt & 0x80) !=3D 0;
> +			rawir.duration =3D (dt & 0x7f) * SUNXI_IR_SAMPLE;
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
> +	ir->base =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(ir->base)) {
> +		dev_err(dev, "failed to map registers\n");
> +		ret =3D PTR_ERR(ir->base);
> +		goto exit_clkdisable_clk;
> +	}
> +

You can drop the extra line here

> +	/* IRQ */
> +	ir->irq =3D platform_get_irq(pdev, 0);
> +	if (ir->irq < 0) {
> +		dev_err(dev, "no irq resource\n");
> +		ret =3D ir->irq;
> +		goto exit_clkdisable_clk;
> +	}
> +
> +	ret =3D devm_request_irq(dev, ir->irq, sunxi_ir_irq, 0, SUNXI_IR_DEV, i=
r);

Starting from here, your handler can be called, and you're far from
ready to handle your interrupts.

> +	if (ret) {
> +		dev_err(dev, "failed request irq\n");
> +		goto exit_clkdisable_clk;
> +	}
> +
> +	ir->rc =3D rc_allocate_device();
> +

You can drop the extra line here

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--1HuzLmPZrG5RH6bG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTdGuZAAoJEBx+YmzsjxAgEOgQAIPVf4z36SM4NEE/FUdQcJPf
fJqPDIA7wwHb3ac1/BXALKUSjpIiXMIu7XvNcRM1T5+x25iexoPVhov3KLW6CDTO
XnnpMO7xIEqmEvjCdY9z9q0ZiXskMB7Haj1uY4NaHPq9Az5O/8NS6J8HSvY4eb5u
wVr51c3o3ypgvXwwswItdwAdSgfZIhjbsRtQuet6/YUAq2ls4hAcxwgcuPRnWQa/
CM5cDsoe7HPMXi6bZvf5b1Y9BBh/nYYMFRluqdBZFpGwTNqZSKnOK2fm4HAK0kFy
lZTb7cNvAiumIyyOBqyOaOD/9FU+2l1N8RPXlf+iBPmrFjMDGHWIAX3+iWGz7NCZ
KsfGKHILKSgkzfA3IMahcQT9mZyavwBLi//BZw0p602rOGZXEm+ILbctfK0e9eig
2qT19VryqGIstXfvqDUadewiPkq1VkqY0rsoWlsNet90XR7hVKLQDWcm6BY4OyZT
6CsmnccIKE3OvXdK0wFraI4dvtvQnA7GlxlVekv1ll1DdJEntd6Gc0On4bJZdTeV
3idtHfiikj+Cyisx1fJtUs5HrMnwTv1NWgGx8o5iDceDqyIpXLbghzqnT0sGmIQI
ufaHjBwTyAVKI58irVW89tmBlIeFIAnMJO7rBsVmtd5oKqv93RJ3Z6J1rsjknaPC
3+qKr+UI+8FirgIcP2lR
=bs9K
-----END PGP SIGNATURE-----

--1HuzLmPZrG5RH6bG--
