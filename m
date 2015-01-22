Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbbAVBpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:45:01 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:36803 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbAVBoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:44:54 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 22 Jan 2015 10:45:51 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, josh@joshtriplett.org,
        Kim Phillips <kim.phillips@freescale.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Jens Axboe <axboe@fb.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 2/2] mm: fix undefined reference to `.kernel_map_pages'
 on PPC builds
Message-ID: <20150122014550.GA21444@js1304-P5Q-DELUXE>
References: <20150120140200.aa7ba0eb28d95e456972e178@freescale.com>
 <20150120230150.GA14475@cloud>
 <20150120160738.edfe64806cc8b943beb1dfa0@linux-foundation.org>
 <CAC5umyieZn7ppXkKb45O=C=BF+iv6R_A1Dwfhro=cBJzFeovrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC5umyieZn7ppXkKb45O=C=BF+iv6R_A1Dwfhro=cBJzFeovrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 09:57:59PM +0900, Akinobu Mita wrote:
> 2015-01-21 9:07 GMT+09:00 Andrew Morton <akpm@linux-foundation.org>:
> > On Tue, 20 Jan 2015 15:01:50 -0800 josh@joshtriplett.org wrote:
> >
> >> On Tue, Jan 20, 2015 at 02:02:00PM -0600, Kim Phillips wrote:
> >> > It's possible to configure DEBUG_PAGEALLOC without PAGE_POISONING on
> >> > ppc.  Fix building the generic kernel_map_pages() implementation in
> >> > this case:
> >> >
> >> >   LD      init/built-in.o
> >> > mm/built-in.o: In function `free_pages_prepare':
> >> > mm/page_alloc.c:770: undefined reference to `.kernel_map_pages'
> >> > mm/built-in.o: In function `prep_new_page':
> >> > mm/page_alloc.c:933: undefined reference to `.kernel_map_pages'
> >> > mm/built-in.o: In function `map_pages':
> >> > mm/compaction.c:61: undefined reference to `.kernel_map_pages'
> >> > make: *** [vmlinux] Error 1
> 
> kernel_map_pages() is static inline function since commit 031bc5743f15
> ("mm/debug-pagealloc: make debug-pagealloc boottime configurable").
> 
> But there is old declaration in 'arch/powerpc/include/asm/cacheflush.h'.
> Removing it or changing s/kernel_map_pages/__kernel_map_pages/ in this
> header file or something can fix this problem?
> 
> The architecture which has ARCH_SUPPORTS_DEBUG_PAGEALLOC
> including PPC should not build mm/debug-pagealloc.o

Yes, architecture with ARCH_SUPPORTS_DEBUG_PAGEALLOC should not build
mm/debug-pagealloc.o. I attach the patch to remove old declaration.
I hope it will fix Kim's problem.

-------------->8------------------
>From 7cb9d1ed8a785df152cb8934e187031c8ebd1bb2 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Thu, 22 Jan 2015 10:28:58 +0900
Subject: [PATCH] mm/debug_pagealloc: fix build failure on ppc and some other
 archs

Kim Phillips reported following build failure.

  LD      init/built-in.o
  mm/built-in.o: In function `free_pages_prepare':
  mm/page_alloc.c:770: undefined reference to `.kernel_map_pages'
  mm/built-in.o: In function `prep_new_page':
  mm/page_alloc.c:933: undefined reference to `.kernel_map_pages'
  mm/built-in.o: In function `map_pages':
  mm/compaction.c:61: undefined reference to `.kernel_map_pages'
  make: *** [vmlinux] Error 1

Reason for this problem is that commit 031bc5743f15
("mm/debug-pagealloc: make debug-pagealloc boottime configurable") forgot
to remove old declaration of kernel_map_pages() in some architectures.
This patch removes them to fix build failure.

Reported-by: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 arch/mn10300/include/asm/cacheflush.h  |    7 -------
 arch/powerpc/include/asm/cacheflush.h  |    7 -------
 arch/s390/include/asm/cacheflush.h     |    4 ----
 arch/sparc/include/asm/cacheflush_64.h |    5 -----
 4 files changed, 23 deletions(-)

diff --git a/arch/mn10300/include/asm/cacheflush.h b/arch/mn10300/include/asm/cacheflush.h
index faed902..6d6df83 100644
--- a/arch/mn10300/include/asm/cacheflush.h
+++ b/arch/mn10300/include/asm/cacheflush.h
@@ -159,13 +159,6 @@ extern void flush_icache_range(unsigned long start, unsigned long end);
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
-/*
- * Internal debugging function
- */
-#ifdef CONFIG_DEBUG_PAGEALLOC
-extern void kernel_map_pages(struct page *page, int numpages, int enable);
-#endif
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_CACHEFLUSH_H */
diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
index 5b93122..30b35ff 100644
--- a/arch/powerpc/include/asm/cacheflush.h
+++ b/arch/powerpc/include/asm/cacheflush.h
@@ -60,13 +60,6 @@ extern void flush_dcache_phys_range(unsigned long start, unsigned long stop);
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
-
-
-#ifdef CONFIG_DEBUG_PAGEALLOC
-/* internal debugging function */
-void kernel_map_pages(struct page *page, int numpages, int enable);
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_POWERPC_CACHEFLUSH_H */
diff --git a/arch/s390/include/asm/cacheflush.h b/arch/s390/include/asm/cacheflush.h
index 3e20383..58fae7d 100644
--- a/arch/s390/include/asm/cacheflush.h
+++ b/arch/s390/include/asm/cacheflush.h
@@ -4,10 +4,6 @@
 /* Caches aren't brain-dead on the s390. */
 #include <asm-generic/cacheflush.h>
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-void kernel_map_pages(struct page *page, int numpages, int enable);
-#endif
-
 int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);
diff --git a/arch/sparc/include/asm/cacheflush_64.h b/arch/sparc/include/asm/cacheflush_64.h
index 3896537..68513c4 100644
--- a/arch/sparc/include/asm/cacheflush_64.h
+++ b/arch/sparc/include/asm/cacheflush_64.h
@@ -74,11 +74,6 @@ void flush_ptrace_access(struct vm_area_struct *, struct page *,
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-/* internal debugging function */
-void kernel_map_pages(struct page *page, int numpages, int enable);
-#endif
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _SPARC64_CACHEFLUSH_H */
-- 
1.7.9.5

