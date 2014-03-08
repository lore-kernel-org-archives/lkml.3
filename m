Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaCHM7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:59:51 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37396 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaCHM7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:59:25 -0500
From: Roman Pen <r.peniaev@gmail.com>
Cc: Roman Peniaev <r.peniaev@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [v2 PATCH 1/1] mtd: mtd_blkdevs: handle REQ_FLUSH request and do explicit flush of writeback buffer
Date: Sat,  8 Mar 2014 21:59:14 +0900
Message-Id: <1394283554-27423-1-git-send-email-r.peniaev@gmail.com>
X-Mailer: git-send-email 1.8.5.2
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Peniaev <r.peniaev@gmail.com>

mtd_blkdevs is device with volatile cache (writeback buffer), so it should support
REQ_FLUSH to do explicit flush.

Without this patch 'sync' does not guarantee that writeback buffer will be flushed
on disk in case of power off, e.g.:

  $ cp some_file /mnt
  $ sync

  ### POWER OFF

In case of this sequence writeback buffer will not be flushed on disk.

This patch fixes this behaviour and explicitly reports to block layer that flush
requests are being supported.

Signed-off-by: Roman Peniaev <r.peniaev@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>
CC: Brian Norris <computersforpeace@gmail.com>
CC: linux-mtd@lists.infradead.org
CC: linux-kernel@vger.kernel.org
---
 drivers/mtd/mtd_blkdevs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 5073cbc..b2970a0 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -89,6 +89,9 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	if (req->cmd_type != REQ_TYPE_FS)
 		return -EIO;
 
+	if (req->cmd_flags & REQ_FLUSH)
+		return tr->flush(dev);
+
 	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
 	    get_capacity(req->rq_disk))
 		return -EIO;
@@ -409,6 +412,9 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (!new->rq)
 		goto error3;
 
+	if (tr->flush)
+		blk_queue_flush(new->rq, REQ_FLUSH);
+
 	new->rq->queuedata = new;
 	blk_queue_logical_block_size(new->rq, tr->blksize);
 
-- 
1.8.5.2

