Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3FDRqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:46:49 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:65117 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3FDRqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:46:48 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: <rtc-linux@googlegroups.com>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-kernel@lists.linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: rtc-twl: ensure IRQ is wakeup enabled
References: <1370039827-25033-1-git-send-email-khilman@linaro.org>
	<51ADD031.2090808@ti.com>
Date: Tue, 04 Jun 2013 10:46:44 -0700
In-Reply-To: <51ADD031.2090808@ti.com> (Grygorii Strashko's message of "Tue, 4
	Jun 2013 14:32:01 +0300")
Message-ID: <877gi94vln.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii Strashko <grygorii.strashko@ti.com> writes:

> Hi Kevin,
>
> On 06/01/2013 01:37 AM, Kevin Hilman wrote:
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
> As I understand, IRQ wake up capabilities are set/clear simultaneously with
> IRQ unmasking/masking on OMAP4+ in omap-wakeupgen.c.
> So, it should work without this patch on OMAP4+.

It might work on OMAP4 for wakeup from suspend, but without properly
declaring the IRQ as a wakeup source, it will not abort suspend if the
RTC fires during the suspend process.  To abort suspend, the IRQ must be
declared as a wakeup IRQ.

> But if TWL is used on non OMAP4+ platform then it is needed.  (OMAP3:
> I haven't found the place where IRQ wakeup capabilities are
> configured, would be appreciate if you can point me on)

IRQ wakeup is a genirq feature that trickles into the irq_chip (in OMAP3
case, it's the twl4030 irq_chip.)

On OMAP3, as mentioned in the changelog, RTC wake has been working fine
without this because we default to CORE retention, so wakeup happens via
the IO ring.  However, if you prevent retention during suspend, then
this IRQ will not wake the system.

Kevin

>>
>> To fix, ensure the RTC IRQ is wakeup enabled whenever the RTC alarm is
>> set.
>>
>> Cc: Alessandro Zummo <a.zummo@towertech.it>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>> ---
>>   drivers/rtc/rtc-twl.c | 16 ++++++++++++++--
>>   1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
>> index 8751a52..bbda0fd 100644
>> --- a/drivers/rtc/rtc-twl.c
>> +++ b/drivers/rtc/rtc-twl.c
>> @@ -213,12 +213,24 @@ static int mask_rtc_irq_bit(unsigned char bit)
>>     static int twl_rtc_alarm_irq_enable(struct device *dev, unsigned
>> enabled)
>>   {
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	int irq = platform_get_irq(pdev, 0);
>> +	static bool twl_rtc_wake_enabled;
>>   	int ret;
>>   -	if (enabled)
>> +	if (enabled) {
>>   		ret = set_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
>> -	else
>> +		if (device_can_wakeup(dev) && !twl_rtc_wake_enabled) {
>> +			enable_irq_wake(irq);
>> +			twl_rtc_wake_enabled = true;
>> +		}
>> +	} else {
>>   		ret = mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
>> +		if (twl_rtc_wake_enabled) {
>> +			disable_irq_wake(irq);
>> +			twl_rtc_wake_enabled = false;
>> +		}
>> +	}
>>     	return ret;
>>   }
> twl-rtc has suspend/resume callbacks implemented, so I think it's the
> better place
> for this code and twl_rtc_wake_enabled can be dropped.

In theory, that might be the better place (and that's where I put these
at first), but unfortunately, it doesn't work that way because the
twl6030-irq core enables/diables the parent IRQ wake feature using PM
notifiers (which was done to avoid potential lock recursion[1].)

During suspend, the notifier runs at suspend_prepare() time, which is
well before the driver's ->suspend() method is called.  The result is
that the parents IRQ wakeup capabilies are never set.

Kevin


[1]
commit ab2b9260df67e29d5bd69d989f2f84f8c2ed4238
Author: Todd Poynor <toddpoynor@google.com>
Date:   Tue Oct 4 11:52:29 2011 +0200

    mfd: Fix twl6030 lockdep recursion warning on setting wake IRQs
    
    LOCKDEP explicitly sets all irq_desc locks as a single lock-class,
    causing "possible recursive locking detected" when the TWL RTC
    driver calls through enable_irq_wake to twl6030_irq_set_wake,
    which recursively calls irq_set_irq_wake.  Although the
    irq_desc and lock are different, LOCKDEP treats these as
    equivalent, presumably due to problems that can be incurred
    when locking more than one irq_desc, so best to avoid this.
    
    Suspend/resume actions implemented as PM notifiers to avoid
    touch the TWL core for this.
    
    Signed-off-by: Todd Poynor <toddpoynor@google.com>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
