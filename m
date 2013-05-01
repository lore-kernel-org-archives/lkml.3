Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3EASnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:43:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916Ab3EASm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:42:58 -0400
Subject: [RFC PATCH 0/8] pci: extended reset capabilities
To: bhelgaas@google.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 01 May 2013 12:42:56 -0600
Message-ID: <20130501181828.28515.68783.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI currently provides pci_reset_function() which will try several
reset mechanisms including PCIe FLR, AF FLR, PM reset, and only if
none of those are available and the device is alone on the bus, a
secondary bus reset.  This is rather limiting because many devices
don't support FLR and don't have useful PM resets.  A driver, like
vfio, that may control all of the devices on a bus needs an interface
to reset a bus even if it has multiple devices.

This series adds pci_reset_slot() and pci_reset_bus() to allow that.
pci_reset_slot() also corrects a problem in the secondary bus reset
path where a bridge supporting pciehp with surprise removal may
detect a device presence change during secondary bus reset and
attempt to remove and re-add the device.  This series allows a driver
to determine which reset mechanisms are available for a device and
upgrade to a slot or bus reset depending on what the platform drivers
support.

I still need to integrate this all the way through to vfio, but I'd
like some feedback on the PCI changes before investing too much in
that.  I'm finding with attempting to support graphics devices
exposed through vfio that they are typically multifunction devices
(func0 = gfx, func1 = audio) where both devices are grouped in the
same iommu group, thus vfio controls both of them.  They don't
support any kind of FLR and a PM reset does nothing.  Also, host
drivers or even userspace drivers, leave the device in an unusable
state, so many users are having problems.  I think these interfaces
should significantly improve our repeatability for such devices.
Thanks,

Alex

---

Alex Williamson (8):
      pci: Create pci_reset_bridge_secondary_bus()
      pci: Add hotplug_slot_ops.reset_slot()
      pci: Add pci_hp_reset_slot
      pci: Implement reset_slot for pciehp
      pci: Add reset_slot option to pci_dev_reset
      pci: Split out pci_dev lock/unlock and save/restore
      pci: Add slot and bus reset interfaces
      pci: Add reset probe functions


 drivers/pci/hotplug/pci_hotplug_core.c |   24 ++
 drivers/pci/hotplug/pciehp.h           |    1 
 drivers/pci/hotplug/pciehp_core.c      |   12 +
 drivers/pci/hotplug/pciehp_hpc.c       |   31 +++
 drivers/pci/pci.c                      |  341 ++++++++++++++++++++++++++++++--
 include/linux/pci.h                    |    6 +
 include/linux/pci_hotplug.h            |   12 +
 7 files changed, 401 insertions(+), 26 deletions(-)
