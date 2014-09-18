Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbaIRBck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 21:32:40 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54523 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756264AbaIRBcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 21:32:05 -0400
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
Subject: [PATCH v11 00/10] Support for creating generic PCI host bridges from DT
Date: Thu, 18 Sep 2014 02:30:15 +0100
Message-Id: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my version 11 of the attempt at adding support for generic PCI host
bridge controllers that make use of device tree information to
configure themselves. It contains minor cleanups compared with v10 to address
the existing comments.

I'm going to ask for this series to be included in -next.

Example on how a host bridge driver can use the series:

static int foohb_probe(struct platform_device *pdev)
{
	struct device_node *dn = pdev->dev.of_node;
	struct foohb_drv *drv;
	resource_size_t io_base = 0;  /* phys address for start of IO */
	struct pci_bus *bus;
	int err = 0;
	LIST_HEAD(res);

	.....
	err = of_pci_get_host_bridge_resources(dn, 0, 255, &res, &io_base);
	if (err)
		goto err_handling;
	err = foohb_setup(drv, ...., &res, &io_base);
	if (err)
		goto err_handling;
	.....
	pci_add_flags(....);
	bus = pci_scan_root_bus(&pdev->dev, 0, &foohb_ops, drv, &res);
	if (!bus)
		goto err_handling;
	....
	return 0;

err_handling:
	......
	return err;
}

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

v10 thread here: https://lkml.org/lkml/2014/9/8/333
v9 thread here, with links to previous threads: https://lkml.org/lkml/2014/8/12/361

Best regards,
Liviu

Catalin Marinas (1):
  PCI: Introduce generic domain handling for PCI busses.

Liviu Dudau (9):
  Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
  PCI: Introduce helper functions to deal with PCI I/O ranges.
  ARM: Define PCI_IOBASE as the base of virtual PCI IO space.
  PCI: OF: Fix the conversion of IO ranges into IO resources.
  PCI: Create pci_host_bridge before its associated bus in
    pci_create_root_bus.
  OF: Introduce helper function for getting PCI domain_nr
  OF: PCI: Add support for parsing PCI host bridge resources from DT
  PCI: Assign unassigned bus resources in pci_scan_root_bus()
  PCI: Introduce pci_remap_iospace() for remapping PCI I/O bus resources
    into CPU space

 arch/arm/include/asm/io.h         |   1 +
 arch/arm/mach-integrator/pci_v3.c |  23 +++---
 drivers/of/address.c              | 146 ++++++++++++++++++++++++++++++++
 drivers/of/of_pci.c               | 170 ++++++++++++++++++++++++++++++++++++++
 drivers/pci/host/pci-tegra.c      |  10 ++-
 drivers/pci/host/pcie-rcar.c      |  21 +++--
 drivers/pci/pci.c                 |  33 ++++++++
 drivers/pci/probe.c               |  46 +++++++----
 include/asm-generic/io.h          |   2 +-
 include/asm-generic/pgtable.h     |   4 +
 include/linux/of_address.h        |  15 +---
 include/linux/of_pci.h            |  18 ++++
 include/linux/pci.h               |  24 ++++++
 13 files changed, 463 insertions(+), 50 deletions(-)

-- 
2.1.0

