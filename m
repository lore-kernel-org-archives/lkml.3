Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbaJ1Wfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:35:54 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37428 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863AbaJ1WeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:34:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/6] rcutorture: Add early boot self tests
Date: Tue, 28 Oct 2014 15:30:01 -0700
Message-Id: <1414535405-30228-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028222929.GA29476@linux.vnet.ibm.com>
 <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0025-0000-0000-000000F0726C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Add early boot self tests for RCU under CONFIG_PROVE_RCU.

Currently the only test is adding a dummy callback which increments a counter
which we then later verify after calling rcu_barrier*().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/rcu.h    |  2 ++
 kernel/rcu/tiny.c   |  4 ++-
 kernel/rcu/tree.c   |  2 ++
 kernel/rcu/update.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index ff1a6de62f17..07bb02eda844 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -135,4 +135,6 @@ int rcu_jiffies_till_stall_check(void);
  */
 #define TPS(x)  tracepoint_string(x)
 
+void rcu_early_boot_tests(void);
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index c0623fc47125..d3d44c589122 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -380,7 +380,9 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
-void rcu_init(void)
+void __init rcu_init(void)
 {
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+
+	rcu_early_boot_tests();
 }
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 9815447d22e0..77b48f03c077 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3766,6 +3766,8 @@ void __init rcu_init(void)
 	pm_notifier(rcu_pm_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
+
+	rcu_early_boot_tests();
 }
 
 #include "tree_plugin.h"
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 3ef8ba58694e..99d47e6a280f 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -690,3 +690,87 @@ static void rcu_spawn_tasks_kthread(void)
 }
 
 #endif /* #ifdef CONFIG_TASKS_RCU */
+
+#ifdef CONFIG_PROVE_RCU
+
+/*
+ * Early boot self test parameters, one for each flavor
+ */
+static bool rcu_self_test;
+static bool rcu_self_test_bh;
+static bool rcu_self_test_sched;
+
+module_param(rcu_self_test, bool, 0444);
+module_param(rcu_self_test_bh, bool, 0444);
+module_param(rcu_self_test_sched, bool, 0444);
+
+static int rcu_self_test_counter;
+
+static void test_callback(struct rcu_head *r)
+{
+	rcu_self_test_counter++;
+	pr_info("RCU test callback executed %d\n", rcu_self_test_counter);
+}
+
+static void early_boot_test_call_rcu(void)
+{
+	static struct rcu_head head;
+
+	call_rcu(&head, test_callback);
+}
+
+static void early_boot_test_call_rcu_bh(void)
+{
+	static struct rcu_head head;
+
+	call_rcu_bh(&head, test_callback);
+}
+
+static void early_boot_test_call_rcu_sched(void)
+{
+	static struct rcu_head head;
+
+	call_rcu_sched(&head, test_callback);
+}
+
+void rcu_early_boot_tests(void)
+{
+	pr_info("Running RCU self tests\n");
+
+	if (rcu_self_test)
+		early_boot_test_call_rcu();
+	if (rcu_self_test_bh)
+		early_boot_test_call_rcu_bh();
+	if (rcu_self_test_sched)
+		early_boot_test_call_rcu_sched();
+}
+
+static int rcu_verify_early_boot_tests(void)
+{
+	int ret = 0;
+	int early_boot_test_counter = 0;
+
+	if (rcu_self_test) {
+		early_boot_test_counter++;
+		rcu_barrier();
+	}
+	if (rcu_self_test_bh) {
+		early_boot_test_counter++;
+		rcu_barrier_bh();
+	}
+	if (rcu_self_test_sched) {
+		early_boot_test_counter++;
+		rcu_barrier_sched();
+	}
+
+	if (rcu_self_test_counter != early_boot_test_counter) {
+		WARN_ON(1);
+		ret = -1;
+	}
+
+	return ret;
+}
+late_initcall(rcu_verify_early_boot_tests);
+#else
+void rcu_early_boot_tests(void) {}
+#endif /* CONFIG_PROVE_RCU */
-- 
1.8.1.5

