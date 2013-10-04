Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3JDNxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:53:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49231 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754476Ab3JDNxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:53:51 -0400
Date: Fri, 4 Oct 2013 14:53:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Steve Capper <steve.capper@linaro.org>
Cc: Zi Shen Lim <zishen.lim@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-networking@linaro.org" <linaro-networking@linaro.org>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        linux-mm@kvack.org
Subject: Re: [RFC] ARM: lockless get_user_pages_fast()
Message-ID: <20131004135306.GK24303@mudshark.cambridge.arm.com>
References: <1380820515-21100-1-git-send-email-zishen.lim@linaro.org>
 <20131003172755.GG7408@mudshark.cambridge.arm.com>
 <CAM1oe53oQ5OBww=89vqcyUt_NqsYfCHDVZkKv0p9=-TchhkHSA@mail.gmail.com>
 <20131004103140.GA4444@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004103140.GA4444@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

[adding linux-mm, since this has turned into a discussion about THP
splitting]

On Fri, Oct 04, 2013 at 11:31:42AM +0100, Steve Capper wrote:
> On Thu, Oct 03, 2013 at 11:07:44AM -0700, Zi Shen Lim wrote:
> > On Thu, Oct 3, 2013 at 10:27 AM, Will Deacon <will.deacon@arm.com> wrote:
> > > On Thu, Oct 03, 2013 at 06:15:15PM +0100, Zi Shen Lim wrote:
> > >> Futex uses GUP. Currently on ARM, the default __get_user_pages_fast
> > >> being used always returns 0, leading to a forever loop in get_futex_key :(
> > >
> > > This looks pretty much like an exact copy of the x86 version, which will
> > > likely also result in another exact copy for arm64. Can none of this code be
> > > made common? Furthermore, the fact that you've lifted the code and not
> > > provided much of an explanation in the cover letter hints that you might not
> > > be aware of all the subtleties involved here...

[...]

> > >> +static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
> > >> +             int write, struct page **pages, int *nr)
> > >> +{
> > >> +     unsigned long next;
> > >> +     pmd_t *pmdp;
> > >> +
> > >> +     pmdp = pmd_offset(&pud, addr);
> > >> +     do {
> > >> +             pmd_t pmd = *pmdp;
> > >> +
> > >> +             next = pmd_addr_end(addr, end);
> > >> +             /*
> > >> +              * The pmd_trans_splitting() check below explains why
> > >> +              * pmdp_splitting_flush has to flush the tlb, to stop
> > >> +              * this gup-fast code from running while we set the
> > >> +              * splitting bit in the pmd. Returning zero will take
> > >> +              * the slow path that will call wait_split_huge_page()
> > >> +              * if the pmd is still in splitting state. gup-fast
> > >> +              * can't because it has irq disabled and
> > >> +              * wait_split_huge_page() would never return as the
> > >> +              * tlb flush IPI wouldn't run.
> > >> +              */
> > >> +             if (pmd_none(pmd) || pmd_trans_splitting(pmd))
> > >> +                     return 0;
> > >> +             if (unlikely(pmd_huge(pmd))) {
> > >> +                     if (!gup_huge_pmd(pmd, addr, next, write, pages, nr))
> > >> +                             return 0;
> > >> +             } else {
> > >> +                     if (!gup_pte_range(pmd, addr, next, write, pages, nr))
> > >> +                             return 0;
> > >> +             }
> > >> +     } while (pmdp++, addr = next, addr != end);
> > >
> > > ...case in point: we don't (usually) require IPIs to shoot down TLB entries
> > > in SMP systems, so this is racy under thp splitting.

[...]

> As Will pointed out, ARM does not usually require IPIs to shoot down TLB
> entries. So the local_irq_disable will not necessarily block pagetables being
> freed when fast_gup is running.
> 
> Transparent huge pages when splitting will set the pmd splitting bit then
> perform a tlb invalidate, then proceed with the split. Thus a splitting THP
> will not always be blocked by local_irq_disable on ARM. This does not only
> affect fast_gup, futexes are also affected. From my understanding of futex on
> THP tail case in kernel/futex.c, it looks like an assumption is made there also
> that splitting pmds can be blocked by disabling local irqs.
> 
> PowerPC and SPARC, like ARM do not necessarily require IPIs for TLB shootdown
> either so they make use of tlb_remove_table (CONFIG_HAVE_RCU_TABLE_FREE). This
> identifies pages backing pagetables that have multiple users and batches them
> up, and then performs a dummy IPI before freeing them en masse. This reduces
> the performance impact from the IPIs (by doing considerably fewer of them), and
> guarantees that pagetables cannot be freed from under the fast_gup.
> Unfortunately this also means that the fast_gup has to be aware of ptes/pmds
> changing from under it.

[...]

> There's also the possibility of blocking without an IPI, but it's not obvious
> to me how to do that (that would probably necessitate a change to
> kernel/futex.c). I've just picked this up recently and am still trying to
> understand it fully.

The IPI solution looks like a hack to me and essentially moves the
synchronisation down into the csd_lock on the splitting side as part of the
cross-call to invalidate the TLB. Furthermore, the TLB doesn't even need to
be invalidated afaict, since we're just updating software bits.

Instead, I wonder whether this can be solved with a simple atomic_t:

	- The fast GUP code (read side) does something like:

		atomic_inc(readers);
		smp_mb__after_atomic_inc();
		__get_user_pages_fast(...);
		smp_mb__before_atomic_dec();
		atomic_dec(readers);

	- The splitting code (write side) then polls the counter to reach
	  zero:

		pmd_t pmd = pmd_mksplitting(*pmdp);
		set_pmd_at(vma->vm_mm, address, pmdp, pmd);
		smp_mb();
		while (atomic_read(readers) != 0)
			cpu_relax();

that way, we don't need to worry about IPIs, we don't need to disable
interrupts on the read side and we still get away without heavyweight
locking.

Of course, I could well be missing something here, but what we currently
have in mainline doesn't work for ARM anyway (since TLB invalidation is
broadcast in hardware).

Will
