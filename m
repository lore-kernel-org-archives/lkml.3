Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab3HGKWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:22:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19416 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab3HGKVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:21:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8143908"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
Date: Wed, 7 Aug 2013 18:25:01 +0800
Message-Id: <1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com>
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

Background)

Although all articles declare that rcu read site is deadlock-immunity.
It is not true for rcu-preempt, it will be deadlock if rcu read site
overlaps with scheduler lock.

ec433f0c, 10f39bb1 and 016a8d5b just partially solve it. But rcu read site
is still not deadlock-immunity. And the problem described in 016a8d5b
is still existed(rcu_read_unlock_special() calls wake_up).

Aim)

We want to fix the problem forever, we want to keep rcu read site
is deadlock-immunity as books say.

How)

The problem is solved by "if rcu_read_unlock_special() is called inside
any lock which can be (chained) nested in rcu_read_unlock_special(),
we defer rcu_read_unlock_special()".
This kind locks include rnp->lock, scheduler locks, perf ctx->lock, locks
in printk()/WARN_ON() and all locks nested in these locks or chained nested
in these locks.

The problem is reduced to "how to distinguish all these locks(context)",
We don't distinguish all these locks, we know that all these locks
should be nested in local_irqs_disable().

we just consider if rcu_read_unlock_special() is called in irqs-disabled
context, it may be called in these suspect locks, we should defer
rcu_read_unlock_special().

The algorithm enlarges the probability of deferring, but the probability
is still very very low.

Deferring does add a small overhead, but it offers us:
	1) really deadlock-immunity for rcu read site
	2) remove the overhead of the irq-work(250 times per second in avg.)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/rcupdate.h |    2 +-
 kernel/rcupdate.c        |    2 +-
 kernel/rcutree_plugin.h  |   47 +++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 4b14bdc..00b4220 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -180,7 +180,7 @@ extern void synchronize_sched(void);
 
 extern void __rcu_read_lock(void);
 extern void __rcu_read_unlock(void);
-extern void rcu_read_unlock_special(struct task_struct *t);
+extern void rcu_read_unlock_special(struct task_struct *t, bool unlock);
 void synchronize_rcu(void);
 
 /*
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index cce6ba8..33b89a3 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -90,7 +90,7 @@ void __rcu_read_unlock(void)
 #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-			rcu_read_unlock_special(t);
+			rcu_read_unlock_special(t, true);
 		barrier();  /* ->rcu_read_unlock_special load before assign */
 		t->rcu_read_lock_nesting = 0;
 	}
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index fc8b36f..997b424 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -242,15 +242,16 @@ static void rcu_preempt_note_context_switch(int cpu)
 				       ? rnp->gpnum
 				       : rnp->gpnum + 1);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	} else if (t->rcu_read_lock_nesting < 0 &&
-		   !WARN_ON_ONCE(t->rcu_read_lock_nesting != INT_MIN) &&
-		   t->rcu_read_unlock_special) {
+	} else if (t->rcu_read_lock_nesting == 0 ||
+		   (t->rcu_read_lock_nesting < 0 &&
+		   !WARN_ON_ONCE(t->rcu_read_lock_nesting != INT_MIN))) {
 
 		/*
 		 * Complete exit from RCU read-side critical section on
 		 * behalf of preempted instance of __rcu_read_unlock().
 		 */
-		rcu_read_unlock_special(t);
+		if (t->rcu_read_unlock_special)
+			rcu_read_unlock_special(t, false);
 	}
 
 	/*
@@ -333,7 +334,7 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-void rcu_read_unlock_special(struct task_struct *t)
+void rcu_read_unlock_special(struct task_struct *t, bool unlock)
 {
 	int empty;
 	int empty_exp;
@@ -364,6 +365,42 @@ void rcu_read_unlock_special(struct task_struct *t)
 
 	/* Clean up if blocked during RCU read-side critical section. */
 	if (special & RCU_READ_UNLOCK_BLOCKED) {
+		/*
+		 * If rcu read lock overlaps with scheduler lock,
+		 * rcu_read_unlock_special() may lead to deadlock:
+		 *
+		 * rcu_read_lock();
+		 * preempt_schedule[_irq]() (when preemption)
+		 * scheduler lock; (or some other locks can be (chained) nested
+		 *                  in rcu_read_unlock_special()/rnp->lock)
+		 * access and check rcu data
+		 * rcu_read_unlock();
+		 *   rcu_read_unlock_special();
+		 *     wake_up();                 DEAD LOCK
+		 *
+		 * To avoid all these kinds of deadlock, we should quit
+		 * rcu_read_unlock_special() here and defer it to
+		 * rcu_preempt_note_context_switch() or next outmost
+		 * rcu_read_unlock() if we consider this case may happen.
+		 *
+		 * Although we can't know whether current _special()
+		 * is nested in scheduler lock or not. But we know that
+		 * irqs are always disabled in this case. so we just quit
+		 * and defer it to rcu_preempt_note_context_switch()
+		 * when irqs are disabled.
+		 *
+		 * It means we always defer _special() when it is
+		 * nested in irqs disabled context, but
+		 *	(special & RCU_READ_UNLOCK_BLOCKED) &&
+		 *	irqs_disabled_flags(flags)
+		 * is still unlikely to be true.
+		 */
+		if (unlikely(unlock && irqs_disabled_flags(flags))) {
+			set_need_resched();
+			local_irq_restore(flags);
+			return;
+		}
+
 		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
 
 		/*
-- 
1.7.4.4

