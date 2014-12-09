Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbaLIQ6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:58:20 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:47142 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaLIQ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:58:18 -0500
Date: Tue, 9 Dec 2014 16:58:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Eddie Huang =?utf-8?B?KOm7g+aZuuWCkSk=?= 
	<eddie.huang@mediatek.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v5] clocksource: arch_timer: Fix code to use physical
 timers when requested
Message-ID: <20141209165807.GJ31129@e104818-lin.cambridge.arm.com>
References: <1416812564-26465-1-git-send-email-sonnyrao@chromium.org>
 <1417776064.14380.17.camel@mtksdaap41>
 <20141208162140.GN16185@e104818-lin.cambridge.arm.com>
 <1418106718.32622.31.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418106718.32622.31.camel@mtksdaap41>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 06:31:58AM +0000, Yingjoe Chen wrote:
> On Mon, 2014-12-08 at 16:21 +0000, Catalin Marinas wrote:
> > On Fri, Dec 05, 2014 at 10:41:04AM +0000, Yingjoe Chen wrote:
> > > On Sun, 2014-11-23 at 23:02 -0800, Sonny Rao wrote: 
> > > > This is a bug fix for using physical arch timers when
> > > > the arch_timer_use_virtual boolean is false.  It restores the
> > > > arch_counter_get_cntpct() function after removal in
> > > > 
> > > > 0d651e4e "clocksource: arch_timer: use virtual counters"
> > > > 
> > > > We need this on certain ARMv7 systems which are architected like this:
> > > > diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> > > > index f190971..b1fa4e6 100644
> > > > --- a/arch/arm64/include/asm/arch_timer.h
> > > > +++ b/arch/arm64/include/asm/arch_timer.h
> > > > @@ -104,6 +104,15 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
> > > >  	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
> > > >  }
> > > >  
> > > > +static inline u64 arch_counter_get_cntpct(void)
> > > > +{
> > > > +	/*
> > > > +	 * AArch64 kernel and user space mandate the use of CNTVCT.
> > > > +	 */
> > > > +	BUG();
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  static inline u64 arch_counter_get_cntvct(void)
> > > >  {
> > > >  	u64 cval;
> > > 
> > > I tested this on an arm64 platform and system fail to boot when apply
> > > this patch.
> > > 
> > > The boot loader start kernel at EL2, so is_hyp_mode_available() will be
> > > true and we will use physical timer. Without this patch,
> > > arch_timer_read_counter set to arch_counter_get_cntvct even when we use
> > > physical timer which is incorrect but at least system will boot.
> > 
> > So on arm64 we want to use CNTVCT all the time, even if we start the
> > kernel at EL2. This is the counter that gets exposed to user via vdso.
> > When the kernel boots at EL2, we initialise CNTVOFF to 0, so we know
> > that CNTVCT == CNTPCT. However, I would still prefer to use CNTVCT even
> > in such case to spot possible firmware issues with not restoring CNTVOFF
> > when coming out of suspend (one particular case of suspend which does
> > not require a different kernel entry point).
> > 
> > > I think we still need this function on arm64. We should add BUG() to
> > > arch_timer_init instead, maybe something like this:
> > > 
> > > @@ -708,9 +708,12 @@ static void __init arch_timer_init(struct device_node *np)
> > >  	 * If we cannot rely on firmware initializing the timer registers then
> > >  	 * we should use the physical timers instead.
> > >  	 */
> > > -	if (IS_ENABLED(CONFIG_ARM) &&
> > > -	    of_property_read_bool(np, "arm,cpu-registers-not-fw-configured"))
> > > +	if (of_property_read_bool(np, "arm,cpu-registers-not-fw-configured")) {
> > > +		if (IS_ENABLED(CONFIG_ARM64))
> > > +			BUG();
> > > +		else
> > >  			arch_timer_use_virtual = false;
> > > +	}
> > 
> > We could be more tolerant (give people a chance to check their DT):
> > 
> > 	if (!WARN_ON(IS_ENABLED(CONFIG_ARM64)))
> > 		arch_timer_use_virtual = false;
> > 
> > In addition, we can define arch_counter_get_cntpct to always read CNTVCT
> > (not that nice but maybe it looks better with a comment):
> > 
> > /*
> >  * AArch64 kernel and user space mandate the use of CNTVCT.
> >  */
> > #define arch_counter_get_cntpct	arch_counter_get_cntvct
> > 
> > (or any better suggestion to avoid reading CNTPCT on arm64)
> > 
> 
> I'm not sure about this. arch_timer_use_virtual is false, indicate we
> are using physical timer, the function name suggest it will read
> physical timer, but actually it is reading virtual timer. It sure will
> create confusion when one need to debug.

You mix timer and counter terms here. Anyway, of we use physical timer,
you could argue that it makes sense to use the corresponding physical
counter (CNTPCT). However, on arm64 we only expose CNTVCT to user VDSO
and we want to use the same in the kernel. When booting at EL2, CNTVCT
== CNTPCT because we control CNTVOFF, that's unless we have some broken
firmware that does not restore CNTVOFF correctly. That's what we want
to spot early, hence the aim to always use the virtual counter (but not
the timer, use use the physical timer as it makes it easier for KVM).

So the patch below, on top of linux-next, should solve the BUG():

---------------------8<------------------------------

>From 9be3c61788eff2e7d010d627582118fa6aae1d9c Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 9 Dec 2014 16:44:06 +0000
Subject: [PATCH] clocksource: arch_timer: Only use the virtual counter
 (CNTVCT) on arm64

The arm64 kernel uses CNTVCT in VDSO. When booting in EL2, the kernel
switches to the physical timers to make things easier for KVM but it
continues to use the virtual counter both in user and kernel. While in
such scenario CNTVCT == CNTPCT (since CNTVOFF is initialised by the
kernel to 0), we want to spot firmware bugs corrupting CNTVOFF early
(which would affect CNTVCT).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/clocksource/arm_arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 6a79fc4f900c..095c1774592c 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -462,7 +462,7 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_CP15_TIMER) {
-		if (arch_timer_use_virtual)
+		if (IS_ENABLED(CONFIG_ARM64) || arch_timer_use_virtual)
 			arch_timer_read_counter = arch_counter_get_cntvct;
 		else
 			arch_timer_read_counter = arch_counter_get_cntpct;
