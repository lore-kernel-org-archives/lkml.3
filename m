Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbbATRjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:39:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26152 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbbATRjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:39:00 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 3/3] mm: cma: release trigger
Date: Tue, 20 Jan 2015 12:38:33 -0500
Message-Id: <1421775513-4460-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421775513-4460-1-git-send-email-sasha.levin@oracle.com>
References: <1421775513-4460-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides a userspace interface to trigger a CMA release.

Usage:

	echo [pages] > free

This would provide testing/fuzzing access to the CMA release paths.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/cma_debug.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/mm/cma_debug.c b/mm/cma_debug.c
index eda0a41..7bb1da1 100644
--- a/mm/cma_debug.c
+++ b/mm/cma_debug.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/dma-contiguous.h>
 #include <linux/slab.h>
+#include <linux/mm_types.h>
 
 #include "cma.h"
 
@@ -64,6 +65,59 @@ static void cma_add_to_cma_mem_list(struct cma_mem *mem)
 	spin_unlock(&cma_mem_head_lock);
 }
 
+static struct cma_mem *cma_get_entry_from_list(void)
+{
+	struct cma_mem *mem = NULL;
+
+	spin_lock(&cma_mem_head_lock);
+	if (!hlist_empty(&cma_mem_head)) {
+		mem = hlist_entry(cma_mem_head.first, struct cma_mem, node);
+		hlist_del_init(&mem->node);
+	}
+	spin_unlock(&cma_mem_head_lock);
+
+	return mem;
+}
+
+static int cma_free_mem(int count)
+{
+	struct cma_mem *mem = NULL;
+
+	while (count) {
+		mem = cma_get_entry_from_list();
+		if (mem == NULL)
+			return 0;
+
+		if (mem->n <= count) {
+			cma_release(dma_contiguous_default_area, mem->p, mem->n);
+			pr_info("CMA: Freeing %lu pages from %p.\n",
+					mem->n, mem->p);
+			count -= mem->n;
+			kfree(mem);
+		} else {
+			cma_release(dma_contiguous_default_area, mem->p, count);
+			pr_info("CMA: Freeing %d pages from %p.\n",
+					count, mem->p);
+			mem->p += count;
+			mem->n -= count;
+			count = 0;
+			cma_add_to_cma_mem_list(mem);
+		}
+	}
+
+	return 0;
+			
+}
+
+static int cma_free_write(void *data, u64 val)
+{
+        int pages = val;
+
+        return cma_free_mem(pages);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_free_fops, NULL, cma_free_write, "%llu\n");
+
 static int cma_alloc_mem(int count)
 {
 	struct cma_mem *mem;
@@ -109,6 +163,8 @@ static int __init cma_debugfs_init(void)
 
 	debugfs_create_file("alloc", S_IWUSR, cma_debugfs_root, NULL,
 				&cma_alloc_fops);
+	debugfs_create_file("free", S_IWUSR, cma_debugfs_root, NULL,
+				&cma_free_fops);
 
 	for (i = 0; i < cma_area_count; i++)
 		cma_debugfs_add_one(&cma_areas[i], i);
-- 
1.7.10.4

