Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaIKMbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:31:41 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:47846 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbaIKM3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:29:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 7/9] drbd: Improve asender performance
Date: Thu, 11 Sep 2014 14:29:11 +0200
Message-Id: <1410438553-30440-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
References: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars@linbit.com>

Shorten receive path in the asender thread. Reduces CPU utilisation
of asender when receiving packets, and with that increases IOPs.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |  6 ++++++
 drivers/block/drbd/drbd_worker.c   | 11 +----------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 3ae769e..6960fb0 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -5561,6 +5561,7 @@ int drbd_asender(struct drbd_thread *thi)
 		 * rv <  expected: "woken" by signal during receive
 		 * rv == 0	 : "connection shut down by peer"
 		 */
+received_more:
 		if (likely(rv > 0)) {
 			received += rv;
 			buf	 += rv;
@@ -5636,6 +5637,11 @@ int drbd_asender(struct drbd_thread *thi)
 			expect	 = header_size;
 			cmd	 = NULL;
 		}
+		if (test_bit(SEND_PING, &connection->flags))
+			continue;
+		rv = drbd_recv_short(connection->meta.socket, buf, expect-received, MSG_DONTWAIT);
+		if (rv > 0)
+			goto received_more;
 	}
 
 	if (0) {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 3b74f08..3ed2d87 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1994,22 +1994,13 @@ static bool dequeue_work_batch(struct drbd_work_queue *queue, struct list_head *
 	return !list_empty(work_list);
 }
 
-static bool dequeue_work_item(struct drbd_work_queue *queue, struct list_head *work_list)
-{
-	spin_lock_irq(&queue->q_lock);
-	if (!list_empty(&queue->q))
-		list_move(queue->q.next, work_list);
-	spin_unlock_irq(&queue->q_lock);
-	return !list_empty(work_list);
-}
-
 static void wait_for_work(struct drbd_connection *connection, struct list_head *work_list)
 {
 	DEFINE_WAIT(wait);
 	struct net_conf *nc;
 	int uncork, cork;
 
-	dequeue_work_item(&connection->sender_work, work_list);
+	dequeue_work_batch(&connection->sender_work, work_list);
 	if (!list_empty(work_list))
 		return;
 
-- 
1.9.1

