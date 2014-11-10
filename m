Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaKJKqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:46:10 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60653 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbaKJKqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:46:06 -0500
Message-ID: <54609725.9080608@ti.com>
Date: Mon, 10 Nov 2014 16:14:53 +0530
From: Vignesh R <vigneshr@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: Re: [PATCH 3/5] mfd: ti_am335x_tscadc: Remove unwanted reg_se_cache
 save
References: <1415339350-17679-1-git-send-email-vigneshr@ti.com> <1415339350-17679-4-git-send-email-vigneshr@ti.com> <20141110091527.GD21424@x1> <20141110092645.GE21424@x1>
In-Reply-To: <20141110092645.GE21424@x1>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 10 November 2014 02:56 PM, Lee Jones wrote:
> On Mon, 10 Nov 2014, Lee Jones wrote:
> 
>> On Fri, 07 Nov 2014, Vignesh R wrote:
>>
>>> In one shot mode, sequencer automatically disables all enabled steps at
>>> the end of each cycle. (both ADC steps and TSC steps) Hence these steps
>>> need not be saved in reg_se_cache for clearing these steps at a later
>>> stage.
>>> Also, when ADC wakes up Sequencer should not be busy executing any of the
>>> config steps except for the charge step. Previously charge step was 1 ADC
>>> clock cycle and hence it was ignored.
>>>
>>> Signed-off-by: Vignesh R <vigneshr@ti.com>
>>> ---
>>>  drivers/mfd/ti_am335x_tscadc.c       | 7 +++++--
>>>  include/linux/mfd/ti_am335x_tscadc.h | 1 +
>>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
>>> index d877e777cce6..94ef8992f46b 100644
>>> --- a/drivers/mfd/ti_am335x_tscadc.c
>>> +++ b/drivers/mfd/ti_am335x_tscadc.c
>>> @@ -86,8 +86,12 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
>>>  		spin_lock_irq(&tsadc->reg_lock);
>>>  		finish_wait(&tsadc->reg_se_wait, &wait);
>>>  
>>> +		/*
>>> +		 * Sequencer should either be idle or
>>> +		 * busy applying the charge step.
>>> +		 */
>>>  		reg = tscadc_readl(tsadc, REG_ADCFSM);
>>> -		WARN_ON(reg & SEQ_STATUS);
>>> +		WARN_ON(reg & SEQ_STATUS & (!CHARGE_STEP));
>>
>> This is almost certainly not correct.
>>
>> Please take another look at the logic.
>>
>> I'm _assuming_ you mean (reg & SEQ_STATUS && !CHARGE_STEP).
> 
> So I just saw that CHARGE_STEP is actually the new macro below.
> 
> So you're currently ANDing these together.
> 
> xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx  reg
> 00000000 00000000 00000000 00100000  #define SEQ_STATUS   BIT(5)
> 00000000 00000000 00000000 00010001  #define CHARGE_STEP  0x11
> 
> ... which will always equate to 0.
> 

Oops.. Sorry.. I meant ((reg & SEQ_STATUS) && !(reg & CHARGE_STEP)).
I will fix this.


>>>  		tsadc->adc_waiting = false;
>>>  	}
>>>  	tsadc->adc_in_use = true;
>>> @@ -96,7 +100,6 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
>>>  void am335x_tsc_se_set_once(struct ti_tscadc_dev *tsadc, u32 val)
>>>  {
>>>  	spin_lock_irq(&tsadc->reg_lock);
>>> -	tsadc->reg_se_cache |= val;
> 
> Didn't you add this line a little over 1 month ago?
> 
> Why the change of heart?
> 

Previously, TSC did not reliably re-enable its steps as the TSC irq
handler received false pen up events. Hence, in order to use TSC after
ADC operation, it was necessary to save and re-enable TSC steps
(basically, to keep TSC steps enabled always).
The change was more of a workaround to overcome limitation of TSC irq
handler. With this series of patches, TSC irq handler is very reliable
and the workaround is no longer required.

>>>  	am335x_tscadc_need_adc(tsadc);
>>>  
>>>  	tscadc_writel(tsadc, REG_SE, val);
>>> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
>>> index c99be5dc0f5c..fcce182e4a35 100644
>>> --- a/include/linux/mfd/ti_am335x_tscadc.h
>>> +++ b/include/linux/mfd/ti_am335x_tscadc.h
>>> @@ -128,6 +128,7 @@
>>>  
>>>  /* Sequencer Status */
>>>  #define SEQ_STATUS BIT(5)
>>> +#define CHARGE_STEP		0x11
>>>  
>>>  #define ADC_CLK			3000000
>>>  #define TOTAL_STEPS		16
>>
> 
