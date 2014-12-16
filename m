Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaLPM5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:57:42 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8287 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaLPM5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:57:40 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0e-54902c429c25
From: Dmitry Safonov <d.safonov@partner.samsung.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        James Bottomley <JBottomley@parallels.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dyasly Sergey <s.dyasly@samsung.com>
Subject: [RFC PATCH] mm: vmalloc: remove ioremap align constraint
Date: Tue, 16 Dec 2014 15:57:11 +0300
Message-id: <1418734631-7933-1-git-send-email-d.safonov@partner.samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e/4ZV0nnQkhBg+XClvMWb+GzeLTyqds
	FgdvfGO3uNS7hNVi0+NrrBaXd81hs7i35j+rxe3LvBafnv1jt5g8W8ri5ccTLA7cHmvmrWH0
	aGnuYfPY9GkSu8eda3vYPE7M+M3isXlJvcfjvZYeJ+f9ZPM4+G4Pk0ffllWMHp83yQVwR3HZ
	pKTmZJalFunbJXBlNC67yFrwUKriw+9PzA2ML0S7GDk4JARMJJY+0+xi5AQyxSQu3FvP1sXI
	xSEksJRRordlJyuE08ckseDbUhaQBjaghpc/EkEaRIAaPp65zAxiMwtMYZboeZIAYgsLOErM
	XPaFEcRmEVCVaFz/mw2klVfAR2LaCj6IXXISJ49NZp3AyL2AkWEVo2hqaXJBcVJ6rqFecWJu
	cWleul5yfu4mRkjwfdnBuPiY1SFGAQ5GJR7egt7+ECHWxLLiytxDjBIczEoivEHKE0KEeFMS
	K6tSi/Lji0pzUosPMTJxcEo1ME4Q5WTofhNgZx2rFjCBtUv8nIXAoybu1ODX+ziU3W33/tw8
	e5dL4EqztDXzf77dk1e0hH+6e4WF0PL2lYy1D1fbcademDF58YxeUb8TM6eLnj/WJM3XU+2X
	If3mxoe5zUpv/zf136nd2z/5eh2P4W2uig2fNx1vDL7I4PbIw2npn3T/Qs3ok0osxRmJhlrM
	RcWJAHstSigcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap uses __get_vm_area_node which sets alignment to fls of requested size.
I couldn't find any reason for such big align. Does it decrease TLB misses?
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

