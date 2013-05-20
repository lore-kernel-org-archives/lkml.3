Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab3ETOlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:41:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37261 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3ETOlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:41:18 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/8] rcu: Rename note_new_gpnum() to note_gp_changes()
Date: Mon, 20 May 2013 07:38:10 -0700
Message-Id: <1369060695-29679-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130520143739.GA29365@linux.vnet.ibm.com>
 <1369060695-29679-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-7606-0000-0000-00000B91DEFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because note_new_gpnum() now also checks for the ends of old grace periods,
this commit changes its name to note_gp_changes().  Later commits will merge
rcu_process_gp_end() into note_gp_changes().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 46f3062..2f40b4d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1307,7 +1307,7 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
  * ->lock of the leaf rcu_node structure corresponding to the current CPU,
  *  and must have irqs disabled.
  */
-static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+static void __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	/* Handle the ends of any preceding grace periods first. */
 	__rcu_process_gp_end(rsp, rnp, rdp);
@@ -1326,19 +1326,20 @@ static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct
 	}
 }
 
-static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
+static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_node *rnp;
 
 	local_irq_save(flags);
 	rnp = rdp->mynode;
-	if (rdp->gpnum == ACCESS_ONCE(rnp->gpnum) || /* outside lock. */
+	if ((rdp->gpnum == ACCESS_ONCE(rnp->gpnum) &&
+	     rdp->completed == ACCESS_ONCE(rnp->completed)) || /* w/out lock. */
 	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, so later. */
 		local_irq_restore(flags);
 		return;
 	}
-	__note_new_gpnum(rsp, rnp, rdp);
+	__note_gp_changes(rsp, rnp, rdp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
@@ -1377,7 +1378,7 @@ check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	local_irq_save(flags);
 	if (rdp->gpnum != rsp->gpnum) {
-		note_new_gpnum(rsp, rdp);
+		note_gp_changes(rsp, rdp);
 		ret = 1;
 	}
 	local_irq_restore(flags);
@@ -1396,7 +1397,7 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 	__rcu_process_gp_end(rsp, rnp, rdp);
 
 	/* Set state so that this CPU will detect the next quiescent state. */
-	__note_new_gpnum(rsp, rnp, rdp);
+	__note_gp_changes(rsp, rnp, rdp);
 }
 
 /*
-- 
1.8.1.5

