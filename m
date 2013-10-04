Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab3JDKbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:31:53 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40942 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3JDKbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:31:49 -0400
Date: Fri, 4 Oct 2013 11:31:42 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Zi Shen Lim <zishen.lim@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-networking@linaro.org" <linaro-networking@linaro.org>,
        chanho61.park@samsung.com
Subject: Re: [RFC] ARM: lockless get_user_pages_fast()
Message-ID: <20131004103140.GA4444@linaro.org>
References: <1380820515-21100-1-git-send-email-zishen.lim@linaro.org>
 <20131003172755.GG7408@mudshark.cambridge.arm.com>
 <CAM1oe53oQ5OBww=89vqcyUt_NqsYfCHDVZkKv0p9=-TchhkHSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM1oe53oQ5OBww=89vqcyUt_NqsYfCHDVZkKv0p9=-TchhkHSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:07:44AM -0700, Zi Shen Lim wrote:
> Thanks for your feedback Will.
> 
> On Thu, Oct 3, 2013 at 10:27 AM, Will Deacon <will.deacon@arm.com> wrote:
> > On Thu, Oct 03, 2013 at 06:15:15PM +0100, Zi Shen Lim wrote:
> >> Futex uses GUP. Currently on ARM, the default __get_user_pages_fast
> >> being used always returns 0, leading to a forever loop in get_futex_key :(
> >>
> >> Implementing GUP solves this problem.
> >>
> >> Tested on vexpress-A15 on QEMU.
> >> 8<---------------------------------------------------->8
> >>
> >> Implement get_user_pages_fast without locking in the fastpath on ARM.
> >> This work is derived from the x86 version and adapted to ARM.
> >
> > This looks pretty much like an exact copy of the x86 version, which will
> > likely also result in another exact copy for arm64. Can none of this code be
> > made common? Furthermore, the fact that you've lifted the code and not
> > provided much of an explanation in the cover letter hints that you might not
> > be aware of all the subtleties involved here...
> >
> 
> You are right. I was wondering the same too. Hopefully this RFC will
> lead to the desired solution.
> 
> x86 does this:
> --8<-----
>         unsigned long mask;
>         pte_t *ptep;
> 
>         mask = _PAGE_PRESENT|_PAGE_USER;
>         if (write)
>                 mask |= _PAGE_RW;
> 
>         ptep = pte_offset_map(&pmd, addr);
>         do {
>                 pte_t pte = gup_get_pte(ptep);
>                 struct page *page;
> 
>                 if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
>                         pte_unmap(ptep);
>                         return 0;
>                 }
> -->8-----
> The adaptation uses pte_* macros.
> 
> x86 also uses a more optimized version of pmd_large and pud_large,
> instead of reusing pmd_huge or pud_huge.
> 
> >> +static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
> >> +             int write, struct page **pages, int *nr)
> >> +{
> >> +     unsigned long next;
> >> +     pmd_t *pmdp;
> >> +
> >> +     pmdp = pmd_offset(&pud, addr);
> >> +     do {
> >> +             pmd_t pmd = *pmdp;
> >> +
> >> +             next = pmd_addr_end(addr, end);
> >> +             /*
> >> +              * The pmd_trans_splitting() check below explains why
> >> +              * pmdp_splitting_flush has to flush the tlb, to stop
> >> +              * this gup-fast code from running while we set the
> >> +              * splitting bit in the pmd. Returning zero will take
> >> +              * the slow path that will call wait_split_huge_page()
> >> +              * if the pmd is still in splitting state. gup-fast
> >> +              * can't because it has irq disabled and
> >> +              * wait_split_huge_page() would never return as the
> >> +              * tlb flush IPI wouldn't run.
> >> +              */
> >> +             if (pmd_none(pmd) || pmd_trans_splitting(pmd))
> >> +                     return 0;
> >> +             if (unlikely(pmd_huge(pmd))) {
> >> +                     if (!gup_huge_pmd(pmd, addr, next, write, pages, nr))
> >> +                             return 0;
> >> +             } else {
> >> +                     if (!gup_pte_range(pmd, addr, next, write, pages, nr))
> >> +                             return 0;
> >> +             }
> >> +     } while (pmdp++, addr = next, addr != end);
> >
> > ...case in point: we don't (usually) require IPIs to shoot down TLB entries
> > in SMP systems, so this is racy under thp splitting.
> >
> 
> Ok. I learned something new :)
> Suggestions on how to proceed?

Hi Zi Shen,
I am actually looking at this now too :-).
(but from the perspective of optimising Direct-IO on ARM/ARM64).

I've been looking through Chanho Park's work at:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-April/162115.html

As Will pointed out, ARM does not usually require IPIs to shoot down TLB
entries. So the local_irq_disable will not necessarily block pagetables being
freed when fast_gup is running.

Transparent huge pages when splitting will set the pmd splitting bit then
perform a tlb invalidate, then proceed with the split. Thus a splitting THP
will not always be blocked by local_irq_disable on ARM. This does not only
affect fast_gup, futexes are also affected. From my understanding of futex on
THP tail case in kernel/futex.c, it looks like an assumption is made there also
that splitting pmds can be blocked by disabling local irqs.

PowerPC and SPARC, like ARM do not necessarily require IPIs for TLB shootdown
either so they make use of tlb_remove_table (CONFIG_HAVE_RCU_TABLE_FREE). This
identifies pages backing pagetables that have multiple users and batches them
up, and then performs a dummy IPI before freeing them en masse. This reduces
the performance impact from the IPIs (by doing considerably fewer of them), and
guarantees that pagetables cannot be freed from under the fast_gup.
Unfortunately this also means that the fast_gup has to be aware of ptes/pmds
changing from under it.

I am currently working on a fast_gup that follows the PowerPC way of doing
things, and am convincing myself that the behaviour is valid on ARM (if
tlb_remove_table were to be used), also I am looking over the THP splitting
logic to see how that is handled on PowerPC and SPARC. It may be practical to
do an IPI for THPs that have multiple users and are splitting. (On my x86
desktop with an uptime of 63 days of running all manner of crazyness, I have
67982 THP splits recorded in total).

There's also the possibility of blocking without an IPI, but it's not obvious
to me how to do that (that would probably necessitate a change to
kernel/futex.c). I've just picked this up recently and am still trying to
understand it fully.

Cheers,
-- 
Steve

> 
> Thanks for your patience.
> 
> > Will
