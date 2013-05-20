Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab3ETOiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:38:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41276 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab3ETOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:38:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/8] rcu: Move code to apply callback-numbering simplifications
Date: Mon, 20 May 2013 07:38:08 -0700
Message-Id: <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130520143739.GA29365@linux.vnet.ibm.com>
References: <20130520143739.GA29365@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-5518-0000-0000-00000ED05309
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The addition of callback numbering allows combining the detection of the
ends of old grace periods and the beginnings of new grace periods.  This
commit moves code to set the stage for this combining.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 118 +++++++++++++++++++++++++++----------------------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 302eadf..9b6df03 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -985,65 +985,6 @@ void rcu_cpu_stall_reset(void)
 }
 
 /*
- * Update CPU-local rcu_data state to record the newly noticed grace period.
- * This is used both when we started the grace period and when we notice
- * that someone else started the grace period.  The caller must hold the
- * ->lock of the leaf rcu_node structure corresponding to the current CPU,
- *  and must have irqs disabled.
- */
-static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
-{
-	if (rdp->gpnum != rnp->gpnum) {
-		/*
-		 * If the current grace period is waiting for this CPU,
-		 * set up to detect a quiescent state, otherwise don't
-		 * go looking for one.
-		 */
-		rdp->gpnum = rnp->gpnum;
-		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpustart");
-		rdp->passed_quiesce = 0;
-		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
-		zero_cpu_stall_ticks(rdp);
-	}
-}
-
-static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-	unsigned long flags;
-	struct rcu_node *rnp;
-
-	local_irq_save(flags);
-	rnp = rdp->mynode;
-	if (rdp->gpnum == ACCESS_ONCE(rnp->gpnum) || /* outside lock. */
-	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, so later. */
-		local_irq_restore(flags);
-		return;
-	}
-	__note_new_gpnum(rsp, rnp, rdp);
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-}
-
-/*
- * Did someone else start a new RCU grace period start since we last
- * checked?  Update local state appropriately if so.  Must be called
- * on the CPU corresponding to rdp.
- */
-static int
-check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	local_irq_save(flags);
-	if (rdp->gpnum != rsp->gpnum) {
-		note_new_gpnum(rsp, rdp);
-		ret = 1;
-	}
-	local_irq_restore(flags);
-	return ret;
-}
-
-/*
  * Initialize the specified rcu_data structure's callback list to empty.
  */
 static void init_callback_list(struct rcu_data *rdp)
@@ -1360,6 +1301,45 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 }
 
 /*
+ * Update CPU-local rcu_data state to record the newly noticed grace period.
+ * This is used both when we started the grace period and when we notice
+ * that someone else started the grace period.  The caller must hold the
+ * ->lock of the leaf rcu_node structure corresponding to the current CPU,
+ *  and must have irqs disabled.
+ */
+static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+{
+	if (rdp->gpnum != rnp->gpnum) {
+		/*
+		 * If the current grace period is waiting for this CPU,
+		 * set up to detect a quiescent state, otherwise don't
+		 * go looking for one.
+		 */
+		rdp->gpnum = rnp->gpnum;
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpustart");
+		rdp->passed_quiesce = 0;
+		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
+		zero_cpu_stall_ticks(rdp);
+	}
+}
+
+static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	unsigned long flags;
+	struct rcu_node *rnp;
+
+	local_irq_save(flags);
+	rnp = rdp->mynode;
+	if (rdp->gpnum == ACCESS_ONCE(rnp->gpnum) || /* outside lock. */
+	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, so later. */
+		local_irq_restore(flags);
+		return;
+	}
+	__note_new_gpnum(rsp, rnp, rdp);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
  * Advance this CPU's callbacks, but only if the current grace period
  * has ended.  This may be called only from the CPU to whom the rdp
  * belongs.
@@ -1382,6 +1362,26 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
+ * Did someone else start a new RCU grace period start since we last
+ * checked?  Update local state appropriately if so.  Must be called
+ * on the CPU corresponding to rdp.
+ */
+static int
+check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	local_irq_save(flags);
+	if (rdp->gpnum != rsp->gpnum) {
+		note_new_gpnum(rsp, rdp);
+		ret = 1;
+	}
+	local_irq_restore(flags);
+	return ret;
+}
+
+/*
  * Do per-CPU grace-period initialization for running CPU.  The caller
  * must hold the lock of the leaf rcu_node structure corresponding to
  * this CPU.
-- 
1.8.1.5

