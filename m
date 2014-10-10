Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaJJSdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:33:36 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49987 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaJJSdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:33:35 -0400
Message-ID: <5438267B.3080901@ozlabs.ru>
Date: Fri, 10 Oct 2014 20:33:31 +0200
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 13/13] vfio: powerpc/spapr: Enable Dynamic DMA windows
References: <1411441262-11025-1-git-send-email-aik@ozlabs.ru>	 <1411441262-11025-14-git-send-email-aik@ozlabs.ru> <1411509370.24563.35.camel@ul30vt.home>
In-Reply-To: <1411509370.24563.35.camel@ul30vt.home>
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 11:56 PM, Alex Williamson wrote:
> On Tue, 2014-09-23 at 13:01 +1000, Alexey Kardashevskiy wrote:
>> This defines and implements VFIO IOMMU API which lets the userspace
>> create and remove DMA windows.
>>
>> This updates VFIO_IOMMU_SPAPR_TCE_GET_INFO to return the number of
>> available windows and page mask.
>>
>> This adds VFIO_IOMMU_SPAPR_TCE_CREATE and VFIO_IOMMU_SPAPR_TCE_REMOVE
>> to allow the user space to create and remove window(s).
>>
>> The VFIO IOMMU driver does basic sanity checks and calls corresponding
>> SPAPR TCE functions. At the moment only IODA2 (POWER8 PCI host bridge)
>> implements them.
>>
>> This advertises VFIO_IOMMU_SPAPR_TCE_FLAG_DDW capability via
>> VFIO_IOMMU_SPAPR_TCE_GET_INFO.
>>
>> This calls platform DDW reset() callback when IOMMU is being disabled
>> to reset the DMA configuration to its original state.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>  drivers/vfio/vfio_iommu_spapr_tce.c | 135 ++++++++++++++++++++++++++++++++++--
>>  include/uapi/linux/vfio.h           |  25 ++++++-
>>  2 files changed, 153 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
>> index 0dccbc4..b518891 100644
>> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
>> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
>> @@ -190,18 +190,25 @@ static void tce_iommu_disable(struct tce_container *container)
>>  
>>  	container->enabled = false;
>>  
>> -	if (!container->grp || !current->mm)
>> +	if (!container->grp)
>>  		return;
>>  
>>  	data = iommu_group_get_iommudata(container->grp);
>>  	if (!data || !data->iommu_owner || !data->ops->get_table)
>>  		return;
>>  
>> -	tbl = data->ops->get_table(data, 0);
>> -	if (!tbl)
>> -		return;
>> +	if (current->mm) {
>> +		tbl = data->ops->get_table(data, 0);
>> +		if (tbl)
>> +			decrement_locked_vm(tbl);
>>  
>> -	decrement_locked_vm(tbl);
>> +		tbl = data->ops->get_table(data, 1);
>> +		if (tbl)
>> +			decrement_locked_vm(tbl);
>> +	}
>> +
>> +	if (data->ops->reset)
>> +		data->ops->reset(data);
>>  }
>>  
>>  static void *tce_iommu_open(unsigned long arg)
>> @@ -243,7 +250,7 @@ static long tce_iommu_ioctl(void *iommu_data,
>>  				 unsigned int cmd, unsigned long arg)
>>  {
>>  	struct tce_container *container = iommu_data;
>> -	unsigned long minsz;
>> +	unsigned long minsz, ddwsz;
>>  	long ret;
>>  
>>  	switch (cmd) {
>> @@ -288,6 +295,28 @@ static long tce_iommu_ioctl(void *iommu_data,
>>  		info.dma32_window_size = tbl->it_size << tbl->it_page_shift;
>>  		info.flags = 0;
>>  
>> +		ddwsz = offsetofend(struct vfio_iommu_spapr_tce_info,
>> +				page_size_mask);
>> +
>> +		if (info.argsz == ddwsz) {
> 
>> =
> 
>> +			if (data->ops->query && data->ops->create &&
>> +					data->ops->remove) {
>> +				info.flags |= VFIO_IOMMU_SPAPR_TCE_FLAG_DDW;
> 
> I think you want to set this flag regardless of whether the user has
> provided space for it.  A valid use model is to call with the minimum
> size and look at the flags to determine if it needs to be called again
> with a larger size.
> 
>> +
>> +				ret = data->ops->query(data,
>> +						&info.current_windows,
>> +						&info.windows_available,
>> +						&info.page_size_mask);
>> +				if (ret)
>> +					return ret;
>> +			} else {
>> +				info.current_windows = 0;
>> +				info.windows_available = 0;
>> +				info.page_size_mask = 0;
>> +			}
>> +			minsz = ddwsz;
> 
> It's not really any longer the min size, is it?
> 
>> +		}
>> +
>>  		if (copy_to_user((void __user *)arg, &info, minsz))
>>  			return -EFAULT;
>>  
>> @@ -412,12 +441,106 @@ static long tce_iommu_ioctl(void *iommu_data,
>>  		tce_iommu_disable(container);
>>  		mutex_unlock(&container->lock);
>>  		return 0;
>> +
>>  	case VFIO_EEH_PE_OP:
>>  		if (!container->grp)
>>  			return -ENODEV;
>>  
>>  		return vfio_spapr_iommu_eeh_ioctl(container->grp,
>>  						  cmd, arg);
>> +
>> +	case VFIO_IOMMU_SPAPR_TCE_CREATE: {
>> +		struct vfio_iommu_spapr_tce_create create;
>> +		struct spapr_tce_iommu_group *data;
>> +		struct iommu_table *tbl;
>> +
>> +		if (WARN_ON(!container->grp))
> 
> redux previous comment on this warning
> 
>> +			return -ENXIO;
>> +
>> +		data = iommu_group_get_iommudata(container->grp);
>> +
>> +		minsz = offsetofend(struct vfio_iommu_spapr_tce_create,
>> +				start_addr);
>> +
>> +		if (copy_from_user(&create, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (create.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		if (create.flags)
>> +			return -EINVAL;
>> +
>> +		if (!data->ops->create || !data->iommu_owner)
>> +			return -ENOSYS;
>> +
>> +		BUG_ON(!data || !data->ops || !data->ops->remove);
> 
> Little late for this test since we'll oops on the previous test.  Why is
> this a BUG_ON?  A user could exploit this on a system with only a
> partial set of callbacks.
> 
>> +
>> +		ret = data->ops->create(data, create.page_shift,
>> +				create.window_shift, &tbl);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ret = try_increment_locked_vm(tbl);
>> +		if (ret) {
>> +			data->ops->remove(data, tbl);
>> +			return ret;
>> +		}
>> +
>> +		create.start_addr = tbl->it_offset << tbl->it_page_shift;
>> +
>> +		if (copy_to_user((void __user *)arg, &create, minsz)) {
>> +			data->ops->remove(data, tbl);
>> +			decrement_locked_vm(tbl);
>> +			return -EFAULT;
>> +		}
>> +		mutex_lock(&container->lock);
>> +		++container->windows_num;
>> +		mutex_unlock(&container->lock);
>> +
>> +		return ret;
>> +	}
>> +	case VFIO_IOMMU_SPAPR_TCE_REMOVE: {
>> +		struct vfio_iommu_spapr_tce_remove remove;
>> +		struct spapr_tce_iommu_group *data;
>> +		struct iommu_table *tbl;
>> +
>> +		if (WARN_ON(!container->grp))
>> +			return -ENXIO;
>> +
>> +		data = iommu_group_get_iommudata(container->grp);
>> +
>> +		minsz = offsetofend(struct vfio_iommu_spapr_tce_remove,
>> +				start_addr);
>> +
>> +		if (copy_from_user(&remove, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (remove.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		if (remove.flags)
>> +			return -EINVAL;
>> +
>> +		if (!data->ops->remove || !data->iommu_owner)
> 
> On this one we don't both to get data/data->ops.  Is there also an
> exploit where the user can call these CREATE/REMOVE interfaces even
> though INFO doesn't expose them if only a partial set of callbacks are
> present?

		if (!data || !data->ops || !data->ops->remove || !data->iommu_owner)

should do it, right?
And I am not going to add create() without remove(), may be it is worth
adding a compile time check for that.


> 
>> +			return -ENOSYS;
>> +
>> +		tbl = spapr_tce_find_table(container, data, remove.start_addr);
> 
> What happens if this returns the 0 index rather than the expected 1
> index table?  Why doesn't this call ops->find_table()?

Why ops->find_table()? They are different (->find_table() searches for the
window by number, spapr_tce_find_table() searches by address), I do not
understand this comment.

And removing window#0 is supported.


> 
>> +		if (!tbl)
>> +			return -EINVAL;
>> +
>> +		ret = data->ops->remove(data, tbl);
>> +		if (ret)
>> +			return ret;
>> +
>> +		decrement_locked_vm(tbl);
>> +
>> +		mutex_lock(&container->lock);
>> +		--container->windows_num;
>> +		mutex_unlock(&container->lock);
>> +
>> +		return 0;
>> +	}
>>  	}
>>  
>>  	return -ENOTTY;
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 6612974..e71a6ef 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -451,9 +451,13 @@ struct vfio_iommu_type1_dma_unmap {
>>   */
>>  struct vfio_iommu_spapr_tce_info {
>>  	__u32 argsz;
>> -	__u32 flags;			/* reserved for future use */
>> +	__u32 flags;
>> +#define VFIO_IOMMU_SPAPR_TCE_FLAG_DDW	1 /* Support dynamic windows */
>>  	__u32 dma32_window_start;	/* 32 bit window start (bytes) */
>>  	__u32 dma32_window_size;	/* 32 bit window size (bytes) */
>> +	__u32 current_windows;
>> +	__u32 windows_available;
>> +	__u32 page_size_mask;
>>  };
>>  
>>  #define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
>> @@ -489,6 +493,25 @@ struct vfio_eeh_pe_op {
>>  
>>  #define VFIO_EEH_PE_OP			_IO(VFIO_TYPE, VFIO_BASE + 21)
>>  
>> +struct vfio_iommu_spapr_tce_create {
>> +	__u32 argsz;
>> +	__u32 flags;
>> +	/* in */
>> +	__u32 page_shift;
>> +	__u32 window_shift;
>> +	/* out */
>> +	__u64 start_addr;
>> +};
>> +#define VFIO_IOMMU_SPAPR_TCE_CREATE	_IO(VFIO_TYPE, VFIO_BASE + 18)
>> +
>> +struct vfio_iommu_spapr_tce_remove {
>> +	__u32 argsz;
>> +	__u32 flags;
>> +	/* in */
>> +	__u64 start_addr;
>> +};
>> +#define VFIO_IOMMU_SPAPR_TCE_REMOVE	_IO(VFIO_TYPE, VFIO_BASE + 19)
>> +
> 
> Zero comments, no good.

Right. I'll fix it. Thanks for the review.


> 
>>  /* ***************************************************************** */
>>  
>>  #endif /* _UAPIVFIO_H */
> 
> 
> 


-- 
Alexey
