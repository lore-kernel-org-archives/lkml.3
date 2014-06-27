Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaF0KX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:23:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:4502 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752869AbaF0KXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:23:54 -0400
X-IronPort-AV: E=Sophos;i="5.00,790,1396972800"; 
   d="scan'208";a="32521742"
Message-ID: <53AD4385.8080105@cn.fujitsu.com>
Date: Fri, 27 Jun 2014 18:12:21 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jens <axboe@kernel.dk>
CC: <martin.petersen@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Kent <kmo@daterainc.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH] bio-integrity: add "bip_max_vcnt" into struct bio_integrity_payload
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "08778795"(block: Fix nr_vecs for inline integrity vectors) from
Martin introduces the function bip_integrity_vecs(get the useful vectors)
to fix the issue about nr_vecs for inline integrity vectors that reported
by David Milburn.
But it seems that bip_integrity_vecs() will return the wrong number if
the bio is not based on any bio_set for some reason(bio->bi_pool == NULL),
because in that case, the bip_inline_vecs[0] is malloced directly.
So here we add the bip_max_vcnt to record the count of vector slots, and
cleanup the function bip_integrity_vecs().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 block/bio-integrity.c |   12 +++---------
 include/linux/bio.h   |    1 +
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 9e24106..bc423f7b 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
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
index 5a64576..1946d72 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -299,6 +299,7 @@ struct bio_integrity_payload {
 
 	unsigned short		bip_slab;	/* slab the bip came from */
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
+	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned		bip_owns_buf:1;	/* should free bip_buf */
 
 	struct work_struct	bip_work;	/* I/O completion */
-- 
1.7.7

