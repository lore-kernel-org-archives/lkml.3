Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab3CBD1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:27:52 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:59784 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3CBDZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:10 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/31] workqueue: prepare flush_workqueue() for dynamic creation and destrucion of unbound pool_workqueues
Date: Fri,  1 Mar 2013 19:24:15 -0800
Message-Id: <1362194662-2344-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unbound pwqs (pool_workqueues) will be dynamically created and
destroyed with the scheduled unbound workqueue w/ custom attributes
support.  This patch synchronizes pwq linking and unlinking against
flush_workqueue() so that its operation isn't disturbed by pwqs coming
and going.

Linking and unlinking a pwq into wq->pwqs is now protected also by
wq->flush_mutex and a new pwq's work_color is initialized to
wq->work_color during linking.  This ensures that pwqs changes don't
disturb flush_workqueue() in progress and the new pwq's work coloring
stays in sync with the rest of the workqueue.

flush_mutex during unlinking isn't strictly necessary but it's simpler
to do it anyway.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e092cd5..0f0da59 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -122,6 +122,9 @@ enum {
  * W: workqueue_lock protected.
  *
  * R: workqueue_lock protected for writes.  Sched-RCU protected for reads.
+ *
+ * FR: wq->flush_mutex and workqueue_lock protected for writes.  Sched-RCU
+ *     protected for reads.
  */
 
 /* struct worker is defined in workqueue_internal.h */
@@ -185,7 +188,7 @@ struct pool_workqueue {
 	int			nr_active;	/* L: nr of active works */
 	int			max_active;	/* L: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
-	struct list_head	pwqs_node;	/* R: node on wq->pwqs */
+	struct list_head	pwqs_node;	/* FR: node on wq->pwqs */
 	struct list_head	mayday_node;	/* W: node on wq->maydays */
 
 	/*
@@ -214,7 +217,7 @@ struct wq_flusher {
 struct workqueue_struct {
 	unsigned int		flags;		/* W: WQ_* flags */
 	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
-	struct list_head	pwqs;		/* R: all pwqs of this wq */
+	struct list_head	pwqs;		/* FR: all pwqs of this wq */
 	struct list_head	list;		/* W: list of all workqueues */
 
 	struct mutex		flush_mutex;	/* protects wq flushing */
@@ -3395,9 +3398,16 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	if (WARN_ON_ONCE(!(wq->flags & WQ_UNBOUND)))
 		return;
 
+	/*
+	 * Unlink @pwq.  Synchronization against flush_mutex isn't strictly
+	 * necessary on release but do it anyway.  It's easier to verify
+	 * and consistent with the linking path.
+	 */
+	mutex_lock(&wq->flush_mutex);
 	spin_lock_irq(&workqueue_lock);
 	list_del_rcu(&pwq->pwqs_node);
 	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&wq->flush_mutex);
 
 	put_unbound_pool(pool);
 	call_rcu_sched(&pwq->rcu, rcu_free_pwq);
@@ -3425,7 +3435,18 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	INIT_LIST_HEAD(&pwq->mayday_node);
 	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
 
+	/*
+	 * Link @pwq and set the matching work_color.  This is synchronized
+	 * with flush_mutex to avoid confusing flush_workqueue().
+	 */
+	mutex_lock(&wq->flush_mutex);
+	spin_lock_irq(&workqueue_lock);
+
+	pwq->work_color = wq->work_color;
 	list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
+
+	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&wq->flush_mutex);
 }
 
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
-- 
1.8.1.2

