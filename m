Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaIXL0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:26:09 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:50484 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIXL0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:26:07 -0400
Date: Wed, 24 Sep 2014 12:26:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Jeff Lance <j-lance1@ti.com>
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: Update logic in CTRL register for
 5-wire TS
Message-ID: <20140924112600.GJ19999@lee--X1>
References: <1409850117-5156-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409850117-5156-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2014, Sebastian Andrzej Siewior wrote:

> From: Jeff Lance <j-lance1@ti.com>
> 
> The logic in AFE_Pen_Ctrl bitmask in the CTRL register is different for five
> wire versus four or eight wire touschscreens. This patch should fix this for
> five-wire touch screens. There should be no change needed here for four and
> eight wire tousch screens.
> 
> Signed-off-by: Jeff Lance <j-lance1@ti.com>
> [bigeasy: keep the change mfd only]
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> I've been looking at moving this piece and the idle mode setting into the
> TSC driver. Kinda odd that I have to patch within the MFD driver for this
> TSC related change.
> Anyone disagrees?
> 
>  drivers/mfd/ti_am335x_tscadc.c       | 30 +++++++++++++++++-------------
>  include/linux/mfd/ti_am335x_tscadc.h |  1 +
>  2 files changed, 18 insertions(+), 13 deletions(-)

I hope this has been fully tested.

Looks like it could work though, so applied, thanks.

> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> index dd4bf5816221..6c9cfb8c1d01 100644
> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -241,18 +241,20 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
>  	tscadc_writel(tscadc, REG_CLKDIV, tscadc->clk_div);
>  
>  	/* Set the control register bits */
> -	ctrl = CNTRLREG_STEPCONFIGWRT |
> -			CNTRLREG_STEPID;
> -	if (tsc_wires > 0)
> -		ctrl |= CNTRLREG_4WIRE | CNTRLREG_TSCENB;
> +	ctrl = CNTRLREG_STEPCONFIGWRT |	CNTRLREG_STEPID;
>  	tscadc_writel(tscadc, REG_CTRL, ctrl);
>  
>  	/* Set register bits for Idle Config Mode */
> -	if (tsc_wires > 0)
> +	if (tsc_wires > 0) {
> +		tscadc->tsc_wires = tsc_wires;
> +		if (tsc_wires == 5)
> +			ctrl |= CNTRLREG_5WIRE | CNTRLREG_TSCENB;
> +		else
> +			ctrl |= CNTRLREG_4WIRE | CNTRLREG_TSCENB;
>  		tscadc_idle_config(tscadc);
> +	}
>  
>  	/* Enable the TSC module enable bit */
> -	ctrl = tscadc_readl(tscadc, REG_CTRL);
>  	ctrl |= CNTRLREG_TSCSSENB;
>  	tscadc_writel(tscadc, REG_CTRL, ctrl);
>  
> @@ -324,21 +326,23 @@ static int tscadc_suspend(struct device *dev)
>  static int tscadc_resume(struct device *dev)
>  {
>  	struct ti_tscadc_dev	*tscadc_dev = dev_get_drvdata(dev);
> -	unsigned int restore, ctrl;
> +	u32 ctrl;
>  
>  	pm_runtime_get_sync(dev);
>  
>  	/* context restore */
>  	ctrl = CNTRLREG_STEPCONFIGWRT |	CNTRLREG_STEPID;
> -	if (tscadc_dev->tsc_cell != -1)
> -		ctrl |= CNTRLREG_TSCENB | CNTRLREG_4WIRE;
>  	tscadc_writel(tscadc_dev, REG_CTRL, ctrl);
>  
> -	if (tscadc_dev->tsc_cell != -1)
> +	if (tscadc_dev->tsc_cell != -1) {
> +		if (tscadc_dev->tsc_wires == 5)
> +			ctrl |= CNTRLREG_5WIRE | CNTRLREG_TSCENB;
> +		else
> +			ctrl |= CNTRLREG_4WIRE | CNTRLREG_TSCENB;
>  		tscadc_idle_config(tscadc_dev);
> -	restore = tscadc_readl(tscadc_dev, REG_CTRL);
> -	tscadc_writel(tscadc_dev, REG_CTRL,
> -			(restore | CNTRLREG_TSCSSENB));
> +	}
> +	ctrl |= CNTRLREG_TSCSSENB;
> +	tscadc_writel(tscadc_dev, REG_CTRL, ctrl);
>  
>  	tscadc_writel(tscadc_dev, REG_CLKDIV, tscadc_dev->clk_div);
>  
> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> index fb96c84dada5..e2e70053470e 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h
> @@ -155,6 +155,7 @@ struct ti_tscadc_dev {
>  	void __iomem *tscadc_base;
>  	int irq;
>  	int used_cells;	/* 1-2 */
> +	int tsc_wires;
>  	int tsc_cell;	/* -1 if not used */
>  	int adc_cell;	/* -1 if not used */
>  	struct mfd_cell cells[TSCADC_CELLS];

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
