Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab3KZUse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:48:34 -0500
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:52453 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932300Ab3KZUsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:48:32 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v3 00/11] Introduce pcim_enable_msi*() family helpers
Date: Tue, 26 Nov 2013 10:09:49 +0100
Message-Id: <cover.1385399393.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is against "next" branch in Bjorn's repo:
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git

Changes from v2 to v3:
  - new public interfaces commented in drivers/pci/msi.c;
  - patch "Make quota traversing and requesting race-safe" explained;
  - pci_enable_msi/msix() 'nvec' arg type changed from 'unsigned int' to 'int';
  - pcim_enable_msi*() arg 'nvec' renamed to 'maxvec' when upper limit passed;
  - pcim_enable_msi*(..., maxvec, minvec) arg order swapped to minvec, maxvec;
  - "PCI: Fail MSI/MSI-X initialization if device is not in PCI_D0" commit
    869a161 and "PCI/MSI: Factor out pci_get_msi_cap() interface" patch
    conflicts resolved;

Tejun, due to last three changes will you keep your "Acked-By" and
"Reviewed-by" on these patches?
  PCI/MSI: Factor out pci_get_msi_cap() interface
  PCI/MSI: Get rid of pci_enable_msi_block_auto() interface
  PCI/MSI: Convert pci_msix_table_size() to a public interface
  PCI/MSI: Introduce pcim_enable_msi*() family helpers

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
				    FOO_DRIVER_MINIMUM_NVEC,
				    nvec);

Device drivers with more specific requirements (i.e. a number of
MSI-Xs which is a multiple of a certain number within a specified
range) would still need to implement the loop using the two old
functions.

Patches 1,2	- ACK'ed tweaks for s390 architecture
Patches 3,4	- fixes for PowerPC pSeries platform
Patches 5-11	- fixes, tweaks and changes of the generic MSI code

The tree could be found in "pci-next-msi-v3" branch in repo:
https://github.com/a-gordeev/linux.git

Alexander Gordeev (11):
  PCI/MSI/s390: Fix single MSI only check
  PCI/MSI/s390: Remove superfluous check of MSI type
  PCI/MSI/pSeries: Fix wrong error code reporting
  PCI/MSI/pSeries: Make quota traversing and requesting race-safe
  PCI/MSI: Fix return value when populate_msi_sysfs() failed
  PCI/MSI: Return -ENOSYS for unimplemented interfaces, not -1
  PCI/MSI: Make pci_enable_msi/msix() 'nvec' argument type as int
  PCI/MSI: Factor out pci_get_msi_cap() interface
  PCI/MSI: Get rid of pci_enable_msi_block_auto() interface
  PCI/MSI: Convert pci_msix_table_size() to a public interface
  PCI/MSI: Introduce pcim_enable_msi*() family helpers

 Documentation/PCI/MSI-HOWTO.txt      |  175 +++++++++++++++++++++++++++++-----
 arch/powerpc/platforms/pseries/msi.c |   26 +++++-
 arch/s390/pci/pci.c                  |    4 +-
 drivers/ata/ahci.c                   |   56 +++++++----
 drivers/pci/msi.c                    |  157 +++++++++++++++++++++++--------
 drivers/pci/pcie/portdrv_core.c      |    5 +-
 include/linux/pci.h                  |   72 ++++++++++++--
 7 files changed, 395 insertions(+), 100 deletions(-)

-- 
1.7.7.6

