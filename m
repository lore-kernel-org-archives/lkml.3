Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab3BGBxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:53:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55938 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3BGBw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:52:56 -0500
Date: Wed, 6 Feb 2013 17:52:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.9] workqueue: simplify is-work-item-queued-here test
Message-ID: <20130207015248.GI2875@htj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Currently, determining whether a work item is queued on a locked pool
involves somewhat convoluted memory barrier dancing.  It goes like the
following.

* When a work item is queued on a pool, work->data is updated before
  work->entry is linked to the pending list with a wmb() inbetween.

* When trying to determine whether a work item is currently queued on
  a pool pointed to by work->data, it locks the pool and looks at
  work->entry.  If work->entry is linked, we then do rmb() and then
  check whether work->data points to the current pool.

This works because, work->data can only point to a pool if it
currently is or were on the pool and,

* If it currently is on the pool, the tests would obviously succeed.

* It it left the pool, its work->entry was cleared under pool->lock,
  so if we're seeing non-empty work->entry, it has to be from the work
  item being linked on another pool.  Because work->data is updated
  before work->entry is linked with wmb() inbetween, work->data update
  from another pool is guaranteed to be visible if we do rmb() after
  seeing non-empty work->entry.  So, we either see empty work->entry
  or we see updated work->data pointin to another pool.

While this works, it's convoluted, to put it mildly.  With recent
updates, it's now guaranteed that work->data points to cwq only while
the work item is queued and that updating work->data to point to cwq
or back to pool is done under pool->lock, so we can simply test
whether work->data points to cwq which is associated with the
currently locked pool instead of the convoluted memory barrier
dancing.

This patch replaces the memory barrier based "are you still here,
really?" test with much simpler "does work->data points to me?" test -
if work->data points to a cwq which is associated with the currently
locked pool, the work item is guaranteed to be queued on the pool as
work->data can start and stop pointing to such cwq only under
pool->lock and the start and stop coincide with queue and dequeue.

tj: Rewrote the comments and description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1068,6 +1068,7 @@ static int try_to_grab_pending(struct wo
 			       unsigned long *flags)
 {
 	struct worker_pool *pool;
+	struct cpu_workqueue_struct *cwq;
 
 	local_irq_save(*flags);
 
@@ -1097,14 +1098,17 @@ static int try_to_grab_pending(struct wo
 		goto fail;
 
 	spin_lock(&pool->lock);
-	if (!list_empty(&work->entry)) {
-		/*
-		 * This work is queued, but perhaps we locked the wrong
-		 * pool.  In that case we must see the new value after
-		 * rmb(), see insert_work()->wmb().
-		 */
-		smp_rmb();
-		if (pool == get_work_pool(work)) {
+	/*
+	 * work->data is guaranteed to point to cwq only while the work
+	 * item is queued on cwq->wq, and both updating work->data to point
+	 * to cwq on queueing and to pool on dequeueing are done under
+	 * cwq->pool->lock.  This in turn guarantees that, if work->data
+	 * points to cwq which is associated with a locked pool, the work
+	 * item is currently queued on that pool.
+	 */
+	cwq = get_work_cwq(work);
+	if (cwq) {
+		if (cwq->pool == pool) {
 			debug_work_deactivate(work);
 
 			/*
@@ -1159,13 +1163,6 @@ static void insert_work(struct cpu_workq
 
 	/* we own @work, set data and link */
 	set_work_cwq(work, cwq, extra_flags);
-
-	/*
-	 * Ensure that we get the right work->data if we see the
-	 * result of list_add() below, see try_to_grab_pending().
-	 */
-	smp_wmb();
-
 	list_add_tail(&work->entry, head);
 
 	/*
@@ -2799,15 +2796,10 @@ static bool start_flush_work(struct work
 		return false;
 
 	spin_lock_irq(&pool->lock);
-	if (!list_empty(&work->entry)) {
-		/*
-		 * See the comment near try_to_grab_pending()->smp_rmb().
-		 * If it was re-queued to a different pool under us, we
-		 * are not going to wait.
-		 */
-		smp_rmb();
-		cwq = get_work_cwq(work);
-		if (unlikely(!cwq || pool != cwq->pool))
+	/* see the comment in try_to_grab_pending() with the same code */
+	cwq = get_work_cwq(work);
+	if (cwq) {
+		if (unlikely(cwq->pool != pool))
 			goto already_gone;
 	} else {
 		worker = find_worker_executing_work(pool, work);
