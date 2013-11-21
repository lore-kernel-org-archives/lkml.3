Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3KUBXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 20:23:01 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57214 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3KUBW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 20:22:58 -0500
Message-ID: <528D6065.3030400@ozlabs.ru>
Date: Thu, 21 Nov 2013 12:22:45 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3] KVM: PPC: vfio kvm device: support spapr tce
References: <1384924730-22762-1-git-send-email-aik@ozlabs.ru> <1384981031.2879.389.camel@ul30vt.home>
In-Reply-To: <1384981031.2879.389.camel@ul30vt.home>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 07:57 AM, Alex Williamson wrote:
> On Wed, 2013-11-20 at 16:18 +1100, Alexey Kardashevskiy wrote:
>> In addition to the external VFIO user API, a VFIO KVM device
>> has been introduced recently.
>>
>> sPAPR TCE IOMMU is para-virtualized and the guest does map/unmap
>> via hypercalls which take a logical bus id (LIOBN) as a target IOMMU
>> identifier. LIOBNs are made up and linked to IOMMU groups by the user
>> space. In order to accelerate IOMMU operations in the KVM, we need
>> to tell KVM the information about LIOBN-to-group mapping.
>>
>> For that, a new KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE_LIOBN parameter
>> is added. It accepts a pair of a VFIO group fd and LIOBN.
>>
>> This also adds a new kvm_vfio_find_group_by_liobn() function which
>> receives kvm struct, LIOBN and a callback. As it increases the IOMMU
>> group use counter, the KVMr is required to pass a callback which
>> called when the VFIO group is about to be removed VFIO-KVM tracking so
>> the KVM is able to call iommu_group_put() to release the IOMMU group.
>>
>> The KVM uses kvm_vfio_find_group_by_liobn() once per KVM run and caches
>> the result in kvm_arch. iommu_group_put() for all groups will be called
>> when KVM finishes (in the SPAPR TCE in KVM enablement patch).
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>> Changes:
>> v3:
>> * total rework
>> * added a release callback into kvm_vfio_find_group_by_liobn so now
>> the user of the API can get a notification if the group is about to
>> disappear
>> ---
>>  Documentation/virtual/kvm/devices/vfio.txt |  19 ++++-
>>  arch/powerpc/kvm/Kconfig                   |   1 +
>>  arch/powerpc/kvm/Makefile                  |   3 +
>>  include/linux/kvm_host.h                   |  18 +++++
>>  include/uapi/linux/kvm.h                   |   7 ++
>>  virt/kvm/vfio.c                            | 116 ++++++++++++++++++++++++++++-
>>  6 files changed, 161 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
>> index ef51740..7ecb3b2 100644
>> --- a/Documentation/virtual/kvm/devices/vfio.txt
>> +++ b/Documentation/virtual/kvm/devices/vfio.txt
>> @@ -16,7 +16,22 @@ Groups:
>>  
>>  KVM_DEV_VFIO_GROUP attributes:
>>    KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
>> +	kvm_device_attr.addr points to an int32_t file descriptor
>> +	for the VFIO group.
>> +
>>    KVM_DEV_VFIO_GROUP_DEL: Remove a VFIO group from VFIO-KVM device tracking
>> +	kvm_device_attr.addr points to an int32_t file descriptor
>> +	for the VFIO group.
>> +
>> +  KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE_LIOBN: sets a liobn for a VFIO group
>> +	kvm_device_attr.addr points to a struct:
>> +		struct kvm_vfio_spapr_tce_liobn {
>> +			__u32	argsz;
>> +			__u32	fd;
> 
> fds are signed, __s32
> 
>> +			__u32	liobn;
>> +		};
>> +		where
>> +		@argsz is a struct size;
>> +		@fd is a file descriptor for a VFIO group;
>> +		@liobn is a logical bus id to be associated with the group.
>>  
>> -For each, kvm_device_attr.addr points to an int32_t file descriptor
>> -for the VFIO group.
>> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
>> index 61b3535..d1b7f64 100644
>> --- a/arch/powerpc/kvm/Kconfig
>> +++ b/arch/powerpc/kvm/Kconfig
>> @@ -60,6 +60,7 @@ config KVM_BOOK3S_64
>>  	select KVM_BOOK3S_64_HANDLER
>>  	select KVM
>>  	select SPAPR_TCE_IOMMU
>> +	select KVM_VFIO
>>  	---help---
>>  	  Support running unmodified book3s_64 and book3s_32 guest kernels
>>  	  in virtual machines on book3s_64 host processors.
>> diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
>> index 6646c95..2438d2e 100644
>> --- a/arch/powerpc/kvm/Makefile
>> +++ b/arch/powerpc/kvm/Makefile
>> @@ -87,6 +87,9 @@ kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HV) := \
>>  kvm-book3s_64-objs-$(CONFIG_KVM_XICS) += \
>>  	book3s_xics.o
>>  
>> +kvm-book3s_64-objs-$(CONFIG_KVM_VFIO) += \
>> +	$(KVM)/vfio.o \
>> +
>>  kvm-book3s_64-module-objs := \
>>  	$(KVM)/kvm_main.o \
>>  	$(KVM)/eventfd.o \
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 88ff96a..1d2ad5e 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -1112,5 +1112,23 @@ static inline bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
>>  }
>>  
>>  #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
>> +
>> +typedef void (*kvm_vfio_release_group_callback)(struct kvm *kvm,
>> +		unsigned long liobn);
> 
> liobn was said to be __u32 in kvm_vfio_spapr_tce_liobn above, here it's
> unsigned long?


PAPR spec says it is 32 bit and kvm_vfio_spapr_tce_liobn is a binary
interface (ABI?) so I want it to be precise.

However kvmppc_get_gpr() (used to parse hypercall parameters such as liobn)
return unsigned long. So inside the kernel I use unsigned long.

So what does make sense to change here?


> 
>> +
>> +#if defined(CONFIG_KVM_VFIO) && defined(CONFIG_SPAPR_TCE_IOMMU)
>> +
>> +extern struct iommu_group *kvm_vfio_find_group_by_liobn(struct kvm *kvm,
>> +		unsigned long liobn, kvm_vfio_release_group_callback cb);
>> +
>> +#else
>> +
>> +static inline struct iommu_group *kvm_vfio_find_group_by_liobn(struct kvm *kvm,
>> +		unsigned long liobn, ikvm_vfio_release_group_callback cb)
>> +{
>> +	return NULL;
>> +}
>> +#endif /* CONFIG_KVM_VFIO && CONFIG_SPAPR_TCE_IOMMU */
>> +
>>  #endif
>>  
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 7c1a349..3d77dde 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -847,6 +847,13 @@ struct kvm_device_attr {
>>  #define  KVM_DEV_VFIO_GROUP			1
>>  #define   KVM_DEV_VFIO_GROUP_ADD			1
>>  #define   KVM_DEV_VFIO_GROUP_DEL			2
>> +#define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE_LIOBN	3
>> +
>> +struct kvm_vfio_spapr_tce_liobn {
>> +	__u32	argsz;
>> +	__u32	fd;
>> +	__u32	liobn;
>> +};
>>  
>>  /*
>>   * ioctls for VM fds
>> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
>> index ca4260e..448910d 100644
>> --- a/virt/kvm/vfio.c
>> +++ b/virt/kvm/vfio.c
>> @@ -22,6 +22,12 @@
>>  struct kvm_vfio_group {
>>  	struct list_head node;
>>  	struct vfio_group *vfio_group;
>> +#ifdef CONFIG_SPAPR_TCE_IOMMU
>> +	struct {
>> +		unsigned long liobn;
>> +		kvm_vfio_release_group_callback cb;
>> +	} spapr_tce;
>> +#endif
>>  };
>>  
>>  struct kvm_vfio {
>> @@ -59,6 +65,51 @@ static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
>>  	symbol_put(vfio_group_put_external_user);
>>  }
>>  
>> +#ifdef CONFIG_SPAPR_TCE_IOMMU
>> +struct iommu_group *kvm_vfio_find_group_by_liobn(struct kvm *kvm,
>> +		unsigned long liobn, kvm_vfio_release_group_callback cb)
>> +{
>> +	struct kvm_vfio_group *kvg;
>> +	int group_id;
>> +	struct iommu_group *grp;
>> +	struct kvm_vfio *kv = NULL;
>> +	struct kvm_device *tmp;
>> +
>> +	if (!cb)
>> +		return NULL;
> 
> Is it worthwhile to use ERR_PTR(-EINVAL) here and the caller can use
> IS_ERR()?
> 
>> +
>> +	/* Find a VFIO KVM device */
>> +	list_for_each_entry(tmp, &kvm->devices, vm_node) {
>> +		if (tmp->ops != &kvm_vfio_ops)
>> +			continue;
>> +
>> +		kv = tmp->private;
>> +		break;
>> +	}
>> +
>> +	if (!kv)
>> +		return NULL;
> 
> ERR_PTR(-EFAULT)?  EIO?
> 
>> +
>> +	/* Find a group */
> 
> Still ignoring kv->lock
> 
>> +	list_for_each_entry(kvg, &kv->group_list, node) {
>> +		if (kvg->spapr_tce.liobn != liobn)
>> +			continue;
>> +
>> +		if (kvg->spapr_tce.cb)
>> +			return NULL;
> 
> ERR_PTR(-EBUSY)?
> 
>> +
>> +		kvg->spapr_tce.cb = cb;
>> +		group_id = vfio_external_user_iommu_id(kvg->vfio_group);
>> +		grp = iommu_group_get_by_id(group_id);
>> +
>> +		return grp;
>> +	}
>> +
>> +	return NULL;
> 
> ERR_PTR(-ENODEV)?
> 
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_vfio_find_group_by_liobn);
>> +#endif
>> +
>>  /*
>>   * Groups can use the same or different IOMMU domains.  If the same then
>>   * adding a new group may change the coherency of groups we've previously
>> @@ -170,6 +221,11 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>>  				continue;
>>  
>>  			list_del(&kvg->node);
>> +#ifdef CONFIG_SPAPR_TCE_IOMMU
>> +			if (kvg->spapr_tce.cb)
>> +				kvg->spapr_tce.cb(dev->kvm,
>> +						kvg->spapr_tce.liobn);
>> +#endif
>>  			kvm_vfio_group_put_external_user(kvg->vfio_group);
>>  			kfree(kvg);
>>  			ret = 0;
>> @@ -183,6 +239,62 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
>>  		kvm_vfio_update_coherency(dev);
>>  
>>  		return ret;
>> +
>> +#ifdef CONFIG_SPAPR_TCE_IOMMU
>> +	case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE_LIOBN: {
>> +		struct kvm_vfio_spapr_tce_liobn param;
>> +		unsigned long minsz;
>> +		struct kvm_vfio *kv = dev->private;
>> +		struct vfio_group *vfio_group;
>> +		struct kvm_vfio_group *kvg;
>> +		struct fd f;
>> +
>> +		minsz = offsetofend(struct kvm_vfio_spapr_tce_liobn, liobn);
>> +
>> +		if (copy_from_user(&param, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (param.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		if (copy_from_user(&param, (void __user *)arg, minsz))
>> +			return -EFAULT;
> 
> copy_from_user twice?  Extra copy here?


Oh. All I wanted was to read minsz first but I cut-n-pasted too blindely :)

> 
>> +
>> +		f = fdget(param.fd);
>> +		if (!f.file)
>> +			return -EBADF;
>> +
>> +		vfio_group = kvm_vfio_group_get_external_user(f.file);
>> +		fdput(f);
>> +
>> +		if (IS_ERR(vfio_group))
>> +			return PTR_ERR(vfio_group);
>> +
>> +		ret = -ENOENT;
>> +
>> +		mutex_lock(&kv->lock);
>> +
>> +		list_for_each_entry(kvg, &kv->group_list, node) {
>> +			if (kvg->vfio_group != vfio_group)
>> +				continue;
>> +
>> +			if (kvg->spapr_tce.liobn) {
>> +				ret = -EBUSY;
>> +				break;
>> +			}
> 
> Is zero not an liobn that can be used by userspace?

Good point, thanks. I thought zero cannot be used but by spec -1 is reserved


>  Is it intentional
> that there's no way to unset or change the group/liobn mapping?  Thanks,


I do not see why we would want to disable once enabled acceleration. Group
removal should clear it though so we are good.

Thanks for the review and patience :)


> 
> Alex
> 
>> +
>> +			kvg->spapr_tce.liobn = param.liobn;
>> +			ret = 0;
>> +			break;
>> +		}
>> +
>> +		mutex_unlock(&kv->lock);
>> +
>> +		kvm_vfio_group_put_external_user(vfio_group);
>> +
>> +		return ret;
>> +	}
>> +#endif /* CONFIG_SPAPR_TCE_IOMMU */
>>  	}
>>  
>>  	return -ENXIO;
>> @@ -207,9 +319,11 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
>>  		switch (attr->attr) {
>>  		case KVM_DEV_VFIO_GROUP_ADD:
>>  		case KVM_DEV_VFIO_GROUP_DEL:
>> +#ifdef CONFIG_SPAPR_TCE_IOMMU
>> +		case KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE_LIOBN:
>> +#endif
>>  			return 0;
>>  		}
>> -
>>  		break;
>>  	}
>>  
> 
> 
> 


-- 
Alexey
