Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3BKQ2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:28:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:30819 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764Ab3BKQ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:28:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,643,1355126400"; 
   d="scan'208";a="255483746"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        daniel@vger.kernel.org, inaro-mm-sig@lists.linaro.org
Subject: [PATCH] lib/scatterlist: add simple page iterator
Date: Mon, 11 Feb 2013 18:28:02 +0200
Message-Id: <1360600082-24460-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an iterator to walk through a scatter list a page at a time starting
at a specific page offset. As opposed to the mapping iterator this is
meant to be small, performing well even in simple loops like collecting
all pages on the scatterlist into an array or setting up an iommu table
based on the pages' DMA address.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 include/linux/scatterlist.h |   48 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4bd6c06..d22851c 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -231,6 +231,54 @@ size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
  */
 #define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))
 
+struct sg_page_iter {
+	struct scatterlist *sg;
+	int sg_pgoffset;
+	struct page *page;
+};
+
+static inline int
+sg_page_cnt(struct scatterlist *sg)
+{
+	BUG_ON(sg->offset || sg->length & ~PAGE_MASK);
+
+	return sg->length >> PAGE_SHIFT;
+}
+
+static inline void
+sg_page_iter_next(struct sg_page_iter *iter)
+{
+	while (iter->sg && iter->sg_pgoffset >= sg_page_cnt(iter->sg)) {
+		iter->sg_pgoffset -= sg_page_cnt(iter->sg);
+		iter->sg = sg_next(iter->sg);
+	}
+
+	if (iter->sg) {
+		iter->page = nth_page(sg_page(iter->sg), iter->sg_pgoffset);
+		iter->sg_pgoffset++;
+	}
+}
+
+static inline void
+sg_page_iter_start(struct sg_page_iter *iter, struct scatterlist *sglist,
+		   unsigned long pgoffset)
+{
+	iter->sg = sglist;
+	iter->sg_pgoffset = pgoffset;
+	iter->page = NULL;
+
+	sg_page_iter_next(iter);
+}
+
+/*
+ * Simple sg page iterator, starting off at the given page offset. Each entry
+ * on the sglist must start at offset 0 and can contain only full pages.
+ * iter->page will point to the current page, iter->sg_pgoffset to the page
+ * offset within the sg holding that page.
+ */
+#define for_each_sg_page(sglist, iter, pgoffset)				\
+	for (sg_page_iter_start((iter), (sglist), (pgoffset));		\
+	     (iter)->sg; sg_page_iter_next(iter))
 
 /*
  * Mapping sg iterator
-- 
1.7.9.5

