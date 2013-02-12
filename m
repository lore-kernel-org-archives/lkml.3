Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317Ab3BLQGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:06:38 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54564 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab3BLQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:06:35 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org>, <nbd-general@lists.sf.net>,
        Paul Clements <Paul.Clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] nbd: fsync and kill block device on shutdown
Date: Tue, 12 Feb 2013 17:06:10 +0100
Message-Id: <1360685171-3792-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two problems with shutdown in the NBD driver.  The first is
that receiving the NBD_DISCONNECT ioctl does not sync the filesystem;
this is useful because BLKFLSBUF is restricted to processes that have
CAP_SYS_ADMIN, and the NBD client may not possess it (fsync of the
block device does not sync the filesystem, either).

The second is that once we clear the socket we have no guarantee that
later reads will come from the same backing storage.  Thus the page cache
must be cleaned, lest reads that hit on the page cache will return stale
data from the previously-accessible disk.

Example:

    # qemu-nbd -r -c/dev/nbd0 /dev/sr0
    # file -s /dev/nbd0
    /dev/stdin: # UDF filesystem data (version 1.5) etc.
    # qemu-nbd -d /dev/nbd0
    # qemu-nbd -r -c/dev/nbd0 /dev/sda
    # file -s /dev/nbd0
    /dev/stdin: # UDF filesystem data (version 1.5) etc.

While /dev/sda has:

    # file -s /dev/sda
    /dev/sda: x86 boot sector; etc.

Cc: <stable@vger.kernel.org>
Cc: <nbd-general@lists.sf.net>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/block/nbd.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 5603765..a9c5c7a 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -608,12 +608,20 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		struct request sreq;
 
 		dev_info(disk_to_dev(nbd->disk), "NBD_DISCONNECT\n");
+		if (!nbd->sock)
+			return -EINVAL;
 
+		mutex_unlock(&nbd->tx_lock);
+		fsync_bdev(bdev);
+		mutex_lock(&nbd->tx_lock);
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_SPECIAL;
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
+
+		/* Check again after getting mutex back.  */
 		if (!nbd->sock)
 			return -EINVAL;
+
 		nbd_send_req(nbd, &sreq);
                 return 0;
 	}
@@ -627,6 +635,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		nbd_clear_que(nbd);
 		BUG_ON(!list_empty(&nbd->queue_head));
 		BUG_ON(!list_empty(&nbd->waiting_queue));
+		kill_bdev(bdev);
 		if (file)
 			fput(file);
 		return 0;
@@ -719,6 +728,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		nbd->file = NULL;
 		nbd_clear_que(nbd);
 		dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
+		kill_bdev(bdev);
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
 		if (file)
 			fput(file);
-- 
1.7.1


