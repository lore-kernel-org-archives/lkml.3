Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaJUH2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 03:28:23 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:51682 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbaJUH1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:27:49 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: karam.lee@lge.com
From: karam.lee@lge.com
To: minchan@kernel.org, ngupta@vflare.org, linux-kernel@vger.kernel.org
Cc: matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com,
        "karam.lee" <karam.lee@lge.com>
Subject: [PATCH v3 3/3] zram: implement rw_page operation of zram
Date: Tue, 21 Oct 2014 16:27:37 +0900
Message-Id: <1413876458-19279-4-git-send-email-karam.lee@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413876458-19279-1-git-send-email-karam.lee@lge.com>
References: <1413876458-19279-1-git-send-email-karam.lee@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "karam.lee" <karam.lee@lge.com>

This patch implements rw_page operation for zram block device.

I implemented the feature in zram and tested it.
Test bed was the G2, LG electronic mobile device, whtich has msm8974
processor and 2GB memory.
With a memory allocation test program consuming memory, the system
generates swap.
And operating time of swap_write_page() was measured.

--------------------------------------------------
|             |   operating time   | improvement |
|             |  (20 runs average) |             |
--------------------------------------------------
|with patch   |    1061.15 us      |    +2.4%    |
--------------------------------------------------
|without patch|    1087.35 us      |             |
--------------------------------------------------

Each test(with paged_io,with BIO) result set shows normal distribution
and has equal variance.
I mean the two values are valid result to compare.
I can say operation with paged I/O(without BIO) is faster 2.4% with
confidence level 95%.

Signed-off-by: karam.lee <karam.lee@lge.com>
---
 drivers/block/zram/zram_drv.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 4565fdc..696f0b5 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -810,8 +810,46 @@ static void zram_slot_free_notify(struct block_device *bdev,
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
+		ret = -EINVAL;
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
+
+out_unlock:
+	up_read(&zram->init_lock);
+out:
+	page_endio(page, rw, ret);
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

