Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3AaSoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:44:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:38873 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756561Ab3AaSl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:41:57 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672836"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 05/13] workqueue: change queued detection and remove *mb()s
Date: Fri, 1 Feb 2013 02:41:28 +0800
Message-Id: <1359657696-2767-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:46,
	Serialize complete at 2013/02/01 02:40:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we has this invariant:
	CWQ bit is set and the cwq->pool == pool
	<==> the work is queued on the pool

So we can simplify the work-queued-detection-and-lock and remove *mb()s.

(Although rmb()/wmb() is nop in x86, but it is very slow in other arch.)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   43 +++++++++++++++++++------------------------
 1 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 50d3dd5..b7cfaa1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1067,6 +1067,7 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 			       unsigned long *flags)
 {
 	struct worker_pool *pool;
+	struct cpu_workqueue_struct *cwq;
 
 	local_irq_save(*flags);
 
@@ -1096,14 +1097,20 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
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
+	 * The CWQ bit is set/cleared only when we do enqueue/dequeue the work
+	 * When a work is enqueued(insert_work()) to a pool:
+	 *	we set cwq(CWQ bit) with pool->lock held
+	 * when a work is dequeued(process_one_work(),try_to_grab_pending()):
+	 *	we clear cwq(CWQ bit) with pool->lock held
+	 *
+	 * So when if the pool->lock is held, we can determine:
+	 * 	CWQ bit is set and the cwq->pool == pool
+	 * 	<==> the work is queued on the pool
+	 */
+	cwq = get_work_cwq(work);
+	if (cwq) {
+		if (pool == cwq->pool) {
 			debug_work_deactivate(work);
 
 			/*
@@ -1156,13 +1163,6 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 
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
@@ -2796,15 +2796,10 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
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
+	/* See the comment near try_to_grab_pending() with the same code */
+	cwq = get_work_cwq(work);
+	if (cwq) {
+		if (unlikely(pool != cwq->pool))
 			goto already_gone;
 	} else {
 		worker = find_worker_executing_work(pool, work);
-- 
1.7.7.6

