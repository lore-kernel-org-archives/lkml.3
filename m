Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3FDQIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:08:44 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53255 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab3FDQIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:08:39 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/10] zram: use zram->lock to protect zram_free_page() in swap free notify path
Date: Wed,  5 Jun 2013 00:06:01 +0800
Message-Id: <1370361968-8764-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram_free_page() is protected by down_write(&zram->lock) when called by
zram_bvec_write(), but there's no such protection when called by
zram_slot_free_notify(), which may cause wrong states to zram object.

There are two possible consequences of this issue:
1) It may cause invalid memory access if we read from a zram device used
   as swap device. (Not sure whether it's legal to make read/write
   requests to a zram device used as swap device.)
2) It may cause some fields (bad_compress, good_compress, pages_stored)
   in zram->stats wrong if the swap layer makes concurrently call to
   zram_slot_free_notify().

So enhance zram_slot_free_notify() to acquire writer lock on zram->lock
before calling zram_free_page().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/zram/zram_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 5a2f20b..847d207 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -582,7 +582,9 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	struct zram *zram;
 
 	zram = bdev->bd_disk->private_data;
+	down_write(&zram->lock);
 	zram_free_page(zram, index);
+	up_write(&zram->lock);
 	zram_stat64_inc(zram, &zram->stats.notify_free);
 }
 
-- 
1.8.1.2

