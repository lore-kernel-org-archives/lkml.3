Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbbAZO0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:26:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34307 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbbAZO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:26:33 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 3/3] mm: cma: release trigger
Date: Mon, 26 Jan 2015 09:26:05 -0500
Message-Id: <1422282365-20015-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422282365-20015-1-git-send-email-sasha.levin@oracle.com>
References: <1422282365-20015-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides a userspace interface to trigger a CMA release.

Usage:

	echo [pages] > free

This would provide testing/fuzzing access to the CMA release paths.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/cma_debug.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/mm/cma_debug.c b/mm/cma_debug.c
index 39c7116..0a63945 100644
--- a/mm/cma_debug.c
+++ b/mm/cma_debug.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/dma-contiguous.h>
 #include <linux/slab.h>
+#include <linux/mm_types.h>
 
 #include "cma.h"
 
@@ -43,6 +44,56 @@ static void cma_add_to_cma_mem_list(struct cma_mem *mem)
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
+static int cma_free_mem(struct cma *cma, int count)
+{
+	struct cma_mem *mem = NULL;
+
+	while (count) {
+		mem = cma_get_entry_from_list();
+		if (mem == NULL)
+			return 0;
+
+		if (mem->n <= count) {
+			cma_release(cma, mem->p, mem->n);
+			count -= mem->n;
+			kfree(mem);
+		} else {
+			cma_release(cma, mem->p, count);
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
+	int pages = val;
+	struct cma *cma = data;
+
+	return cma_free_mem(cma, pages);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_free_fops, NULL, cma_free_write, "%llu\n");
+
 static int cma_alloc_mem(struct cma *cma, int count)
 {
 	struct cma_mem *mem;
@@ -89,6 +140,9 @@ static void cma_debugfs_add_one(struct cma *cma, int idx)
 	debugfs_create_file("alloc", S_IWUSR, cma_debugfs_root, cma,
 				&cma_alloc_fops);
 
+	debugfs_create_file("free", S_IWUSR, cma_debugfs_root, cma,
+				&cma_free_fops);
+
 	debugfs_create_file("base_pfn", S_IRUGO, tmp,
 				&cma->base_pfn, &cma_debugfs_fops);
 	debugfs_create_file("count", S_IRUGO, tmp,
-- 
1.7.10.4

