Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaJMI4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:56:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44442 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaJMI4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:56:03 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: karam.lee@lge.com
From: karam.lee@lge.com
To: minchan@kernel.org, ngupta@vflare.org, linux-kernel@vger.kernel.org
Cc: matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com,
        "karam.lee" <karam.lee@lge.com>
Subject: [PATCH v2 3/3] zram: implement rw_page operation of zram
Date: Mon, 13 Oct 2014 17:55:42 +0900
Message-Id: <1413190542-23960-4-git-send-email-karam.lee@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413190542-23960-1-git-send-email-karam.lee@lge.com>
References: <1413190542-23960-1-git-send-email-karam.lee@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "karam.lee" <karam.lee@lge.com>

This patch implements rw_page operation for zram block device.

Signed-off-by: karam.lee <karam.lee@lge.com>
---
 drivers/block/zram/zram_drv.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b0c3a20..a44aab0 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -810,8 +810,45 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	atomic64_inc(&zram->stats.notify_free);
 }
 
+static int zram_rw_page(struct block_device *bdev, sector_t sector,
+		       struct page *page, int rw)
+{
+	int offset, ret = 1;
+	u32 index;
+	struct zram *zram;
+	struct bio_vec bv;
+
+	zram = bdev->bd_disk->private_data;
+	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
+		atomic64_inc(&zram->stats.invalid_io);
+		goto out;
+	}
+
+	down_read(&zram->init_lock);
+	if (unlikely(!init_done(zram))) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	index = sector >> SECTORS_PER_PAGE_SHIFT;
+	offset = sector & (SECTORS_PER_PAGE - 1) << SECTOR_SHIFT;
+
+	bv.bv_page = page;
+	bv.bv_len = PAGE_SIZE;
+	bv.bv_offset = 0;
+
+	ret = zram_bvec_rw(zram, &bv, index, offset, rw);
+	page_endio(page, rw, ret);
+
+out_unlock:
+	up_read(&zram->init_lock);
+out:
+	return ret;
+}
+
 static const struct block_device_operations zram_devops = {
 	.swap_slot_free_notify = zram_slot_free_notify,
+	.rw_page = zram_rw_page,
 	.owner = THIS_MODULE
 };
 
-- 
1.7.9.5

