Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119AbaGYAiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:38:10 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:44196 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934872AbaGYAiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:38:08 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH v2 1/2] rcu: Create a function for rcu_nocb_mask boot time setup
Date: Thu, 24 Jul 2014 20:37:31 -0400
Message-Id: <1406248652-17416-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit creates a function rcu_bootup_announce_oddness_nocb(), which handles
allocation of rcu_nocb_mask and setting it according to the kernel configuration
parameters.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
v2: don't break the print string (comment from paulmck)

 kernel/rcu/tree_plugin.h | 61 +++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c31eb28..520538a 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -47,6 +47,39 @@ static char __initdata nocb_buf[NR_CPUS * 5];
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 /*
+ * This is a helper for rcu_bootup_announce_oddness(), which takes care of
+ * setting up rcu_nocb_mask for nocb specific kernel configuration parameters
+ */
+static void __init rcu_bootup_announce_oddness_nocb(void)
+{
+#ifndef CONFIG_RCU_NOCB_CPU_NONE
+	if (!have_rcu_nocb_mask) {
+		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
+		have_rcu_nocb_mask = true;
+	}
+#ifdef CONFIG_RCU_NOCB_CPU_ZERO
+	pr_info("\tOffload RCU callbacks from CPU 0\n");
+	cpumask_set_cpu(0, rcu_nocb_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
+#ifdef CONFIG_RCU_NOCB_CPU_ALL
+	pr_info("\tOffload RCU callbacks from all CPUs\n");
+	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
+	if (have_rcu_nocb_mask) {
+		if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
+			pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
+			cpumask_and(rcu_nocb_mask, cpu_possible_mask,
+				    rcu_nocb_mask);
+		}
+		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
+		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
+		if (rcu_nocb_poll)
+			pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
+	}
+}
+
+/*
  * Check the RCU kernel configuration parameters and print informative
  * messages about anything out of the ordinary.  If you like #ifdef, you
  * will love this function.
@@ -86,32 +119,8 @@ static void __init rcu_bootup_announce_oddness(void)
 	if (nr_cpu_ids != NR_CPUS)
 		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 #ifdef CONFIG_RCU_NOCB_CPU
-#ifndef CONFIG_RCU_NOCB_CPU_NONE
-	if (!have_rcu_nocb_mask) {
-		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
-		have_rcu_nocb_mask = true;
-	}
-#ifdef CONFIG_RCU_NOCB_CPU_ZERO
-	pr_info("\tOffload RCU callbacks from CPU 0\n");
-	cpumask_set_cpu(0, rcu_nocb_mask);
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
-#ifdef CONFIG_RCU_NOCB_CPU_ALL
-	pr_info("\tOffload RCU callbacks from all CPUs\n");
-	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
-#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
-	if (have_rcu_nocb_mask) {
-		if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
-			pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
-			cpumask_and(rcu_nocb_mask, cpu_possible_mask,
-				    rcu_nocb_mask);
-		}
-		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
-		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
-		if (rcu_nocb_poll)
-			pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
-	}
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
+	rcu_bootup_announce_oddness_nocb();
+#endif
 }
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
-- 
2.0.1

