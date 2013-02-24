Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3BXLF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 06:05:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:64234 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab3BXLFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 06:05:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,727,1355126400"; 
   d="scan'208";a="291112686"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH v5] lib/scatterlist: use page iterator in the mapping iterator
Date: Sun, 24 Feb 2013 13:05:37 +0200
Message-Id: <1361703937-1212-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361455080-23667-1-git-send-email-imre.deak@intel.com>
References: <1361455080-23667-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better code reuse use the newly added page iterator to iterate through
the pages.  The offset, length within the page is still calculated by the
mapping iterator as well as the actual mapping.  Idea from Tejun Heo.

v1-v3:
- original version

v4:
- The dw_mmc driver used sg_mapping_iter::__sg, which was marked as internal
  and moved by this patch to the new sg_page_iter struct. This caused a
  compile time breakage for the driver. Fix this by making
  sg_mapping_iter::piter a public interface and making the driver use
  sg_mapping_iter::piter.sg instead of sg_mapping_iter::__sg.
  Thanks to James Hogan for pointing this out.

v5:
- Fix the mapping size to be page-size limited. Thanks to Stephen Warren
  for tracking down the bug.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/mmc/host/dw_mmc.c   |    4 ++--
 include/linux/scatterlist.h |    6 +++---
 lib/scatterlist.c           |   48 +++++++++++++++++++++----------------------
 3 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 323c502..6b89fde 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1445,7 +1445,7 @@ static void dw_mci_read_data_pio(struct dw_mci *host)
 		if (!sg_miter_next(sg_miter))
 			goto done;
 
-		host->sg = sg_miter->__sg;
+		host->sg = sg_miter->piter.sg;
 		buf = sg_miter->addr;
 		remain = sg_miter->length;
 		offset = 0;
@@ -1500,7 +1500,7 @@ static void dw_mci_write_data_pio(struct dw_mci *host)
 		if (!sg_miter_next(sg_miter))
 			goto done;
 
-		host->sg = sg_miter->__sg;
+		host->sg = sg_miter->piter.sg;
 		buf = sg_miter->addr;
 		remain = sg_miter->length;
 		offset = 0;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 788a853..2d8bdae 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -293,11 +293,11 @@ struct sg_mapping_iter {
 	void			*addr;		/* pointer to the mapped area */
 	size_t			length;		/* length of the mapped area */
 	size_t			consumed;	/* number of consumed bytes */
+	struct sg_page_iter	piter;		/* page iterator */
 
 	/* these are internal states, keep away */
-	struct scatterlist	*__sg;		/* current entry */
-	unsigned int		__nents;	/* nr of remaining entries */
-	unsigned int		__offset;	/* offset within sg */
+	unsigned int		__offset;	/* offset within page */
+	unsigned int		__remaining;	/* remaining bytes on page */
 	unsigned int		__flags;
 };
 
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a1d1564..b83c144 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -449,9 +449,7 @@ void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
 {
 	memset(miter, 0, sizeof(struct sg_mapping_iter));
 
-	miter->__sg = sgl;
-	miter->__nents = nents;
-	miter->__offset = 0;
+	__sg_page_iter_start(&miter->piter, sgl, nents, 0);
 	WARN_ON(!(flags & (SG_MITER_TO_SG | SG_MITER_FROM_SG)));
 	miter->__flags = flags;
 }
@@ -476,36 +474,35 @@ EXPORT_SYMBOL(sg_miter_start);
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
+		if (!__sg_page_iter_next(&miter->piter))
 			return false;
-	}
 
-	/* map the next page */
-	off = miter->__sg->offset + miter->__offset;
-	len = miter->__sg->length - miter->__offset;
+		sg = miter->piter.sg;
+		pgoffset = miter->piter.sg_pgoffset;
 
-	miter->page = nth_page(sg_page(miter->__sg), off >> PAGE_SHIFT);
-	off &= ~PAGE_MASK;
-	miter->length = min_t(unsigned int, len, PAGE_SIZE - off);
-	miter->consumed = miter->length;
+		miter->__offset = pgoffset ? 0 : sg->offset;
+		miter->__remaining = sg->offset + sg->length -
+				(pgoffset << PAGE_SHIFT) - miter->__offset;
+		miter->__remaining = min_t(unsigned long, miter->__remaining,
+					   PAGE_SIZE - miter->__offset);
+	}
+	miter->page = miter->piter.page;
+	miter->consumed = miter->length = miter->__remaining;
 
 	if (miter->__flags & SG_MITER_ATOMIC)
-		miter->addr = kmap_atomic(miter->page) + off;
+		miter->addr = kmap_atomic(miter->page) + miter->__offset;
 	else
-		miter->addr = kmap(miter->page) + off;
+		miter->addr = kmap(miter->page) + miter->__offset;
 
 	return true;
 }
@@ -532,6 +529,7 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 	/* drop resources from the last iteration */
 	if (miter->addr) {
 		miter->__offset += miter->consumed;
+		miter->__remaining -= miter->consumed;
 
 		if (miter->__flags & SG_MITER_TO_SG)
 			flush_kernel_dcache_page(miter->page);
-- 
1.7.10.4

