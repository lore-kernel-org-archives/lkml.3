Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab3HAWS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:18:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923Ab3HAWSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:18:25 -0400
Message-ID: <1375395497.31262.271.camel@ul30vt.home>
Subject: RFC: vfio-pci API for PCI bus/slot (hot) resets
From: Alex Williamson <alex.williamson@redhat.com>
To: kvm <kvm@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 01 Aug 2013 16:18:17 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfio-pci needs to support an interface to do hot resets (PCI parent
bridge secondary bus reset).   We need this to support reset of
co-assigned devices where one or more of the devices does not support
function level reset.  In particular, discrete graphics cards typically
have no reset options other than doing a link reset.  What I have below
is a bit awkward, so I welcome other ideas to accomplish this goal.
I've been using a "blind" interface based on all affected devices
belonging to the same VFIO container for current VGA testing.  This is
ok when all you want to do is VGA, but I'd really like to make use of
this any time a device doesn't support a function level reset.  I've
posted a series to the PCI list to add bus and slot reset interfaces to
PCI-core, this API is how we expose that through VFIO to a user.  Please
comment.  Thanks,

Alex

---
Mechanism to do PCI hot resets through VFIO:

VFIO is fundamentally an IOMMU group and device level interface.
There's no concept of buses, slots, or hierarchies of devices.  There
are only IOMMU group and devices.  A bus (or slot) may contain exactly
one IOMMU group, multiple IOMMU groups, or a portion of an IOMMU group.
An IOMMU group may contain one or more devices.

The first question is perhaps where should we create the interface to do
a PCI hot reset.  Assuming an ioctl interface, our choices are the
group, the container, or the device file descriptors.  Groups and
containers are not PCI specific, so an extension on either of those
doesn't make much sense.  They also don't have much granularity if your
goal is to do a hot reset on the smallest subset of devices you can.
Therefore the only choice seems to be a VFIO device level interface.

The fact that a hot reset affects multiple devices also raises concerns.
How do we make sure a user has sufficient access/privilege to perform
this operation?  If all of the affected devices are within the same
group, then we know the user already "owns" all those devices.  Using
groups as the boundary excludes a number of use cases though.  The user
would need to prove that they also own the other groups or devices that
are affected by the reset.  This might be multiple groups, so the ioctl
quickly grows to requiring a list of file descriptors be passed for
validation.

We already use the group file descriptor as a unit of ownership for
enabling the container, so it seems like it would make sense to use it
here too.  The alternative is a device file descriptor, but groups may
encompass devices the user doesn't care to use and we don't want to
require that they open a file descriptor simply to perform a hot reset.
Groups can also contain devices that the user cannot open, for instance
those owned by VFIO "compatible" drivers like pci-stub or pcieport.

The user also needs to know the set of devices affected by a hot reset,
otherwise they have no idea which group file descriptors to pass to such
an interface.  That implies we also need a separate "info" ioctl for the
user to learn that information.  We could argue that the user could
learn this information from sysfs, but that imposes non-trivial library
or code overhead on the user to evaluate the topology.  The PCI hot
reset info ioctl would need to indicate whether a hot reset is
available, and the set of affected devices.  It may be useful to provide
this as a {group, device} pair so the user doesn't need to
cross-reference each device with sysfs to determine the group for the
device.  This would then provide both the set of groups required to
perform the hot reset and the set of devices affected by the hot reset.

As an alternative, we could consider simply requiring that all of the
devices affected by a hot reset belong to the same VFIO container.
However, allowing multiple groups per container is an optional IOMMU
capability that really has no relation to PCI bus/slot boundaries.  It
seems a bit arbitrary to require groups be placed in the same container
to get a PCI hot reset.  That likely means we'd still need to support
passing some kind of ownership token as above with groups.  So it
doesn't seem to make the situation any better.

Given the above discussion, I therefore propose the following PCI hot
reset interface:

/**
 * VFIO_DEVICE_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + ??,
 *                                        struct vfio_device_pci_hot_reset_info)
 */

#define VFIO_DEVICE_PCI_HOT_RESET_INFO     _IO(VFIO_TYPE, VFIO_BASE + ??)

struct vfio_device_pci_hot_reset_info_entry {
	__u32	group_id;
	__u16	segment; /* A reset will never include devices on other segments... return it anyway */
	__u8	bus;
	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
};

struct vfio_device_pci_hot_reset_info {
	__u32	argsz;
	__u32	flags;
#define VFIO_PCI_HOT_RESET_SUPPORTED	(1 << 0) /* Device supports hot reset */
#define VFIO_PCI_HOT_RESET_POPULATED	(1 << 1) /* Entries field are populated */
	__u32	count;
	struct vfio_device_pci_hot_reset_info_entry	entries[];
};

The user calls VFIO_DEVICE_PCI_HOT_RESET_INFO on a VFIO device file
descriptor with a struct vfio_device_pci_hot_reset_info data structure,
minimally the sizeof the struct with argsz set.  VFIO returns whether
hot reset is supported and the number of devices affected by the reset.
If argsz is big enough, VFIO will fill in the entries and set the
populated flag, otherwise the caller can reallocate the structure and
try again.

/**
 * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + ??,
 *                                  struct vfio_device_pci_hot_reset)
 */

#define VFIO_DEVICE_PCI_HOT_RESET     _IO(VFIO_TYPE, VFIO_BASE + ??)

struct vfio_device_pci_hot_reset {
	__u32	argsz;
	__u32	flags;
	__u32	count;
	__u32	fds[];
};

As above, the user calls VFIO_DEVICE_PCI_HOT_RESET on a VFIO device file
descriptor.  Using the list from PCI_HOT_RESET_INFO, the user allocates
a struct vfio_device_pci_hot_reset of sufficient size to pass a list of
VFIO group file descriptors.  There should be one file descriptor for
each group listed in the info entries.  If the list of groups matches
those affected by a hot reset of the device, then VFIO will perform the
hot reset action and return success.

