Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934592Ab3IDKnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:43:00 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5261 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934537Ab3IDKm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:42:58 -0400
Message-ID: <52270E5F.4000600@huawei.com>
Date: Wed, 4 Sep 2013 18:41:35 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>, <james.hogan@imgtec.com>,
        <monstr@monstr.eu>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Xishi Qiu <qiuxishi@huawei.com>, <microblaze-uclinux@itee.uq.edu.au>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH 1/2] mm/arch: use __free_reserved_page() to simplify the code
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __free_reserved_page() to simplify the code in arch.

It used split_page() in consistent_alloc()/__dma_alloc_coherent()/dma_alloc_coherent(),
so page->_count == 1, and we can free it safely.

__free_reserved_page()
	ClearPageReserved()
	init_page_count()  // it won't change the value
	__free_page()

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 arch/metag/kernel/dma.c           |    4 +---
 arch/microblaze/mm/consistent.c   |    7 ++-----
 arch/powerpc/mm/dma-noncoherent.c |    4 +---
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/metag/kernel/dma.c b/arch/metag/kernel/dma.c
index 8c00ded..db589ad 100644
--- a/arch/metag/kernel/dma.c
+++ b/arch/metag/kernel/dma.c
@@ -305,9 +305,7 @@ void dma_free_coherent(struct device *dev, size_t size,
 
 			if (pfn_valid(pfn)) {
 				struct page *page = pfn_to_page(pfn);
-				ClearPageReserved(page);
-
-				__free_page(page);
+				__free_reserved_page(page);
 				continue;
 			}
 		}
diff --git a/arch/microblaze/mm/consistent.c b/arch/microblaze/mm/consistent.c
index 5226b09..dbbf224 100644
--- a/arch/microblaze/mm/consistent.c
+++ b/arch/microblaze/mm/consistent.c
@@ -176,8 +176,7 @@ void consistent_free(size_t size, void *vaddr)
 	page = virt_to_page(vaddr);
 
 	do {
-		ClearPageReserved(page);
-		__free_page(page);
+		__free_reserved_page(page);
 		page++;
 	} while (size -= PAGE_SIZE);
 #else
@@ -194,9 +193,7 @@ void consistent_free(size_t size, void *vaddr)
 			pte_clear(&init_mm, (unsigned int)vaddr, ptep);
 			if (pfn_valid(pfn)) {
 				page = pfn_to_page(pfn);
-
-				ClearPageReserved(page);
-				__free_page(page);
+				__free_reserved_page(page);
 			}
 		}
 		vaddr += PAGE_SIZE;
diff --git a/arch/powerpc/mm/dma-noncoherent.c b/arch/powerpc/mm/dma-noncoherent.c
index 6747eec..7b6c107 100644
--- a/arch/powerpc/mm/dma-noncoherent.c
+++ b/arch/powerpc/mm/dma-noncoherent.c
@@ -287,9 +287,7 @@ void __dma_free_coherent(size_t size, void *vaddr)
 			pte_clear(&init_mm, addr, ptep);
 			if (pfn_valid(pfn)) {
 				struct page *page = pfn_to_page(pfn);
-
-				ClearPageReserved(page);
-				__free_page(page);
+				__free_reserved_page(page);
 			}
 		}
 		addr += PAGE_SIZE;
-- 
1.7.1



