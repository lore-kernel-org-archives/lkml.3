Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130Ab3BMPKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:10:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:49422 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934031Ab3BMPKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:10:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,657,1355126400"; 
   d="scan'208";a="262128710"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH v3 1/2] lib/scatterlist: add simple page iterator
Date: Wed, 13 Feb 2013 17:10:23 +0200
Message-Id: <1360768224-18163-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360608604-3520-1-git-send-email-imre.deak@intel.com>
References: <1360608604-3520-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an iterator to walk through a scatter list a page at a time starting
at a specific page offset. As opposed to the mapping iterator this is
meant to be small, performing well even in simple loops like collecting
all pages on the scatterlist into an array or setting up an iommu table
based on the pages' DMA address.

v2:
- sg_pgoffset pointed incorrectly at the next page not the current one.

v3:
- formatting fixes, documentation (Andrew)
- uninline helper functions, as they are too big (Andrew)
- support for terminating the iteration after a maximum number
  sglist->nents entries, needed by the next patch

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 include/linux/scatterlist.h |   35 +++++++++++++++++++++++++++++++++++
 lib/scatterlist.c           |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4bd6c06..788a853 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -231,6 +231,41 @@ size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
  */
 #define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))
 
+/*
+ * sg page iterator
+ *
+ * Iterates over sg entries page-by-page.  On each successful iteration,
+ * @piter->page points to the current page, @piter->sg to the sg holding this
+ * page and @piter->sg_pgoffset to the page's page offset within the sg. The
+ * iteration will stop either when a maximum number of sg entries was reached
+ * or a terminating sg (sg_last(sg) == true) was reached.
+ */
+struct sg_page_iter {
+	struct page		*page;		/* current page */
+	struct scatterlist	*sg;		/* sg holding the page */
+	unsigned int		sg_pgoffset;	/* page offset within the sg */
+
+	/* these are internal states, keep away */
+	unsigned int		__nents;	/* remaining sg entries */
+	int			__pg_advance;	/* nr pages to advance at the
+						 * next step */
+};
+
+bool __sg_page_iter_next(struct sg_page_iter *piter);
+void __sg_page_iter_start(struct sg_page_iter *piter,
+			  struct scatterlist *sglist, unsigned int nents,
+			  unsigned long pgoffset);
+
+/**
+ * for_each_sg_page - iterate over the pages of the given sg list
+ * @sglist:	sglist to iterate over
+ * @piter:	page iterator to hold current page, sg, sg_pgoffset
+ * @nents:	maximum number of sg entries to iterate over
+ * @pgoffset:	starting page offset
+ */
+#define for_each_sg_page(sglist, piter, nents, pgoffset)		   \
+	for (__sg_page_iter_start((piter), (sglist), (nents), (pgoffset)); \
+	     __sg_page_iter_next(piter);)
 
 /*
  * Mapping sg iterator
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 7874b01..a1d1564 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -394,6 +394,44 @@ int sg_alloc_table_from_pages(struct sg_table *sgt,
 }
 EXPORT_SYMBOL(sg_alloc_table_from_pages);
 
+void __sg_page_iter_start(struct sg_page_iter *piter,
+			  struct scatterlist *sglist, unsigned int nents,
+			  unsigned long pgoffset)
+{
+	piter->__pg_advance = 0;
+	piter->__nents = nents;
+
+	piter->page = NULL;
+	piter->sg = sglist;
+	piter->sg_pgoffset = pgoffset;
+}
+EXPORT_SYMBOL(__sg_page_iter_start);
+
+static int sg_page_count(struct scatterlist *sg)
+{
+	return PAGE_ALIGN(sg->offset + sg->length) >> PAGE_SHIFT;
+}
+
+bool __sg_page_iter_next(struct sg_page_iter *piter)
+{
+	if (!piter->__nents || !piter->sg)
+		return false;
+
+	piter->sg_pgoffset += piter->__pg_advance;
+	piter->__pg_advance = 1;
+
+	while (piter->sg_pgoffset >= sg_page_count(piter->sg)) {
+		piter->sg_pgoffset -= sg_page_count(piter->sg);
+		piter->sg = sg_next(piter->sg);
+		if (!--piter->__nents || !piter->sg)
+			return false;
+	}
+	piter->page = nth_page(sg_page(piter->sg), piter->sg_pgoffset);
+
+	return true;
+}
+EXPORT_SYMBOL(__sg_page_iter_next);
+
 /**
  * sg_miter_start - start mapping iteration over a sg list
  * @miter: sg mapping iter to be started
-- 
1.7.10.4

