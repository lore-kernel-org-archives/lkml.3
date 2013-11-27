Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab3K0Ung (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:43:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab3K0Une (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:43:34 -0500
Message-ID: <1385585007.25738.138.camel@ul30vt.home>
Subject: Re: [PATCH v4] KVM: PPC: vfio kvm device: support spapr tce
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Wed, 27 Nov 2013 13:43:27 -0700
In-Reply-To: <1385369342-24423-1-git-send-email-aik@ozlabs.ru>
References: <1385369342-24423-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 19:49 +1100, Alexey Kardashevskiy wrote:
> In addition to the external VFIO user API, a VFIO KVM device
> has been introduced recently.
> 
> sPAPR TCE IOMMU is para-virtualized and the guest does map/unmap
> via hypercalls which take a logical bus id (LIOBN) as a target IOMMU
> identifier. LIOBNs are made up and linked to IOMMU groups by the user
> space. In order to accelerate IOMMU operations in the KVM, we need
> to tell KVM the information about LIOBN-to-group mapping.
> 
> For that, a new KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE_LIOBN parameter
> is added. It accepts a pair of a VFIO group fd and LIOBN.
> 
> This also adds a new kvm_vfio_find_group_by_liobn() function which
> receives kvm struct, LIOBN and a callback. As it increases the IOMMU
> group use counter, the KVMr is required to pass a callback which
> called when the VFIO group is about to be removed VFIO-KVM tracking so
> the KVM is able to call iommu_group_put() to release the IOMMU group.
> 
> The KVM uses kvm_vfio_find_group_by_liobn() once per KVM run and caches
> the result in kvm_arch. iommu_group_put() for all groups will be called
> when KVM finishes (in the SPAPR TCE in KVM enablement patch).
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> Changes:
> v4:
> * fixed few bugs
> * changed kvm_vfio_find_group_by_liobn() to return informative errors
> 
> v3:
> * total rework
> * added a release callback into kvm_vfio_find_group_by_liobn so now
> the user of the API can get a notification if the group is about to
> disappear
> ---
>  Documentation/virtual/kvm/devices/vfio.txt |  19 ++++-
>  arch/powerpc/kvm/Kconfig                   |   1 +
>  arch/powerpc/kvm/Makefile                  |   3 +
>  include/linux/kvm_host.h                   |  18 +++++
>  include/uapi/linux/kvm.h                   |   7 ++
>  virt/kvm/vfio.c                            | 116 ++++++++++++++++++++++++++++-
>  6 files changed, 161 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
> index ef51740..7ecb3b2 100644
> --- a/Documentation/virtual/kvm/devices/vfio.txt
> +++ b/Documentation/virtual/kvm/devices/vfio.txt
> @@ -16,7 +16,22 @@ Groups:
>  
>  KVM_DEV_VFIO_GROUP attributes:
>    KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
> +	kvm_device_attr.addr points to an int32_t file descriptor
> +	for the VFIO group.
> +
>    KVM_DEV_VFIO_GROUP_DEL: Remove a VFIO group from VFIO-KVM device tracking
> +	kvm_device_attr.addr points to an int32_t file descriptor
> +	for the VFIO group.
> +
> +  KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE_LIOBN: sets a liobn for a VFIO group
> +	kvm_device_attr.addr points to a struct:
> +		struct kvm_vfio_spapr_tce_liobn {
> +			__u32	argsz;
> +			__u32	fd;

__s32 per the definition below

> +			__u32	liobn;
> +		};
> +		where
> +		@argsz is a struct size;
> +		@fd is a file descriptor for a VFIO group;
> +		@liobn is a logical bus id to be associated with the group.
>  
> -For each, kvm_device_attr.addr points to an int32_t file descriptor
> -for the VFIO group.
> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
> index 9a50d82..f463958 100644
> --- a/arch/powerpc/kvm/Kconfig
> +++ b/arch/powerpc/kvm/Kconfig
> @@ -60,6 +60,7 @@ config KVM_BOOK3S_64
>  	select KVM_BOOK3S_64_HANDLER
>  	select KVM
>  	select SPAPR_TCE_IOMMU if IOMMU_SUPPORT
> +	select KVM_VFIO
>  	---help---
>  	  Support running unmodified book3s_64 and book3s_32 guest kernels
>  	  in virtual machines on book3s_64 host processors.
> diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
> index 6646c95..2438d2e 100644
> --- a/arch/powerpc/kvm/Makefile
> +++ b/arch/powerpc/kvm/Makefile
> @@ -87,6 +87,9 @@ kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HV) := \
>  kvm-book3s_64-objs-$(CONFIG_KVM_XICS) += \
>  	book3s_xics.o
>  
> +kvm-book3s_64-objs-$(CONFIG_KVM_VFIO) += \
> +	$(KVM)/vfio.o \
> +
>  kvm-book3s_64-module-objs := \
>  	$(KVM)/kvm_main.o \
>  	$(KVM)/eventfd.o \
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 88ff96a..1d2ad5e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1112,5 +1112,23 @@ static inline bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
>  }
>  
>  #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
> +
> +typedef void (*kvm_vfio_release_group_callback)(struct kvm *kvm,
> +		unsigned long liobn);

Seems like a bit of namespace pollution that this is named generically
but is specific to spapr/liobn.  Is this ever needed w/o
CONFIG_SPAPR_TCE_IOMMU?

> +#if defined(CONFIG_KVM_VFIO) && defined(CONFIG_SPAPR_TCE_IOMMU)
> +
> +extern struct iommu_group *kvm_vfio_find_group_by_liobn(struct kvm *kvm,
> +		unsigned long liobn, kvm_vfio_release_group_callback cb);
> +
> +#else
> +
> +static inline struct iommu_group *kvm_vfio_find_group_by_liobn(struct kvm *kvm,
> +		unsigned long liobn, ikvm_vfio_release_group_callback cb)
> +{
> +	return NULL;

The real function returns ERR_PTR(-errno) now, this should too.

> +}
> +#endif /* CONFIG_KVM_VFIO && CONFIG_SPAPR_TCE_IOMMU */

Why isn't this

#ifdef CONFIG_SPAPR_TCE_IOMMU
#ifdef CONFIG_KVM_VFIO
extern...
#else
static inline...
#endif
#endif

?

> +
>  #endif
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 7c1a349..51d5464 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -847,6 +847,13 @@ struct kvm_device_attr {
>  #define  KVM_DEV_VFIO_GROUP			1
>  #define   KVM_DEV_VFIO_GROUP_ADD			1
>  #define   KVM_DEV_VFIO_GROUP_DEL			2
> +#define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE_LIOBN	3
> +
> +struct kvm_vfio_spapr_tce_liobn {
> +	__u32	argsz;
> +	__s32	fd;
> +	__u32	liobn;
> +};
>  
>  /*
>   * ioctls for VM fds
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index ca4260e..ddc945d 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -22,6 +22,12 @@
>  struct kvm_vfio_group {
>  	struct list_head node;
>  	struct vfio_group *vfio_group;
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +	struct {
> +		unsigned long liobn;
> +		kvm_vfio_release_group_callback cb;
> +	} spapr_tce;
> +#endif
>  };
>  
>  struct kvm_vfio {
> @@ -59,6 +65,51 @@ static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
>  	symbol_put(vfio_group_put_external_user);
>  }
>  
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +struct iommu_group *kvm_vfio_find_group_by_liobn(struct kvm *kvm,
> +		unsigned long liobn, kvm_vfio_release_group_callback cb)
> +{
> +	struct kvm_vfio_group *kvg;
> +	int group_id;
> +	struct iommu_group *grp;
> +	struct kvm_vfio *kv = NULL;
> +	struct kvm_device *tmp;
> +
> +	if (!cb)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Find a VFIO KVM device */
> +	list_for_each_entry(tmp, &kvm->devices, vm_node) {
> +		if (tmp->ops != &kvm_vfio_ops)
> +			continue;
> +
> +		kv = tmp->private;
> +		break;
> +	}
> +
> +	if (!kv)
> +		return ERR_PTR(-EIO);
> +

I'm getting tired of noting that this ignores kv->lock...

> +	/* Find a group */
> +	list_for_each_entry(kvg, &kv->group_list, node) {
> +		if (kvg->spapr_tce.liobn != liobn)
> +			continue;
> +
> +		if (kvg->spapr_tce.cb)
> +			return ERR_PTR(-EBUSY);
> +
> +		kvg->spapr_tce.cb = cb;
> +		group_id = vfio_external_user_iommu_id(kvg->vfio_group);
> +		grp = iommu_group_get_by_id(group_id);
> +
> +		return grp;
> +	}
> +
> +	return ERR_PTR(-ENODEV);
> +}
> +EXPORT_SYMBOL_GPL(kvm_vfio_find_group_by_liobn);
> +#endif
> +
>  /*
>   * Groups can use the same or different IOMMU domains.  If the same then
>   * adding a new group may change the coherency of groups we've previously
> @@ -140,7 +191,9 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>  
>  		list_add_tail(&kvg->node, &kv->group_list);
>  		kvg->vfio_group = vfio_group;
> -
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +		kvg->spapr_tce.liobn = -1;
> +#endif
>  		mutex_unlock(&kv->lock);
>  
>  		kvm_vfio_update_coherency(dev);
> @@ -170,6 +223,11 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>  				continue;
>  
>  			list_del(&kvg->node);
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +			if (kvg->spapr_tce.cb)
> +				kvg->spapr_tce.cb(dev->kvm,
> +						kvg->spapr_tce.liobn);
> +#endif
>  			kvm_vfio_group_put_external_user(kvg->vfio_group);
>  			kfree(kvg);
>  			ret = 0;
> @@ -183,6 +241,59 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>  		kvm_vfio_update_coherency(dev);
>  
>  		return ret;
> +
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE_LIOBN: {
> +		struct kvm_vfio_spapr_tce_liobn param;
> +		unsigned long minsz;
> +		struct kvm_vfio *kv = dev->private;
> +		struct vfio_group *vfio_group;
> +		struct kvm_vfio_group *kvg;
> +		struct fd f;
> +
> +		minsz = offsetofend(struct kvm_vfio_spapr_tce_liobn, liobn);
> +
> +		if (copy_from_user(&param, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (param.argsz < minsz)
> +			return -EINVAL;
> +
> +		f = fdget(param.fd);
> +		if (!f.file)
> +			return -EBADF;
> +
> +		vfio_group = kvm_vfio_group_get_external_user(f.file);
> +		fdput(f);
> +
> +		if (IS_ERR(vfio_group))
> +			return PTR_ERR(vfio_group);
> +
> +		ret = -ENOENT;
> +
> +		mutex_lock(&kv->lock);
> +
> +		list_for_each_entry(kvg, &kv->group_list, node) {
> +			if (kvg->vfio_group != vfio_group)
> +				continue;
> +
> +			if (kvg->spapr_tce.liobn != -1) {
> +				ret = -EBUSY;
> +				break;
> +			}
> +
> +			kvg->spapr_tce.liobn = param.liobn;
> +			ret = 0;
> +			break;
> +		}
> +
> +		mutex_unlock(&kv->lock);
> +
> +		kvm_vfio_group_put_external_user(vfio_group);
> +
> +		return ret;
> +	}
> +#endif /* CONFIG_SPAPR_TCE_IOMMU */
>  	}
>  
>  	return -ENXIO;
> @@ -207,6 +318,9 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
>  		switch (attr->attr) {
>  		case KVM_DEV_VFIO_GROUP_ADD:
>  		case KVM_DEV_VFIO_GROUP_DEL:
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
> +		case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE_LIOBN:
> +#endif
>  			return 0;
>  		}
>  



