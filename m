Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab3GBJZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:25:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56046 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab3GBJZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:25:15 -0400
Date: Tue, 2 Jul 2013 12:24:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <balbi@ti.com>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
Message-ID: <20130702092458.GI3352@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWOmaDnDlrCGjNh4"
Content-Disposition: inline
In-Reply-To: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pWOmaDnDlrCGjNh4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 02, 2013 at 02:26:39PM +0530, Sourav Poddar wrote:
> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> index 33f9c09..ea14eff 100644
> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -46,6 +46,7 @@ obj-$(CONFIG_SPI_OCTEON)		+=3D spi-octeon.o
>  obj-$(CONFIG_SPI_OMAP_UWIRE)		+=3D spi-omap-uwire.o
>  obj-$(CONFIG_SPI_OMAP_100K)		+=3D spi-omap-100k.o
>  obj-$(CONFIG_SPI_OMAP24XX)		+=3D spi-omap2-mcspi.o
> +obj-$(CONFIG_QSPI_DRA7xxx)              +=3D ti-qspi.o

all other drivers are prepended with spi-

> diff --git a/drivers/spi/ti-qspi.c b/drivers/spi/ti-qspi.c
> new file mode 100644
> index 0000000..e646a93
> --- /dev/null
> +++ b/drivers/spi/ti-qspi.c
> @@ -0,0 +1,357 @@
> +/*
> + * TI QSPI driver
> + *
> + * Copyright (C) 2013, Texas Instruments, Incorporated
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR /PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/dmaengine.h>
> +#include <linux/omap-dma.h>
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/pinctrl/consumer.h>
> +
> +#include <linux/spi/spi.h>
> +
> +struct dra7xxx_qspi {
> +	struct spi_master	*master;
> +	void __iomem            *base;
> +	int device_type;
> +	struct device           *dev;

nit: move this pointer up and the int down.

> +	u32 spi_max_frequency;
> +	u32 cmd;
> +	u32 dc;
> +};
> +
> +#define QSPI_PID			(0x0)
> +#define QSPI_SYSCONFIG			(0x10)
> +#define QSPI_INTR_STATUS_RAW_SET	(0x20)
> +#define QSPI_INTR_STATUS_ENABLED_CLEAR	(0x24)
> +#define QSPI_INTR_ENABLE_SET_REG	(0x28)
> +#define QSPI_INTR_ENABLE_CLEAR_REG	(0x2c)
> +#define QSPI_SPI_CLOCK_CNTRL_REG	(0x40)
> +#define QSPI_SPI_DC_REG			(0x44)
> +#define QSPI_SPI_CMD_REG		(0x48)
> +#define QSPI_SPI_STATUS_REG		(0x4c)
> +#define QSPI_SPI_DATA_REG		(0x50)
> +#define QSPI_SPI_SETUP0_REG		(0x54)
> +#define QSPI_SPI_SWITCH_REG		(0x64)
> +#define QSPI_SPI_SETUP1_REG		(0x58)
> +#define QSPI_SPI_SETUP2_REG		(0x5c)
> +#define QSPI_SPI_SETUP3_REG		(0x60)
> +#define QSPI_SPI_DATA_REG_1		(0x68)
> +#define QSPI_SPI_DATA_REG_2		(0x6c)
> +#define QSPI_SPI_DATA_REG_3		(0x70)
> +
> +#define QSPI_TIMEOUT			2000000
> +
> +#define QSPI_FCLK			192000000
> +
> +/* Clock Control */
> +#define QSPI_CLK_EN			(1 << 31)
> +#define QSPI_CLK_DIV_MAX		0xffff
> +
> +/* Command */
> +#define QSPI_EN_CS(n)			(n << 28)
> +#define QSPI_WLEN(n)			((n-1) << 19)
> +#define QSPI_3_PIN			(1 << 18)
> +#define QSPI_RD_SNGL			(1 << 16)
> +#define QSPI_WR_SNGL			(2 << 16)
> +#define QSPI_RD_QUAD			(7 << 16)
> +#define QSPI_INVAL			(4 << 16)
> +
> +/* Device Control */
> +#define QSPI_DD(m, n)			(m << (3 + n*8))
> +#define QSPI_CKPHA(n)			(1 << (2 + n*8))
> +#define QSPI_CSPOL(n)			(1 << (1 + n*8))
> +#define QSPI_CKPOL(n)			(1 << (n*8))
> +
> +/* Status */
> +#define QSPI_WC				(1 << 1)
> +#define QSPI_BUSY			(1 << 0)
> +#define QSPI_WC_BUSY			(QSPI_WC | QSPI_BUSY)
> +#define QSPI_XFER_DONE			QSPI_WC
> +
> +#define XFER_END			0x01
> +
> +#define SPI_AUTOSUSPEND_TIMEOUT         2000
> +
> +static inline unsigned long dra7xxx_readl(struct dra7xxx_qspi *qspi,
> +		unsigned long reg)
> +{
> +	return readl(qspi->base + reg);
> +}
> +
> +static inline void dra7xxx_writel(struct dra7xxx_qspi *qspi,
> +		unsigned long val, unsigned long reg)
> +{
> +	writel(val, qspi->base + reg);
> +}
> +
> +static int dra7xxx_qspi_setup(struct spi_device *spi)
> +{
> +	struct dra7xxx_qspi	*qspi =3D
> +			spi_master_get_devdata(spi->master);
> +
> +	int clk_div;
> +
> +	if (!qspi->spi_max_frequency)
> +		clk_div =3D 0;

won't this generate division by zero ?

> +	else
> +		clk_div =3D (QSPI_FCLK / qspi->spi_max_frequency) - 1;

this QSPI_FCLK looks like it should be a clk_get_rate().

> +	pr_debug("%s: hz: %d, clock divider %d\n", __func__,
> +			qspi->spi_max_frequency, clk_div);

dev_dbg()

> +	pm_runtime_get_sync(qspi->dev);
> +
> +	/* disable SCLK */
> +	dra7xxx_writel(qspi, dra7xxx_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG)
> +			& ~QSPI_CLK_EN, QSPI_SPI_CLOCK_CNTRL_REG);
> +
> +	if (clk_div < 0) {
> +		pr_debug("%s: clock divider < 0, using /1 divider\n", __func__);
> +		clk_div =3D 0;
> +	}
> +
> +	if (clk_div > QSPI_CLK_DIV_MAX) {
> +		pr_debug("%s: clock divider >%d , using /%d divider\n",
> +			__func__, QSPI_CLK_DIV_MAX, QSPI_CLK_DIV_MAX + 1);
> +		clk_div =3D QSPI_CLK_DIV_MAX;
> +	}
> +
> +	/* enable SCLK */
> +	dra7xxx_writel(qspi, QSPI_CLK_EN | clk_div, QSPI_SPI_CLOCK_CNTRL_REG);
> +
> +	pm_runtime_mark_last_busy(qspi->dev);
> +	pm_runtime_put_autosuspend(qspi->dev);
> +
> +	pr_debug("%s: spi_clock_cntrl %ld\n", __func__,
> +		dra7xxx_readl(qspi, QSPI_SPI_CLOCK_CNTRL_REG));

dev_dbg(), also use a cached value of the control register. Read only
once.

> +
> +	return 0;
> +}
> +
> +static int dra7xxx_qspi_prepare_xfer(struct spi_master *master)
> +{
> +	struct dra7xxx_qspi *qspi =3D spi_master_get_devdata(master);
> +
> +	pm_runtime_get_sync(qspi->dev);
> +
> +	return 0;
> +}
> +
> +static int dra7xxx_qspi_unprepare_xfer(struct spi_master *master)
> +{
> +	struct dra7xxx_qspi *qspi =3D spi_master_get_devdata(master);
> +
> +	pm_runtime_mark_last_busy(qspi->dev);
> +	pm_runtime_put_autosuspend(qspi->dev);
> +
> +	return 0;
> +}
> +
> +static int qspi_transfer_msg(struct dra7xxx_qspi *qspi, unsigned count,
> +			const u8 *txbuf, u8 *rxbuf, bool flags)
> +{
> +	uint status;
> +	int timeout;
> +
> +	while (count--) {
> +		if (txbuf) {
> +			pr_debug("tx cmd %08x dc %08x data %02x\n",
> +				qspi->cmd | QSPI_WR_SNGL, qspi->dc, *txbuf);

dev_dbg()

> +			dra7xxx_writel(qspi, *txbuf++, QSPI_SPI_DATA_REG);
> +			dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
> +			dra7xxx_writel(qspi, qspi->cmd | QSPI_WR_SNGL,
> +					QSPI_SPI_CMD_REG);
> +			status =3D dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
> +			timeout =3D QSPI_TIMEOUT;
> +			while ((status & QSPI_WC_BUSY) !=3D QSPI_XFER_DONE) {

do you really need to poll ? No IRQ available ?

> +				if (--timeout < 0) {
> +					pr_debug("QSPI tx timed out\n");

dev_dbg()

> +					return -1;
> +				}
> +				status =3D dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
> +			}
> +			pr_debug("tx done, status %08x\n", status);

dev_dbg()

> +		}
> +		if (rxbuf) {
> +			pr_debug("rx cmd %08x dc %08x\n",
> +				qspi->cmd | QSPI_RD_SNGL, qspi->dc);

dev_dbg()

> +			dra7xxx_writel(qspi, qspi->dc, QSPI_SPI_DC_REG);
> +			dra7xxx_writel(qspi, qspi->cmd | QSPI_RD_SNGL,
> +					QSPI_SPI_CMD_REG);
> +			status =3D dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
> +			timeout =3D QSPI_TIMEOUT;
> +			while ((status & QSPI_WC_BUSY) !=3D QSPI_XFER_DONE) {
> +				if (--timeout < 0) {
> +					pr_debug("QSPI rx timed out\n");

dev_dbg()

> +					return -1;
> +				}
> +				status =3D dra7xxx_readl(qspi, QSPI_SPI_STATUS_REG);
> +			}
> +			*rxbuf++ =3D dra7xxx_readl(qspi, QSPI_SPI_DATA_REG);
> +			pr_debug("rx done, status %08x, read %02x\n",
> +				status, *(rxbuf-1));

dev_dbg()

> +		}
> +	}
> +
> +	if (flags & XFER_END)
> +		dra7xxx_writel(qspi, qspi->cmd | QSPI_INVAL, QSPI_SPI_CMD_REG);
> +
> +	return 0;
> +}
> +
> +static int dra7xxx_qspi_start_transfer_one(struct spi_master *master,
> +		struct spi_message *m)
> +{
> +	struct dra7xxx_qspi *qspi =3D spi_master_get_devdata(master);
> +	struct spi_device *spi =3D m->spi;
> +	struct spi_transfer *t;
> +	int status =3D 0;
> +	int flags =3D 0;
> +
> +	/* setup command reg */
> +	qspi->cmd =3D 0;
> +	qspi->cmd |=3D QSPI_WLEN(8);
> +	qspi->cmd |=3D QSPI_EN_CS(0);
> +	qspi->cmd |=3D 0xfff;

what is this magic number ???

> +	/* setup device control reg */
> +	qspi->dc =3D 0;
> +
> +	if (spi->mode & SPI_CPHA)
> +		qspi->dc |=3D QSPI_CKPHA(0);
> +	if (spi->mode & SPI_CPOL)
> +		qspi->dc |=3D QSPI_CKPOL(0);
> +	if (spi->mode & SPI_CS_HIGH)
> +		qspi->dc |=3D QSPI_CSPOL(0);
> +
> +	list_for_each_entry(t, &m->transfers, transfer_list) {
> +		if (list_is_last(&t->transfer_list, &m->transfers))
> +			flags =3D XFER_END;
> +
> +		qspi_transfer_msg(qspi, t->len, t->tx_buf,
> +			t->rx_buf, flags);
> +
> +		m->actual_length +=3D t->len;
> +	}
> +	m->status =3D status;
> +	spi_finalize_current_message(master);
> +
> +	return status;
> +}
> +
> +static const struct of_device_id dra7xxx_qspi_match[] =3D {
> +	{.compatible =3D "ti,dra7xxx-qspi" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, dra7xxx_qspi_match);
> +
> +static int dra7xxx_qspi_probe(struct platform_device *pdev)
> +{
> +	struct  dra7xxx_qspi *qspi;
> +	struct spi_master *master;
> +	struct resource         *r;
> +	struct device_node *np =3D pdev->dev.of_node;
> +	u32 max_freq;
> +	int ret;
> +
> +	master =3D spi_alloc_master(&pdev->dev, sizeof(*qspi));
> +	if (!master)
> +		return -ENOMEM;
> +
> +	master->mode_bits =3D SPI_CPOL | SPI_CPHA;
> +
> +	master->num_chipselect =3D 1;
> +	master->bus_num =3D -1;
> +	master->setup =3D dra7xxx_qspi_setup;
> +	master->prepare_transfer_hardware =3D dra7xxx_qspi_prepare_xfer;
> +	master->transfer_one_message =3D dra7xxx_qspi_start_transfer_one;
> +	master->unprepare_transfer_hardware =3D dra7xxx_qspi_unprepare_xfer;
> +	master->dev.of_node =3D pdev->dev.of_node;
> +	master->bits_per_word_mask =3D BIT(32 - 1) | BIT(16 - 1) | BIT(8 - 1);
> +
> +	dev_set_drvdata(&pdev->dev, master);
> +
> +	qspi =3D spi_master_get_devdata(master);
> +	qspi->master =3D master;
> +	qspi->dev =3D &pdev->dev;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (r =3D=3D NULL) {
> +		ret =3D -ENODEV;
> +		goto free_master;
> +	}
> +
> +	qspi->base =3D devm_ioremap_resource(&pdev->dev, r);
> +	if (!qspi->base) {
> +		dev_dbg(&pdev->dev, "can't ioremap MCSPI\n");

no need to print anything, devm_ioremap_resource() already prints error
messages.

--=20
balbi

--pWOmaDnDlrCGjNh4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0pxqAAoJEIaOsuA1yqREhxgQAKxb0WxmsII+8N9AwD1jiiEV
rd4YtcVXxtrXr36+EF8mTbFyX11EPNRFS97wOrMP+mYLTEKwyzGGdV8qCjh+7J1v
KKqJH9uGFCHtGocq8NkHIXq+7+hu4ZfEAljfaYEe56lS29c0FZK2rBwkVnjVNVHo
s7X3umV4lTfn2nxYcgDR7ynVS+6PXe1FkuG7mw3iVnWVEJhjbfhO/xFfoNOBvoar
yTgejwZXrGHDOGo1aCTdfsU/VvGmNF5Qkf8Ek2r9MZHiXBoTKt2eOu/hFgPiNY6x
n3D+l8jdQ/1zlPRnQ54rdMJY+g2BRnFA5LNmx+7Ux2JrdlziU0yiWq3yag3ujXqp
otcrcoCc8TWPSYsvqdENMQkkrZbIF2mpWMF2KEZO8quiYJOYm0zVda/1H+x8Nf5s
CtkHvqfypqmvGo7AT901kkDbFNRVMD3KDwrUc4M7lHhC3vxJO9HTo2Z/zfByZ5vk
kHV7AN8TWWGQgd71K9aHTDW4/VuPLa0TG7WCnidP9Upq8VYQjmpnK1jsCdhGirxS
EZjoohX43Z3rXDpH0KbB2u8z27IxcCN0SAW9myiDVHQwVfLzMBSMbStCVq5lhj3G
FVQaBgAM/jAdMLc3oPvdzy4gJs3BsWQswiMrP/e/5emIH5lv+2jOlVMMWbTb2gbX
NtYWKNtSWgqYIQzJRAWs
=zoy8
-----END PGP SIGNATURE-----

--pWOmaDnDlrCGjNh4--
