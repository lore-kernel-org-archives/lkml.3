Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3L3H1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:27:03 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:14215 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751230Ab3L3H1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:27:00 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v5 0/4] Introduce pci_enable_msi/msix_range() interfaces
Date: Mon, 30 Dec 2013 08:28:12 +0100
Message-Id: <cover.1388262668.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is against "next" branch in Bjorn's repo:
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git

Changes from v4 to v5:
  - pci_auto_enable_msi* functions renamed to pci_enable_msi* ones;
  - pci_enable_msi_range() and pci_enable_msix_range() are the only
    basic interfaces left to enable MSI/MSI-X operation;
  - pci_enable_msi(), pci_enable_msi_block() and pci_enable_msix() old
    interfaces deprecated in favour of pci_enable_msi/msix_range() ones;
    description of the old interfaces is removed from the documentation;
  - pci_get_msi_vec_count()  renamed to pci_msi_vec_count() and
    pci_get_msix_vec_count() renamed to pci_msix_vec_count();

Changes from v3 to v4:
  - pcim_enable_msi* functions renamed to pci_auto_enable_msi* ones;
  - PowerPC patches dropped;
  - pci_get_msi_cap()     renamed to pci_get_msi_vec_count() and
    pci_msix_table_size() renamed to pci_get_msix_vec_count();

Changes from v2 to v3:
  - new public interfaces commented in drivers/pci/msi.c;
  - patch "Make quota traversing and requesting race-safe" explained;
  - pci_enable_msi/msix() 'nvec' arg type changed from 'unsigned int' to 'int';
  - pcim_enable_msi*() arg 'nvec' renamed to 'maxvec' when upper limit passed;
  - pcim_enable_msi*(..., maxvec, minvec) arg order swapped to minvec, maxvec;
  - "PCI: Fail MSI/MSI-X initialization if device is not in PCI_D0" commit
    869a161 and "PCI/MSI: Factor out pci_get_msi_cap() interface" patch
    conflicts resolved;

This update introduces pci_enable_msi_range() function which
supersedes pci_enable_msi() and pci_enable_msi_block()
interfaces for MSI and pci_enable_msi_range() function which
supersedes pci_enable_msix() interface for MSI-X interrupts.

The plan is to convert all drivers to the new interfaces and
then remove existing pci_enable_msi(), pci_enable_msi_block()
and pci_enable_msix() functions.

The newly introduced functions return either a negative error
code or a number of successfully allocated MSI/MSI-X interrupts.

Unlike the old interfaces where the "third" state indicates
a possible number of MSI interrupts that could have been
allocated, the new interfaces allow device drivers not to deal
with tri-state return values and hide fallback logic behind
the implementation.

As result, device drivers are expected to have more clearer
and straight code.

The tree could be found in "pci-next-msi-v5" branch in repo:
https://github.com/a-gordeev/linux.git

Alexander Gordeev (4):
  PCI/MSI: Factor out pci_msi_vec_count() interface
  PCI/MSI: Get rid of pci_enable_msi_block_auto() interface
  PCI/MSI: Introduce pci_msix_vec_count() interface
  PCI/MSI: Introduce pci_enable_msi/msix_range() interfaces

 Documentation/PCI/MSI-HOWTO.txt |  308 ++++++++++++++++++++++++++-------------
 drivers/ata/ahci.c              |   56 +++++---
 drivers/pci/msi.c               |  150 +++++++++++++++-----
 drivers/pci/pcie/portdrv_core.c |    7 +-
 include/linux/pci.h             |   27 +++-
 5 files changed, 385 insertions(+), 163 deletions(-)

-- 
1.7.7.6

