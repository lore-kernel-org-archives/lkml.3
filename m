Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaG2XFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:05:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52635 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaG2XFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:05:06 -0400
Message-ID: <53D828A0.1080408@codeaurora.org>
Date: Tue, 29 Jul 2014 16:05:04 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH RFC v2] PM / sleep: Fix racing timers
References: <53D083C5.2000501@linaro.org> <1406322408-15408-1-git-send-email-soren.brinkmann@xilinx.com> <53D6A23A.6010904@codeaurora.org> <53D6A36B.1070105@linaro.org> <53D6A6B3.4060507@codeaurora.org> <d7b265bb-546f-4e86-8e81-197edd1757c5@BN1AFFO11FD007.protection.gbl>
In-Reply-To: <d7b265bb-546f-4e86-8e81-197edd1757c5@BN1AFFO11FD007.protection.gbl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/14 13:02, Sören Brinkmann wrote:
> On Mon, 2014-07-28 at 12:38PM -0700, Stephen Boyd wrote:
>>
>> Agreed. Perhaps I put it the wrong way. I'm worried that some timer
>> needs to run just when we go into suspend. As long as that timer is the
>> scheduler tick we should be ok, but if it isn't the scheduler tick then
>> it would be good to know what it is and why it's pending. Unless the
>> idea is that if we get this far into suspend and there's a pending timer
>> we should just ignore it and go to sleep anyway?
> Well, that is pretty much what happens currently. The IRQs are disabled
> and nobody cares about the pending timer. 

Yep. It sounds like we don't know what it is so let's hope it's the
sched tick. I suspect that driver suspend paths are canceling their
timers because their hardware has been quiesced.

> My problem with that is, that
> "suspend" for Zynq is just waiting in WFI. Hence, the pending interrupts
> causes an immediate resume.
> So, it should hopefully be more or less fine since the current
> implementation basically ignores the timer. With this patch we just shut
> them down a little earlier to prevent this pending interrupt - at least
> that is the intention.
>

That sort of WFI based suspend doesn't actually sound like a memory
suspend at all. It's really the "freeze" state where we would sit in the
deepest CPU idle state waiting for some prescribed wakeup event (power
button press, etc.) that would then trigger a wakeup_source to be
activated and then wakeup the suspend thread.

Unless the WFI actually triggers some power state controller? For
example, on the ARM platforms I have we trigger suspend via a WFI, which
causes a power state controller to pull the power from the CPU that
triggered the WFI and then goes ahead and turns off the rest of the SoC
power and puts the ddr in self-refresh. If we have a pending irq then
the power state controller would abort suspend and we'd come right back
almost immediately (similar to your situation). The thing is we don't
see any pending irqs and we don't have this patch, so I wonder if we
just haven't hit this case, or if there's something more fundamental
going on that causes a difference. Or maybe we do see this pending irq
sometimes but we don't care because we'll try and go right back to
suspend again.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

