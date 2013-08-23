Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3HWGwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 02:52:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4959 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab3HWGwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:52:15 -0400
X-IronPort-AV: E=Sophos;i="4.89,939,1367942400"; 
   d="scan'208";a="8280248"
Message-ID: <5217009F.5030309@cn.fujitsu.com>
Date: Fri, 23 Aug 2013 14:26:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Lai Jiangshan <eag0628@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>	<1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com>	<20130808204020.GA31127@linux.vnet.ibm.com>	<5205B6FF.7060502@cn.fujitsu.com>	<20130812135309.GF27162@twins.programming.kicks-ass.net>	<20130812101008.27048d83@gandalf.local.home>	<CACvQF51-oAGkdxwku+orKSQ=SZd1A4saXzkrgcRGi+KnZUZYxQ@mail.gmail.com> <20130822103431.7abc09ab@gandalf.local.home>
In-Reply-To: <20130822103431.7abc09ab@gandalf.local.home>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/23 14:20:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/23 14:20:25,
	Serialize complete at 2013/08/23 14:20:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] rcu/rt_mutex: eliminate a kind of deadlock for rcu read site

Current rtmutex's lock->wait_lock doesn't disables softirq nor irq, it will
cause rcu read site deadlock when rcu overlaps with any softirq-context/irq-context lock.

@L is a spinlock of softirq or irq context.

CPU1					cpu2(rcu boost)
rcu_read_lock()				rt_mutext_lock()
<preemption and reschedule back>	  raw_spin_lock(lock->wait_lock)
spin_lock_XX(L)				  <interrupt and doing softirq or irq>
rcu_read_unlock()                         do_softirq()
  rcu_read_unlock_special()
    rt_mutext_unlock()
      raw_spin_lock(lock->wait_lock)	    spin_lock_XX(L)  **DEADLOCK**

This patch fixes this kind of deadlock by removing rt_mutext_unlock() from
rcu_read_unlock(), new rt_mutex_rcu_deboost_unlock() is called instead.
Thus rtmutex's lock->wait_lock will not be called from rcu_read_unlock().

This patch does not eliminate all kinds of rcu-read-site deadlock,
if @L is a scheduler lock, it will be deadlock, we should apply Paul's rule
in this case.(avoid overlapping or preempt_disable()).

rt_mutex_rcu_deboost_unlock() requires the @waiter is queued, so we
can't directly call rt_mutex_lock(&mtx) in the rcu_boost thread,
we split rt_mutex_lock(&mtx) into two steps just like pi-futex.
This result a internal state in rcu_boost thread and cause
rcu_boost thread a bit more complicated.

Thanks
Lai

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 5cd0f09..8830874 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -102,7 +102,7 @@ extern struct group_info init_groups;
 
 #ifdef CONFIG_RCU_BOOST
 #define INIT_TASK_RCU_BOOST()						\
-	.rcu_boost_mutex = NULL,
+	.rcu_boost_waiter = NULL,
 #else
 #define INIT_TASK_RCU_BOOST()
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e9995eb..1eca99f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1078,7 +1078,7 @@ struct task_struct {
 	struct rcu_node *rcu_blocked_node;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 #ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rcu_boost_mutex;
+	struct rt_mutex_waiter *rcu_boost_waiter;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
@@ -1723,7 +1723,7 @@ static inline void rcu_copy_process(struct task_struct *p)
 	p->rcu_blocked_node = NULL;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 #ifdef CONFIG_RCU_BOOST
-	p->rcu_boost_mutex = NULL;
+	p->rcu_boost_waiter = NULL;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 769e12e..d207ddd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -33,6 +33,7 @@
 #define RCU_KTHREAD_PRIO 1
 
 #ifdef CONFIG_RCU_BOOST
+#include "rtmutex_common.h"
 #define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
 #else
 #define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
@@ -340,7 +341,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 	unsigned long flags;
 	struct list_head *np;
 #ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rbmp = NULL;
+	struct rt_mutex_waiter *waiter = NULL;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	struct rcu_node *rnp;
 	int special;
@@ -397,10 +398,10 @@ void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		if (&t->rcu_node_entry == rnp->boost_tasks)
 			rnp->boost_tasks = np;
-		/* Snapshot/clear ->rcu_boost_mutex with rcu_node lock held. */
-		if (t->rcu_boost_mutex) {
-			rbmp = t->rcu_boost_mutex;
-			t->rcu_boost_mutex = NULL;
+		/* Snapshot/clear ->rcu_boost_waiter with rcu_node lock held. */
+		if (t->rcu_boost_waiter) {
+			waiter = t->rcu_boost_waiter;
+			t->rcu_boost_waiter = NULL;
 		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
@@ -426,8 +427,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (rbmp)
-			rt_mutex_unlock(rbmp);
+		if (waiter)
+			rt_mutex_rcu_deboost_unlock(t, waiter);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -1129,9 +1130,6 @@ void exit_rcu(void)
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 #ifdef CONFIG_RCU_BOOST
-
-#include "rtmutex_common.h"
-
 #ifdef CONFIG_RCU_TRACE
 
 static void rcu_initiate_boost_trace(struct rcu_node *rnp)
@@ -1181,14 +1179,15 @@ static int rcu_boost(struct rcu_node *rnp)
 {
 	unsigned long flags;
 	struct rt_mutex mtx;
+	struct rt_mutex_waiter rcu_boost_waiter;
 	struct task_struct *t;
 	struct list_head *tb;
+	int ret;
 
 	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL)
 		return 0;  /* Nothing left to boost. */
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-
 	/*
 	 * Recheck under the lock: all tasks in need of boosting
 	 * might exit their RCU read-side critical sections on their own.
@@ -1215,7 +1214,7 @@ static int rcu_boost(struct rcu_node *rnp)
 
 	/*
 	 * We boost task t by manufacturing an rt_mutex that appears to
-	 * be held by task t.  We leave a pointer to that rt_mutex where
+	 * be held by task t.  We leave a pointer to that rt_mutex_waiter where
 	 * task t can find it, and task t will release the mutex when it
 	 * exits its outermost RCU read-side critical section.  Then
 	 * simply acquiring this artificial rt_mutex will boost task
@@ -1230,11 +1229,30 @@ static int rcu_boost(struct rcu_node *rnp)
 	 * section.
 	 */
 	t = container_of(tb, struct task_struct, rcu_node_entry);
+	get_task_struct(t);
 	rt_mutex_init_proxy_locked(&mtx, t);
-	t->rcu_boost_mutex = &mtx;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
-	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
+
+	debug_rt_mutex_init_waiter(&rcu_boost_waiter);
+	/* Side effect: boosts task t's priority. */
+	ret = rt_mutex_start_proxy_lock(&mtx, &rcu_boost_waiter, current, 0);
+	if (WARN_ON_ONCE(ret)) {
+		put_task_struct(t);
+		return 0; /* temporary stop boosting */
+	}
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	if (&t->rcu_node_entry == rnp->exp_tasks ||
+	    &t->rcu_node_entry == rnp->boost_tasks) {
+		t->rcu_boost_waiter = &rcu_boost_waiter;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	} else {
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		rt_mutex_rcu_deboost_unlock(t, &rcu_boost_waiter);
+	}
+
+	put_task_struct(t);
+	rt_mutex_finish_proxy_lock(&mtx, NULL, &rcu_boost_waiter, 0);
 
 	return ACCESS_ONCE(rnp->exp_tasks) != NULL ||
 	       ACCESS_ONCE(rnp->boost_tasks) != NULL;
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 0dd6aec..2f3caee 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -734,6 +734,43 @@ rt_mutex_slowunlock(struct rt_mutex *lock)
 	rt_mutex_adjust_prio(current);
 }
 
+#ifdef CONFIG_RCU_BOOST
+/*
+ * rt_mutex_rcu_deboost_unlock() - unlock in irq/bh/process context
+ *
+ * please revert the patch which introduces this function when
+ * rt_mutex's ->wait_lock is irq-off.
+ */
+void rt_mutex_rcu_deboost_unlock(struct task_struct *owner,
+				 struct rt_mutex_waiter *waiter)
+{
+	unsigned long flags;
+	struct rt_mutex *lock = waiter->lock;
+
+	/*
+	 * The correction of the following code is based on
+	 * 1) current lock is owned by @owner
+	 * 2) only one task(@waiter->task) is waiting on the @lock
+	 * 3) the @waiter has been queued and keeps been queued
+	 */
+	if (WARN_ON_ONCE(rt_mutex_owner(lock) != owner))
+		return; /* 1) */
+	if (WARN_ON_ONCE(rt_mutex_top_waiter(lock) != waiter))
+		return; /* 2) & 3) */
+	if (WARN_ON_ONCE(plist_node_empty(&waiter->pi_list_entry)))
+		return; /* 2) & 3) */
+
+	raw_spin_lock_irqsave(&owner->pi_lock, flags);
+	plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
+	lock->owner = NULL;
+	raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
+
+	wake_up_process(waiter->task);
+	/* Undo pi boosting if necessary: */
+	rt_mutex_adjust_prio(owner);
+}
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 /*
  * debug aware fast / slowpath lock,trylock,unlock
  *
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index 53a66c8..3cdbe82 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -117,6 +117,11 @@ extern int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 				      struct rt_mutex_waiter *waiter,
 				      int detect_deadlock);
 
+#ifdef CONFIG_RCU_BOOST
+void rt_mutex_rcu_deboost_unlock(struct task_struct *owner,
+				 struct rt_mutex_waiter *waiter);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 # include "rtmutex-debug.h"
 #else
