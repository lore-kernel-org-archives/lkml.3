Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaBUKTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:19:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbaBUKT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:19:27 -0500
X-IronPort-AV: E=Sophos;i="4.97,517,1389715200"; 
   d="scan'208";a="9575584"
Message-ID: <53072633.2010106@cn.fujitsu.com>
Date: Fri, 21 Feb 2014 18:10:59 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: Jens <axboe@kernel.dk>, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs/bio-integrity: remove duplicate code
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/21 18:17:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/21 18:17:13,
	Serialize complete at 2014/02/21 18:17:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most code of function bio_integrity_verify and bio_integrity_generate
is the same, so introduce a help function bio_integrity_generate_verify()
to remove the duplicate code.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/bio-integrity.c |   86 ++++++++++++++++++++++-----------------------------
 1 files changed, 37 insertions(+), 49 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 0129b78..413312f 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -301,25 +301,26 @@ int bio_integrity_get_tag(struct bio *bio, void *tag_buf, unsigned int len)
 EXPORT_SYMBOL(bio_integrity_get_tag);
 
 /**
- * bio_integrity_generate - Generate integrity metadata for a bio
- * @bio:	bio to generate integrity metadata for
- *
- * Description: Generates integrity metadata for a bio by calling the
- * block device's generation callback function.  The bio must have a
- * bip attached with enough room to accommodate the generated
- * integrity metadata.
+ * bio_integrity_generate_verify - Generate/verify integrity metadata for a bio
+ * @bio:	bio to generate/verify integrity metadata for
+ * @operate:	operate number, 1 for generate, 0 for verify
  */
-static void bio_integrity_generate(struct bio *bio)
+static int bio_integrity_generate_verify(struct bio *bio, int operate)
 {
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_exchg bix;
 	struct bio_vec bv;
 	struct bvec_iter iter;
-	sector_t sector = bio->bi_iter.bi_sector;
-	unsigned int sectors, total;
+	sector_t sector;
+	unsigned int sectors, total, ret;
 	void *prot_buf = bio->bi_integrity->bip_buf;
 
-	total = 0;
+	if (operate)
+		sector = bio->bi_iter.bi_sector;
+	else
+		sector = bio->bi_integrity->bip_iter.bi_sector;
+
+	total = ret = 0;
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
@@ -330,7 +331,15 @@ static void bio_integrity_generate(struct bio *bio)
 		bix.prot_buf = prot_buf;
 		bix.sector = sector;
 
-		bi->generate_fn(&bix);
+		if (operate) {
+			bi->generate_fn(&bix);
+		} else {
+			ret = bi->verify_fn(&bix);
+			if (ret) {
+				kunmap_atomic(kaddr);
+				return ret;
+			}
+		}
 
 		sectors = bv.bv_len / bi->sector_size;
 		sector += sectors;
@@ -340,6 +349,21 @@ static void bio_integrity_generate(struct bio *bio)
 
 		kunmap_atomic(kaddr);
 	}
+	return ret;
+}
+
+/**
+ * bio_integrity_generate - Generate integrity metadata for a bio
+ * @bio:	bio to generate integrity metadata for
+ *
+ * Description: Generates integrity metadata for a bio by calling the
+ * block device's generation callback function.  The bio must have a
+ * bip attached with enough room to accommodate the generated
+ * integrity metadata.
+ */
+static void bio_integrity_generate(struct bio *bio)
+{
+	bio_integrity_generate_verify(bio, 1);
 }
 
 static inline unsigned short blk_integrity_tuple_size(struct blk_integrity *bi)
@@ -454,43 +478,7 @@ EXPORT_SYMBOL(bio_integrity_prep);
  */
 static int bio_integrity_verify(struct bio *bio)
 {
-	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-	struct blk_integrity_exchg bix;
-	struct bio_vec *bv;
-	sector_t sector = bio->bi_integrity->bip_iter.bi_sector;
-	unsigned int sectors, total, ret;
-	void *prot_buf = bio->bi_integrity->bip_buf;
-	int i;
-
-	ret = total = 0;
-	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
-	bix.sector_size = bi->sector_size;
-
-	bio_for_each_segment_all(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page);
-
-		bix.data_buf = kaddr + bv->bv_offset;
-		bix.data_size = bv->bv_len;
-		bix.prot_buf = prot_buf;
-		bix.sector = sector;
-
-		ret = bi->verify_fn(&bix);
-
-		if (ret) {
-			kunmap_atomic(kaddr);
-			return ret;
-		}
-
-		sectors = bv->bv_len / bi->sector_size;
-		sector += sectors;
-		prot_buf += sectors * bi->tuple_size;
-		total += sectors * bi->tuple_size;
-		BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);
-
-		kunmap_atomic(kaddr);
-	}
-
-	return ret;
+	return bio_integrity_generate_verify(bio, 0);
 }
 
 /**
-- 
1.7.7

