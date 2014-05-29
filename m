Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaE2MkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:40:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42353 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757048AbaE2MkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:40:01 -0400
Date: Thu, 29 May 2014 13:39:29 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH] arm64: kernel: initialize broadcast hrtimer based clock
 event device
Message-ID: <20140529123929.GF24233@leverpostej>
References: <1401355381-11446-1-git-send-email-lorenzo.pieralisi@arm.com>
 <53871444.3080206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53871444.3080206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti,

On Thu, May 29, 2014 at 12:04:36PM +0100, Preeti U Murthy wrote:
> Hi Lorenzo,
> 
> On 05/29/2014 02:53 PM, Lorenzo Pieralisi wrote:
> > On platforms implementing CPU power management, the CPUidle subsystem
> > can allow CPUs to enter idle states where local timers logic is lost on power
> > down. To keep the software timers functional the kernel relies on an
> > always-on broadcast timer to be present in the platform to relay the
> > interrupt signalling the timer expiries.
> > 
> > For platforms implementing CPU core gating that do not implement an always-on
> > HW timer or implement it in a broken way, this patch adds code to initialize
> > the kernel software broadcast hrtimer upon boot. It relies on a dynamically
> 
> It would be best to use the term "hrtimer based broadcast device"
> throughout the changelog for uniformity and to avoid confusion instead
> of mixing it with "software broadcast".
> 
> > chosen CPU to be always powered-up. This CPU then relays the timer interrupt
> > to CPUs in deep-idle states through its HW local timer device.
> > 
> > On systems with power management capabilities but no functional HW broadcast
> > tick device, the hrtimer based clock event device allows the kernel to
> > enter high-resolution timer mode, which improves system latencies and saves
> > dynamic power.
> 
> Sorry but I do not understand the above paragraph. What do you mean by
> "allows the kernel to enter high resolution timer mode" ? And how does
> it improve system latency? I understand that the hrtimer based
> clockevent device saves dynamic power since it provides a mechanism in
> which cpus can enter deeper idle states.

When there's no oneshot-capable broadcast device and the CPU-local
clock_event_device has the CLK_EVT_FEAT_C3STOP flag,
tick_is_oneshot_available will return false. Thus
tick_check_oneshot_change will return false, and hrtimer_switch_to_hres
will never switch to high resolution mode (and we can also never enter
NOHZ mode), leaving us stuck in periodic mode.

In periodic mode ticks occur at fixed intervals, and any timer wakeup
will occur after the tick following the requested wakeup time, adding
some amount of latency over what would be possible with high resolution
mode. Additionally, as we can only wake up at said ticks and not between
them, it's possible that several timers for intervals shorter than that
tick interval will fire at once upon a timer tick. Any tasks which
requested these wakeups will fight for CPU time, and some will see
additional latency because of this.

> > 
> > The side effect of having a CPU always-on has implications on power management
> > platform capabilities and makes CPUidle suboptimal, since at least a CPU is
> > kept always in a shallow idle state by the kernel to relay timer interrupts,
> > but at least leaves the kernel with a functional system with some working power
> > management capabilities.
> > 
> > The hrtimer based clock event device has lowest possible rating so that,
> > if a platform contains a functional HW clock event device with broadcast
> > capabilities, that device is always chosen as a tick broadcast device instead
> > of the software based one, now present by default.
> 
> I think this statement "instead of the software based one, now present
> by default" is incorrect. The hrtimer based clock event device will come
> into picture only when the arch calls tick_setup_hrtimer_broadcast()
> explicitly. Otherwise either the arch should register a real clock
> device which does broadcast or should disable deep idle states where the
> local timers stop. So I would suggest skipping the last paragraph as it
> is not conveying anything in specific. The fact that a clock device with
> the highest rating will be chosen is already known and need not be
> mentioned explicitly IMHO.

I think it is worth keeping the paragraph to allay anyone's fear that
the hrtimer based broadcast device might be selected in preference to a
real suitable clock. I would otherwise not be aware that the hrtimer
based broadcast device had the lowest rating (and would have to go and
look that up separately).

As the arch code has delegated timer registration to
clocksoruce_of_init, it doesn't know whether any of the real devices
that may have been registered are suitable as a broadcast source for
oneshot events. So we can't conditionally register the hrtimer based
broadcast device.

Perhaps we could replace "now present by default" with "which is
unconditionally registered in case no suitable hardware device is
present"?

Cheers,
Mark.
