Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934149Ab3BMPKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:10:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:49422 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934031Ab3BMPKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:10:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,657,1355126400"; 
   d="scan'208";a="285222032"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH v3 2/2] lib/scatterlist: use page iterator in the mapping iterator
Date: Wed, 13 Feb 2013 17:10:24 +0200
Message-Id: <1360768224-18163-2-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360768224-18163-1-git-send-email-imre.deak@intel.com>
References: <1360768224-18163-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1360608604-3520-1-git-send-email-imre.deak@intel.com>
References: <1360608604-3520-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better code reuse use the newly added page iterator to iterate
through the pages. The offset, length within the page is still
calculated by the mapping iterator as well as the actual mapping.
Idea from Tejun Heo <tj@kernel.org>.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 include/linux/scatterlist.h |    6 +++---
 lib/scatterlist.c           |   46 ++++++++++++++++++++-----------------------
 2 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 788a853..a6cd692 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -295,9 +295,9 @@ struct sg_mapping_iter {
 	size_t			consumed;	/* number of consumed bytes */
 
 	/* these are internal states, keep away */
-	struct scatterlist	*__sg;		/* current entry */
-	unsigned int		__nents;	/* nr of remaining entries */
-	unsigned int		__offset;	/* offset within sg */
+	unsigned int		__offset;	/* offset within page */
+	struct sg_page_iter	__piter;	/* page iterator */
+	unsigned int		__remaining;	/* remaining bytes on page */
 	unsigned int		__flags;
 };
 
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a1d1564..4e4974a 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -449,9 +449,7 @@ void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
 {
 	memset(miter, 0, sizeof(struct sg_mapping_iter));
 
-	miter->__sg = sgl;
-	miter->__nents = nents;
-	miter->__offset = 0;
+	__sg_page_iter_start(&miter->__piter, sgl, nents, 0);
 	WARN_ON(!(flags & (SG_MITER_TO_SG | SG_MITER_FROM_SG)));
 	miter->__flags = flags;
 }
@@ -476,36 +474,33 @@ EXPORT_SYMBOL(sg_miter_start);
  */
 bool sg_miter_next(struct sg_mapping_iter *miter)
 {
-	unsigned int off, len;
-
-	/* check for end and drop resources from the last iteration */
-	if (!miter->__nents)
-		return false;
-
 	sg_miter_stop(miter);
 
-	/* get to the next sg if necessary.  __offset is adjusted by stop */
-	while (miter->__offset == miter->__sg->length) {
-		if (--miter->__nents) {
-			miter->__sg = sg_next(miter->__sg);
-			miter->__offset = 0;
-		} else
+	/*
+	 * Get to the next page if necessary.
+	 * __remaining, __offset is adjusted by sg_miter_stop
+	 */
+	if (!miter->__remaining) {
+		struct scatterlist *sg;
+		unsigned long pgoffset;
+
+		if (!__sg_page_iter_next(&miter->__piter))
 			return false;
-	}
 
-	/* map the next page */
-	off = miter->__sg->offset + miter->__offset;
-	len = miter->__sg->length - miter->__offset;
+		sg = miter->__piter.sg;
+		pgoffset = miter->__piter.sg_pgoffset;
 
-	miter->page = nth_page(sg_page(miter->__sg), off >> PAGE_SHIFT);
-	off &= ~PAGE_MASK;
-	miter->length = min_t(unsigned int, len, PAGE_SIZE - off);
-	miter->consumed = miter->length;
+		miter->__offset = pgoffset ? 0 : sg->offset;
+		miter->__remaining = sg->offset + sg->length -
+				(pgoffset << PAGE_SHIFT) - miter->__offset;
+	}
+	miter->page = miter->__piter.page;
+	miter->consumed = miter->length = miter->__remaining;
 
 	if (miter->__flags & SG_MITER_ATOMIC)
-		miter->addr = kmap_atomic(miter->page) + off;
+		miter->addr = kmap_atomic(miter->page) + miter->__offset;
 	else
-		miter->addr = kmap(miter->page) + off;
+		miter->addr = kmap(miter->page) + miter->__offset;
 
 	return true;
 }
@@ -532,6 +527,7 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 	/* drop resources from the last iteration */
 	if (miter->addr) {
 		miter->__offset += miter->consumed;
+		miter->__remaining -= miter->consumed;
 
 		if (miter->__flags & SG_MITER_TO_SG)
 			flush_kernel_dcache_page(miter->page);
-- 
1.7.10.4

