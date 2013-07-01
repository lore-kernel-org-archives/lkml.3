Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3GATuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:50:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58019 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3GATuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:50:06 -0400
Message-ID: <51D1DD6D.8050805@codeaurora.org>
Date: Mon, 01 Jul 2013 12:50:05 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Stehle Vincent-B46079 <B46079@freescale.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: next-20130627 breaks i.MX6 sabre sd UART console
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de> <51CDB26A.9060500@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net> <51CDC2B3.1030907@codeaurora.org> <20130629020738.GG11625@codeaurora.org> <F7C43F8B2814514CA05F3436BC68046EF2EF29@039-SN2MPN1-011.039d.mgd.msft.net> <alpine.DEB.2.02.1307011425500.4013@ionos.tec.linutronix.de> <F7C43F8B2814514CA05F3436BC68046EF2F708@039-SN2MPN1-011.039d.mgd.msft.net> <alpine.DEB.2.02.1307011531210.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307011531210.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/13 10:49, Thomas Gleixner wrote:
> On Mon, 1 Jul 2013, Stehle Vincent-B46079 wrote:
>
>> From: Thomas Gleixner [mailto:tglx@linutronix.de] 
>>> (..) Can you please apply the patch below and provide the output?
>> Sure; thanks for the patch. The kernel seems to be in a loop, as it prints many messages and never stops. I copy only the first ones:
>>
>> ...
>> Switched to clocksource mxc_timer1
>> next 800000000098967f nevt 7fffffffffffffff per 989680 nxtp 1c03a180 now 1c553a59
> Yuck. nevt (dev->next_event) is KTIME_MAX. No surprise, that we end up
> in an endless loop.
>
> Now the question is how we did end up with that and how is that
> related to the dummy timer.
>
> From your debug output we see that the dummy timer is installed before
> the local timer. The dummytimer is disfunctional, so it requires
> broadcast in the first place.
>
> Now when we install the local timer the broadcast is not disabled,
> because the local timer is affected by C3STOP. Now the CPU is not in a
> power state which makes the broadcasting necessary, but the broadcast
> code has no way to distinguish whether the broadcast bit is set due to
> power state or due to a dummy timer.
>
> That's clearly wrong as we end up with two periodic events for that
> cpu (broadcast and local timer) as long as nothing calls into the
> broadcast control code. That's fixable with some surgery.

Yes, that sounds like the problem. Before this change the dummy would
never have been installed first and so the broadcast timer wouldn't be
running during boot.

>
> Though that does not explain why dev->next_event is set to KTIME_MAX
> after we installed the mxc_timer1 as the system clocksource. And we
> really need to know why that happens. 
>
> Here is some more debugging which should shine some light on that.

Each local_timer clockevent should have their next_event set for
KTIME_MAX when they're registered because they get "shutdown" initially.
twd timers support both periodic and oneshot, so we won't emulate
periodic mode with oneshot mode. Looking at tick_setup_periodic() it
looks like the next_event member is ignored and we just set the mode to
periodic. KTIME_MAX should still be there. That should be fine though as
long as we don't switch the tick device into oneshot mode.

It seems that someone is switching the tick device into oneshot mode
without changing the event handler away from tick_handle_periodic(). Is
that supposed to happen? Most clockevents_set_mode(ONESHOT) calls are
prefaced with a handler change or they're operating on the broadcast
device. I suspect that tick_check_oneshot_broadcast() is the bad one.
That one changes the mode and then tick_handle_periodic() probably runs
past that if check and starts trying to emulate periodic mode when
next_event is still KTIME_MAX.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

