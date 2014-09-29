Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbaI2ObS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:31:18 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50506 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754068AbaI2ObI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:31:08 -0400
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
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>
Subject: [PATCH v13 00/12] Support for creating generic PCI host bridges from DT
Date: Mon, 29 Sep 2014 15:29:19 +0100
Message-Id: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my version 13 of the attempt at adding support for generic PCI host
bridge controllers. It contains only cleanups to make it play nice with the
linux-next tree as of 09/25. If Bjorn deems it safe, now that it looks like
asm-generic is going to revert some of its more aggresive patches, he has the
choice of queueing it into linux-next again.

Changes from v12:
- refreshed the whole series based on what Bjorn has submitted into linux-next.
  He has added Signed-off-bys and change the title of some commits, plus
  reworked the patches that move of_pci_range_to_resource() from of_address.h into
  address.c.
- updated "[PATCH 01/12] asm-generic/io.h: Fix ioport_map() for !CONFIG_GENERIC_IOMAP"
  to match the patch that Thierry Reding has submitted through the asm-generic branch.
  If his series lands first upstream this patch will be skipped.
- updated "[PATCH 03/12] ARM: Define PCI_IOBASE as the base of virtual PCI IO space" to
  cast the PCI_IOBASE value to (void __iomem *) as is the case with most #defined versions
- dropped the patch that was changing the order of initialisation between pci_host_bridge
  and root bus in pci_create_root_bus()
- fixed "[PATCH 07/12] PCI: Add generic domain handling" to account for the previous patch
  being removed
- fixed the title of commit 08/12 to reflect the name of the functions that are actually
  added (s/of_pci_get_domain_nr/pci_get_new_domain_nr/)

v12 thread here: https://lkml.org/lkml/2014/9/23/852
v11 thread here: https://lkml.org/lkml/2014/9/17/732
v10 thread here: https://lkml.org/lkml/2014/9/8/333
v9 thread here, with links to previous threads: https://lkml.org/lkml/2014/8/12/361

Best regards,
Liviu


Bjorn Helgaas (1):
  of/pci: Define of_pci_range_to_resource() only when CONFIG_PCI=y

Catalin Marinas (1):
  PCI: Add generic domain handling

Liviu Dudau (10):
  asm-generic/io.h: Fix ioport_map() for !CONFIG_GENERIC_IOMAP
  of/pci: Add pci_register_io_range() and pci_pio_to_address()
  ARM: Define PCI_IOBASE as the base of virtual PCI IO space
  of/pci: Move of_pci_range_to_resources() to of/address.c
  of/pci: Fix the conversion of IO ranges into IO resources
  of/pci: Add pci_get_new_domain_nr() and of_get_pci_domain_nr()
  of/pci: Add support for parsing PCI host bridge resources from DT
  PCI: Assign unassigned bus resources in pci_scan_root_bus()
  PCI: Add pci_remap_iospace() to map bus I/O resources
  arm64: Add architectural support for PCI

 arch/arm/include/asm/io.h         |   1 +
 arch/arm/mach-integrator/pci_v3.c |  23 +++---
 arch/arm64/Kconfig                |  22 +++++-
 arch/arm64/include/asm/Kbuild     |   1 +
 arch/arm64/include/asm/io.h       |   3 +-
 arch/arm64/include/asm/pci.h      |  37 +++++++++
 arch/arm64/include/asm/pgtable.h  |   2 +
 arch/arm64/kernel/Makefile        |   1 +
 arch/arm64/kernel/pci.c           |  70 +++++++++++++++++
 drivers/of/address.c              | 154 ++++++++++++++++++++++++++++++++++++++
 drivers/of/of_pci.c               | 142 +++++++++++++++++++++++++++++++++++
 drivers/pci/host/pci-tegra.c      |  10 ++-
 drivers/pci/host/pcie-rcar.c      |  21 ++++--
 drivers/pci/pci.c                 |  40 ++++++++++
 drivers/pci/probe.c               |  14 +++-
 include/asm-generic/io.h          |   2 +-
 include/asm-generic/pgtable.h     |   4 +
 include/linux/of_address.h        |  17 ++---
 include/linux/of_pci.h            |  13 ++++
 include/linux/pci.h               |  27 +++++++
 20 files changed, 566 insertions(+), 38 deletions(-)
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/kernel/pci.c

-- 
2.1.1

