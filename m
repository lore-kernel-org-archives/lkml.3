Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaAPNP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:15:57 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:38187 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaAPNPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:15:51 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv3 3/8] zram: remove good and bad compress stats
Date: Thu, 16 Jan 2014 16:12:11 +0300
Message-Id: <1389877936-15543-4-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
In-Reply-To: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove `good' and `bad' compressed sub-requests stats. RW request may
cause a number of RW sub-requests. zram used to account `good' compressed
sub-queries (with compressed size less than 50% of original size), `bad'
compressed sub-queries (with compressed size greater that 75% of original
size), leaving sub-requests with compression size between 50% and 75% of
original size not accounted and not reported. zram already accounts each
sub-request's compression size so we can calculate real device compression
ratio.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 11 -----------
 drivers/block/zram/zram_drv.h |  2 --
 2 files changed, 13 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b0bcb7e..c7c7789 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -293,7 +293,6 @@ static void zram_free_page(struct zram *zram, size_t index)
 {
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle = meta->table[index].handle;
-	u16 size = meta->table[index].size;
 
 	if (unlikely(!handle)) {
 		/*
@@ -307,14 +306,8 @@ static void zram_free_page(struct zram *zram, size_t index)
 		return;
 	}
 
-	if (unlikely(size > max_zpage_size))
-		atomic_dec(&zram->stats.bad_compress);
-
 	zs_free(meta->mem_pool, handle);
 
-	if (size <= PAGE_SIZE / 2)
-		atomic_dec(&zram->stats.good_compress);
-
 	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
 	atomic_dec(&zram->stats.pages_stored);
 
@@ -478,7 +471,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	}
 
 	if (unlikely(clen > max_zpage_size)) {
-		atomic_inc(&zram->stats.bad_compress);
 		clen = PAGE_SIZE;
 		src = NULL;
 		if (is_partial_io(bvec))
@@ -518,9 +510,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_size);
 	atomic_inc(&zram->stats.pages_stored);
-	if (clen <= PAGE_SIZE / 2)
-		atomic_inc(&zram->stats.good_compress);
-
 out:
 	if (locked)
 		mutex_unlock(&meta->buffer_lock);
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index e81e9cd..2f173cb 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -78,8 +78,6 @@ struct zram_stats {
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
 	atomic_t pages_zero;		/* no. of zero filled pages */
 	atomic_t pages_stored;	/* no. of pages currently stored */
-	atomic_t good_compress;	/* % of pages with compression ratio<=50% */
-	atomic_t bad_compress;	/* % of pages with compression ratio>=75% */
 };
 
 struct zram_meta {
-- 
1.8.5.3.493.gb139ac2

