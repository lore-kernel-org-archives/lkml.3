Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3GIX3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:29:39 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51181 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3GIX3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:29:37 -0400
Message-ID: <51DC9CDA.3070906@ozlabs.ru>
Date: Wed, 10 Jul 2013 09:29:30 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 8/8] KVM: PPC: Add hugepage support for IOMMU in-kernel
 handling
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru> <1373123227-22969-9-git-send-email-aik@ozlabs.ru> <51DC4923.5010501@suse.de>
In-Reply-To: <51DC4923.5010501@suse.de>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 03:32 AM, Alexander Graf wrote:
> On 07/06/2013 05:07 PM, Alexey Kardashevskiy wrote:
>> This adds special support for huge pages (16MB).  The reference
>> counting cannot be easily done for such pages in real mode (when
>> MMU is off) so we added a list of huge pages.  It is populated in
>> virtual mode and get_page is called just once per a huge page.
>> Real mode handlers check if the requested page is huge and in the list,
>> then no reference counting is done, otherwise an exit to virtual mode
>> happens.  The list is released at KVM exit.  At the moment the fastest
>> card available for tests uses up to 9 huge pages so walking through this
>> list is not very expensive.  However this can change and we may want
>> to optimize this.
>>
>> Signed-off-by: Paul Mackerras<paulus@samba.org>
>> Signed-off-by: Alexey Kardashevskiy<aik@ozlabs.ru>
>>
>> ---
>>
>> Changes:
>> 2013/06/27:
>> * list of huge pages replaces with hashtable for better performance
> 
> So the only thing your patch description really talks about is not true
> anymore?
> 
>> * spinlock removed from real mode and only protects insertion of new
>> huge [ages descriptors into the hashtable
>>
>> 2013/06/05:
>> * fixed compile error when CONFIG_IOMMU_API=n
>>
>> 2013/05/20:
>> * the real mode handler now searches for a huge page by gpa (used to be pte)
>> * the virtual mode handler prints warning if it is called twice for the same
>> huge page as the real mode handler is expected to fail just once - when a
>> huge
>> page is not in the list yet.
>> * the huge page is refcounted twice - when added to the hugepage list and
>> when used in the virtual mode hcall handler (can be optimized but it will
>> make the patch less nice).
>>
>> Signed-off-by: Alexey Kardashevskiy<aik@ozlabs.ru>
>> ---
>>   arch/powerpc/include/asm/kvm_host.h |  25 +++++++++
>>   arch/powerpc/kernel/iommu.c         |   6 ++-
>>   arch/powerpc/kvm/book3s_64_vio.c    | 104
>> +++++++++++++++++++++++++++++++++---
>>   arch/powerpc/kvm/book3s_64_vio_hv.c |  21 ++++++--
>>   4 files changed, 146 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/kvm_host.h
>> b/arch/powerpc/include/asm/kvm_host.h
>> index 53e61b2..a7508cf 100644
>> --- a/arch/powerpc/include/asm/kvm_host.h
>> +++ b/arch/powerpc/include/asm/kvm_host.h
>> @@ -30,6 +30,7 @@
>>   #include<linux/kvm_para.h>
>>   #include<linux/list.h>
>>   #include<linux/atomic.h>
>> +#include<linux/hashtable.h>
>>   #include<asm/kvm_asm.h>
>>   #include<asm/processor.h>
>>   #include<asm/page.h>
>> @@ -182,10 +183,34 @@ struct kvmppc_spapr_tce_table {
>>       u32 window_size;
>>       struct iommu_group *grp;        /* used for IOMMU groups */
>>       struct vfio_group *vfio_grp;        /* used for IOMMU groups */
>> +    DECLARE_HASHTABLE(hash_tab, ilog2(64));    /* used for IOMMU groups */
>> +    spinlock_t hugepages_write_lock;    /* used for IOMMU groups */
>>       struct { struct { unsigned long put, indir, stuff; } rm, vm; } stat;
>>       struct page *pages[0];
>>   };
>>
>> +/*
>> + * The KVM guest can be backed with 16MB pages.
>> + * In this case, we cannot do page counting from the real mode
>> + * as the compound pages are used - they are linked in a list
>> + * with pointers as virtual addresses which are inaccessible
>> + * in real mode.
>> + *
>> + * The code below keeps a 16MB pages list and uses page struct
>> + * in real mode if it is already locked in RAM and inserted into
>> + * the list or switches to the virtual mode where it can be
>> + * handled in a usual manner.
>> + */
>> +#define KVMPPC_SPAPR_HUGEPAGE_HASH(gpa)    hash_32(gpa>>  24, 32)
>> +
>> +struct kvmppc_spapr_iommu_hugepage {
>> +    struct hlist_node hash_node;
>> +    unsigned long gpa;    /* Guest physical address */
>> +    unsigned long hpa;    /* Host physical address */
>> +    struct page *page;    /* page struct of the very first subpage */
>> +    unsigned long size;    /* Huge page size (always 16MB at the moment) */
>> +};
>> +
>>   struct kvmppc_linear_info {
>>       void        *base_virt;
>>       unsigned long     base_pfn;
>> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
>> index 51678ec..e0b6eca 100644
>> --- a/arch/powerpc/kernel/iommu.c
>> +++ b/arch/powerpc/kernel/iommu.c
>> @@ -999,7 +999,8 @@ int iommu_free_tces(struct iommu_table *tbl, unsigned
>> long entry,
>>               if (!pg) {
>>                   ret = -EAGAIN;
>>               } else if (PageCompound(pg)) {
>> -                ret = -EAGAIN;
>> +                /* Hugepages will be released at KVM exit */
>> +                ret = 0;
>>               } else {
>>                   if (oldtce&  TCE_PCI_WRITE)
>>                       SetPageDirty(pg);
>> @@ -1009,6 +1010,9 @@ int iommu_free_tces(struct iommu_table *tbl,
>> unsigned long entry,
>>               struct page *pg = pfn_to_page(oldtce>>  PAGE_SHIFT);
>>               if (!pg) {
>>                   ret = -EAGAIN;
>> +            } else if (PageCompound(pg)) {
>> +                /* Hugepages will be released at KVM exit */
>> +                ret = 0;
>>               } else {
>>                   if (oldtce&  TCE_PCI_WRITE)
>>                       SetPageDirty(pg);
>> diff --git a/arch/powerpc/kvm/book3s_64_vio.c
>> b/arch/powerpc/kvm/book3s_64_vio.c
>> index 2b51f4a..c037219 100644
>> --- a/arch/powerpc/kvm/book3s_64_vio.c
>> +++ b/arch/powerpc/kvm/book3s_64_vio.c
>> @@ -46,6 +46,40 @@
>>
>>   #define ERROR_ADDR      ((void *)~(unsigned long)0x0)
>>
>> +#ifdef CONFIG_IOMMU_API
> 
> Can't you just make CONFIG_IOMMU_API mandatory in Kconfig?


Sure I can. I can do anything. Why should I? Do I have to do that to get
this accepted? I do not understand this comment. It has already been
discussed how to enable this option.


>> +static void kvmppc_iommu_hugepages_init(struct kvmppc_spapr_tce_table *tt)
>> +{
>> +    spin_lock_init(&tt->hugepages_write_lock);
>> +    hash_init(tt->hash_tab);
>> +}
>> +
>> +static void kvmppc_iommu_hugepages_cleanup(struct kvmppc_spapr_tce_table
>> *tt)
>> +{
>> +    int bkt;
>> +    struct kvmppc_spapr_iommu_hugepage *hp;
>> +    struct hlist_node *tmp;
>> +
>> +    spin_lock(&tt->hugepages_write_lock);
>> +    hash_for_each_safe(tt->hash_tab, bkt, tmp, hp, hash_node) {
>> +        pr_debug("Release HP liobn=%llx #%u gpa=%lx hpa=%lx size=%ld\n",
>> +                tt->liobn, bkt, hp->gpa, hp->hpa, hp->size);
> 
> trace point
> 
>> +        hlist_del_rcu(&hp->hash_node);
>> +
>> +        put_page(hp->page);
> 
> Don't you have to mark them dirty?


get_user_pages_fast is called with writing==1. Does not it do the same?

> 
>> +        kfree(hp);
>> +    }
>> +    spin_unlock(&tt->hugepages_write_lock);
>> +}
>> +#else
>> +static void kvmppc_iommu_hugepages_init(struct kvmppc_spapr_tce_table *tt)
>> +{
>> +}
>> +
>> +static void kvmppc_iommu_hugepages_cleanup(struct kvmppc_spapr_tce_table
>> *tt)
>> +{
>> +}
>> +#endif /* CONFIG_IOMMU_API */
>> +
>>   static long kvmppc_stt_npages(unsigned long window_size)
>>   {
>>       return ALIGN((window_size>>  SPAPR_TCE_SHIFT)
>> @@ -112,6 +146,7 @@ static void release_spapr_tce_table(struct
>> kvmppc_spapr_tce_table *stt)
>>
>>       mutex_lock(&kvm->lock);
>>       list_del(&stt->list);
>> +    kvmppc_iommu_hugepages_cleanup(stt);
>>
>>   #ifdef CONFIG_IOMMU_API
>>       if (stt->grp) {
>> @@ -200,6 +235,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>>       kvm_get_kvm(kvm);
>>
>>       mutex_lock(&kvm->lock);
>> +    kvmppc_iommu_hugepages_init(stt);
>>       list_add(&stt->list,&kvm->arch.spapr_tce_tables);
>>
>>       mutex_unlock(&kvm->lock);
>> @@ -283,6 +319,7 @@ long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm
>> *kvm,
>>
>>       kvm_get_kvm(kvm);
>>       mutex_lock(&kvm->lock);
>> +    kvmppc_iommu_hugepages_init(tt);
>>       list_add(&tt->list,&kvm->arch.spapr_tce_tables);
>>       mutex_unlock(&kvm->lock);
>>
>> @@ -307,10 +344,17 @@ long kvm_vm_ioctl_create_spapr_tce_iommu(struct kvm
>> *kvm,
>>
>>   /* Converts guest physical address to host virtual address */
>>   static void __user *kvmppc_vm_gpa_to_hva_and_get(struct kvm_vcpu *vcpu,
>> +        struct kvmppc_spapr_tce_table *tt,
>>           unsigned long gpa, struct page **pg, unsigned long *hpa)
>>   {
>>       unsigned long hva, gfn = gpa>>  PAGE_SHIFT;
>>       struct kvm_memory_slot *memslot;
>> +#ifdef CONFIG_IOMMU_API
>> +    struct kvmppc_spapr_iommu_hugepage *hp;
>> +    unsigned key = KVMPPC_SPAPR_HUGEPAGE_HASH(gpa);
>> +    pte_t *ptep;
>> +    unsigned int shift = 0;
>> +#endif
>>
>>       memslot = search_memslots(kvm_memslots(vcpu->kvm), gfn);
>>       if (!memslot)
>> @@ -325,6 +369,54 @@ static void __user
>> *kvmppc_vm_gpa_to_hva_and_get(struct kvm_vcpu *vcpu,
>>           *hpa = __pa((unsigned long) page_address(*pg)) +
>>                   (hva&  ~PAGE_MASK);
>>
>> +#ifdef CONFIG_IOMMU_API
> 
> This function is becoming incredibly large. Please split it up. Also please
> document the code.


Less than 100 lines is incredibly large? There are _many_ functions bigger
than that. I do not really see the point in making a separate function
which is going to be called only once.





-- 
Alexey
