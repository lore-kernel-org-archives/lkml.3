Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3KTUcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:32:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57872 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973Ab3KTUcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:32:43 -0500
Message-ID: <528D1C49.3020301@ti.com>
Date: Wed, 20 Nov 2013 15:32:09 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Stephen Boyd <sboyd@codeaurora.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pm@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] PM / Clocks: fix pm_clk_resume/suspend if CONFIG_PM_RUNTIME
 is set
References: <1384954307-27094-1-git-send-email-grygorii.strashko@ti.com> <528D0296.1070001@codeaurora.org> <528D082C.3040405@ti.com> <528D1327.7080205@codeaurora.org> <528D1784.8080704@ti.com>
In-Reply-To: <528D1784.8080704@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Kevin and Rafiel,

On Wednesday 20 November 2013 03:11 PM, Grygorii Strashko wrote:
> On 11/20/2013 09:53 PM, Stephen Boyd wrote:
>> On 11/20/13 11:06, Grygorii Strashko wrote:
>>> On 11/20/2013 08:42 PM, Stephen Boyd wrote:
>>>> On 11/20/13 05:31, Grygorii Strashko wrote:
>>>>> @@ -230,7 +230,7 @@ int pm_clk_suspend(struct device *dev)
>>>>>    	list_for_each_entry_reverse(ce, &psd->clock_list, node) {
>>>>>    		if (ce->status < PCE_STATUS_ERROR) {
>>>>>    			if (ce->status == PCE_STATUS_ENABLED)
>>>>> -				clk_disable(ce->clk);
>>>>> +				clk_disable_unprepare(ce->clk);
>>>>>    			ce->status = PCE_STATUS_ACQUIRED;
>>>>>    		}
>>>>>    	}
>>>>> @@ -259,7 +259,7 @@ int pm_clk_resume(struct device *dev)
>>>>>    
>>>>>    	list_for_each_entry(ce, &psd->clock_list, node) {
>>>>>    		if (ce->status < PCE_STATUS_ERROR) {
>>>>> -			clk_enable(ce->clk);
>>>>> +			clk_prepare_enable(ce->clk);
>>>>>    			ce->status = PCE_STATUS_ENABLED;
>>>>>    		}
>>>>>    	}
>>>> This is inside a spin_lock_irqsave(). You should be getting scheduling
>>>> while atomic warnings with this change. Are you testing with
>>>> DEBUG_ATOMIC_SLEEP=y?
>>> Ops, thanks. No, It's not tested with DEBUG_ATOMIC_SLEEP and
>>> I agree with you.
>>>
I suspected this and thats what I was trying to mention off-list
about sleeping inside locks.

>>> So, I see two option here:
>>> 1) split above loops on two
>>> 2) add calls of clk_prepare()/clk_unprepare() in pm_clk_notify()
>>>
>>> In my opinion option [2] is better.
>>>
>>
>> Doesn't that mean the clock will always be prepared as long as the
>> device is present? That doesn't sound good. I would like the clocks to
>> be disabled and unprepared as long as the device is suspended.
> 
> Yep (
> 
>>
>> What is the lock protecting? The linked list or something more? Can we
>> remove the locks?
> 
> Looks like it's protecting linked list pm_clock_entry'es.
> 
>>
>> It looks like even if you just remove the locks here, the PM core is
>> free to call this function with irqs disabled if pm_runtime_irq_safe()
>> has been called on the device. Perhaps runtime PM can only do the
>> clk_enable()/clk_disable() part and the clk_unprepare()/clk_prepare()
>> calls should happen in the system suspend callbacks?
> 
> Even don't know what to say :( On Keystone clk_unprepare()/clk_prepare() are NOPs.
> But clk_prepare() has to be called at least once before clk_enable() :((
> So, solution with suspend/resume will not fix current problem :( unfortunately.
> 
> FYI, Now pm_clk_suspend/pm_clk_resume are called from arch/arm/mach-keystone/pm_domain.c
> (also similar solution is used by Davinci, but issue has not been detected because
> PM runtime hasn't been used by Davinci IP drivers before)
> 
One way to deal with this is to have clk_unprepare()/clk_prepare()
called from dev_pm_domain ops before calling pm_clk_[suspend/resume]() if we
can't have that as part of runtime code.

Kevin/Rafael might have better ideas here.

Regards,
Santosh

