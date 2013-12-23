Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab3LWWGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:06:15 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60644 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab3LWV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:53 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 18/27] drbd: Turn conn_flush_workqueue() into drbd_flush_workqueue()
Date: Mon, 23 Dec 2013 22:50:47 +0100
Message-Id: <1387835456-29695-19-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The new function can flush any work queue, not just the work queue of the data
socket of a connection.

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   12 ++----------
 drivers/block/drbd/drbd_main.c     |   24 ++++++++++++++++++++++++
 drivers/block/drbd/drbd_nl.c       |   10 +++++-----
 drivers/block/drbd/drbd_receiver.c |   22 ++--------------------
 4 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index eb2bc90..7185c98 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -346,11 +346,6 @@ enum epoch_event {
 	EV_CLEANUP = 32, /* used as flag */
 };
 
-struct drbd_wq_barrier {
-	struct drbd_work w;
-	struct completion done;
-};
-
 struct digest_info {
 	int digest_size;
 	void *digest;
@@ -1349,12 +1344,7 @@ extern void __drbd_free_peer_req(struct drbd_device *, struct drbd_peer_request
 extern struct page *drbd_alloc_pages(struct drbd_peer_device *, unsigned int, bool);
 extern void drbd_set_recv_tcq(struct drbd_device *device, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_device *device, struct list_head *to_be_freed);
-extern void conn_flush_workqueue(struct drbd_connection *connection);
 extern int drbd_connected(struct drbd_peer_device *);
-static inline void drbd_flush_workqueue(struct drbd_device *device)
-{
-	conn_flush_workqueue(first_peer_device(device)->connection);
-}
 
 /* Yes, there is kernel_setsockopt, but only since 2.6.18.
  * So we have our own copy of it here. */
@@ -1709,6 +1699,8 @@ drbd_queue_work(struct drbd_work_queue *q, struct drbd_work *w)
 	wake_up(&q->q_wait);
 }
 
+extern void drbd_flush_workqueue(struct drbd_work_queue *work_queue);
+
 static inline void wake_asender(struct drbd_connection *connection)
 {
 	if (test_bit(SIGNAL_ASENDER, &connection->flags))
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 0500b56..e11f606 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2397,6 +2397,30 @@ static void drbd_init_workqueue(struct drbd_work_queue* wq)
 	init_waitqueue_head(&wq->q_wait);
 }
 
+struct completion_work {
+	struct drbd_work w;
+	struct completion done;
+};
+
+static int w_complete(struct drbd_work *w, int cancel)
+{
+	struct completion_work *completion_work =
+		container_of(w, struct completion_work, w);
+
+	complete(&completion_work->done);
+	return 0;
+}
+
+void drbd_flush_workqueue(struct drbd_work_queue *work_queue)
+{
+	struct completion_work completion_work;
+
+	completion_work.w.cb = w_complete;
+	init_completion(&completion_work.done);
+	drbd_queue_work(work_queue, &completion_work.w);
+	wait_for_completion(&completion_work.done);
+}
+
 struct drbd_resource *drbd_find_resource(const char *name)
 {
 	struct drbd_resource *resource;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index f613ba9..b202cdb 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1181,7 +1181,7 @@ void drbd_reconsider_max_bio_size(struct drbd_device *device)
 static void conn_reconfig_start(struct drbd_connection *connection)
 {
 	drbd_thread_start(&connection->worker);
-	conn_flush_workqueue(connection);
+	drbd_flush_workqueue(&connection->sender_work);
 }
 
 /* if still unconfigured, stops worker again. */
@@ -1600,7 +1600,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	 */
 	wait_event(device->misc_wait, !atomic_read(&device->ap_pending_cnt) || drbd_suspended(device));
 	/* and for any other previously queued work */
-	drbd_flush_workqueue(device);
+	drbd_flush_workqueue(&first_peer_device(device)->connection->sender_work);
 
 	rv = _drbd_request_state(device, NS(disk, D_ATTACHING), CS_VERBOSE);
 	retcode = rv;  /* FIXME: Type mismatch. */
@@ -2249,7 +2249,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 
 	((char *)new_net_conf->shared_secret)[SHARED_SECRET_MAX-1] = 0;
 
-	conn_flush_workqueue(connection);
+	drbd_flush_workqueue(&connection->sender_work);
 
 	mutex_lock(&adm_ctx.resource->conf_update);
 	old_net_conf = connection->net_conf;
@@ -2589,7 +2589,7 @@ int drbd_adm_invalidate(struct sk_buff *skb, struct genl_info *info)
 	 * Also wait for it's after_state_ch(). */
 	drbd_suspend_io(device);
 	wait_event(device->misc_wait, !test_bit(BITMAP_IO, &device->flags));
-	drbd_flush_workqueue(device);
+	drbd_flush_workqueue(&first_peer_device(device)->connection->sender_work);
 
 	/* If we happen to be C_STANDALONE R_SECONDARY, just change to
 	 * D_INCONSISTENT, and set all bits in the bitmap.  Otherwise,
@@ -2655,7 +2655,7 @@ int drbd_adm_invalidate_peer(struct sk_buff *skb, struct genl_info *info)
 	 * Also wait for it's after_state_ch(). */
 	drbd_suspend_io(device);
 	wait_event(device->misc_wait, !test_bit(BITMAP_IO, &device->flags));
-	drbd_flush_workqueue(device);
+	drbd_flush_workqueue(&first_peer_device(device)->connection->sender_work);
 
 	/* If we happen to be C_STANDALONE R_PRIMARY, just set all bits
 	 * in the bitmap.  Otherwise, try to start a resync handshake
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 3c88efa..c99f252 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4484,24 +4484,6 @@ static void drbdd(struct drbd_connection *connection)
 	conn_request_state(connection, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 }
 
-static int w_complete(struct drbd_work *w, int cancel)
-{
-	struct drbd_wq_barrier *b = container_of(w, struct drbd_wq_barrier, w);
-
-	complete(&b->done);
-	return 0;
-}
-
-void conn_flush_workqueue(struct drbd_connection *connection)
-{
-	struct drbd_wq_barrier barr;
-
-	barr.w.cb = w_complete;
-	init_completion(&barr.done);
-	drbd_queue_work(&connection->sender_work, &barr.w);
-	wait_for_completion(&barr.done);
-}
-
 static void conn_disconnect(struct drbd_connection *connection)
 {
 	struct drbd_peer_device *peer_device;
@@ -4589,14 +4571,14 @@ static int drbd_disconnected(struct drbd_peer_device *peer_device)
 	/* wait for all w_e_end_data_req, w_e_end_rsdata_req, w_send_barrier,
 	 * w_make_resync_request etc. which may still be on the worker queue
 	 * to be "canceled" */
-	drbd_flush_workqueue(device);
+	drbd_flush_workqueue(&peer_device->connection->sender_work);
 
 	drbd_finish_peer_reqs(device);
 
 	/* This second workqueue flush is necessary, since drbd_finish_peer_reqs()
 	   might have issued a work again. The one before drbd_finish_peer_reqs() is
 	   necessary to reclain net_ee in drbd_finish_peer_reqs(). */
-	drbd_flush_workqueue(device);
+	drbd_flush_workqueue(&peer_device->connection->sender_work);
 
 	/* need to do it again, drbd_finish_peer_reqs() may have populated it
 	 * again via drbd_try_clear_on_disk_bm(). */
-- 
1.7.9.5

