Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbbAXOIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:08:48 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:39627 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbbAXOEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:11 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 14/32] rcu: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:20 -0500
Message-Id: <1422108218-25398-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 3ec85cb..26e04cf 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -53,7 +53,6 @@ DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
 static bool have_rcu_nocb_mask;	    /* Was rcu_nocb_mask allocated? */
 static bool __read_mostly rcu_nocb_poll;    /* Offload kthread are to poll. */
-static char __initdata nocb_buf[NR_CPUS * 5];
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 /*
@@ -2513,8 +2512,8 @@ void __init rcu_init_nohz(void)
 		cpumask_and(rcu_nocb_mask, cpu_possible_mask,
 			    rcu_nocb_mask);
 	}
-	cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
-	pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
+	pr_info("\tOffload RCU callbacks from CPUs: %*pbl.\n",
+		cpumask_pr_args(rcu_nocb_mask));
 	if (rcu_nocb_poll)
 		pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
 
-- 
2.1.0

