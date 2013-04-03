Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385Ab3DCOpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:45:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60053 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844Ab3DCOpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:45:49 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 00/12] Rewrite Tegra PCIe driver
Date: Wed,  3 Apr 2013 16:45:06 +0200
Message-Id: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.2
X-Provags-ID: V02:K0:DQlrIgyrhpLUmkoZgM+TQkexX/tAoNw4hgIfZnhOMiF
 IOyJ6itpRWkcMlFy2JjP7gf1ieDw/MCLuRPRjbUg5TR4oRM2YC
 rIvwna38MtJ5RDCDxhZbwf/smtba0OZ38jHDsOMWr2J072TH1G
 OkxGBbDPdKcqLMxKlJp/G3Hrk8nGvwrDaGu+C8CKR4OFY1eduo
 gK+07zAKJvYjaPyGzIOT/R8ChXfmoIQYnLq8XUEeyPm1Uw2bDD
 BkynnCHXe4lQWonM/7D6oXqT7420MuSiCTd/j2WO8DFNnv4+Z8
 LCwMpNwE2OkzBGQnnUn8wrqHT/PbN7IClQo942+nNDVhH4ZYpT
 Jzmrxevp9+w3TUt0rjZq0hTlBPuZBLmSUI0C2AY8aA24kftEEM
 NXFQhXiFz5l4gG5R+LpQw8bv59QLwL+HNyySJWApnxCAiSYK16
 uiYXM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains an almost complete rewrite of the Tegra PCIe
driver. The code is moved to the drivers/pci/host directory and turned
into a proper platform driver, adding MSI and DT support while at it.
Other PCI host controller drivers can be added to that directory in an
attempt to make it easier to factor out common code.

Patches 1 to 3 add generic OF helpers to parse a PCI node's ranges
property as well as obtain the device and function numbers from a node's
reg property.

Patch 4 introduces a new MSI chip infrastructure which is required to
make multiple platform-specific implementations of the MSI support
functions coexist peacefully.

Patches 5 and 6 move some of the Tegra specific code around to allow it
to be used from outside the arch/arm/mach-tegra directory.

Patch 7 moves the Tegra PCIe controller driver to the drivers/pci/host
directory and turns it into a proper platform driver. It also adds MSI
(based on patches by NVIDIA) and DT support.

Patches 8 to 11 add device tree based probing for the TEC, Harmony and
TrimSlice boards. Finally the default configuration for Tegra is updated
in patch 12.

Thierry

Andrew Murray (1):
  of/pci: Provide support for parsing PCI DT ranges property

Thierry Reding (11):
  of/pci: Add of_pci_get_devfn() function
  of/pci: Add of_pci_parse_bus_range() function
  PCI: Introduce new MSI chip infrastructure
  ARM: tegra: Move tegra_pcie_xclk_clamp() to PMC
  ARM: tegra: Move pmc.h to include/linux/tegra-pmc.h
  PCI: tegra: Move PCIe driver to drivers/pci/host
  ARM: tegra: tamonten: Add PCIe support
  ARM: tegra: tec: Add PCIe support
  ARM: tegra: harmony: Initialize PCIe from DT
  ARM: tegra: trimslice: Initialize PCIe from DT
  ARM: tegra: Update default configuration (PCIe)

 .../bindings/pci/nvidia,tegra20-pcie.txt           |  123 ++
 arch/arm/boot/dts/tegra20-harmony.dts              |   20 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |   17 +-
 arch/arm/boot/dts/tegra20-tec.dts                  |    8 +
 arch/arm/boot/dts/tegra20-trimslice.dts            |   28 +
 arch/arm/boot/dts/tegra20.dtsi                     |   53 +
 arch/arm/configs/tegra_defconfig                   |    4 +-
 arch/arm/mach-tegra/Kconfig                        |    7 +-
 arch/arm/mach-tegra/Makefile                       |    3 -
 arch/arm/mach-tegra/board-harmony-pcie.c           |   89 --
 arch/arm/mach-tegra/board.h                        |    8 -
 arch/arm/mach-tegra/iomap.h                        |    3 -
 arch/arm/mach-tegra/pcie.c                         |  886 -----------
 arch/arm/mach-tegra/pmc.c                          |   16 +
 arch/arm/mach-tegra/tegra.c                        |   24 -
 arch/microblaze/pci/pci-common.c                   |  110 +-
 arch/mips/pci/pci.c                                |   50 +-
 arch/powerpc/kernel/pci-common.c                   |   99 +-
 drivers/of/address.c                               |   63 +
 drivers/of/of_pci.c                                |   59 +-
 drivers/pci/Kconfig                                |    2 +
 drivers/pci/Makefile                               |    3 +
 drivers/pci/host/Kconfig                           |    8 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-tegra.c                       | 1560 ++++++++++++++++++++
 drivers/pci/msi.c                                  |   35 +-
 drivers/pci/probe.c                                |    1 +
 include/linux/msi.h                                |   10 +
 include/linux/of_address.h                         |   42 +
 include/linux/of_pci.h                             |    2 +
 include/linux/pci.h                                |    1 +
 include/linux/tegra-pmc.h                          |   23 +
 32 files changed, 2155 insertions(+), 1203 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
 delete mode 100644 arch/arm/mach-tegra/board-harmony-pcie.c
 delete mode 100644 arch/arm/mach-tegra/pcie.c
 create mode 100644 drivers/pci/host/Kconfig
 create mode 100644 drivers/pci/host/Makefile
 create mode 100644 drivers/pci/host/pci-tegra.c
 create mode 100644 include/linux/tegra-pmc.h

-- 
1.8.2

