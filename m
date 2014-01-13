Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaAMLTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:19:32 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40230 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaAMLT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:19:26 -0500
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 3/7] zram: remove unnecessary free
Date: Mon, 13 Jan 2014 20:18:58 +0900
Message-Id: <1389611942-15544-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1389611942-15544-1-git-send-email-minchan@kernel.org>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] introduced pending zram slot free in zram's write path
in case of missing slot free by memory allocation failure in
zram_slot_free_notify but it is not necessary because
we have already freed the slot right before overwriting.

[1] [a0c516cbfc, zram: don't grab mutex in zram_slot_free_noity]

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d87c7e9..ebfddd8 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -441,14 +441,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
-	/*
-	 * zram_slot_free_notify could miss free so that let's
-	 * double check.
-	 */
-	if (unlikely(meta->table[index].handle ||
-			zram_test_flag(meta, index, ZRAM_ZERO)))
-		zram_free_page(zram, index);
-
 	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
 			       meta->compress_workmem);
 
-- 
1.8.4.3

