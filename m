Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3HBFKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 01:10:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:37881 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab3HBFKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 01:10:37 -0400
Message-ID: <1375420202.3743.97.camel@pasglop>
Subject: Re: RFC: vfio-pci API for PCI bus/slot (hot) resets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Date: Fri, 02 Aug 2013 15:10:02 +1000
In-Reply-To: <1375395497.31262.271.camel@ul30vt.home>
References: <1375395497.31262.271.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 16:18 -0600, Alex Williamson wrote:
> vfio-pci needs to support an interface to do hot resets (PCI parent
> bridge secondary bus reset).   We need this to support reset of
> co-assigned devices where one or more of the devices does not support
> function level reset.  In particular, discrete graphics cards typically
> have no reset options other than doing a link reset.  

Link reset != hot reset but yeah I see your point. There is more too,
there is fundamental reset which may or may not be something we can
control for individual slots (ie, switch legs) depending on platform
specific stuff...

> What I have below
> is a bit awkward, so I welcome other ideas to accomplish this goal.
> I've been using a "blind" interface based on all affected devices
> belonging to the same VFIO container for current VGA testing.  This is
> ok when all you want to do is VGA, but I'd really like to make use of
> this any time a device doesn't support a function level reset.  I've
> posted a series to the PCI list to add bus and slot reset interfaces to
> PCI-core, this API is how we expose that through VFIO to a user.  Please
> comment.  Thanks,

Also in some cases, at least for us, we have a problem where the scope
of the reset can be larger than the group ... in this case I think we
need to forbid the reset.

For us, it's also tied into our "EEH" error handling. IE. The way the
guest will request some of these things is going to be via firmware APIs
that we have yet to implement, but that we were also thinking of
implementing entire in the kernel rather than qemu for various
reasons... IE. There is more to error handling & recovery in our case at
least than AER and reset :-)

I need to spend more time reading your proposal and see how it can work
for us (or not...)... but we might end up just doing our own thing that
carries the whole EEH API instead.

Cheers,
Ben.

> Alex
> 
> ---
> Mechanism to do PCI hot resets through VFIO:
> 
> VFIO is fundamentally an IOMMU group and device level interface.
> There's no concept of buses, slots, or hierarchies of devices.  There
> are only IOMMU group and devices.  A bus (or slot) may contain exactly
> one IOMMU group, multiple IOMMU groups, or a portion of an IOMMU group.
> An IOMMU group may contain one or more devices.
> 
> The first question is perhaps where should we create the interface to do
> a PCI hot reset.  Assuming an ioctl interface, our choices are the
> group, the container, or the device file descriptors.  Groups and
> containers are not PCI specific, so an extension on either of those
> doesn't make much sense.  They also don't have much granularity if your
> goal is to do a hot reset on the smallest subset of devices you can.
> Therefore the only choice seems to be a VFIO device level interface.
> 
> The fact that a hot reset affects multiple devices also raises concerns.
> How do we make sure a user has sufficient access/privilege to perform
> this operation?  If all of the affected devices are within the same
> group, then we know the user already "owns" all those devices.  Using
> groups as the boundary excludes a number of use cases though.  The user
> would need to prove that they also own the other groups or devices that
> are affected by the reset.  This might be multiple groups, so the ioctl
> quickly grows to requiring a list of file descriptors be passed for
> validation.
> 
> We already use the group file descriptor as a unit of ownership for
> enabling the container, so it seems like it would make sense to use it
> here too.  The alternative is a device file descriptor, but groups may
> encompass devices the user doesn't care to use and we don't want to
> require that they open a file descriptor simply to perform a hot reset.
> Groups can also contain devices that the user cannot open, for instance
> those owned by VFIO "compatible" drivers like pci-stub or pcieport.
> 
> The user also needs to know the set of devices affected by a hot reset,
> otherwise they have no idea which group file descriptors to pass to such
> an interface.  That implies we also need a separate "info" ioctl for the
> user to learn that information.  We could argue that the user could
> learn this information from sysfs, but that imposes non-trivial library
> or code overhead on the user to evaluate the topology.  The PCI hot
> reset info ioctl would need to indicate whether a hot reset is
> available, and the set of affected devices.  It may be useful to provide
> this as a {group, device} pair so the user doesn't need to
> cross-reference each device with sysfs to determine the group for the
> device.  This would then provide both the set of groups required to
> perform the hot reset and the set of devices affected by the hot reset.
> 
> As an alternative, we could consider simply requiring that all of the
> devices affected by a hot reset belong to the same VFIO container.
> However, allowing multiple groups per container is an optional IOMMU
> capability that really has no relation to PCI bus/slot boundaries.  It
> seems a bit arbitrary to require groups be placed in the same container
> to get a PCI hot reset.  That likely means we'd still need to support
> passing some kind of ownership token as above with groups.  So it
> doesn't seem to make the situation any better.
> 
> Given the above discussion, I therefore propose the following PCI hot
> reset interface:
> 
> /**
>  * VFIO_DEVICE_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + ??,
>  *                                        struct vfio_device_pci_hot_reset_info)
>  */
> 
> #define VFIO_DEVICE_PCI_HOT_RESET_INFO     _IO(VFIO_TYPE, VFIO_BASE + ??)
> 
> struct vfio_device_pci_hot_reset_info_entry {
> 	__u32	group_id;
> 	__u16	segment; /* A reset will never include devices on other segments... return it anyway */
> 	__u8	bus;
> 	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
> };
> 
> struct vfio_device_pci_hot_reset_info {
> 	__u32	argsz;
> 	__u32	flags;
> #define VFIO_PCI_HOT_RESET_SUPPORTED	(1 << 0) /* Device supports hot reset */
> #define VFIO_PCI_HOT_RESET_POPULATED	(1 << 1) /* Entries field are populated */
> 	__u32	count;
> 	struct vfio_device_pci_hot_reset_info_entry	entries[];
> };
> 
> The user calls VFIO_DEVICE_PCI_HOT_RESET_INFO on a VFIO device file
> descriptor with a struct vfio_device_pci_hot_reset_info data structure,
> minimally the sizeof the struct with argsz set.  VFIO returns whether
> hot reset is supported and the number of devices affected by the reset.
> If argsz is big enough, VFIO will fill in the entries and set the
> populated flag, otherwise the caller can reallocate the structure and
> try again.
> 
> /**
>  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + ??,
>  *                                  struct vfio_device_pci_hot_reset)
>  */
> 
> #define VFIO_DEVICE_PCI_HOT_RESET     _IO(VFIO_TYPE, VFIO_BASE + ??)
> 
> struct vfio_device_pci_hot_reset {
> 	__u32	argsz;
> 	__u32	flags;
> 	__u32	count;
> 	__u32	fds[];
> };
> 
> As above, the user calls VFIO_DEVICE_PCI_HOT_RESET on a VFIO device file
> descriptor.  Using the list from PCI_HOT_RESET_INFO, the user allocates
> a struct vfio_device_pci_hot_reset of sufficient size to pass a list of
> VFIO group file descriptors.  There should be one file descriptor for
> each group listed in the info entries.  If the list of groups matches
> those affected by a hot reset of the device, then VFIO will perform the
> hot reset action and return success.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


