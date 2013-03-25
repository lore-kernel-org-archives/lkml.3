Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab3CYXHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:07:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39380 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825Ab3CYXHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:07:31 -0400
Date: Mon, 25 Mar 2013 23:07:30 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Magnus Damm <magnus.damm@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
Message-ID: <20130325230730.GA5518@MacBook-Pro.local>
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com>
 <20130321110646.GE15279@e106331-lin.cambridge.arm.com>
 <20130325172633.GP30923@n2100.arm.linux.org.uk>
 <5150C16A.3040208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5150C16A.3040208@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 09:28:10PM +0000, Rob Herring wrote:
> On 03/25/2013 12:26 PM, Russell King - ARM Linux wrote:
> > On Thu, Mar 21, 2013 at 11:06:47AM +0000, Mark Rutland wrote:
> >> On TC2 this series leads to using the vexpress 24MHz clock as the sched clock
> >> in preference to the architected timer:
> >>
> >>   Architected local timer running at 24.00MHz (virt).
> >>   Switching to timer-based delay loop
> >>   Registered arch_counter_get_cntvct+0x0/0x14 as sched_clock source
> >>   sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956ms
> >>   Registered versatile_read_sched_clock+0x0/0x28 as sched_clock source
> >>
> >> As they both have the same frequency, neither overrides the other, and
> >> whichever gets registered last is used as the sched_clock. As accesses
> >> to the architected timer are going to have a much lower overhead, this
> >> isn't very nice (and it could be better to use it even if it had a lower
> >> frequency).
> > 
> > I'll remind people that sched_clock() is supposed to be functional at
> > the point in the boot sequence where the call to sched_init() is called.
> > That is after setup_arch() and *before* time_init() is called.
> 
> I count integrator-cp, realview, versatile and non-DT VExpress that do
> this (not surprisingly) and 25 platforms or timer implementations plus
> arm64 that do sched_clock setup in time_init.

Before time_init(), sched_clock() currently returns 0 with the
architected timers (though I don't particularly like this for arm64).
Marc Rutland has patches to make arch_timer_read_counter() a function
which always returns the virtual counter. It requires the CNTVOFF
register to be set to 0 on AArch32 during boot. But this way
sched_clock() on arm64 would always return meaningful values as we have
the architected timers.

-- 
Catalin
