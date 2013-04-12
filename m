Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3DLXtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:49:31 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43649 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab3DLXsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:48:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/12] rcu: Consolidate rcutiny_plugin.h ifdefs
Date: Fri, 12 Apr 2013 16:48:29 -0700
Message-Id: <1365810511-24811-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365810511-24811-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130412234810.GA23678@linux.vnet.ibm.com>
 <1365810511-24811-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-5406-0000-0000-0000076934B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit rearranges code in order to allow ifdefs to be consolidated
in kernel/rcutiny_plugin.h, simplifying the code.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h | 86 +++++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 46 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index bac3a6e..65ef180 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -53,54 +53,10 @@ static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 };
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
+#include <linux/kernel_stat.h>
+
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
-
-#ifdef CONFIG_RCU_TRACE
-
-static void check_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-	unsigned long j;
-	unsigned long js;
-
-	if (rcu_cpu_stall_suppress)
-		return;
-	rcp->ticks_this_gp++;
-	j = jiffies;
-	js = rcp->jiffies_stall;
-	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
-		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
-		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
-		       jiffies - rcp->gp_start, rcp->qlen);
-		dump_stack();
-	}
-	if (*rcp->curtail && ULONG_CMP_GE(j, js))
-		rcp->jiffies_stall = jiffies +
-			3 * rcu_jiffies_till_stall_check() + 3;
-	else if (ULONG_CMP_GE(j, js))
-		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
-}
-
-#endif /* #ifdef CONFIG_RCU_TRACE */
-
-static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
-{
-#ifdef CONFIG_RCU_TRACE
-	rcp->ticks_this_gp = 0;
-	rcp->gp_start = jiffies;
-	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
-#endif /* #ifdef CONFIG_RCU_TRACE */
-}
-
-static void check_cpu_stalls(void)
-{
-	RCU_TRACE(check_cpu_stall(&rcu_bh_ctrlblk));
-	RCU_TRACE(check_cpu_stall(&rcu_sched_ctrlblk));
-}
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-#include <linux/kernel_stat.h>
 
 /*
  * During boot, we forgive RCU lockdep issues.  After this function is
@@ -179,4 +135,42 @@ MODULE_AUTHOR("Paul E. McKenney");
 MODULE_DESCRIPTION("Read-Copy Update tracing for tiny implementation");
 MODULE_LICENSE("GPL");
 
+static void check_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	unsigned long j;
+	unsigned long js;
+
+	if (rcu_cpu_stall_suppress)
+		return;
+	rcp->ticks_this_gp++;
+	j = jiffies;
+	js = rcp->jiffies_stall;
+	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
+		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
+		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
+		       jiffies - rcp->gp_start, rcp->qlen);
+		dump_stack();
+	}
+	if (*rcp->curtail && ULONG_CMP_GE(j, js))
+		rcp->jiffies_stall = jiffies +
+			3 * rcu_jiffies_till_stall_check() + 3;
+	else if (ULONG_CMP_GE(j, js))
+		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+}
+
 #endif /* #ifdef CONFIG_RCU_TRACE */
+
+static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
+{
+#ifdef CONFIG_RCU_TRACE
+	rcp->ticks_this_gp = 0;
+	rcp->gp_start = jiffies;
+	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+#endif /* #ifdef CONFIG_RCU_TRACE */
+}
+
+static void check_cpu_stalls(void)
+{
+	RCU_TRACE(check_cpu_stall(&rcu_bh_ctrlblk));
+	RCU_TRACE(check_cpu_stall(&rcu_sched_ctrlblk));
+}
-- 
1.8.1.5

