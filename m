Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3CWJic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 05:38:32 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:34091 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3CWJib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 05:38:31 -0400
Date: Sat, 23 Mar 2013 10:38:26 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 27/34] s390: Use generic idle loop
Message-ID: <20130323093826.GC3530@osiris>
References: <20130321214930.752934102@linutronix.de>
 <20130321215235.090816526@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321215235.090816526@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032309-2966-0000-0000-0000071479E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:53:18PM -0000, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/s390/kernel/process.c |   25 +++++++------------------
>  arch/s390/kernel/smp.c     |    3 +--
>  2 files changed, 8 insertions(+), 20 deletions(-)

Please merge the patch below into your patch to fix some issues.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig          |  1 +
 arch/s390/kernel/process.c | 13 +++++--------
 arch/s390/kernel/vtime.c   |  5 -----
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index eb8fb62..749513d 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -97,6 +97,7 @@ config S390
 	select CLONE_BACKWARDS2
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CPU_DEVICES if !SMP
+	select GENERIC_IDLE_LOOP
 	select GENERIC_KERNEL_THREAD
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL_OLD
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 546afed..2bc3edd 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -61,16 +61,8 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 	return sf->gprs[8];
 }
 
-/*
- * The idle function on a S390...
- */
 void arch_cpu_idle(void)
 {
-	if (test_thread_flag(TIF_MCCK_PENDING)) {
-		local_irq_enable();
-		return;
-	}
-
 	local_mcck_disable();
 	if (test_thread_flag(TIF_MCCK_PENDING)) {
 		local_mcck_enable();
@@ -87,6 +79,11 @@ void arch_cpu_idle_exit(void)
 		s390_handle_mcck();
 }
 
+void arch_cpu_idle_dead(void)
+{
+	cpu_die();
+}
+
 extern void __kprobes kernel_thread_starter(void);
 
 /*
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index a0042ac..3fb0935 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -158,8 +158,6 @@ void __kprobes vtime_stop_cpu(void)
 	unsigned long psw_mask;
 
 	trace_hardirqs_on();
-	/* Don't trace preempt off for idle. */
-	stop_critical_timings();
 
 	/* Wait for external, I/O or machine check interrupt. */
 	psw_mask = psw_kernel_bits | PSW_MASK_WAIT | PSW_MASK_DAT |
@@ -169,9 +167,6 @@ void __kprobes vtime_stop_cpu(void)
 	/* Call the assembler magic in entry.S */
 	psw_idle(idle, psw_mask);
 
-	/* Reenable preemption tracer. */
-	start_critical_timings();
-
 	/* Account time spent with enabled wait psw loaded as idle time. */
 	idle->sequence++;
 	smp_wmb();
-- 
1.7.12.4

