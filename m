Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaFQCzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:55:24 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:63817 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbaFQCzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:55:23 -0400
Message-ID: <539FAE21.7070702@gmail.com>
Date: Mon, 16 Jun 2014 22:55:29 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Josh Triplett <josh@joshtriplett.org>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC PATCH 1/1] kernel/rcu/tree.c: simplify force_quiescent_state()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This might sound really naive, but please bear with me.

force_quiescent_state() used to do a lot of things in the past in addition to
forcing a quiescent state. (In my reading of the mailing list I found state
transitions for one). 

Now according to the code, what is being done is multiple callers try to go up
the hierarchy of nodes to see who reaches the root node. The caller reaching the
root node wins and it acquires root node lock and it gets to set rsp->gp_flags!

At each level of the hierarchy we try to acquire fqslock. This is the only place
which actually uses fqslock. 

I guess this was being done to avoid the contention on fqslock, but all we are
doing here is setting one flag. This way of acquiring locks might reduce
contention if every update is trying to do some independent work, but here all
we are doing is setting the same flag with same value.

We can also remove fqslock completely if we do not need this. Also using
cmpxchg() to set the value of the flag looks like a good idea to avoid taking
the root node lock. Thoughts?

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f1ba773..9a46f32 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2399,36 +2399,27 @@ static void force_qs_rnp(struct rcu_state *rsp,
 static void force_quiescent_state(struct rcu_state *rsp)
 {
 	unsigned long flags;
-	bool ret;
-	struct rcu_node *rnp;
-	struct rcu_node *rnp_old = NULL;
-
-	/* Funnel through hierarchy to reduce memory contention. */
-	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
-	for (; rnp != NULL; rnp = rnp->parent) {
-		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
-		      !raw_spin_trylock(&rnp->fqslock);
-		if (rnp_old != NULL)
-			raw_spin_unlock(&rnp_old->fqslock);
-		if (ret) {
-			ACCESS_ONCE(rsp->n_force_qs_lh)++;
-			return;
-		}
-		rnp_old = rnp;
+	struct rcu_node *rnp_root = rcu_get_root(rsp);
+
+	/* early test to see if someone already forced a quiescent state
+	 */
+	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
+		ACCESS_ONCE(rsp->n_force_qs_lh)++;
+		return;  /* Someone beat us to it. */
 	}
-	/* rnp_old == rcu_get_root(rsp), rnp == NULL. */
 
 	/* Reached the root of the rcu_node tree, acquire lock. */
-	raw_spin_lock_irqsave(&rnp_old->lock, flags);
+	raw_spin_lock_irqsave(&rnp_root->lock, flags);
 	smp_mb__after_unlock_lock();
-	raw_spin_unlock(&rnp_old->fqslock);
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		ACCESS_ONCE(rsp->n_force_qs_lh)++;
-		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
-		return;  /* Someone beat us to it. */
+		raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
+		return;  /* Someone actually beat us to it. */
 	}
+
+	/* can we use cmpxchg instead of the above lock? */
 	ACCESS_ONCE(rsp->gp_flags) |= RCU_GP_FLAG_FQS;
-	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
 	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
 }
 
-- 
1.9.1
