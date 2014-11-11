Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaKKP1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:27:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59194 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaKKP1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:27:47 -0500
From: "R, Vignesh" <vigneshr@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, "Balbi, Felipe" <balbi@ti.com>,
        "Griffis, Brad" <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: RE: [PATCH v3 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
Thread-Topic: [PATCH v3 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
Thread-Index: AQHP/Yp+gO0+/Ht8MEGJbTH4WilZEJxa/iEAgACMCNA=
Date: Tue, 11 Nov 2014 15:26:19 +0000
Message-ID: <71C24A547111EA4E84AE759B748D9EAE4B976C@DBDE04.ent.ti.com>
References: <1415694844-11230-1-git-send-email-vigneshr@ti.com>
 <1415694844-11230-4-git-send-email-vigneshr@ti.com>
 <20141111122623.GA24004@x1>
In-Reply-To: <20141111122623.GA24004@x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sABFS0FK005660


On Tue, 11 Nov 2014, Vignesh R wrote:

> In one shot mode, sequencer automatically disables all enabled steps 
> at the end of each cycle. (both ADC steps and TSC steps) Hence these 
> steps need not be saved in reg_se_cache for clearing these steps at a 
> later stage.
> Also, when ADC wakes up Sequencer should not be busy executing any of 
> the config steps except for the charge step. Previously charge step 
> was 1 ADC clock cycle and hence it was ignored.
> 
> Signed-off-by: Vignesh R <vigneshr@ti.com>
> ---

You need to provide a changelog here when submitting new versions.

I have included changelog in the cover page. Will include them in 
individual patches next time.

>  drivers/mfd/ti_am335x_tscadc.c       | 7 +++++--
>  include/linux/mfd/ti_am335x_tscadc.h | 1 +
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/ti_am335x_tscadc.c 
> b/drivers/mfd/ti_am335x_tscadc.c index d877e777cce6..110038859a8d 
> 100644
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
> +		WARN_ON((reg & SEQ_STATUS) && !(reg & CHARGE_STEP));
>  		tsadc->adc_waiting = false;
>  	}
>  	tsadc->adc_in_use = true;
> @@ -96,7 +100,6 @@ static void am335x_tscadc_need_adc(struct 
> ti_tscadc_dev *tsadc)  void am335x_tsc_se_set_once(struct 
> ti_tscadc_dev *tsadc, u32 val)  {
>  	spin_lock_irq(&tsadc->reg_lock);
> -	tsadc->reg_se_cache |= val;

You didn't answer my question about this?
I did reply to the question in the previous thread.  

Previously, TSC did not reliably re-enable its steps as the TSC irq handler received 
false pen up events. Hence, in order to use TSC after ADC operation, it was necessary to
 save and re-enable TSC steps (basically, to keep TSC steps enabled always).
The change was more of a workaround to overcome limitation of TSC irq handler. With 
this series of patches, TSC irq handler is very reliable and the workaround is no longer required.

>  	am335x_tscadc_need_adc(tsadc);
>  
>  	tscadc_writel(tsadc, REG_SE, val);
> diff --git a/include/linux/mfd/ti_am335x_tscadc.h 
> b/include/linux/mfd/ti_am335x_tscadc.h
> index c99be5dc0f5c..fcce182e4a35 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h
> @@ -128,6 +128,7 @@
>  
>  /* Sequencer Status */
>  #define SEQ_STATUS BIT(5)
> +#define CHARGE_STEP		0x11
>  
>  #define ADC_CLK			3000000
>  #define TOTAL_STEPS		16

--
Lee Jones
Linaro STMicroelectronics Landing Team Lead Linaro.org â”‚ Open source software for ARM SoCs Follow Linaro: Facebook | Twitter | Blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
