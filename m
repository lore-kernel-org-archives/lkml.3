Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbaGAQSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:18:02 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53126 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134AbaGAQQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 17/20] drbd: add drbd_queue_work_if_unqueued helper
Date: Tue,  1 Jul 2014 18:16:47 +0200
Message-Id: <1404231410-29852-18-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We sometimes do
    if (list_empty(&w.list))
	drbd_queue_work(&q, &w.list);

Removal (list_del_init) may happen outside all locks, after all
pending work entries have been moved to an on-stack local work list.

For not dynamically allocated, but embeded, work structs,
we must avoid to re-add until it really was removed.

Move that list_empty check inside the spin_lock(&q->q_lock)
within the helper function, and change to list_empty_careful().

This may have been the reason for a list_add corruption
inside drbd_queue_work().

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h    | 11 +++++++++++
 drivers/block/drbd/drbd_worker.c |  8 ++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c88d6c6..a71f8bb 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1778,6 +1778,17 @@ drbd_queue_work(struct drbd_work_queue *q, struct drbd_work *w)
 }
 
 static inline void
+drbd_queue_work_if_unqueued(struct drbd_work_queue *q, struct drbd_work *w)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&q->q_lock, flags);
+	if (list_empty_careful(&w->list))
+		list_add_tail(&w->list, &q->q);
+	spin_unlock_irqrestore(&q->q_lock, flags);
+	wake_up(&q->q_wait);
+}
+
+static inline void
 drbd_device_post_work(struct drbd_device *device, int work_bit)
 {
 	if (!test_and_set_bit(work_bit, &device->flags)) {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 9f0acb0..49b8873 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -452,9 +452,9 @@ void resync_timer_fn(unsigned long data)
 {
 	struct drbd_device *device = (struct drbd_device *) data;
 
-	if (list_empty(&device->resync_work.list))
-		drbd_queue_work(&first_peer_device(device)->connection->sender_work,
-				&device->resync_work);
+	drbd_queue_work_if_unqueued(
+		&first_peer_device(device)->connection->sender_work,
+		&device->resync_work);
 }
 
 static void fifo_set(struct fifo_buffer *fb, int value)
@@ -1968,7 +1968,7 @@ static void do_unqueued_work(struct drbd_connection *connection)
 static bool dequeue_work_batch(struct drbd_work_queue *queue, struct list_head *work_list)
 {
 	spin_lock_irq(&queue->q_lock);
-	list_splice_init(&queue->q, work_list);
+	list_splice_tail_init(&queue->q, work_list);
 	spin_unlock_irq(&queue->q_lock);
 	return !list_empty(work_list);
 }
-- 
1.9.1

