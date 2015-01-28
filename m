Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895AbbA1CXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:23:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21612 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbbA1CX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:23:28 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v3 3/3] mm: cma: release trigger
Date: Tue, 27 Jan 2015 21:22:57 -0500
Message-Id: <1422411777-22332-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422411777-22332-1-git-send-email-sasha.levin@oracle.com>
References: <1422411777-22332-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
index 5bd6863..c29f029 100644
--- a/mm/cma_debug.c
+++ b/mm/cma_debug.c
@@ -39,6 +39,59 @@ static void cma_add_to_cma_mem_list(struct cma *cma, struct cma_mem *mem)
 	spin_unlock(&cma->mem_head_lock);
 }
 
+static struct cma_mem *cma_get_entry_from_list(struct cma *cma)
+{
+	struct cma_mem *mem = NULL;
+
+	spin_lock(&cma->mem_head_lock);
+	if (!hlist_empty(&cma->mem_head)) {
+		mem = hlist_entry(cma->mem_head.first, struct cma_mem, node);
+		hlist_del_init(&mem->node);
+	}
+	spin_unlock(&cma->mem_head_lock);
+
+	return mem;
+}
+
+static int cma_free_mem(struct cma *cma, int count)
+{
+	struct cma_mem *mem = NULL;
+
+	while (count) {
+		mem = cma_get_entry_from_list(cma);
+		if (mem == NULL)
+			return 0;
+
+		if (mem->n <= count) {
+			cma_release(cma, mem->p, mem->n);
+			count -= mem->n;
+			kfree(mem);
+		} else if (cma->order_per_bit == 0) {
+			cma_release(cma, mem->p, count);
+			mem->p += count;
+			mem->n -= count;
+			count = 0;
+			cma_add_to_cma_mem_list(cma, mem);
+		} else {
+			cma_add_to_cma_mem_list(cma, mem);
+			break;
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
+	struct cma *cma = data;
+
+        return cma_free_mem(cma, pages);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_free_fops, NULL, cma_free_write, "%llu\n");
+
 static int cma_alloc_mem(struct cma *cma, int count)
 {
 	struct cma_mem *mem;
@@ -85,6 +138,9 @@ static void cma_debugfs_add_one(struct cma *cma, int idx)
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

