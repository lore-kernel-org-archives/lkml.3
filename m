Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaFKUlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:41:18 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:43708 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaFKUjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:39:49 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: [RFC PATCH 1/5] kernel/rcu/tree.c:1272 fix a sparse warning 
Date: Wed, 11 Jun 2014 16:39:39 -0400
Message-Id: <1402519183-12752-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/rcu/tree.c:1272:9: warning: context imbalance in 'rcu_start_future_gp' - different lock contexts for basic block

We can simplify the function by keeping the contexts together and removing
redundant checks.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 65 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f1ba773..9ab84d3 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1234,49 +1234,54 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
 	}
 
 	/*
-	 * There might be no grace period in progress.  If we don't already
+	 * There is be no grace period in progress.  If we don't already
 	 * hold it, acquire the root rcu_node structure's lock in order to
-	 * start one (if needed).
+	 * start one.
 	 */
 	if (rnp != rnp_root) {
 		raw_spin_lock(&rnp_root->lock);
 		smp_mb__after_unlock_lock();
+		/*
+		 * Get a new grace-period number.  If there really is no grace
+		 * period in progress, it will be smaller than the one we obtained
+		 * earlier.  Adjust callbacks as needed.  Note that even no-CBs
+		 */
+		c = rcu_cbs_completed(rdp->rsp, rnp_root);
+
+		/*
+		 * If the needed request for the required grace period is already
+		 * recorded, trace and leave.
+		 */
+		if (rnp_root->need_future_gp[c & 0x1]) {
+			trace_rcu_future_gp(rnp, rdp, c, TPS("Prestartedroot"));
+			raw_spin_unlock(&rnp_root->lock);
+			goto out;
+		}
+
+		/* Record the need for the future grace period. */
+		rnp_root->need_future_gp[c & 0x1]++;
+
+		/*
+		 * Start a new grace period since it is not started
+		 */
+		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedroot"));
+		ret = rcu_start_gp_advanced(rdp->rsp, rnp_root, rdp);
+		raw_spin_unlock(&rnp_root->lock);
+		goto out;
 	}
 
+	/* rnp == rnp_root, we already hold the lock */
+	trace_rcu_future_gp(rnp, rdp, c, TPS("StartedLeaf"));
+	ret = rcu_start_gp_advanced(rdp->rsp, rnp, rdp);
+out:
 	/*
-	 * Get a new grace-period number.  If there really is no grace
-	 * period in progress, it will be smaller than the one we obtained
-	 * earlier.  Adjust callbacks as needed.  Note that even no-CBs
-	 * CPUs have a ->nxtcompleted[] array, so no no-CBs checks needed.
+	 * Adjust callbacks as needed.  Note that even no-CBs CPUs
+	 * have a ->nxtcompleted[] array, so no no-CBs checks needed.
 	 */
-	c = rcu_cbs_completed(rdp->rsp, rnp_root);
 	for (i = RCU_DONE_TAIL; i < RCU_NEXT_TAIL; i++)
 		if (ULONG_CMP_LT(c, rdp->nxtcompleted[i]))
 			rdp->nxtcompleted[i] = c;
 
-	/*
-	 * If the needed for the required grace period is already
-	 * recorded, trace and leave.
-	 */
-	if (rnp_root->need_future_gp[c & 0x1]) {
-		trace_rcu_future_gp(rnp, rdp, c, TPS("Prestartedroot"));
-		goto unlock_out;
-	}
-
-	/* Record the need for the future grace period. */
-	rnp_root->need_future_gp[c & 0x1]++;
-
-	/* If a grace period is not already in progress, start one. */
-	if (rnp_root->gpnum != rnp_root->completed) {
-		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleafroot"));
-	} else {
-		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedroot"));
-		ret = rcu_start_gp_advanced(rdp->rsp, rnp_root, rdp);
-	}
-unlock_out:
-	if (rnp != rnp_root)
-		raw_spin_unlock(&rnp_root->lock);
-out:
 	if (c_out != NULL)
 		*c_out = c;
 	return ret;
-- 
1.9.1

