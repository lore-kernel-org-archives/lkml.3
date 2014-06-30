Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaF3QBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:01:36 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50033 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbaF3PxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/18] drbd: fix a race stopping the worker thread
Date: Mon, 30 Jun 2014 17:52:57 +0200
Message-Id: <1404143587-24344-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We may implicitly call drbd_send() from inside wait_for_work(),
via maybe_send_barrier().

If the "stop" signal was send just before that, drbd_send() would call
flush_signals(), and we would run an unbounded schedule() afterwards.

Fix: check for thread_state == RUNNING before we schedule()

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_worker.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 5915885..47bc840 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1930,6 +1930,9 @@ static void wait_for_work(struct drbd_connection *connection, struct list_head *
 		if (send_barrier)
 			maybe_send_barrier(connection,
 					connection->send.current_epoch_nr + 1);
+		/* drbd_send() may have called flush_signals() */
+		if (get_t_state(&connection->worker) != RUNNING)
+			break;
 		schedule();
 		/* may be woken up for other things but new work, too,
 		 * e.g. if the current epoch got closed.
-- 
1.9.1

