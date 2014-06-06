Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaFFQjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:39:42 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64180 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaFFQjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:39:40 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:61b0:c77e:e905:5cc9]
In-Reply-To: <1402002841.9207.260.camel@ul30vt.home>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-11-git-send-email-a.motakis@virtualopensystems.com> <1402002841.9207.260.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Fri, 6 Jun 2014 18:39:19 +0200
Message-ID: <CAG8rG2yqDWW03o74Hq1N=p7hKgrSLt1CAAFkLy=79RPvqp6=Mw@mail.gmail.com>
Subject: Re: [RFC PATCH v6 10/20] vfio/platform: return info for device and
 its memory mapped IO regions
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        alvise rigo <a.rigo@virtualopensystems.com>,
        KVM devel mailing list <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Eric Auger <eric.auger@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 11:14 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Thu, 2014-06-05 at 19:03 +0200, Antonios Motakis wrote:
>> A VFIO userspace driver will start by opening the VFIO device
>> that corresponds to an IOMMU group, and will use the ioctl interface
>> to get the basic device info, such as number of memory regions and
>> interrupts, and their properties.
>>
>> This patch enables the IOCTLs:
>>  - VFIO_DEVICE_GET_INFO
>>  - VFIO_DEVICE_GET_REGION_INFO
>>
>> IRQ info is provided by one of the latter patches.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/vfio_platform.c         | 79 +++++++++++++++++++++++++--
>>  drivers/vfio/platform/vfio_platform_private.h | 17 ++++++
>>  2 files changed, 90 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
>> index 1df76d8..eeaebc4 100644
>> --- a/drivers/vfio/platform/vfio_platform.c
>> +++ b/drivers/vfio/platform/vfio_platform.c
>> @@ -34,17 +34,66 @@
>>  #define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
>>  #define DRIVER_DESC     "VFIO for platform devices - User Level meta-driver"
>>
>> +static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
>> +{
>> +     int cnt = 0, i;
>> +
>> +     while (platform_get_resource(vdev->pdev, IORESOURCE_MEM, cnt))
>> +             cnt++;
>> +
>> +     vdev->region = kzalloc(sizeof(struct vfio_platform_region) * cnt,
>> +                             GFP_KERNEL);
>> +     if (!vdev->region)
>> +             return -ENOMEM;
>> +
>> +     for (i = 0; i < cnt;  i++) {
>> +             struct resource *res =
>> +                     platform_get_resource(vdev->pdev, IORESOURCE_MEM, i);
>> +
>> +             if (!res)
>> +                     goto err;
>> +
>> +             vdev->region[i].addr = res->start;
>> +             vdev->region[i].size = resource_size(res);
>> +             vdev->region[i].flags = 0;
>> +     }
>> +
>> +     vdev->num_regions = cnt;
>> +
>> +     return 0;
>> +err:
>> +     kfree(vdev->region);
>> +     return -EINVAL;
>> +}
>> +
>> +static void vfio_platform_regions_cleanup(struct vfio_platform_device *vdev)
>> +{
>> +     vdev->num_regions = 0;
>> +     kfree(vdev->region);
>> +}
>> +
>>  static void vfio_platform_release(void *device_data)
>>  {
>> +     struct vfio_platform_device *vdev = device_data;
>> +
>> +     vfio_platform_regions_cleanup(vdev);
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
>> -     return 0;
>> +     ret = vfio_platform_regions_init(vdev);
>> +     if (ret)
>> +             module_put(THIS_MODULE);
>> +
>> +     return ret;
>
> The user can call VFIO_GROUP_GET_DEVICE_FD for a single device more than
> once, vfio_pci maintains a reference count to make sure we only allocate
> and initialize on the first open and cleanup on the last close.
>

Ack

>>  }
>>
>>  static long vfio_platform_ioctl(void *device_data,
>> @@ -65,18 +114,36 @@ static long vfio_platform_ioctl(void *device_data,
>>                       return -EINVAL;
>>
>>               info.flags = VFIO_DEVICE_FLAGS_PLATFORM;
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
>> +
>> +             if (info.argsz < minsz)
>> +                     return -EINVAL;
>> +
>> +             if (info.index >= vdev->num_regions)
>> +                     return -EINVAL;
>> +
>> +             /* map offset to the physical address  */
>> +             info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
>> +             info.size = vdev->region[info.index].size;
>> +             info.flags = vdev->region[info.index].flags;
>> +
>> +             return copy_to_user((void __user *)arg, &info, minsz);
>>
>> -     else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
>> +     } else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
>>               return -EINVAL;
>>
>> -     else if (cmd == VFIO_DEVICE_SET_IRQS)
>> +     } else if (cmd == VFIO_DEVICE_SET_IRQS)
>>               return -EINVAL;
>>
>>       else if (cmd == VFIO_DEVICE_RESET)
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index 4ae88f8..3448f918 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -15,8 +15,25 @@
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
>> +};
>> +
>>  struct vfio_platform_device {
>>       struct platform_device          *pdev;
>> +     struct vfio_platform_region     *region;
>
> "regions" (plural) has slightly better consistency.  Thanks,
>

Ack as well.


-- 
Antonios Motakis
Virtual Open Systems
