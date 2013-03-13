Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407Ab3CMX23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:28:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51090 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab3CMX21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:27 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 00/27] PCI: Add for_each_pci_resource and addon_res support
Date: Wed, 13 Mar 2013 16:27:55 -0700
Message-Id: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First part is for_each_pci_resource support:
Now pci device resource iteration is done via "for (i=0...)" open code.
That make code hard to read esp when only bridge or sriov resources
are involved.

We want to replace those open code with for_each_pci_resource() to make
the code more readable.
Also will add addon_resource handling, and need to make addon resource
to be treated as normal PCI resources during iteration, add
for_each_pci_resource will make that support transition more simple.

To make for_each_pci_resource more efficient. We will use preset bitmap
of different type for searching next idx.

Second parts is addon_res support:
Now there is some non normal pci resources other than standard,rom,
sriov, bridges.
Some could be same as standard reg, but using different position.
Some could have own way to read/write to them.
Kernel are using different way to hack those resources like abusing
pci bridge resource spot on non bridge pci device.

Add addon_resources list in pci_dev for those non-standard resources.
With this patch, will treat addon-resource like standard resources with
special ops.

At last replace some quirk_io with addon_res.

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-for-each-res-addon-v3
on top of v3.9-rc2

-v3: rebase on of v3.9-rc2

Thanks

Yinghai Lu

Ram Pai (1):
  PCI: pci resource iterator

Yinghai Lu (26):
  PCI: Add pci_dev_resource_n()
  PCI: Add pci_dev_resource_idx() helper
  PCI: Add is_pci_*_resource_idx() helpers
  PCI: Update pci_resource_start etc to use pci_dev_resource_n()
  PCI, x86: Use for_each_pci_resource() with pci_allocate_bridge_resources
  PCI, x86: Use for_each_pci_resource() with pci_allocate_dev_resources
  PCI: Use for_each_pci_resource() with IOV releated functions
  PCI, acpiphp: Use for_each_pci_resource() helper
  PCI, pciehp: Use for_each_pci_resource() helper
  PCI: Use for_each_pci_resource() in pci_enable_dev
  PCI: Use for_each_pci_resource() in pci_reassigndev
  PCI: Use for_each_pci_resource() with pci bar reassign funcs
  PCI: Use for_each_pci_resource() in pci_assign_resource
  PCI, x86: Use for_each_pci_resource() with noassign_bars
  PCI: Use for_each_pci_resource() in pci_dev_driver()
  PCI: Use for_each_pci_resource() in pci resource release
  PCI: Use for_each_pci_resource() in pci bases reading
  PCI, x86: Use for_each_pci_resource() with mrst
  PCI, xen: Use for_each_pci_resource() with xen pci
  PCI: Add addon_resource support for pci devices
  PCI: Add helpers to add addon_resource
  PCI: Update pci_resource_bar() to support addon_resource
  PCI: Assign/update resource to addon_res
  PCI: Make piix4 quirk to use addon_res
  PCI: Make quirk_io_region to use addon_res
  PCI: Use addon_fixed_resource with ati fixed resource

 arch/x86/pci/common.c              |    3 +-
 arch/x86/pci/i386.c                |   58 +++-----
 arch/x86/pci/mrst.c                |    7 +-
 drivers/pci/hotplug/acpiphp_glue.c |    4 +-
 drivers/pci/hotplug/pciehp_hpc.c   |    5 +-
 drivers/pci/iov.c                  |   31 +++--
 drivers/pci/pci-driver.c           |    6 +-
 drivers/pci/pci.c                  |   27 ++--
 drivers/pci/probe.c                |  176 ++++++++++++++++++++++++-
 drivers/pci/quirks.c               |  256 +++++++++++++++++++++---------------
 drivers/pci/remove.c               |    5 +-
 drivers/pci/setup-bus.c            |   28 ++--
 drivers/pci/setup-res.c            |   38 ++++--
 drivers/pci/xen-pcifront.c         |    4 +-
 include/linux/pci.h                |   79 ++++++++++-
 15 files changed, 508 insertions(+), 219 deletions(-)

-- 
1.7.10.4

