Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab3E0KI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:08:58 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:35686 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab3E0KIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:08:55 -0400
Message-ID: <51A330AB.8060805@redhat.com>
Date: Mon, 27 May 2013 12:08:43 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: PPC: Add support for multiple-TCE hcalls
References: <1369105607-20957-1-git-send-email-aik@ozlabs.ru> <1369105607-20957-2-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1369105607-20957-2-git-send-email-aik@ozlabs.ru>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/05/2013 05:06, Alexey Kardashevskiy ha scritto:
> This adds real mode handlers for the H_PUT_TCE_INDIRECT and
> H_STUFF_TCE hypercalls for QEMU emulated devices such as virtio
> devices or emulated PCI.

Do you mean vio?  virtio (without getting into whether that's good or
bad) will bypass the iommu.

Paolo

> These calls allow adding multiple entries
> (up to 512) into the TCE table in one call which saves time on
> transition to/from real mode.
> 
> This adds a tce_tmp cache to kvm_vcpu_arch to save valid TCEs
> (copied from user and verified) before writing the whole list into
> the TCE table. This cache will be utilized more in the upcoming
> VFIO/IOMMU support to continue TCE list processing in the virtual
> mode in the case if the real mode handler failed for some reason.
> 
> This adds a guest physical to host real address converter
> and calls the existing H_PUT_TCE handler. The converting function
> is going to be fully utilized by upcoming VFIO supporting patches.
> 
> This also implements the KVM_CAP_PPC_MULTITCE capability,
> so in order to support the functionality of this patch, QEMU
> needs to query for this capability and set the "hcall-multi-tce"
> hypertas property only if the capability is present, otherwise
> there will be serious performance degradation.
> 
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> 
> ---
> Changelog:
> * added kvm_vcpu_arch::tce_tmp
> * removed cleanup if put_indirect failed, instead we do not even start
> writing to TCE table if we cannot get TCEs from the user and they are
> invalid
> * kvmppc_emulated_h_put_tce is split to kvmppc_emulated_put_tce
> and kvmppc_emulated_validate_tce (for the previous item)
> * fixed bug with failthrough for H_IPI
> * removed all get_user() from real mode handlers
> * kvmppc_lookup_pte() added (instead of making lookup_linux_pte public)
> ---
>  Documentation/virtual/kvm/api.txt       |   14 ++
>  arch/powerpc/include/asm/kvm_host.h     |    2 +
>  arch/powerpc/include/asm/kvm_ppc.h      |   16 +-
>  arch/powerpc/kvm/book3s_64_vio.c        |  118 ++++++++++++++
>  arch/powerpc/kvm/book3s_64_vio_hv.c     |  266 +++++++++++++++++++++++++++----
>  arch/powerpc/kvm/book3s_hv.c            |   39 +++++
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S |    6 +
>  arch/powerpc/kvm/book3s_pr_papr.c       |   37 ++++-
>  arch/powerpc/kvm/powerpc.c              |    3 +
>  include/uapi/linux/kvm.h                |    1 +
>  10 files changed, 470 insertions(+), 32 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 5f91eda..3c7c7ea 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2780,3 +2780,17 @@ Parameters: args[0] is the XICS device fd
>              args[1] is the XICS CPU number (server ID) for this vcpu
>  
>  This capability connects the vcpu to an in-kernel XICS device.
> +
> +6.8 KVM_CAP_PPC_MULTITCE
> +
> +Architectures: ppc
> +Parameters: none
> +Returns: 0 on success; -1 on error
> +
> +This capability enables the guest to put/remove multiple TCE entries
> +per hypercall which significanly accelerates DMA operations for PPC KVM
> +guests.
> +
> +When this capability is enabled, H_PUT_TCE_INDIRECT and H_STUFF_TCE are
> +expected to occur rather than H_PUT_TCE which supports only one TCE entry
> +per call.
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index af326cd..85d8f26 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -609,6 +609,8 @@ struct kvm_vcpu_arch {
>  	spinlock_t tbacct_lock;
>  	u64 busy_stolen;
>  	u64 busy_preempt;
> +
> +	unsigned long *tce_tmp;    /* TCE cache for TCE_PUT_INDIRECT hall */
>  #endif
>  };
>  
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index a5287fe..e852921b 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -133,8 +133,20 @@ extern int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu);
>  
>  extern long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>  				struct kvm_create_spapr_tce *args);
> -extern long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
> -			     unsigned long ioba, unsigned long tce);
> +extern struct kvmppc_spapr_tce_table *kvmppc_find_tce_table(
> +		struct kvm_vcpu *vcpu, unsigned long liobn);
> +extern long kvmppc_emulated_validate_tce(unsigned long tce);
> +extern void kvmppc_emulated_put_tce(struct kvmppc_spapr_tce_table *tt,
> +		unsigned long ioba, unsigned long tce);
> +extern long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce);
> +extern long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_list, unsigned long npages);
> +extern long kvmppc_virtmode_h_stuff_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_value, unsigned long npages);
>  extern long kvm_vm_ioctl_allocate_rma(struct kvm *kvm,
>  				struct kvm_allocate_rma *rma);
>  extern struct kvmppc_linear_info *kvm_alloc_rma(void);
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index b2d3f3b..06b7b20 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -14,6 +14,7 @@
>   *
>   * Copyright 2010 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
>   * Copyright 2011 David Gibson, IBM Corporation <dwg@au1.ibm.com>
> + * Copyright 2013 Alexey Kardashevskiy, IBM Corporation <aik@au1.ibm.com>
>   */
>  
>  #include <linux/types.h>
> @@ -36,8 +37,11 @@
>  #include <asm/ppc-opcode.h>
>  #include <asm/kvm_host.h>
>  #include <asm/udbg.h>
> +#include <asm/iommu.h>
> +#include <asm/tce.h>
>  
>  #define TCES_PER_PAGE	(PAGE_SIZE / sizeof(u64))
> +#define ERROR_ADDR      ((void *)~(unsigned long)0x0)
>  
>  static long kvmppc_stt_npages(unsigned long window_size)
>  {
> @@ -148,3 +152,117 @@ fail:
>  	}
>  	return ret;
>  }
> +
> +/* Converts guest physical address into host virtual */
> +static void __user *kvmppc_virtmode_gpa_to_hva(struct kvm_vcpu *vcpu,
> +		unsigned long gpa)
> +{
> +	unsigned long hva, gfn = gpa >> PAGE_SHIFT;
> +	struct kvm_memory_slot *memslot;
> +
> +	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
> +	if (!memslot)
> +		return ERROR_ADDR;
> +
> +	hva = __gfn_to_hva_memslot(memslot, gfn) + (gpa & ~PAGE_MASK);
> +	return (void *) hva;
> +}
> +
> +long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce)
> +{
> +	long ret;
> +	struct kvmppc_spapr_tce_table *tt;
> +
> +	tt = kvmppc_find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to userspace */
> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	/* Emulated IO */
> +	if (ioba >= tt->window_size)
> +		return H_PARAMETER;
> +
> +	ret = kvmppc_emulated_validate_tce(tce);
> +	if (ret)
> +		return ret;
> +
> +	kvmppc_emulated_put_tce(tt, ioba, tce);
> +
> +	return H_SUCCESS;
> +}
> +
> +long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_list, unsigned long npages)
> +{
> +	struct kvmppc_spapr_tce_table *tt;
> +	long i, ret;
> +	unsigned long __user *tces;
> +
> +	tt = kvmppc_find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to userspace */
> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	/*
> +	 * The spec says that the maximum size of the list is 512 TCEs so
> +	 * so the whole table addressed resides in 4K page
> +	 */
> +	if (npages > 512)
> +		return H_PARAMETER;
> +
> +	if (tce_list & ~IOMMU_PAGE_MASK)
> +		return H_PARAMETER;
> +
> +	tces = kvmppc_virtmode_gpa_to_hva(vcpu, tce_list);
> +	if (tces == ERROR_ADDR)
> +		return H_TOO_HARD;
> +
> +	/* Emulated IO */
> +	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
> +		return H_PARAMETER;
> +
> +	for (i = 0; i < npages; ++i) {
> +		if (get_user(vcpu->arch.tce_tmp[i], tces + i))
> +			return H_PARAMETER;
> +
> +		ret = kvmppc_emulated_validate_tce(vcpu->arch.tce_tmp[i]);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	for (i = 0; i < npages; ++i)
> +		kvmppc_emulated_put_tce(tt,
> +				ioba + (i << IOMMU_PAGE_SHIFT),
> +				vcpu->arch.tce_tmp[i]);
> +
> +	return H_SUCCESS;
> +}
> +
> +long kvmppc_virtmode_h_stuff_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_value, unsigned long npages)
> +{
> +	struct kvmppc_spapr_tce_table *tt;
> +	long i, ret;
> +
> +	tt = kvmppc_find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to userspace */
> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	/* Emulated IO */
> +	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
> +		return H_PARAMETER;
> +
> +	ret = kvmppc_emulated_validate_tce(tce_value);
> +	if (ret || (tce_value & (TCE_PCI_WRITE | TCE_PCI_READ)))
> +		return H_PARAMETER;
> +
> +	for (i = 0; i < npages; ++i, ioba += IOMMU_PAGE_SIZE)
> +		kvmppc_emulated_put_tce(tt, ioba, tce_value);
> +
> +	return H_SUCCESS;
> +}
> diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
> index 30c2f3b..c68d538 100644
> --- a/arch/powerpc/kvm/book3s_64_vio_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
> @@ -14,6 +14,7 @@
>   *
>   * Copyright 2010 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
>   * Copyright 2011 David Gibson, IBM Corporation <dwg@au1.ibm.com>
> + * Copyright 2013 Alexey Kardashevskiy, IBM Corporation <aik@au1.ibm.com>
>   */
>  
>  #include <linux/types.h>
> @@ -35,42 +36,249 @@
>  #include <asm/ppc-opcode.h>
>  #include <asm/kvm_host.h>
>  #include <asm/udbg.h>
> +#include <asm/iommu.h>
> +#include <asm/tce.h>
>  
>  #define TCES_PER_PAGE	(PAGE_SIZE / sizeof(u64))
> +#define ERROR_ADDR      (~(unsigned long)0x0)
>  
> -/* WARNING: This will be called in real-mode on HV KVM and virtual
> - *          mode on PR KVM
> +/* Finds a TCE table descriptor by LIOBN */
> +struct kvmppc_spapr_tce_table *kvmppc_find_tce_table(struct kvm_vcpu *vcpu,
> +		unsigned long liobn)
> +{
> +	struct kvmppc_spapr_tce_table *tt;
> +
> +	list_for_each_entry(tt, &vcpu->kvm->arch.spapr_tce_tables, list) {
> +		if (tt->liobn == liobn)
> +			return tt;
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(kvmppc_find_tce_table);
> +
> +/*
> + * Validate TCE address.
> + * At the moment only flags are validated
> + * as other check will significantly slow down
> + * or can make it even impossible to handle TCE requests
> + * in real mode.
> + */
> +long kvmppc_emulated_validate_tce(unsigned long tce)
> +{
> +	if (tce & ~(IOMMU_PAGE_MASK | TCE_PCI_WRITE | TCE_PCI_READ))
> +		return H_PARAMETER;
> +
> +	return H_SUCCESS;
> +}
> +EXPORT_SYMBOL_GPL(kvmppc_emulated_validate_tce);
> +
> +/*
> + * kvmppc_emulated_put_tce() handles TCE requests for devices emulated
> + * by QEMU. It puts guest TCE values into the table and expects
> + * the QEMU to convert them later in the QEMU device implementation.
> + * Wiorks in both real and virtual modes.
> + * It cannot fail so kvmppc_emulated_validate_tce must be called before it.
>   */
> +void kvmppc_emulated_put_tce(struct kvmppc_spapr_tce_table *tt,
> +		unsigned long ioba, unsigned long tce)
> +{
> +	unsigned long idx = ioba >> SPAPR_TCE_SHIFT;
> +	struct page *page;
> +	u64 *tbl;
> +
> +	/*
> +	 * Note on the use of page_address() in real mode,
> +	 *
> +	 * It is safe to use page_address() in real mode on ppc64 because
> +	 * page_address() is always defined as lowmem_page_address()
> +	 * which returns __va(PFN_PHYS(page_to_pfn(page))) which is arithmetial
> +	 * operation and does not access page struct.
> +	 *
> +	 * Theoretically page_address() could be defined different
> +	 * but either WANT_PAGE_VIRTUAL or HASHED_PAGE_VIRTUAL
> +	 * should be enabled.
> +	 * WANT_PAGE_VIRTUAL is never enabled on ppc32/ppc64,
> +	 * HASHED_PAGE_VIRTUAL could be enabled for ppc32 only and only
> +	 * if CONFIG_HIGHMEM is defined. As CONFIG_SPARSEMEM_VMEMMAP
> +	 * is not expected to be enabled on ppc32, page_address()
> +	 * is safe for ppc32 as well.
> +	 */
> +#if defined(HASHED_PAGE_VIRTUAL) || defined(WANT_PAGE_VIRTUAL)
> +#error TODO: fix to avoid page_address() here
> +#endif
> +	page = tt->pages[idx / TCES_PER_PAGE];
> +	tbl = (u64 *)page_address(page);
> +
> +	/* udbg_printf("tce @ %p\n", &tbl[idx % TCES_PER_PAGE]); */
> +	tbl[idx % TCES_PER_PAGE] = tce;
> +}
> +EXPORT_SYMBOL_GPL(kvmppc_emulated_put_tce);
> +
> +#ifdef CONFIG_KVM_BOOK3S_64_HV
> +
> +static pte_t kvmppc_lookup_pte(pgd_t *pgdir, unsigned long hva, bool writing,
> +			unsigned long *pte_sizep)
> +{
> +	pte_t *ptep;
> +	unsigned int shift = 0;
> +	pte_t pte, tmp, ret;
> +
> +	ptep = find_linux_pte_or_hugepte(pgdir, hva, &shift);
> +	if (!ptep)
> +		return __pte(0);
> +	if (shift)
> +		*pte_sizep = 1ul << shift;
> +	else
> +		*pte_sizep = PAGE_SIZE;
> +
> +	if (!pte_present(*ptep))
> +		return __pte(0);
> +
> +	/* wait until _PAGE_BUSY is clear then set it atomically */
> +	__asm__ __volatile__ (
> +		"1:	ldarx	%0,0,%3\n"
> +		"	andi.	%1,%0,%4\n"
> +		"	bne-	1b\n"
> +		"	ori	%1,%0,%4\n"
> +		"	stdcx.	%1,0,%3\n"
> +		"	bne-	1b"
> +		: "=&r" (pte), "=&r" (tmp), "=m" (*ptep)
> +		: "r" (ptep), "i" (_PAGE_BUSY)
> +		: "cc");
> +
> +	ret = pte;
> +
> +	return ret;
> +}
> +
> +/*
> + * Converts guest physical address into host physical address.
> + * Also returns pte and page size if the page is present in page table.
> + */
> +static unsigned long kvmppc_realmode_gpa_to_hpa(struct kvm_vcpu *vcpu,
> +		unsigned long gpa)
> +{
> +	struct kvm_memory_slot *memslot;
> +	pte_t pte;
> +	unsigned long hva, hpa, pg_size = 0, offset;
> +	unsigned long gfn = gpa >> PAGE_SHIFT;
> +	bool writing = gpa & TCE_PCI_WRITE;
> +
> +	/* Find a KVM memslot */
> +	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
> +	if (!memslot)
> +		return ERROR_ADDR;
> +
> +	/* Convert guest physical address to host virtual */
> +	hva = __gfn_to_hva_memslot(memslot, gfn);
> +
> +	/* Find a PTE and determine the size */
> +	pte = kvmppc_lookup_pte(vcpu->arch.pgdir, hva,
> +			writing, &pg_size);
> +	if (!pte)
> +		return ERROR_ADDR;
> +
> +	/* Calculate host phys address keeping flags and offset in the page */
> +	offset = gpa & (pg_size - 1);
> +
> +	/* pte_pfn(pte) should return an address aligned to pg_size */
> +	hpa = (pte_pfn(pte) << PAGE_SHIFT) + offset;
> +
> +	return hpa;
> +}
> +
>  long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
>  		      unsigned long ioba, unsigned long tce)
>  {
> -	struct kvm *kvm = vcpu->kvm;
> -	struct kvmppc_spapr_tce_table *stt;
> -
> -	/* udbg_printf("H_PUT_TCE(): liobn=0x%lx ioba=0x%lx, tce=0x%lx\n", */
> -	/* 	    liobn, ioba, tce); */
> -
> -	list_for_each_entry(stt, &kvm->arch.spapr_tce_tables, list) {
> -		if (stt->liobn == liobn) {
> -			unsigned long idx = ioba >> SPAPR_TCE_SHIFT;
> -			struct page *page;
> -			u64 *tbl;
> -
> -			/* udbg_printf("H_PUT_TCE: liobn 0x%lx => stt=%p  window_size=0x%x\n", */
> -			/* 	    liobn, stt, stt->window_size); */
> -			if (ioba >= stt->window_size)
> -				return H_PARAMETER;
> -
> -			page = stt->pages[idx / TCES_PER_PAGE];
> -			tbl = (u64 *)page_address(page);
> -
> -			/* FIXME: Need to validate the TCE itself */
> -			/* udbg_printf("tce @ %p\n", &tbl[idx % TCES_PER_PAGE]); */
> -			tbl[idx % TCES_PER_PAGE] = tce;
> -			return H_SUCCESS;
> -		}
> +	long ret;
> +	struct kvmppc_spapr_tce_table *tt;
> +
> +	tt = kvmppc_find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to virtual space */
> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	/* Emulated IO */
> +	if (ioba >= tt->window_size)
> +		return H_PARAMETER;
> +
> +	ret = kvmppc_emulated_validate_tce(tce);
> +	if (ret)
> +		return ret;
> +
> +	kvmppc_emulated_put_tce(tt, ioba, tce);
> +
> +	return H_SUCCESS;
> +}
> +
> +long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_list,	unsigned long npages)
> +{
> +	struct kvmppc_spapr_tce_table *tt;
> +	long i, ret;
> +	unsigned long *tces;
> +
> +	tt = kvmppc_find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to virtual space */
> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	/*
> +	 * The spec says that the maximum size of the list is 512 TCEs so
> +	 * so the whole table addressed resides in 4K page
> +	 */
> +	if (npages > 512)
> +		return H_PARAMETER;
> +
> +	if (tce_list & ~IOMMU_PAGE_MASK)
> +		return H_PARAMETER;
> +
> +	tces = (unsigned long *) kvmppc_realmode_gpa_to_hpa(vcpu, tce_list);
> +	if ((unsigned long)tces == ERROR_ADDR)
> +		return H_TOO_HARD;
> +
> +	/* Emulated IO */
> +	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
> +		return H_PARAMETER;
> +
> +	for (i = 0; i < npages; ++i) {
> +		ret = kvmppc_emulated_validate_tce(tces[i]);
> +		if (ret)
> +			return ret;
>  	}
>  
> -	/* Didn't find the liobn, punt it to userspace */
> -	return H_TOO_HARD;
> +	for (i = 0; i < npages; ++i)
> +		kvmppc_emulated_put_tce(tt, ioba + (i << IOMMU_PAGE_SHIFT),
> +				tces[i]);
> +
> +	return H_SUCCESS;
> +}
> +
> +long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_value, unsigned long npages)
> +{
> +	struct kvmppc_spapr_tce_table *tt;
> +	long i, ret;
> +
> +	tt = kvmppc_find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to virtual space */
> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	/* Emulated IO */
> +	if ((ioba + (npages << IOMMU_PAGE_SHIFT)) > tt->window_size)
> +		return H_PARAMETER;
> +
> +	ret = kvmppc_emulated_validate_tce(tce_value);
> +	if (ret || (tce_value & (TCE_PCI_WRITE | TCE_PCI_READ)))
> +		return H_PARAMETER;
> +
> +	for (i = 0; i < npages; ++i, ioba += IOMMU_PAGE_SIZE)
> +		kvmppc_emulated_put_tce(tt, ioba, tce_value);
> +
> +	return H_SUCCESS;
>  }
> +#endif /* CONFIG_KVM_BOOK3S_64_HV */
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 9de24f8..9d70fd8 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -566,6 +566,30 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
>  			ret = kvmppc_xics_hcall(vcpu, req);
>  			break;
>  		} /* fallthrough */
> +		return RESUME_HOST;
> +	case H_PUT_TCE:
> +		ret = kvmppc_virtmode_h_put_tce(vcpu, kvmppc_get_gpr(vcpu, 4),
> +						kvmppc_get_gpr(vcpu, 5),
> +						kvmppc_get_gpr(vcpu, 6));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_PUT_TCE_INDIRECT:
> +		ret = kvmppc_virtmode_h_put_tce_indirect(vcpu, kvmppc_get_gpr(vcpu, 4),
> +						kvmppc_get_gpr(vcpu, 5),
> +						kvmppc_get_gpr(vcpu, 6),
> +						kvmppc_get_gpr(vcpu, 7));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_STUFF_TCE:
> +		ret = kvmppc_virtmode_h_stuff_tce(vcpu, kvmppc_get_gpr(vcpu, 4),
> +						kvmppc_get_gpr(vcpu, 5),
> +						kvmppc_get_gpr(vcpu, 6),
> +						kvmppc_get_gpr(vcpu, 7));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
>  	default:
>  		return RESUME_HOST;
>  	}
> @@ -956,6 +980,20 @@ struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
>  	vcpu->arch.cpu_type = KVM_CPU_3S_64;
>  	kvmppc_sanity_check(vcpu);
>  
> +	/*
> +	 * As we want to minimize the chance of having H_PUT_TCE_INDIRECT
> +	 * half executed, we first read TCEs from the user, check them and
> +	 * return error if something went wrong and only then put TCEs into
> +	 * the TCE table.
> +	 *
> +	 * tce_tmp is a cache for TCEs to avoid stack allocation or
> +	 * kmalloc as the whole TCE list can take up to 512 items 8 bytes
> +	 * each (4096 bytes).
> +	 */
> +	vcpu->arch.tce_tmp = kmalloc(4096, GFP_KERNEL);
> +	if (!vcpu->arch.tce_tmp)
> +		goto free_vcpu;
> +
>  	return vcpu;
>  
>  free_vcpu:
> @@ -978,6 +1016,7 @@ void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
>  	unpin_vpa(vcpu->kvm, &vcpu->arch.slb_shadow);
>  	unpin_vpa(vcpu->kvm, &vcpu->arch.vpa);
>  	spin_unlock(&vcpu->arch.vpa_update_lock);
> +	kfree(vcpu->arch.tce_tmp);
>  	kvm_vcpu_uninit(vcpu);
>  	kmem_cache_free(kvm_vcpu_cache, vcpu);
>  }
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index b02f91e..d35554e 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -1490,6 +1490,12 @@ hcall_real_table:
>  	.long	0		/* 0x11c */
>  	.long	0		/* 0x120 */
>  	.long	.kvmppc_h_bulk_remove - hcall_real_table
> +	.long	0		/* 0x128 */
> +	.long	0		/* 0x12c */
> +	.long	0		/* 0x130 */
> +	.long	0		/* 0x134 */
> +	.long	.kvmppc_h_stuff_tce - hcall_real_table
> +	.long	.kvmppc_h_put_tce_indirect - hcall_real_table
>  hcall_real_table_end:
>  
>  ignore_hdec:
> diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
> index b24309c..3750e3c 100644
> --- a/arch/powerpc/kvm/book3s_pr_papr.c
> +++ b/arch/powerpc/kvm/book3s_pr_papr.c
> @@ -220,7 +220,38 @@ static int kvmppc_h_pr_put_tce(struct kvm_vcpu *vcpu)
>  	unsigned long tce = kvmppc_get_gpr(vcpu, 6);
>  	long rc;
>  
> -	rc = kvmppc_h_put_tce(vcpu, liobn, ioba, tce);
> +	rc = kvmppc_virtmode_h_put_tce(vcpu, liobn, ioba, tce);
> +	if (rc == H_TOO_HARD)
> +		return EMULATE_FAIL;
> +	kvmppc_set_gpr(vcpu, 3, rc);
> +	return EMULATE_DONE;
> +}
> +
> +static int kvmppc_h_pr_put_tce_indirect(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long liobn = kvmppc_get_gpr(vcpu, 4);
> +	unsigned long ioba = kvmppc_get_gpr(vcpu, 5);
> +	unsigned long tce = kvmppc_get_gpr(vcpu, 6);
> +	unsigned long npages = kvmppc_get_gpr(vcpu, 7);
> +	long rc;
> +
> +	rc = kvmppc_virtmode_h_put_tce_indirect(vcpu, liobn, ioba,
> +			tce, npages);
> +	if (rc == H_TOO_HARD)
> +		return EMULATE_FAIL;
> +	kvmppc_set_gpr(vcpu, 3, rc);
> +	return EMULATE_DONE;
> +}
> +
> +static int kvmppc_h_pr_stuff_tce(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long liobn = kvmppc_get_gpr(vcpu, 4);
> +	unsigned long ioba = kvmppc_get_gpr(vcpu, 5);
> +	unsigned long tce_value = kvmppc_get_gpr(vcpu, 6);
> +	unsigned long npages = kvmppc_get_gpr(vcpu, 7);
> +	long rc;
> +
> +	rc = kvmppc_virtmode_h_stuff_tce(vcpu, liobn, ioba, tce_value, npages);
>  	if (rc == H_TOO_HARD)
>  		return EMULATE_FAIL;
>  	kvmppc_set_gpr(vcpu, 3, rc);
> @@ -247,6 +278,10 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
>  		return kvmppc_h_pr_bulk_remove(vcpu);
>  	case H_PUT_TCE:
>  		return kvmppc_h_pr_put_tce(vcpu);
> +	case H_PUT_TCE_INDIRECT:
> +		return kvmppc_h_pr_put_tce_indirect(vcpu);
> +	case H_STUFF_TCE:
> +		return kvmppc_h_pr_stuff_tce(vcpu);
>  	case H_CEDE:
>  		vcpu->arch.shared->msr |= MSR_EE;
>  		kvm_vcpu_block(vcpu);
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 6316ee3..8465c2a 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -395,6 +395,9 @@ int kvm_dev_ioctl_check_extension(long ext)
>  		r = 1;
>  		break;
>  #endif
> +	case KVM_CAP_SPAPR_MULTITCE:
> +		r = 1;
> +		break;
>  	default:
>  		r = 0;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a5c86fc..5a2afda 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -666,6 +666,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_IRQ_MPIC 90
>  #define KVM_CAP_PPC_RTAS 91
>  #define KVM_CAP_IRQ_XICS 92
> +#define KVM_CAP_SPAPR_MULTITCE (0x110000 + 89)
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> 

