Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaJ1V6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:58:13 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50947 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341AbaJ1V5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:57:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/10] rcu: Remove "cpu" argument to rcu_cleanup_after_idle()
Date: Tue, 28 Oct 2014 14:53:36 -0700
Message-Id: <1414533217-24910-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com>
 <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102821-0029-0000-0000-000000F4ECA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The "cpu" argument to rcu_cleanup_after_idle() is always the current
CPU, so drop it.  This moves the smp_processor_id() from the caller to
rcu_cleanup_after_idle(), saving argument-passing overhead.  Again,
the anticipated cross-CPU uses of these functions has been replaced
by NO_HZ_FULL.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 2 +-
 kernel/rcu/tree.h        | 2 +-
 kernel/rcu/tree_plugin.h | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8251938fb4ae..fa76fd3c219c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -661,7 +661,7 @@ static void rcu_eqs_exit_common(long long oldval, int user)
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
 	smp_mb__after_atomic();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
-	rcu_cleanup_after_idle(smp_processor_id());
+	rcu_cleanup_after_idle();
 	trace_rcu_dyntick(TPS("End"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle __maybe_unused =
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 8bc3cacbe14a..36c30390e4e9 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -579,7 +579,7 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 #endif /* #ifdef CONFIG_RCU_BOOST */
 static void __init rcu_spawn_boost_kthreads(void);
 static void rcu_prepare_kthreads(int cpu);
-static void rcu_cleanup_after_idle(int cpu);
+static void rcu_cleanup_after_idle(void);
 static void rcu_prepare_for_idle(void);
 static void rcu_idle_count_callbacks_posted(void);
 static void print_cpu_stall_info_begin(void);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 5e68ab5fe317..2443282737ba 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1523,7 +1523,7 @@ int rcu_needs_cpu(unsigned long *delta_jiffies)
  * Because we do not have RCU_FAST_NO_HZ, don't bother cleaning up
  * after it.
  */
-static void rcu_cleanup_after_idle(int cpu)
+static void rcu_cleanup_after_idle(void)
 {
 }
 
@@ -1731,10 +1731,10 @@ static void rcu_prepare_for_idle(void)
  * any grace periods that elapsed while the CPU was idle, and if any
  * callbacks are now ready to invoke, initiate invocation.
  */
-static void rcu_cleanup_after_idle(int cpu)
+static void rcu_cleanup_after_idle(void)
 {
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
-	if (rcu_is_nocb_cpu(cpu))
+	if (rcu_is_nocb_cpu(smp_processor_id()))
 		return;
 	if (rcu_try_advance_all_cbs())
 		invoke_rcu_core();
-- 
1.8.1.5

