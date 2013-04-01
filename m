Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab3DAJG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:06:27 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:55502 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3DAJGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:06:23 -0400
Date: Mon, 1 Apr 2013 11:06:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] sparc: Use generic idle loop
Message-ID: <20130401090620.GA24861@merkur.ravnborg.org>
References: <20130321214930.752934102@linutronix.de> <20130329161905.GC6201@merkur.ravnborg.org> <20130329202926.GA9484@merkur.ravnborg.org> <51592EF1.4090302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51592EF1.4090302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srivatsa,

thanks for the feedback!

@davem - I need you to look at this again. I am not sure about the changes
I do in sparc64_yield().

> > +/* the idle loop on a Sparc... ;) */
> > +void arch_cpu_idle(void)
> >  {
> > +	if (sparc_idle)
> > +		(*sparc_idle)();
> > +	else
> > +		cpu_relax();
> >  }
> 
> You need to enable interrupts when coming out in the 'else' case,
> because we enter with interrupts disabled and expect to come out
> of arch_cpu_idle() with interrupts enabled. (Otherwise you'll hit
> that WARN_ON() in the generic code). Thomas has handled a similar
> case in the mips patch.

Something like this should do it then:

/* Idle loop support */
void arch_cpu_idle(void)
{
        if (sparc_idle)
                (*sparc_idle)();
        else
                local_irq_enable();
}

I dropped cpu_relax() as this is a simple barrier() which is
part of the generic code (using rmb()).


> > -static void sparc64_yield(int cpu)
> > +/* The idle loop on sparc64. */
> > +void arch_cpu_idle_enter()
> >  {
> > +	int cpu;
> > +
> > +	cpu = smp_processor_id();
> > +
> >  	if (tlb_type != hypervisor) {
> >  		touch_nmi_watchdog();
> >  		return;
> > @@ -88,31 +93,10 @@ static void sparc64_yield(int cpu)
> >  	set_thread_flag(TIF_POLLING_NRFLAG);
> >  }
> > 
> 
> Hmm, this looks weird. The contents of this function should have
> been inside arch_cpu_idle() (not arch_cpu_idle_enter).
Yep - I see now.

> And it is
> unnecessary to set/clear POLLING flags here, since they are handled
> in the generic code.
OK

> (Same is the case with the need_resched and
> the cpu_is_offline check).
There are some comments about race-conditions in the commit where they were added.
I think the out-most pair can be dropped as this is done in generic code but
that the inner ones needs to stay.

I simplified arch_cpu_idle() - former sparc64_yield() based on your comments.
- dropped TIF_POLLING_NRFLAG handling
- dropped smp_mb__after_clear_bit() - this is done in generic code using rmb()
- dropped the out-most while (!need_resched() && !cpu_is_offline(cpu))
- always enable irq on exit (but I am not sure if this is correct)

But I need davem to have a look at this - as I am fooling around in
code that I do not know much about..
So this is *NOT* to be applied.

	Sam

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3d361f2..ee5eacc 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -37,6 +37,7 @@ config SPARC
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_IDLE_LOOP
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select MODULES_USE_ELF_RELA
diff --git a/arch/sparc/kernel/hvtramp.S b/arch/sparc/kernel/hvtramp.S
index 9365432..605c960 100644
--- a/arch/sparc/kernel/hvtramp.S
+++ b/arch/sparc/kernel/hvtramp.S
@@ -128,8 +128,7 @@ hv_cpu_startup:
 
 	call		smp_callin
 	 nop
-	call		cpu_idle
-	 mov		0, %o0
+
 	call		cpu_panic
 	 nop
 
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index 62eede1..890d7c4 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -64,23 +64,13 @@ extern void fpsave(unsigned long *, unsigned long *, void *, unsigned long *);
 struct task_struct *last_task_used_math = NULL;
 struct thread_info *current_set[NR_CPUS];
 
-/*
- * the idle loop on a Sparc... ;)
- */
-void cpu_idle(void)
+/* Idle loop support. */
+void arch_cpu_idle(void)
 {
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	/* endless idle loop with no priority at all */
-	for (;;) {
-		while (!need_resched()) {
-			if (sparc_idle)
-				(*sparc_idle)();
-			else
-				cpu_relax();
-		}
-		schedule_preempt_disabled();
-	}
+	if (sparc_idle)
+		(*sparc_idle)();
+	else
+		local_irq_enable();
 }
 
 /* XXX cli/sti -> local_irq_xxx here, check this works once SMP is fixed. */
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index cdb80b2..cecb0d6 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -52,17 +52,12 @@
 
 #include "kstack.h"
 
-static void sparc64_yield(int cpu)
+/* Idle loop support on sparc64. */
+void arch_cpu_idle(void)
 {
 	if (tlb_type != hypervisor) {
 		touch_nmi_watchdog();
-		return;
-	}
-
-	clear_thread_flag(TIF_POLLING_NRFLAG);
-	smp_mb__after_clear_bit();
-
-	while (!need_resched() && !cpu_is_offline(cpu)) {
+	} else {
 		unsigned long pstate;
 
 		/* Disable interrupts. */
@@ -73,7 +68,7 @@ static void sparc64_yield(int cpu)
 			: "=&r" (pstate)
 			: "i" (PSTATE_IE));
 
-		if (!need_resched() && !cpu_is_offline(cpu))
+		if (!need_resched() && !cpu_is_offline(smp_processor_id()))
 			sun4v_cpu_yield();
 
 		/* Re-enable interrupts. */
@@ -84,36 +79,16 @@ static void sparc64_yield(int cpu)
 			: "=&r" (pstate)
 			: "i" (PSTATE_IE));
 	}
-
-	set_thread_flag(TIF_POLLING_NRFLAG);
+	local_irq_enable();
 }
 
-/* The idle loop on sparc64. */
-void cpu_idle(void)
-{
-	int cpu = smp_processor_id();
-
-	set_thread_flag(TIF_POLLING_NRFLAG);
-
-	while(1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-
-		while (!need_resched() && !cpu_is_offline(cpu))
-			sparc64_yield(cpu);
-
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-
 #ifdef CONFIG_HOTPLUG_CPU
-		if (cpu_is_offline(cpu)) {
-			sched_preempt_enable_no_resched();
-			cpu_play_dead();
-		}
-#endif
-		schedule_preempt_disabled();
-	}
+void arch_cpu_idle_dead()
+{
+	sched_preempt_enable_no_resched();
+	cpu_play_dead();
 }
+#endif
 
 #ifdef CONFIG_COMPAT
 static void show_regwindow32(struct pt_regs *regs)
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 9e7e6d7..e3f2b81 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -369,7 +369,7 @@ void __cpuinit sparc_start_secondary(void *arg)
 	local_irq_enable();
 
 	wmb();
-	cpu_idle();
+	cpu_startup_entry(CPUHP_ONLINE);
 
 	/* We should never reach here! */
 	BUG();
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 537eb66..c025ffc 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -127,6 +127,8 @@ void __cpuinit smp_callin(void)
 
 	/* idle thread is expected to have preempt disabled */
 	preempt_disable();
+
+	cpu_startup_entry(CPUHP_ONLINE);
 }
 
 void cpu_panic(void)
diff --git a/arch/sparc/kernel/trampoline_64.S b/arch/sparc/kernel/trampoline_64.S
index da1b781..2e973a2 100644
--- a/arch/sparc/kernel/trampoline_64.S
+++ b/arch/sparc/kernel/trampoline_64.S
@@ -407,8 +407,7 @@ after_lock_tlb:
 
 	call		smp_callin
 	 nop
-	call		cpu_idle
-	 mov		0, %o0
+
 	call		cpu_panic
 	 nop
 1:	b,a,pt		%xcc, 1b
