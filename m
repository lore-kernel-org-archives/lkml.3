Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218AbaFILES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:04:18 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:56314 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932253AbaFILEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:04:14 -0400
Date: Mon, 9 Jun 2014 12:03:56 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "msalter@redhat.com" <msalter@redhat.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>
Subject: Re: [PATCH] arm64: Add flush_cache_vmap call in __early_set_fixmap
Message-ID: <20140609110356.GD25590@arm.com>
References: <1402050590-23877-1-git-send-email-leif.lindholm@linaro.org>
 <1402065449.15402.2.camel@deneb.redhat.com>
 <20140606145324.GE4179@bivouac.eciton.net>
 <1402067373.15402.9.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402067373.15402.9.camel@deneb.redhat.com>
Thread-Topic: [PATCH] arm64: Add flush_cache_vmap call in __early_set_fixmap
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 04:09:33PM +0100, Mark Salter wrote:
> On Fri, 2014-06-06 at 15:53 +0100, Leif Lindholm wrote:
> > On Fri, Jun 06, 2014 at 10:37:29AM -0400, Mark Salter wrote:
> > > On Fri, 2014-06-06 at 11:29 +0100, Leif Lindholm wrote:
> > > > __early_set_fixmap does not do any synchronization when called to set a
> > > > fixmap entry. Add call to flush_vmap_cache().

Did you hit a problem or it was just for safety?

> > > > Tested on hardware.
> > > > 
> > > > Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> > > > Tested-by: Graeme Gregory <graeme.gregory@linaro.org>
> > > > Cc: Steve Capper <steve.capper@linaro.org>
> > > > ---
> > > >  arch/arm64/mm/ioremap.c |    5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> > > > index 7ec3283..5b8766c 100644
> > > > --- a/arch/arm64/mm/ioremap.c
> > > > +++ b/arch/arm64/mm/ioremap.c
> > > > @@ -176,9 +176,10 @@ void __init __early_set_fixmap(enum fixed_addresses idx,
> > > >  
> > > >  	pte = early_ioremap_pte(addr);
> > > >  
> > > > -	if (pgprot_val(flags))
> > > > +	if (pgprot_val(flags)) {
> > > >  		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
> > > > -	else {
> > > > +		flush_cache_vmap(addr, addr + PAGE_SIZE);
> > > > +	} else {
> > > >  		pte_clear(&init_mm, addr, pte);
> > > >  		flush_tlb_kernel_range(addr, addr+PAGE_SIZE);
> > > >  	}
> > > 
> > > I'm confused by the commit message mentioning synchronization but
> > > the code doing a cache flush. I see that arm64 implementation of
> > > flush_cache_vmap() is just a dsb(). If it is synchronization that
> > > we need here (and it certainly looks like we do), why not just add
> > > the dsb() directly to make that clear?
> > 
> > It needs this Linux-semantically for the same reason remap_page_range
> > needs it. From the ARM architectural point of view, the reason is that
> > the translation table walk is considered a separate observer from the
> > core data interface.
> > 
> > But since there is a common Linux semantic for this, I preferred
> > reusing that over just throwing in a dsb(). My interpretation of
> > flush_cache_vmap() was "flush mappings from cache, so they can be
> > picked up by table walk". While we don't technically need to flush the
> > cache here, the underlying requirement is the same.
> 
> But the range you are flushing is not a range seen by the table walk
> observer. I just think it is clearer to explicitly show that it is
> the pte write which we want the table walk to see rather than to
> rely on the implicit behavior of a cache flush routine.

I think that's a valid point. flush_cache_vmap() is used to remove any
cached entries for the ioremap/vmap'ed range. That's not the aim here.

As an optimisation, set_pte() doesn't have a dsb(). We do this on the
clearing/invalidating path via the TLB flushing routines but not on the
re-enabling path. Here we just added dsb() in the relevant functions
that were called from the generic code (flush_cache_vmap,
update_mmu_cache).

A quick grep through the kernel shows that we have other set_pte() calls
without additional dsb() like create_mapping(), I think kvm_set_pte() as
well.

So I'm proposing an alternative patch (which needs some benchmarking as
well to see if anything is affected, maybe application startup time).

------------------8<-------------------------------

>From b5cd0fff5cb044fa32cbaa4eebd2f00690922567 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 9 Jun 2014 11:55:03 +0100
Subject: [PATCH] arm64: Use DSB after page table update

As an optimisation, set_pte() does not contain a DSB instruction to
ensure the observability of the page table update before subsequent
memory accesses or TLB maintenance. Such barrier is placed in the
flush_tlb_*() functions and flush_cache_vmap()/update_mmu_cache().
However, there are still places where this barrier is missed like
create_mapping().

This patch adds a dsb(ishst) call in set_pte() but only when the entry
being written is valid. For invalid entries, there is always a
subsequent TLB maintenance containing the DSB.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/cacheflush.h | 11 +----------
 arch/arm64/include/asm/pgtable.h    |  8 ++++++++
 arch/arm64/include/asm/tlbflush.h   |  5 -----
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index a5176cf32dad..8fdf37d83014 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -138,19 +138,10 @@ static inline void __flush_icache_all(void)
 #define flush_icache_page(vma,page)	do { } while (0)
 
 /*
- * flush_cache_vmap() is used when creating mappings (eg, via vmap,
- * vmalloc, ioremap etc) in kernel space for pages.  On non-VIPT
- * caches, since the direct-mappings of these pages may contain cached
- * data, we need to do a full cache flush to ensure that writebacks
- * don't corrupt data placed into these pages via the new mappings.
+ * Not required on AArch64 with VIPT caches.
  */
 static inline void flush_cache_vmap(unsigned long start, unsigned long end)
 {
-	/*
-	 * set_pte_at() called from vmap_pte_range() does not
-	 * have a DSB after cleaning the cache line.
-	 */
-	dsb(ish);
 }
 
 static inline void flush_cache_vunmap(unsigned long start, unsigned long end)
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index aa150ed99f22..2d03af6a2225 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -136,6 +136,7 @@ extern struct page *empty_zero_page;
 #define pte_write(pte)		(!!(pte_val(pte) & PTE_WRITE))
 #define pte_exec(pte)		(!(pte_val(pte) & PTE_UXN))
 
+#define pte_valid(pte)		(!!(pte_val(pte) & PTE_VALID))
 #define pte_valid_user(pte) \
 	((pte_val(pte) & (PTE_VALID | PTE_USER)) == (PTE_VALID | PTE_USER))
 
@@ -184,6 +185,13 @@ static inline pte_t pte_mkspecial(pte_t pte)
 static inline void set_pte(pte_t *ptep, pte_t pte)
 {
 	*ptep = pte;
+
+	/*
+	 * If !pte_valid(pte), the DSB is handled by the TLB invalidation
+	 * operation.
+	 */
+	if (pte_valid(pte))
+		dsb(ishst);
 }
 
 extern void __sync_icache_dcache(pte_t pteval, unsigned long addr);
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index b9349c4513ea..b28b970123dc 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -130,11 +130,6 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 static inline void update_mmu_cache(struct vm_area_struct *vma,
 				    unsigned long addr, pte_t *ptep)
 {
-	/*
-	 * set_pte() does not have a DSB, so make sure that the page table
-	 * write is visible.
-	 */
-	dsb(ishst);
 }
 
 #define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
