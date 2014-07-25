Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935193AbaGYAiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:38:19 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:33162 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935059AbaGYAiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:38:10 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH v2 2/2] rcu: Check the return value of rcu_nocb_mask cpumask allocation
Date: Thu, 24 Jul 2014 20:37:32 -0400
Message-Id: <1406248652-17416-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406248652-17416-1-git-send-email-bobby.prani@gmail.com>
References: <1406248652-17416-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit checks the return value of the zalloc_cpumask_var() used for
allocating cpumask for rcu_nocb_mask.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
v2: no change from v1

 kernel/rcu/tree_plugin.h | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 520538a..9c9a01c 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -54,7 +54,10 @@ static void __init rcu_bootup_announce_oddness_nocb(void)
 {
 #ifndef CONFIG_RCU_NOCB_CPU_NONE
 	if (!have_rcu_nocb_mask) {
-		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
+		if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
+			pr_info("rcu_nocb_mask allocation failed\n");
+			return;
+		}
 		have_rcu_nocb_mask = true;
 	}
 #ifdef CONFIG_RCU_NOCB_CPU_ZERO
@@ -66,17 +69,15 @@ static void __init rcu_bootup_announce_oddness_nocb(void)
 	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
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
+	if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
+		pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
+		cpumask_and(rcu_nocb_mask, cpu_possible_mask,
+				rcu_nocb_mask);
 	}
+	cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
+	pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
+	if (rcu_nocb_poll)
+		pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
 }
 
 /*
-- 
2.0.1

