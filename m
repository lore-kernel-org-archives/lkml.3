Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3AaMQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:16:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:56083 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3AaMLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:36 -0500
Message-Id: <20130131120743.390767686@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 28/40] cpuhotplug: Remove CPU_STARTING notifier
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline;
 filename=cpuhotplug-remove-cpu-starting-notifier.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users converted to state machine.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/cpu.h        |    6 ------
 include/linux/cpuhotplug.h |    1 -
 kernel/cpu.c               |   13 +------------
 3 files changed, 1 insertion(+), 19 deletions(-)

Index: linux-2.6/include/linux/cpu.h
===================================================================
--- linux-2.6.orig/include/linux/cpu.h
+++ linux-2.6/include/linux/cpu.h
@@ -67,10 +67,6 @@ extern ssize_t arch_print_cpu_modalias(s
 					* sleep, must not fail */
 #define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
 					* lock is dropped */
-#define CPU_STARTING		0x000A /* CPU (unsigned)v soon running.
-					* Called on the new cpu, just before
-					* enabling interrupts. Must not sleep,
-					* must not fail */
 
 /* Used for CPU hotplug events occurring while tasks are frozen due to a suspend
  * operation in progress
@@ -84,8 +80,6 @@ extern ssize_t arch_print_cpu_modalias(s
 #define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
 #define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
-#define CPU_STARTING_FROZEN	(CPU_STARTING | CPU_TASKS_FROZEN)
-
 
 #ifdef CONFIG_SMP
 extern bool cpuhp_tasks_frozen;
Index: linux-2.6/include/linux/cpuhotplug.h
===================================================================
--- linux-2.6.orig/include/linux/cpuhotplug.h
+++ linux-2.6/include/linux/cpuhotplug.h
@@ -26,7 +26,6 @@ enum cpuhp_states {
 	CPUHP_AP_ARM_VFP_STARTING,
 	CPUHP_AP_ARM64_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
-	CPUHP_AP_NOTIFY_STARTING,
 	CPUHP_AP_NOTIFY_DYING,
 	CPUHP_AP_SCHED_MIGRATE_DYING,
 	CPUHP_AP_MAX,
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -216,12 +216,6 @@ static int bringup_cpu(unsigned int cpu)
 	return 0;
 }
 
-static int notify_starting(unsigned int cpu)
-{
-	cpu_notify(CPU_STARTING, cpu);
-	return 0;
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 EXPORT_SYMBOL(register_cpu_notifier);
 
@@ -446,10 +440,9 @@ EXPORT_SYMBOL(cpu_down);
 #endif /*CONFIG_HOTPLUG_CPU*/
 
 /**
- * notify_cpu_starting(cpu) - call the CPU_STARTING notifiers
+ * notify_cpu_starting(cpu) - Invoke the callbacks on the starting CPU
  * @cpu: cpu that just started
  *
- * This function calls the cpu_chain notifiers with CPU_STARTING.
  * It must be called by the arch code on the new cpu, before the new cpu
  * enables interrupts and before the "boot" cpu returns from __cpu_up().
  */
@@ -816,10 +809,6 @@ static struct cpuhp_step cpuhp_ap_states
 		.startup = sched_starting_cpu,
 		.teardown = NULL,
 	},
-	[CPUHP_AP_NOTIFY_STARTING] = {
-		.startup = notify_starting,
-		.teardown = NULL,
-	},
 	[CPUHP_AP_NOTIFY_DYING] = {
 		.startup = NULL,
 		.teardown = notify_dying,


