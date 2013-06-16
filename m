Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3FPErJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:47:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:43394 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab3FPErF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:47:05 -0400
Message-ID: <1371358002.21896.124.camel@pasglop>
Subject: Re: [PATCH 4/4] KVM: PPC: Add hugepage support for IOMMU in-kernel
 handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Date: Sun, 16 Jun 2013 14:46:42 +1000
In-Reply-To: <1370412673-1345-5-git-send-email-aik@ozlabs.ru>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-5-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 16:11 +1000, Alexey Kardashevskiy wrote:

> @@ -185,7 +186,31 @@ static unsigned long kvmppc_realmode_gpa_to_hpa(struct kvm_vcpu *vcpu,
>  	unsigned long hva, hpa, pg_size = 0, offset;
>  	unsigned long gfn = gpa >> PAGE_SHIFT;
>  	bool writing = gpa & TCE_PCI_WRITE;
> +	struct kvmppc_iommu_hugepage *hp;
>  
> +	/*
> +	 * Try to find an already used hugepage.
> +	 * If it is not there, the kvmppc_lookup_pte() will return zero
> +	 * as it won't do get_page() on a huge page in real mode
> +	 * and therefore the request will be passed to the virtual mode.
> +	 */
> +	if (tt) {
> +		spin_lock(&tt->hugepages_lock);
> +		list_for_each_entry(hp, &tt->hugepages, list) {
> +			if ((gpa < hp->gpa) || (gpa >= hp->gpa + hp->size))
> +				continue;
> +
> +			/* Calculate host phys address keeping flags and offset in the page */
> +			offset = gpa & (hp->size - 1);
> +
> +			/* pte_pfn(pte) should return an address aligned to pg_size */
> +			hpa = (pte_pfn(hp->pte) << PAGE_SHIFT) + offset;
> +			spin_unlock(&tt->hugepages_lock);
> +
> +			return hpa;
> +		}
> +		spin_unlock(&tt->hugepages_lock);
> +	}

Wow .... this is run in real mode right ?

spin_lock() and spin_unlock() are a big no-no in real mode. If lockdep
and/or spinlock debugging are enabled and something goes pear-shaped
they are going to bring your whole system down in a blink in quite
horrible ways.

If you are going to do that, you need some kind of custom low-level
lock.

Also, I see that you are basically using a non-ordered list and doing a
linear search in it every time. That's going to COST !

You should really consider a more efficient data structure. You should
also be able to do something that doesn't require locks for readers.

>  	/* Find a KVM memslot */
>  	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
>  	if (!memslot)
> @@ -237,6 +262,10 @@ static long kvmppc_clear_tce_real_mode(struct kvm_vcpu *vcpu,
>  		if (oldtce & TCE_PCI_WRITE)
>  			SetPageDirty(page);
>  
> +		/* Do not put a huge page and continue without error */
> +		if (PageCompound(page))
> +			continue;
> +
>  		if (realmode_put_page(page)) {
>  			ret = H_TOO_HARD;
>  			break;
> @@ -282,7 +311,7 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
>  			if (iommu_tce_put_param_check(tbl, ioba, tce))
>  				return H_PARAMETER;
>  
> -			hpa = kvmppc_realmode_gpa_to_hpa(vcpu, tce, true);
> +			hpa = kvmppc_realmode_gpa_to_hpa(vcpu, tt, tce, true);
>  			if (hpa == ERROR_ADDR) {
>  				vcpu->arch.tce_reason = H_TOO_HARD;
>  				return H_TOO_HARD;
> @@ -295,6 +324,11 @@ long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
>  			if (unlikely(ret)) {
>  				struct page *pg = realmode_pfn_to_page(hpa);
>  				BUG_ON(!pg);
> +
> +				/* Do not put a huge page and return an error */
> +				if (!PageCompound(pg))
> +					return H_HARDWARE;
> +
>  				if (realmode_put_page(pg)) {
>  					vcpu->arch.tce_reason = H_HARDWARE;
>  					return H_TOO_HARD;
> @@ -351,7 +385,7 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
>  	vcpu->arch.tce_tmp_num = 0;
>  	vcpu->arch.tce_reason = 0;
>  
> -	tces = (unsigned long *) kvmppc_realmode_gpa_to_hpa(vcpu,
> +	tces = (unsigned long *) kvmppc_realmode_gpa_to_hpa(vcpu, NULL,
>  			tce_list, false);
>  	if ((unsigned long)tces == ERROR_ADDR)
>  		return H_TOO_HARD;
> @@ -374,7 +408,7 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
>  
>  		/* Translate TCEs and go get_page */
>  		for (i = 0; i < npages; ++i) {
> -			unsigned long hpa = kvmppc_realmode_gpa_to_hpa(vcpu,
> +			unsigned long hpa = kvmppc_realmode_gpa_to_hpa(vcpu, tt,
>  					vcpu->arch.tce_tmp[i], true);
>  			if (hpa == ERROR_ADDR) {
>  				vcpu->arch.tce_tmp_num = i;

Cheers,
Ben.


