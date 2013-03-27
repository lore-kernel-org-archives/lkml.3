Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3C0Rmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:42:45 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51699 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3C0Rky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:54 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 18/22] block: Kill bio_sector_offset()
Date: Wed, 27 Mar 2013 10:39:48 -0700
Message-Id: <1364405992-28424-19-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was only used my dm, and the last patch removed dm's use of it.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c            | 38 --------------------------------------
 include/linux/bio.h |  1 -
 2 files changed, 39 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 80644cc..4eeddf4 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1765,44 +1765,6 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 }
 EXPORT_SYMBOL(bio_split);
 
-/**
- *      bio_sector_offset - Find hardware sector offset in bio
- *      @bio:           bio to inspect
- *      @index:         bio_vec index
- *      @offset:        offset in bv_page
- *
- *      Return the number of hardware sectors between beginning of bio
- *      and an end point indicated by a bio_vec index and an offset
- *      within that vector's page.
- */
-sector_t bio_sector_offset(struct bio *bio, unsigned short index,
-			   unsigned int offset)
-{
-	unsigned int sector_sz;
-	struct bio_vec *bv;
-	sector_t sectors;
-	int i;
-
-	sector_sz = queue_logical_block_size(bio->bi_bdev->bd_disk->queue);
-	sectors = 0;
-
-	if (index >= bio->bi_iter.bi_idx)
-		index = bio->bi_vcnt - 1;
-
-	bio_for_each_segment_all(bv, bio, i) {
-		if (i == index) {
-			if (offset > bv->bv_offset)
-				sectors += (offset - bv->bv_offset) / sector_sz;
-			break;
-		}
-
-		sectors += bv->bv_len / sector_sz;
-	}
-
-	return sectors;
-}
-EXPORT_SYMBOL(bio_sector_offset);
-
 /*
  * create memory pools for biovec's in a bio_set.
  * use the global biovec slabs created for general use.
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1967b64..80ffe15 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -331,7 +331,6 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
-- 
1.8.1.3

