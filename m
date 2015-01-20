Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbbATRkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:40:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26107 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbATRi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:38:56 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 1/3] mm: cma: debugfs interface
Date: Tue, 20 Jan 2015 12:38:31 -0500
Message-Id: <1421775513-4460-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421775513-4460-1-git-send-email-sasha.levin@oracle.com>
References: <1421775513-4460-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a simple debugfs interface to expose information about CMA areas
in the system.

Useful for testing/sanity checks for CMA since it was impossible to previously
retrieve this information in userspace.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/Kconfig     |    6 ++++++
 mm/Makefile    |    1 +
 mm/cma.c       |   19 ++++--------------
 mm/cma.h       |   20 +++++++++++++++++++
 mm/cma_debug.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 92 insertions(+), 15 deletions(-)
 create mode 100644 mm/cma.h
 create mode 100644 mm/cma_debug.c

diff --git a/mm/Kconfig b/mm/Kconfig
index a03131b..390214d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -517,6 +517,12 @@ config CMA_DEBUG
 	  processing calls such as dma_alloc_from_contiguous().
 	  This option does not affect warning and error messages.
 
+config CMA_DEBUGFS
+	bool "CMA debugfs interface"
+	depends on CMA && DEBUG_FS
+	help
+	  Turns on the DebugFS interface for CMA.
+
 config CMA_AREAS
 	int "Maximum count of the CMA areas"
 	depends on CMA
diff --git a/mm/Makefile b/mm/Makefile
index 3548460..9ec12b4 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -73,3 +73,4 @@ obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
 obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
+obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
diff --git a/mm/cma.c b/mm/cma.c
index a85ae28..6a0b248 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -35,16 +35,10 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 
-struct cma {
-	unsigned long	base_pfn;
-	unsigned long	count;
-	unsigned long	*bitmap;
-	unsigned int order_per_bit; /* Order of pages represented by one bit */
-	struct mutex	lock;
-};
-
-static struct cma cma_areas[MAX_CMA_AREAS];
-static unsigned cma_area_count;
+#include "cma.h"
+
+struct cma cma_areas[MAX_CMA_AREAS];
+unsigned cma_area_count;
 static DEFINE_MUTEX(cma_mutex);
 
 phys_addr_t cma_get_base(struct cma *cma)
@@ -75,11 +69,6 @@ static unsigned long cma_bitmap_aligned_offset(struct cma *cma, int align_order)
 		(cma->base_pfn >> cma->order_per_bit);
 }
 
-static unsigned long cma_bitmap_maxno(struct cma *cma)
-{
-	return cma->count >> cma->order_per_bit;
-}
-
 static unsigned long cma_bitmap_pages_to_bits(struct cma *cma,
 						unsigned long pages)
 {
diff --git a/mm/cma.h b/mm/cma.h
new file mode 100644
index 0000000..4141887
--- /dev/null
+++ b/mm/cma.h
@@ -0,0 +1,20 @@
+#ifndef __MM_CMA_H__
+#define __MM_CMA_H__
+
+struct cma {
+	unsigned long   base_pfn;
+	unsigned long   count;
+	unsigned long   *bitmap;
+	unsigned int order_per_bit; /* Order of pages represented by one bit */
+	struct mutex    lock;
+};
+
+extern struct cma cma_areas[MAX_CMA_AREAS];
+extern unsigned cma_area_count;
+
+static unsigned long cma_bitmap_maxno(struct cma *cma)
+{
+	return cma->count >> cma->order_per_bit;
+}
+
+#endif
diff --git a/mm/cma_debug.c b/mm/cma_debug.c
new file mode 100644
index 0000000..3a25413
--- /dev/null
+++ b/mm/cma_debug.c
@@ -0,0 +1,61 @@
+/*
+ * CMA DebugFS Interface
+ *
+ * Copyright (c) 2015 Sasha Levin <sasha.levin@oracle.com>
+ */
+ 
+
+#include <linux/debugfs.h>
+#include <linux/cma.h>
+
+#include "cma.h"
+
+static struct dentry *cma_debugfs_root;
+
+static int cma_debugfs_get(void *data, u64 *val)
+{
+	unsigned long *p = data;
+
+	*val = *p;
+
+	return 0;
+} 
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_debugfs_fops, cma_debugfs_get, NULL, "%llu\n");
+
+static void cma_debugfs_add_one(struct cma *cma, int idx)
+{
+	struct dentry *tmp;
+	char name[16];
+	int u32s;
+
+	sprintf(name, "cma-%d", idx);
+
+	tmp = debugfs_create_dir(name, cma_debugfs_root);
+
+	debugfs_create_file("base_pfn", S_IRUGO, tmp,
+				&cma->base_pfn, &cma_debugfs_fops);
+	debugfs_create_file("count", S_IRUGO, tmp,
+				&cma->count, &cma_debugfs_fops);
+	debugfs_create_file("order_per_bit", S_IRUGO, tmp,
+			&cma->order_per_bit, &cma_debugfs_fops);
+
+	u32s = DIV_ROUND_UP(cma_bitmap_maxno(cma), BITS_PER_BYTE * sizeof(u32));
+	debugfs_create_u32_array("bitmap", S_IRUGO, tmp, (u32*)cma->bitmap, u32s);
+}
+
+static int __init cma_debugfs_init(void)
+{
+	int i;
+
+	cma_debugfs_root = debugfs_create_dir("cma", NULL);
+	if (!cma_debugfs_root)
+		return -ENOMEM;
+
+	for (i = 0; i < cma_area_count; i++)
+		cma_debugfs_add_one(&cma_areas[i], i);
+
+	return 0;
+}
+late_initcall(cma_debugfs_init);
+
-- 
1.7.10.4

