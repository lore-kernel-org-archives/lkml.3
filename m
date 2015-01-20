Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbbATRjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:39:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26131 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbATRi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:38:58 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 2/3] mm: cma: allocation trigger
Date: Tue, 20 Jan 2015 12:38:32 -0500
Message-Id: <1421775513-4460-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421775513-4460-1-git-send-email-sasha.levin@oracle.com>
References: <1421775513-4460-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides a userspace interface to trigger a CMA allocation.

Usage:

	echo [pages] > alloc

This would provide testing/fuzzing access to the CMA allocation paths.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/cma_debug.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/mm/cma_debug.c b/mm/cma_debug.c
index 3a25413..eda0a41 100644
--- a/mm/cma_debug.c
+++ b/mm/cma_debug.c
@@ -7,9 +7,22 @@
 
 #include <linux/debugfs.h>
 #include <linux/cma.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/dma-contiguous.h>
+#include <linux/slab.h>
 
 #include "cma.h"
 
+struct cma_mem {
+	struct hlist_node node;
+	struct page *p;
+	unsigned long n;
+};
+
+static HLIST_HEAD(cma_mem_head);
+static DEFINE_SPINLOCK(cma_mem_head_lock);
+
 static struct dentry *cma_debugfs_root;
 
 static int cma_debugfs_get(void *data, u64 *val)
@@ -44,6 +57,48 @@ static void cma_debugfs_add_one(struct cma *cma, int idx)
 	debugfs_create_u32_array("bitmap", S_IRUGO, tmp, (u32*)cma->bitmap, u32s);
 }
 
+static void cma_add_to_cma_mem_list(struct cma_mem *mem)
+{
+	spin_lock(&cma_mem_head_lock);
+	hlist_add_head(&mem->node, &cma_mem_head);
+	spin_unlock(&cma_mem_head_lock);
+}
+
+static int cma_alloc_mem(int count)
+{
+	struct cma_mem *mem;
+	struct page *p;
+
+	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+	if (!mem) 
+		return -ENOMEM;
+
+	p = cma_alloc(dma_contiguous_default_area, count, CONFIG_CMA_ALIGNMENT);
+	if (!p) {
+		pr_info("CMA: Allocation failed.\n");
+		kfree(mem);
+		return -ENOMEM;
+	}
+
+	pr_info("CMA: Allocated %d pages at %p\n", count, p);
+
+	mem->p = p;
+	mem->n = count;
+
+	cma_add_to_cma_mem_list(mem);
+
+	return 0;
+}
+
+static int cma_alloc_write(void *data, u64 val)
+{
+	int pages = val;
+
+	return cma_alloc_mem(pages);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_alloc_fops, NULL, cma_alloc_write, "%llu\n");
+
 static int __init cma_debugfs_init(void)
 {
 	int i;
@@ -52,6 +107,9 @@ static int __init cma_debugfs_init(void)
 	if (!cma_debugfs_root)
 		return -ENOMEM;
 
+	debugfs_create_file("alloc", S_IWUSR, cma_debugfs_root, NULL,
+				&cma_alloc_fops);
+
 	for (i = 0; i < cma_area_count; i++)
 		cma_debugfs_add_one(&cma_areas[i], i);
 
-- 
1.7.10.4

