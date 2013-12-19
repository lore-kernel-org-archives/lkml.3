Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3LSJgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:36:45 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60166 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab3LSJgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:36:42 -0500
Date: Thu, 19 Dec 2013 15:06:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 04/13] drivers: block: Mark the function as static in
 drbd_worker.c
Message-ID: <34369b05532be286682cad1591276af1d6b702fb.1387445396.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions drbd_endio_read_sec_final(), drbd_send_barrier(),
need_to_send_barrier(), dequeue_work_batch(), dequeue_work_item() and
wait_for_work() as static in drbd/drbd_worker.c because they are not
used outside this file.

This eliminates the following warnings in drbd/drbd_worker.c:
drivers/block/drbd/drbd_worker.c:99:6: warning: no previous prototype for ‘drbd_endio_read_sec_final’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_worker.c:1276:5: warning: no previous prototype for ‘drbd_send_barrier’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_worker.c:1774:6: warning: no previous prototype for ‘need_to_send_barrier’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_worker.c:1798:6: warning: no previous prototype for ‘dequeue_work_batch’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_worker.c:1806:6: warning: no previous prototype for ‘dequeue_work_item’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_worker.c:1815:6: warning: no previous prototype for ‘wait_for_work’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_worker.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 891c0ec..2733ae3 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -96,7 +96,7 @@ void drbd_md_io_complete(struct bio *bio, int error)
 /* reads on behalf of the partner,
  * "submitted" by the receiver
  */
-void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(local)
+static void drbd_endio_read_sec_final(struct drbd_peer_request *peer_req) __releases(local)
 {
 	unsigned long flags = 0;
 	struct drbd_conf *mdev = peer_req->w.mdev;
@@ -1273,7 +1273,7 @@ int w_prev_work_done(struct drbd_work *w, int cancel)
  * and to be able to wait for them.
  * See also comment in drbd_adm_attach before drbd_suspend_io.
  */
-int drbd_send_barrier(struct drbd_tconn *tconn)
+static int drbd_send_barrier(struct drbd_tconn *tconn)
 {
 	struct p_barrier *p;
 	struct drbd_socket *sock;
@@ -1771,7 +1771,7 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
  * (because we have not yet seen new requests), we should send the
  * corresponding barrier now.  Must be checked within the same spinlock
  * that is used to check for new requests. */
-bool need_to_send_barrier(struct drbd_tconn *connection)
+static bool need_to_send_barrier(struct drbd_tconn *connection)
 {
 	if (!connection->send.seen_any_write_yet)
 		return false;
@@ -1795,7 +1795,7 @@ bool need_to_send_barrier(struct drbd_tconn *connection)
 	return true;
 }
 
-bool dequeue_work_batch(struct drbd_work_queue *queue, struct list_head *work_list)
+static bool dequeue_work_batch(struct drbd_work_queue *queue, struct list_head *work_list)
 {
 	spin_lock_irq(&queue->q_lock);
 	list_splice_init(&queue->q, work_list);
@@ -1803,7 +1803,7 @@ bool dequeue_work_batch(struct drbd_work_queue *queue, struct list_head *work_li
 	return !list_empty(work_list);
 }
 
-bool dequeue_work_item(struct drbd_work_queue *queue, struct list_head *work_list)
+static bool dequeue_work_item(struct drbd_work_queue *queue, struct list_head *work_list)
 {
 	spin_lock_irq(&queue->q_lock);
 	if (!list_empty(&queue->q))
@@ -1812,7 +1812,7 @@ bool dequeue_work_item(struct drbd_work_queue *queue, struct list_head *work_lis
 	return !list_empty(work_list);
 }
 
-void wait_for_work(struct drbd_tconn *connection, struct list_head *work_list)
+static void wait_for_work(struct drbd_tconn *connection, struct list_head *work_list)
 {
 	DEFINE_WAIT(wait);
 	struct net_conf *nc;
-- 
1.7.9.5

