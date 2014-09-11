Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaIKMbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:31:43 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:47845 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbaIKM3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:29:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 8/9] drbd: reduce lock contention in drbd_worker
Date: Thu, 11 Sep 2014 14:29:12 +0200
Message-Id: <1410438553-30440-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
References: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

The worker may now dequeue work items in batches.
This should reduce lock contention during busy periods.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_worker.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 3ed2d87..d2d1f97 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -2026,8 +2026,6 @@ static void wait_for_work(struct drbd_connection *connection, struct list_head *
 		prepare_to_wait(&connection->sender_work.q_wait, &wait, TASK_INTERRUPTIBLE);
 		spin_lock_irq(&connection->resource->req_lock);
 		spin_lock(&connection->sender_work.q_lock);	/* FIXME get rid of this one? */
-		/* dequeue single item only,
-		 * we still use drbd_queue_work_front() in some places */
 		if (!list_empty(&connection->sender_work.q))
 			list_splice_tail_init(&connection->sender_work.q, work_list);
 		spin_unlock(&connection->sender_work.q_lock);	/* FIXME get rid of this one? */
@@ -2114,7 +2112,7 @@ int drbd_worker(struct drbd_thread *thi)
 		if (get_t_state(thi) != RUNNING)
 			break;
 
-		while (!list_empty(&work_list)) {
+		if (!list_empty(&work_list)) {
 			w = list_first_entry(&work_list, struct drbd_work, list);
 			list_del_init(&w->list);
 			update_worker_timing_details(connection, w->cb);
@@ -2130,13 +2128,13 @@ int drbd_worker(struct drbd_thread *thi)
 			update_worker_timing_details(connection, do_unqueued_work);
 			do_unqueued_work(connection);
 		}
-		while (!list_empty(&work_list)) {
+		if (!list_empty(&work_list)) {
 			w = list_first_entry(&work_list, struct drbd_work, list);
 			list_del_init(&w->list);
 			update_worker_timing_details(connection, w->cb);
 			w->cb(w, 1);
-		}
-		dequeue_work_batch(&connection->sender_work, &work_list);
+		} else
+			dequeue_work_batch(&connection->sender_work, &work_list);
 	} while (!list_empty(&work_list) || test_bit(DEVICE_WORK_PENDING, &connection->flags));
 
 	rcu_read_lock();
-- 
1.9.1

