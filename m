Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbbAMNpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:45:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38886 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbAMNpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:45:11 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Paul Clements <Paul.Clements@steeleye.com>
Cc: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [RFC 3/4] nbd: Create helper functions for ioctls
Date: Tue, 13 Jan 2015 14:44:24 +0100
Message-Id: <1421156665-27318-4-git-send-email-mpa@pengutronix.de>
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

This patch prepares the nbd code for the nbd-root device patch. It
moves the ioctl code into separate functions so they can be called
directly. The patch creates nbd_set_total_size(), nbd_set_blksize(),
nbd_set_sock() and nbd_set_timeout().

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/block/nbd.c | 79 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 22 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 0ff6ebbec252..11f7644be111 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -596,6 +596,55 @@ static void do_nbd_request(struct request_queue *q)
 	}
 }
 
+/*
+ * Call with tx_lock held
+ */
+static void nbd_set_total_size(struct block_device *bdev,
+			       struct nbd_device *nbd, size_t size)
+{
+	nbd->bytesize = size;
+	bdev->bd_inode->i_size = size;
+	set_blocksize(bdev, nbd->blksize);
+	set_capacity(nbd->disk, size >> 9);
+}
+
+/*
+ * Call with tx_lock held
+ */
+static void nbd_set_blksize(struct block_device *bdev, struct nbd_device *nbd,
+			    size_t blksize)
+{
+	u64 new_bytesize;
+
+	nbd->blksize = blksize;
+	bdev->bd_inode->i_size = nbd->bytesize;
+	set_blocksize(bdev, nbd->blksize);
+
+	new_bytesize = nbd->bytesize & ~(nbd->blksize-1);
+	if (new_bytesize != nbd->bytesize)
+		nbd_set_total_size(bdev, nbd, new_bytesize);
+}
+
+/*
+ * Call with tx_lock held
+ */
+static void nbd_set_sock(struct block_device *bdev, struct nbd_device *nbd,
+			 struct socket *sock)
+{
+	nbd->sock = sock;
+	if (max_part > 0)
+		bdev->bd_invalidated = 1;
+	nbd->disconnect = 0; /* we're connected now */
+}
+
+/*
+ * Call with tx_lock held
+ */
+static void nbd_set_timeout(struct nbd_device *nbd, int timeout)
+{
+	nbd->xmit_timeout = timeout * HZ;
+}
+
 static int nbd_connection_start(struct block_device *bdev,
 				struct nbd_device *nbd)
 {
@@ -733,33 +782,22 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		if (nbd->sock)
 			return -EBUSY;
 		sock = sockfd_lookup(arg, &err);
-		if (sock) {
-			nbd->sock = sock;
-			if (max_part > 0)
-				bdev->bd_invalidated = 1;
-			nbd->disconnect = 0; /* we're connected now */
-			return 0;
-		}
-		return -EINVAL;
+		if (!sock)
+			return -EINVAL;
+
+		nbd_set_sock(bdev, nbd, sock);
 	}
 
 	case NBD_SET_BLKSIZE:
-		nbd->blksize = arg;
-		nbd->bytesize &= ~(nbd->blksize-1);
-		bdev->bd_inode->i_size = nbd->bytesize;
-		set_blocksize(bdev, nbd->blksize);
-		set_capacity(nbd->disk, nbd->bytesize >> 9);
+		nbd_set_blksize(bdev, nbd, arg);
 		return 0;
 
 	case NBD_SET_SIZE:
-		nbd->bytesize = arg & ~(nbd->blksize-1);
-		bdev->bd_inode->i_size = nbd->bytesize;
-		set_blocksize(bdev, nbd->blksize);
-		set_capacity(nbd->disk, nbd->bytesize >> 9);
+		nbd_set_total_size(bdev, nbd, arg & ~(nbd->blksize-1));
 		return 0;
 
 	case NBD_SET_TIMEOUT:
-		nbd->xmit_timeout = arg * HZ;
+		nbd_set_timeout(nbd, arg);
 		return 0;
 
 	case NBD_SET_FLAGS:
@@ -767,10 +805,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		return 0;
 
 	case NBD_SET_SIZE_BLOCKS:
-		nbd->bytesize = ((u64) arg) * nbd->blksize;
-		bdev->bd_inode->i_size = nbd->bytesize;
-		set_blocksize(bdev, nbd->blksize);
-		set_capacity(nbd->disk, nbd->bytesize >> 9);
+		nbd_set_total_size(bdev, nbd, ((u64)arg) * nbd->blksize);
 		return 0;
 
 	case NBD_DO_IT:
-- 
2.1.4

