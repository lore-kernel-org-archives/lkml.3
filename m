Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3KTTxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:53:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41208 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab3KTTxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:53:12 -0500
Message-ID: <528D1327.7080205@codeaurora.org>
Date: Wed, 20 Nov 2013 11:53:11 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: santosh.shilimkar@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM / Clocks: fix pm_clk_resume/suspend if CONFIG_PM_RUNTIME
 is set
References: <1384954307-27094-1-git-send-email-grygorii.strashko@ti.com> <528D0296.1070001@codeaurora.org> <528D082C.3040405@ti.com>
In-Reply-To: <528D082C.3040405@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13 11:06, Grygorii Strashko wrote:
> On 11/20/2013 08:42 PM, Stephen Boyd wrote:
>> On 11/20/13 05:31, Grygorii Strashko wrote:
>>> @@ -230,7 +230,7 @@ int pm_clk_suspend(struct device *dev)
>>>   	list_for_each_entry_reverse(ce, &psd->clock_list, node) {
>>>   		if (ce->status < PCE_STATUS_ERROR) {
>>>   			if (ce->status == PCE_STATUS_ENABLED)
>>> -				clk_disable(ce->clk);
>>> +				clk_disable_unprepare(ce->clk);
>>>   			ce->status = PCE_STATUS_ACQUIRED;
>>>   		}
>>>   	}
>>> @@ -259,7 +259,7 @@ int pm_clk_resume(struct device *dev)
>>>   
>>>   	list_for_each_entry(ce, &psd->clock_list, node) {
>>>   		if (ce->status < PCE_STATUS_ERROR) {
>>> -			clk_enable(ce->clk);
>>> +			clk_prepare_enable(ce->clk);
>>>   			ce->status = PCE_STATUS_ENABLED;
>>>   		}
>>>   	}
>> This is inside a spin_lock_irqsave(). You should be getting scheduling
>> while atomic warnings with this change. Are you testing with
>> DEBUG_ATOMIC_SLEEP=y?
> Ops, thanks. No, It's not tested with DEBUG_ATOMIC_SLEEP and 
> I agree with you.
>
> So, I see two option here:
> 1) split above loops on two
> 2) add calls of clk_prepare()/clk_unprepare() in pm_clk_notify()
>
> In my opinion option [2] is better.
>

Doesn't that mean the clock will always be prepared as long as the
device is present? That doesn't sound good. I would like the clocks to
be disabled and unprepared as long as the device is suspended.

What is the lock protecting? The linked list or something more? Can we
remove the locks?

It looks like even if you just remove the locks here, the PM core is
free to call this function with irqs disabled if pm_runtime_irq_safe()
has been called on the device. Perhaps runtime PM can only do the
clk_enable()/clk_disable() part and the clk_unprepare()/clk_prepare()
calls should happen in the system suspend callbacks?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

