Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab3HSSla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:41:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3HSSl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:41:28 -0400
Message-ID: <1376937682.2657.15.camel@ul30vt.home>
Subject: Re: [PATCH] vfio-pci: PCI hot reset interface
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 19 Aug 2013 12:41:22 -0600
In-Reply-To: <1376521578.13642.65.camel@ul30vt.home>
References: <20130814200845.21923.64284.stgit@bling.home>
	 <CAErSpo4zfuaaBSDci4jOu_9RgUfLQNPvKhro1OEh=8AMvAFWYw@mail.gmail.com>
	 <1376521578.13642.65.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 17:06 -0600, Alex Williamson wrote:
> On Wed, 2013-08-14 at 16:42 -0600, Bjorn Helgaas wrote:
> > [+cc Al, linux-fsdevel for fdget/fdput usage]
> > 
> > On Wed, Aug 14, 2013 at 2:10 PM, Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > > The current VFIO_DEVICE_RESET interface only maps to PCI use cases
> > > where we can isolate the reset to the individual PCI function.  This
> > > means the device must support FLR (PCIe or AF), PM reset on D3hot->D0
> > > transition, device specific reset, or be a singleton device on a bus
> > > for a secondary bus reset.  FLR does not have widespread support,
> > > PM reset is not very reliable, and bus topology is dictated by the
> > > system and device design.  We need to provide a means for a user to
> > > induce a bus reset in cases where the existing mechanisms are not
> > > available or not reliable.
> > >
> > > This device specific extension to VFIO provides the user with this
> > > ability.  Two new ioctls are introduced:
> > >  - VFIO_DEVICE_PCI_GET_HOT_RESET_INFO
> > >  - VFIO_DEVICE_PCI_HOT_RESET
> > >
> > > The first provides the user with information about the extent of
> > > devices affected by a hot reset.  This is essentially a list of
> > > devices and the IOMMU groups they belong to.  The user may then
> > > initiate a hot reset by calling the second ioctl.  We must be
> > > careful that the user has ownership of all the affected devices
> > > found via the first ioctl, so the second ioctl takes a list of file
> > > descriptors for the VFIO groups affected by the reset.  Each group
> > > must have IOMMU protection established for the ioctl to succeed.
> > >
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > >
> > > This patch is dependent on v5 "pci: bus and slot reset interfaces" as
> > > well as "pci: Add probe functions for bus and slot reset".
> > >
> > >  drivers/vfio/pci/vfio_pci.c |  272 +++++++++++++++++++++++++++++++++++++++++++
> > >  include/uapi/linux/vfio.h   |   38 ++++++
> > >  2 files changed, 309 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > > index cef6002..eb69bf3 100644
> > > --- a/drivers/vfio/pci/vfio_pci.c
> > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > @@ -227,6 +227,97 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
> > >         return 0;
> > >  }
> > >
> > > +static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
> > > +{
> > > +       (*(int *)data)++;
> > > +       return 0;
> > > +}
> > > +
> > > +struct vfio_pci_fill_info {
> > > +       int max;
> > > +       int cur;
> > > +       struct vfio_pci_dependent_device *devices;
> > > +};
> > > +
> > > +static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
> > > +{
> > > +       struct vfio_pci_fill_info *info = data;
> > > +       struct iommu_group *iommu_group;
> > > +
> > > +       if (info->cur == info->max)
> > > +               return -EAGAIN; /* Something changed, try again */
> > > +
> > > +       iommu_group = iommu_group_get(&pdev->dev);
> > > +       if (!iommu_group)
> > > +               return -EPERM; /* Cannot reset non-isolated devices */
> > > +
> > > +       info->devices[info->cur].group_id = iommu_group_id(iommu_group);
> > > +       info->devices[info->cur].segment = pci_domain_nr(pdev->bus);
> > > +       info->devices[info->cur].bus = pdev->bus->number;
> > > +       info->devices[info->cur].devfn = pdev->devfn;
> > > +       info->cur++;
> > > +       iommu_group_put(iommu_group);
> > > +       return 0;
> > > +}
> > > +
> > > +struct vfio_pci_group {
> > > +       struct vfio_group *group;
> > > +       int id;
> > > +};
> > > +
> > > +struct vfio_pci_group_info {
> > > +       int count;
> > > +       struct vfio_pci_group *groups;
> > > +};
> > > +
> > > +static int vfio_pci_validate_devs(struct pci_dev *pdev, void *data)
> > > +{
> > > +       struct vfio_pci_group_info *info = data;
> > > +       struct iommu_group *group;
> > > +       int id, i;
> > > +
> > > +       group = iommu_group_get(&pdev->dev);
> > > +       if (!group)
> > > +               return -EPERM;
> > > +
> > > +       id = iommu_group_id(group);
> > > +
> > > +       for (i = 0; i < info->count; i++)
> > > +               if (info->groups[i].id == id)
> > > +                       break;
> > > +
> > > +       iommu_group_put(group);
> > > +
> > > +       return (i == info->count) ? -EINVAL : 0;
> > > +}
> > > +
> > > +static int vfio_pci_for_each_slot_or_bus(struct pci_dev *pdev,
> > > +                                        int (*fn)(struct pci_dev *,
> > > +                                                  void *data), void *data,
> > > +                                        bool slot)
> > > +{
> > > +       struct pci_dev *tmp;
> > > +       int ret = 0;
> > > +
> > > +       list_for_each_entry(tmp, &pdev->bus->devices, bus_list) {
> > > +               if (slot && tmp->slot != pdev->slot)
> > > +                       continue;
> > > +
> > > +               ret = fn(tmp, data);
> > > +               if (ret)
> > > +                       break;
> > > +
> > > +               if (tmp->subordinate) {
> > > +                       ret = vfio_pci_for_each_slot_or_bus(tmp, fn,
> > > +                                                           data, false);
> > > +                       if (ret)
> > > +                               break;
> > > +               }
> > > +       }
> > > +
> > > +       return ret;
> > > +}
> > 
> > vfio_pci_for_each_slot_or_bus() isn't really vfio-specific, is it?
> 
> It's not, I originally has callbacks split out as PCI patches but I was
> able to simplify some things in the code by customizing it to my usage,
> so I left it here.
> 
> > I mean, traversing the PCI hierarchy doesn't require vfio knowledge.  I
> > think this loop (walking the bus->devices list) skips devices on
> > "virtual buses" that may be added for SR-IOV.  I'm not sure that
> > pci_walk_bus() handles that correctly either, but at least if you used
> > that, we could fix the problem in one place.
> 
> I didn't know about pci_walk_bus(), I'll look into switching to it.

It looks like pci_walk_bus() is a poor replacement for when dealing with
slots.  There might be multiple slots on a bus or a mix of slots and
non-slots, so for each device pci_walk_bus() finds on a subordinate bus
I'd need to walk up the tree to find the parent bridge on the original
bus to figure out if it's in the same slot.  Should we have a
pci_walk_slot() function?  Thanks,

Alex


