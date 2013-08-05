Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3HEThJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:37:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab3HEThH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:37:07 -0400
Subject: [PATCH v4 0/9] pci: bus and slot reset interfaces
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: ddutile@redhat.com, indou.takao@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Aug 2013 13:37:03 -0600
Message-ID: <20130805193200.9260.38729.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3: Incorporate feedback from Don:
      - Expand the comment in patch 5
      - Reverse bus/slot unlocking to go up the tree, comments for all

Thanks,
Alex

This series adds PCI bus and slot reset interfaces to the already
existing function reset interface.  I need this for two reasons, the
first is that not all devices support function level reset.  Even
some of those that we detect as supporting a PM reset on D3hot->D0
transition actually don't do any reset.  Others have no reset
capability at all.  We currently implement a secondary bus reset
escalation from the function reset path, but only when there is a
single devfn on the bus.  Drivers like vfio can have ownership of
all of the devices on a bus and should therefore have a path to
initiate a secondary bus reset with multiple devices.  This is
particularly required for use of GPUs by userspace, where none of
the predominant GPUs implement a useful function level reset.

The second reason is that even the current function reset escalating
to a secondary bus reset can cause problems with hotplug controllers.
If a root port supports PCIe HP with suprise removal, a bus reset
can trigger a presence detection change, which results in an attempt
to remove the struct device.  By having a slot reset interface, we
can involve the hotplug controllers to allow for a controlled bus
reset and avoid this spurious removal attempt.

---

Alex Williamson (9):
      pci: Create pci_reset_bridge_secondary_bus()
      pci: Add hotplug_slot_ops.reset_slot()
      pci: Implement reset_slot for pciehp
      pci: Add slot reset option to pci_dev_reset
      pci: Split out pci_dev lock/unlock and save/restore
      pci: Add slot and bus reset interfaces
      pci: Wake-up devices before save for reset
      pci: Tune secondary bus reset timing
      pci: Remove aer_do_secondary_bus_reset()


 drivers/pci/hotplug/pciehp.h       |    1 
 drivers/pci/hotplug/pciehp_core.c  |   12 +
 drivers/pci/hotplug/pciehp_hpc.c   |   31 +++
 drivers/pci/pci.c                  |  348 +++++++++++++++++++++++++++++++++---
 drivers/pci/pcie/aer/aerdrv.c      |    2 
 drivers/pci/pcie/aer/aerdrv.h      |    1 
 drivers/pci/pcie/aer/aerdrv_core.c |   35 ----
 include/linux/pci.h                |    3 
 include/linux/pci_hotplug.h        |    4 
 9 files changed, 375 insertions(+), 62 deletions(-)
