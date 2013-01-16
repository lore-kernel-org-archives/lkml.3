Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab3APIJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:09:06 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58321 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3APIJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:09:04 -0500
X-AuditID: 9c930197-b7b76ae000000e7d-24-50f6601c1ac2
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, js1304@gmail.com,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RFC PATCH 1/3] staging, zsmalloc: introduce zs_mem_[read/write]
Date: Wed, 16 Jan 2013 17:08:55 +0900
Message-Id: <1358323737-13396-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If object is on boundary of page, zs_map_object() copy content of object
to pre-allocated page and return virtual address of
this pre-allocated page. If user inform zsmalloc of memcpy region,
we can avoid this copy overhead.
This patch implement two API and these get information of memcpy region.
Using this information, we can do memcpy without overhead.

For USE_PGTABLE_MAPPING case, we can avoid flush cache and tlb overhead
via these API.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
These are [RFC] patches, because I don't test and
I don't have test environment, yet. Just compile test done.
If there is positive comment, I will setup test env and check correctness.
These are based on v3.8-rc3.
If rebase is needed, please notify me what tree I should rebase.

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 09a9d35..e3ef5a5 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -1045,6 +1045,118 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
 
+void zs_mem_read(struct zs_pool *pool, unsigned long handle,
+			void *dest, unsigned long src_off, size_t n)
+{
+	struct page *page;
+	unsigned long obj_idx, off;
+
+	unsigned int class_idx;
+	enum fullness_group fg;
+	struct size_class *class;
+	struct page *pages[2];
+	int sizes[2];
+	void *addr;
+
+	BUG_ON(!handle);
+
+	/*
+	 * Because we use per-cpu mapping areas shared among the
+	 * pools/users, we can't allow mapping in interrupt context
+	 * because it can corrupt another users mappings.
+	 */
+	BUG_ON(in_interrupt());
+
+	obj_handle_to_location(handle, &page, &obj_idx);
+	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
+	class = &pool->size_class[class_idx];
+	off = obj_idx_to_offset(page, obj_idx, class->size);
+	off += src_off;
+
+	BUG_ON(class->size < n);
+
+	if (off + n <= PAGE_SIZE) {
+		/* this object is contained entirely within a page */
+		addr = kmap_atomic(page);
+		memcpy(dest, addr + off, n);
+		kunmap_atomic(addr);
+		return;
+	}
+
+	/* this object spans two pages */
+	pages[0] = page;
+	pages[1] = get_next_page(page);
+	BUG_ON(!pages[1]);
+
+	sizes[0] = PAGE_SIZE - off;
+	sizes[1] = n - sizes[0];
+
+	addr = kmap_atomic(pages[0]);
+	memcpy(dest, addr + off, sizes[0]);
+	kunmap_atomic(addr);
+
+	addr = kmap_atomic(pages[1]);
+	memcpy(dest + sizes[0], addr, sizes[1]);
+	kunmap_atomic(addr);
+}
+EXPORT_SYMBOL_GPL(zs_mem_read);
+
+void zs_mem_write(struct zs_pool *pool, unsigned long handle,
+			const void *src, unsigned long dest_off, size_t n)
+{
+	struct page *page;
+	unsigned long obj_idx, off;
+
+	unsigned int class_idx;
+	enum fullness_group fg;
+	struct size_class *class;
+	struct page *pages[2];
+	int sizes[2];
+	void *addr;
+
+	BUG_ON(!handle);
+
+	/*
+	 * Because we use per-cpu mapping areas shared among the
+	 * pools/users, we can't allow mapping in interrupt context
+	 * because it can corrupt another users mappings.
+	 */
+	BUG_ON(in_interrupt());
+
+	obj_handle_to_location(handle, &page, &obj_idx);
+	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
+	class = &pool->size_class[class_idx];
+	off = obj_idx_to_offset(page, obj_idx, class->size);
+	off += dest_off;
+
+	BUG_ON(class->size < n);
+
+	if (off + n <= PAGE_SIZE) {
+		/* this object is contained entirely within a page */
+		addr = kmap_atomic(page);
+		memcpy(addr + off, src, n);
+		kunmap_atomic(addr);
+		return;
+	}
+
+	/* this object spans two pages */
+	pages[0] = page;
+	pages[1] = get_next_page(page);
+	BUG_ON(!pages[1]);
+
+	sizes[0] = PAGE_SIZE - off;
+	sizes[1] = n - sizes[0];
+
+	addr = kmap_atomic(pages[0]);
+	memcpy(addr + off, src, sizes[0]);
+	kunmap_atomic(addr);
+
+	addr = kmap_atomic(pages[1]);
+	memcpy(addr, src + sizes[0], sizes[1]);
+	kunmap_atomic(addr);
+}
+EXPORT_SYMBOL_GPL(zs_mem_write);
+
 u64 zs_get_total_size_bytes(struct zs_pool *pool)
 {
 	int i;
diff --git a/drivers/staging/zsmalloc/zsmalloc.h b/drivers/staging/zsmalloc/zsmalloc.h
index de2e8bf..fb70f00 100644
--- a/drivers/staging/zsmalloc/zsmalloc.h
+++ b/drivers/staging/zsmalloc/zsmalloc.h
@@ -38,6 +38,11 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle,
 			enum zs_mapmode mm);
 void zs_unmap_object(struct zs_pool *pool, unsigned long handle);
 
+void zs_mem_read(struct zs_pool *pool, unsigned long handle,
+			void *dest, unsigned long src_off, size_t n);
+void zs_mem_write(struct zs_pool *pool, unsigned long handle,
+			const void *src, unsigned long dest_off, size_t n);
+
 u64 zs_get_total_size_bytes(struct zs_pool *pool);
 
 #endif
-- 
1.7.9.5

