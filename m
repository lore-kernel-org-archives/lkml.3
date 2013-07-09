Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab3GIRCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:02:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab3GIRCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:02:40 -0400
Message-ID: <51DC4228.7010607@suse.de>
Date: Tue, 09 Jul 2013 19:02:32 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120306 Thunderbird/10.0.3
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 6/8] KVM: PPC: Add support for multiple-TCE hcalls
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru> <1373123227-22969-7-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1373123227-22969-7-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2013 05:07 PM, Alexey Kardashevskiy wrote:
> This adds real mode handlers for the H_PUT_TCE_INDIRECT and
> H_STUFF_TCE hypercalls for QEMU emulated devices such as IBMVIO
> devices or emulated PCI.  These calls allow adding multiple entries
> (up to 512) into the TCE table in one call which saves time on
> transition to/from real mode.

We don't mention QEMU explicitly in KVM code usually.

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

Same as above. But really you're only giving recommendations here. 
What's the point? Please describe what the benefit of this patch is, not 
what some other random subsystem might do with the benefits it brings.

>
> Signed-off-by: Paul Mackerras<paulus@samba.org>
> Signed-off-by: Alexey Kardashevskiy<aik@ozlabs.ru>
>
> ---
> Changelog:
> 2013/07/06:
> * fixed number of wrong get_page()/put_page() calls
>
> 2013/06/27:
> * fixed clear of BUSY bit in kvmppc_lookup_pte()
> * H_PUT_TCE_INDIRECT does realmode_get_page() now
> * KVM_CAP_SPAPR_MULTITCE now depends on CONFIG_PPC_BOOK3S_64
> * updated doc
>
> 2013/06/05:
> * fixed mistype about IBMVIO in the commit message
> * updated doc and moved it to another section
> * changed capability number
>
> 2013/05/21:
> * added kvm_vcpu_arch::tce_tmp
> * removed cleanup if put_indirect failed, instead we do not even start
> writing to TCE table if we cannot get TCEs from the user and they are
> invalid
> * kvmppc_emulated_h_put_tce is split to kvmppc_emulated_put_tce
> and kvmppc_emulated_validate_tce (for the previous item)
> * fixed bug with failthrough for H_IPI
> * removed all get_user() from real mode handlers
> * kvmppc_lookup_pte() added (instead of making lookup_linux_pte public)
>
> Signed-off-by: Alexey Kardashevskiy<aik@ozlabs.ru>
> ---
>   Documentation/virtual/kvm/api.txt       |  25 +++
>   arch/powerpc/include/asm/kvm_host.h     |   9 ++
>   arch/powerpc/include/asm/kvm_ppc.h      |  16 +-
>   arch/powerpc/kvm/book3s_64_vio.c        | 154 ++++++++++++++++++-
>   arch/powerpc/kvm/book3s_64_vio_hv.c     | 260 ++++++++++++++++++++++++++++----
>   arch/powerpc/kvm/book3s_hv.c            |  41 ++++-
>   arch/powerpc/kvm/book3s_hv_rmhandlers.S |   6 +
>   arch/powerpc/kvm/book3s_pr_papr.c       |  37 ++++-
>   arch/powerpc/kvm/powerpc.c              |   3 +
>   9 files changed, 517 insertions(+), 34 deletions(-)
>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 6365fef..762c703 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2362,6 +2362,31 @@ calls by the guest for that service will be passed to userspace to be
>   handled.
>
>
> +4.86 KVM_CAP_PPC_MULTITCE
> +
> +Capability: KVM_CAP_PPC_MULTITCE
> +Architectures: ppc
> +Type: vm
> +
> +This capability means the kernel is capable of handling hypercalls
> +H_PUT_TCE_INDIRECT and H_STUFF_TCE without passing those into the user
> +space. This significanly accelerates DMA operations for PPC KVM guests.

significanly? Please run this through a spell checker.

> +The user space should expect that its handlers for these hypercalls

s/The//

> +are not going to be called.

Is user space guaranteed they will not be called? Or can it still happen?

> +
> +In order to enable H_PUT_TCE_INDIRECT and H_STUFF_TCE use in the guest,
> +the user space might have to advertise it for the guest. For example,
> +IBM pSeries guest starts using them if "hcall-multi-tce" is present in
> +the "ibm,hypertas-functions" device-tree property.

This paragraph describes sPAPR. That's fine, but please document it as 
such. Also please check your grammar.

> +
> +Without this capability, only H_PUT_TCE is handled by the kernel and
> +therefore the use of H_PUT_TCE_INDIRECT and H_STUFF_TCE is not recommended
> +unless the capability is present as passing hypercalls to the userspace
> +slows operations a lot.
> +
> +Unlike other capabilities of this section, this one is always enabled.

Why? Wouldn't that confuse older user space?

> +
> +
>   5. The kvm_run structure
>   ------------------------
>
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index af326cd..20d04bd 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -180,6 +180,7 @@ struct kvmppc_spapr_tce_table {
>   	struct kvm *kvm;
>   	u64 liobn;
>   	u32 window_size;
> +	struct { struct { unsigned long put, indir, stuff; } rm, vm; } stat;

You don't need this.

>   	struct page *pages[0];
>   };
>
> @@ -609,6 +610,14 @@ struct kvm_vcpu_arch {
>   	spinlock_t tbacct_lock;
>   	u64 busy_stolen;
>   	u64 busy_preempt;
> +
> +	unsigned long *tce_tmp_hpas;	/* TCE cache for TCE_PUT_INDIRECT hcall */
> +	enum {
> +		TCERM_NONE,
> +		TCERM_GETPAGE,
> +		TCERM_PUTTCE,
> +		TCERM_PUTLIST,
> +	} tce_rm_fail;			/* failed stage of request processing */
>   #endif
>   };
>
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index a5287fe..fa722a0 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -133,8 +133,20 @@ extern int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu);
>
>   extern long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>   				struct kvm_create_spapr_tce *args);
> -extern long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
> -			     unsigned long ioba, unsigned long tce);
> +extern struct kvmppc_spapr_tce_table *kvmppc_find_tce_table(
> +		struct kvm_vcpu *vcpu, unsigned long liobn);
> +extern long kvmppc_emulated_validate_tce(unsigned long tce);
> +extern void kvmppc_emulated_put_tce(struct kvmppc_spapr_tce_table *tt,
> +		unsigned long ioba, unsigned long tce);
> +extern long kvmppc_vm_h_put_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce);
> +extern long kvmppc_vm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_list, unsigned long npages);
> +extern long kvmppc_vm_h_stuff_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_value, unsigned long npages);
>   extern long kvm_vm_ioctl_allocate_rma(struct kvm *kvm,
>   				struct kvm_allocate_rma *rma);
>   extern struct kvmppc_linear_info *kvm_alloc_rma(void);
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index b2d3f3b..99bf4e5 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -14,6 +14,7 @@
>    *
>    * Copyright 2010 Paul Mackerras, IBM Corp.<paulus@au1.ibm.com>
>    * Copyright 2011 David Gibson, IBM Corporation<dwg@au1.ibm.com>
> + * Copyright 2013 Alexey Kardashevskiy, IBM Corporation<aik@au1.ibm.com>
>    */
>
>   #include<linux/types.h>
> @@ -36,8 +37,10 @@
>   #include<asm/ppc-opcode.h>
>   #include<asm/kvm_host.h>
>   #include<asm/udbg.h>
> +#include<asm/iommu.h>
> +#include<asm/tce.h>
>
> -#define TCES_PER_PAGE	(PAGE_SIZE / sizeof(u64))
> +#define ERROR_ADDR      ((void *)~(unsigned long)0x0)
>
>   static long kvmppc_stt_npages(unsigned long window_size)
>   {
> @@ -50,6 +53,20 @@ static void release_spapr_tce_table(struct kvmppc_spapr_tce_table *stt)
>   	struct kvm *kvm = stt->kvm;
>   	int i;
>
> +#define __SV(x) stt->stat.x
> +#define __SVD(x) (__SV(rm.x)?(__SV(rm.x)-__SV(vm.x)):0)
> +	pr_debug("%s stat for liobn=%llx\n"
> +			"--------------- realmode ----- virtmode ---\n"
> +			"put_tce       %10ld     %10ld\n"
> +			"put_tce_indir %10ld     %10ld\n"
> +			"stuff_tce     %10ld     %10ld\n",
> +			__func__, stt->liobn,
> +			__SVD(put), __SV(vm.put),
> +			__SVD(indir), __SV(vm.indir),
> +			__SVD(stuff), __SV(vm.stuff));
> +#undef __SVD
> +#undef __SV

All of these stat points should just be trace points. You can do the 
statistic gathering from user space then.

> +
>   	mutex_lock(&kvm->lock);
>   	list_del(&stt->list);
>   	for (i = 0; i<  kvmppc_stt_npages(stt->window_size); i++)
> @@ -148,3 +165,138 @@ fail:
>   	}
>   	return ret;
>   }
> +
> +/* Converts guest physical address to host virtual address */
> +static void __user *kvmppc_vm_gpa_to_hva_and_get(struct kvm_vcpu *vcpu,

Please don't distinguish _vm versions. They're the normal case. _rm ones 
are the special ones.

> +		unsigned long gpa, struct page **pg)
> +{
> +	unsigned long hva, gfn = gpa>>  PAGE_SHIFT;
> +	struct kvm_memory_slot *memslot;
> +
> +	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
> +	if (!memslot)
> +		return ERROR_ADDR;
> +
> +	hva = __gfn_to_hva_memslot(memslot, gfn) + (gpa&  ~PAGE_MASK);

s/+/|/

> +
> +	if (get_user_pages_fast(hva&  PAGE_MASK, 1, 0, pg) != 1)
> +		return ERROR_ADDR;
> +
> +	return (void *) hva;
> +}
> +
> +long kvmppc_vm_h_put_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce)
> +{
> +	long ret;
> +	struct kvmppc_spapr_tce_table *tt;
> +
> +	tt = kvmppc_find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to userspace */

Unclear comment.

> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	++tt->stat.vm.put;
> +
> +	if (ioba>= tt->window_size)
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
> +long kvmppc_vm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_list, unsigned long npages)
> +{
> +	struct kvmppc_spapr_tce_table *tt;
> +	long i, ret = H_SUCCESS;
> +	unsigned long __user *tces;
> +	struct page *pg = NULL;
> +
> +	tt = kvmppc_find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to userspace */
> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	++tt->stat.vm.indir;
> +
> +	/*
> +	 * The spec says that the maximum size of the list is 512 TCEs so
> +	 * so the whole table addressed resides in 4K page

so so?

> +	 */
> +	if (npages>  512)
> +		return H_PARAMETER;
> +
> +	if (tce_list&  ~IOMMU_PAGE_MASK)
> +		return H_PARAMETER;
> +
> +	if ((ioba + (npages<<  IOMMU_PAGE_SHIFT))>  tt->window_size)
> +		return H_PARAMETER;
> +
> +	tces = kvmppc_vm_gpa_to_hva_and_get(vcpu, tce_list,&pg);
> +	if (tces == ERROR_ADDR)
> +		return H_TOO_HARD;
> +
> +	if (vcpu->arch.tce_rm_fail == TCERM_PUTLIST)
> +		goto put_list_page_exit;
> +
> +	for (i = 0; i<  npages; ++i) {
> +		if (get_user(vcpu->arch.tce_tmp_hpas[i], tces + i)) {
> +			ret = H_PARAMETER;
> +			goto put_list_page_exit;
> +		}
> +
> +		ret = kvmppc_emulated_validate_tce(vcpu->arch.tce_tmp_hpas[i]);
> +		if (ret)
> +			goto put_list_page_exit;
> +	}
> +
> +	for (i = 0; i<  npages; ++i)
> +		kvmppc_emulated_put_tce(tt, ioba + (i<<  IOMMU_PAGE_SHIFT),
> +				vcpu->arch.tce_tmp_hpas[i]);
> +put_list_page_exit:
> +	if (pg)
> +		put_page(pg);
> +
> +	if (vcpu->arch.tce_rm_fail != TCERM_NONE) {
> +		vcpu->arch.tce_rm_fail = TCERM_NONE;
> +		if (pg&&  !PageCompound(pg))
> +			put_page(pg); /* finish pending realmode_put_page() */
> +	}
> +
> +	return ret;
> +}
> +
> +long kvmppc_vm_h_stuff_tce(struct kvm_vcpu *vcpu,
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
> +	++tt->stat.vm.stuff;
> +
> +	if ((ioba + (npages<<  IOMMU_PAGE_SHIFT))>  tt->window_size)
> +		return H_PARAMETER;
> +
> +	ret = kvmppc_emulated_validate_tce(tce_value);
> +	if (ret || (tce_value&  (TCE_PCI_WRITE | TCE_PCI_READ)))
> +		return H_PARAMETER;
> +
> +	for (i = 0; i<  npages; ++i, ioba += IOMMU_PAGE_SIZE)
> +		kvmppc_emulated_put_tce(tt, ioba, tce_value);
> +
> +	return H_SUCCESS;
> +}
> diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
> index 30c2f3b..cd3e6f9 100644
> --- a/arch/powerpc/kvm/book3s_64_vio_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
> @@ -14,6 +14,7 @@
>    *
>    * Copyright 2010 Paul Mackerras, IBM Corp.<paulus@au1.ibm.com>
>    * Copyright 2011 David Gibson, IBM Corporation<dwg@au1.ibm.com>
> + * Copyright 2013 Alexey Kardashevskiy, IBM Corporation<aik@au1.ibm.com>
>    */
>
>   #include<linux/types.h>
> @@ -35,42 +36,243 @@
>   #include<asm/ppc-opcode.h>
>   #include<asm/kvm_host.h>
>   #include<asm/udbg.h>
> +#include<asm/iommu.h>
> +#include<asm/tce.h>
>
>   #define TCES_PER_PAGE	(PAGE_SIZE / sizeof(u64))
> +#define ERROR_ADDR      (~(unsigned long)0x0)
>
> -/* WARNING: This will be called in real-mode on HV KVM and virtual
> - *          mode on PR KVM

What's wrong with the warning?

> +/*
> + * Finds a TCE table descriptor by LIOBN
>    */
> +struct kvmppc_spapr_tce_table *kvmppc_find_tce_table(struct kvm_vcpu *vcpu,
> +		unsigned long liobn)
> +{
> +	struct kvmppc_spapr_tce_table *tt;
> +
> +	list_for_each_entry(tt,&vcpu->kvm->arch.spapr_tce_tables, list) {
> +		if (tt->liobn == liobn)
> +			return tt;
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(kvmppc_find_tce_table);
> +
> +#ifdef DEBUG
> +/*
> + * Lets user mode disable realmode handlers by putting big number
> + * in the bottom value of LIOBN

What? Seriously? Just don't enable the CAP.

> + */
> +#define kvmppc_find_tce_table(a, b) \
> +		((((b)&0xffff)>10000)?NULL:kvmppc_find_tce_table((a), (b)))
> +#endif
> +
> +/*
> + * Validates TCE address.
> + * At the moment only flags are validated as other checks will significantly slow
> + * down or can make it even impossible to handle TCE requests in real mode.

What?

> + */
> +long kvmppc_emulated_validate_tce(unsigned long tce)

I don't like the naming scheme. Please turn this around and make it 
kvmppc_tce_validate().

> +{
> +	if (tce&  ~(IOMMU_PAGE_MASK | TCE_PCI_WRITE | TCE_PCI_READ))
> +		return H_PARAMETER;
> +
> +	return H_SUCCESS;
> +}
> +EXPORT_SYMBOL_GPL(kvmppc_emulated_validate_tce);
> +
> +/*
> + * Handles TCE requests for QEMU emulated devices.

We still don't mention QEMU in KVM code. And does it really matter 
whether they're emulated by QEMU? Devices could also be emulated by KVM.

> + * Puts guest TCE values to the table and expects QEMU to convert them
> + * later in a QEMU device implementation.
> + * Called in both real and virtual modes.
> + * Cannot fail so kvmppc_emulated_validate_tce must be called before it.
> + */
> +void kvmppc_emulated_put_tce(struct kvmppc_spapr_tce_table *tt,

kvmppc_tce_put()

> +		unsigned long ioba, unsigned long tce)
> +{
> +	unsigned long idx = ioba>>  SPAPR_TCE_SHIFT;
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

Can you extract the text above, the check and the page_address call into 
a simple wrapper function?

> +	page = tt->pages[idx / TCES_PER_PAGE];
> +	tbl = (u64 *)page_address(page);
> +
> +	/* udbg_printf("tce @ %p\n",&tbl[idx % TCES_PER_PAGE]); */

This is not an RFC, is it?

> +	tbl[idx % TCES_PER_PAGE] = tce;
> +}
> +EXPORT_SYMBOL_GPL(kvmppc_emulated_put_tce);
> +
> +#ifdef CONFIG_KVM_BOOK3S_64_HV
> +/*
> + * Converts guest physical address to host physical address.
> + * Tries to increase page counter via realmode_get_page() and
> + * returns ERROR_ADDR if failed.
> + */
> +static unsigned long kvmppc_rm_gpa_to_hpa_and_get(struct kvm_vcpu *vcpu,
> +		unsigned long gpa, struct page **pg)
> +{
> +	struct kvm_memory_slot *memslot;
> +	pte_t *ptep, pte;
> +	unsigned long hva, hpa = ERROR_ADDR;
> +	unsigned long gfn = gpa>>  PAGE_SHIFT;
> +	unsigned shift = 0;
> +
> +	memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
> +	if (!memslot)
> +		return ERROR_ADDR;
> +
> +	hva = __gfn_to_hva_memslot(memslot, gfn);
> +
> +	ptep = find_linux_pte_or_hugepte(vcpu->arch.pgdir, hva,&shift);
> +	if (!ptep || !pte_present(*ptep))
> +		return ERROR_ADDR;
> +	pte = *ptep;
> +
> +	if (((gpa&  TCE_PCI_WRITE) || pte_write(pte))&&  !pte_dirty(pte))
> +		return ERROR_ADDR;
> +
> +	if (!pte_young(pte))
> +		return ERROR_ADDR;
> +
> +	if (!shift)
> +		shift = PAGE_SHIFT;
> +
> +	/* Put huge pages handling to the virtual mode */
> +	if (shift>  PAGE_SHIFT)
> +		return ERROR_ADDR;
> +
> +	*pg = realmode_pfn_to_page(pte_pfn(pte));
> +	if (!*pg || realmode_get_page(*pg))
> +		return ERROR_ADDR;
> +
> +	/* pte_pfn(pte) returns address aligned to pg_size */
> +	hpa = (pte_pfn(pte)<<  PAGE_SHIFT) + (gpa&  ((1<<  shift) - 1));
> +
> +	if (unlikely(pte_val(pte) != pte_val(*ptep))) {
> +		hpa = ERROR_ADDR;
> +		realmode_put_page(*pg);
> +		*pg = NULL;
> +	}
> +
> +	return hpa;
> +}
> +
>   long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
>   		      unsigned long ioba, unsigned long tce)
>   {
> -	struct kvm *kvm = vcpu->kvm;
> -	struct kvmppc_spapr_tce_table *stt;
> -
> -	/* udbg_printf("H_PUT_TCE(): liobn=0x%lx ioba=0x%lx, tce=0x%lx\n", */
> -	/* 	    liobn, ioba, tce); */
> -
> -	list_for_each_entry(stt,&kvm->arch.spapr_tce_tables, list) {
> -		if (stt->liobn == liobn) {
> -			unsigned long idx = ioba>>  SPAPR_TCE_SHIFT;
> -			struct page *page;
> -			u64 *tbl;
> -
> -			/* udbg_printf("H_PUT_TCE: liobn 0x%lx =>  stt=%p  window_size=0x%x\n", */
> -			/* 	    liobn, stt, stt->window_size); */
> -			if (ioba>= stt->window_size)
> -				return H_PARAMETER;
> -
> -			page = stt->pages[idx / TCES_PER_PAGE];
> -			tbl = (u64 *)page_address(page);
> -
> -			/* FIXME: Need to validate the TCE itself */
> -			/* udbg_printf("tce @ %p\n",&tbl[idx % TCES_PER_PAGE]); */
> -			tbl[idx % TCES_PER_PAGE] = tce;
> -			return H_SUCCESS;
> -		}
> +	long ret;
> +	struct kvmppc_spapr_tce_table *tt = kvmppc_find_tce_table(vcpu, liobn);
> +
> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	++tt->stat.rm.put;
> +
> +	if (ioba>= tt->window_size)
> +		return H_PARAMETER;
> +
> +	ret = kvmppc_emulated_validate_tce(tce);
> +	if (!ret)
> +		kvmppc_emulated_put_tce(tt, ioba, tce);
> +
> +	return ret;
> +}
> +
> +long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,

So the _vm version is the normal one and this is the _rm version? If so, 
please mark it as such. Is there any way to generate both from the same 
source? The way it's now there is a lot of duplicate code.


Alex

> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_list,	unsigned long npages)
> +{
> +	struct kvmppc_spapr_tce_table *tt = kvmppc_find_tce_table(vcpu, liobn);
> +	long i, ret = H_SUCCESS;
> +	unsigned long tces;
> +	struct page *pg = NULL;
> +
> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	++tt->stat.rm.indir;
> +
> +	/*
> +	 * The spec says that the maximum size of the list is 512 TCEs so
> +	 * so the whole table addressed resides in 4K page
> +	 */
> +	if (npages>  512)
> +		return H_PARAMETER;
> +
> +	if (tce_list&  ~IOMMU_PAGE_MASK)
> +		return H_PARAMETER;
> +
> +	if ((ioba + (npages<<  IOMMU_PAGE_SHIFT))>  tt->window_size)
> +		return H_PARAMETER;
> +
> +	tces = kvmppc_rm_gpa_to_hpa_and_get(vcpu, tce_list,&pg);
> +	if (tces == ERROR_ADDR)
> +		return H_TOO_HARD;
> +
> +	for (i = 0; i<  npages; ++i) {
> +		ret = kvmppc_emulated_validate_tce(((unsigned long *)tces)[i]);
> +		if (ret)
> +			goto put_unlock_exit;
> +	}
> +
> +	for (i = 0; i<  npages; ++i)
> +		kvmppc_emulated_put_tce(tt, ioba + (i<<  IOMMU_PAGE_SHIFT),
> +				((unsigned long *)tces)[i]);
> +
> +put_unlock_exit:
> +	if (!ret&&  pg&&  !PageCompound(pg)&&  realmode_put_page(pg)) {
> +		vcpu->arch.tce_rm_fail = TCERM_PUTLIST;
> +		ret = H_TOO_HARD;
>   	}
>
> -	/* Didn't find the liobn, punt it to userspace */
> -	return H_TOO_HARD;
> +	return ret;
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
> +	if (!tt)
> +		return H_TOO_HARD;
> +
> +	++tt->stat.rm.stuff;
> +
> +	if ((ioba + (npages<<  IOMMU_PAGE_SHIFT))>  tt->window_size)
> +		return H_PARAMETER;
> +
> +	ret = kvmppc_emulated_validate_tce(tce_value);
> +	if (ret || (tce_value&  (TCE_PCI_WRITE | TCE_PCI_READ)))
> +		return H_PARAMETER;
> +
> +	for (i = 0; i<  npages; ++i, ioba += IOMMU_PAGE_SIZE)
> +		kvmppc_emulated_put_tce(tt, ioba, tce_value);
> +
> +	return H_SUCCESS;
>   }
> +#endif /* CONFIG_KVM_BOOK3S_64_HV */
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 550f592..ac41d01 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -567,7 +567,31 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
>   		if (kvmppc_xics_enabled(vcpu)) {
>   			ret = kvmppc_xics_hcall(vcpu, req);
>   			break;
> -		} /* fallthrough */
> +		}
> +		return RESUME_HOST;
> +	case H_PUT_TCE:
> +		ret = kvmppc_vm_h_put_tce(vcpu, kvmppc_get_gpr(vcpu, 4),
> +						kvmppc_get_gpr(vcpu, 5),
> +						kvmppc_get_gpr(vcpu, 6));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_PUT_TCE_INDIRECT:
> +		ret = kvmppc_vm_h_put_tce_indirect(vcpu, kvmppc_get_gpr(vcpu, 4),
> +						kvmppc_get_gpr(vcpu, 5),
> +						kvmppc_get_gpr(vcpu, 6),
> +						kvmppc_get_gpr(vcpu, 7));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_STUFF_TCE:
> +		ret = kvmppc_vm_h_stuff_tce(vcpu, kvmppc_get_gpr(vcpu, 4),
> +						kvmppc_get_gpr(vcpu, 5),
> +						kvmppc_get_gpr(vcpu, 6),
> +						kvmppc_get_gpr(vcpu, 7));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
>   	default:
>   		return RESUME_HOST;
>   	}
> @@ -958,6 +982,20 @@ struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
>   	vcpu->arch.cpu_type = KVM_CPU_3S_64;
>   	kvmppc_sanity_check(vcpu);
>
> +	/*
> +	 * As we want to minimize the chance of having H_PUT_TCE_INDIRECT
> +	 * half executed, we first read TCEs from the user, check them and
> +	 * return error if something went wrong and only then put TCEs into
> +	 * the TCE table.
> +	 *
> +	 * tce_tmp_hpas is a cache for TCEs to avoid stack allocation or
> +	 * kmalloc as the whole TCE list can take up to 512 items 8 bytes
> +	 * each (4096 bytes).
> +	 */
> +	vcpu->arch.tce_tmp_hpas = kmalloc(4096, GFP_KERNEL);
> +	if (!vcpu->arch.tce_tmp_hpas)
> +		goto free_vcpu;
> +
>   	return vcpu;
>
>   free_vcpu:
> @@ -980,6 +1018,7 @@ void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
>   	unpin_vpa(vcpu->kvm,&vcpu->arch.slb_shadow);
>   	unpin_vpa(vcpu->kvm,&vcpu->arch.vpa);
>   	spin_unlock(&vcpu->arch.vpa_update_lock);
> +	kfree(vcpu->arch.tce_tmp_hpas);
>   	kvm_vcpu_uninit(vcpu);
>   	kmem_cache_free(kvm_vcpu_cache, vcpu);
>   }
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index b02f91e..d35554e 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -1490,6 +1490,12 @@ hcall_real_table:
>   	.long	0		/* 0x11c */
>   	.long	0		/* 0x120 */
>   	.long	.kvmppc_h_bulk_remove - hcall_real_table
> +	.long	0		/* 0x128 */
> +	.long	0		/* 0x12c */
> +	.long	0		/* 0x130 */
> +	.long	0		/* 0x134 */
> +	.long	.kvmppc_h_stuff_tce - hcall_real_table
> +	.long	.kvmppc_h_put_tce_indirect - hcall_real_table
>   hcall_real_table_end:
>
>   ignore_hdec:
> diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
> index da0e0bc..edfea88 100644
> --- a/arch/powerpc/kvm/book3s_pr_papr.c
> +++ b/arch/powerpc/kvm/book3s_pr_papr.c
> @@ -220,7 +220,38 @@ static int kvmppc_h_pr_put_tce(struct kvm_vcpu *vcpu)
>   	unsigned long tce = kvmppc_get_gpr(vcpu, 6);
>   	long rc;
>
> -	rc = kvmppc_h_put_tce(vcpu, liobn, ioba, tce);
> +	rc = kvmppc_vm_h_put_tce(vcpu, liobn, ioba, tce);
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
> +	rc = kvmppc_vm_h_put_tce_indirect(vcpu, liobn, ioba,
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
> +	rc = kvmppc_vm_h_stuff_tce(vcpu, liobn, ioba, tce_value, npages);
>   	if (rc == H_TOO_HARD)
>   		return EMULATE_FAIL;
>   	kvmppc_set_gpr(vcpu, 3, rc);
> @@ -247,6 +278,10 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
>   		return kvmppc_h_pr_bulk_remove(vcpu);
>   	case H_PUT_TCE:
>   		return kvmppc_h_pr_put_tce(vcpu);
> +	case H_PUT_TCE_INDIRECT:
> +		return kvmppc_h_pr_put_tce_indirect(vcpu);
> +	case H_STUFF_TCE:
> +		return kvmppc_h_pr_stuff_tce(vcpu);
>   	case H_CEDE:
>   		vcpu->arch.shared->msr |= MSR_EE;
>   		kvm_vcpu_block(vcpu);
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 6316ee3..ccb578b 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -394,6 +394,9 @@ int kvm_dev_ioctl_check_extension(long ext)
>   	case KVM_CAP_PPC_GET_SMMU_INFO:
>   		r = 1;
>   		break;
> +	case KVM_CAP_SPAPR_MULTITCE:
> +		r = 1;
> +		break;
>   #endif
>   	default:
>   		r = 0;

