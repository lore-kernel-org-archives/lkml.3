Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3IEUHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:07:40 -0400
Received: from a10-13.smtp-out.amazonses.com ([54.240.10.13]:37841 "EHLO
	a10-13.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633Ab3IEUHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:07:38 -0400
Date: Thu, 5 Sep 2013 20:07:37 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus. 
Message-ID: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.05-54.240.10.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure how to call this kernel option but we need something like
that. I see drivers and the kernel spawning processes on the nohz cores.
The name kthread is not really catching the purpose.

os_cpus=? highlatency_cpus=?


Subject: Restrict kernel spawning of threads to a specified set of cpus.

Currently the kernel by default allows kernel threads to be spawned on
any cpu. This is a problem for low latency applications that want to
avoid Os actions on specific processors.

Add a kernel option that restrict kthread and usermode spawning
to a specific set of processors. Also sets the affinities of
init by default to the restricted set since we certainly do not
want userspace daemons etc to be started there either.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/cpumask.h
===================================================================
--- linux.orig/include/linux/cpumask.h	2013-09-05 14:55:32.033229179 -0500
+++ linux/include/linux/cpumask.h	2013-09-05 14:55:32.021229296 -0500
@@ -44,6 +44,7 @@ extern int nr_cpu_ids;
  *     cpu_present_mask - has bit 'cpu' set iff cpu is populated
  *     cpu_online_mask  - has bit 'cpu' set iff cpu available to scheduler
  *     cpu_active_mask  - has bit 'cpu' set iff cpu available to migration
+ *     cpu_kthread_mask -  has bit 'cpu' set iff general kernel threads allowed
  *
  *  If !CONFIG_HOTPLUG_CPU, present == possible, and active == online.
  *
@@ -80,6 +81,7 @@ extern const struct cpumask *const cpu_p
 extern const struct cpumask *const cpu_online_mask;
 extern const struct cpumask *const cpu_present_mask;
 extern const struct cpumask *const cpu_active_mask;
+extern const struct cpumask *const cpu_kthread_mask;

 #if NR_CPUS > 1
 #define num_online_cpus()	cpumask_weight(cpu_online_mask)
Index: linux/init/main.c
===================================================================
--- linux.orig/init/main.c	2013-09-05 14:55:32.033229179 -0500
+++ linux/init/main.c	2013-09-05 14:55:32.025229258 -0500
@@ -882,6 +882,7 @@ static noinline void __init kernel_init_

 	do_basic_setup();

+	set_cpus_allowed_ptr(current, cpu_kthread_mask);
 	/* Open the /dev/console on the rootfs, this should never fail */
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
 		pr_err("Warning: unable to open an initial console.\n");
Index: linux/kernel/cpu.c
===================================================================
--- linux.orig/kernel/cpu.c	2013-09-05 14:55:32.033229179 -0500
+++ linux/kernel/cpu.c	2013-09-05 14:55:32.025229258 -0500
@@ -677,6 +677,19 @@ static DECLARE_BITMAP(cpu_active_bits, C
 const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
 EXPORT_SYMBOL(cpu_active_mask);

+static DECLARE_BITMAP(cpu_kthread_bits, CONFIG_NR_CPUS) __read_mostly
+	= CPU_BITS_ALL;
+const struct cpumask *const cpu_kthread_mask = to_cpumask(cpu_kthread_bits);
+EXPORT_SYMBOL(cpu_kthread_mask);
+
+static int __init kthread_setup(char *str)
+{
+        cpulist_parse(str, (struct cpumask *)&cpu_kthread_bits);
+        return 1;
+}
+__setup("kthread=", kthread_setup);
+
+
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
Index: linux/kernel/kthread.c
===================================================================
--- linux.orig/kernel/kthread.c	2013-09-05 14:55:32.033229179 -0500
+++ linux/kernel/kthread.c	2013-09-05 14:55:32.025229258 -0500
@@ -282,7 +282,7 @@ struct task_struct *kthread_create_on_no
 		 * The kernel thread should not inherit these properties.
 		 */
 		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
-		set_cpus_allowed_ptr(create.result, cpu_all_mask);
+		set_cpus_allowed_ptr(create.result, cpu_kthread_mask);
 	}
 	return create.result;
 }
@@ -450,7 +450,7 @@ int kthreadd(void *unused)
 	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
-	set_cpus_allowed_ptr(tsk, cpu_all_mask);
+	set_cpus_allowed_ptr(tsk, cpu_kthread_mask);
 	set_mems_allowed(node_states[N_MEMORY]);

 	current->flags |= PF_NOFREEZE;
Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt	2013-09-05 14:55:32.033229179 -0500
+++ linux/Documentation/kernel-parameters.txt	2013-09-05 14:58:38.839366991 -0500
@@ -1400,6 +1400,16 @@ bytes respectively. Such letter suffixes
 	kstack=N	[X86] Print N words from the kernel stack
 			in oops dumps.

+	kthread=	[KNL, SMP] Only run kernel threads on the specified
+			list of processors. The kernel will start threads
+			on the indicated processors only (unless there
+			are specific reasons to run a thread with
+			different affinities). This can be used to make
+			init start on certain processors and also to
+			control where kmod and other user space threads
+			are being spawned. Allows to keep kernel threads
+			away from certain cores unless absoluteluy necessary.
+
 	kvm.ignore_msrs=[KVM] Ignore guest accesses to unhandled MSRs.
 			Default is 0 (don't ignore, but inject #GP)

Index: linux/kernel/kmod.c
===================================================================
--- linux.orig/kernel/kmod.c	2013-09-05 14:55:24.000000000 -0500
+++ linux/kernel/kmod.c	2013-09-05 14:56:29.412657249 -0500
@@ -209,8 +209,8 @@ static int ____call_usermodehelper(void
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);

-	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, cpu_all_mask);
+	/* We can run only where init is allowed to run. */
+	set_cpus_allowed_ptr(current, cpu_kthread_mask);

 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
