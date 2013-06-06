Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3FFKWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:22:39 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49607 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab3FFKWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:22:37 -0400
Date: Thu, 6 Jun 2013 11:22:33 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 2/4] x86, cpa: Map in an arbitrary pgd
Message-ID: <20130606102233.GG30420@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-3-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370177770-26661-3-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Jun, at 02:56:08PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Add the ability to map pages in an arbitrary pgd.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/pgtable_types.h |  3 +-
>  arch/x86/mm/pageattr.c               | 80 ++++++++++++++++++++++++++++--------
>  2 files changed, 65 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index e6423002c10b..0613e147f083 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -352,7 +352,8 @@ static inline void update_page_count(int level, unsigned long pages) { }
>   */
>  extern pte_t *lookup_address(unsigned long address, unsigned int *level);
>  extern phys_addr_t slow_virt_to_phys(void *__address);
> -
> +extern void kernel_map_pages_in_pgd(pgd_t *pgd, unsigned long address,
> +				    unsigned numpages, unsigned long page_flags);
>  #endif	/* !__ASSEMBLY__ */
>  
>  #endif /* _ASM_X86_PGTABLE_DEFS_H */
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index bb32480c2d71..3d64e5fc2adc 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -30,6 +30,7 @@
>   */
>  struct cpa_data {
>  	unsigned long	*vaddr;
> +	pgd_t		*pgd;
>  	pgprot_t	mask_set;
>  	pgprot_t	mask_clr;
>  	int		numpages;

[...]

> @@ -697,7 +714,10 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
>  	else
>  		address = *cpa->vaddr;
>  repeat:
> -	kpte = lookup_address(address, &level);
> +	if (cpa->pgd)
> +		kpte = __lookup_address_in_pgd(cpa->pgd, address, &level);
> +	else
> +		kpte = _lookup_address_cpa(cpa, address, &level);

Don't you also need to initialise .pgd in __set_pages_p() and
__set_pages_np()?

-- 
Matt Fleming, Intel Open Source Technology Center
