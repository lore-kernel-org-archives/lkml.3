Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaKEKE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:04:26 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59963 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaKEKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:04:23 -0500
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:c0ab:7493:ff17:bb99]
In-Reply-To: <1414782674.27420.320.camel@ul30vt.home>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
 <1414433284-31719-11-git-send-email-a.motakis@virtualopensystems.com> <1414782674.27420.320.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 5 Nov 2014 11:04:02 +0100
Message-ID: <CAG8rG2wPH8fQm7ZFC+q9EvBPzg=xg18Qz399n+=Q=GKyHPOGmA@mail.gmail.com>
Subject: Re: [PATCH v9 10/19] vfio/platform: return IRQ info
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 8:11 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2014-10-27 at 19:07 +0100, Antonios Motakis wrote:
>> Return information for the interrupts exposed by the device.
>> This patch extends VFIO_DEVICE_GET_INFO with the number of IRQs
>> and enables VFIO_DEVICE_GET_IRQ_INFO.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/Makefile                |  2 +-
>>  drivers/vfio/platform/vfio_platform_common.c  | 31 ++++++++++++--
>>  drivers/vfio/platform/vfio_platform_irq.c     | 59 +++++++++++++++++++++++++++
>>  drivers/vfio/platform/vfio_platform_private.h | 10 +++++
>>  4 files changed, 97 insertions(+), 5 deletions(-)
>>  create mode 100644 drivers/vfio/platform/vfio_platform_irq.c
>>
>> diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
>> index 1957170..81de144 100644
>> --- a/drivers/vfio/platform/Makefile
>> +++ b/drivers/vfio/platform/Makefile
>> @@ -1,5 +1,5 @@
>>
>> -vfio-platform-y := vfio_platform.o vfio_platform_common.o
>> +vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o
>>
>>  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> index aeaaec9..5f2c205 100644
>> --- a/drivers/vfio/platform/vfio_platform_common.c
>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> @@ -105,6 +105,7 @@ static void vfio_platform_release(void *device_data)
>>
>>       if (!(--vdev->refcnt)) {
>>               vfio_platform_regions_cleanup(vdev);
>> +             vfio_platform_irq_cleanup(vdev);
>>       }
>>
>>       mutex_unlock(&driver_lock);
>> @@ -126,6 +127,10 @@ static int vfio_platform_open(void *device_data)
>>               ret = vfio_platform_regions_init(vdev);
>>               if (ret)
>>                       goto err_reg;
>> +
>> +             ret = vfio_platform_irq_init(vdev);
>> +             if (ret)
>> +                     goto err_irq;
>>       }
>>
>>       vdev->refcnt++;
>> @@ -133,6 +138,8 @@ static int vfio_platform_open(void *device_data)
>>       mutex_unlock(&driver_lock);
>>       return 0;
>>
>> +err_irq:
>> +     vfio_platform_regions_cleanup(vdev);
>>  err_reg:
>>       mutex_unlock(&driver_lock);
>>       module_put(THIS_MODULE);
>> @@ -158,7 +165,7 @@ static long vfio_platform_ioctl(void *device_data,
>>
>>               info.flags = vdev->flags;
>>               info.num_regions = vdev->num_regions;
>> -             info.num_irqs = 0;
>> +             info.num_irqs = vdev->num_irqs;
>>
>>               return copy_to_user((void __user *)arg, &info, minsz);
>>
>> @@ -183,10 +190,26 @@ static long vfio_platform_ioctl(void *device_data,
>>
>>               return copy_to_user((void __user *)arg, &info, minsz);
>>
>> -     } else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
>> -             return -EINVAL;
>> +     } else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
>> +             struct vfio_irq_info info;
>> +
>> +             minsz = offsetofend(struct vfio_irq_info, count);
>> +
>> +             if (copy_from_user(&info, (void __user *)arg, minsz))
>> +                     return -EFAULT;
>> +
>> +             if (info.argsz < minsz)
>> +                     return -EINVAL;
>> +
>> +             if (info.index >= vdev->num_irqs)
>> +                     return -EINVAL;
>> +
>> +             info.flags = vdev->irqs[info.index].flags;
>> +             info.count = vdev->irqs[info.index].count;
>> +
>> +             return copy_to_user((void __user *)arg, &info, minsz);
>>
>> -     else if (cmd == VFIO_DEVICE_SET_IRQS)
>> +     } else if (cmd == VFIO_DEVICE_SET_IRQS)
>>               return -EINVAL;
>>
>>       else if (cmd == VFIO_DEVICE_RESET)
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> new file mode 100644
>> index 0000000..d99c71c
>> --- /dev/null
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -0,0 +1,59 @@
>> +/*
>> + * VFIO platform devices interrupt handling
>> + *
>> + * Copyright (C) 2013 - Virtual Open Systems
>> + * Author: Antonios Motakis <a.motakis@virtualopensystems.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License, version 2, as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/eventfd.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/iommu.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/notifier.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/vfio.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/irq.h>
>> +
>> +#include "vfio_platform_private.h"
>> +
>> +int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>> +{
>> +     int cnt = 0, i;
>> +
>> +     while (vdev->get_irq(vdev, cnt) > 0)
>
> For platform devices this is just a wrapper around platform_get_irq(),
> which sort of seems like it can return 0 as a valid irq.  Am I wrong
> about that?  If 0 can be valid, AMBA would need to update it's error
> return value too.

Never thought of the possibility of having a device with irq 0. I will
look into it and handle appropriately.

>
>> +             cnt++;
>> +
>> +     vdev->irqs = kcalloc(cnt, sizeof(struct vfio_platform_irq), GFP_KERNEL);
>> +     if (!vdev->irqs)
>> +             return -ENOMEM;
>> +
>> +     for (i = 0; i < cnt; i++) {
>> +             vdev->irqs[i].flags = 0;
>> +             vdev->irqs[i].count = 1;
>> +     }
>> +
>> +     vdev->num_irqs = cnt;
>> +
>> +     return 0;
>> +}
>> +
>> +void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>> +{
>> +     vdev->num_irqs = 0;
>> +     kfree(vdev->irqs);
>> +}
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index 1f251b2..3a29a72 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -24,6 +24,11 @@
>>  #define VFIO_PLATFORM_INDEX_TO_OFFSET(index) \
>>       ((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
>>
>> +struct vfio_platform_irq {
>> +     u32                     flags;
>> +     u32                     count;
>> +};
>> +
>>  struct vfio_platform_region {
>>       u64                     addr;
>>       resource_size_t         size;
>> @@ -37,6 +42,8 @@ struct vfio_platform_region {
>>  struct vfio_platform_device {
>>       struct vfio_platform_region     *regions;
>>       u32                             num_regions;
>> +     struct vfio_platform_irq        *irqs;
>> +     u32                             num_irqs;
>>       int                             refcnt;
>>
>>       /*
>> @@ -56,4 +63,7 @@ extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
>>  extern struct vfio_platform_device *vfio_platform_remove_common
>>                                    (struct device *dev);
>>
>> +extern int vfio_platform_irq_init(struct vfio_platform_device *vdev);
>> +extern void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
>> +
>>  #endif /* VFIO_PLATFORM_PRIVATE_H */
>
>
>
