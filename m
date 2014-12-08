Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaLHRnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:43:32 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:49514 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbaLHRna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:43:30 -0500
Date: Mon, 8 Dec 2014 12:43:26 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.19 1/3] workqueue: make the workqueues list RCU
 walkable
Message-ID: <20141208174326.GB12274@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The workqueues list is protected by wq_pool_mutex and a workqueue and
its subordinate data structures are freed directly on destruction.  We
want to add the ability dump workqueues from a sysrq callback which
requires walking all workqueues without grabbing wq_pool_mutex.  This
patch makes freeing of workqueues RCU protected and makes the
workqueues list walkable while holding RCU read lock.

Note that pool_workqueues and pools are already sched-RCU protected.
For consistency, workqueues are also protected with sched-RCU.

While at it, reverse the workqueues list so that a workqueue which is
created earlier comes before.  The order of the list isn't significant
functionally but this makes the planned sysrq dump list system
workqueues first.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -230,7 +230,7 @@ struct wq_device;
  */
 struct workqueue_struct {
 	struct list_head	pwqs;		/* WR: all pwqs of this wq */
-	struct list_head	list;		/* PL: list of all workqueues */
+	struct list_head	list;		/* PR: list of all workqueues */
 
 	struct mutex		mutex;		/* protects this wq */
 	int			work_color;	/* WQ: current work color */
@@ -257,6 +257,13 @@ struct workqueue_struct {
 #endif
 	char			name[WQ_NAME_LEN]; /* I: workqueue name */
 
+	/*
+	 * Destruction of workqueue_struct is sched-RCU protected to allow
+	 * walking the workqueues list without grabbing wq_pool_mutex.
+	 * This is used to dump all workqueues from sysrq.
+	 */
+	struct rcu_head		rcu;
+
 	/* hot fields used during command issue, aligned to cacheline */
 	unsigned int		flags ____cacheline_aligned; /* WQ: WQ_* flags */
 	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwqs */
@@ -288,7 +295,7 @@ static struct workqueue_attrs *wq_update
 static DEFINE_MUTEX(wq_pool_mutex);	/* protects pools and workqueues list */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
-static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
+static LIST_HEAD(workqueues);		/* PR: list of all workqueues */
 static bool workqueue_freezing;		/* PL: have wqs started freezing? */
 
 /* the per-cpu worker pools */
@@ -3386,6 +3393,20 @@ static int init_worker_pool(struct worke
 	return 0;
 }
 
+static void rcu_free_wq(struct rcu_head *rcu)
+{
+	struct workqueue_struct *wq =
+		container_of(rcu, struct workqueue_struct, rcu);
+
+	if (!(wq->flags & WQ_UNBOUND))
+		free_percpu(wq->cpu_pwqs);
+	else
+		free_workqueue_attrs(wq->unbound_attrs);
+
+	kfree(wq->rescuer);
+	kfree(wq);
+}
+
 static void rcu_free_pool(struct rcu_head *rcu)
 {
 	struct worker_pool *pool = container_of(rcu, struct worker_pool, rcu);
@@ -3563,12 +3584,10 @@ static void pwq_unbound_release_workfn(s
 
 	/*
 	 * If we're the last pwq going away, @wq is already dead and no one
-	 * is gonna access it anymore.  Free it.
+	 * is gonna access it anymore.  Schedule RCU free.
 	 */
-	if (is_last) {
-		free_workqueue_attrs(wq->unbound_attrs);
-		kfree(wq);
-	}
+	if (is_last)
+		call_rcu_sched(&wq->rcu, rcu_free_wq);
 }
 
 /**
@@ -4105,7 +4124,7 @@ struct workqueue_struct *__alloc_workque
 		pwq_adjust_max_active(pwq);
 	mutex_unlock(&wq->mutex);
 
-	list_add(&wq->list, &workqueues);
+	list_add_tail_rcu(&wq->list, &workqueues);
 
 	mutex_unlock(&wq_pool_mutex);
 
@@ -4161,24 +4180,20 @@ void destroy_workqueue(struct workqueue_
 	 * flushing is complete in case freeze races us.
 	 */
 	mutex_lock(&wq_pool_mutex);
-	list_del_init(&wq->list);
+	list_del_rcu(&wq->list);
 	mutex_unlock(&wq_pool_mutex);
 
 	workqueue_sysfs_unregister(wq);
 
-	if (wq->rescuer) {
+	if (wq->rescuer)
 		kthread_stop(wq->rescuer->task);
-		kfree(wq->rescuer);
-		wq->rescuer = NULL;
-	}
 
 	if (!(wq->flags & WQ_UNBOUND)) {
 		/*
 		 * The base ref is never dropped on per-cpu pwqs.  Directly
-		 * free the pwqs and wq.
+		 * schedule RCU free.
 		 */
-		free_percpu(wq->cpu_pwqs);
-		kfree(wq);
+		call_rcu_sched(&wq->rcu, rcu_free_wq);
 	} else {
 		/*
 		 * We're the sole accessor of @wq at this point.  Directly
