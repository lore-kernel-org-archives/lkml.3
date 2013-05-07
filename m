Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3EGV53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:57:29 -0400
Received: from mail.ispras.ru ([83.149.199.45]:57887 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab3EGV50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:57:26 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Raja Mani <raja_mani@ti.com>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] [media] wl128x: do not call copy_to_user() while holding spinlocks
Date: Wed,  8 May 2013 01:57:08 +0400
Message-Id: <1367963828-7910-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() must not be called with spinlocks held, but it is in
fmc_transfer_rds_from_internal_buff().
The patch copies data to tmpbuf, releases spinlock and then passes it to userspace.

By the way there is a small unification: replace a couple of hardcoded constants by a macro.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/radio/wl128x/fmdrv_common.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index a002234..253f307 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -715,7 +715,7 @@ static void fm_irq_handle_rdsdata_getcmd_resp(struct fmdev *fmdev)
 	struct fm_rdsdata_format rds_fmt;
 	struct fm_rds *rds = &fmdev->rx.rds;
 	unsigned long group_idx, flags;
-	u8 *rds_data, meta_data, tmpbuf[3];
+	u8 *rds_data, meta_data, tmpbuf[FM_RDS_BLK_SIZE];
 	u8 type, blk_idx;
 	u16 cur_picode;
 	u32 rds_len;
@@ -1073,6 +1073,7 @@ int fmc_transfer_rds_from_internal_buff(struct fmdev *fmdev, struct file *file,
 		u8 __user *buf, size_t count)
 {
 	u32 block_count;
+	u8 tmpbuf[FM_RDS_BLK_SIZE];
 	unsigned long flags;
 	int ret;
 
@@ -1087,29 +1088,32 @@ int fmc_transfer_rds_from_internal_buff(struct fmdev *fmdev, struct file *file,
 	}
 
 	/* Calculate block count from byte count */
-	count /= 3;
+	count /= FM_RDS_BLK_SIZE;
 	block_count = 0;
 	ret = 0;
 
-	spin_lock_irqsave(&fmdev->rds_buff_lock, flags);
-
 	while (block_count < count) {
-		if (fmdev->rx.rds.wr_idx == fmdev->rx.rds.rd_idx)
-			break;
+		spin_lock_irqsave(&fmdev->rds_buff_lock, flags);
 
-		if (copy_to_user(buf, &fmdev->rx.rds.buff[fmdev->rx.rds.rd_idx],
-					FM_RDS_BLK_SIZE))
+		if (fmdev->rx.rds.wr_idx == fmdev->rx.rds.rd_idx) {
+			spin_unlock_irqrestore(&fmdev->rds_buff_lock, flags);
 			break;
-
+		}
+		memcpy(tmpbuf, &fmdev->rx.rds.buff[fmdev->rx.rds.rd_idx],
+					FM_RDS_BLK_SIZE);
 		fmdev->rx.rds.rd_idx += FM_RDS_BLK_SIZE;
 		if (fmdev->rx.rds.rd_idx >= fmdev->rx.rds.buf_size)
 			fmdev->rx.rds.rd_idx = 0;
 
+		spin_unlock_irqrestore(&fmdev->rds_buff_lock, flags);
+
+		if (copy_to_user(buf, tmpbuf, FM_RDS_BLK_SIZE))
+			break;
+
 		block_count++;
 		buf += FM_RDS_BLK_SIZE;
 		ret += FM_RDS_BLK_SIZE;
 	}
-	spin_unlock_irqrestore(&fmdev->rds_buff_lock, flags);
 	return ret;
 }
 
-- 
1.7.9.5

