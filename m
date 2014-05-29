Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026AbaE2Qt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:49:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45725 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932795AbaE2Qt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:49:26 -0400
Date: Thu, 29 May 2014 17:48:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH] arm64: kernel: initialize broadcast hrtimer based clock
 event device
Message-ID: <20140529164855.GH24233@leverpostej>
References: <1401355381-11446-1-git-send-email-lorenzo.pieralisi@arm.com>
 <53871444.3080206@linux.vnet.ibm.com>
 <20140529123929.GF24233@leverpostej>
 <20140529142912.GB20798@red-moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529142912.GB20798@red-moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 03:29:12PM +0100, Lorenzo Pieralisi wrote:
> On Thu, May 29, 2014 at 01:39:29PM +0100, Mark Rutland wrote:
> 
> [...]
> 
> > > > The side effect of having a CPU always-on has implications on power management
> > > > platform capabilities and makes CPUidle suboptimal, since at least a CPU is
> > > > kept always in a shallow idle state by the kernel to relay timer interrupts,
> > > > but at least leaves the kernel with a functional system with some working power
> > > > management capabilities.
> > > > 
> > > > The hrtimer based clock event device has lowest possible rating so that,
> > > > if a platform contains a functional HW clock event device with broadcast
> > > > capabilities, that device is always chosen as a tick broadcast device instead
> > > > of the software based one, now present by default.
> > > 
> > > I think this statement "instead of the software based one, now present
> > > by default" is incorrect. The hrtimer based clock event device will come
> > > into picture only when the arch calls tick_setup_hrtimer_broadcast()
> > > explicitly. Otherwise either the arch should register a real clock
> > > device which does broadcast or should disable deep idle states where the
> > > local timers stop. So I would suggest skipping the last paragraph as it
> > > is not conveying anything in specific. The fact that a clock device with
> > > the highest rating will be chosen is already known and need not be
> > > mentioned explicitly IMHO.
> > 
> > I think it is worth keeping the paragraph to allay anyone's fear that
> > the hrtimer based broadcast device might be selected in preference to a
> > real suitable clock. I would otherwise not be aware that the hrtimer
> > based broadcast device had the lowest rating (and would have to go and
> > look that up separately).
> > 
> > As the arch code has delegated timer registration to
> > clocksoruce_of_init, it doesn't know whether any of the real devices
> > that may have been registered are suitable as a broadcast source for
> > oneshot events. So we can't conditionally register the hrtimer based
> > broadcast device.
> > 
> > Perhaps we could replace "now present by default" with "which is
> > unconditionally registered in case no suitable hardware device is
> > present"?
> 
> How about this:
> 
> -- >8 --
> Subject: [PATCH] arm64: kernel: initialize broadcast hrtimer based clock event
>  device
> 
> On platforms implementing CPU power management, the CPUidle subsystem
> can allow CPUs to enter idle states where local timers logic is lost on power
> down. To keep the software timers functional the kernel relies on an
> always-on broadcast timer to be present in the platform to relay the
> interrupt signalling the timer expiries.
> 
> For platforms implementing CPU core gating that do not implement an always-on
> HW timer or implement it in a broken way, this patch adds code to initialize
> the kernel hrtimer based clock event device upon boot (which can be chosen as
> tick broadcast device by the kernel).
> It relies on a dynamically chosen CPU to be always powered-up. This CPU then
> relays the timer interrupt to CPUs in deep-idle states through its HW local
> timer device.
> 
> The side effect of having a CPU always-on has implications on power management
> platform capabilities and makes CPUidle suboptimal, since at least a CPU is
> kept always in a shallow idle state by the kernel to relay timer interrupts,
> but at least leaves the kernel with a functional system with some working power
> management capabilities.

I think "The side effect of" is redundant, but otherwise this is fine.

> 
> The hrtimer based clock event device has lowest possible rating so that,
> if a platform contains a functional HW clock event device with broadcast
> capabilities, that device is always chosen as a tick broadcast device instead
> of the hrtimer based one, which is unconditionally registered in case no
> suitable hardware clock event device is present.

The last paragaph jumps back and forward a bit. How about:

The hrtimer based clock event device is unconditionally registered, but
has the lowest possible rating such that any broadcast-capable HW clock
event device present will be chosen in preference as the tick broadcast
device.

Cheers,
Mark.
