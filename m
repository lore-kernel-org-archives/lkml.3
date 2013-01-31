Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3AaMLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:11:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:55860 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3AaMLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:11:17 -0500
Message-Id: <20130131120741.823640323@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 31 Jan 2013 12:11:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 05/40] cpu: Restructure cpu_down code
References: <20130131120348.372374706@linutronix.de>
Content-Disposition: inline; filename=cpu-hotplug-split-out-cpu-up.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out into separate functions, so we can convert it to a state machine.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/cpu.c |   69 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 22 deletions(-)

Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -168,6 +168,43 @@ static int cpu_notify(unsigned long val,
 	return __cpu_notify(val, cpu, -1, NULL);
 }
 
+/* Notifier wrappers for transitioning to state machine */
+static int notify_prepare(unsigned int cpu)
+{
+	int nr_calls = 0;
+	int ret;
+
+	ret = __cpu_notify(CPU_UP_PREPARE, cpu, -1, &nr_calls);
+	if (ret) {
+		nr_calls--;
+		printk(KERN_WARNING "%s: attempt to bring up CPU %u failed\n",
+				__func__, cpu);
+		__cpu_notify(CPU_UP_CANCELED, cpu, nr_calls, NULL);
+	}
+	return ret;
+}
+
+static int notify_online(unsigned int cpu)
+{
+	cpu_notify(CPU_ONLINE, cpu);
+	return 0;
+}
+
+static int bringup_cpu(unsigned int cpu)
+{
+	struct task_struct *idle = idle_thread_get(cpu);
+	int ret;
+
+	/* Arch-specific enabling code. */
+	ret = __cpu_up(cpu, idle);
+	if (ret) {
+		cpu_notify(CPU_UP_CANCELED, cpu);
+		return ret;
+	}
+	BUG_ON(!cpu_online(cpu));
+	return 0;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 static void cpu_notify_nofail(unsigned long val, unsigned int cpu)
@@ -340,7 +377,7 @@ EXPORT_SYMBOL(cpu_down);
 static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 {
 	struct task_struct *idle;
-	int ret, nr_calls = 0;
+	int ret;
 
 	cpu_hotplug_begin();
 
@@ -355,35 +392,23 @@ static int __cpuinit _cpu_up(unsigned in
 		goto out;
 	}
 
+	cpuhp_tasks_frozen = tasks_frozen;
+
 	ret = smpboot_create_threads(cpu);
 	if (ret)
 		goto out;
 
-	cpuhp_tasks_frozen = tasks_frozen;
-
-	ret = __cpu_notify(CPU_UP_PREPARE, cpu, -1, &nr_calls);
-	if (ret) {
-		nr_calls--;
-		printk(KERN_WARNING "%s: attempt to bring up CPU %u failed\n",
-				__func__, cpu);
-		goto out_notify;
-	}
+	ret = notify_prepare(cpu);
+	if (ret)
+		goto out;
 
-	/* Arch-specific enabling code. */
-	ret = __cpu_up(cpu, idle);
-	if (ret != 0)
-		goto out_notify;
-	BUG_ON(!cpu_online(cpu));
+	ret = bringup_cpu(cpu);
+	if (ret)
+		goto out;
 
 	/* Wake the per cpu threads */
 	smpboot_unpark_threads(cpu);
-
-	/* Now call notifier in preparation. */
-	cpu_notify(CPU_ONLINE, cpu);
-
-out_notify:
-	if (ret != 0)
-		__cpu_notify(CPU_UP_CANCELED, cpu, nr_calls, NULL);
+	notify_online(cpu);
 out:
 	cpu_hotplug_done();
 


