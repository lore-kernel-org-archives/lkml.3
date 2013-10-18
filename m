Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3JSHE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 03:04:59 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:15041 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750948Ab3JSHE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 03:04:58 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 00/29] Introduce pcim_enable_msi*() family helpers
Date: Fri, 18 Oct 2013 19:12:00 +0200
Message-Id: <cover.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is against "next" branch in Bjorn's repo:
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git

Currently many device drivers need contiguously call functions
pci_enable_msix() for MSI-X or pci_enable_msi_block() for MSI
in a loop until success or failure. This update generalizes
this usage pattern and introduces pcim_enable_msi*() family
helpers.

As result, device drivers do not have to deal with tri-state
return values from pci_enable_msix() and pci_enable_msi_block()
functions directly and expected to have more clearer and straight
code.

So i.e. the request loop described in the documentation...

	int foo_driver_enable_msix(struct foo_adapter *adapter,
				   int nvec)
	{
		while (nvec >= FOO_DRIVER_MINIMUM_NVEC) {
			rc = pci_enable_msix(adapter->pdev,
					     adapter->msix_entries,
					     nvec);
			if (rc > 0)
				nvec = rc;
			else
				return rc;
		}

		return -ENOSPC;
	}

...would turn into a single helper call....

	rc = pcim_enable_msix_range(adapter->pdev,
				    adapter->msix_entries,
				    nvec,
				    FOO_DRIVER_MINIMUM_NVEC);


Device drivers with more specific requirements (i.e. a number of
MSI-Xs which is a multiple of a certain number within a specified
range) would still need to implement the loop using the two old
functions.

It is fair to say the proposal in v1 ("Re-design MSI/MSI-X interrupts
enablement pattern")is scrapped. Thus, I do not clarify what are the
changes since v1  - the whole v2 series could be
considered as completely new.

Device driver updates (patches 12-29) are provided to clarify the
change and expected to get reviews in follow-up post(s) when/if
patch 12 ("PCI/MSI: Introduce pcim_enable_msi*() family helpers")
is accepted.

Patches 1,2	- ACK'ed tweaks for s390 architecture
Patches 3,4	- fixes for PowerPC pSeries platform
Patches 5-12	- fixes, tweaks and changes of the generic MSI code
Patches 12-29	- example updates of few device drivers

The tree could be found in "pci-next-msi-v2" branch in repo:
https://github.com/a-gordeev/linux.git

Alexander Gordeev (29):
  PCI/MSI/s390: Fix single MSI only check
  PCI/MSI/s390: Remove superfluous check of MSI type
  PCI/MSI/pSeries: Fix wrong error code reporting
  PCI/MSI/pSeries: Make quota traversing and requesting race-safe
  PCI/MSI: Fix return value when populate_msi_sysfs() failed
  PCI/MSI: Get rid of useless count of msi_desc leftovers
  PCI/MSI: Return -ENOSYS for unimplemented interfaces, not -1
  PCI/MSI: Make pci_enable_msix() 'nvec' argument unsigned int
  PCI/MSI: Factor out pci_get_msi_cap() interface
  PCI/MSI: Get rid of pci_enable_msi_block_auto() interface
  PCI/MSI: Convert pci_msix_table_size() to a public interface
  PCI/MSI: Introduce pcim_enable_msi*() family helpers
  ipr: Do not call pci_disable_msi/msix() if pci_enable_msi/msix()
    failed
  ipr: Make use of pcim_enable_msi/msix() interfaces
  ixgbe: Make use of pcim_enable_msix_range() interface
  ixgbevf: Make use of pcim_enable_msix_range() interface
  megaraid: Make use of pcim_enable_msix() interface
  ntb: Fix missed call to pci_enable_msix()
  ntb: Make use of pcim_enable_msix/msix_exact() interfaces
  qib: Make use of pcim_enable_msix() and pci_msix_table_size()
    interfaces
  qla2xxx: Make use of pcim_enable_msix_range() interface
  qlge: Get rid of an redundant assignment
  qlge: Make use of pcim_enable_msix() interface
  tg3: Make use of pcim_enable_msix() interface
  vmxnet3: Return -EINVAL if number of requested MSI-Xs is not enough
  vmxnet3: Fixup a weird loop exit
  vmxnet3: Return -ENOSPC when not enough MSI-X vectors available
  vmxnet3: Limit number of rx queues to 1 if per-queue MSI-Xs failed
  vmxnet3: Make use of pcim_enable_msix_range() interface

 Documentation/PCI/MSI-HOWTO.txt                   |  169 ++++++++++++++++++---
 arch/powerpc/platforms/pseries/msi.c              |   26 +++-
 arch/s390/pci/pci.c                               |    4 +-
 drivers/ata/ahci.c                                |   56 +++++---
 drivers/infiniband/hw/qib/qib_pcie.c              |   48 +++---
 drivers/net/ethernet/broadcom/tg3.c               |    6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c      |   16 +--
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   33 ++---
 drivers/net/ethernet/qlogic/qlge/qlge_main.c      |   16 +--
 drivers/net/vmxnet3/vmxnet3_drv.c                 |   58 +++-----
 drivers/ntb/ntb_hw.c                              |   34 ++---
 drivers/pci/msi.c                                 |  129 +++++++++-------
 drivers/pci/pcie/portdrv_core.c                   |    5 +-
 drivers/scsi/ipr.c                                |   51 +++----
 drivers/scsi/megaraid/megaraid_sas_base.c         |   16 +--
 drivers/scsi/qla2xxx/qla_isr.c                    |   28 ++--
 include/linux/pci.h                               |   79 +++++++++--
 17 files changed, 466 insertions(+), 308 deletions(-)

-- 
1.7.7.6

