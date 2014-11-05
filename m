Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaKEJvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:51:19 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48351 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaKEJvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:51:06 -0500
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:c0ab:7493:ff17:bb99]
In-Reply-To: <1414781936.27420.317.camel@ul30vt.home>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
 <1414433284-31719-8-git-send-email-a.motakis@virtualopensystems.com> <1414781936.27420.317.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 5 Nov 2014 10:50:46 +0100
Message-ID: <CAG8rG2wNREAurf-gYD=3RTE9kWO5=gOvtydxQzvrn9TnxMj_1Q@mail.gmail.com>
Subject: Re: [PATCH v9 07/19] vfio/platform: return info for device memory
 mapped IO regions
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 7:58 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2014-10-27 at 19:07 +0100, Antonios Motakis wrote:
>> This patch enables the IOCTLs VFIO_DEVICE_GET_REGION_INFO ioctl call,
>> which allows the user to learn about the available MMIO resources of
>> a device.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/vfio_platform_common.c  | 110 +++++++++++++++++++++++++-
>>  drivers/vfio/platform/vfio_platform_private.h |  22 ++++++
>>  2 files changed, 128 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> index cb20526..82de752 100644
>> --- a/drivers/vfio/platform/vfio_platform_common.c
>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> @@ -27,17 +27,97 @@
>>
>>  #include "vfio_platform_private.h"
>>
>> +static DEFINE_MUTEX(driver_lock);
>> +
>> +static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
>> +{
>> +     int cnt = 0, i;
>> +
>> +     while (vdev->get_resource(vdev, cnt))
>> +             cnt++;
>> +
>> +     vdev->regions = kcalloc(cnt, sizeof(struct vfio_platform_region),
>> +                             GFP_KERNEL);
>> +     if (!vdev->regions)
>> +             return -ENOMEM;
>> +
>> +     for (i = 0; i < cnt;  i++) {
>> +             struct resource *res =
>> +                     vdev->get_resource(vdev, i);
>> +
>> +             if (!res)
>> +                     goto err;
>> +
>> +             vdev->regions[i].addr = res->start;
>> +             vdev->regions[i].size = resource_size(res);
>> +             vdev->regions[i].flags = 0;
>> +
>> +             switch (resource_type(res)) {
>> +             case IORESOURCE_MEM:
>> +                     vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_MMIO;
>> +                     break;
>> +             case IORESOURCE_IO:
>> +                     vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_PIO;
>> +                     break;
>> +             default:
>> +                     goto err;
>> +             }
>> +     }
>> +
>> +     vdev->num_regions = cnt;
>> +
>> +     return 0;
>> +err:
>> +     kfree(vdev->regions);
>> +     return -EINVAL;
>> +}
>> +
>> +static void vfio_platform_regions_cleanup(struct vfio_platform_device *vdev)
>> +{
>> +     vdev->num_regions = 0;
>> +     kfree(vdev->regions);
>> +}
>> +
>>  static void vfio_platform_release(void *device_data)
>>  {
>> +     struct vfio_platform_device *vdev = device_data;
>> +
>> +     mutex_lock(&driver_lock);
>> +
>> +     if (!(--vdev->refcnt)) {
>> +             vfio_platform_regions_cleanup(vdev);
>> +     }
>> +
>> +     mutex_unlock(&driver_lock);
>> +
>>       module_put(THIS_MODULE);
>>  }
>>
>>  static int vfio_platform_open(void *device_data)
>>  {
>> +     struct vfio_platform_device *vdev = device_data;
>> +     int ret;
>> +
>>       if (!try_module_get(THIS_MODULE))
>>               return -ENODEV;
>>
>> +     mutex_lock(&driver_lock);
>> +
>> +     if (!vdev->refcnt) {
>> +             ret = vfio_platform_regions_init(vdev);
>> +             if (ret)
>> +                     goto err_reg;
>> +     }
>> +
>> +     vdev->refcnt++;
>> +
>> +     mutex_unlock(&driver_lock);
>>       return 0;
>> +
>> +err_reg:
>> +     mutex_unlock(&driver_lock);
>> +     module_put(THIS_MODULE);
>> +     return ret;
>>  }
>>
>>  static long vfio_platform_ioctl(void *device_data,
>> @@ -58,15 +138,33 @@ static long vfio_platform_ioctl(void *device_data,
>>                       return -EINVAL;
>>
>>               info.flags = vdev->flags;
>> -             info.num_regions = 0;
>> +             info.num_regions = vdev->num_regions;
>>               info.num_irqs = 0;
>>
>>               return copy_to_user((void __user *)arg, &info, minsz);
>>
>> -     } else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
>> -             return -EINVAL;
>> +     } else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
>> +             struct vfio_region_info info;
>> +
>> +             minsz = offsetofend(struct vfio_region_info, offset);
>> +
>> +             if (copy_from_user(&info, (void __user *)arg, minsz))
>> +                     return -EFAULT;
>>
>> -     else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
>> +             if (info.argsz < minsz)
>> +                     return -EINVAL;
>> +
>> +             if (info.index >= vdev->num_regions)
>> +                     return -EINVAL;
>> +
>> +             /* map offset to the physical address  */
>> +             info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
>> +             info.size = vdev->regions[info.index].size;
>> +             info.flags = vdev->regions[info.index].flags;
>> +
>> +             return copy_to_user((void __user *)arg, &info, minsz);
>> +
>> +     } else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
>>               return -EINVAL;
>>
>>       else if (cmd == VFIO_DEVICE_SET_IRQS)
>> @@ -134,10 +232,14 @@ struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
>>  {
>>       struct vfio_platform_device *vdev;
>>
>> +     mutex_lock(&driver_lock);
>> +
>>       vdev = vfio_del_group_dev(dev);
>>       if (vdev)
>>               iommu_group_put(dev->iommu_group);
>>
>> +     mutex_unlock(&driver_lock);
>> +
>
> This is the same deadlock that vfio-pci recently removed.  Imagine that
> you attempt to unbind an in-use device from vfio-platform,
> vfio_del_group_dev() waits, holding the mutex, for the device to be
> unused.  vfio_platform_release() must acquire the mutex before it can
> run.  I don't think you need the mutex here.  Thanks,

Fair enough, no mutex for _release then.

>
> Alex
>
>>       return vdev;
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index 062b92d..b24729f 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -15,7 +15,29 @@
>>  #ifndef VFIO_PLATFORM_PRIVATE_H
>>  #define VFIO_PLATFORM_PRIVATE_H
>>
>> +#define VFIO_PLATFORM_OFFSET_SHIFT   40
>> +#define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
>> +
>> +#define VFIO_PLATFORM_OFFSET_TO_INDEX(off)   \
>> +     (off >> VFIO_PLATFORM_OFFSET_SHIFT)
>> +
>> +#define VFIO_PLATFORM_INDEX_TO_OFFSET(index) \
>> +     ((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
>> +
>> +struct vfio_platform_region {
>> +     u64                     addr;
>> +     resource_size_t         size;
>> +     u32                     flags;
>> +     u32                     type;
>> +#define VFIO_PLATFORM_REGION_TYPE_MMIO       1
>> +#define VFIO_PLATFORM_REGION_TYPE_PIO        2
>> +};
>> +
>>  struct vfio_platform_device {
>> +     struct vfio_platform_region     *regions;
>> +     u32                             num_regions;
>> +     int                             refcnt;
>> +
>>       /*
>>        * These fields should be filled by the bus specific binder
>>        */
>
>
>
