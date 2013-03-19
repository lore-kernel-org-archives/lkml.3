Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3CSFBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:01:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43450 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3CSFBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:01:17 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-0e-5147f11b73bc
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2] ARM: mm: clean-up in order to reduce to call kmap_high_get()
Date: Tue, 19 Mar 2013 14:01:27 +0900
Message-Id: <1363669287-9049-1-git-send-email-iamjoonsoo.kim@lge.com>
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

v2: change cache_is_vipt() to cache_is_vipt_nonaliasing() in order to
be self-documented

Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
Hello Nicolas.
I maintain your 'Acked-by' while updating this patch to v2.
Please let me know if there is problem.

Thanks.

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index e9db6b4..ef3e0f3 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -823,16 +823,17 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
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
+
+			if (cache_is_vipt_nonaliasing()) {
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
index 1c8f7f5..0d473cc 100644
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
+		if (cache_is_vipt_nonaliasing()) {
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

