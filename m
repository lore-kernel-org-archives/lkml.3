Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab3CRVhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:37:23 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43570 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab3CRVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:37:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/15] rcu: Rename n_nocb_gp_requests to need_future_gp
Date: Mon, 18 Mar 2013 14:36:48 -0700
Message-Id: <1363642610-21390-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318213608.GA20296@linux.vnet.ibm.com>
 <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-5406-0000-0000-0000067F0CBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

CPUs going idle need to be able to indicate their need for future grace
periods.  A mechanism for doing this already exists for no-callbacks
CPUs, so the idea is to re-use that mechanism.  This commit therefore
moves the ->n_nocb_gp_requests field of the rcu_node structure out from
under the CONFIG_RCU_NOCB_CPU #ifdef and renames it to ->need_future_gp.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.h        |  4 ++--
 kernel/rcutree_plugin.h | 18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 96a27f9..034b524 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -194,9 +194,9 @@ struct rcu_node {
 #ifdef CONFIG_RCU_NOCB_CPU
 	wait_queue_head_t nocb_gp_wq[2];
 				/* Place for rcu_nocb_kthread() to wait GP. */
-	int n_nocb_gp_requests[2];
-				/* Counts of upcoming no-CB GP requests. */
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
+	int need_future_gp[2];
+				/* Counts of upcoming no-CB GP requests. */
 	raw_spinlock_t fqslock ____cacheline_internodealigned_in_smp;
 } ____cacheline_internodealigned_in_smp;
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 073ded2..f3f0020 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2018,7 +2018,7 @@ static int rcu_nocb_needs_gp(struct rcu_state *rsp)
 {
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	return rnp->n_nocb_gp_requests[(ACCESS_ONCE(rnp->completed) + 1) & 0x1];
+	return rnp->need_future_gp[(ACCESS_ONCE(rnp->completed) + 1) & 0x1];
 }
 
 /*
@@ -2032,8 +2032,8 @@ static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 	int needmore;
 
 	wake_up_all(&rnp->nocb_gp_wq[c & 0x1]);
-	rnp->n_nocb_gp_requests[c & 0x1] = 0;
-	needmore = rnp->n_nocb_gp_requests[(c + 1) & 0x1];
+	rnp->need_future_gp[c & 0x1] = 0;
+	needmore = rnp->need_future_gp[(c + 1) & 0x1];
 	trace_rcu_future_grace_period(rsp->name, rnp->gpnum, rnp->completed,
 				      c, rnp->level, rnp->grplo, rnp->grphi,
 				      needmore ? "CleanupMore" : "Cleanup");
@@ -2041,7 +2041,7 @@ static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 }
 
 /*
- * Set the root rcu_node structure's ->n_nocb_gp_requests field
+ * Set the root rcu_node structure's ->need_future_gp field
  * based on the sum of those of all rcu_node structures.  This does
  * double-count the root rcu_node structure's requests, but this
  * is necessary to handle the possibility of a rcu_nocb_kthread()
@@ -2050,7 +2050,7 @@ static int rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
  */
 static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
 {
-	rnp->n_nocb_gp_requests[(rnp->completed + 1) & 0x1] += nrq;
+	rnp->need_future_gp[(rnp->completed + 1) & 0x1] += nrq;
 }
 
 static void rcu_init_one_nocb(struct rcu_node *rnp)
@@ -2181,7 +2181,7 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	c = rnp->completed + 2;
 
 	/* Count our request for a grace period. */
-	rnp->n_nocb_gp_requests[c & 0x1]++;
+	rnp->need_future_gp[c & 0x1]++;
 	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
 				      rnp->completed, c, rnp->level,
 				      rnp->grplo, rnp->grphi, "Startleaf");
@@ -2225,10 +2225,10 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 			 * Adjust counters accordingly and start the
 			 * needed grace period.
 			 */
-			rnp->n_nocb_gp_requests[c & 0x1]--;
+			rnp->need_future_gp[c & 0x1]--;
 			c = rnp_root->completed + 1;
-			rnp->n_nocb_gp_requests[c & 0x1]++;
-			rnp_root->n_nocb_gp_requests[c & 0x1]++;
+			rnp->need_future_gp[c & 0x1]++;
+			rnp_root->need_future_gp[c & 0x1]++;
 			trace_rcu_future_grace_period(rdp->rsp->name,
 						      rnp->gpnum,
 						      rnp->completed,
-- 
1.8.1.5

