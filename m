Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaG1Tib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:38:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50634 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaG1Ti3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:38:29 -0400
Message-ID: <53D6A6B3.4060507@codeaurora.org>
Date: Mon, 28 Jul 2014 12:38:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH RFC v2] PM / sleep: Fix racing timers
References: <53D083C5.2000501@linaro.org> <1406322408-15408-1-git-send-email-soren.brinkmann@xilinx.com> <53D6A23A.6010904@codeaurora.org> <53D6A36B.1070105@linaro.org>
In-Reply-To: <53D6A36B.1070105@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/14 12:24, John Stultz wrote:
> On 07/28/2014 12:19 PM, Stephen Boyd wrote:
>> On 07/25/14 14:06, Soren Brinkmann wrote:
>>> On platforms that do not power off during suspend, successfully entering
>>> suspend races with timers.
>>>
>>> The race happening in a couple of location is:
>>>
>>>   1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
>>>      ...
>>>   2. syscore_suspend()
>>>       -> timekeeping_suspend()
>>>        -> clockevents_notify(SUSPEND)
>>>         -> tick_suspend()   	(timers are turned off here)
>>>      ...
>>>   3. wfi            		(wait for wake-IRQ here)
>>>
>>> Between steps 1 and 2 the timers can still generate interrupts that are
>>> not handled and stay pending until step 3. That pending IRQ causes an
>>> immediate - spurious - wake.
>>>
>>> The solution is to move the clockevents suspend/resume notification
>>> out of the syscore_suspend step and explictly call them at the appropriate
>>> time in the suspend/hibernation paths. I.e. timers are suspend _before_
>>> IRQs get disabled. And accordingly in the resume path.
>>>
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> Do we know which timer_list or hrtimer wants to run while entering
>> suspend? I'd suspect the scheduler tick but perhaps we just forgot to
>> cancel some timer during suspend?
> Though, canceling timers really shouldn't be necessary for
> suspend/resume, no?
>
>

Agreed. Perhaps I put it the wrong way. I'm worried that some timer
needs to run just when we go into suspend. As long as that timer is the
scheduler tick we should be ok, but if it isn't the scheduler tick then
it would be good to know what it is and why it's pending. Unless the
idea is that if we get this far into suspend and there's a pending timer
we should just ignore it and go to sleep anyway?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

