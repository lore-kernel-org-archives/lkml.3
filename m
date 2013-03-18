Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab3CRVRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:17:37 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38621 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879Ab3CRVRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:17:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/7] rcu: Add softirq-stall indications to stall-warning messages
Date: Mon, 18 Mar 2013 14:16:55 -0700
Message-Id: <1363641416-18642-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363641416-18642-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318211615.GA15814@linux.vnet.ibm.com>
 <1363641416-18642-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-9360-0000-0000-0000116012CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If RCU's softirq handler is prevented from executing, an RCU CPU stall
warning can result.  Ways to prevent RCU's softirq handler from executing
include: (1) CPU spinning with interrupts disabled, (2) infinite loop
in some softirq handler, and (3) in -rt kernels, an infinite loop in a
set of real-time threads running at priorities higher than that of RCU's
softirq handler.

Because this situation can be difficult to track down, this commit causes
the count of RCU softirq handler invocations to be printed with RCU
CPU stall warnings.  This information does require some interpretation,
as now documented in Documentation/RCU/stallwarn.txt.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/RCU/stallwarn.txt | 33 ++++++++++++++++++++++++---------
 kernel/rcutree.h                |  5 +++++
 kernel/rcutree_plugin.h         |  4 +++-
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 1927151..e38b8df 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -92,14 +92,14 @@ If the CONFIG_RCU_CPU_STALL_INFO kernel configuration parameter is set,
 more information is printed with the stall-warning message, for example:
 
 	INFO: rcu_preempt detected stall on CPU
-	0: (63959 ticks this GP) idle=241/3fffffffffffffff/0
+	0: (63959 ticks this GP) idle=241/3fffffffffffffff/0 softirq=82/543
 	   (t=65000 jiffies)
 
 In kernels with CONFIG_RCU_FAST_NO_HZ, even more information is
 printed:
 
 	INFO: rcu_preempt detected stall on CPU
-	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer not pending
+	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 softirq=82/543 last_accelerate: a345/d342 nonlazy_posted: 25 .D
 	   (t=65000 jiffies)
 
 The "(64628 ticks this GP)" indicates that this CPU has taken more
@@ -116,13 +116,28 @@ number between the two "/"s is the value of the nesting, which will
 be a small positive number if in the idle loop and a very large positive
 number (as shown above) otherwise.
 
-For CONFIG_RCU_FAST_NO_HZ kernels, the "drain=0" indicates that the CPU is
-not in the process of trying to force itself into dyntick-idle state, the
-"." indicates that the CPU has not given up forcing RCU into dyntick-idle
-mode (it would be "H" otherwise), and the "timer not pending" indicates
-that the CPU has not recently forced RCU into dyntick-idle mode (it
-would otherwise indicate the number of microseconds remaining in this
-forced state).
+The "softirq=" portion of the message tracks the number of RCU softirq
+handlers that the stalled CPU has executed.  The number before the "/"
+is the number that had executed since boot at the time that this CPU
+last noted the beginning of a grace period, which might be the current
+(stalled) grace period, or it might be some earlier grace period (for
+example, if the CPU might have been in dyntick-idle mode for an extended
+time period.  The number after the "/" is the number that have executed
+since boot until the current time.  If this latter number stays constant
+across repeated stall-warning messages, it is possible that RCU's softirq
+handlers are no longer able to execute on this CPU.  This can happen if
+the stalled CPU is spinning with interrupts are disabled, or, in -rt
+kernels, if a high-priority process is starving RCU's softirq handler.
+
+For CONFIG_RCU_FAST_NO_HZ kernels, the "last_accelerate:" prints the
+low-order 16 bits (in hex) of the jiffies counter when this CPU last
+invoked rcu_try_advance_all_cbs() from rcu_needs_cpu() or last invoked
+rcu_accelerate_cbs() from rcu_prepare_for_idle().  The "nonlazy_posted:"
+prints the number of non-lazy callbacks posted since the last call to
+rcu_needs_cpu().  Finally, an "L" indicates that there are currently
+no non-lazy callbacks ("." is printed otherwise, as shown above) and
+"D" indicates that dyntick-idle processing is enabled ("." is printed
+otherwise, for example, if disabled via the "nohz=" kernel boot parameter).
 
 
 Multiple Warnings From One Stall
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 8e75609..26c9bb3 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -325,6 +325,11 @@ struct rcu_data {
 	struct task_struct *nocb_kthread;
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
+	/* 8) RCU CPU stall data. */
+#ifdef CONFIG_RCU_CPU_STALL_INFO
+	unsigned int softirq_snap;	/* Snapshot of softirq activity. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
+
 	int cpu;
 	struct rcu_state *rsp;
 };
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c1cc7e1..7fcd3bb 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2070,10 +2070,11 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 		ticks_value = rsp->gpnum - rdp->gpnum;
 	}
 	print_cpu_stall_fast_no_hz(fast_no_hz, cpu);
-	printk(KERN_ERR "\t%d: (%lu %s) idle=%03x/%llx/%d %s\n",
+	printk(KERN_ERR "\t%d: (%lu %s) idle=%03x/%llx/%d softirq=%u/%u %s\n",
 	       cpu, ticks_value, ticks_title,
 	       atomic_read(&rdtp->dynticks) & 0xfff,
 	       rdtp->dynticks_nesting, rdtp->dynticks_nmi_nesting,
+	       rdp->softirq_snap, kstat_softirqs_cpu(RCU_SOFTIRQ, cpu),
 	       fast_no_hz);
 }
 
@@ -2087,6 +2088,7 @@ static void print_cpu_stall_info_end(void)
 static void zero_cpu_stall_ticks(struct rcu_data *rdp)
 {
 	rdp->ticks_this_gp = 0;
+	rdp->softirq_snap = kstat_softirqs_cpu(RCU_SOFTIRQ, smp_processor_id());
 }
 
 /* Increment ->ticks_this_gp for all flavors of RCU. */
-- 
1.8.1.5

