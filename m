Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaIZUTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:19:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbaIZUTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:19:13 -0400
Message-ID: <1411762736.7360.42.camel@ul30vt.home>
Subject: Re: [PATCHv7 10/26] vfio: platform: probe to devices on the
 platform bus
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        KVM devel mailing list <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Eric Auger <eric.auger@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>
Date: Fri, 26 Sep 2014 14:18:56 -0600
In-Reply-To: <CAG8rG2wECWL2w9Xyvs7tZx8bqdMqk2SP8gfYpq=ZY0_Jk0Q+-g@mail.gmail.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1411483586-29304-11-git-send-email-a.motakis@virtualopensystems.com>
	 <1411513277.24563.61.camel@ul30vt.home>
	 <CAG8rG2wECWL2w9Xyvs7tZx8bqdMqk2SP8gfYpq=ZY0_Jk0Q+-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 17:30 +0200, Antonios Motakis wrote:
> On Wed, Sep 24, 2014 at 1:01 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > On Tue, 2014-09-23 at 16:46 +0200, Antonios Motakis wrote:
> > > Driver to bind to Linux platform devices, and callbacks to discover their
> > > resources to be used by the main VFIO PLATFORM code.
> > >
> > > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > > ---
> > >  drivers/vfio/platform/vfio_platform.c | 96 +++++++++++++++++++++++++++++++++++
> > >  include/uapi/linux/vfio.h             |  1 +
> > >  2 files changed, 97 insertions(+)
> > >  create mode 100644 drivers/vfio/platform/vfio_platform.c
> > >
> > > diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> > > new file mode 100644
> > > index 0000000..024c026
> > > --- /dev/null
> > > +++ b/drivers/vfio/platform/vfio_platform.c
> > > @@ -0,0 +1,96 @@
> > > +/*
> > > + * Copyright (C) 2013 - Virtual Open Systems
> > > + * Author: Antonios Motakis <a.motakis@virtualopensystems.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License, version 2, as
> > > + * published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +
> > > +#include <linux/device.h>
> > > +#include <linux/eventfd.h>
> > > +#include <linux/interrupt.h>
> > > +#include <linux/iommu.h>
> > > +#include <linux/module.h>
> > > +#include <linux/mutex.h>
> > > +#include <linux/notifier.h>
> > > +#include <linux/pm_runtime.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/types.h>
> > > +#include <linux/uaccess.h>
> > > +#include <linux/vfio.h>
> > > +#include <linux/io.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/irq.h>
> > > +
> > > +#include "vfio_platform_private.h"
> > > +
> > > +#define DRIVER_VERSION  "0.7"
> > > +#define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
> > > +#define DRIVER_DESC     "VFIO for platform devices - User Level meta-driver"
> > > +
> > > +/* probing devices from the linux platform bus */
> > > +
> > > +static struct resource *get_platform_resource(struct vfio_platform_device *vdev,
> > > +                                             int i)
> > > +{
> > > +     struct platform_device *pdev = (struct platform_device *) vdev->opaque;
> > > +
> > > +     return platform_get_resource(pdev, IORESOURCE_MEM, i);
> >
> > ARM may only support IORESOURCE_MEM, but I don't think platform devices
> > are limited to MMIO, right?  vfio-platform shouldn't be either.
> >
> 
> Indeed. Should we however implement this lacking a target to verify it
> is working correctly?
> 
> Leaving it out would mean PIO resources for those devices would not be
> exposed before an update to VFIO, but we wouldn't have to break
> backward compatibility I think.
> 
> Would you prefer to have it implemented regardless?

I think we need to have PIO figured out at least enough to have stubbed
read/write handlers that could be filled in by someone with test
hardware.  I'm not sure I fully understand how a user associates a
region index to a device tree description, whether it's ordering or
something more complicated, so I'm not sure if simply listing all the
PIO resources after the MMIO resources is sufficient and compatible.
Maybe you have some thoughts on that.  Thanks,

Alex

> > > +}
> > > +
> > > +static int get_platform_irq(struct vfio_platform_device *vdev, int i)
> > > +{
> > > +     struct platform_device *pdev = (struct platform_device *) vdev->opaque;
> > > +
> > > +     return platform_get_irq(pdev, i);
> > > +}
> > > +
> > > +
> > > +static int vfio_platform_probe(struct platform_device *pdev)
> > > +{
> > > +     struct vfio_platform_device *vdev;
> > > +     int ret;
> > > +
> > > +     vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> > > +     if (!vdev)
> > > +             return -ENOMEM;
> > > +
> > > +     vdev->opaque = (void *) pdev;
> > > +     vdev->name = pdev->name;
> > > +     vdev->flags = VFIO_DEVICE_FLAGS_PLATFORM;
> > > +     vdev->get_resource = get_platform_resource;
> > > +     vdev->get_irq = get_platform_irq;
> > > +
> > > +     ret = vfio_platform_probe_common(vdev, &pdev->dev);
> > > +     if (ret)
> > > +             kfree(vdev);
> > > +
> > > +     return ret;
> > > +}
> > > +
> > > +static int vfio_platform_remove(struct platform_device *pdev)
> > > +{
> > > +     return vfio_platform_remove_common(&pdev->dev);
> > > +}
> > > +
> > > +static struct platform_driver vfio_platform_driver = {
> > > +     .probe          = vfio_platform_probe,
> > > +     .remove         = vfio_platform_remove,
> > > +     .driver = {
> > > +             .name   = "vfio-platform",
> > > +             .owner  = THIS_MODULE,
> > > +     },
> > > +};
> > > +
> > > +module_platform_driver(vfio_platform_driver);
> > > +
> > > +MODULE_VERSION(DRIVER_VERSION);
> > > +MODULE_LICENSE("GPL v2");
> > > +MODULE_AUTHOR(DRIVER_AUTHOR);
> > > +MODULE_DESCRIPTION(DRIVER_DESC);
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index 30f630c..b022a25 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -158,6 +158,7 @@ struct vfio_device_info {
> > >       __u32   flags;
> > >  #define VFIO_DEVICE_FLAGS_RESET      (1 << 0)        /* Device supports reset */
> > >  #define VFIO_DEVICE_FLAGS_PCI        (1 << 1)        /* vfio-pci device */
> > > +#define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)  /* vfio-platform device */
> > >       __u32   num_regions;    /* Max region index + 1 */
> > >       __u32   num_irqs;       /* Max IRQ index + 1 */
> > >  };
> >
> >
> >
> 
> 
> 



