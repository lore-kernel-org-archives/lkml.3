Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937678Ab3DIKdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:33:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39322 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935814Ab3DIKdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:33:16 -0400
Date: Tue, 9 Apr 2013 11:33:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv4 01/11] clockevents: Prefer CPU local devices over
 global devices
Message-ID: <20130409103303.GV23725@e106331-lin.cambridge.arm.com>
References: <1365456453-16297-1-git-send-email-sboyd@codeaurora.org>
 <1365456453-16297-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365456453-16297-2-git-send-email-sboyd@codeaurora.org>
Thread-Topic: [PATCHv4 01/11] clockevents: Prefer CPU local devices over
 global devices
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Apologies for my lack of response on the last version of this.

On Mon, Apr 08, 2013 at 10:27:23PM +0100, Stephen Boyd wrote:
> On an SMP system with only one global clockevent and a dummy
> clockevent per CPU we run into problems. We want the dummy
> clockevents to be registered as the per CPU tick devices, but
> we can only achieve that if we register the dummy clockevents
> before the global clockevent or if we artificially inflate the
> rating of the dummy clockevents to be higher than the rating
> of the global clockevent. Failure to do so leads to boot
> hangs when the dummy timers are registered on all other CPUs
> besides the CPU that accepted the global clockevent as its tick
> device and there is no broadcast timer to poke the dummy
> devices.
> 
> If we're registering multiple clockevents and one clockevent is
> global and the other is local to a particular CPU we should
> choose to use the local clockevent regardless of the rating of
> the device. This way, if the clockevent is a dummy it will take
> the tick device duty as long as there isn't a higher rated tick
> device and any global clockevent will be bumped out into
> broadcast mode, fixing the problem described above.

It might be worth pointing out that if dummy timers are only registered
when there's more than one CPU, UP behaviour won't degrade from the
current state of affairs.

> 
> Reported-by: Mark Rutland <mark.rutland@arm.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  kernel/time/tick-common.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index b1600a6..9ea59b9 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -251,9 +251,10 @@ static int tick_check_new_device(struct clock_event_device *newdev)
>  		    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
>  			goto out_bc;
>  		/*
> -		 * Check the rating
> +		 * Check the rating, but prefer CPU local devices
>  		 */
> -		if (curdev->rating >= newdev->rating)
> +		if (curdev->rating >= newdev->rating &&
> +		    cpumask_equal(curdev->cpumask, newdev->cpumask))
>  			goto out_bc;
>  	}

This looks good to me. I tested this on a TC2 with a v3.9-rc6 kernel
without architected timer support. The patch restores the ability to use
the sp804 as a broadcast source.

Tested-by: Mark Rutland <mark.rutland@arm.com>

If possible I think this should sit in -next for a bit to make sure it
doesn't have any unexpected side effects.

Otherwise, results of testing below.

Without this patch (where boot hangs), magic sysrq show-all-timers give
me the following:

Tick Device: mode:     1
Broadcast device
Clock Event Device: <NULL>
tick_broadcast_mask: 0000000e
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: v2m-timer0
 max_delta_ns:   4294966591000
 min_delta_ns:   14999
 mult:           2147484
 shift:          31
 mode:           3
 next_event:     18340000000 nsecs
 set_next_event: sp804_set_next_event
 set_mode:       sp804_set_mode
 event_handler:  hrtimer_interrupt
 retries:        0

Tick Device: mode:     0
Per CPU device: 1
Clock Event Device: dummy_timer
 max_delta_ns:   0
 min_delta_ns:   0
 mult:           1
 shift:          0
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: <00000000>
 set_mode:       broadcast_timer_set_mode
 event_handler:  tick_handle_periodic
 retries:        0

[...]

With this patch (where boot succeeds), show-all-timers gives me the following:

Tick Device: mode:     0
Broadcast device
Clock Event Device: v2m-timer0
 max_delta_ns:   4294966591000
 min_delta_ns:   14999
 mult:           2147484
 shift:          31
 mode:           2
 next_event:     9223372036854775807 nsecs
 set_next_event: sp804_set_next_event
 set_mode:       sp804_set_mode
 event_handler:  tick_handle_periodic_broadcast
 retries:        0
tick_broadcast_mask: 0000000f
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     0
Per CPU device: 0
Clock Event Device: dummy_timer
 max_delta_ns:   0
 min_delta_ns:   0
 mult:           1
 shift:          0
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: <pK-error>
 set_mode:       broadcast_timer_set_mode
 event_handler:  tick_handle_periodic
 retries:        0

Tick Device: mode:     0
Per CPU device: 1
Clock Event Device: dummy_timer
 max_delta_ns:   0
 min_delta_ns:   0
 mult:           1
 shift:          0
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: <pK-error>
 set_mode:       broadcast_timer_set_mode
 event_handler:  tick_handle_periodic
 retries:        0

[...]

Cheers,
Mark.
