Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3JCR2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:28:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58833 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755077Ab3JCR2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:28:30 -0400
Date: Thu, 3 Oct 2013 18:27:55 +0100
From: Will Deacon <will.deacon@arm.com>
To: Zi Shen Lim <zishen.lim@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-networking@linaro.org" <linaro-networking@linaro.org>
Subject: Re: [RFC] ARM: lockless get_user_pages_fast()
Message-ID: <20131003172755.GG7408@mudshark.cambridge.arm.com>
References: <1380820515-21100-1-git-send-email-zishen.lim@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380820515-21100-1-git-send-email-zishen.lim@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 06:15:15PM +0100, Zi Shen Lim wrote:
> Futex uses GUP. Currently on ARM, the default __get_user_pages_fast
> being used always returns 0, leading to a forever loop in get_futex_key :(
> 
> Implementing GUP solves this problem.
> 
> Tested on vexpress-A15 on QEMU.
> 8<---------------------------------------------------->8
> 
> Implement get_user_pages_fast without locking in the fastpath on ARM.
> This work is derived from the x86 version and adapted to ARM.

This looks pretty much like an exact copy of the x86 version, which will
likely also result in another exact copy for arm64. Can none of this code be
made common? Furthermore, the fact that you've lifted the code and not
provided much of an explanation in the cover letter hints that you might not
be aware of all the subtleties involved here...

> +static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
> +		int write, struct page **pages, int *nr)
> +{
> +	unsigned long next;
> +	pmd_t *pmdp;
> +
> +	pmdp = pmd_offset(&pud, addr);
> +	do {
> +		pmd_t pmd = *pmdp;
> +
> +		next = pmd_addr_end(addr, end);
> +		/*
> +		 * The pmd_trans_splitting() check below explains why
> +		 * pmdp_splitting_flush has to flush the tlb, to stop
> +		 * this gup-fast code from running while we set the
> +		 * splitting bit in the pmd. Returning zero will take
> +		 * the slow path that will call wait_split_huge_page()
> +		 * if the pmd is still in splitting state. gup-fast
> +		 * can't because it has irq disabled and
> +		 * wait_split_huge_page() would never return as the
> +		 * tlb flush IPI wouldn't run.
> +		 */
> +		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
> +			return 0;
> +		if (unlikely(pmd_huge(pmd))) {
> +			if (!gup_huge_pmd(pmd, addr, next, write, pages, nr))
> +				return 0;
> +		} else {
> +			if (!gup_pte_range(pmd, addr, next, write, pages, nr))
> +				return 0;
> +		}
> +	} while (pmdp++, addr = next, addr != end);

...case in point: we don't (usually) require IPIs to shoot down TLB entries
in SMP systems, so this is racy under thp splitting.

Will
