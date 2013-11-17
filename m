Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3KQXrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 18:47:22 -0500
Received: from mout.gmx.net ([212.227.17.21]:64157 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab3KQXrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 18:47:12 -0500
Date: Mon, 18 Nov 2013 00:47:07 +0100
From: Helge Deller <deller@gmx.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-parisc@vger.kernel.org
Cc: Helge Deller <deller@gmx.de>, Benjamin LaHaise <bcrl@kvack.org>,
        Simon Baatz <gmbnomis@gmail.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, John David Anglin <dave.anglin@bell.net>
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
Message-ID: <20131117234707.GA25545@p100.box>
References: <20131115220529.GA3160@ls3530.box>
 <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
 <20131116200717.GA18939@schnuecks.de>
 <20131116200959.GA14098@kvack.org>
 <528933BC.50806@gmx.de>
 <1384724973.2050.14.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384724973.2050.14.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:q+WtMtVbtmgmqLh9cYavEELo2eOdL/kRFY1oG3a4z5p2ORyKQI3
 FnEHsGz+V4rjoVkOLp4ltJE0EoE+Esk4G/Q47jSNKbxwJiW7zGzb1btHLXjNeY583Nsg600
 +9fWc6I3z83Qp7QFPmg+ljty8lQ4g6nO9O92xq4NVDSSHPrtEEEPNjuS9c7cDs15Tfj+67Z
 gge1C7hYiH5bZJTIAfqDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* James Bottomley <James.Bottomley@HansenPartnership.com>:
> On Sun, 2013-11-17 at 22:23 +0100, Helge Deller wrote:
> > On 11/16/2013 09:09 PM, Benjamin LaHaise wrote:
> > > On Sat, Nov 16, 2013 at 09:07:18PM +0100, Simon Baatz wrote:
> > >> On Fri, Nov 15, 2013 at 02:42:05PM -0800, James Bottomley wrote:
> > >>> On Fri, 2013-11-15 at 23:05 +0100, Helge Deller wrote:
> > >>>> When a user page mapping is released via kunmap*() functions, the D-cache needs
> > >>>> to be flushed via flush_dcache_page() to avoid D-cache aliasing issues.
> > >>>>
> > >>>> This patch fixes aio on the parisc platform (and probably others).
> > >>>
> > >>> This should be flush_kernel_dcache_page().  flush_dcache_page() is for
> > >>> full coherency but for unmap, we know the page was coherent going in and
> > >>> may have been modified by the kernel, so only the kernel view needs to
> > >>> be sync'd.  Technically, by the kernel API, the flush should be done
> > >>> *before* unmapping.  This would have mattered on parisc until we did
> > >>> flush via tmpalias which means we no-longer care if the mapping for the
> > >>> flush exists or not because we always recreate it via the tmpalias
> > >>> pages.
> > >>
> > >> On ARM, flush_kernel_dcache_page() actually assumes that the page is
> > >> mapped.  It avoids double flushing of highmem pages by not flushing
> > >> in those cases where kunmap_atomic() already takes care of flushing.
> > > 
> > > Helge -- are you going to resubmit a version of this patch that makes the 
> > > recommended change?
> > 
> > Sure, I'll do. May need some time for testing the various machine types though.
> > Maybe in the end you can drop my patch since we might be able to fix it in the 
> > parisc arch code.
> > 
> > @James, Dave: The patch I sent here was not used on the C8000. The C8000 (PA8800)
> > works out of the box (and it uses the flush_kernel_dcache_page() function which
> > is provided by kunmap()). It seems we require the flush_kernel_dcache_page() on
> > the other machines too?
> 
> Well, this is why I think our in-kernel API (not the parisc one) for
> kmap/kunmap is faulty.  I can't see any valid use of kmap/kunmap where
> you don't need to flush. 

Maybe adding a flag to kmap(), e.g. READ_ONLY, WRITE_ONLY or similiar? 

> Either you kmapped for reading, in which case
> you need to flush user space before the kernel access, or you kmapped
> for writing, in which case you need to flush user space just before
> mapping (eliminate any dirty user line) and the kernel cache before
> unmap (so the modification becomes visible in main memory).

That's exactly what Dave told me in a private mail earlier.

Below is a patch to the parisc arch code which is originally from Dave.
I only changed kunmap_parisc() to always call
flush_kernel_dcache_page_addr(addr) - independend if we are on a PA8800/8900
CPU or not - which is what you proposed in your original mail.
And yes, this flush_kernel_dcache_page() fixes the aio problems
on all my machines (32- and 64bit kernels, PA7300LC, PA8700, ...).


>  I could see
> an argument that flushing all the user mappings is expensive so only do
> it if necessary, but I think it looks to be always necessary: even if
> you're writing only, which means purging the lines above the user
> mappings, most hardware will panic (HPMC) if it sees inequivalent
> aliases with clashing dirty lines.



diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index f0e2784..ce6d605 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -43,6 +43,8 @@ static inline void flush_kernel_dcache_page(struct page *page)
 	flush_kernel_dcache_page_addr(page_address(page));
 }
 
+void flush_user_dcache_page(struct page *page);
+
 #define flush_kernel_dcache_range(start,size) \
 	flush_kernel_dcache_range_asm((start), (start)+(size));
 /* vmap range flushes and invalidates.  Architecturally, we don't need
@@ -125,18 +127,27 @@ flush_anon_page(struct vm_area_struct *vma, struct page *page, unsigned long vma
 void mark_rodata_ro(void);
 #endif
 
-#ifdef CONFIG_PA8X00
-/* Only pa8800, pa8900 needs this */
-
 #include <asm/kmap_types.h>
 
 #define ARCH_HAS_KMAP
 
-void kunmap_parisc(void *addr);
+static inline void kmap_parisc(struct page *page)
+{
+	if (parisc_requires_coherency())
+		flush_user_dcache_page(page);
+}
+
+static inline void kunmap_parisc(void *addr)
+{
+	/* always flush kernel dcache, independed of
+	 * parisc_requires_coherency(). Needed on CPUs < PA8800/PA8900 */
+	flush_kernel_dcache_page_addr(addr);
+}
 
 static inline void *kmap(struct page *page)
 {
 	might_sleep();
+	kmap_parisc(page);
 	return page_address(page);
 }
 
@@ -148,6 +159,7 @@ static inline void kunmap(struct page *page)
 static inline void *kmap_atomic(struct page *page)
 {
 	pagefault_disable();
+	kmap_parisc(page);
 	return page_address(page);
 }
 
@@ -160,7 +172,6 @@ static inline void __kunmap_atomic(void *addr)
 #define kmap_atomic_prot(page, prot)	kmap_atomic(page)
 #define kmap_atomic_pfn(pfn)	kmap_atomic(pfn_to_page(pfn))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
-#endif
 
 #endif /* _PARISC_CACHEFLUSH_H */
 
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index c035673..a7ee7b7 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -283,7 +283,7 @@ __flush_cache_page(struct vm_area_struct *vma, unsigned long vmaddr,
 	preempt_enable();
 }
 
-void flush_dcache_page(struct page *page)
+void flush_user_dcache_page(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 	struct vm_area_struct *mpnt;
@@ -291,13 +291,6 @@ void flush_dcache_page(struct page *page)
 	unsigned long addr, old_addr = 0;
 	pgoff_t pgoff;
 
-	if (mapping && !mapping_mapped(mapping)) {
-		set_bit(PG_dcache_dirty, &page->flags);
-		return;
-	}
-
-	flush_kernel_dcache_page(page);
-
 	if (!mapping)
 		return;
 
@@ -332,6 +325,20 @@ void flush_dcache_page(struct page *page)
 	}
 	flush_dcache_mmap_unlock(mapping);
 }
+EXPORT_SYMBOL(flush_user_dcache_page);
+
+void flush_dcache_page(struct page *page)
+{
+	struct address_space *mapping = page_mapping(page);
+
+	if (mapping && !mapping_mapped(mapping)) {
+		set_bit(PG_dcache_dirty, &page->flags);
+		return;
+	}
+
+	flush_kernel_dcache_page(page);
+	flush_user_dcache_page(page);
+}
 EXPORT_SYMBOL(flush_dcache_page);
 
 /* Defined in arch/parisc/kernel/pacache.S */
@@ -413,16 +420,6 @@ void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
 }
 EXPORT_SYMBOL(copy_user_page);
 
-#ifdef CONFIG_PA8X00
-
-void kunmap_parisc(void *addr)
-{
-	if (parisc_requires_coherency())
-		flush_kernel_dcache_page_addr(addr);
-}
-EXPORT_SYMBOL(kunmap_parisc);
-#endif
-
 void purge_tlb_entries(struct mm_struct *mm, unsigned long addr)
 {
 	unsigned long flags;
