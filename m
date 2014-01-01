Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaAAQVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 11:21:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42303 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaAAQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 11:21:31 -0500
From: Roman Pen <r.peniaev@gmail.com>
Cc: Roman Peniaev <r.peniaev@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mtd: mtd_blkdevs: handle REQ_FLUSH request and do explicit flush of writeback buffer
Date: Thu,  2 Jan 2014 01:21:21 +0900
Message-Id: <1388593281-22613-1-git-send-email-r.peniaev@gmail.com>
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
CC: linux-mtd@lists.infradead.org
CC: linux-kernel@vger.kernel.org
---
 drivers/mtd/mtd_blkdevs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 5073cbc..feafe5c 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -89,6 +89,12 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	if (req->cmd_type != REQ_TYPE_FS)
 		return -EIO;
 
+	if (req->cmd_flags & REQ_FLUSH) {
+		if (tr->flush)
+			return tr->flush(dev);
+		return 0;
+	}
+
 	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
 	    get_capacity(req->rq_disk))
 		return -EIO;
@@ -409,6 +415,8 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (!new->rq)
 		goto error3;
 
+	blk_queue_flush(new->rq, REQ_FLUSH);
+
 	new->rq->queuedata = new;
 	blk_queue_logical_block_size(new->rq, tr->blksize);
 
-- 
1.8.5.2

