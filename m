Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaJTCBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 22:01:25 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:22633 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751187AbaJTCBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 22:01:23 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Kevin Hilman <khilman@kernel.org>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] spi/atmel: add support for runtime PM
Thread-Topic: [PATCH] spi/atmel: add support for runtime PM
Thread-Index: AQHP6OOz3LvTFspzlkWsWVFQ1Yxkwpw0Q30ogAP5RlA=
Date: Mon, 20 Oct 2014 01:59:05 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BF592EF5@penmbx01>
References: <1413424160-21180-1-git-send-email-wenyou.yang@atmel.com>
 <7hk33yhms4.fsf@deeprootsystems.com>
In-Reply-To: <7hk33yhms4.fsf@deeprootsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kevin Hilman [mailto:khilman@kernel.org]
> Sent: Friday, October 17, 2014 9:03 PM
> To: Yang, Wenyou
> Cc: broonie@kernel.org; linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org;
> Ferre, Nicolas; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] spi/atmel: add support for runtime PM
> 
> Wenyou Yang <wenyou.yang@atmel.com> writes:
> 
> > Drivers should put the device into low power states proactively
> > whenever the device is not in use. Thus implement support for runtime
> > PM and use the autosuspend feature to make sure that we can still
> > perform well in case we see lots of SPI traffic within short period of time.
> >
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > ---
> >  drivers/spi/spi-atmel.c |   62
> +++++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 55 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c index
> > 649dcb5..aca285e 100644
> > --- a/drivers/spi/spi-atmel.c
> > +++ b/drivers/spi/spi-atmel.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/io.h>
> >  #include <linux/gpio.h>
> >  #include <linux/pinctrl/consumer.h>
> > +#include <linux/pm_runtime.h>
> >
> >  /* SPI register offsets */
> >  #define SPI_CR					0x0000
> > @@ -191,6 +192,8 @@
> >
> >  #define SPI_DMA_TIMEOUT		(msecs_to_jiffies(1000))
> >
> > +#define AUTOSUSPEND_TIMEOUT	2000
> > +
> >  struct atmel_spi_dma {
> >  	struct dma_chan			*chan_rx;
> >  	struct dma_chan			*chan_tx;
> > @@ -1313,6 +1316,7 @@ static int atmel_spi_probe(struct platform_device
> *pdev)
> >  	master->setup = atmel_spi_setup;
> >  	master->transfer_one_message = atmel_spi_transfer_one_message;
> >  	master->cleanup = atmel_spi_cleanup;
> > +	master->auto_runtime_pm = true;
> >  	platform_set_drvdata(pdev, master);
> >
> >  	as = spi_master_get_devdata(master); @@ -1385,6 +1389,11 @@ static
> > int atmel_spi_probe(struct platform_device *pdev)
> >  	dev_info(&pdev->dev, "Atmel SPI Controller at 0x%08lx (irq %d)\n",
> >  			(unsigned long)regs->start, irq);
> >
> > +	pm_runtime_set_autosuspend_delay(&pdev->dev,
> AUTOSUSPEND_TIMEOUT);
> > +	pm_runtime_use_autosuspend(&pdev->dev);
> > +	pm_runtime_set_active(&pdev->dev);
> > +	pm_runtime_enable(&pdev->dev);
> > +
> >  	ret = devm_spi_register_master(&pdev->dev, master);
> >  	if (ret)
> >  		goto out_free_dma;
> > @@ -1392,6 +1401,9 @@ static int atmel_spi_probe(struct platform_device
> *pdev)
> >  	return 0;
> >
> >  out_free_dma:
> > +	pm_runtime_disable(&pdev->dev);
> > +	pm_runtime_set_suspended(&pdev->dev);
> > +
> >  	if (as->use_dma)
> >  		atmel_spi_release_dma(as);
> >
> > @@ -1413,6 +1425,8 @@ static int atmel_spi_remove(struct platform_device
> *pdev)
> >  	struct spi_master	*master = platform_get_drvdata(pdev);
> >  	struct atmel_spi	*as = spi_master_get_devdata(master);
> >
> > +	pm_runtime_get_sync(&pdev->dev);
> > +
> >  	/* reset the hardware and block queue progress */
> >  	spin_lock_irq(&as->lock);
> >  	if (as->use_dma) {
> > @@ -1430,9 +1444,13 @@ static int atmel_spi_remove(struct
> > platform_device *pdev)
> >
> >  	clk_disable_unprepare(as->clk);
> >
> > +	pm_runtime_put_noidle(&pdev->dev);
> 
> Why the _noidle version?
 Because invoked from the _remove function, only decrement the device's usage counter, no further idle operation need.

> 
> > +	pm_runtime_disable(&pdev->dev);
> > +
> >  	return 0;
> >  }
> >
> > +#ifdef CONFIG_PM
> 
> Why CONFIG_PM?  CONFIG_PM_SLEEP  causes CONFIG_PM=y, so this seems
> redundant.
Accepted, I will remove it.

> 
> >  #ifdef CONFIG_PM_SLEEP
> >  static int atmel_spi_suspend(struct device *dev)  { @@ -1447,9
> > +1465,10 @@ static int atmel_spi_suspend(struct device *dev)
> >  		return ret;
> >  	}
> >
> > -	clk_disable_unprepare(as->clk);
> > -
> > -	pinctrl_pm_select_sleep_state(dev);
> > +	if (!pm_runtime_suspended(dev)) {
> > +		clk_disable_unprepare(as->clk);
> > +		pinctrl_pm_select_sleep_state(dev);
> > +	}
> 
> a.k.a. pm_runtime_put_sync() since the ->runtime_suspend() callback does the
> same thing.
> 
> >  	return 0;
> >  }
> > @@ -1460,9 +1479,10 @@ static int atmel_spi_resume(struct device *dev)
> >  	struct atmel_spi	*as = spi_master_get_devdata(master);
> >  	int ret;
> >
> > -	pinctrl_pm_select_default_state(dev);
> > -
> > -	clk_prepare_enable(as->clk);
> > +	if (!pm_runtime_suspended(dev)) {
> > +		pinctrl_pm_select_default_state(dev);
> > +		clk_prepare_enable(as->clk);
> > +	}
> 
> a.k.a. pm_runtime_get_sync()
> 
> Kevin
> 
> >  	/* Start the queue running */
> >  	ret = spi_master_resume(master);
> > @@ -1471,9 +1491,37 @@ static int atmel_spi_resume(struct device *dev)
> >
> >  	return ret;
> >  }
> > +#endif
> >
> > -static SIMPLE_DEV_PM_OPS(atmel_spi_pm_ops, atmel_spi_suspend,
> > atmel_spi_resume);
> > +#ifdef CONFIG_PM_RUNTIME
> > +static int atmel_spi_runtime_suspend(struct device *dev) {
> > +	struct spi_master *master = dev_get_drvdata(dev);
> > +	struct atmel_spi *as = spi_master_get_devdata(master);
> >
> > +	clk_disable_unprepare(as->clk);
> > +	pinctrl_pm_select_sleep_state(dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static int atmel_spi_runtime_resume(struct device *dev) {
> > +	struct spi_master *master = dev_get_drvdata(dev);
> > +	struct atmel_spi *as = spi_master_get_devdata(master);
> > +
> > +	pinctrl_pm_select_default_state(dev);
> > +	clk_prepare_enable(as->clk);
> > +
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static const struct dev_pm_ops atmel_spi_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(atmel_spi_suspend, atmel_spi_resume)
> > +	SET_RUNTIME_PM_OPS(atmel_spi_runtime_suspend,
> > +			   atmel_spi_runtime_resume, NULL) };
> >  #define ATMEL_SPI_PM_OPS	(&atmel_spi_pm_ops)
> >  #else
> >  #define ATMEL_SPI_PM_OPS	NULL

Best Regards,
Wenyou Yang
