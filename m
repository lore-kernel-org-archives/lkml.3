Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3LSKg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:36:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:51147 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3LSKgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:36:24 -0500
Message-ID: <52B2CC20.8040308@linutronix.de>
Date: Thu, 19 Dec 2013 11:36:16 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mfd: input: iio: ti_amm335x: rework TSC/ADC synchronisation
References: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de> <1387385577-24447-6-git-send-email-bigeasy@linutronix.de> <20131219084206.GC2621@lee--X1>
In-Reply-To: <20131219084206.GC2621@lee--X1>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 09:42 AM, Lee Jones wrote:
> Spell check this entire block.

will do.

> Smileys in commit messages are generally a bad idea.

will drop.

> Please insert '\n's between paragraphs.

Okay.

> Proof read, as some of the sentences are not comprehensible.

I am going to retry.

> /* MFD Parts */
> 
>> --- a/drivers/mfd/ti_am335x_tscadc.c
>> +++ b/drivers/mfd/ti_am335x_tscadc.c
>> @@ -24,6 +24,7 @@
> 
>> -static void am335x_tsc_se_update(struct ti_tscadc_dev *tsadc)
>> +void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val)
>>  {
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&tsadc->reg_lock, flags);
>> +	tsadc->reg_se_cache |= val;
>>  	tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
>> +	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
>>  }
>> +EXPORT_SYMBOL_GPL(am335x_tsc_se_set);
>>  
>> -void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val)
>> +void am335x_tsc_se_tsc_set(struct ti_tscadc_dev *tsadc, u32 val)
> 
> What's the difference between:
> 
> am335x_tsc_se_set()
> and
> am335x_tsc_se_tsc_set()

The code is the same. I tried to avoid to call the function with the
tsc in its name from the adc part. The continuous mode is still using
this interface because its content has to remain while the TSC is
updating the register. Only the write of the ADC in single-shot-mode is
used as a "one-time-thing" and not required later.

> Why don't you have a am335x_tsc_se_tsc_set_tsc_se_tsc_set() ;)
> 
> Perhaps a better function name might be in order.

the am335x_tsc is the namespace. se the register followed by the user
which is tsc or adc but I know what you mean. I will try to replace it
with _cached and _once so we get rid of the part where is twice in the
name of the function.

> 
>>  {
>>  	unsigned long flags;
>>  
>>  	spin_lock_irqsave(&tsadc->reg_lock, flags);
>> -	tsadc->reg_se_cache |= val;
>> -	am335x_tsc_se_update(tsadc);
>> +	tsadc->reg_se_cache = val;
>> +	if (tsadc->adc_in_use || tsadc->adc_waiting) {
>> +		if (tsadc->adc_waiting)
>> +			wake_up(&tsadc->reg_se_wait);
> 
> So if we're either in-use or waiting, the step mask is never set?
> 
> But I guess that the touchscreen driver assumes it has been set.
> 
> Is this okay?

Yes this is okay because the ADC driver is waiting to use it
exclusively. The ADC driver invokes am335x_tsc_se_adc_done() once it is
done so TSC's mask which is saved here will then be written to the
register.

> 
>> +	} else {
>> +		tscadc_writel(tsadc, REG_SE, val);
>> +	}
> 
> I think this would be better represented as:
> 
>         if (tsadc->adc_waiting)
>                 wake_up(&tsadc->reg_se_wait);
>         else if (!tsadc->adc_in_use)
>                 tscadc_writel(tsadc, REG_SE, val);

I think that looks fine. I will double check it and take your proposal
if nothing goes wrong.

Sebastian
