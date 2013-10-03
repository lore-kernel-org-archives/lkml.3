Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3JCSHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:07:46 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52096 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab3JCSHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:07:45 -0400
MIME-Version: 1.0
In-Reply-To: <20131003172755.GG7408@mudshark.cambridge.arm.com>
References: <1380820515-21100-1-git-send-email-zishen.lim@linaro.org>
	<20131003172755.GG7408@mudshark.cambridge.arm.com>
Date: Thu, 3 Oct 2013 11:07:44 -0700
Message-ID: <CAM1oe53oQ5OBww=89vqcyUt_NqsYfCHDVZkKv0p9=-TchhkHSA@mail.gmail.com>
Subject: Re: [RFC] ARM: lockless get_user_pages_fast()
From: Zi Shen Lim <zishen.lim@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-networking@linaro.org" <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your feedback Will.

On Thu, Oct 3, 2013 at 10:27 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Oct 03, 2013 at 06:15:15PM +0100, Zi Shen Lim wrote:
>> Futex uses GUP. Currently on ARM, the default __get_user_pages_fast
>> being used always returns 0, leading to a forever loop in get_futex_key :(
>>
>> Implementing GUP solves this problem.
>>
>> Tested on vexpress-A15 on QEMU.
>> 8<---------------------------------------------------->8
>>
>> Implement get_user_pages_fast without locking in the fastpath on ARM.
>> This work is derived from the x86 version and adapted to ARM.
>
> This looks pretty much like an exact copy of the x86 version, which will
> likely also result in another exact copy for arm64. Can none of this code be
> made common? Furthermore, the fact that you've lifted the code and not
> provided much of an explanation in the cover letter hints that you might not
> be aware of all the subtleties involved here...
>

You are right. I was wondering the same too. Hopefully this RFC will
lead to the desired solution.

x86 does this:
--8<-----
        unsigned long mask;
        pte_t *ptep;

        mask = _PAGE_PRESENT|_PAGE_USER;
        if (write)
                mask |= _PAGE_RW;

        ptep = pte_offset_map(&pmd, addr);
        do {
                pte_t pte = gup_get_pte(ptep);
                struct page *page;

                if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
                        pte_unmap(ptep);
                        return 0;
                }
-->8-----
The adaptation uses pte_* macros.

x86 also uses a more optimized version of pmd_large and pud_large,
instead of reusing pmd_huge or pud_huge.

>> +static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
>> +             int write, struct page **pages, int *nr)
>> +{
>> +     unsigned long next;
>> +     pmd_t *pmdp;
>> +
>> +     pmdp = pmd_offset(&pud, addr);
>> +     do {
>> +             pmd_t pmd = *pmdp;
>> +
>> +             next = pmd_addr_end(addr, end);
>> +             /*
>> +              * The pmd_trans_splitting() check below explains why
>> +              * pmdp_splitting_flush has to flush the tlb, to stop
>> +              * this gup-fast code from running while we set the
>> +              * splitting bit in the pmd. Returning zero will take
>> +              * the slow path that will call wait_split_huge_page()
>> +              * if the pmd is still in splitting state. gup-fast
>> +              * can't because it has irq disabled and
>> +              * wait_split_huge_page() would never return as the
>> +              * tlb flush IPI wouldn't run.
>> +              */
>> +             if (pmd_none(pmd) || pmd_trans_splitting(pmd))
>> +                     return 0;
>> +             if (unlikely(pmd_huge(pmd))) {
>> +                     if (!gup_huge_pmd(pmd, addr, next, write, pages, nr))
>> +                             return 0;
>> +             } else {
>> +                     if (!gup_pte_range(pmd, addr, next, write, pages, nr))
>> +                             return 0;
>> +             }
>> +     } while (pmdp++, addr = next, addr != end);
>
> ...case in point: we don't (usually) require IPIs to shoot down TLB entries
> in SMP systems, so this is racy under thp splitting.
>

Ok. I learned something new :)
Suggestions on how to proceed?

Thanks for your patience.

> Will
