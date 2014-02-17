Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaBQVgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:36:22 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60779 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaBQVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:07 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/12] rcu: Add ACCESS_ONCE() to ->n_force_qs_lh accesses
Date: Mon, 17 Feb 2014 13:35:48 -0800
Message-Id: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140217213533.GA5387@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-0928-0000-0000-000006C30F2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The ->n_force_qs_lh field is accessed without the benefit of any
synchronization, so this commit adds the needed ACCESS_ONCE() wrappers.
Yes, increments to ->n_force_qs_lh can be lost, but contention should
be low and the field is strictly statistical in nature, so this is not
a problem.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c       | 4 ++--
 kernel/rcu/tree_trace.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index b3d116cd072d..e64157798624 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2304,7 +2304,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 		if (rnp_old != NULL)
 			raw_spin_unlock(&rnp_old->fqslock);
 		if (ret) {
-			rsp->n_force_qs_lh++;
+			ACCESS_ONCE(rsp->n_force_qs_lh)++;
 			return;
 		}
 		rnp_old = rnp;
@@ -2316,7 +2316,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	smp_mb__after_unlock_lock();
 	raw_spin_unlock(&rnp_old->fqslock);
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
-		rsp->n_force_qs_lh++;
+		ACCESS_ONCE(rsp->n_force_qs_lh)++;
 		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 		return;  /* Someone beat us to it. */
 	}
diff --git a/kernel/rcu/tree_trace.c b/kernel/rcu/tree_trace.c
index 4def475336d4..d1f1e64a6d72 100644
--- a/kernel/rcu/tree_trace.c
+++ b/kernel/rcu/tree_trace.c
@@ -273,7 +273,7 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	seq_printf(m, "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld/%ld\n",
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
 		   rsp->n_force_qs - rsp->n_force_qs_ngp,
-		   rsp->n_force_qs_lh, rsp->qlen_lazy, rsp->qlen);
+		   ACCESS_ONCE(rsp->n_force_qs_lh), rsp->qlen_lazy, rsp->qlen);
 	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < rcu_num_nodes; rnp++) {
 		if (rnp->level != level) {
 			seq_puts(m, "\n");
-- 
1.8.1.5

