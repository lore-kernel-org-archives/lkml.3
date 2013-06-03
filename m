Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab3FCPpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:45:01 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:60935 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649Ab3FCPoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:44:55 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 3/8] zram: use zram->lock to protect zram_free_page() in swap free notify path
Date: Mon,  3 Jun 2013 23:42:15 +0800
Message-Id: <1370274140-26420-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram_free_page() is protected by down_write(&zram->lock) when called by
zram_bvec_write(), but there's no such protection when called by
zram_slot_free_notify(), which may cause wrong states to zram object.

So enhance zram_slot_free_notify() to acquire writer lock on zram->lock
before calling zram_free_page().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/staging/zram/zram_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index ee6b67d..0738f6c 100644
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

