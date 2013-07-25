Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3GYDeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 23:34:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18438 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab3GYDeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 23:34:21 -0400
X-IronPort-AV: E=Sophos;i="4.89,740,1367942400"; 
   d="scan'208";a="8015090"
Message-ID: <51F09BB9.7030906@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 11:30:01 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] f2fs: move bio_private allocation out of f2fs_bio_alloc()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 11:31:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 11:31:42,
	Serialize complete at 2013/07/25 11:31:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio->bi_private is not always needed. As in the reading data path,
end_read_io does not need bio_private for further using, so moving
bio_private allocation out of f2fs_bio_alloc(). Alloc it in the
submit_write_page(), and ignore it in the f2fs_readpage().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/data.c    |    1 -
 fs/f2fs/segment.c |   19 +++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c73c394..19cd7c6 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -365,7 +365,6 @@ static void read_end_io(struct bio *bio, int err)
 		}
 		unlock_page(page);
 	} while (bvec >= bio->bi_io_vec);
-	kfree(bio->bi_private);
 	bio_put(bio);
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a86d125..9b74ae2 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -611,18 +611,12 @@ static void f2fs_end_io_write(struct bio *bio, int err)
 struct bio *f2fs_bio_alloc(struct block_device *bdev, int npages)
 {
 	struct bio *bio;
-	struct bio_private *priv;
-retry:
-	priv = kmalloc(sizeof(struct bio_private), GFP_NOFS);
-	if (!priv) {
-		cond_resched();
-		goto retry;
-	}
 
 	/* No failure on bio allocation */
 	bio = bio_alloc(GFP_NOIO, npages);
 	bio->bi_bdev = bdev;
-	bio->bi_private = priv;
+	bio->bi_private = NULL;
+
 	return bio;
 }
 
@@ -681,8 +675,17 @@ static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
 		do_submit_bio(sbi, type, false);
 alloc_new:
 	if (sbi->bio[type] == NULL) {
+		struct bio_private *priv;
+retry:
+		priv = kmalloc(sizeof(struct bio_private), GFP_NOFS);
+		if (!priv) {
+			cond_resched();
+			goto retry;
+		}
+
 		sbi->bio[type] = f2fs_bio_alloc(bdev, max_hw_blocks(sbi));
 		sbi->bio[type]->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+		sbi->bio[type]->bi_private = priv;
 		/*
 		 * The end_io will be assigned at the sumbission phase.
 		 * Until then, let bio_add_page() merge consecutive IOs as much
-- 
1.7.7

