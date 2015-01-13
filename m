Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbbAMNpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:45:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38876 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbAMNpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:45:03 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Paul Clements <Paul.Clements@steeleye.com>
Cc: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [RFC 2/4] nbd: Split 'DO_IT' into three functions
Date: Tue, 13 Jan 2015 14:44:23 +0100
Message-Id: <1421156665-27318-3-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421156665-27318-1-git-send-email-mpa@pengutronix.de>
References: <1421156665-27318-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DO_IT ioctl does a lot of things to handle the connection. This
patch splits the DO_IT ioctl routine into three functions
nbd_connection_start()/run()/stop(). This makes it easier to read and
allows other functions to call the same code. This patch prepares the
DO_IT code for nbd-root device.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/block/nbd.c | 146 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 91 insertions(+), 55 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 6bd7df2ff648..0ff6ebbec252 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -596,6 +596,95 @@ static void do_nbd_request(struct request_queue *q)
 	}
 }
 
+static int nbd_connection_start(struct block_device *bdev,
+				struct nbd_device *nbd)
+{
+	if (nbd->flags & NBD_FLAG_READ_ONLY)
+		set_device_ro(bdev, true);
+	if (nbd->flags & NBD_FLAG_SEND_TRIM)
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
+	if (nbd->flags & NBD_FLAG_SEND_FLUSH)
+		blk_queue_flush(nbd->disk->queue, REQ_FLUSH);
+	else
+		blk_queue_flush(nbd->disk->queue, 0);
+	return 0;
+}
+
+static int nbd_connection_run(struct nbd_device *nbd)
+{
+	struct task_struct *thread;
+	int error;
+
+	thread = kthread_run(nbd_thread, nbd, "%s", nbd->disk->disk_name);
+	if (IS_ERR(thread)) {
+		mutex_lock(&nbd->tx_lock);
+		return PTR_ERR(thread);
+	}
+
+	error = nbd_do_it(nbd);
+
+	kthread_stop(thread);
+
+	return error;
+}
+
+/*
+ * Call with tx_lock held
+ */
+static int nbd_connection_stop(struct block_device *bdev,
+			       struct nbd_device *nbd)
+{
+	struct socket *sock;
+
+	sock_shutdown(nbd, 0);
+	sock = nbd->sock;
+	nbd->sock = NULL;
+	nbd_clear_que(nbd);
+	dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
+	kill_bdev(bdev);
+	queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
+	set_device_ro(bdev, false);
+	if (sock)
+		sockfd_put(sock);
+
+	nbd->flags = 0;
+	nbd->bytesize = 0;
+	bdev->bd_inode->i_size = 0;
+	set_capacity(nbd->disk, 0);
+
+	if (max_part > 0)
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
+	if (nbd->disconnect) /* user requested, ignore socket errors */
+		return 0;
+
+	return nbd->harderror;
+}
+
+/*
+ * Call with tx_lock held
+ */
+static int nbd_connection_handler(struct block_device *bdev,
+				  struct nbd_device *nbd)
+{
+	int error;
+
+	mutex_unlock(&nbd->tx_lock);
+
+	error = nbd_connection_start(bdev, nbd);
+	if (error)
+		return error;
+
+	error = nbd_connection_run(nbd);
+
+	mutex_lock(&nbd->tx_lock);
+	if (error)
+		return error;
+
+	error = nbd_connection_stop(bdev, nbd);
+
+	return error;
+}
+
 /* Must be called with tx_lock held */
 
 static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
@@ -684,61 +773,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		set_capacity(nbd->disk, nbd->bytesize >> 9);
 		return 0;
 
-	case NBD_DO_IT: {
-		struct task_struct *thread;
-		struct socket *sock;
-		int error;
-
-		if (nbd->pid)
-			return -EBUSY;
-		if (!nbd->sock)
-			return -EINVAL;
-
-		mutex_unlock(&nbd->tx_lock);
-
-		if (nbd->flags & NBD_FLAG_READ_ONLY)
-			set_device_ro(bdev, true);
-		if (nbd->flags & NBD_FLAG_SEND_TRIM)
-			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
-				nbd->disk->queue);
-		if (nbd->flags & NBD_FLAG_SEND_FLUSH)
-			blk_queue_flush(nbd->disk->queue, REQ_FLUSH);
-		else
-			blk_queue_flush(nbd->disk->queue, 0);
-
-		thread = kthread_run(nbd_thread, nbd, "%s",
-				     nbd->disk->disk_name);
-		if (IS_ERR(thread)) {
-			mutex_lock(&nbd->tx_lock);
-			return PTR_ERR(thread);
-		}
-
-		error = nbd_do_it(nbd);
-		kthread_stop(thread);
-
-		mutex_lock(&nbd->tx_lock);
-		if (error)
-			return error;
-		sock_shutdown(nbd, 0);
-		sock = nbd->sock;
-		nbd->sock = NULL;
-		nbd_clear_que(nbd);
-		dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
-		kill_bdev(bdev);
-		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
-		set_device_ro(bdev, false);
-		if (sock)
-			sockfd_put(sock);
-		nbd->flags = 0;
-		nbd->bytesize = 0;
-		bdev->bd_inode->i_size = 0;
-		set_capacity(nbd->disk, 0);
-		if (max_part > 0)
-			ioctl_by_bdev(bdev, BLKRRPART, 0);
-		if (nbd->disconnect) /* user requested, ignore socket errors */
-			return 0;
-		return nbd->harderror;
-	}
+	case NBD_DO_IT:
+		return nbd_connection_handler(bdev, nbd);
 
 	case NBD_CLEAR_QUE:
 		/*
-- 
2.1.4

