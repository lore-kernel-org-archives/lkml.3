Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3IHOMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 10:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab3IHOMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 10:12:41 -0400
Date: Sun, 8 Sep 2013 17:12:27 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v10 12/13] KVM: PPC: Add support for IOMMU in-kernel
 handling
Message-ID: <20130908141227.GK17294@redhat.com>
References: <1377679841-3822-1-git-send-email-aik@ozlabs.ru>
 <1378464026-32459-1-git-send-email-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378464026-32459-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 08:40:26PM +1000, Alexey Kardashevskiy wrote:
> This allows the host kernel to handle H_PUT_TCE, H_PUT_TCE_INDIRECT
> and H_STUFF_TCE requests targeted an IOMMU TCE table without passing
> them to user space which saves time on switching to user space and back.
> 
> Both real and virtual modes are supported. The kernel tries to
> handle a TCE request in the real mode, if fails it passes the request
> to the virtual mode to complete the operation. If it a virtual mode
> handler fails, the request is passed to user space.
> 
> The first user of this is VFIO on POWER. Trampolines to the VFIO external
> user API functions are required for this patch.
> 
> This adds a "SPAPR TCE IOMMU" KVM device to associate a logical bus
> number (LIOBN) with an VFIO IOMMU group fd and enable in-kernel handling
> of map/unmap requests. The device supports a single attribute which is
> a struct with LIOBN and IOMMU fd. When the attribute is set, the device
> establishes the connection between KVM and VFIO.
> 
> Tests show that this patch increases transmission speed from 220MB/s
> to 750..1020MB/s on 10Gb network (Chelsea CXGB3 10Gb ethernet card).
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> ---
> 
> Changes:
> v10:
> * all IOMMU TCE links are handled by one KVM device now
> * KVM device has its own list of TCE descriptors
> * the search-by-liobn function was extended to search through
> emulated and IOMMU lists
> 
> v9:
> * KVM_CAP_SPAPR_TCE_IOMMU ioctl to KVM replaced with "SPAPR TCE IOMMU"
> KVM device
> * release_spapr_tce_table() is not shared between different TCE types
> * reduced the patch size by moving KVM device bits and VFIO external API
> trampolines to separate patches
> * moved documentation from Documentation/virtual/kvm/api.txt to
> Documentation/virtual/kvm/devices/spapr_tce_iommu.txt
> 
> v8:
> * fixed warnings from check_patch.pl
> 
> 2013/07/11:
> * removed multiple #ifdef IOMMU_API as IOMMU_API is always enabled
> for KVM_BOOK3S_64
> * kvmppc_gpa_to_hva_and_get also returns host phys address. Not much sense
> for this here but the next patch for hugepages support will use it more.
> 
> 2013/07/06:
> * added realmode arch_spin_lock to protect TCE table from races
> in real and virtual modes
> * POWERPC IOMMU API is changed to support real mode
> * iommu_take_ownership and iommu_release_ownership are protected by
> iommu_table's locks
> * VFIO external user API use rewritten
> * multiple small fixes
> 
> 2013/06/27:
> * tce_list page is referenced now in order to protect it from accident
> invalidation during H_PUT_TCE_INDIRECT execution
> * added use of the external user VFIO API
> 
> 2013/06/05:
> * changed capability number
> * changed ioctl number
> * update the doc article number
> 
> 2013/05/20:
> * removed get_user() from real mode handlers
> * kvm_vcpu_arch::tce_tmp usage extended. Now real mode handler puts there
> translated TCEs, tries realmode_get_page() on those and if it fails, it
> passes control over the virtual mode handler which tries to finish
> the request handling
> * kvmppc_lookup_pte() now does realmode_get_page() protected by BUSY bit
> on a page
> * The only reason to pass the request to user mode now is when the user mode
> did not register TCE table in the kernel, in all other cases the virtual mode
> handler is expected to do the job
> ---
>  .../virtual/kvm/devices/spapr_tce_iommu.txt        |  40 +++
>  arch/powerpc/include/asm/kvm_host.h                |   8 +
>  arch/powerpc/include/uapi/asm/kvm.h                |   5 -
>  arch/powerpc/kvm/book3s_64_vio.c                   | 327 ++++++++++++++++++++-
>  arch/powerpc/kvm/book3s_64_vio_hv.c                | 142 +++++++++
>  arch/powerpc/kvm/powerpc.c                         |   1 +
>  include/linux/kvm_host.h                           |   1 +
>  virt/kvm/kvm_main.c                                |   5 +
>  8 files changed, 517 insertions(+), 12 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/devices/spapr_tce_iommu.txt
> 
> diff --git a/Documentation/virtual/kvm/devices/spapr_tce_iommu.txt b/Documentation/virtual/kvm/devices/spapr_tce_iommu.txt
> new file mode 100644
> index 0000000..b911945
> --- /dev/null
> +++ b/Documentation/virtual/kvm/devices/spapr_tce_iommu.txt
> @@ -0,0 +1,40 @@
> +SPAPR TCE IOMMU device
> +
> +Capability: KVM_CAP_SPAPR_TCE_IOMMU
> +Architectures: powerpc
> +
> +Device type supported: KVM_DEV_TYPE_SPAPR_TCE_IOMMU
> +
> +Groups:
> +  KVM_DEV_SPAPR_TCE_IOMMU_ATTR_LINKAGE
> +  Attributes: one VFIO IOMMU fd per LIOBN, indexed by LIOBN
> +
> +This is completely made up device which provides API to link
> +logical bus number (LIOBN) and IOMMU group. The user space has
> +to create a new SPAPR TCE IOMMU device once per KVM session
> +and use "set_attr" to add or remove a logical bus.
> +
> +LIOBN is a PCI bus identifier from PPC64-server (sPAPR) DMA hypercalls
> +(H_PUT_TCE, H_PUT_TCE_INDIRECT, H_STUFF_TCE).
> +IOMMU group is a minimal isolated device set which can be passed to
> +the user space via VFIO.
> +
> +The userspace adds the new LIOBN-IOMMU link by calling KVM_SET_DEVICE_ATTR
> +with the attribute initialized as shown below:
> +struct kvm_device_attr attr = {
> +	.flags = 0,
> +	.group = KVM_DEV_SPAPR_TCE_IOMMU_ATTR_LINKAGE,
> +	.attr = liobn,
> +	.addr = (uint64_t)(uintptr_t)&group_fd,
> +};
> +
> +To remove the link, the userspace calls KVM_SET_DEVICE_ATTR with
> +the group_fd equal to zero.
> +
Zero is a valid fd descriptor. Lest make it -1.

> +As the device opens VFIO group fds and holds the file pointer,
> +it does not need to keep an fd internally and therefore KVM_GET_DEVICE_ATTR
> +is not supported.
> +
> +When KVM exits, all links are destroyed automatically.
> +
> +The kernel advertises this feature via KVM_CAP_SPAPR_TCE_IOMMU capability.
Why KVM_CAP_SPAPR_TCE_IOMMU is needed? Supported devices are
discoverable without capabilities.

> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index a23f132..a2a481e 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -181,9 +181,15 @@ struct kvmppc_spapr_tce_table {
>  	struct kvm *kvm;
>  	u64 liobn;
>  	u32 window_size;
> +	struct iommu_group *grp;		/* used for IOMMU groups */
> +	struct vfio_group *vfio_grp;		/* used for IOMMU groups */
>  	struct page *pages[0];
>  };
>  
> +struct kvmppc_spapr_tce_iommu_device {
> +	struct list_head tables;
> +};
> +
>  struct kvmppc_linear_info {
>  	void		*base_virt;
>  	unsigned long	 base_pfn;
> @@ -264,6 +270,7 @@ struct kvm_arch {
>  #endif /* CONFIG_KVM_BOOK3S_64_HV */
>  #ifdef CONFIG_PPC_BOOK3S_64
>  	struct list_head spapr_tce_tables;
> +	struct kvmppc_spapr_tce_iommu_device *tcedev;
>  	struct list_head rtas_tokens;
>  #endif
>  #ifdef CONFIG_KVM_MPIC
> @@ -612,6 +619,7 @@ struct kvm_vcpu_arch {
>  	u64 busy_preempt;
>  
>  	unsigned long *tce_tmp_hpas;	/* TCE cache for TCE_PUT_INDIRECT */
> +	unsigned long tce_tmp_num;	/* Number of handled TCEs in cache */
>  	enum {
>  		TCERM_NONE,
>  		TCERM_GETPAGE,
> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
> index c1ae1e5..a9d3d73 100644
> --- a/arch/powerpc/include/uapi/asm/kvm.h
> +++ b/arch/powerpc/include/uapi/asm/kvm.h
> @@ -512,11 +512,6 @@ struct kvm_get_htab_header {
>  #define  KVM_XICS_PENDING		(1ULL << 42)
>  
>  /* SPAPR TCE IOMMU device specification */
> -struct kvm_create_spapr_tce_iommu_linkage {
> -	__u64 liobn;
> -	__u32 fd;
> -	__u32 flags;
> -};
>  #define KVM_DEV_SPAPR_TCE_IOMMU_ATTR_LINKAGE	0
>  
>  #endif /* __LINUX_KVM_POWERPC_H */
> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index 2880d2b..0978794 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c
> @@ -29,6 +29,8 @@
>  #include <linux/anon_inodes.h>
>  #include <linux/module.h>
>  #include <linux/vfio.h>
> +#include <linux/iommu.h>
> +#include <linux/file.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/kvm_ppc.h>
> @@ -158,10 +160,8 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>  	int i;
>  
>  	/* Check this LIOBN hasn't been previously allocated */
> -	list_for_each_entry(stt, &kvm->arch.spapr_tce_tables, list) {
> -		if (stt->liobn == args->liobn)
> -			return -EBUSY;
> -	}
> +	if (kvmppc_find_tce_table(kvm, args->liobn))
> +		return -EBUSY;
>  
>  	npages = kvmppc_stt_npages(args->window_size);
>  
> @@ -201,9 +201,175 @@ fail:
>  	return ret;
>  }
>  
> -/* Converts guest physical address to host virtual address */
> +static void kvmppc_spapr_tce_iommu_table_destroy(
> +		struct kvm_device *dev,
> +		struct kvmppc_spapr_tce_table *tt)
> +{
> +	struct kvm *kvm = dev->kvm;
> +
> +	mutex_lock(&kvm->lock);
> +	list_del(&tt->list);
> +
> +	if (tt->vfio_grp)
> +		kvmppc_vfio_group_put_external_user(tt->vfio_grp);
> +	iommu_group_put(tt->grp);
> +
> +	kfree(tt);
> +	mutex_unlock(&kvm->lock);
> +}
> +
> +static int kvmppc_spapr_tce_iommu_create(struct kvm_device *dev, u32 type)
> +{
> +	struct kvmppc_spapr_tce_iommu_device *tcedev;
> +	int ret = 0;
> +
> +	tcedev = kzalloc(sizeof(*tcedev), GFP_KERNEL);
> +	if (!tcedev)
> +		return -ENOMEM;
> +	dev->private = tcedev;
> +
> +	INIT_LIST_HEAD(&tcedev->tables);
> +
> +	/* Already there ? */
> +	mutex_lock(&dev->kvm->lock);
> +	if (dev->kvm->arch.tcedev)
> +		ret = -EEXIST;
> +	else
> +		dev->kvm->arch.tcedev = tcedev;
> +	mutex_unlock(&dev->kvm->lock);
> +
> +	if (ret)
Need to free tcedev here.

> +		return ret;
> +
> +	return 0;
> +}
> +

--
			Gleb.
