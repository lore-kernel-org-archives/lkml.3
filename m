Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaBGJx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:53:56 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54219 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaBGJxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:53:50 -0500
Message-ID: <1391766753.27491.60.camel@iivanov-dev>
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Andy Gross <agross@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
Date: Fri, 07 Feb 2014 11:52:33 +0200
In-Reply-To: <20140207073952.GA2610@qualcomm.com>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
	 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
	 <20140207073952.GA2610@qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andy,

On Fri, 2014-02-07 at 01:39 -0600, Andy Gross wrote: 
> On Thu, Feb 06, 2014 at 06:57:48PM +0200, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > Qualcomm Universal Peripheral (QUP) core is an AHB slave that
> > provides a common data path (an output FIFO and an input FIFO)
> > for serial peripheral interface (SPI) mini-core. SPI in master mode
> > support up to 50MHz, up to four chip selects, and a programmable
> > data path from 4 bits to 32 bits; MODE0..3 protocols
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > Cc: Alok Chauhan <alokc@codeaurora.org>
> > Cc: Gilad Avidov <gavidov@codeaurora.org>
> > Cc: Kiran Gunda <kgunda@codeaurora.org>
> > Cc: Sagar Dharia <sdharia@codeaurora.org>
> > ---
> >  drivers/spi/Kconfig   |   14 +
> >  drivers/spi/Makefile  |    1 +
> >  drivers/spi/spi-qup.c |  898 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 913 insertions(+)
> >  create mode 100644 drivers/spi/spi-qup.c
> > 
> > diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> > index ba9310b..bf8ce6b 100644
> > --- a/drivers/spi/Kconfig
> > +++ b/drivers/spi/Kconfig
> > @@ -381,6 +381,20 @@ config SPI_RSPI
> >  	help
> >  	  SPI driver for Renesas RSPI blocks.
> >  
> > +config SPI_QUP
> > +	tristate "Qualcomm SPI Support with QUP interface"
> > +	depends on ARCH_MSM
> 
> I'd change to ARCH_MSM_DT.  This ensures the OF component is there.

Ok. will change.

> 
> > +	help
> > +	  Qualcomm Universal Peripheral (QUP) core is an AHB slave that
> > +	  provides a common data path (an output FIFO and an input FIFO)
> > +	  for serial peripheral interface (SPI) mini-core. SPI in master
> > +	  mode support up to 50MHz, up to four chip selects, and a
> > +	  programmable data path from 4 bits to 32 bits; supports numerous
> > +	  protocol variants.
> > +
> > +	  This driver can also be built as a module.  If so, the module
> > +	  will be called spi_qup.
> > +
> >  config SPI_S3C24XX
> >  	tristate "Samsung S3C24XX series SPI"
> >  	depends on ARCH_S3C24XX
> > diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> > index 95af48d..e598147 100644
> > --- a/drivers/spi/Makefile
> > +++ b/drivers/spi/Makefile
> > @@ -59,6 +59,7 @@ spi-pxa2xx-platform-$(CONFIG_SPI_PXA2XX_PXADMA)	+= spi-pxa2xx-pxadma.o
> >  spi-pxa2xx-platform-$(CONFIG_SPI_PXA2XX_DMA)	+= spi-pxa2xx-dma.o
> >  obj-$(CONFIG_SPI_PXA2XX)		+= spi-pxa2xx-platform.o
> >  obj-$(CONFIG_SPI_PXA2XX_PCI)		+= spi-pxa2xx-pci.o
> > +obj-$(CONFIG_SPI_QUP)			+= spi-qup.o
> >  obj-$(CONFIG_SPI_RSPI)			+= spi-rspi.o
> >  obj-$(CONFIG_SPI_S3C24XX)		+= spi-s3c24xx-hw.o
> >  spi-s3c24xx-hw-y			:= spi-s3c24xx.o
> > diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
> > new file mode 100644
> > index 0000000..5eb5e8f
> > --- /dev/null
> > +++ b/drivers/spi/spi-qup.c
> > @@ -0,0 +1,898 @@
> > +/*
> > + * Copyright (c) 2008-2014, The Linux foundation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License rev 2 and
> > + * only rev 2 as published by the free Software foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or fITNESS fOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/delay.h>
> > +#include <linux/err.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/io.h>
> > +#include <linux/list.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pm_runtime.h>
> 
> Remove this for now.  No runtime support.

Did you see any particular issue with the implementation 
or this is just because this platform didn't have support 
for power management?  

> 
> > +#include <linux/spi/spi.h>
> > +

<snip>

> > +
> > +static int spi_qup_transfer_do(struct spi_qup *controller,
> > +			       struct spi_qup_device *chip,
> > +			       struct spi_transfer *xfer)
> > +{
> > +	unsigned long timeout;
> > +	int ret = -EIO;
> > +
> > +	reinit_completion(&controller->done);
> > +
> > +	timeout = DIV_ROUND_UP(controller->speed_hz, MSEC_PER_SEC);
> > +	timeout = DIV_ROUND_UP(xfer->len * 8, timeout);
> > +	timeout = 100 * msecs_to_jiffies(timeout);
> > +
> > +	controller->rx_bytes = 0;
> > +	controller->tx_bytes = 0;
> > +	controller->error = 0;
> > +	controller->xfer = xfer;
> > +
> > +	if (spi_qup_set_state(controller, QUP_STATE_RUN)) {
> > +		dev_warn(controller->dev, "cannot set RUN state\n");
> > +		goto exit;
> > +	}
> > +
> > +	if (spi_qup_set_state(controller, QUP_STATE_PAUSE)) {
> > +		dev_warn(controller->dev, "cannot set PAUSE state\n");
> > +		goto exit;
> > +	}
> > +
> > +	spi_qup_fifo_write(controller, xfer);
> > +
> > +	if (spi_qup_set_state(controller, QUP_STATE_RUN)) {
> > +		dev_warn(controller->dev, "cannot set EXECUTE state\n");
> > +		goto exit;
> > +	}
> > +
> > +	if (!wait_for_completion_timeout(&controller->done, timeout))
> > +		ret = -ETIMEDOUT;
> > +	else
> > +		ret = controller->error;
> > +exit:
> > +	controller->xfer = NULL;
> 
> Should the manipulation of controller->xfer be protected by spinlock?

:-). Probably. I am wondering, could I avoid locking if firstly place
QUP into RESET state and then access these field. This should stop
all activities in it, right?
> 
> > +	controller->error = 0;
> > +	controller->rx_bytes = 0;
> > +	controller->tx_bytes = 0;
> > +	spi_qup_set_state(controller, QUP_STATE_RESET);
> > +	return ret;
> > +}
> > +

<snip>

> > +
> > +/* set clock freq, clock ramp, bits per work */
> > +static int spi_qup_io_setup(struct spi_device *spi,
> > +			  struct spi_transfer *xfer)
> > +{

<snip>

> > +
> > +	/*
> > +	 * TODO: In BAM mode mask INPUT and OUTPUT service flags in
> > +	 * to prevent IRQs on FIFO status change.
> > +	 */
> 
> Remove the TODO.  Not necessary.  This stuff can be added when it becomes BAM
> enabled.

Ok. 

> 
> > +	writel_relaxed(0, controller->base + QUP_OPERATIONAL_MASK);
> > +
> > +	return 0;
> > +}
> > +
> > +static int spi_qup_transfer_one(struct spi_master *master,
> > +				struct spi_message *msg)
> > +{
> > +	struct spi_qup *controller = spi_master_get_devdata(master);
> > +	struct spi_qup_device *chip = spi_get_ctldata(msg->spi);
> > +	struct spi_transfer *xfer;
> > +	struct spi_device *spi;
> > +	unsigned cs_change;
> > +	int status;
> > +
> > +	spi = msg->spi;
> > +	cs_change = 1;
> > +	status = 0;
> > +
> > +	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
> > +
> > +		status = spi_qup_io_setup(spi, xfer);
> > +		if (status)
> > +			break;
> > +
> 
> no locking?  This whole code block needs to have some type of mutex_lock to keep
> others from trouncing the hardware while you are doing this transfer.

This is handled by SPI framework.

> 
> > +		if (cs_change)
> > +			spi_qup_assert_cs(controller, chip);
> 
> Should the CS be done outside the loop?  I'd expect the following sequence to
> happen:
> - change CS
> - Loop and do some transfers
> - deassert CS
> 
> In this code, you reinitialize and assert/deassert CS for every transaction.
> 
> > +
> > +		cs_change = xfer->cs_change;


Not exactly. It is allowed that CS goes inactive after every
transaction. This is how I read struct spi_transfer description.

> > +
> > +		/* Do actual transfer */
> > +		status = spi_qup_transfer_do(controller, chip, xfer);
> > +		if (status)
> > +			break;
> > +
> > +		msg->actual_length += xfer->len;
> > +
> > +		if (xfer->delay_usecs)
> > +			udelay(xfer->delay_usecs);
> > +
> > +		if (cs_change)
> > +			spi_qup_deassert_cs(controller, chip);
> > +	}
> > +
> > +	if (status || !cs_change)
> > +		spi_qup_deassert_cs(controller, chip);
> > +
> > +	msg->status = status;
> > +	spi_finalize_current_message(master);
> > +	return status;
> > +}
> > +
> > +static int spi_qup_probe(struct platform_device *pdev)
> > +{
> > +	struct spi_master *master;
> > +	struct clk *iclk, *cclk;
> > +	struct spi_qup *controller;
> > +	struct resource *res;
> > +	struct device *dev;
> > +	void __iomem *base;
> > +	u32 data, max_freq, iomode;
> > +	int ret, irq, size;
> > +
> > +	dev = &pdev->dev;
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	base = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(base))
> > +		return PTR_ERR(base);
> > +
> > +	irq = platform_get_irq(pdev, 0);
> > +
> > +	if (irq < 0)
> > +		return irq;
> > +
> > +	cclk = devm_clk_get(dev, "core");
> > +	if (IS_ERR(cclk)) {
> > +		dev_err(dev, "cannot get core clock\n");
> No need to error print.  devm_clk_get already outputs something

Ok.

> > +		return PTR_ERR(cclk);
> > +	}
> > +
> > +	iclk = devm_clk_get(dev, "iface");
> > +	if (IS_ERR(iclk)) {
> > +		dev_err(dev, "cannot get iface clock\n");
> 
> No need to error print.  devm_clk_get already outputs something

Ok.

> 
> > +		return PTR_ERR(iclk);
> > +	}
> > +
> > +	if (of_property_read_u32(dev->of_node, "spi-max-frequency", &max_freq))
> > +		max_freq = 19200000;
> 
> I'd set the default to 50MHz as that is the max supported by hardware.  I'd just
> set max_freq declaration to 50MHz and then check the value if it is changed via
> DT.

50MHz doesn't seems to be supported on all chip sets. Currently common
denominator on all chip sets, that I can see, is 19.2MHz. I have tried 
to test it with more than 19.2MHz on APQ8074 and it fails.

> 
> > +
> > +	if (!max_freq) {
> > +		dev_err(dev, "invalid clock frequency %d\n", max_freq);
> > +		return -ENXIO;
> > +	}
> 
> This is buggy.  Remove this and collapse into the of_property_read_u32 if
> statement.  On non-zero, check the range for validity.

True. Will fix.

> 
> > +
> > +	ret = clk_set_rate(cclk, max_freq);
> > +	if (ret)
> > +		dev_warn(dev, "fail to set SPI frequency %d\n", max_freq);
> 
> Bail here?

I don't know. What will be the consequences if controller continue to
operate on its default rate?

> 
> > +
> > +	ret = clk_prepare_enable(cclk);
> > +	if (ret) {
> > +		dev_err(dev, "cannot enable core clock\n");
> > +		return ret;
> > +	}
> > +
> > +	ret = clk_prepare_enable(iclk);
> > +	if (ret) {
> > +		clk_disable_unprepare(cclk);
> > +		dev_err(dev, "cannot enable iface clock\n");
> > +		return ret;
> > +	}
> > +
> > +	data = readl_relaxed(base + QUP_HW_VERSION);
> > +
> > +	if (data < QUP_HW_VERSION_2_1_1) {
> > +		clk_disable_unprepare(cclk);
> > +		clk_disable_unprepare(iclk);
> > +		dev_err(dev, "v.%08x is not supported\n", data);
> > +		return -ENXIO;
> > +	}
> > +
> > +	master = spi_alloc_master(dev, sizeof(struct spi_qup));
> > +	if (!master) {
> > +		clk_disable_unprepare(cclk);
> > +		clk_disable_unprepare(iclk);
> > +		dev_err(dev, "cannot allocate master\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	master->bus_num = pdev->id;
> > +	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
> > +	master->num_chipselect = SPI_NUM_CHIPSELECTS;
> > +	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
> > +	master->setup = spi_qup_setup;
> > +	master->cleanup = spi_qup_cleanup;
> > +	master->transfer_one_message = spi_qup_transfer_one;
> > +	master->dev.of_node = pdev->dev.of_node;
> > +	master->auto_runtime_pm = true;
> 
> Remove this.  No runtime support
> 
> > +
> > +	platform_set_drvdata(pdev, master);
> > +
> > +	controller = spi_master_get_devdata(master);
> > +
> > +	controller->dev  = dev;
> > +	controller->base = base;
> > +	controller->iclk = iclk;
> > +	controller->cclk = cclk;
> > +	controller->irq  = irq;
> > +	controller->max_speed_hz = clk_get_rate(cclk);
> > +	controller->speed_hz = controller->max_speed_hz;
> > +
> > +	init_completion(&controller->done);
> > +
> > +	iomode = readl_relaxed(base + QUP_IO_M_MODES);
> > +
> > +	size = QUP_IO_M_OUTPUT_BLOCK_SIZE(iomode);
> > +	if (size)
> > +		controller->out_blk_sz = size * 16;
> > +	else
> > +		controller->out_blk_sz = 4;
> > +
> > +	size = QUP_IO_M_INPUT_BLOCK_SIZE(iomode);
> > +	if (size)
> > +		controller->in_blk_sz = size * 16;
> > +	else
> > +		controller->in_blk_sz = 4;
> > +
> > +	size = QUP_IO_M_OUTPUT_FIFO_SIZE(iomode);
> > +	controller->out_fifo_sz = controller->out_blk_sz * (2 << size);
> > +
> > +	size = QUP_IO_M_INPUT_FIFO_SIZE(iomode);
> > +	controller->in_fifo_sz = controller->in_blk_sz * (2 << size);
> > +
> > +	dev_info(dev, "v.%08x IN:block:%d, fifo:%d, OUT:block:%d, fifo:%d\n",
> > +		 data, controller->in_blk_sz, controller->in_fifo_sz,
> > +		 controller->out_blk_sz, controller->out_fifo_sz);
> > +
> > +	writel_relaxed(1, base + QUP_SW_RESET);
> > +
> > +	ret = spi_qup_set_state(controller, QUP_STATE_RESET);
> > +	if (ret) {
> > +		dev_err(dev, "cannot set RESET state\n");
> > +		goto error;
> > +	}
> > +
> > +	writel_relaxed(0, base + QUP_OPERATIONAL);
> > +	writel_relaxed(0, base + QUP_IO_M_MODES);
> > +	writel_relaxed(0, base + QUP_OPERATIONAL_MASK);
> > +	writel_relaxed(SPI_ERROR_CLK_UNDER_RUN | SPI_ERROR_CLK_OVER_RUN,
> > +		       base + SPI_ERROR_FLAGS_EN);
> > +
> > +	writel_relaxed(0, base + SPI_CONFIG);
> > +	writel_relaxed(SPI_IO_C_NO_TRI_STATE, base + SPI_IO_CONTROL);
> > +
> > +	ret = devm_request_irq(dev, irq, spi_qup_qup_irq,
> > +			       IRQF_TRIGGER_HIGH, pdev->name, controller);
> > +	if (ret) {
> > +		dev_err(dev, "cannot request IRQ %d\n", irq);
> 
> unnecessary print

Will remove.

> 
> > +		goto error;
> > +	}
> > +
> > +	ret = devm_spi_register_master(dev, master);
> > +	if (!ret) {
> > +		pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
> > +		pm_runtime_use_autosuspend(dev);
> > +		pm_runtime_set_active(dev);
> > +		pm_runtime_enable(dev);
> 
> Remove all the runtime stuff.  not supported right now.
> 
> > +		return ret;
> > +	}
> > +error:
> > +	clk_disable_unprepare(cclk);
> > +	clk_disable_unprepare(iclk);
> > +	spi_master_put(master);
> > +	return ret;
> > +}
> > +

<snip>

> 
> > +
> > +static int spi_qup_remove(struct platform_device *pdev)
> > +{
> > +	struct spi_master *master = dev_get_drvdata(&pdev->dev);
> > +	struct spi_qup *controller = spi_master_get_devdata(master);
> > +
> > +	pm_runtime_get_sync(&pdev->dev);
> > +
> 
> Do we need to wait for any current transactions to complete
> and do a devm_free_irq()?
> 
> > +	clk_disable_unprepare(controller->cclk);
> > +	clk_disable_unprepare(controller->iclk);

My understanding is:

Disabling clocks will timeout transaction, if any. Core Device driver
will call: devm_spi_unregister(), which will wait pending transactions
to complete and then remove the SPI master.

> > +
> > +	pm_runtime_put_noidle(&pdev->dev);
> > +	pm_runtime_disable(&pdev->dev);
> > +	return 0;
> > +}
> > +
> > +static struct of_device_id spi_qup_dt_match[] = {
> > +	{ .compatible = "qcom,spi-qup-v2", },
> 
> Need compatible tags of qcom,spi-qup-v2.1.1 (msm8974 v1) or qcom,spi-qup-v2.2.1
> (msm8974 v2)

I am not aware of the difference. My board report v.20020000. 
Is there difference of handling these controllers?


Thanks, 
Ivan

