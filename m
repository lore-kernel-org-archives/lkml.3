Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161171Ab3BODye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 22:54:34 -0500
Received: from ozlabs.org ([203.10.76.45]:43815 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935333Ab3BODy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 22:54:29 -0500
Date: Fri, 15 Feb 2013 14:54:00 +1100
From: Paul Mackerras <paulus@samba.org>
To: aik@ozlabs.ru
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 4/4] vfio powerpc: added real mode support
Message-ID: <20130215035400.GD25015@drongo>
References: <1360584763-21988-1-git-send-email-a>
 <5118e071.22ca320a.1f08.ffffe2f4@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5118e071.22ca320a.1f08.ffffe2f4@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 11:12:43PM +1100, aik@ozlabs.ru wrote:
> From: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> The patch allows the host kernel to handle H_PUT_TCE request
> without involving QEMU in it what should save time on switching
> from the kernel to QEMU and back.
> 
> The patch adds an IOMMU ID parameter into the KVM_CAP_SPAPR_TCE ioctl,
> QEMU needs to be fixed to support that.
> 
> At the moment H_PUT_TCE is processed in the virtual mode as the page
> to be mapped may not be present in the RAM so paging may be involved as
> it can be done from the virtual mode only.
> 
> Tests show that this patch increases tranmission speed from 220MB/s
> to 750..1020MB/s on 10Gb network (Chelsea CXGB3 10Gb ethernet card).
[snip]
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index b4fdabc..acb9cdc 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -47,6 +47,8 @@
>  #include <asm/fadump.h>
>  #include <asm/vio.h>
>  #include <asm/tce.h>
> +#include <asm/kvm_book3s_64.h>
> +#include <asm/page.h>
>  
>  #define DBG(...)
>  
> @@ -727,6 +729,7 @@ void iommu_register_group(struct iommu_table * tbl,
>  		return;
>  	}
>  	tbl->it_group = grp;
> +	INIT_LIST_HEAD(&tbl->it_hugepages);
>  	iommu_group_set_iommudata(grp, tbl, group_release);
>  	iommu_group_set_name(grp, kasprintf(GFP_KERNEL, "domain%d-pe%lx",
>  			domain_number, pe_num));
> @@ -906,6 +909,83 @@ void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
>  {
>  }
>  
> +/*
> + * The KVM guest can be backed with 16MB pages (qemu switch
> + * -mem-path /var/lib/hugetlbfs/global/pagesize-16MB/).
> + * In this case, we cannot do page counting from the real mode
> + * as the compound pages are used - they are linked in a list
> + * with pointers as virtual addresses which are inaccessible
> + * in real mode.
> + *
> + * The code below keeps a 16MB pages list and uses page struct
> + * in real mode if it is already locked in RAM and inserted into
> + * the list or switches to the virtual mode where it can be
> + * handled in a usual manner.
> + */
> +struct iommu_kvmppc_hugepages {
> +	struct list_head list;
> +	pte_t pte;		/* Huge page PTE */
> +	unsigned long pa;	/* Base phys address used as a real TCE */
> +	struct page *page;	/* page struct of the very first subpage */
> +	unsigned long size;	/* Huge page size (always 16MB at the moment) */
> +	bool dirty;		/* Dirty bit */
> +};
> +
> +static struct iommu_kvmppc_hugepages *find_hp_by_pte(struct iommu_table *tbl,
> +		pte_t pte)
> +{
> +	struct iommu_kvmppc_hugepages *hp;
> +
> +	list_for_each_entry(hp, &tbl->it_hugepages, list) {
> +		if (hp->pte == pte)
> +			return hp;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct iommu_kvmppc_hugepages *find_hp_by_pa(struct iommu_table *tbl,
> +		unsigned long pa)
> +{
> +	struct iommu_kvmppc_hugepages *hp;
> +
> +	list_for_each_entry(hp, &tbl->it_hugepages, list) {
> +		if ((hp->pa <= pa) && (pa < hp->pa + hp->size))
> +			return hp;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct iommu_kvmppc_hugepages *add_hp(struct iommu_table *tbl,
> +		pte_t pte, unsigned long va, unsigned long pg_size)
> +{
> +	int ret;
> +	struct iommu_kvmppc_hugepages *hp;
> +
> +	hp = kzalloc(sizeof(*hp), GFP_KERNEL);
> +	if (!hp)
> +		return NULL;
> +
> +	hp->pte = pte;
> +	va = va & ~(pg_size - 1);
> +	ret = get_user_pages_fast(va, 1, true/*write*/, &hp->page);
> +	if ((ret != 1) || !hp->page) {
> +		kfree(hp);
> +		return NULL;
> +	}
> +#if defined(HASHED_PAGE_VIRTUAL) || defined(WANT_PAGE_VIRTUAL)
> +#error TODO: fix to avoid page_address() here
> +#endif
> +	hp->pa = __pa((unsigned long) page_address(hp->page));
> +
> +	hp->size = pg_size;
> +
> +	list_add(&hp->list, &tbl->it_hugepages);
> +
> +	return hp;
> +}

I don't see any locking here.  What stops one cpu doing add_hp() from
racing with another doing find_hp_by_pte() or find_hp_by_pa()?

[snip]
> @@ -1021,6 +1123,24 @@ long iommu_clear_tce_user_mode(struct iommu_table *tbl, unsigned long ioba,
>  }
>  EXPORT_SYMBOL_GPL(iommu_clear_tce_user_mode);
>  
> +long iommu_clear_tce_real_mode(struct iommu_table *tbl, unsigned long ioba,
> +		unsigned long tce_value, unsigned long npages)
> +{
> +	long ret;
> +	unsigned long entry = ioba >> IOMMU_PAGE_SHIFT;
> +
> +	ret = tce_clear_param_check(tbl, ioba, tce_value, npages);
> +	if (!ret)
> +		ret = clear_tce(tbl, true, entry, npages);
> +
> +	if (ret < 0)
> +		pr_err("iommu_tce: %s failed ioba=%lx, tce_value=%lx ret=%ld\n",
> +				__func__, ioba, tce_value, ret);

Better to avoid printk in real mode if at all possible, particularly
if they're guest-triggerable.

[snip]
> @@ -195,15 +225,43 @@ long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
>  	if (!stt)
>  		return H_TOO_HARD;
>  
> +	if (stt->virtmode_only)
> +		return H_TOO_HARD;
> +
>  	tces = (void *) get_real_address(vcpu, tce_list, false, NULL, NULL);
>  	if (!tces)
>  		return H_TOO_HARD;
>  
>  	/* Emulated IO */
> -	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
> -		ret = emulated_h_put_tce(stt, ioba, tces[i]);
> +	if (!stt->tbl) {
> +		for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
> +			ret = emulated_h_put_tce(stt, ioba, tces[i]);
> +
> +		return ret;
> +	}
> +
> +	/* VFIO IOMMU */
> +	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE) {
> +		unsigned long hpa, pg_size = 0;
> +		pte_t pte = 0;
> +
> +		hpa = get_real_address(vcpu, tces[i], tces[i] & TCE_PCI_WRITE,
> +				&pte, &pg_size);
> +		if (!hpa)
> +			return H_TOO_HARD;
> +
> +		ret = iommu_put_tce_real_mode(stt->tbl,
> +				ioba, hpa, pte, pg_size);

If we get a failure part-way through, should we go back and remove the
entries we put in?

[snip]
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 26e2b271..3727ea6 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -863,6 +863,7 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
>  /* Available with KVM_CAP_PPC_HTAB_FD */
>  #define KVM_PPC_GET_HTAB_FD	  _IOW(KVMIO,  0xaa, struct kvm_get_htab_fd)
> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xaf, struct kvm_create_spapr_tce_iommu)

This needs an entry in Documentation/virtual/kvm/api.txt.

Paul.
