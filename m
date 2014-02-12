Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaBLMah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:30:37 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:56279 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751199AbaBLMag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:30:36 -0500
Message-ID: <1392208233.848.48.camel@hornet>
Subject: Re: [PATCH 00/12] Versatile Express updates
From: Pawel Moll <pawel.moll@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>, Jean Delvare <jdelvare@suse.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 12 Feb 2014 12:30:33 +0000
In-Reply-To: <2782419.lfJiZZjaFg@wuerfel>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	 <2782419.lfJiZZjaFg@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 19:28 +0000, Arnd Bergmann wrote:
> On Tuesday 11 February 2014 17:10:24 Pawel Moll wrote:
> > This series is a set of updates following the infrastructure
> > rework and depends on it. It will be finally posted once
> > the main series is merged. For the time being I would really
> > appreciate feedback and/or (n)acks...
> 
> I haven't read the patches yet, but on a general level, do
> you think this code can be (or should) be shared with
> mach-versatile and mach-realview?

Haven't worked with the old ones too much, I just had a look at a couple
of TRMs... The sysregs look similar, don't they? Deceitfully
similar... ;-)

Let me start from the VE side and classify the registers into functional
groups, looking at them from a MFD cells point of view:

- general ID registers like SYS_ID, SYS_MISC, SYS_PROCIDx - either not
really useful for drivers or different bitmasks if needed (eg. the
MASTERSITE bit in SYS_MISC); in other words - good candidates for syscon
if at all interesting

- de-facto GPIO registers like SYS_LED, SYS_MCI, SYS_FLASH - easily
covered via "basic-mmio-gpio" driver; can be simply exposed in the tree
as subnodes

- flags (SYS_*FLAGS*) - used pretty much only for SMP booting; that's
where, I believe, we could unify and move the DT-based operations into
plat_versatile; it is too early for the device model though, so out of
the sysreg driver scope, really (even if the code lives here for now)

- counters (SYS_100HZ, SYS_24MHZ) - the 24MHz one is used on some of the
platforms as a sched clock source; in the fourth patch of the second
series I moved it out into drivers/clocksource - it could be easily
generalised and used across more platforms, but again - it's early code,
so out of sysreg driver scope

- system configuration (SYS_CFG*) - that's the main difference between
VE and its predecessors; the older seem to provide separate system
registers to control infrastructure like clocks etc. (eg. SYS_OSC* on
the realview boards), while here we have the (whatever you call it ;-)
config bus

- other registers that are currently not used at all, but most of them
differ either in naming (and location) or in offset.

All this leads, I believe, to conclusion that they definitely deserve
different compatible values. Therefore they would also require different
mfdcells definitions. Of course we could have more than one in a single
file and pick one via matching table but:

1. There is always that little "extra" (like the master site
configuration on VE, which doesn't happen on the previous ones)

2. I'd rather not to have the non-VE stuff in arm64 kernel.

So, to summarize, I think we need separate files for at least main
families of the sysreg drivers (I didn't spent enough time on this to be
able to find commonalities and differences inside realview and versatile
families), but try to share as much as possible of the "functional"
drivers (with the sched clock and the smp operations being the most
obvious candidates).

> One of the things on my (mid-term) to-do list is to completely
> convert those two platforms over to being entirely DT based
> and having no board specific code so we can actually delete
> the directories along with mach-vexpress

And I sympathise with this goal :-) (interestingly Olof in the past
expressed strong and opposite opinion in the subject ;-)

If you have a look at the last patch of the second series, you'll find
that what's left in the VEXPRESS_DT machine are smp operations and
l2x0_of_init. Then, assuming that we finally get some answer to the CLCD
problem (latest in this subject happened here:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/268037 - I really
lost all hopes for CDF getting anywhere...) removal of the non-DT code
is a matter of a single patch (and a massive negative stat :-). From
there there's only a bunch of PM-related files in arch/arm/mach-vexpress
that I guess could be moved somewhere else (that's what Olof didn't
really like).

Pawel

