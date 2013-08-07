Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab3HGKVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:21:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab3HGKVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:21:02 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8143906"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH 3/8] rcu: keep irqs disabled in rcu_read_unlock_special()
Date: Wed, 7 Aug 2013 18:24:59 +0800
Message-Id: <1375871104-10688-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:36,
	Serialize complete at 2013/08/07 18:19:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_read_unlock_special() may enable irqs temporarily before it finish its
last work. It doesn't introduce any extremely bad things. but it does
add more task rcu machine states and add more complexity, bad to review.

And if the task is preempted when it enables irqs,
the synchronize_rcu_expedited() will be slowed down, and it can't get help
from rcu_boost.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcutree_plugin.h |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 54f7e45..6b23b6f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -338,7 +338,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 	int empty;
 	int empty_exp;
 	int empty_exp_now;
-	unsigned long flags;
+	unsigned long flags, irq_disabled_flags;
 	struct list_head *np;
 #ifdef CONFIG_RCU_BOOST
 	struct rt_mutex *rbmp = NULL;
@@ -351,6 +351,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 		return;
 
 	local_irq_save(flags);
+	local_save_flags(irq_disabled_flags);
 
 	/*
 	 * If RCU core is waiting for this CPU to exit critical section,
@@ -414,9 +415,12 @@ void rcu_read_unlock_special(struct task_struct *t)
 							 rnp->grplo,
 							 rnp->grphi,
 							 !!rnp->gp_tasks);
-			rcu_report_unblock_qs_rnp(rnp, flags);
+			rcu_report_unblock_qs_rnp(rnp, irq_disabled_flags);
+			/* irqs remain disabled. */
 		} else {
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock,
+						   irq_disabled_flags);
+			/* irqs remain disabled. */
 		}
 
 #ifdef CONFIG_RCU_BOOST
@@ -431,9 +435,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		if (!empty_exp && empty_exp_now)
 			rcu_report_exp_rnp(&rcu_preempt_state, rnp, true);
-	} else {
-		local_irq_restore(flags);
 	}
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_RCU_CPU_STALL_VERBOSE
-- 
1.7.4.4

