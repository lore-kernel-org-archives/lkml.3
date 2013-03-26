Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab3CZL2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:28:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51594 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756213Ab3CZL23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:28:29 -0400
Date: Tue, 26 Mar 2013 11:28:11 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv3 01/10] clocksource: add generic dummy timer driver
Message-ID: <20130326112811.GD4065@e106331-lin.cambridge.arm.com>
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org>
 <1363198676-30417-2-git-send-email-sboyd@codeaurora.org>
 <20130321180922.GB10716@e106331-lin.cambridge.arm.com>
 <514B4DBD.4060403@codeaurora.org>
 <20130322180305.GB1436@e106331-lin.cambridge.arm.com>
 <5150800E.2000905@codeaurora.org>
 <20130325180007.GA4065@e106331-lin.cambridge.arm.com>
 <5151049D.5040400@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5151049D.5040400@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 02:14:53AM +0000, Stephen Boyd wrote:
> On 03/25/13 11:00, Mark Rutland wrote:
> >
> >>> I've spent the last few hours trying to get the dummy_timer driver working on
> >>> tc2 with the sp804 as the broadcast source (with architected timer support
> >>> disabled). It turns out that having dummy timer's rating so low means that it
> >>> won't be selected as the tick device on cpu0 in preference to the sp804, and
> >>> thus won't push the sp804 out of that spot (allowing it to become the broadcast
> >>> source). This leads to boot stalling.
> >> I'm not following here. Why would we want to remove sp804 from the tick
> >> duty?
> > To run an SMP system without local timers, we need the sp804 to be the
> > broadcast timer. Unfortunately the tick device and broadcast timer are mutually
> > exclusive positions, so we need to have a dummy timer knock the sp804 out of
> > tick device duty to enable broadcast.
> >
> > When the dummy timer's rating was 400 (against the sp804's 350), this worked.
> > The sp804 would be registered, and would become cpu0's tick device. Later the
> > dummy would get registered, knocking the sp804 out (whereupon it would get
> > cycled back through tick_check_new_device and become the broadcast timer).
> >
> > With the dummy timer's rating lower, the sp804 stays as cpu0's tick device, all
> > other cpus get dummy timers, but there's no broadcast source, so the system
> > locks up waiting for secondary cpus.
> 
> Ok. Thanks for clearing up my confusion.
> 
> Like you say, increasing the dummy timer rating seems like a hack. But
> it also sounds like you want to keep the dummy timer driver fully self
> contained. I'm not opposed to calling dummy_timer_register() at the
> bottom of tick_init() if we have to, but it sounds like you don't like that.

I'd like to keep the dummy timer driver self-contained if we can, but if it
makes it more robust and/or easier to deal with by having an external call to
register the driver, then I'm not opposed to that.

> 
> An alternative would be to push the dummy timer logic into the core
> clockevents layer under the ifdef for arch has broadcast. This is
> probably the correct approach because most devices don't want to have a
> dummy timer sitting around unused. I might be able to take a look at
> this tomorrow.

I'm also not opposed to this idea.

> 
> One final question, if you remove all other CPUs besides the CPU that is
> servicing the sp804 interrupt do we end up in a situation where the
> sp804 is broadcasting to the dummy tick device? I haven't read through
> all the code yet for that one. I would think tick_switch_to_oneshot()
> would complain on your device?

The current code in arch/arm/kernel/smp.c only registers the local timer on
cpu0 if we have more than one CPU, so the sp804 stays as cpu0's tick device.

With the generic dummy timer (with a rating bumped up to 400, using an
early_initcall, and the dummy timers rejected as broadcast sources [1]), even
when booting only with one cpu described in the dt the sp804 is relegated to
broadcast timer duty, broadcasting to the dummy timer on cpu0. Echoing 'q' to
/proc/sysrq-trigger gives me:

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
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     0
Per CPU device: 0
Clock Event Device: dummy_timer
 max_delta_ns:   0
 min_delta_ns:   0
 mult:           0
 shift:          0
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: <00000000>
 set_mode:       dummy_timer_set_mode
 event_handler:  tick_handle_periodic
 retries:        0

Though "broadcasting" to the same cpu is special-cased in tick_do_broadcast,
which will call the tick device's event_handler directly rather than having the
cpu attempt to IPI to itself.

As you suggest, tick_switch_to_oneshot does complain:

Clockevents: could not switch to one-shot mode: dummy_timer is not functional.
Could not switch to high resolution mode on CPU 0

To handle this case we could check cpu_possible_mask when initialising the
dummy and only register it if more than 1 cpu is possible. That would be
roughly in line with how we handle this case in smp.c.

Thanks,
Mark.

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a7dc19b8652c862d5b7c4d2339bd3c428bd29c4a
