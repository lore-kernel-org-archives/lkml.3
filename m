Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab3K1Q1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:27:44 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53090 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3K1Q1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:27:42 -0500
Date: Fri, 29 Nov 2013 00:29:13 +0800
From: Jianyu Zhan <nasa4836@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        zhangyanfei@cn.fujitsu.com, liwanp@linux.vnet.ibm.com,
        rientjes@google.com, linux-kernel@vger.kernel.org
Subject: [PATCH]mm/vmalloc: interchage the implementation of
 vmalloc_to_{pfn,page}
Message-ID: <20131128162913.GA4234@lcx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are implementing vmalloc_to_pfn() as a wrapper of 
vmalloc_to_page(), which is implemented as follow: 

 1. walks the page talbes to generates the corresponding pfn,
 2. then wraps the pfn to struct page,
 3. returns it.

And vmalloc_to_pfn() re-wraps the vmalloc_to_page() to get the pfn.

This seems too circuitous, so this patch reverses the way:
implementing the vmalloc_to_page() as a wrapper of vmalloc_to_pfn().
This makes vmalloc_to_pfn() and vmalloc_to_page() slightly effective.

No functional change. 

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
mm/vmalloc.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0fdf968..a335e21 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -220,12 +220,12 @@ int is_vmalloc_or_module_addr(const void *x)
 }
 
 /*
- * Walk a vmap address to the struct page it maps.
+ * Walk a vmap address to the physical pfn it maps to.
  */
-struct page *vmalloc_to_page(const void *vmalloc_addr)
+unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
 {
 	unsigned long addr = (unsigned long) vmalloc_addr;
-	struct page *page = NULL;
+	unsigned long pfn;
 	pgd_t *pgd = pgd_offset_k(addr);
 
 	/*
@@ -244,23 +244,23 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
 				ptep = pte_offset_map(pmd, addr);
 				pte = *ptep;
 				if (pte_present(pte))
-					page = pte_page(pte);
+					pfn = pte_page(pte);
 				pte_unmap(ptep);
 			}
 		}
 	}
-	return page;
+	return pfn;
 }
-EXPORT_SYMBOL(vmalloc_to_page);
+EXPORT_SYMBOL(vmalloc_to_pfn);
 
 /*
- * Map a vmalloc()-space virtual address to the physical page frame number.
+ * Map a vmalloc()-space virtual address to the struct page.
  */
-unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
+struct page *vmalloc_to_page(const void *vmalloc_addr)
 {
-	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
+	return pfn_to_page(vmalloc_to_pfn(vmalloc_addr));
 }
-EXPORT_SYMBOL(vmalloc_to_pfn);
+EXPORT_SYMBOL(vmalloc_to_page);
 
 
 /*** Global kva allocator ***/
