Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbaIRDV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:21:59 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:40357 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbaIRDV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:21:56 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [RFC PATCH 1/3] rcu: Add early boot self tests
Date: Wed, 17 Sep 2014 23:21:47 -0400
Message-Id: <1411010509-31927-3-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411010509-31927-1-git-send-email-bobby.prani@gmail.com>
References: <1411010509-31927-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add early boot self tests for RCU under CONFIG_PROVE_RCU.

Currently the only test is adding a dummy callback which increments a counter
which we then later verify after calling rcu_barrier*().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/rcu.h    |  2 ++
 kernel/rcu/tiny.c   |  4 ++-
 kernel/rcu/tree.c   |  2 ++
 kernel/rcu/update.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index ff1a6de..07bb02e 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -135,4 +135,6 @@ int rcu_jiffies_till_stall_check(void);
  */
 #define TPS(x)  tracepoint_string(x)
 
+void rcu_early_boot_tests(void);
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index c0623fc..d3d44c5 100644
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
index e4c6d60..f93a62c 100644
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
index 3ef8ba5..5929f0c 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -690,3 +690,94 @@ static void rcu_spawn_tasks_kthread(void)
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
+static bool rcu_self_test_srcu;
+
+module_param(rcu_self_test, bool, 0444);
+module_param(rcu_self_test_bh, bool, 0444);
+module_param(rcu_self_test_sched, bool, 0444);
+module_param(rcu_self_test_srcu, bool, 0444);
+
+static int rcu_self_test_counter;
+static struct rcu_head head;
+DEFINE_STATIC_SRCU(srcu_struct);
+
+static void test_callback(struct rcu_head *r)
+{
+	rcu_self_test_counter++;
+	pr_info("RCU test callback executed %d\n", rcu_self_test_counter);
+}
+
+static void early_boot_test_call_rcu(void)
+{
+	call_rcu(&head, test_callback);
+}
+
+static void early_boot_test_call_rcu_bh(void)
+{
+	call_rcu_bh(&head, test_callback);
+}
+
+static void early_boot_test_call_rcu_sched(void)
+{
+	call_rcu_sched(&head, test_callback);
+}
+
+static void early_boot_test_call_srcu(void)
+{
+	call_srcu(&srcu_struct, &head, test_callback);
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
+	if (rcu_self_test_srcu)
+		early_boot_test_call_srcu();
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
+	if (rcu_self_test_srcu) {
+		early_boot_test_counter++;
+		srcu_barrier(&srcu_struct);
+	}
+
+	if (rcu_self_test_counter != early_boot_test_counter)
+		ret = -1;
+
+	return ret;
+}
+late_initcall(rcu_verify_early_boot_tests);
+#else
+void rcu_early_boot_tests(void) {}
+#endif /* CONFIG_PROVE_RCU */
-- 
2.1.0

