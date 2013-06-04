Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab3FDRzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:55:03 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55918 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3FDRy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:54:58 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] rtc: rtc-twl: ensure IRQ is wakeup enabled
References: <1370039827-25033-1-git-send-email-khilman@linaro.org>
	<20130603161303.55e9da049744656541e9048f@linux-foundation.org>
Date: Tue, 04 Jun 2013 10:54:54 -0700
In-Reply-To: <20130603161303.55e9da049744656541e9048f@linux-foundation.org>
	(Andrew Morton's message of "Mon, 3 Jun 2013 16:13:03 -0700")
Message-ID: <87k3m93gnl.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 31 May 2013 15:37:07 -0700 Kevin Hilman <khilman@linaro.org> wrote:
>
>> Currently, the RTC IRQ is never wakeup-enabled so is not capable of
>> bringing the system out of suspend.
>> 
>> On OMAP platforms, we have gotten by without this because the TWL RTC
>> is on an I2C-connected chip which is capable of waking up the OMAP via
>> the IO ring when the OMAP is in low-power states.
>> 
>> However, if the OMAP suspends without hitting the low-power states
>> (and the IO ring is not enabled), RTC wakeups will not work because
>> the IRQ is not wakeup enabled.
>> 
>> To fix, ensure the RTC IRQ is wakeup enabled whenever the RTC alarm is
>> set.
>> 
>> --- a/drivers/rtc/rtc-twl.c
>> +++ b/drivers/rtc/rtc-twl.c
>> @@ -213,12 +213,24 @@ static int mask_rtc_irq_bit(unsigned char bit)
>>  
>>  static int twl_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
>>  {
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	int irq = platform_get_irq(pdev, 0);
>> +	static bool twl_rtc_wake_enabled;
>>  	int ret;
>>  
>> -	if (enabled)
>> +	if (enabled) {
>>  		ret = set_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
>> -	else
>> +		if (device_can_wakeup(dev) && !twl_rtc_wake_enabled) {
>> +			enable_irq_wake(irq);
>> +			twl_rtc_wake_enabled = true;
>> +		}
>> +	} else {
>>  		ret = mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
>> +		if (twl_rtc_wake_enabled) {
>> +			disable_irq_wake(irq);
>> +			twl_rtc_wake_enabled = false;
>> +		}
>> +	}
>
> Why do we need this (slightly racy) logic with twl_rtc_wake_enabled? 
> Other drivers don't do this.

I suspect the other drivers don't do this because they're making these
calls in their suspend/resume callbacks and can make assumptions about 
the order and balance of the calls (e.g. the PM core will not call your
resume callback if your suspend callback hasn't been called.)  What's
being protected against is imbalanced calling of the IRQ wake calls
(e.g. calling disable_irq_wake() on an IRQ where enable_irq_wake() has
not been called.)

In this patch, I'm using the rtc_alarm_irq_enable() function instead of
the suspend/resume functions because of some limitations of parent
device of this one (I described that at the end of a previous reponse to
this thread[1].)  Because of that, I cannot make the same assumptions
about the ordering of enable/disable calls to this function.

> Should we test device_may_wakeup() befre running disable_irq_wake()? 
> Most drivers seem to do this, but it's all a bit foggy.

I suppose I could've added that check too for symmetry, but it would be
redundant because the twl_rtc_wake_enabled flag can only be set when
device_can_wakeup() == true.

Kevin

[1] http://marc.info/?l=linux-omap&m=137036801320665&w=2
