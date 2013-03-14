Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab3CNK5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:57:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51842 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab3CNKhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alex Bligh <alex@alex.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 29/88] nbd: fsync and kill block device on shutdown
Date: Thu, 14 Mar 2013 10:35:22 +0000
Message-Id: <1363257381-15900-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 3a2d63f87989e01437ba994df5f297528c353d7d upstream.

There are two problems with shutdown in the NBD driver.

1: Receiving the NBD_DISCONNECT ioctl does not sync the filesystem.

   This patch adds the sync operation into __nbd_ioctl()'s
   NBD_DISCONNECT handler.  This is useful because BLKFLSBUF is restricted
   to processes that have CAP_SYS_ADMIN, and the NBD client may not
   possess it (fsync of the block device does not sync the filesystem,
   either).

2: Once we clear the socket we have no guarantee that later reads will
   come from the same backing storage.

   The patch adds calls to kill_bdev() in __nbd_ioctl()'s socket
   clearing code so the page cache is cleaned, lest reads that hit on the
   page cache will return stale data from the previously-accessible disk.

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

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Paul Clements <Paul.Clements@steeleye.com>
Cc: Alex Bligh <alex@alex.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/nbd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 3c4c225..7f25e24 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -584,12 +584,20 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
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
@@ -603,6 +611,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		nbd_clear_que(nbd);
 		BUG_ON(!list_empty(&nbd->queue_head));
 		BUG_ON(!list_empty(&nbd->waiting_queue));
+		kill_bdev(bdev);
 		if (file)
 			fput(file);
 		return 0;
@@ -683,6 +692,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		nbd->file = NULL;
 		nbd_clear_que(nbd);
 		dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
+		kill_bdev(bdev);
 		if (file)
 			fput(file);
 		nbd->bytesize = 0;
-- 
1.8.1.2

