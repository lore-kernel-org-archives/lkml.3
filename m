Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3KVTCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:02:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33357 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3KVTB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:01:59 -0500
Message-ID: <528FAA00.9060801@ti.com>
Date: Fri, 22 Nov 2013 14:01:20 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pm@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] PM / Clocks: fix pm_clk_resume/suspend if CONFIG_PM_RUNTIME
 is set
References: <1384954307-27094-1-git-send-email-grygorii.strashko@ti.com> <528D0296.1070001@codeaurora.org> <528D082C.3040405@ti.com> <528D1327.7080205@codeaurora.org> <528D1784.8080704@ti.com> <528D1C49.3020301@ti.com> <87ppps6zve.fsf@linaro.org>
In-Reply-To: <87ppps6zve.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 November 2013 01:43 PM, Kevin Hilman wrote:
> Santosh Shilimkar <santosh.shilimkar@ti.com> writes:
> 
> [...]
> 
>>>> It looks like even if you just remove the locks here, the PM core is
>>>> free to call this function with irqs disabled if pm_runtime_irq_safe()
>>>> has been called on the device. Perhaps runtime PM can only do the
>>>> clk_enable()/clk_disable() part and the clk_unprepare()/clk_prepare()
>>>> calls should happen in the system suspend callbacks?
>>>
>>> Even don't know what to say :( On Keystone clk_unprepare()/clk_prepare() are NOPs.
>>> But clk_prepare() has to be called at least once before clk_enable() :((
>>> So, solution with suspend/resume will not fix current problem :( unfortunately.
>>>
>>> FYI, Now pm_clk_suspend/pm_clk_resume are called from arch/arm/mach-keystone/pm_domain.c
>>> (also similar solution is used by Davinci, but issue has not been detected because
>>> PM runtime hasn't been used by Davinci IP drivers before)
>>>
>> One way to deal with this is to have clk_unprepare()/clk_prepare()
>> called from dev_pm_domain ops before calling pm_clk_[suspend/resume]() if we
>> can't have that as part of runtime code.
> 
> That doesn't solve the irq_safe problem that Stephen pointed out without
> being very careful.  Basically, if you have _any_ potentially sleeping
> calls in this path, you can never allow devices to use
> pm_runtime_irq_safe().
> 
You are right. I realized that after reading the code.

> Also, I don't like having the clk_enable in the PM core but the
> clk_prepare in the platform-specific pm_domain.  That seems prone for
> platforms to get wrong.
> 
Agree.

> I'll need to think about this a little more before having any idea what
> to do here.
> 
Thanks Kevin for looking into it.

Regards,
Santosh

