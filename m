Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbaICKKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:10:23 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57372 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756216AbaICJ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.12 09/56] bio-integrity: add "bip_max_vcnt" into struct bio_integrity_payload
Date: Wed,  3 Sep 2014 11:26:28 +0200
Message-Id: <c27a4fe151abf351665639eef0ee2fef7e6fb4f9.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cbcd1054a1fd2aa980fc11ff28e436fc4aaa2d54 upstream.

Commit 08778795 ("block: Fix nr_vecs for inline integrity vectors") from
Martin introduces the function bip_integrity_vecs(get the useful vectors)
to fix the issue about nr_vecs for inline integrity vectors that reported
by David Milburn.

But it seems that bip_integrity_vecs() will return the wrong number if the
bio is not based on any bio_set for some reason(bio->bi_pool == NULL),
because in that case, the bip_inline_vecs[0] is malloced directly.  So
here we add the bip_max_vcnt to record the count of vector slots, and
cleanup the function bip_integrity_vecs().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
---
 fs/bio-integrity.c  | 12 +++---------
 include/linux/bio.h |  1 +
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 76273c1d26a6..04a43c011a66 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -70,8 +70,10 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 					  bs->bvec_integrity_pool);
 		if (!bip->bip_vec)
 			goto err;
+		bip->bip_max_vcnt = bvec_nr_vecs(idx);
 	} else {
 		bip->bip_vec = bip->bip_inline_vecs;
+		bip->bip_max_vcnt = inline_vecs;
 	}
 
 	bip->bip_slab = idx;
@@ -114,14 +116,6 @@ void bio_integrity_free(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_integrity_free);
 
-static inline unsigned int bip_integrity_vecs(struct bio_integrity_payload *bip)
-{
-	if (bip->bip_slab == BIO_POOL_NONE)
-		return BIP_INLINE_VECS;
-
-	return bvec_nr_vecs(bip->bip_slab);
-}
-
 /**
  * bio_integrity_add_page - Attach integrity metadata
  * @bio:	bio to update
@@ -137,7 +131,7 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct bio_vec *iv;
 
-	if (bip->bip_vcnt >= bip_integrity_vecs(bip)) {
+	if (bip->bip_vcnt >= bip->bip_max_vcnt) {
 		printk(KERN_ERR "%s: bip_vec full\n", __func__);
 		return 0;
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ec48bac5b039..6c17ad5cc814 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -187,6 +187,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_slab;	/* slab the bip came from */
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_idx;	/* current bip_vec index */
+	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned		bip_owns_buf:1;	/* should free bip_buf */
 
 	struct work_struct	bip_work;	/* I/O completion */
-- 
2.1.0

