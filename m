Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaJ0Ptv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:49:51 -0400
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:35843 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbaJ0Pts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:49:48 -0400
Date: Mon, 27 Oct 2014 10:49:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <htejun@gmail.com>
cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Subject: [percpu] Convert remaining __get_cpu_var uses in 3.18-rcX
Message-ID: <alpine.DEB.2.11.1410271047400.17089@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the 3.18 merge period additional __get_cpu_var uses were
added. The patch converts these to this_cpu_ptr().

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/arm64/kernel/psci.c
===================================================================
--- linux.orig/arch/arm64/kernel/psci.c
+++ linux/arch/arm64/kernel/psci.c
@@ -511,7 +511,7 @@ static int cpu_psci_cpu_kill(unsigned in

 static int psci_suspend_finisher(unsigned long index)
 {
-	struct psci_power_state *state = __get_cpu_var(psci_power_state);
+	struct psci_power_state *state = __this_cpu_read(psci_power_state);

 	return psci_ops.cpu_suspend(state[index - 1],
 				    virt_to_phys(cpu_resume));
@@ -520,7 +520,7 @@ static int psci_suspend_finisher(unsigne
 static int __maybe_unused cpu_psci_cpu_suspend(unsigned long index)
 {
 	int ret;
-	struct psci_power_state *state = __get_cpu_var(psci_power_state);
+	struct psci_power_state *state = __this_cpu_read(psci_power_state);
 	/*
 	 * idle state index 0 corresponds to wfi, should never be called
 	 * from the cpu_suspend operations
Index: linux/kernel/irq_work.c
===================================================================
--- linux.orig/kernel/irq_work.c
+++ linux/kernel/irq_work.c
@@ -175,11 +175,11 @@ EXPORT_SYMBOL_GPL(irq_work_run);

 void irq_work_tick(void)
 {
-	struct llist_head *raised = &__get_cpu_var(raised_list);
+	struct llist_head *raised = this_cpu_ptr(&raised_list);

 	if (!llist_empty(raised) && !arch_irq_work_has_interrupt())
 		irq_work_run_list(raised);
-	irq_work_run_list(&__get_cpu_var(lazy_list));
+	irq_work_run_list(this_cpu_ptr(&lazy_list));
 }

 /*
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -235,7 +235,7 @@ void tick_nohz_full_kick(void)
 	if (!tick_nohz_full_cpu(smp_processor_id()))
 		return;

-	irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+	irq_work_queue(this_cpu_ptr(&nohz_full_kick_work));
 }

 /*
