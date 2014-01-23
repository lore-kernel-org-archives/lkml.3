Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaAWR2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:28:04 -0500
Received: from fe01x03-cgp.akado.ru ([77.232.31.164]:52724 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752864AbaAWR2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:28:01 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jan 2014 12:28:01 EST
Date: Thu, 23 Jan 2014 20:27:29 +0400 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac
To: linux-mm@kvack.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "mm/vmalloc: interchage the implementation of
 vmalloc_to_{pfn,page}"
Message-ID: <alpine.LNX.2.00.1401232025400.1392@linmac>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sep 17 00:00:00 2001
From: Vladimir Murzin <murzin.v@gmail.com>
Date: Thu, 23 Jan 2014 14:54:20 +0400
Subject: [PATCH] Revert "mm/vmalloc: interchage the implementation of
 vmalloc_to_{pfn,page}"

This reverts commit ece86e222db48d04bda218a2be70e384518bb08c.

Despite being claimed that patch doesn't introduce any functional
changes in fact it does.

The "no page" path behaves different now. Originally, vmalloc_to_page
might return NULL under some conditions, with new implementation it returns
pfn_to_page(0) which is not the same as NULL.

Simple test shows the difference.

test.c

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>

int __init myi(void)
{
	struct page *p;
	void *v;

	v = vmalloc(PAGE_SIZE);
	/* trigger the "no page" path in vmalloc_to_page*/
	vfree(v);

	p = vmalloc_to_page(v);

	pr_err("expected val = NULL, returned val = %p", p);

	return -EBUSY;
}

void __exit mye(void)
{

}
module_init(myi)
module_exit(mye)

Before interchange:
expected val = NULL, returned val =   (null)

After interchange:
expected val = NULL, returned val = c7ebe000

Signed-off-by: Vladimir Murzin <murzin.v@gmail.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---

I'm a bit surprised to see this patch merged because I've already pointed [1]
at difference in behaviour introduced by the patch.

If I've lost the point here or misunderstand the patch or abuse vmalloc_to_*
interface I'd be grateful if someone let me know.

[1] https://lkml.org/lkml/2013/12/1/76

Thanks
Vladimir


 mm/vmalloc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e4f0db2..0fdf968 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -220,12 +220,12 @@ int is_vmalloc_or_module_addr(const void *x)
 }
 
 /*
- * Walk a vmap address to the physical pfn it maps to.
+ * Walk a vmap address to the struct page it maps.
  */
-unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
+struct page *vmalloc_to_page(const void *vmalloc_addr)
 {
 	unsigned long addr = (unsigned long) vmalloc_addr;
-	unsigned long pfn = 0;
+	struct page *page = NULL;
 	pgd_t *pgd = pgd_offset_k(addr);
 
 	/*
@@ -244,23 +244,23 @@ unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
 				ptep = pte_offset_map(pmd, addr);
 				pte = *ptep;
 				if (pte_present(pte))
-					pfn = pte_pfn(pte);
+					page = pte_page(pte);
 				pte_unmap(ptep);
 			}
 		}
 	}
-	return pfn;
+	return page;
 }
-EXPORT_SYMBOL(vmalloc_to_pfn);
+EXPORT_SYMBOL(vmalloc_to_page);
 
 /*
- * Map a vmalloc()-space virtual address to the struct page.
+ * Map a vmalloc()-space virtual address to the physical page frame number.
  */
-struct page *vmalloc_to_page(const void *vmalloc_addr)
+unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
 {
-	return pfn_to_page(vmalloc_to_pfn(vmalloc_addr));
+	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
 }
-EXPORT_SYMBOL(vmalloc_to_page);
+EXPORT_SYMBOL(vmalloc_to_pfn);
 
 
 /*** Global kva allocator ***/
-- 
1.7.10.4

