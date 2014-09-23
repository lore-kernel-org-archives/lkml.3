Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbaIWUE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:04:59 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50315 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751307AbaIWUE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:04:57 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v12 00/12] Support for creating generic PCI host bridges from DT
Date: Tue, 23 Sep 2014 20:01:02 +0100
Message-Id: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my version 12 of the attempt at adding support for generic PCI host
bridge controllers that make use of device tree information to
configure themselves. It contains cleanups to address comments posted for v11.

Bjorn intends to pull this series into his tree and send it to linux-next if
no major issues arise.


Changes from v11:
 - fixed race condition in pci_register_io_range() and bug where the function
   would return with the io_range_lock held.
 - split patch 4/10 that fixes the convertion of IO ranges into resources into
   two patches. The new 4/12 just moves the function into drivers/of/address.c
   and 5/12 makes the functional changes.
 - Added Linus Walleij ACK on 5/12 for the arch/arm/mach-integrator/pci_v3.c
   part
 - Removed the old PCI domain number parser and allocator and split the code
   into two independent functions: 'int pci_get_new_domain_nr(void)' will
   always return a new domain number when called while 'of_get_pci_domain_nr()'
   will parse the DT and try to find a property of the given node called
   'linux,pci-domain'. The property value, if found, will be truncated to
   16-bit value and returned, or a negative value if an error occurs.
 - Made the io_base pointer parameter that gets passed to
   of_pci_get_host_bridge_resources() optional (thanks Robert Richter) and
   be explicit when detecting multiple IO ranges about the device used.
 - Fixed comments on commits to explain who uses pci_remap_iospace() as well
   as making clear that the value used inside the function is a virtual address
   and not a physical one. Also be explicit in the warning generated when
   architectures without memory mapped IO support make use of this function
 - Merged the arm64 patch into this series as Bjorn is going to pull it
   into his tree.

Changes from v10:
 - Addressed Lorenzo's comments wrt io_base not being initialised inside the
   function that is supposed to modify it and also updated the comments to
   explain the values returned by the function
 - Updated pci_domain_nr helper function to split the allocation of the domain
   number from the parsing of the device tree to find maximum defined domain
   value
 - Fixed up the commit author for commit 6/10

Changes from v9:
 - Moved the DT parsing and assigning of IRQ patch from this series into arm64
   specific patch. This keeps existing pcibios_add_device() unchanged and adds
   an arch-specific version that can later be expanded to cater for dma_ops.
 - Incorporated the fix for users of of_pci_range_to_resources() into the patch
   that changes the behaviour for easier bisection.
 - Added fixes for tegra and rcar host drivers in their usage of
   of_pci_range_to_resources()
 - Broke up of_create_pci_host_bridge() to remove the callback function. The
   function left has been renamed into of_pci_get_host_bridge_resources(). The
   added benefit of that is that the architectural hook for fixing up host bridge
   resources now dissappears.
 - Reshuffled the way pgprot_device gets introduced. It is now part of the patch
   that adds pci_remap_iospace() function. The arm64 specific override is moved
   into the arm64 patchset.
 - Added a patch to pci_scan_root_bus() to assign unassigned resources if PCI
   flags are not PCI_PROBE_ONLY

v11 thread here: https://lkml.org/lkml/2014/9/17/732
v10 thread here: https://lkml.org/lkml/2014/9/8/333
v9 thread here, with links to previous threads: https://lkml.org/lkml/2014/8/12/361

Best regards,
Liviu

Catalin Marinas (1):
  PCI: Introduce generic domain handling for PCI busses.

Liviu Dudau (11):
  Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
  PCI: Introduce helper functions to deal with PCI I/O ranges.
  ARM: Define PCI_IOBASE as the base of virtual PCI IO space.
  PCI: OF: Move of_pci_range_to_resources() into address.c
  PCI: OF: Fix the conversion of IO ranges into IO resources.
  PCI: Create pci_host_bridge before its associated bus in pci_create_root_bus.
  PCI: OF: Introduce helper function for retrieving PCI domain numbers
  OF: PCI: Add support for parsing PCI host bridge resources from DT
  PCI: Assign unassigned bus resources in pci_scan_root_bus()
  PCI: Introduce pci_remap_iospace() for remapping PCI I/O bus resources into CPU space
  arm64: Add architectural support for PCIe

 arch/arm/include/asm/io.h         |   1 +
 arch/arm/mach-integrator/pci_v3.c |  23 +++---
 arch/arm64/Kconfig                |  22 +++++-
 arch/arm64/include/asm/Kbuild     |   1 +
 arch/arm64/include/asm/io.h       |   3 +-
 arch/arm64/include/asm/pci.h      |  37 +++++++++
 arch/arm64/include/asm/pgtable.h  |   2 +
 arch/arm64/kernel/Makefile        |   1 +
 arch/arm64/kernel/pci.c           |  70 +++++++++++++++++
 drivers/of/address.c              | 155 ++++++++++++++++++++++++++++++++++++++
 drivers/of/of_pci.c               | 140 ++++++++++++++++++++++++++++++++++
 drivers/pci/host/pci-tegra.c      |  10 ++-
 drivers/pci/host/pcie-rcar.c      |  21 ++++--
 drivers/pci/pci.c                 |  43 +++++++++++
 drivers/pci/probe.c               |  46 ++++++-----
 include/asm-generic/io.h          |   2 +-
 include/asm-generic/pgtable.h     |   4 +
 include/linux/of_address.h        |  22 +++---
 include/linux/of_pci.h            |  18 +++++
 include/linux/pci.h               |  27 +++++++
 20 files changed, 596 insertions(+), 52 deletions(-)
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/kernel/pci.c

-- 
2.1.0

