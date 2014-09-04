Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbaIDBia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:38:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42015 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaIDBi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:38:26 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Luigi Semenzato <semenzato@google.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 3/3] zram: add swap_get_free hint
Date: Thu,  4 Sep 2014 10:39:46 +0900
Message-Id: <1409794786-10951-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409794786-10951-1-git-send-email-minchan@kernel.org>
References: <1409794786-10951-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement SWAP_GET_FREE handler in zram so that VM can
know how many zram has freeable space.
VM can use it to stop anonymous reclaiming once zram is full.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 88661d62e46a..8e22b20aa2db 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -951,6 +951,22 @@ static int zram_slot_free_notify(struct block_device *bdev,
 	return 0;
 }
 
+static int zram_get_free_pages(struct block_device *bdev, long *free)
+{
+	struct zram *zram;
+	struct zram_meta *meta;
+
+	zram = bdev->bd_disk->private_data;
+	meta = zram->meta;
+
+	if (!zram->limit_pages)
+		return 1;
+
+	*free = zram->limit_pages - zs_get_total_pages(meta->mem_pool);
+
+	return 0;
+}
+
 static int zram_swap_hint(struct block_device *bdev,
 				unsigned int hint, void *arg)
 {
@@ -958,6 +974,8 @@ static int zram_swap_hint(struct block_device *bdev,
 
 	if (hint == SWAP_SLOT_FREE)
 		ret = zram_slot_free_notify(bdev, (unsigned long)arg);
+	else if (hint == SWAP_GET_FREE)
+		ret = zram_get_free_pages(bdev, arg);
 
 	return ret;
 }
-- 
2.0.0

