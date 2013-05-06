Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab3EFWrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:47:18 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:51447 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab3EFWrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:47:13 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/33] blk-throttle: make throtl_pending_timer_fn() ready for hierarchy
Date: Mon,  6 May 2013 15:46:08 -0700
Message-Id: <1367880372-28312-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

throtl_pending_timer_fn() currently assumes that the parent_sq is the
top level one and the bio's dispatched are ready to be issued;
however, this assumption will be wrong with proper hierarchy support.
This patch makes the following changes to make
throtl_pending_timer_fn() ready for hiearchy.

* If the parent_sq isn't the top-level one, update the parent
  throtl_grp's dispatch time and schedule the next dispatch as
  necessary.  If the parent's dispatch time is now, repeat the
  function for the parent throtl_grp.

* If the parent_sq is the top-level one, kick issue work_item as
  before.

* The debug message printed by throtl_log() now prints out the
  service_queue's nr_queued[] instead of the total nr_queued as the
  latter becomes uninteresting and misleading with hierarchical
  dispatch.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 0420261..bc65077 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -952,23 +952,33 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
  * This timer is armed when a child throtl_grp with active bio's become
  * pending and queued on the service_queue's pending_tree and expires when
  * the first child throtl_grp should be dispatched.  This function
- * dispatches bio's from the children throtl_grps and kicks
- * throtl_data->dispatch_work if there are bio's ready to be issued.
+ * dispatches bio's from the children throtl_grps to the parent
+ * service_queue.
+ *
+ * If the parent's parent is another throtl_grp, dispatching is propagated
+ * by either arming its pending_timer or repeating dispatch directly.  If
+ * the top-level service_tree is reached, throtl_data->dispatch_work is
+ * kicked so that the ready bio's are issued.
  */
 static void throtl_pending_timer_fn(unsigned long arg)
 {
 	struct throtl_service_queue *sq = (void *)arg;
+	struct throtl_grp *tg = sq_to_tg(sq);
 	struct throtl_data *td = sq_to_td(sq);
 	struct request_queue *q = td->queue;
-	bool dispatched = false;
+	struct throtl_service_queue *parent_sq;
+	bool dispatched;
 	int ret;
 
 	spin_lock_irq(q->queue_lock);
+again:
+	parent_sq = sq->parent_sq;
+	dispatched = false;
 
 	while (true) {
 		throtl_log(sq, "dispatch nr_queued=%u read=%u write=%u",
-			   td->nr_queued[READ] + td->nr_queued[WRITE],
-			   td->nr_queued[READ], td->nr_queued[WRITE]);
+			   sq->nr_queued[READ] + sq->nr_queued[WRITE],
+			   sq->nr_queued[READ], sq->nr_queued[WRITE]);
 
 		ret = throtl_select_dispatch(sq);
 		if (ret) {
@@ -985,9 +995,25 @@ static void throtl_pending_timer_fn(unsigned long arg)
 		spin_lock_irq(q->queue_lock);
 	}
 
-	if (dispatched)
-		queue_work(kthrotld_workqueue, &td->dispatch_work);
+	if (!dispatched)
+		goto out_unlock;
 
+	if (parent_sq) {
+		/* @parent_sq is another throl_grp, propagate dispatch */
+		if (tg->flags & THROTL_TG_WAS_EMPTY) {
+			tg_update_disptime(tg);
+			if (!throtl_schedule_next_dispatch(parent_sq, false)) {
+				/* window is already open, repeat dispatching */
+				sq = parent_sq;
+				tg = sq_to_tg(sq);
+				goto again;
+			}
+		}
+	} else {
+		/* reached the top-level, queue issueing */
+		queue_work(kthrotld_workqueue, &td->dispatch_work);
+	}
+out_unlock:
 	spin_unlock_irq(q->queue_lock);
 }
 
-- 
1.8.1.4

