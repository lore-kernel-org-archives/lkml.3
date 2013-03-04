Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3CDEtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:49:15 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58074 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3CDEtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 23:49:14 -0500
X-AuditID: 9c930197-b7c43ae0000006e1-94-513427c8f481
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] ARM: mm: clean-up in order to reduce to call kmap_high_get()
Date: Mon,  4 Mar 2013 13:50:09 +0900
Message-Id: <1362372609-877-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kmap_atomic(), kmap_high_get() is invoked for checking already
mapped area. In __flush_dcache_page() and dma_cache_maint_page(),
we explicitly call kmap_high_get() before kmap_atomic()
when cache_is_vipt(), so kmap_high_get() can be invoked twice.
This is useless operation, so remove one.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index c7e3759..b7711be 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -822,16 +822,16 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
 		if (PageHighMem(page)) {
 			if (len + offset > PAGE_SIZE)
 				len = PAGE_SIZE - offset;
-			vaddr = kmap_high_get(page);
-			if (vaddr) {
-				vaddr += offset;
-				op(vaddr, len, dir);
-				kunmap_high(page);
-			} else if (cache_is_vipt()) {
-				/* unmapped pages might still be cached */
+			if (cache_is_vipt()) {
 				vaddr = kmap_atomic(page);
 				op(vaddr + offset, len, dir);
 				kunmap_atomic(vaddr);
+			} else {
+				vaddr = kmap_high_get(page);
+				if (vaddr) {
+					op(vaddr + offset, len, dir);
+					kunmap_high(page);
+				}
 			}
 		} else {
 			vaddr = page_address(page) + offset;
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 1c8f7f5..e6a03d0 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -170,15 +170,18 @@ void __flush_dcache_page(struct address_space *mapping, struct page *page)
 	if (!PageHighMem(page)) {
 		__cpuc_flush_dcache_area(page_address(page), PAGE_SIZE);
 	} else {
-		void *addr = kmap_high_get(page);
-		if (addr) {
-			__cpuc_flush_dcache_area(addr, PAGE_SIZE);
-			kunmap_high(page);
-		} else if (cache_is_vipt()) {
-			/* unmapped pages might still be cached */
+		void *addr;
+
+		if (cache_is_vipt()) {
 			addr = kmap_atomic(page);
 			__cpuc_flush_dcache_area(addr, PAGE_SIZE);
 			kunmap_atomic(addr);
+		} else {
+			addr = kmap_high_get(page);
+			if (addr) {
+				__cpuc_flush_dcache_area(addr, PAGE_SIZE);
+				kunmap_high(page);
+			}
 		}
 	}
 
-- 
1.7.9.5

