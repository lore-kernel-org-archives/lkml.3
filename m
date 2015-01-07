Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbbAGRc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:32:57 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49077 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbbAGRcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:32:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/14] rcu: Make use of rcu_preempt_has_tasks()
Date: Wed,  7 Jan 2015 09:32:26 -0800
Message-Id: <1420651953-2651-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0021-0000-0000-00000793981E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Given that there is now arcu_preempt_has_tasks() function that checks
to see if the ->blkd_tasks list is non-empty, this commit makes use of it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index d594da48f4b4..bcc6d9134d47 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -540,7 +540,7 @@ static int rcu_print_task_stall(struct rcu_node *rnp)
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
 	WARN_ON_ONCE(rcu_preempt_blocked_readers_cgp(rnp));
-	if (!list_empty(&rnp->blkd_tasks))
+	if (rcu_preempt_has_tasks(rnp))
 		rnp->gp_tasks = rnp->blkd_tasks.next;
 	WARN_ON_ONCE(rnp->qsmask);
 }
@@ -706,7 +706,7 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	smp_mb__after_unlock_lock();
-	if (list_empty(&rnp->blkd_tasks)) {
+	if (!rcu_preempt_has_tasks(rnp)) {
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else {
 		rnp->exp_tasks = rnp->blkd_tasks.next;
@@ -985,7 +985,7 @@ void exit_rcu(void)
 
 static void rcu_initiate_boost_trace(struct rcu_node *rnp)
 {
-	if (list_empty(&rnp->blkd_tasks))
+	if (!rcu_preempt_has_tasks(rnp))
 		rnp->n_balk_blkd_tasks++;
 	else if (rnp->exp_tasks == NULL && rnp->gp_tasks == NULL)
 		rnp->n_balk_exp_gp_tasks++;
-- 
1.8.1.5

