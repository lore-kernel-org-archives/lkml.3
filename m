Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762503AbaGRWmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:42:51 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56412 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbaGRWmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:42:50 -0400
Message-ID: <53C9A2E7.8020307@linaro.org>
Date: Fri, 18 Jul 2014 15:42:47 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched_clock: Avoid corrupting hrtimer tree during suspend
References: <1405721392-30795-1-git-send-email-sboyd@codeaurora.org> <53C99EC5.2060602@linaro.org> <53C9A1EC.8060905@codeaurora.org>
In-Reply-To: <53C9A1EC.8060905@codeaurora.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 03:38 PM, Stephen Boyd wrote:
> On 07/18/14 15:25, John Stultz wrote:
>> On 07/18/2014 03:09 PM, Stephen Boyd wrote:
>>> During suspend we call sched_clock_poll() to update the epoch and
>>> accumulated time and reprogram the sched_clock_timer to fire
>>> before the next wrap-around time. Unfortunately,
>>> sched_clock_poll() doesn't restart the timer, instead it relies
>>> on the hrtimer layer to do that and during suspend we aren't
>>> calling that function from the hrtimer layer. Instead, we're
>>> reprogramming the expires time while the hrtimer is enqueued,
>>> which can cause the hrtimer tree to be corrupted. Fix this
>>> problem by updating the state via update_sched_clock() and
>>> properly restarting the timer via hrtimer_start().
>>>
>>> Fixes: a08ca5d1089d "sched_clock: Use an hrtimer instead of timer"
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> ---
>>>
>>> I also wonder if we should be restarting the timer during resume
>>> instead of suspend given that the resume path modifies the epoch.
>>> At that point timers can't run because interrupts are disabled and
>>> we don't really care if the timer fires earlier than it's supposed
>>> to anyway because it's just there to avoid rollover events, but
>>> does it seem better to do it that way? I didn't send that version
>>> because this patch is to fix the code intention, but I'm curious
>>> if anyone else feels like it should be changed.
>> Yea, starting the timer on suspend seems unintuitive to me.
>>
>> Is this something you were hoping to get in for 3.17 or is this a urgent
>> 3.16 item?
> Ok I'll send a follow up patch to cancel during suspend and start during
> resume, unless you want that to be part of this fix? It's a regression
> back to v3.13 so I would think it's urgent, although I haven't seen any
> reports on the mailing list, just reports on some of our android kernels.

If its a regression (and needs -stable backports) it needs to go in via
tip/timers/urgent, and not via the regular merge window.

Whats the additional risk -stable wise for canceling the timer during
suspend and starting it back up during resume?

thanks
-john
