Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaLQWKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:10:32 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47528 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaLQWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:10:30 -0500
From: Gregory Fong <gregory.0xf0@gmail.com>
To: linux-mm@kvack.org
Cc: Gregory Fong <gregory.0xf0@gmail.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH] mm: cma: add functions for getting allocation info
Date: Wed, 17 Dec 2014 14:10:30 -0800
Message-Id: <1418854236-25140-1-git-send-email-gregory.0xf0@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions allow for retrieval of information on what is allocated from
within a given CMA region.  It can be useful to know the number of distinct
contiguous allocations and where in the region those allocations are located.

Based on an initial version by Marc Carino <marc.ceeeee@gmail.com> in a driver
that used the CMA bitmap directly; this instead moves the logic into the core
CMA API.

Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
---
This has been really useful for us to determine allocation information for a
CMA region.  We have had a separate driver that might not be appropriate for
upstream, but allowed using a user program to run CMA unit tests to verify that
allocations end up where they we would expect.  This addition would allow for
that without needing to expose the CMA bitmap.  Wanted to put this out there to
see if anyone else would be interested, comments and suggestions welcome.

 include/linux/cma.h |  3 ++
 mm/cma.c            | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index a93438b..bc676e5 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -25,6 +25,9 @@ extern int __init cma_declare_contiguous(phys_addr_t base,
 extern int cma_init_reserved_mem(phys_addr_t base,
 					phys_addr_t size, int order_per_bit,
 					struct cma **res_cma);
+extern int cma_get_alloc_info(struct cma *cma, int index, phys_addr_t *base,
+		phys_addr_t *size);
 extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
+extern int cma_get_alloc_count(struct cma *cma);
 extern bool cma_release(struct cma *cma, struct page *pages, int count);
 #endif
diff --git a/mm/cma.c b/mm/cma.c
index f891762..fc9a04a 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -447,3 +447,94 @@ bool cma_release(struct cma *cma, struct page *pages, int count)
 
 	return true;
 }
+
+enum cma_scan_type {
+	GET_NUM_ALLOCS,
+	GET_ALLOC_INFO,
+};
+
+struct cma_scan_bitmap_res {
+	int index;             /* index of allocation (input) */
+	unsigned long offset;  /* offset into bitmap */
+	unsigned long size;    /* size in bits */
+	int num_allocs;        /* number of allocations */
+};
+
+static int cma_scan_bitmap(struct cma *cma, enum cma_scan_type op,
+		struct cma_scan_bitmap_res *res)
+{
+	unsigned long i = 0, pos_head = 0, pos_tail;
+	int count = 0, head_found = 0;
+
+	if (!cma)
+		return -EFAULT;
+
+	/* Count the number of contiguous chunks */
+	do {
+		if (head_found) {
+			pos_tail = find_next_zero_bit(cma->bitmap, cma->count,
+						      i);
+
+			if (op == GET_ALLOC_INFO && count == res->index) {
+				res->offset = pos_head;
+				res->size = pos_tail - pos_head;
+				return 0;
+			}
+			count++;
+
+			head_found = 0;
+			i = pos_tail + 1;
+
+		} else {
+			pos_head = find_next_bit(cma->bitmap, cma->count, i);
+			i = pos_head + 1;
+			head_found = 1;
+		}
+	} while (i < cma->count);
+
+	if (op == GET_NUM_ALLOCS) {
+		res->num_allocs = count;
+		return 0;
+	} else {
+		return -EINVAL;
+	}
+}
+
+/**
+ * cma_get_alloc_info() - Get info on the requested allocation
+ * @cma:   Contiguous memory region for which the allocation is performed.
+ * @index: Index of the allocation to get info for
+ * @base:  Base address of the allocation
+ * @size:  Size of the allocation in bytes
+ *
+ * Return: 0 on success, negative on failure
+ */
+int cma_get_alloc_info(struct cma *cma, int index, phys_addr_t *base,
+		phys_addr_t *size)
+{
+	struct cma_scan_bitmap_res res;
+	int ret;
+
+	res.index = index;
+	ret = cma_scan_bitmap(cma, GET_ALLOC_INFO, &res);
+	if (ret)
+		return ret;
+
+	*base = cma_get_base(cma) + PFN_PHYS(res.offset << cma->order_per_bit);
+	*size = PFN_PHYS(res.size << cma->order_per_bit);
+	return 0;
+}
+
+/**
+ * cma_get_alloc_count() - Get number of allocations
+ * @cma:   Contiguous memory region for which the allocation is performed.
+ *
+ * Return: number of allocations on success, negative on failure
+ */
+int cma_get_alloc_count(struct cma *cma)
+{
+	struct cma_scan_bitmap_res res;
+	int ret = cma_scan_bitmap(cma, GET_NUM_ALLOCS, &res);
+
+	return (ret < 0) ? ret : res.num_allocs;
+}
-- 
1.9.1

