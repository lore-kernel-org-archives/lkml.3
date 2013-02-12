Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355Ab3BLOmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:42:46 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:62211 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759841Ab3BLOmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:42:45 -0500
Message-ID: <511A54DC.9030908@ozlabs.ru>
Date: Wed, 13 Feb 2013 01:42:36 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] iommu: making IOMMU sysfs nodes API public
References: <1360628713.3248.8.camel@bling.home>  <1360642004-7419-1-git-send-email-aik@ozlabs.ru> <1360645643.3248.91.camel@bling.home>
In-Reply-To: <1360645643.3248.91.camel@bling.home>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/13 16:07, Alex Williamson wrote:
> On Tue, 2013-02-12 at 15:06 +1100, Alexey Kardashevskiy wrote:
>> Having this patch in a tree, adding new nodes in sysfs
>> for IOMMU groups is going to be easier.
>>
>> The first candidate for this change is a "dma-window-size"
>> property which tells a size of a DMA window of the specific
>> IOMMU group which can be used later for locked pages accounting.
>
> I'm still churning on this one; I'm nervous this would basically creat
> a /proc free-for-all under /sys/kernel/iommu_group/$GROUP/ where any
> iommu driver can add random attributes.  That can get ugly for
> userspace.

Is not it exactly what sysfs is for (unlike /proc)? :)


> On the other hand, for the application of userspace knowing how much
> memory to lock for vfio use of a group, it's an appealing location to
> get that information.  Something like libvirt would already be poking
> around here to figure out which devices to bind.  Page limits need to be
> setup prior to use through vfio, so sysfs is more convenient than
> through vfio ioctls.

True. DMA window properties do not change since boot so sysfs is the right 
place to expose them.

> But then is dma-window-size just a vfio requirement leaking over into
> iommu groups?  Can we allow iommu driver based attributes without giving
> up control of the namespace?  Thanks,

Who are you asking these questions? :)


> Alex
>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>   drivers/iommu/iommu.c |   19 ++-----------------
>>   include/linux/iommu.h |   20 ++++++++++++++++++++
>>   2 files changed, 22 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index b0afd3d..58cc298 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -52,22 +52,6 @@ struct iommu_device {
>>   	char *name;
>>   };
>>
>> -struct iommu_group_attribute {
>> -	struct attribute attr;
>> -	ssize_t (*show)(struct iommu_group *group, char *buf);
>> -	ssize_t (*store)(struct iommu_group *group,
>> -			 const char *buf, size_t count);
>> -};
>> -
>> -#define IOMMU_GROUP_ATTR(_name, _mode, _show, _store)		\
>> -struct iommu_group_attribute iommu_group_attr_##_name =		\
>> -	__ATTR(_name, _mode, _show, _store)
>> -
>> -#define to_iommu_group_attr(_attr)	\
>> -	container_of(_attr, struct iommu_group_attribute, attr)
>> -#define to_iommu_group(_kobj)		\
>> -	container_of(_kobj, struct iommu_group, kobj)
>> -
>>   static ssize_t iommu_group_attr_show(struct kobject *kobj,
>>   				     struct attribute *__attr, char *buf)
>>   {
>> @@ -98,11 +82,12 @@ static const struct sysfs_ops iommu_group_sysfs_ops = {
>>   	.store = iommu_group_attr_store,
>>   };
>>
>> -static int iommu_group_create_file(struct iommu_group *group,
>> +int iommu_group_create_file(struct iommu_group *group,
>>   				   struct iommu_group_attribute *attr)
>>   {
>>   	return sysfs_create_file(&group->kobj, &attr->attr);
>>   }
>> +EXPORT_SYMBOL_GPL(iommu_group_create_file);
>>
>>   static void iommu_group_remove_file(struct iommu_group *group,
>>   				    struct iommu_group_attribute *attr)
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index f3b99e1..6d24ba7 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -21,6 +21,7 @@
>>
>>   #include <linux/errno.h>
>>   #include <linux/types.h>
>> +#include <linux/stat.h>
>>
>>   #define IOMMU_READ	(1)
>>   #define IOMMU_WRITE	(2)
>> @@ -197,6 +198,25 @@ static inline int report_iommu_fault(struct iommu_domain *domain,
>>   	return ret;
>>   }
>>
>> +struct iommu_group_attribute {
>> +	struct attribute attr;
>> +	ssize_t (*show)(struct iommu_group *group, char *buf);
>> +	ssize_t (*store)(struct iommu_group *group,
>> +			 const char *buf, size_t count);
>> +};
>> +
>> +#define IOMMU_GROUP_ATTR(_name, _mode, _show, _store)		\
>> +struct iommu_group_attribute iommu_group_attr_##_name =		\
>> +	__ATTR(_name, _mode, _show, _store)
>> +
>> +#define to_iommu_group_attr(_attr)	\
>> +	container_of(_attr, struct iommu_group_attribute, attr)
>> +#define to_iommu_group(_kobj)		\
>> +	container_of(_kobj, struct iommu_group, kobj)
>> +
>> +extern int iommu_group_create_file(struct iommu_group *group,
>> +				   struct iommu_group_attribute *attr);
>> +
>>   #else /* CONFIG_IOMMU_API */
>>
>>   struct iommu_ops {};
>
>
>


-- 
Alexey
