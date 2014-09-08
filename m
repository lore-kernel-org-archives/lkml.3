Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaIHTU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:20:59 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59080 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbaIHTU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:20:57 -0400
Date: Mon, 8 Sep 2014 12:16:34 -0700
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Laura Abbott <lauraa@codeaurora.org>,
        Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/8] arm: fixmap: implement __set_fixmap()
Message-ID: <20140908191634.GV5598@outflux.net>
References: <1409781429-27593-1-git-send-email-keescook@chromium.org>
 <1409781429-27593-4-git-send-email-keescook@chromium.org>
 <20140904170349.GL7156@arm.com>
 <CAGXu5jKimGaupwyUwt0Zwa3OtjeoED8-uBeMX0MwXjBYP6ssAg@mail.gmail.com>
 <20140904172748.GO7156@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904172748.GO7156@arm.com>
Organization: Chromium
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 06:27:48PM +0100, Will Deacon wrote:
> On Thu, Sep 04, 2014 at 06:23:42PM +0100, Kees Cook wrote:
> > On Thu, Sep 4, 2014 at 10:03 AM, Will Deacon <will.deacon@arm.com> wrote:
> > > Hi Kees,
> > >
> > > On Wed, Sep 03, 2014 at 10:57:04PM +0100, Kees Cook wrote:
> > >> This is used from set_fixmap() and clear_fixmap() via asm-generic/fixmap.h.
> > >> Also makes sure that the fixmap allocation fits into the expected range.
> > >>
> > >> Based on patch by Rabin Vincent.
> > >
> > > [...]
> > >
> > >> +void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
> > >> +{
> > >> +     unsigned long vaddr = __fix_to_virt(idx);
> > >> +     pte_t *pte = pte_offset_kernel(pmd_off_k(vaddr), vaddr);
> > >> +
> > >> +     /* Make sure fixmap region does not exceed available allocation. */
> > >> +     BUILD_BUG_ON(FIXADDR_START + (__end_of_fixed_addresses * PAGE_SIZE) >
> > >> +                  FIXADDR_END);
> > >> +     BUG_ON(idx >= __end_of_fixed_addresses);
> > >> +
> > >> +     if (pgprot_val(prot))
> > >> +             set_pte_at(NULL, vaddr, pte,
> > >> +                     pfn_pte(phys >> PAGE_SHIFT, prot));
> > >> +     else
> > >> +             pte_clear(NULL, vaddr, pte);
> > >> +
> > >> +     /*
> > >> +      * Given the potential a15 tlbi errata, we can only do tlb flushes
> > >> +      * with interrupts disabled. Callers must have taken care of this.
> > >> +      */
> > >> +     WARN_ON_ONCE(!irqs_disabled());
> > >> +     flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
> > >
> > > Aha, this explains why we were confusing each other! The issue is that
> > > interrupts must be *enabled*, so this code does the exact opposite of
> > > what we need.
> > >
> > > I think this got lost in a sea of double negatives during the last round
> > > of review.
> > 
> > Ah! If this is the case, perhaps we can get away with
> > local_flush_tlb_kernel_range() then?
> 
> That's a bit tricky, since you need to ensure that preemption is disabled
> until the mapping is put back like it was.

Okay, under both real hardware with the errata, and under QEMU, things seem
to work with this change to the series. What do you think?

Thanks!

-Kees

diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
index b050ed7..8558d6b 100644
--- a/arch/arm/kernel/patch.c
+++ b/arch/arm/kernel/patch.c
@@ -37,6 +37,7 @@ void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags)
 	else
 		__acquire(&patch_lock);
 
+	preempt_disable();
 	set_fixmap(fixmap, page_to_phys(page));
 
 	return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));
@@ -46,6 +47,7 @@ void __kprobes patch_unmap(int fixmap, unsigned long *flags)
 	__releases(&patch_lock)
 {
 	clear_fixmap(fixmap);
+	preempt_enable();
 
 	if (flags)
 		spin_unlock_irqrestore(&patch_lock, *flags);
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index fab8583..efaf74c 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -368,7 +368,7 @@ void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
 			pfn_pte(phys >> PAGE_SHIFT, prot));
 	else
 		pte_clear(NULL, vaddr, pte);
-	flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
+	local_flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
 }
 
 /*

-- 
Kees Cook
Chrome OS Security
