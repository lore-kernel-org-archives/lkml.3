Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab3CSTbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:31:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34778 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933625Ab3CST26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:58 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904508"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 13/21] workqueue: remove unused pwq_lock
Date: Wed, 20 Mar 2013 03:28:13 +0800
Message-Id: <1363721306-2030-14-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:31,
	Serialize complete at 2013/03/20 03:27:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all first_pwq() and for_each_pwq() are converted to be protected by
wq->mutex or RCU_SCHED, so freaky pwq_lock is unused.

simply remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   31 +++++++++++--------------------
 1 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a3460e7..e45f038 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -127,12 +127,9 @@ enum {
  *
  * PR: pools_mutex protected for writes.  Sched-RCU protected for reads.
  *
- * PW: pwq_lock protected.
- *
  * Q: wq->mutex protected.
  *
- * QR: wq->mutex and pwq_lock protected for writes.  Sched-RCU
- *     protected for reads.
+ * QR: wq->mutex protected for writes.  Sched-RCU protected for reads.
  *
  * MD: wq_mayday_lock protected.
  */
@@ -206,7 +203,7 @@ struct pool_workqueue {
 	 * Release of unbound pwq is punted to system_wq.  See put_pwq()
 	 * and pwq_unbound_release_workfn() for details.  pool_workqueue
 	 * itself is also sched-RCU protected so that the first pwq can be
-	 * determined without grabbing pwq_lock.
+	 * determined without grabbing wq->mutex.
 	 */
 	struct work_struct	unbound_release_work;
 	struct rcu_head		rcu;
@@ -260,7 +257,6 @@ static struct kmem_cache *pwq_cache;
 
 static DEFINE_MUTEX(wqs_mutex);		/* protects workqueues */
 static DEFINE_MUTEX(pools_mutex);	/* protects pools */
-static DEFINE_SPINLOCK(pwq_lock);	/* protects pool_workqueues */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
 static LIST_HEAD(workqueues);		/* QS: list of all workqueues */
@@ -301,11 +297,10 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 			   lockdep_is_held(&pools_mutex),		\
 			   "sched RCU or pools_mutex should be held")
 
-#define assert_rcu_or_pwq_lock(wq)					\
+#define assert_rcu_or_wq_mutex(wq)					\
 	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
-			   lockdep_is_held(&wq->mutex) ||		\
-			   lockdep_is_held(&pwq_lock),			\
-			   "sched RCU or pwq_lock should be held")
+			   lockdep_is_held(&wq->mutex),			\
+			   "sched RCU or wq->mutex should be held")
 
 #ifdef CONFIG_LOCKDEP
 #define assert_manager_or_pool_lock(pool)				\
@@ -359,7 +354,7 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  * @pwq: iteration cursor
  * @wq: the target workqueue
  *
- * This must be called either with pwq_lock held or sched RCU read locked.
+ * This must be called either with wq->mutex held or sched RCU read locked.
  * If the pwq needs to be used beyond the locking in effect, the caller is
  * responsible for guaranteeing that the pwq stays online.
  *
@@ -368,7 +363,7 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  */
 #define for_each_pwq(pwq, wq)						\
 	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
-		if (({ assert_rcu_or_pwq_lock(wq); false; })) { }		\
+		if (({ assert_rcu_or_wq_mutex(wq); false; })) { }	\
 		else
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
@@ -507,13 +502,13 @@ static int worker_pool_assign_id(struct worker_pool *pool)
  * first_pwq - return the first pool_workqueue of the specified workqueue
  * @wq: the target workqueue
  *
- * This must be called either with pwq_lock held or sched RCU read locked.
+ * This must be called either with wq->mutex held or sched RCU read locked.
  * If the pwq needs to be used beyond the locking in effect, the caller is
  * responsible for guaranteeing that the pwq stays online.
  */
 static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
 {
-	assert_rcu_or_pwq_lock(wq);
+	assert_rcu_or_wq_mutex(wq);
 	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
 				      pwqs_node);
 }
@@ -3551,9 +3546,7 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	 * and consistent with the linking path.
 	 */
 	mutex_lock(&wq->mutex);
-	spin_lock_irq(&pwq_lock);
 	list_del_rcu(&pwq->pwqs_node);
-	spin_unlock_irq(&pwq_lock);
 	mutex_unlock(&wq->mutex);
 
 	put_unbound_pool(pool);
@@ -3639,9 +3632,7 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	pwq_adjust_max_active(pwq);
 
 	/* link in @pwq */
-	spin_lock_irq(&pwq_lock);
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
-	spin_unlock_irq(&pwq_lock);
 
 	mutex_unlock(&wq->mutex);
 }
@@ -4290,7 +4281,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  * pool->worklist.
  *
  * CONTEXT:
- * Grabs and releases wqs_mutex, pwq_lock and pool->lock's.
+ * Grabs and releases wqs_mutex, wq->mutex and pool->lock's.
  */
 void freeze_workqueues_begin(void)
 {
@@ -4377,7 +4368,7 @@ out_unlock:
  * frozen works are transferred to their respective pool worklists.
  *
  * CONTEXT:
- * Grabs and releases wqs_mutex, pwq_lock and pool->lock's.
+ * Grabs and releases wqs_mutex, wq->mutex and pool->lock's.
  */
 void thaw_workqueues(void)
 {
-- 
1.7.7.6

