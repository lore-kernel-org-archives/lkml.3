Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbaLWKAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:00:32 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56578 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbaLWKA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:00:27 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-16-54993d395645
From: Dmitry Safonov <d.safonov@partner.samsung.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        James Bottomley <JBottomley@parallels.com>,
        Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dyasly Sergey <s.dyasly@samsung.com>
Subject: [RFC][PATCH RESEND] mm: vmalloc: remove ioremap align constraint
Date: Tue, 23 Dec 2014 13:00:13 +0300
Message-id: <1419328813-2211-1-git-send-email-d.safonov@partner.samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4VV1L25khBgfWiVnMWb+GzWJlj7fF
	p5VP2SwO3vjGbnGpdwmrxabH11gtLu+aw2Zxb81/Vovbl3ktPj37x24xebaUxcuPJ1gceDzW
	zFvD6NHS3MPmsenTJHaPO9f2sHmcmPGbxWPzknqPx3stPU7O+8nmcfDdHiaPvi2rGD0+b5IL
	4I7isklJzcksSy3St0vgyljQ08BecE264mefTQPjCbEuRk4OCQETib5l31kgbDGJC/fWs4HY
	QgJLGSUmfzPuYuQCsvuYJM5v/cHUxcjBwQbU8PJHIkiNCFD9xzOXmUFqmAUOMEu8WfeLESQh
	LOAp0fV7NROIzSKgKnFsyyM2kF5eAR+J9b/SIXbJSZw8Npl1AiP3AkaGVYyiqaXJBcVJ6blG
	esWJucWleel6yfm5mxghQfh1B+PSY1aHGAU4GJV4eC9+mxEixJpYVlyZe4hRgoNZSYT3pfjM
	ECHelMTKqtSi/Pii0pzU4kOMTBycUg2MV47ctyuz7Puw24ybbZbbfw21yA+/Q9X4mW02RS3b
	vvb1xBnHlrayR52vKaoyc9S//55NTzL+6N0m5+2qst//RGt+qQzuWDBz/gaj1ncenf0//I0O
	GV5Ju8rmpFBryb52tXvPj6+s8YubQtub7ISPvWWet2a+kuyLFwv5V2g8kmzSaVFT6GJTYinO
	SDTUYi4qTgQAORzgUyACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap uses __get_vm_area_node which sets alignment to fls of requested size.
I couldn't find any reason for such big align. Does it decrease TLB misses?
I tested it on custom ARM board with 200+ Mb of ioremap and it works.
What am I missing?

Alignment restriction for ioremap region was introduced with the commit:

> Author: James Bottomley <jejb@mulgrave.(none)>
> Date:   Wed Jun 30 11:11:14 2004 -0500
> 
>     Add vmalloc alignment constraints
> 
>     vmalloc is used by ioremap() to get regions for
>     remapping I/O space.  To feed these regions back
>     into a __get_free_pages() type memory allocator,
>     they are expected to have more alignment than
>     get_vm_area() proves.  So add additional alignment
>     constraints for VM_IOREMAP.
> 
>     Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dyasly Sergey <s.dyasly@samsung.com>
Signed-off-by: Dmitry Safonov <d.safonov@partner.samsung.com>
---
 arch/arm/include/asm/memory.h       | 5 -----
 arch/unicore32/include/asm/memory.h | 5 -----
 include/linux/vmalloc.h             | 8 --------
 mm/vmalloc.c                        | 2 --
 4 files changed, 20 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 184def0..b333245 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -78,11 +78,6 @@
  */
 #define XIP_VIRT_ADDR(physaddr)  (MODULES_VADDR + ((physaddr) & 0x000fffff))
 
-/*
- * Allow 16MB-aligned ioremap pages
- */
-#define IOREMAP_MAX_ORDER	24
-
 #else /* CONFIG_MMU */
 
 /*
diff --git a/arch/unicore32/include/asm/memory.h b/arch/unicore32/include/asm/memory.h
index debafc4..ffae189 100644
--- a/arch/unicore32/include/asm/memory.h
+++ b/arch/unicore32/include/asm/memory.h
@@ -46,11 +46,6 @@
 #define MODULES_END		(PAGE_OFFSET)
 
 /*
- * Allow 16MB-aligned ioremap pages
- */
-#define IOREMAP_MAX_ORDER	24
-
-/*
  * Physical vs virtual RAM address space conversion.  These are
  * private definitions which should NOT be used outside memory.h
  * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index b87696f..2f428e8 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -18,14 +18,6 @@ struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
 /* bits [20..32] reserved for arch specific ioremap internals */
 
-/*
- * Maximum alignment for ioremap() regions.
- * Can be overriden by arch-specific value.
- */
-#ifndef IOREMAP_MAX_ORDER
-#define IOREMAP_MAX_ORDER	(7 + PAGE_SHIFT)	/* 128 pages */
-#endif
-
 struct vm_struct {
 	struct vm_struct	*next;
 	void			*addr;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 39c3388..c4f480dd 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1313,8 +1313,6 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 	struct vm_struct *area;
 
 	BUG_ON(in_interrupt());
-	if (flags & VM_IOREMAP)
-		align = 1ul << clamp(fls(size), PAGE_SHIFT, IOREMAP_MAX_ORDER);
 
 	size = PAGE_ALIGN(size);
 	if (unlikely(!size))
-- 
1.9.1

