Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaKCPFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:05:40 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57834 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaKCPFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:05:35 -0500
Date: Mon, 3 Nov 2014 15:05:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Vignesh R <vigneshr@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jan Kardell <jan.kardell@telliq.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Brad Griffis <bgriffis@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 2/4] input: touchscreen: ti_am335x_tsc: Remove udelay in
 interrupt handler
Message-ID: <20141103150526.GI4538@x1>
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
 <1414408111-2631-3-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414408111-2631-3-git-send-email-vigneshr@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Vignesh R wrote:
> From: Brad Griffis <bgriffis@ti.com>
> 
> TSC interrupt handler had udelay to avoid reporting of false pen-up
> interrupt to user space. This patch implements workaround suggesting in
> Advisory 1.0.31 of silicon errata for am335x, thus eliminating udelay
> and touchscreen lag. This also improves performance of touchscreen and
> eliminates sudden jump of cursor at touch release.
> 
> IDLECONFIG and CHARGECONFIG registers are to be configured
> with same values in order to eliminate false pen-up events. This
> workaround may result in false pen-down to be detected, hence considerable
> charge step delay needs to be added. The charge delay is set to 0xB000
> (in terms of ADC clock cycles) by default.
> 
> TSC steps are disabled at the end of every sampling cycle and EOS bit is
> set. Once the EOS bit is set, the TSC steps need to be re-enabled to begin
> next sampling cycle.
> 
> In one shot mode, sequencer automatically disables all enabled steps at
> the end of each cycle. (both ADC steps and TSC steps) Hence these steps
> need not be saved in reg_se_cache for clearing these steps at a later
> stage.
> 
> Signed-off-by: Brad Griffis <bgriffis@ti.com>
> [vigneshr@ti.com: Ported patch from v3.12 to v3.18rc2]
> Signed-off-by: Vignesh R <vigneshr@ti.com>
> ---
>  drivers/input/touchscreen/ti_am335x_tsc.c | 56 ++++++++++++-------------------
>  drivers/mfd/ti_am335x_tscadc.c            |  7 ++--
>  include/linux/mfd/ti_am335x_tscadc.h      |  4 ++-
>  3 files changed, 30 insertions(+), 37 deletions(-)

[...]

> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> index d877e777cce6..94ef8992f46b 100644
> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -86,8 +86,12 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
>  		spin_lock_irq(&tsadc->reg_lock);
>  		finish_wait(&tsadc->reg_se_wait, &wait);
>  
> +		/*
> +		 * Sequencer should either be idle or
> +		 * busy applying the charge step.
> +		 */
>  		reg = tscadc_readl(tsadc, REG_ADCFSM);
> -		WARN_ON(reg & SEQ_STATUS);
> +		WARN_ON(reg & SEQ_STATUS & (!CHARGE_STEP));
>  		tsadc->adc_waiting = false;
>  	}
>  	tsadc->adc_in_use = true;
> @@ -96,7 +100,6 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
>  void am335x_tsc_se_set_once(struct ti_tscadc_dev *tsadc, u32 val)
>  {
>  	spin_lock_irq(&tsadc->reg_lock);
> -	tsadc->reg_se_cache |= val;
>  	am335x_tscadc_need_adc(tsadc);
>  
>  	tscadc_writel(tsadc, REG_SE, val);

I believe all of these changes can, and therefor should live in a
separate patch.

> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> index e2e70053470e..fcce182e4a35 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h
> @@ -52,6 +52,7 @@
>  
>  /* IRQ enable */
>  #define IRQENB_HW_PEN		BIT(0)
> +#define IRQENB_EOS		BIT(1)
>  #define IRQENB_FIFO0THRES	BIT(2)
>  #define IRQENB_FIFO0OVRRUN	BIT(3)
>  #define IRQENB_FIFO0UNDRFLW	BIT(4)
> @@ -107,7 +108,7 @@
>  /* Charge delay */
>  #define CHARGEDLY_OPEN_MASK	(0x3FFFF << 0)
>  #define CHARGEDLY_OPEN(val)	((val) << 0)
> -#define CHARGEDLY_OPENDLY	CHARGEDLY_OPEN(1)
> +#define CHARGEDLY_OPENDLY	CHARGEDLY_OPEN(0xB000)
>  
>  /* Control register */
>  #define CNTRLREG_TSCSSENB	BIT(0)
> @@ -127,6 +128,7 @@
>  
>  /* Sequencer Status */
>  #define SEQ_STATUS BIT(5)
> +#define CHARGE_STEP		0x11
>  
>  #define ADC_CLK			3000000
>  #define TOTAL_STEPS		16

The header changes should be split between the two Input and MFD
patches.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
