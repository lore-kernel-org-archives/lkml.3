Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaBGHj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:39:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41617 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaBGHj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:39:56 -0500
Date: Fri, 7 Feb 2014 01:39:52 -0600
From: Andy Gross <agross@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
Message-ID: <20140207073952.GA2610@qualcomm.com>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 06:57:48PM +0200, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Qualcomm Universal Peripheral (QUP) core is an AHB slave that
> provides a common data path (an output FIFO and an input FIFO)
> for serial peripheral interface (SPI) mini-core. SPI in master mode
> support up to 50MHz, up to four chip selects, and a programmable
> data path from 4 bits to 32 bits; MODE0..3 protocols
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Cc: Alok Chauhan <alokc@codeaurora.org>
> Cc: Gilad Avidov <gavidov@codeaurora.org>
> Cc: Kiran Gunda <kgunda@codeaurora.org>
> Cc: Sagar Dharia <sdharia@codeaurora.org>
> ---
>  drivers/spi/Kconfig   |   14 +
>  drivers/spi/Makefile  |    1 +
>  drivers/spi/spi-qup.c |  898 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 913 insertions(+)
>  create mode 100644 drivers/spi/spi-qup.c
> 
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index ba9310b..bf8ce6b 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -381,6 +381,20 @@ config SPI_RSPI
>  	help
>  	  SPI driver for Renesas RSPI blocks.
>  
> +config SPI_QUP
> +	tristate "Qualcomm SPI Support with QUP interface"
> +	depends on ARCH_MSM

I'd change to ARCH_MSM_DT.  This ensures the OF component is there.

> +	help
> +	  Qualcomm Universal Peripheral (QUP) core is an AHB slave that
> +	  provides a common data path (an output FIFO and an input FIFO)
> +	  for serial peripheral interface (SPI) mini-core. SPI in master
> +	  mode support up to 50MHz, up to four chip selects, and a
> +	  programmable data path from 4 bits to 32 bits; supports numerous
> +	  protocol variants.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called spi_qup.
> +
>  config SPI_S3C24XX
>  	tristate "Samsung S3C24XX series SPI"
>  	depends on ARCH_S3C24XX
> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> index 95af48d..e598147 100644
> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -59,6 +59,7 @@ spi-pxa2xx-platform-$(CONFIG_SPI_PXA2XX_PXADMA)	+= spi-pxa2xx-pxadma.o
>  spi-pxa2xx-platform-$(CONFIG_SPI_PXA2XX_DMA)	+= spi-pxa2xx-dma.o
>  obj-$(CONFIG_SPI_PXA2XX)		+= spi-pxa2xx-platform.o
>  obj-$(CONFIG_SPI_PXA2XX_PCI)		+= spi-pxa2xx-pci.o
> +obj-$(CONFIG_SPI_QUP)			+= spi-qup.o
>  obj-$(CONFIG_SPI_RSPI)			+= spi-rspi.o
>  obj-$(CONFIG_SPI_S3C24XX)		+= spi-s3c24xx-hw.o
>  spi-s3c24xx-hw-y			:= spi-s3c24xx.o
> diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
> new file mode 100644
> index 0000000..5eb5e8f
> --- /dev/null
> +++ b/drivers/spi/spi-qup.c
> @@ -0,0 +1,898 @@
> +/*
> + * Copyright (c) 2008-2014, The Linux foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License rev 2 and
> + * only rev 2 as published by the free Software foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or fITNESS fOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>

Remove this for now.  No runtime support.

> +#include <linux/spi/spi.h>
> +
> +#define QUP_CONFIG			0x0000
> +#define QUP_STATE			0x0004
> +#define QUP_IO_M_MODES			0x0008
> +#define QUP_SW_RESET			0x000c
> +#define QUP_OPERATIONAL			0x0018
> +#define QUP_ERROR_FLAGS			0x001c
> +#define QUP_ERROR_FLAGS_EN		0x0020
> +#define QUP_OPERATIONAL_MASK		0x0028
> +#define QUP_HW_VERSION			0x0030
> +#define QUP_MX_OUTPUT_CNT		0x0100
> +#define QUP_OUTPUT_FIFO			0x0110
> +#define QUP_MX_WRITE_CNT		0x0150
> +#define QUP_MX_INPUT_CNT		0x0200
> +#define QUP_MX_READ_CNT			0x0208
> +#define QUP_INPUT_FIFO			0x0218
> +
> +#define SPI_CONFIG			0x0300
> +#define SPI_IO_CONTROL			0x0304
> +#define SPI_ERROR_FLAGS			0x0308
> +#define SPI_ERROR_FLAGS_EN		0x030c
> +
> +/* QUP_CONFIG fields */
> +#define QUP_CONFIG_SPI_MODE		(1 << 8)
> +#define QUP_CONFIG_NO_INPUT		BIT(7)
> +#define QUP_CONFIG_NO_OUTPUT		BIT(6)
> +#define QUP_CONFIG_N			0x001f
> +
> +/* QUP_STATE fields */
> +#define QUP_STATE_VALID			BIT(2)
> +#define QUP_STATE_RESET			0
> +#define QUP_STATE_RUN			1
> +#define QUP_STATE_PAUSE			3
> +#define QUP_STATE_MASK			3
> +#define QUP_STATE_CLEAR			2
> +
> +#define QUP_HW_VERSION_2_1_1		0x20010001
> +
> +/* QUP_IO_M_MODES fields */
> +#define QUP_IO_M_PACK_EN		BIT(15)
> +#define QUP_IO_M_UNPACK_EN		BIT(14)
> +#define QUP_IO_M_INPUT_MODE_MASK_SHIFT	12
> +#define QUP_IO_M_OUTPUT_MODE_MASK_SHIFT	10
> +#define QUP_IO_M_INPUT_MODE_MASK	(3 << QUP_IO_M_INPUT_MODE_MASK_SHIFT)
> +#define QUP_IO_M_OUTPUT_MODE_MASK	(3 << QUP_IO_M_OUTPUT_MODE_MASK_SHIFT)
> +
> +#define QUP_IO_M_OUTPUT_BLOCK_SIZE(x)	(((x) & (0x03 << 0)) >> 0)
> +#define QUP_IO_M_OUTPUT_FIFO_SIZE(x)	(((x) & (0x07 << 2)) >> 2)
> +#define QUP_IO_M_INPUT_BLOCK_SIZE(x)	(((x) & (0x03 << 5)) >> 5)
> +#define QUP_IO_M_INPUT_FIFO_SIZE(x)	(((x) & (0x07 << 7)) >> 7)
> +
> +#define QUP_IO_M_MODE_FIFO		0
> +#define QUP_IO_M_MODE_BLOCK		1
> +#define QUP_IO_M_MODE_DMOV		2
> +#define QUP_IO_M_MODE_BAM		3
> +
> +/* QUP_OPERATIONAL fields */
> +#define QUP_OP_MAX_INPUT_DONE_FLAG	BIT(11)
> +#define QUP_OP_MAX_OUTPUT_DONE_FLAG	BIT(10)
> +#define QUP_OP_IN_SERVICE_FLAG		BIT(9)
> +#define QUP_OP_OUT_SERVICE_FLAG		BIT(8)
> +#define QUP_OP_IN_FIFO_FULL		BIT(7)
> +#define QUP_OP_OUT_FIFO_FULL		BIT(6)
> +#define QUP_OP_IN_FIFO_NOT_EMPTY	BIT(5)
> +#define QUP_OP_OUT_FIFO_NOT_EMPTY	BIT(4)
> +
> +/* QUP_ERROR_FLAGS and QUP_ERROR_FLAGS_EN fields */
> +#define QUP_ERROR_OUTPUT_OVER_RUN	BIT(5)
> +#define QUP_ERROR_INPUT_UNDER_RUN	BIT(4)
> +#define QUP_ERROR_OUTPUT_UNDER_RUN	BIT(3)
> +#define QUP_ERROR_INPUT_OVER_RUN	BIT(2)
> +
> +/* SPI_CONFIG fields */
> +#define SPI_CONFIG_HS_MODE		BIT(10)
> +#define SPI_CONFIG_INPUT_FIRST		BIT(9)
> +#define SPI_CONFIG_LOOPBACK		BIT(8)
> +
> +/* SPI_IO_CONTROL fields */
> +#define SPI_IO_C_FORCE_CS		BIT(11)
> +#define SPI_IO_C_CLK_IDLE_HIGH		BIT(10)
> +#define SPI_IO_C_MX_CS_MODE		BIT(8)
> +#define SPI_IO_C_CS_N_POLARITY_0	BIT(4)
> +#define SPI_IO_C_CS_SELECT(x)		(((x) & 3) << 2)
> +#define SPI_IO_C_CS_SELECT_MASK		0x000c
> +#define SPI_IO_C_TRISTATE_CS		BIT(1)
> +#define SPI_IO_C_NO_TRI_STATE		BIT(0)
> +
> +/* SPI_ERROR_FLAGS and SPI_ERROR_FLAGS_EN fields */
> +#define SPI_ERROR_CLK_OVER_RUN		BIT(1)
> +#define SPI_ERROR_CLK_UNDER_RUN		BIT(0)
> +
> +#define SPI_NUM_CHIPSELECTS		4
> +
> +/* high speed mode is when bus rate is greater then 26MHz */
> +#define SPI_HS_MIN_RATE			26000000
> +
> +#define SPI_DELAY_THRESHOLD		1
> +#define SPI_DELAY_RETRY			10
> +
> +struct spi_qup_device {
> +	int bits_per_word;
> +	int chip_select;
> +	int speed_hz;
> +	u16 mode;
> +};
> +
> +struct spi_qup {
> +	void __iomem		*base;
> +	struct device		*dev;
> +	struct clk		*cclk;	/* core clock */
> +	struct clk		*iclk;	/* interface clock */
> +	int			irq;
> +	u32			max_speed_hz;
> +	u32			speed_hz;
> +
> +	int			in_fifo_sz;
> +	int			out_fifo_sz;
> +	int			in_blk_sz;
> +	int			out_blk_sz;
> +
> +	struct spi_transfer	*xfer;
> +	struct completion	done;
> +	int			error;
> +	int			bytes_per_word;
> +	int			tx_bytes;
> +	int			rx_bytes;
> +};
> +
> +
> +static inline bool spi_qup_is_valid_state(struct spi_qup *controller)
> +{
> +	u32 opstate = readl_relaxed(controller->base + QUP_STATE);
> +
> +	return opstate & QUP_STATE_VALID;
> +}
> +
> +static int spi_qup_set_state(struct spi_qup *controller, u32 state)
> +{
> +	unsigned long loop = 0;
> +	u32 cur_state;
> +
> +	cur_state = readl_relaxed(controller->base + QUP_STATE);
> +	/*
> +	 * Per spec: for PAUSE_STATE to RESET_STATE, two writes
> +	 * of (b10) are required
> +	 */
> +	if (((cur_state & QUP_STATE_MASK) == QUP_STATE_PAUSE) &&
> +	    (state == QUP_STATE_RESET)) {
> +		writel_relaxed(QUP_STATE_CLEAR, controller->base + QUP_STATE);
> +		writel_relaxed(QUP_STATE_CLEAR, controller->base + QUP_STATE);
> +	} else {
> +		cur_state &= ~QUP_STATE_MASK;
> +		cur_state |= state;
> +		writel_relaxed(cur_state, controller->base + QUP_STATE);
> +	}
> +
> +	while (!spi_qup_is_valid_state(controller)) {
> +
> +		usleep_range(SPI_DELAY_THRESHOLD, SPI_DELAY_THRESHOLD * 2);
> +
> +		if (++loop > SPI_DELAY_RETRY)
> +			return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static void spi_qup_deassert_cs(struct spi_qup *controller,
> +				struct spi_qup_device *chip)
> +{
> +	u32 iocontol, mask;
> +
> +	iocontol = readl_relaxed(controller->base + SPI_IO_CONTROL);
> +
> +	/* Disable auto CS toggle and use manual */
> +	iocontol &= ~SPI_IO_C_MX_CS_MODE;
> +	iocontol |= SPI_IO_C_FORCE_CS;
> +
> +	iocontol &= ~SPI_IO_C_CS_SELECT_MASK;
> +	iocontol |= SPI_IO_C_CS_SELECT(chip->chip_select);
> +
> +	mask = SPI_IO_C_CS_N_POLARITY_0 << chip->chip_select;
> +
> +	if (chip->mode & SPI_CS_HIGH)
> +		iocontol &= ~mask;
> +	else
> +		iocontol |= mask;
> +
> +	writel_relaxed(iocontol, controller->base + SPI_IO_CONTROL);
> +}
> +
> +static void spi_qup_assert_cs(struct spi_qup *controller,
> +			      struct spi_qup_device *chip)
> +{
> +	u32 iocontol, mask;
> +
> +	iocontol = readl_relaxed(controller->base + SPI_IO_CONTROL);
> +
> +	/* Disable auto CS toggle and use manual */
> +	iocontol &= ~SPI_IO_C_MX_CS_MODE;
> +	iocontol |= SPI_IO_C_FORCE_CS;
> +
> +	iocontol &= ~SPI_IO_C_CS_SELECT_MASK;
> +	iocontol |= SPI_IO_C_CS_SELECT(chip->chip_select);
> +
> +	mask = SPI_IO_C_CS_N_POLARITY_0 << chip->chip_select;
> +
> +	if (chip->mode & SPI_CS_HIGH)
> +		iocontol |= mask;
> +	else
> +		iocontol &= ~mask;
> +
> +	writel_relaxed(iocontol, controller->base + SPI_IO_CONTROL);
> +}
> +
> +static void spi_qup_fifo_read(struct spi_qup *controller,
> +			      struct spi_transfer *xfer)
> +{
> +	u8 *rx_buf = xfer->rx_buf;
> +	u32 word, state;
> +	int idx, shift;
> +
> +	while (controller->rx_bytes < xfer->len) {
> +
> +		state = readl_relaxed(controller->base + QUP_OPERATIONAL);
> +		if (0 == (state & QUP_OP_IN_FIFO_NOT_EMPTY))
> +			break;
> +
> +		word = readl_relaxed(controller->base + QUP_INPUT_FIFO);
> +
> +		for (idx = 0; idx < controller->bytes_per_word &&
> +		     controller->rx_bytes < xfer->len; idx++,
> +		     controller->rx_bytes++) {
> +
> +			if (!rx_buf)
> +				continue;
> +			/*
> +			 * The data format depends on bytes_per_word:
> +			 *  4 bytes: 0x12345678
> +			 *  2 bytes: 0x00001234
> +			 *  1 byte : 0x00000012
> +			 */
> +			shift = BITS_PER_BYTE;
> +			shift *= (controller->bytes_per_word - idx - 1);
> +			rx_buf[controller->rx_bytes] = word >> shift;
> +		}
> +	}
> +}
> +
> +static void spi_qup_fifo_write(struct spi_qup *controller,
> +			       struct spi_transfer *xfer)
> +{
> +	const u8 *tx_buf = xfer->tx_buf;
> +	u32 word, state, data;
> +	int idx;
> +
> +	while (controller->tx_bytes < xfer->len) {
> +
> +		state = readl_relaxed(controller->base + QUP_OPERATIONAL);
> +		if (state & QUP_OP_OUT_FIFO_FULL)
> +			break;
> +
> +		word = 0;
> +		for (idx = 0; idx < controller->bytes_per_word &&
> +		     controller->tx_bytes < xfer->len; idx++,
> +		     controller->tx_bytes++) {
> +
> +			if (!tx_buf)
> +				continue;
> +
> +			data = tx_buf[controller->tx_bytes];
> +			word |= data << (BITS_PER_BYTE * (3 - idx));
> +		}
> +
> +		writel_relaxed(word, controller->base + QUP_OUTPUT_FIFO);
> +	}
> +}
> +
> +static irqreturn_t spi_qup_qup_irq(int irq, void *dev_id)
> +{
> +	struct spi_qup *controller = dev_id;
> +	struct spi_transfer *xfer;
> +	u32 opflags, qup_err, spi_err;
> +
> +	xfer = controller->xfer;
> +
> +	qup_err = readl_relaxed(controller->base + QUP_ERROR_FLAGS);
> +	spi_err = readl_relaxed(controller->base + SPI_ERROR_FLAGS);
> +	opflags = readl_relaxed(controller->base + QUP_OPERATIONAL);
> +
> +	writel_relaxed(qup_err, controller->base + QUP_ERROR_FLAGS);
> +	writel_relaxed(spi_err, controller->base + SPI_ERROR_FLAGS);
> +	writel_relaxed(opflags, controller->base + QUP_OPERATIONAL);
> +
> +	if (!xfer)
> +		return IRQ_HANDLED;
> +
> +	if (qup_err) {
> +		if (qup_err & QUP_ERROR_OUTPUT_OVER_RUN)
> +			dev_warn(controller->dev, "OUTPUT_OVER_RUN\n");
> +		if (qup_err & QUP_ERROR_INPUT_UNDER_RUN)
> +			dev_warn(controller->dev, "INPUT_UNDER_RUN\n");
> +		if (qup_err & QUP_ERROR_OUTPUT_UNDER_RUN)
> +			dev_warn(controller->dev, "OUTPUT_UNDER_RUN\n");
> +		if (qup_err & QUP_ERROR_INPUT_OVER_RUN)
> +			dev_warn(controller->dev, "INPUT_OVER_RUN\n");
> +
> +		controller->error = -EIO;
> +	}
> +
> +	if (spi_err) {
> +		if (spi_err & SPI_ERROR_CLK_OVER_RUN)
> +			dev_warn(controller->dev, "CLK_OVER_RUN\n");
> +		if (spi_err & SPI_ERROR_CLK_UNDER_RUN)
> +			dev_warn(controller->dev, "CLK_UNDER_RUN\n");
> +
> +		controller->error = -EIO;
> +	}
> +
> +	if (opflags & QUP_OP_IN_SERVICE_FLAG) {
> +		writel_relaxed(QUP_OP_IN_SERVICE_FLAG,
> +		       controller->base + QUP_OPERATIONAL);
> +		spi_qup_fifo_read(controller, xfer);
> +	}
> +
> +	if (opflags & QUP_OP_OUT_SERVICE_FLAG) {
> +		writel_relaxed(QUP_OP_OUT_SERVICE_FLAG,
> +		       controller->base + QUP_OPERATIONAL);
> +		spi_qup_fifo_write(controller, xfer);
> +	}
> +
> +	if (controller->rx_bytes == xfer->len ||
> +	    controller->error)
> +		complete(&controller->done);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int spi_qup_transfer_do(struct spi_qup *controller,
> +			       struct spi_qup_device *chip,
> +			       struct spi_transfer *xfer)
> +{
> +	unsigned long timeout;
> +	int ret = -EIO;
> +
> +	reinit_completion(&controller->done);
> +
> +	timeout = DIV_ROUND_UP(controller->speed_hz, MSEC_PER_SEC);
> +	timeout = DIV_ROUND_UP(xfer->len * 8, timeout);
> +	timeout = 100 * msecs_to_jiffies(timeout);
> +
> +	controller->rx_bytes = 0;
> +	controller->tx_bytes = 0;
> +	controller->error = 0;
> +	controller->xfer = xfer;
> +
> +	if (spi_qup_set_state(controller, QUP_STATE_RUN)) {
> +		dev_warn(controller->dev, "cannot set RUN state\n");
> +		goto exit;
> +	}
> +
> +	if (spi_qup_set_state(controller, QUP_STATE_PAUSE)) {
> +		dev_warn(controller->dev, "cannot set PAUSE state\n");
> +		goto exit;
> +	}
> +
> +	spi_qup_fifo_write(controller, xfer);
> +
> +	if (spi_qup_set_state(controller, QUP_STATE_RUN)) {
> +		dev_warn(controller->dev, "cannot set EXECUTE state\n");
> +		goto exit;
> +	}
> +
> +	if (!wait_for_completion_timeout(&controller->done, timeout))
> +		ret = -ETIMEDOUT;
> +	else
> +		ret = controller->error;
> +exit:
> +	controller->xfer = NULL;

Should the manipulation of controller->xfer be protected by spinlock?

> +	controller->error = 0;
> +	controller->rx_bytes = 0;
> +	controller->tx_bytes = 0;
> +	spi_qup_set_state(controller, QUP_STATE_RESET);
> +	return ret;
> +}
> +
> +static int spi_qup_setup(struct spi_device *spi)
> +{
> +	struct spi_qup *controller = spi_master_get_devdata(spi->master);
> +	struct spi_qup_device *chip = spi_get_ctldata(spi);
> +
> +	if (spi->chip_select >= spi->master->num_chipselect) {
> +		dev_err(controller->dev, "invalid chip_select %d\n",
> +			spi->chip_select);
> +		return -EINVAL;
> +	}
> +
> +	if (spi->max_speed_hz > controller->max_speed_hz) {
> +		dev_err(controller->dev, "invalid max_speed_hz %d\n",
> +			spi->max_speed_hz);
> +		return -EINVAL;
> +	}
> +
> +	if (!chip) {
> +		/* First setup */
> +		chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> +		if (!chip) {
> +			dev_err(controller->dev, "no memory for chip data\n");
> +			return -ENOMEM;
> +		}
> +
> +		spi_set_ctldata(spi, chip);
> +	}
> +
> +	return 0;
> +}
> +
> +static void spi_qup_cleanup(struct spi_device *spi)
> +{
> +	struct spi_qup_device *chip = spi_get_ctldata(spi);
> +
> +	if (!chip)
> +		return;
> +
> +	spi_set_ctldata(spi, NULL);
> +	kfree(chip);
> +}
> +
> +/* set clock freq, clock ramp, bits per work */
> +static int spi_qup_io_setup(struct spi_device *spi,
> +			  struct spi_transfer *xfer)
> +{
> +	struct spi_qup *controller = spi_master_get_devdata(spi->master);
> +	struct spi_qup_device *chip = spi_get_ctldata(spi);
> +	u32 iocontol, config, iomode, mode;
> +	int ret, n_words;
> +
> +	if (spi->mode & SPI_LOOP && xfer->len > controller->in_fifo_sz) {
> +		dev_err(controller->dev, "too big size for loopback %d > %d\n",
> +			xfer->len, controller->in_fifo_sz);
> +		return -EIO;
> +	}
> +
> +	chip->mode = spi->mode;
> +	chip->speed_hz = spi->max_speed_hz;
> +	if (xfer->speed_hz)
> +		chip->speed_hz = xfer->speed_hz;
> +
> +	if (controller->speed_hz != chip->speed_hz) {
> +		ret = clk_set_rate(controller->cclk, chip->speed_hz);
> +		if (ret) {
> +			dev_err(controller->dev, "fail to set frequency %d",
> +				chip->speed_hz);
> +			return -EIO;
> +		}
> +	}
> +
> +	controller->speed_hz = chip->speed_hz;
> +
> +	chip->bits_per_word = spi->bits_per_word;
> +	if (xfer->bits_per_word)
> +		chip->bits_per_word = xfer->bits_per_word;
> +
> +	if (chip->bits_per_word <= 8)
> +		controller->bytes_per_word = 1;
> +	else if (chip->bits_per_word <= 16)
> +		controller->bytes_per_word = 2;
> +	else
> +		controller->bytes_per_word = 4;
> +
> +	if (controller->bytes_per_word > xfer->len ||
> +	    xfer->len % controller->bytes_per_word != 0){
> +		/* No partial transfers */
> +		dev_err(controller->dev, "invalid len %d for %d bits\n",
> +			xfer->len, chip->bits_per_word);
> +		return -EIO;
> +	}
> +
> +	n_words = xfer->len / controller->bytes_per_word;
> +
> +	if (spi_qup_set_state(controller, QUP_STATE_RESET)) {
> +		dev_err(controller->dev, "cannot set RESET state\n");
> +		return -EIO;
> +	}
> +
> +	if (n_words <= controller->in_fifo_sz) {
> +		mode = QUP_IO_M_MODE_FIFO;
> +		writel_relaxed(n_words, controller->base + QUP_MX_READ_CNT);
> +		writel_relaxed(n_words, controller->base + QUP_MX_WRITE_CNT);
> +		/* must be zero for FIFO */
> +		writel_relaxed(0, controller->base + QUP_MX_INPUT_CNT);
> +		writel_relaxed(0, controller->base + QUP_MX_OUTPUT_CNT);
> +	} else {
> +		mode = QUP_IO_M_MODE_BLOCK;
> +		writel_relaxed(n_words, controller->base + QUP_MX_INPUT_CNT);
> +		writel_relaxed(n_words, controller->base + QUP_MX_OUTPUT_CNT);
> +		/* must be zero for BLOCK and BAM */
> +		writel_relaxed(0, controller->base + QUP_MX_READ_CNT);
> +		writel_relaxed(0, controller->base + QUP_MX_WRITE_CNT);
> +	}
> +
> +	iomode = readl_relaxed(controller->base + QUP_IO_M_MODES);
> +	/* Set input and output transfer mode */
> +	iomode &= ~(QUP_IO_M_INPUT_MODE_MASK | QUP_IO_M_OUTPUT_MODE_MASK);
> +	iomode &= ~(QUP_IO_M_PACK_EN | QUP_IO_M_UNPACK_EN);
> +	iomode |= (mode << QUP_IO_M_OUTPUT_MODE_MASK_SHIFT);
> +	iomode |= (mode << QUP_IO_M_INPUT_MODE_MASK_SHIFT);
> +
> +	writel_relaxed(iomode, controller->base + QUP_IO_M_MODES);
> +
> +	config = readl_relaxed(controller->base + SPI_CONFIG);
> +
> +	if (chip->mode & SPI_LOOP)
> +		config |= SPI_CONFIG_LOOPBACK;
> +	else
> +		config &= ~SPI_CONFIG_LOOPBACK;
> +
> +	if (chip->mode & SPI_CPHA)
> +		config &= ~SPI_CONFIG_INPUT_FIRST;
> +	else
> +		config |= SPI_CONFIG_INPUT_FIRST;
> +
> +	/*
> +	 * HS_MODE improves signal stability for spi-clk high rates
> +	 * but is invalid in loop back mode.
> +	 */
> +	if ((controller->speed_hz >= SPI_HS_MIN_RATE) &&
> +	    !(chip->mode & SPI_LOOP))
> +		config |= SPI_CONFIG_HS_MODE;
> +	else
> +		config &= ~SPI_CONFIG_HS_MODE;
> +
> +	writel_relaxed(config, controller->base + SPI_CONFIG);
> +
> +	config = readl_relaxed(controller->base + QUP_CONFIG);
> +	config &= ~(QUP_CONFIG_NO_INPUT | QUP_CONFIG_NO_OUTPUT | QUP_CONFIG_N);
> +	config |= chip->bits_per_word - 1;
> +	config |= QUP_CONFIG_SPI_MODE;
> +	writel_relaxed(config, controller->base + QUP_CONFIG);
> +
> +	iocontol = readl_relaxed(controller->base + SPI_IO_CONTROL);
> +
> +	/* Disable auto CS toggle */
> +	iocontol &= ~SPI_IO_C_MX_CS_MODE;
> +
> +	if (chip->mode & SPI_CPOL)
> +		iocontol |= SPI_IO_C_CLK_IDLE_HIGH;
> +	else
> +		iocontol &= ~SPI_IO_C_CLK_IDLE_HIGH;
> +
> +	writel_relaxed(iocontol, controller->base + SPI_IO_CONTROL);
> +
> +	/*
> +	 * TODO: In BAM mode mask INPUT and OUTPUT service flags in
> +	 * to prevent IRQs on FIFO status change.
> +	 */

Remove the TODO.  Not necessary.  This stuff can be added when it becomes BAM
enabled.

> +	writel_relaxed(0, controller->base + QUP_OPERATIONAL_MASK);
> +
> +	return 0;
> +}
> +
> +static int spi_qup_transfer_one(struct spi_master *master,
> +				struct spi_message *msg)
> +{
> +	struct spi_qup *controller = spi_master_get_devdata(master);
> +	struct spi_qup_device *chip = spi_get_ctldata(msg->spi);
> +	struct spi_transfer *xfer;
> +	struct spi_device *spi;
> +	unsigned cs_change;
> +	int status;
> +
> +	spi = msg->spi;
> +	cs_change = 1;
> +	status = 0;
> +
> +	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
> +
> +		status = spi_qup_io_setup(spi, xfer);
> +		if (status)
> +			break;
> +

no locking?  This whole code block needs to have some type of mutex_lock to keep
others from trouncing the hardware while you are doing this transfer.

> +		if (cs_change)
> +			spi_qup_assert_cs(controller, chip);

Should the CS be done outside the loop?  I'd expect the following sequence to
happen:
- change CS
- Loop and do some transfers
- deassert CS

In this code, you reinitialize and assert/deassert CS for every transaction.

> +
> +		cs_change = xfer->cs_change;
> +
> +		/* Do actual transfer */
> +		status = spi_qup_transfer_do(controller, chip, xfer);
> +		if (status)
> +			break;
> +
> +		msg->actual_length += xfer->len;
> +
> +		if (xfer->delay_usecs)
> +			udelay(xfer->delay_usecs);
> +
> +		if (cs_change)
> +			spi_qup_deassert_cs(controller, chip);
> +	}
> +
> +	if (status || !cs_change)
> +		spi_qup_deassert_cs(controller, chip);
> +
> +	msg->status = status;
> +	spi_finalize_current_message(master);
> +	return status;
> +}
> +
> +static int spi_qup_probe(struct platform_device *pdev)
> +{
> +	struct spi_master *master;
> +	struct clk *iclk, *cclk;
> +	struct spi_qup *controller;
> +	struct resource *res;
> +	struct device *dev;
> +	void __iomem *base;
> +	u32 data, max_freq, iomode;
> +	int ret, irq, size;
> +
> +	dev = &pdev->dev;
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> +
> +	irq = platform_get_irq(pdev, 0);
> +
> +	if (irq < 0)
> +		return irq;
> +
> +	cclk = devm_clk_get(dev, "core");
> +	if (IS_ERR(cclk)) {
> +		dev_err(dev, "cannot get core clock\n");
No need to error print.  devm_clk_get already outputs something
> +		return PTR_ERR(cclk);
> +	}
> +
> +	iclk = devm_clk_get(dev, "iface");
> +	if (IS_ERR(iclk)) {
> +		dev_err(dev, "cannot get iface clock\n");

No need to error print.  devm_clk_get already outputs something

> +		return PTR_ERR(iclk);
> +	}
> +
> +	if (of_property_read_u32(dev->of_node, "spi-max-frequency", &max_freq))
> +		max_freq = 19200000;

I'd set the default to 50MHz as that is the max supported by hardware.  I'd just
set max_freq declaration to 50MHz and then check the value if it is changed via
DT.

> +
> +	if (!max_freq) {
> +		dev_err(dev, "invalid clock frequency %d\n", max_freq);
> +		return -ENXIO;
> +	}

This is buggy.  Remove this and collapse into the of_property_read_u32 if
statement.  On non-zero, check the range for validity.

> +
> +	ret = clk_set_rate(cclk, max_freq);
> +	if (ret)
> +		dev_warn(dev, "fail to set SPI frequency %d\n", max_freq);

Bail here?

> +
> +	ret = clk_prepare_enable(cclk);
> +	if (ret) {
> +		dev_err(dev, "cannot enable core clock\n");
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(iclk);
> +	if (ret) {
> +		clk_disable_unprepare(cclk);
> +		dev_err(dev, "cannot enable iface clock\n");
> +		return ret;
> +	}
> +
> +	data = readl_relaxed(base + QUP_HW_VERSION);
> +
> +	if (data < QUP_HW_VERSION_2_1_1) {
> +		clk_disable_unprepare(cclk);
> +		clk_disable_unprepare(iclk);
> +		dev_err(dev, "v.%08x is not supported\n", data);
> +		return -ENXIO;
> +	}
> +
> +	master = spi_alloc_master(dev, sizeof(struct spi_qup));
> +	if (!master) {
> +		clk_disable_unprepare(cclk);
> +		clk_disable_unprepare(iclk);
> +		dev_err(dev, "cannot allocate master\n");
> +		return -ENOMEM;
> +	}
> +
> +	master->bus_num = pdev->id;
> +	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
> +	master->num_chipselect = SPI_NUM_CHIPSELECTS;
> +	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
> +	master->setup = spi_qup_setup;
> +	master->cleanup = spi_qup_cleanup;
> +	master->transfer_one_message = spi_qup_transfer_one;
> +	master->dev.of_node = pdev->dev.of_node;
> +	master->auto_runtime_pm = true;

Remove this.  No runtime support

> +
> +	platform_set_drvdata(pdev, master);
> +
> +	controller = spi_master_get_devdata(master);
> +
> +	controller->dev  = dev;
> +	controller->base = base;
> +	controller->iclk = iclk;
> +	controller->cclk = cclk;
> +	controller->irq  = irq;
> +	controller->max_speed_hz = clk_get_rate(cclk);
> +	controller->speed_hz = controller->max_speed_hz;
> +
> +	init_completion(&controller->done);
> +
> +	iomode = readl_relaxed(base + QUP_IO_M_MODES);
> +
> +	size = QUP_IO_M_OUTPUT_BLOCK_SIZE(iomode);
> +	if (size)
> +		controller->out_blk_sz = size * 16;
> +	else
> +		controller->out_blk_sz = 4;
> +
> +	size = QUP_IO_M_INPUT_BLOCK_SIZE(iomode);
> +	if (size)
> +		controller->in_blk_sz = size * 16;
> +	else
> +		controller->in_blk_sz = 4;
> +
> +	size = QUP_IO_M_OUTPUT_FIFO_SIZE(iomode);
> +	controller->out_fifo_sz = controller->out_blk_sz * (2 << size);
> +
> +	size = QUP_IO_M_INPUT_FIFO_SIZE(iomode);
> +	controller->in_fifo_sz = controller->in_blk_sz * (2 << size);
> +
> +	dev_info(dev, "v.%08x IN:block:%d, fifo:%d, OUT:block:%d, fifo:%d\n",
> +		 data, controller->in_blk_sz, controller->in_fifo_sz,
> +		 controller->out_blk_sz, controller->out_fifo_sz);
> +
> +	writel_relaxed(1, base + QUP_SW_RESET);
> +
> +	ret = spi_qup_set_state(controller, QUP_STATE_RESET);
> +	if (ret) {
> +		dev_err(dev, "cannot set RESET state\n");
> +		goto error;
> +	}
> +
> +	writel_relaxed(0, base + QUP_OPERATIONAL);
> +	writel_relaxed(0, base + QUP_IO_M_MODES);
> +	writel_relaxed(0, base + QUP_OPERATIONAL_MASK);
> +	writel_relaxed(SPI_ERROR_CLK_UNDER_RUN | SPI_ERROR_CLK_OVER_RUN,
> +		       base + SPI_ERROR_FLAGS_EN);
> +
> +	writel_relaxed(0, base + SPI_CONFIG);
> +	writel_relaxed(SPI_IO_C_NO_TRI_STATE, base + SPI_IO_CONTROL);
> +
> +	ret = devm_request_irq(dev, irq, spi_qup_qup_irq,
> +			       IRQF_TRIGGER_HIGH, pdev->name, controller);
> +	if (ret) {
> +		dev_err(dev, "cannot request IRQ %d\n", irq);

unnecessary print

> +		goto error;
> +	}
> +
> +	ret = devm_spi_register_master(dev, master);
> +	if (!ret) {
> +		pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
> +		pm_runtime_use_autosuspend(dev);
> +		pm_runtime_set_active(dev);
> +		pm_runtime_enable(dev);

Remove all the runtime stuff.  not supported right now.

> +		return ret;
> +	}
> +error:
> +	clk_disable_unprepare(cclk);
> +	clk_disable_unprepare(iclk);
> +	spi_master_put(master);
> +	return ret;
> +}
> +
> +#ifdef CONFIG_PM_RUNTIME

Remove all the runtime stuff.  not supported right now.

> +static int spi_qup_pm_suspend_runtime(struct device *device)
> +{
> +	struct spi_master *master = dev_get_drvdata(device);
> +	struct spi_qup *controller = spi_master_get_devdata(master);
> +
> +	disable_irq(controller->irq);
> +	clk_disable_unprepare(controller->cclk);
> +	clk_disable_unprepare(controller->iclk);
> +	dev_dbg(device, "suspend runtime\n");
> +	return 0;
> +}
> +
> +static int spi_qup_pm_resume_runtime(struct device *device)
> +{
> +	struct spi_master *master = dev_get_drvdata(device);
> +	struct spi_qup *controller = spi_master_get_devdata(master);
> +
> +	clk_prepare_enable(controller->cclk);
> +	clk_prepare_enable(controller->iclk);
> +	enable_irq(controller->irq);
> +	dev_dbg(device, "resume runtime\n");
> +	return 0;
> +}
> +#endif /* CONFIG_PM_RUNTIME */
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int spi_qup_suspend(struct device *device)
> +{
> +	struct spi_master *master = dev_get_drvdata(device);
> +	struct spi_qup *controller = spi_master_get_devdata(master);
> +	int status;
> +
> +	status = spi_master_suspend(master);
> +	if (!status) {
> +		disable_irq(controller->irq);
> +		clk_disable_unprepare(controller->cclk);
> +		clk_disable_unprepare(controller->iclk);
> +	}
> +
> +	dev_dbg(device, "system suspend %d\n", status);
> +	return status;
> +}

Remove all the suspend/resume stuff.  not supported right now.

> +
> +static int spi_qup_resume(struct device *device)
> +{
> +	struct spi_master *master = dev_get_drvdata(device);
> +	struct spi_qup *controller = spi_master_get_devdata(master);
> +	int status;
> +
> +	clk_prepare_enable(controller->cclk);
> +	clk_prepare_enable(controller->iclk);
> +
> +	status = spi_master_resume(master);
> +
> +	dev_dbg(device, "system resume %d\n", status);
> +	return status;
> +}
> +#endif /* CONFIG_PM_SLEEP */

Remove all the suspend/resume stuff.  not supported right now.

> +
> +static int spi_qup_remove(struct platform_device *pdev)
> +{
> +	struct spi_master *master = dev_get_drvdata(&pdev->dev);
> +	struct spi_qup *controller = spi_master_get_devdata(master);
> +
> +	pm_runtime_get_sync(&pdev->dev);
> +

Do we need to wait for any current transactions to complete
and do a devm_free_irq()?

> +	clk_disable_unprepare(controller->cclk);
> +	clk_disable_unprepare(controller->iclk);
> +
> +	pm_runtime_put_noidle(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +	return 0;
> +}
> +
> +static struct of_device_id spi_qup_dt_match[] = {
> +	{ .compatible = "qcom,spi-qup-v2", },

Need compatible tags of qcom,spi-qup-v2.1.1 (msm8974 v1) or qcom,spi-qup-v2.2.1
(msm8974 v2)

> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, spi_qup_dt_match);
> +
> +static const struct dev_pm_ops spi_qup_dev_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(spi_qup_suspend, spi_qup_resume)
> +	SET_RUNTIME_PM_OPS(spi_qup_pm_suspend_runtime,
> +			   spi_qup_pm_resume_runtime,
> +			   NULL)
> +};

Remove this for now.

> +
> +static struct platform_driver spi_qup_driver = {
> +	.driver = {
> +		.name		= "spi_qup",
> +		.owner		= THIS_MODULE,
> +		.pm		= &spi_qup_dev_pm_ops,
> +		.of_match_table = spi_qup_dt_match,
> +	},
> +	.probe = spi_qup_probe,
> +	.remove = spi_qup_remove,
> +};
> +module_platform_driver(spi_qup_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION("0.4");
> +MODULE_ALIAS("platform:spi_qup");
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
