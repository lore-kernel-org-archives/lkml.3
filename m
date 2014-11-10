Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaKJS05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:26:57 -0500
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:57672 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbaKJS04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:26:56 -0500
Date: Mon, 10 Nov 2014 12:26:51 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [NOHZ] Remove scheduler_tick_max_deferment
In-Reply-To: <20141110153147.GK4901@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1411101226310.12918@gentwo.org>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org> <alpine.DEB.2.11.1411012003390.5308@nanos> <alpine.DEB.2.11.1411011646280.7732@gentwo.org> <alpine.DEB.2.11.1411012313320.5308@nanos> <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
 <CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com> <20141110153147.GK4901@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Would it make sense for unlimited max deferment to be available as
> a boot parameter?  That would allow people who want tick-free execution
> more than accurate stats to get that easily, while keeping stats accurate
> for everyone else.

Subject: Make the maximum tick deferral for CONFIG_NO_HZ configurable

Add a way to configure this interval at boot and via
/proc/sys/vm/max_defer_tick

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/sched/core.c
===================================================================
--- linux.orig/kernel/sched/core.c
+++ linux/kernel/sched/core.c
@@ -2574,6 +2574,17 @@ void scheduler_tick(void)
 }

 #ifdef CONFIG_NO_HZ_FULL
+int sysctl_max_defer_tick __read_mostly = 1;
+
+static int __init max_defer_tick_setup(char *str)
+{
+	sysctl_max_defer_tick = simple_strtol(str, NULL, 0);
+	pr_info("NO_HZ_FULL maxinum deferral of busy tick set to %d\n",
+		sysctl_max_defer_tick);
+	return 1;
+}
+__setup("max_defer_tick=", max_defer_tick_setup);
+
 /**
  * scheduler_tick_max_deferment
  *
@@ -2592,7 +2603,7 @@ u64 scheduler_tick_max_deferment(void)
 	struct rq *rq = this_rq();
 	unsigned long next, now = ACCESS_ONCE(jiffies);

-	next = rq->last_sched_tick + HZ;
+	next = rq->last_sched_tick + sysctl_max_defer_tick * HZ;

 	if (time_before_eq(next, now))
 		return 0;
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -1407,6 +1407,15 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 #endif
+#ifdef CONFIG_NO_HZ_FULL
+	{
+		.procname	= "max_defer_tick",
+		.data		= &sysctl_max_defer_tick,
+		.maxlen		= sizeof(sysctl_max_defer_tick),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+#endif
 #ifdef CONFIG_MMU
 	{
 		.procname	= "mmap_min_addr",
Index: linux/Documentation/sysctl/vm.txt
===================================================================
--- linux.orig/Documentation/sysctl/vm.txt
+++ linux/Documentation/sysctl/vm.txt
@@ -714,6 +714,13 @@ is 1 second.

 ==============================================================

+max_defer_tick
+
+The maximum time that the tick may be deferred while a process is
+monopolizing a cpu.
+
+==============================================================
+
 swappiness

 This control is used to define how aggressive the kernel will swap
Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -1876,6 +1876,10 @@ bytes respectively. Such letter suffixes
 			devices can be requested on-demand with the
 			/dev/loop-control interface.

+	max_defer_tick	[NO_HZ_FULL] The number of seconds that the system may
+			defer the timer tick if a process is monopolizing the
+			cpu.
+
 	mce		[X86-32] Machine Check Exception

 	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.txt
Index: linux/include/linux/sched/sysctl.h
===================================================================
--- linux.orig/include/linux/sched/sysctl.h
+++ linux/include/linux/sched/sysctl.h
@@ -53,6 +53,10 @@ extern unsigned int sysctl_numa_balancin
 extern unsigned int sysctl_numa_balancing_scan_period_max;
 extern unsigned int sysctl_numa_balancing_scan_size;

+#ifdef CONFIG_NO_HZ_FULL
+extern int sysctl_max_defer_tick;
+#endif
+
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
