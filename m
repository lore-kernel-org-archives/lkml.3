Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaBNUXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:23:39 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:42175 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380AbaBNUUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:20:37 -0500
Message-Id: <20140214201908.182470299@linux.com>
Date: Fri, 14 Feb 2014 14:19:21 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 40/48] powerpc: Handle new __get_cpu_var calls in 3.14
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=powerpc_new
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/powerpc/kernel/irq.c
===================================================================
--- linux.orig/arch/powerpc/kernel/irq.c	2014-02-03 14:16:29.028411561 -0600
+++ linux/arch/powerpc/kernel/irq.c	2014-02-03 14:27:59.283978219 -0600
@@ -486,7 +486,7 @@
 
 	/* And finally process it */
 	if (unlikely(irq == NO_IRQ))
-		__get_cpu_var(irq_stat).spurious_irqs++;
+		__this_cpu_inc(irq_stat.spurious_irqs);
 	else {
 		desc = irq_to_desc(irq);
 		if (likely(desc))
Index: linux/arch/powerpc/kernel/kgdb.c
===================================================================
--- linux.orig/arch/powerpc/kernel/kgdb.c	2014-01-28 11:24:05.156637470 -0600
+++ linux/arch/powerpc/kernel/kgdb.c	2014-02-03 14:22:38.680680583 -0600
@@ -155,7 +155,7 @@
 {
 	struct thread_info *thread_info, *exception_thread_info;
 	struct thread_info *backup_current_thread_info =
-		&__get_cpu_var(kgdb_thread_info);
+		this_cpu_ptr(&kgdb_thread_info);
 
 	if (user_mode(regs))
 		return 0;
Index: linux/arch/powerpc/kernel/mce.c
===================================================================
--- linux.orig/arch/powerpc/kernel/mce.c	2014-01-28 11:24:05.156637470 -0600
+++ linux/arch/powerpc/kernel/mce.c	2014-02-03 14:26:27.685893903 -0600
@@ -73,8 +73,8 @@
 		    uint64_t addr)
 {
 	uint64_t srr1;
-	int index = __get_cpu_var(mce_nest_count)++;
-	struct machine_check_event *mce = &__get_cpu_var(mce_event[index]);
+	int index = __this_cpu_inc_return(mce_nest_count);
+	struct machine_check_event *mce = __this_cpu_read(mce_event[index]);
 
 	/*
 	 * Return if we don't have enough space to log mce event.
@@ -143,7 +143,7 @@
  */
 int get_mce_event(struct machine_check_event *mce, bool release)
 {
-	int index = __get_cpu_var(mce_nest_count) - 1;
+	int index = __this_cpu_read(mce_nest_count) - 1;
 	struct machine_check_event *mc_evt;
 	int ret = 0;
 
@@ -153,7 +153,7 @@
 
 	/* Check if we have MCE info to process. */
 	if (index < MAX_MC_EVT) {
-		mc_evt = &__get_cpu_var(mce_event[index]);
+		mc_evt = __this_cpu_read(mce_event[index]);
 		/* Copy the event structure and release the original */
 		if (mce)
 			*mce = *mc_evt;
@@ -163,7 +163,7 @@
 	}
 	/* Decrement the count to free the slot. */
 	if (release)
-		__get_cpu_var(mce_nest_count)--;
+		__this_cpu_dec(mce_nest_count);
 
 	return ret;
 }
@@ -184,13 +184,13 @@
 	if (!get_mce_event(&evt, MCE_EVENT_RELEASE))
 		return;
 
-	index = __get_cpu_var(mce_queue_count)++;
+	index = __this_cpu_inc_return(mce_queue_count);
 	/* If queue is full, just return for now. */
 	if (index >= MAX_MC_EVT) {
-		__get_cpu_var(mce_queue_count)--;
+		__this_cpu_dec(mce_queue_count);
 		return;
 	}
-	__get_cpu_var(mce_event_queue[index]) = evt;
+	__this_cpu_write(mce_event_queue[index], evt);
 
 	/* Queue irq work to process this event later. */
 	irq_work_queue(&mce_event_process_work);
@@ -208,11 +208,11 @@
 	 * For now just print it to console.
 	 * TODO: log this error event to FSP or nvram.
 	 */
-	while (__get_cpu_var(mce_queue_count) > 0) {
-		index = __get_cpu_var(mce_queue_count) - 1;
+	while (__this_cpu_read(mce_queue_count) > 0) {
+		index = __this_cpu_read(mce_queue_count) - 1;
 		machine_check_print_event_info(
-				&__get_cpu_var(mce_event_queue[index]));
-		__get_cpu_var(mce_queue_count)--;
+				this_cpu_ptr(&mce_event_queue[index]));
+		__this_cpu_dec(mce_queue_count);
 	}
 }
 
Index: linux/arch/powerpc/kernel/time.c
===================================================================
--- linux.orig/arch/powerpc/kernel/time.c	2014-02-03 14:16:29.028411561 -0600
+++ linux/arch/powerpc/kernel/time.c	2014-02-03 14:27:26.854657482 -0600
@@ -531,7 +531,7 @@
 		*next_tb = ~(u64)0;
 		if (evt->event_handler)
 			evt->event_handler(evt);
-		__get_cpu_var(irq_stat).timer_irqs_event++;
+		__this_cpu_inc(irq_stat.timer_irqs_event);
 	} else {
 		now = *next_tb - now;
 		if (now <= DECREMENTER_MAX)
@@ -539,7 +539,7 @@
 		/* We may have raced with new irq work */
 		if (test_irq_work_pending())
 			set_dec(1);
-		__get_cpu_var(irq_stat).timer_irqs_others++;
+		__this_cpu_inc(irq_stat.timer_irqs_others);
 	}
 
 #ifdef CONFIG_PPC64
Index: linux/arch/powerpc/mm/hugetlbpage-book3e.c
===================================================================
--- linux.orig/arch/powerpc/mm/hugetlbpage-book3e.c	2014-02-03 14:16:29.038411354 -0600
+++ linux/arch/powerpc/mm/hugetlbpage-book3e.c	2014-02-03 14:22:04.551394132 -0600
@@ -33,7 +33,7 @@
 
 	ncams = mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY;
 
-	index = __get_cpu_var(next_tlbcam_idx);
+	index = this_cpu_read(next_tlbcam_idx);
 
 	/* Just round-robin the entries and wrap when we hit the end */
 	if (unlikely(index == ncams - 1))

