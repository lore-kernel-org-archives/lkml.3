Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbaGPTBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:01:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbaGPTBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:01:15 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/3] vfio-pci: Reset improvements
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Wed, 16 Jul 2014 13:01:10 -0600
Message-ID: <20140716184645.4153.86129.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is intended to improve the state of devices returned back
to the host from vfio-pci or re-used by another user.  First we make
sure that busmaster is disabled in the saved state, so the device
cannot continue to do DMA, then we add some serialization, move our
reference counting under it to fix an unlikely bug should we fail to
initialize a device, and add the ability to do bus/slot reset on
device release.  To do this, we require all devices affected by the
bus/slot reset to be bound to vfio-pci, therefore users sequestering
devices with pci-stub will need to bind them to vfio-pci to see this
change.

The effect of these changes are perhaps most noticeable with GPU
assignment to a VM, where killing QEMU results in a static image on
the framebuffer since no reset of the device was done.  Returning
the GPU to a host device at this point was suspect.  Other devices,
like USB controllers, also don't necessarily appreciate being abruptly
disconnected from their IOMMU domain and would generate IOMMU faults
in the event the user process is killed.  Both of these cases should
be resolved here, assuming all the devices on the bus are bound to
vfio-pci and at least one of the devices in use does not support
a function-local reset.

Please test and comment.  Thanks,

Alex

---

Alex Williamson (3):
      vfio-pci: Attempt bus/slot reset on release
      vfio-pci: Use mutex around open, release, and remove
      vfio-pci: Release devices with BusMaster disabled


 drivers/vfio/pci/vfio_pci.c         |  157 ++++++++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_private.h |    3 -
 2 files changed, 147 insertions(+), 13 deletions(-)
