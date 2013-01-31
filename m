Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3AaMSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:18:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:55993 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3AaML3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:29 -0500
Message-Id: <20130131120742.853625949@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 20/40] perf: Remove perf cpu notifier code
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=perf-remove-perf-cpu-notifier.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users converted to state machine callbacks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpu.h        |    2 --
 include/linux/perf_event.h |   21 ---------------------
 2 files changed, 23 deletions(-)

Index: linux-2.6/include/linux/cpu.h
===================================================================
--- linux-2.6.orig/include/linux/cpu.h
+++ linux-2.6/include/linux/cpu.h
@@ -58,8 +58,6 @@ extern ssize_t arch_print_cpu_modalias(s
  * CPU notifier priorities.
  */
 enum {
-	/* migration should happen before other stuff but after perf */
-	CPU_PRI_PERF		= 20,
 	CPU_PRI_MIGRATION	= 10,
 	/* bring up workqueues before normal notifiers and down after */
 	CPU_PRI_WORKQUEUE_UP	= 5,
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -796,27 +796,6 @@ static inline void perf_event_task_tick(
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
 
-/*
- * This has to have a higher priority than migration_notifier in sched.c.
- */
-#define perf_cpu_notifier(fn)						\
-do {									\
-	static struct notifier_block fn##_nb __cpuinitdata =		\
-		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
-	unsigned long cpu = smp_processor_id();				\
-	unsigned long flags;						\
-	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
-		(void *)(unsigned long)cpu);				\
-	local_irq_save(flags);						\
-	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
-		(void *)(unsigned long)cpu);				\
-	local_irq_restore(flags);					\
-	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
-		(void *)(unsigned long)cpu);				\
-	register_cpu_notifier(&fn##_nb);				\
-} while (0)
-
-
 #define PMU_FORMAT_ATTR(_name, _format)					\
 static ssize_t								\
 _name##_show(struct device *dev,					\


