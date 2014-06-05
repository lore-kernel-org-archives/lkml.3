Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaFEEVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaFEEVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Clements <Paul.Clements@steeleye.com>,
        Alex Bligh <alex@alex.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 156/214] nbd: fsync and kill block device on shutdown
Date: Wed,  4 Jun 2014 21:18:39 -0700
Message-Id: <20140605041700.712194782@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjusted context
 - s/\bnbd\b/lo/
 - Incorporate export of kill_bdev() from commit ff01bb483265
   ('fs: move code out of buffer.c')]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[hq: Backported to 3.4: Adjusted context]
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/nbd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -584,10 +584,17 @@ static int __nbd_ioctl(struct block_devi
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
 
@@ -606,6 +613,7 @@ static int __nbd_ioctl(struct block_devi
 		nbd_clear_que(nbd);
 		BUG_ON(!list_empty(&nbd->queue_head));
 		BUG_ON(!list_empty(&nbd->waiting_queue));
+		kill_bdev(bdev);
 		if (file)
 			fput(file);
 		return 0;
@@ -688,6 +696,7 @@ static int __nbd_ioctl(struct block_devi
 		nbd->file = NULL;
 		nbd_clear_que(nbd);
 		dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
+		kill_bdev(bdev);
 		if (file)
 			fput(file);
 		nbd->bytesize = 0;


