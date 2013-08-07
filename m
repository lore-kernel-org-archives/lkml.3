Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab3HGKVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:21:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19416 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab3HGKVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:21:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8143911"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH 8/8] rcu: remove irq work for rsp_wakeup()
Date: Wed, 7 Aug 2013 18:25:04 +0800
Message-Id: <1375871104-10688-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:36,
	Serialize complete at 2013/08/07 18:19:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is safe to aquire scheduler lock in rnp->lock since the rcu read lock is
always deadlock-immunity(rnp->lock is always can't be nested in scheduler lock)

it partial revert patch 016a8d5b.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcutree.c |   17 ++---------------
 kernel/rcutree.h |    1 -
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e08abb9..6c91edc 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1524,14 +1524,6 @@ static int __noreturn rcu_gp_kthread(void *arg)
 	}
 }
 
-static void rsp_wakeup(struct irq_work *work)
-{
-	struct rcu_state *rsp = container_of(work, struct rcu_state, wakeup_work);
-
-	/* Wake up rcu_gp_kthread() to start the grace period. */
-	wake_up(&rsp->gp_wq);
-}
-
 /*
  * Start a new RCU grace period if warranted, re-initializing the hierarchy
  * in preparation for detecting the next grace period.  The caller must hold
@@ -1556,12 +1548,8 @@ rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 	}
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
 
-	/*
-	 * We can't do wakeups while holding the rnp->lock, as that
-	 * could cause possible deadlocks with the rq->lock. Deter
-	 * the wakeup to interrupt context.
-	 */
-	irq_work_queue(&rsp->wakeup_work);
+	/* Wake up rcu_gp_kthread() to start the grace period. */
+	wake_up(&rsp->gp_wq);
 }
 
 /*
@@ -3153,7 +3141,6 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 
 	rsp->rda = rda;
 	init_waitqueue_head(&rsp->gp_wq);
-	init_irq_work(&rsp->wakeup_work, rsp_wakeup);
 	rnp = rsp->level[rcu_num_lvls - 1];
 	for_each_possible_cpu(i) {
 		while (i > rnp->grphi)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index a5e9643..5892a43 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -449,7 +449,6 @@ struct rcu_state {
 	char *name;				/* Name of structure. */
 	char abbr;				/* Abbreviated name. */
 	struct list_head flavors;		/* List of RCU flavors. */
-	struct irq_work wakeup_work;		/* Postponed wakeups */
 };
 
 /* Values for rcu_state structure's gp_flags field. */
-- 
1.7.4.4

