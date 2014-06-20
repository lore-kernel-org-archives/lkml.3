Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966948AbaFTSd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:33:57 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41685 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbaFTSdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:33:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Christoph Lameter <cl@gentwo.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH RFC tip/core/rcu 5/5] rcu: Add boot/sysfs control for RCU cond_resched() help solicitation
Date: Fri, 20 Jun 2014 11:33:23 -0700
Message-Id: <1403289203-6371-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140620183249.GA6325@linux.vnet.ibm.com>
 <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062018-8236-0000-0000-0000034087D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit replaces the hard-coded seven-jiffy cond_resched()
quiescent-state solicitation delay with a delay that can be set via
the rcutree.jiffies_till_cond_resched_qs boot parameter, or of course
via sysfs.  This change was inspired in part by Dave Hansen's time-based
approach: https://lkml.org/lkml/2014/6/17/746.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 Documentation/kernel-parameters.txt |  7 +++++++
 kernel/rcu/tree.c                   | 24 ++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6eaa9cdb7094..1b553596e933 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2785,6 +2785,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			leaf rcu_node structure.  Useful for very large
 			systems.
 
+	rcutree.jiffies_till_cond_resched_qs= [KNL]
+			Set required age in jiffies for a given
+			grace period before RCU starts soliciting
+			quiescent-state help from cond_resched_rcu_qs(),
+			and, if CONFIG_RCU_COND_RESCHED_QS=y, also from
+			cond_resched() itself.
+
 	rcutree.jiffies_till_first_fqs= [KNL]
 			Set delay from grace-period initialization to
 			first attempt to force quiescent states.
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8d1f45b41433..d88f6a10d971 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -295,6 +295,14 @@ static ulong jiffies_till_next_fqs = ULONG_MAX;
 module_param(jiffies_till_first_fqs, ulong, 0644);
 module_param(jiffies_till_next_fqs, ulong, 0644);
 
+/*
+ * How long the grace period must be before we start recruiting
+ * quiescent-state help from cond_resched_rcu_qs() and, if
+ * CONFIG_RCU_COND_RESCHED_QS=y, also from cond_resched() itself.
+ */
+static ulong jiffies_till_cond_resched_qs = 10;
+module_param(jiffies_till_cond_resched_qs, ulong, 0644);
+
 static bool rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 				  struct rcu_data *rdp);
 static void force_qs_rnp(struct rcu_state *rsp,
@@ -951,9 +959,21 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	 * even context-switching back and forth between a pair of
 	 * in-kernel CPU-bound tasks cannot advance grace periods.
 	 * So if the grace period is old enough, make the CPU pay attention.
+	 * Note that the unsynchronized assignments to the per-CPU
+	 * rcu_cond_resched_mask variable are safe.  Yes, setting of
+	 * bits can be lost, but they will be set again on the next
+	 * force-quiescent-state pass.  So lost bit sets do not result
+	 * in incorrect behavior, merely in a grace period lasting
+	 * a few jiffies longer than it might otherwise.  Because
+	 * there are at most four threads involved, and because the
+	 * updates are only once every few jiffies, the probability of
+	 * lossage (and thus of slight grace-period extension) is
+	 * quite low.
 	 */
-	if (ULONG_CMP_GE(jiffies, rdp->rsp->gp_start + 7)) {
-		rcrmp = &per_cpu(rcu_cond_resched_mask, rdp->cpu);
+	rcrmp = &per_cpu(rcu_cond_resched_mask, rdp->cpu);
+	if (ULONG_CMP_GE(jiffies,
+			 rdp->rsp->gp_start + jiffies_till_cond_resched_qs) &&
+	    !(ACCESS_ONCE(*rcrmp) & rdp->rsp->flavor_mask)) {
 		ACCESS_ONCE(rdp->cond_resched_completed) =
 			ACCESS_ONCE(rdp->mynode->completed);
 		smp_mb(); /* ->cond_resched_completed before *rcrmp. */
-- 
1.8.1.5

