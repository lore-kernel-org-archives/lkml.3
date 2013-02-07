Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab3BGRRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:17:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56102 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907Ab3BGRRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:17:52 -0500
Date: Thu, 7 Feb 2013 17:17:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [PATCHv3 4/4] arm: Add generic timer broadcast support
Message-ID: <20130207171748.GB28072@e106331-lin.cambridge.arm.com>
References: <1358183124-28461-1-git-send-email-mark.rutland@arm.com>
 <1358183124-28461-5-git-send-email-mark.rutland@arm.com>
 <5112C25F.6000508@wwwdotorg.org>
 <20130207100403.GD16987@e106331-lin.cambridge.arm.com>
 <511392A8.9010905@ti.com>
MIME-Version: 1.0
In-Reply-To: <511392A8.9010905@ti.com>
Thread-Topic: [PATCHv3 4/4] arm: Add generic timer broadcast support
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Feb 2013 17:17:49.0441 (UTC) FILETIME=[0DEF6710:01CE0557]
X-MC-Unique: 113020717175009101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> > The intent of 12ad100046: "clockevents: Add generic timer broadcast function"
> > was to setup the broadcast function both for non-functional/dummy timers and
> > those that stop in low-power states (CLOCK_EVT_FEAT_C3STOP). I missed the
> > CLOCK_EVT_FEAT_C3STOP case.
> >
> I am not sure this exactly the case. Because in my testing, the C3STOP 
> path was exercised already. And if the C3STOP is used then notifiers
> calls are expected for switching of clock-events to broadcast mode.

I don't thing the C3STOP path was fully exercised.

The notifier calls sets up the broadcast source and adds cpus to
tick_broadcast_oneshot_mask, but they don't set up the broadcast function on
the local timer clock_event_devices. While everything else was set up for broadcast,
the CPU in idle's tick_cpu_device->evtdev had a NULL broadcast function pointer.

As soon as the broadcast device receives its interrupt, it attempts to
broadcast to all cpus in tick_broadcast_oneshot_mask, calling the broadcast
function pointer on their local timers' struct clock_event_device. As this was
never set up, it explodes, attempting to branch to NULL.

> 
> And dummy broad-cast hook should come into picture only if the per CPU
> local timer clock-event are not registered.

This is irrelevant here. The issue is that the broadcast function pointer isn't
set up for clocks with CLOCK_EVT_FEAT_C3STOP.

> 
> I just tried "next-20130207" on OMAP and I see the broad-cast mechanism
> works and didn't observe any crash.
> 
> ------------------------------
> Tick Device: mode:     1
> Broadcast device
> Clock Event Device: gp_timer
>   max_delta_ns:   131071523464981
>   min_delta_ns:   91552
>   mult:           70369
>   shift:          31
>   mode:           3
>   next_event:     89984375000 nsecs
>   set_next_event: omap2_gp_timer_set_next_event
>   set_mode:       omap2_gp_timer_set_mode
>   event_handler:  tick_handle_oneshot_broadcast
>   retries:        0
> 
> tick_broadcast_mask: 00000003
> tick_broadcast_oneshot_mask: 00000000

The broadcast clocks' next broadcast is in ~90 seconds time.

[...]

> 
> Tick Device: mode:     1
> Per CPU device: 1
> Clock Event Device: local_timer
>   max_delta_ns:   10737418240
>   min_delta_ns:   1000
>   mult:           858993459
>   shift:          31
>   mode:           3
>   next_event:     89921875000 nsecs
>   set_next_event: twd_set_next_event
>   set_mode:       twd_set_mode
>   event_handler:  hrtimer_interrupt
>   retries:        258

And this clock next expects a tick in ~90 seconds time.

Did you leave the board on for at least 90 seconds after grabbing this output,
with the cpu staying in idle?

If not, the kernel won't have attempted to broadcast.

> 
> #
> 
> ------------------------------
> 
> > I believe the patch below will fix this for Tegra and any other platforms where
> > broadcast is required in low power states.
> >
> Am not sure you really need that patch unless and until am missing a
> scenario in my test.

I suspect that with the time before broadcast being so large, broadcast never
actually occurred (even though the global timer was ready for it to).

I've don't have a suitable OMAP platform to test that theory on, unfortunately.

> 
> Stephan,
> 
> Do we have crash log seen on Tegra ? Which tegra CPUIDLE driver
> is being used when crash is seen ?

I've acquired a Harmony board, and running next-20130207, I encounter the exact
issue I described above (with the PC at NULL). With my suggested patch applied,
the problem disappears.

I believe the idle driver would be tegra20-cpuidle, and I believe it's doing
the right thing.

Thanks,
Mark.

