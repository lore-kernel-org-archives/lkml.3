Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaKEJvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:51:01 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44116 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaKEJu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:50:57 -0500
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:c0ab:7493:ff17:bb99]
In-Reply-To: <1414780819.27420.314.camel@ul30vt.home>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
 <1414433284-31719-5-git-send-email-a.motakis@virtualopensystems.com> <1414780819.27420.314.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 5 Nov 2014 10:50:37 +0100
Message-ID: <CAG8rG2z-PMEN-9iZnv2jpcTrfugeA3+OUt=WUd75FLy7ZSDG1Q@mail.gmail.com>
Subject: Re: [PATCH v9 04/19] vfio: amba: VFIO support for AMBA devices
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
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 7:40 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2014-10-27 at 19:07 +0100, Antonios Motakis wrote:
>> Add support for discovering AMBA devices with VFIO and handle them
>> similarly to Linux platform devices.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/vfio_amba.c | 116 ++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/vfio.h         |   1 +
>>  2 files changed, 117 insertions(+)
>>  create mode 100644 drivers/vfio/platform/vfio_amba.c
>>
>> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
>> new file mode 100644
>> index 0000000..cf61324
>> --- /dev/null
>> +++ b/drivers/vfio/platform/vfio_amba.c
>> @@ -0,0 +1,116 @@
>> +/*
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
>> +#include <linux/io.h>
>> +#include <linux/irq.h>
>> +#include <linux/amba/bus.h>
>> +
>> +#include "vfio_platform_private.h"
>> +
>> +#define DRIVER_VERSION  "0.9"
>> +#define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
>> +#define DRIVER_DESC     "VFIO for AMBA devices - User Level meta-driver"
>> +
>> +/* probing devices from the AMBA bus */
>> +
>> +static struct resource *get_amba_resource(struct vfio_platform_device *vdev,
>> +                                             int i)
>> +{
>> +     struct amba_device *adev = (struct amba_device *) vdev->opaque;
>> +
>> +     if (i == 0)
>> +             return &adev->res;
>> +
>> +     return NULL;
>> +}
>> +
>> +static int get_amba_irq(struct vfio_platform_device *vdev, int i)
>> +{
>> +     struct amba_device *adev = (struct amba_device *) vdev->opaque;
>> +
>> +     if (i < AMBA_NR_IRQS)
>> +             return adev->irq[i];
>> +
>> +     return 0;
>> +}
>> +
>> +static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
>> +{
>> +
>> +     struct vfio_platform_device *vdev;
>> +     int ret;
>> +
>> +     vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
>> +     if (!vdev)
>> +             return -ENOMEM;
>> +
>> +     vdev->opaque = (void *) adev;
>> +     vdev->name = "vfio-amba-dev";
>
> You need to actually allocate some memory here with something like
> kasprintf.  Don't forget to free it on the error and remove path.

Ack.

>
>> +     vdev->flags = VFIO_DEVICE_FLAGS_AMBA;
>> +     vdev->get_resource = get_amba_resource;
>> +     vdev->get_irq = get_amba_irq;
>> +
>> +     ret = vfio_platform_probe_common(vdev, &adev->dev);
>> +     if (ret)
>> +             kfree(vdev);
>> +
>> +     return ret;
>> +}
>> +
>> +static int vfio_amba_remove(struct amba_device *adev)
>> +{
>> +     struct vfio_platform_device *vdev;
>> +
>> +     vdev = vfio_platform_remove_common(&adev->dev);
>> +     if(vdev) {
>> +             kfree(vdev);
>> +             return 0;
>> +     }
>> +
>> +     return -EINVAL;
>> +}
>> +
>> +static struct amba_id pl330_ids[] = {
>> +     { 0, 0 },
>> +};
>> +
>> +MODULE_DEVICE_TABLE(amba, pl330_ids);
>> +
>> +static struct amba_driver vfio_amba_driver = {
>> +     .probe = vfio_amba_probe,
>> +     .remove = vfio_amba_remove,
>> +     .id_table = pl330_ids,
>> +     .drv = {
>> +             .name = "vfio-amba",
>> +             .owner = THIS_MODULE,
>> +     },
>> +};
>> +
>> +module_amba_driver(vfio_amba_driver);
>> +
>> +MODULE_VERSION(DRIVER_VERSION);
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_AUTHOR(DRIVER_AUTHOR);
>> +MODULE_DESCRIPTION(DRIVER_DESC);
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 9db1056..92469e0 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -158,6 +158,7 @@ struct vfio_device_info {
>>  #define VFIO_DEVICE_FLAGS_RESET      (1 << 0)        /* Device supports reset */
>>  #define VFIO_DEVICE_FLAGS_PCI        (1 << 1)        /* vfio-pci device */
>>  #define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)  /* vfio-platform device */
>> +#define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)     /* vfio-amba device */
>>       __u32   num_regions;    /* Max region index + 1 */
>>       __u32   num_irqs;       /* Max IRQ index + 1 */
>>  };
>
>
>
