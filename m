Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3FPEjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:39:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:48179 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3FPEjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:39:41 -0400
Message-ID: <1371357560.21896.120.camel@pasglop>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Date: Sun, 16 Jun 2013 14:39:20 +1000
In-Reply-To: <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-4-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static pte_t kvmppc_lookup_pte(pgd_t *pgdir, unsigned long hva, bool writing,
> -			unsigned long *pte_sizep)
> +			unsigned long *pte_sizep, bool do_get_page)
>  {
>  	pte_t *ptep;
>  	unsigned int shift = 0;
> @@ -135,6 +136,14 @@ static pte_t kvmppc_lookup_pte(pgd_t *pgdir, unsigned long hva, bool writing,
>  	if (!pte_present(*ptep))
>  		return __pte(0);
>  
> +	/*
> +	 * Put huge pages handling to the virtual mode.
> +	 * The only exception is for TCE list pages which we
> +	 * do need to call get_page() for.
> +	 */
> +	if ((*pte_sizep > PAGE_SIZE) && do_get_page)
> +		return __pte(0);
> +
>  	/* wait until _PAGE_BUSY is clear then set it atomically */
>  	__asm__ __volatile__ (
>  		"1:	ldarx	%0,0,%3\n"
> @@ -148,6 +157,18 @@ static pte_t kvmppc_lookup_pte(pgd_t *pgdir, unsigned long hva, bool writing,
>  		: "cc");
>  
>  	ret = pte;
> +	if (do_get_page && pte_present(pte) && (!writing || pte_write(pte))) {
> +		struct page *pg = NULL;
> +		pg = realmode_pfn_to_page(pte_pfn(pte));
> +		if (realmode_get_page(pg)) {
> +			ret = __pte(0);
> +		} else {
> +			pte = pte_mkyoung(pte);
> +			if (writing)
> +				pte = pte_mkdirty(pte);
> +		}
> +	}
> +	*ptep = pte;	/* clears _PAGE_BUSY */
>  
>  	return ret;
>  }

So now you are adding the clearing of _PAGE_BUSY that was missing for
your first patch, except that this is not enough since that means that
in the "emulated" case (ie, !do_get_page) you will in essence return
and then use a PTE that is not locked without any synchronization to
ensure that the underlying page doesn't go away... then you'll
dereference that page.

So either make everything use speculative get_page, or make the emulated
case use the MMU notifier to drop the operation in case of collision.

The former looks easier.

Also, any specific reason why you do:

  - Lock the PTE
  - get_page()
  - Unlock the PTE

Instead of

  - Read the PTE
  - get_page_unless_zero
  - re-check PTE

Like get_user_pages_fast() does ?

The former will be two atomic ops, the latter only one (faster), but
maybe you have a good reason why that can't work...

Cheers,
Ben.


