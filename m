Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267Ab3BLQG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:06:29 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:56139 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab3BLQG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:06:26 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Bligh <alex@alex.org.uk>, <nbd-general@lists.sf.net>,
        Paul Clements <Paul.Clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] nbd: support FLUSH requests
Date: Tue, 12 Feb 2013 17:06:09 +0100
Message-Id: <1360685171-3792-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Bligh <alex@alex.org.uk>

The NBD device does not support writeback caching, thus it is not safe
against power losses unless the client opens the target with O_DSYNC or
O_SYNC.

Add support for a new flag that the server can pass.  If the flag is
enabled, we translate REQ_FLUSH requests into the NBD_CMD_FLUSH
command.

Cc: <nbd-general@lists.sf.net>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alex Bligh <alex@alex.org.uk>
[ Removed FUA support for reasons similar to those outlined in
  https://lkml.org/lkml/2010/8/17/234 for virtio - Paolo ]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/block/nbd.c      |   22 ++++++++++++++++++++--
 include/uapi/linux/nbd.h |    3 ++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 043ddcc..5603765 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -98,6 +98,7 @@ static const char *nbdcmd_to_ascii(int cmd)
 	case  NBD_CMD_READ: return "read";
 	case NBD_CMD_WRITE: return "write";
 	case  NBD_CMD_DISC: return "disconnect";
+	case NBD_CMD_FLUSH: return "flush";
 	case  NBD_CMD_TRIM: return "trim/discard";
 	}
 	return "invalid";
@@ -244,8 +245,15 @@ static int nbd_send_req(struct nbd_device *nbd, struct request *req)
 
 	request.magic = htonl(NBD_REQUEST_MAGIC);
 	request.type = htonl(nbd_cmd(req));
-	request.from = cpu_to_be64((u64)blk_rq_pos(req) << 9);
-	request.len = htonl(size);
+
+	if (nbd_cmd(req) == NBD_CMD_FLUSH) {
+		/* Other values are reserved for FLUSH requests.  */
+		request.from = 0;
+		request.len = 0;
+	} else {
+		request.from = cpu_to_be64((u64)blk_rq_pos(req) << 9);
+		request.len = htonl(size);
+	}
 	memcpy(request.handle, &req, sizeof(req));
 
 	dprintk(DBG_TX, "%s: request %p: sending control (%s@%llu,%uB)\n",
@@ -482,6 +490,11 @@ static void nbd_handle_req(struct nbd_device *nbd, struct request *req)
 		}
 	}
 
+	if (req->cmd_flags & REQ_FLUSH) {
+		BUG_ON(unlikely(blk_rq_sectors(req)));
+		nbd_cmd(req) = NBD_CMD_FLUSH;
+	}
+
 	req->errors = 0;
 
 	mutex_lock(&nbd->tx_lock);
@@ -684,6 +697,10 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		if (nbd->flags & NBD_FLAG_SEND_TRIM)
 			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
 				nbd->disk->queue);
+		if (nbd->flags & NBD_FLAG_SEND_FLUSH)
+			blk_queue_flush(nbd->disk->queue, REQ_FLUSH);
+		else
+			blk_queue_flush(nbd->disk->queue, 0);
 
 		thread = kthread_create(nbd_thread, nbd, nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
@@ -705,6 +722,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
 		if (file)
 			fput(file);
+		nbd->flags = 0;
 		nbd->bytesize = 0;
 		bdev->bd_inode->i_size = 0;
 		set_capacity(nbd->disk, 0);
diff --git a/include/uapi/linux/nbd.h b/include/uapi/linux/nbd.h
index dfb5144..4f52549 100644
--- a/include/uapi/linux/nbd.h
+++ b/include/uapi/linux/nbd.h
@@ -33,13 +33,14 @@ enum {
 	NBD_CMD_READ = 0,
 	NBD_CMD_WRITE = 1,
 	NBD_CMD_DISC = 2,
-	/* there is a gap here to match userspace */
+	NBD_CMD_FLUSH = 3,
 	NBD_CMD_TRIM = 4
 };
 
 /* values for flags field */
 #define NBD_FLAG_HAS_FLAGS    (1 << 0) /* nbd-server supports flags */
 #define NBD_FLAG_READ_ONLY    (1 << 1) /* device is read-only */
+#define NBD_FLAG_SEND_FLUSH   (1 << 2) /* can flush writeback cache */
 /* there is a gap here to match userspace */
 #define NBD_FLAG_SEND_TRIM    (1 << 5) /* send trim/discard */
 
-- 
1.7.1


