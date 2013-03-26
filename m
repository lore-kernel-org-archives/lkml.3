Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954Ab3CZAI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:08:28 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49556 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933884Ab3CZAHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:07:52 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, js1304@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] workqueue: remove pwq_lock which is no longer used
Date: Mon, 25 Mar 2013 17:07:29 -0700
Message-Id: <1364256449-11401-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364256449-11401-1-git-send-email-tj@kernel.org>
References: <1364256449-11401-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

To simplify locking, the previous patches expanded wq->mutex to
protect all fields of each workqueue instance including the pwqs list
leaving pwq_lock without any user.  Remove the unused pwq_lock.

tj: Rebased on top of the current dev branch.  Updated description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index af6087a..04a8b98 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -125,12 +125,9 @@ enum {
  *
  * PR: wq_pool_mutex protected for writes.  Sched-RCU protected for reads.
  *
- * PW: pwq_lock protected.
- *
  * WQ: wq->mutex protected.
  *
- * WR: wq->mutex and pwq_lock protected for writes.  Sched-RCU protected
- *     for reads.
+ * WR: wq->mutex protected for writes.  Sched-RCU protected for reads.
  *
  * MD: wq_mayday_lock protected.
  */
@@ -257,7 +254,6 @@ struct workqueue_struct {
 static struct kmem_cache *pwq_cache;
 
 static DEFINE_MUTEX(wq_pool_mutex);	/* protects pools and workqueues list */
-static DEFINE_SPINLOCK(pwq_lock);	/* protects pool_workqueues */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
 static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
@@ -300,8 +296,7 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 
 #define assert_rcu_or_wq_mutex(wq)					\
 	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
-			   lockdep_is_held(&wq->mutex) ||		\
-			   lockdep_is_held(&pwq_lock),			\
+			   lockdep_is_held(&wq->mutex),			\
 			   "sched RCU or wq->mutex should be held")
 
 #ifdef CONFIG_LOCKDEP
@@ -3549,9 +3544,7 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	 * and consistent with the linking path.
 	 */
 	mutex_lock(&wq->mutex);
-	spin_lock_irq(&pwq_lock);
 	list_del_rcu(&pwq->pwqs_node);
-	spin_unlock_irq(&pwq_lock);
 	mutex_unlock(&wq->mutex);
 
 	put_unbound_pool(pool);
@@ -3635,9 +3628,7 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	pwq_adjust_max_active(pwq);
 
 	/* link in @pwq */
-	spin_lock_irq(&pwq_lock);
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
-	spin_unlock_irq(&pwq_lock);
 
 	mutex_unlock(&wq->mutex);
 }
-- 
1.8.1.4

