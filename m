Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3ITIPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:15:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13952 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab3ITIPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:15:52 -0400
X-IronPort-AV: E=Sophos;i="4.90,938,1371052800"; 
   d="scan'208";a="8569624"
Message-ID: <523C030E.3040408@cn.fujitsu.com>
Date: Fri, 20 Sep 2013 16:10:54 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: Jens <axboe@kernel.dk>, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/bio-integrity: remove duplicate code
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/20 16:14:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/20 16:14:15,
	Serialize complete at 2013/09/20 16:14:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most code of function bio_integrity_verify and bio_integrity_generate
is the same, so introduce a common function bio_integrity_generate_verity()
to remove the duplicate code.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/bio-integrity.c |   84 ++++++++++++++++++++++-----------------------------
 1 files changed, 36 insertions(+), 48 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 6025084..f096aec 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -287,24 +287,25 @@ int bio_integrity_get_tag(struct bio *bio, void *tag_buf, unsigned int len)
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
 	struct bio_vec *bv;
-	sector_t sector = bio->bi_sector;
-	unsigned int i, sectors, total;
+	sector_t sector;
+	unsigned int i, sectors, total, ret;
 	void *prot_buf = bio->bi_integrity->bip_buf;
 
-	total = 0;
+	if (operate)
+		sector = bio->bi_sector;
+	else
+		sector = bio->bi_integrity->bip_sector;
+
+	ret = total = 0;
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
@@ -314,8 +315,13 @@ static void bio_integrity_generate(struct bio *bio)
 		bix.data_size = bv->bv_len;
 		bix.prot_buf = prot_buf;
 		bix.sector = sector;
-
-		bi->generate_fn(&bix);
+		if (operate) {
+			bi->generate_fn(&bix);
+		} else {
+			ret = bi->verify_fn(&bix);
+			kunmap_atomic(kaddr);
+			return ret;
+		}
 
 		sectors = bv->bv_len / bi->sector_size;
 		sector += sectors;
@@ -325,6 +331,22 @@ static void bio_integrity_generate(struct bio *bio)
 
 		kunmap_atomic(kaddr);
 	}
+
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
@@ -439,41 +461,7 @@ EXPORT_SYMBOL(bio_integrity_prep);
  */
 static int bio_integrity_verify(struct bio *bio)
 {
-	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-	struct blk_integrity_exchg bix;
-	struct bio_vec *bv;
-	sector_t sector = bio->bi_integrity->bip_sector;
-	unsigned int i, sectors, total, ret;
-	void *prot_buf = bio->bi_integrity->bip_buf;
-
-	ret = total = 0;
-	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
-	bix.sector_size = bi->sector_size;
-
-	bio_for_each_segment(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page);
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
-		BUG_ON(total > bio->bi_integrity->bip_size);
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

