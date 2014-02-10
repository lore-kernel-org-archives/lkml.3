Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaBJPNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:13:40 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54922 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751449AbaBJPNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:13:37 -0500
Date: Mon, 10 Feb 2014 15:12:47 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: linux@arm.linux.org.uk, jonathan.austin@arm.com, nico@linaro.org,
        marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, vgupta@synopsys.com,
        ben.dooks@codethink.co.uk, u.kleine-koenig@pengutronix.de,
        sboyd@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        maxime.coquelin@st.com
Subject: Re: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
Message-ID: <20140210151247.GD2794@e103592.cambridge.arm.com>
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com>
 <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com>
 <20140210141634.GA2794@e103592.cambridge.arm.com>
 <52F8E5E2.30805@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F8E5E2.30805@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 03:44:50PM +0100, Fabrice Gasnier wrote:
> On 02/10/2014 03:16 PM, Dave Martin wrote:
> >On Fri, Feb 07, 2014 at 05:19:15PM +0100, Fabrice GASNIER wrote:
> >>This patch adds imprecise abort enable/disable macros.
> >>It also enables imprecise aborts when starting kernel.
> >Relying on imprecise aborts for hardware probing would be considered bad
> >hardware and/or software design for ARM-specific stuff.
> >
> >PCI is more generic though, so we may have to put up with this to some
> >extent.  Can you point me to the affected probing code?  I'm not very
> >familiar with that stuff...
> Hi,
> 
> I'm currently re-basing to prepare upstream of such a driver so, no
> code for now on my side,
> but, I saw others that have similar behavior :
> http://www.spinics.net/lists/linux-pci/msg26124.html
> Basically, I think all PCI drivers using hook_fault_code(16+6, ...)
> use similar mechanism.

Hmmm.  There seem to be a few problems here.

Firstly, blindly adding 4 to PC is obviouly not right, partly because we
might be running an unrelated thread by the time the abort fires, and
also because the affected instruction might not be 4 bytes in size in a
Thumb kernel.

Secondly, do we ever release the fault code hook?  If not, it looks like
we just ignore all imprecise aborts from the moment that driver is
loaded, whatever causes them ... not ideal.


Are the aborts triggered by the PCI common code?  Do you know which 
precise code triggers the aborts?

I wonder whether it would be possible to arch hooks to do the
problematic probing another way.

Cheers
---Dave


> >
> >>Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
> >>---
> >>  arch/arm/include/asm/irqflags.h |   33 +++++++++++++++++++++++++++++++++
> >>  arch/arm/kernel/smp.c           |    1 +
> >>  arch/arm/kernel/traps.c         |    4 ++++
> >>  3 files changed, 38 insertions(+)
> >>
> >>diff --git a/arch/arm/include/asm/irqflags.h b/arch/arm/include/asm/irqflags.h
> >>index 3b763d6..82e3834 100644
> >>--- a/arch/arm/include/asm/irqflags.h
> >>+++ b/arch/arm/include/asm/irqflags.h
> >>@@ -51,6 +51,9 @@ static inline void arch_local_irq_disable(void)
> >>  #define local_fiq_enable()  __asm__("cpsie f	@ __stf" : : : "memory", "cc")
> >>  #define local_fiq_disable() __asm__("cpsid f	@ __clf" : : : "memory", "cc")
> >>+
> >>+#define local_abt_enable()  __asm__("cpsie a	@ __sta" : : : "memory", "cc")
> >>+#define local_abt_disable() __asm__("cpsid a	@ __cla" : : : "memory", "cc")
> >>  #else
> >>  /*
> >>@@ -130,6 +133,36 @@ static inline void arch_local_irq_disable(void)
> >>  	: "memory", "cc");					\
> >>  	})
> >>+/*
> >>+ * Enable Aborts
> >>+ */
> >>+#define local_abt_enable()					\
> >>+	({							\
> >>+		unsigned long temp;				\
> >>+	__asm__ __volatile__(					\
> >>+	"mrs	%0, cpsr		@ sta\n"		\
> >>+"	bic	%0, %0, %1\n"					\
> >>+"	msr	cpsr_c, %0"					\
> >I suggest you use "cpsie/cpsid a" instead.  This requires ARMv6, but the
> >CPSR.A bit only exists on ARMv6 and later anyway.  Poking that bit
> >on earlier CPUs may cause unpredictable behaviour, so these macros
> >should be no-ops for v5 and earlier.
> Thanks,
> I'll prepare a new patch that way.
> >
> >>+	: "=r" (temp)						\
> >>+	: "r" (PSR_A_BIT)					\
> >>+	: "memory", "cc");					\
> >>+	})
> >>+
> >>+/*
> >>+ * Disable Aborts
> >>+ */
> >>+#define local_abt_disable()					\
> >>+	({							\
> >>+		unsigned long temp;				\
> >>+	__asm__ __volatile__(					\
> >>+	"mrs	%0, cpsr		@ cla\n"		\
> >>+"	orr	%0, %0, %1\n"					\
> >>+"	msr	cpsr_c, %0"					\
> >>+	: "=r" (temp)						\
> >>+	: "r" (PSR_A_BIT)					\
> >>+	: "memory", "cc");					\
> >>+	})
> >>+
> >>  #endif
> >>  /*
> >>diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> >>index dc894ab..c2093cb 100644
> >>--- a/arch/arm/kernel/smp.c
> >>+++ b/arch/arm/kernel/smp.c
> >>@@ -377,6 +377,7 @@ asmlinkage void secondary_start_kernel(void)
> >>  	local_irq_enable();
> >>  	local_fiq_enable();
> >>+	local_abt_enable();
> >>  	/*
> >>  	 * OK, it's off to the idle thread for us
> >>diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> >>index 4636d56..ef15709 100644
> >>--- a/arch/arm/kernel/traps.c
> >>+++ b/arch/arm/kernel/traps.c
> >>@@ -900,6 +900,10 @@ void __init early_trap_init(void *vectors_base)
> >>  	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
> >>  	modify_domain(DOMAIN_USER, DOMAIN_CLIENT);
> >>+
> >>+	/* Enable imprecise aborts */
> >>+	local_abt_enable();
> >It would be good to clean up why aborts are not being consistently
> >enabled on boot.
> I did a bit of analysis and summarized it in this thread. I've not
> been further:
> http://archive.arm.linux.org.uk/lurker/message/20140203.164322.edba427a.en.html
> 
> BR,
> Fabrice
> >
> >Really, they should be enabled, except for a brief window during
> >boot when the vectors are not mapped and the abort can't be dispatched.
> >
> >Cheers
> >---Dave
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
