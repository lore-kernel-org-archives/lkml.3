Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaBMRMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:12:20 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13034 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751572AbaBMRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:12:18 -0500
Date: Thu, 13 Feb 2014 17:12:11 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <Will.Deacon@arm.com>,
        Steven Capper <steve.capper@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: mm: report both sections from PMD
Message-ID: <20140213171211.GJ19841@arm.com>
References: <20140212224638.GA4558@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212224638.GA4558@www.outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:46:38PM +0000, Kees Cook wrote:
> diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
> index 03243f7eeddf..fb3de59ee811 100644
> --- a/arch/arm/include/asm/pgtable-3level.h
> +++ b/arch/arm/include/asm/pgtable-3level.h
> @@ -138,10 +138,6 @@
>  #define pud_none(pud)		(!pud_val(pud))
>  #define pud_bad(pud)		(!(pud_val(pud) & 2))
>  #define pud_present(pud)	(pud_val(pud))
> -#define pmd_table(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
> -						 PMD_TYPE_TABLE)
> -#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
> -						 PMD_TYPE_SECT)
>  #define pmd_large(pmd)		pmd_sect(pmd)
>  
>  #define pud_clear(pudp)			\
> diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
> index 7d59b524f2af..934aa5b60c7c 100644
> --- a/arch/arm/include/asm/pgtable.h
> +++ b/arch/arm/include/asm/pgtable.h
> @@ -183,6 +183,10 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
>  
>  #define pmd_none(pmd)		(!pmd_val(pmd))
>  #define pmd_present(pmd)	(pmd_val(pmd))
> +#define pmd_table(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
> +						 PMD_TYPE_TABLE)
> +#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
> +						 PMD_TYPE_SECT)

Do you still need to move these two if you only use pmd_large()? AFAICT,
it is equivalent to pmd_sect().

>  static inline pte_t *pmd_page_vaddr(pmd_t pmd)
>  {
> diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
> index 2b342177f5de..32635b474832 100644
> --- a/arch/arm/mm/dump.c
> +++ b/arch/arm/mm/dump.c
> @@ -260,8 +260,14 @@ static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
>  
>  	for (i = 0; i < PTRS_PER_PMD; i++, pmd++) {
>  		addr = start + i * PMD_SIZE;
> -		if (pmd_none(*pmd) || pmd_large(*pmd) || !pmd_present(*pmd))
> +		if (pmd_none(*pmd) || pmd_large(*pmd) || !pmd_present(*pmd)) {
>  			note_page(st, addr, 3, pmd_val(*pmd));
> +			if (SECTION_SIZE < PMD_SIZE &&
> +			    pmd_sect(*pmd) && pmd_sect(pmd[1])) {

I think the first patch was better with pmd[0] and pmd[1] treated
independently if SECTION_SIZE < PMD_SIZE, only that it should have
checked for pmd_sect(pmd[1]). I don't see anything in
__map_init_section() that would prevent populating only the second pmd
leaving the first one empty.

-- 
Catalin
