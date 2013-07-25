Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3GYRxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:53:42 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:33628 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab3GYRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:53:39 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jay Agarwal <jagarwal@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 00/16] Rewrite Tegra PCIe driver
Date: Thu, 25 Jul 2013 10:53:14 -0700
Message-Id: <1374774810-18459-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This patch series contains an almost complete rewrite of the Tegra PCIe
driver. The code is moved to the drivers/pci/host directory and turned
into a proper platform driver, adding MSI and DT support while at it.

Patches 1 and 2 move some of the Tegra specific code around to allow it
to be used from outside the arch/arm/mach-tegra directory.

Patch 3 moves the Tegra PCIe controller driver to the drivers/pci/host
directory and turns it into a proper platform driver while adding MSI
(based on patches from NVIDIA) and DT support.

Patches 4 to 7 add Tegra20 board support for PCIe via DT.

Patch 8 adds Tegra30 PCIe support to the driver, which is fixed up by
patch 9. These haven't been squashed to keep the history since most of
this work has been done over several months.

Patch 10 adds DT support for Tegra30 and patches 11 to 13 enable PCIe
support on Tegra30-based Cardhu and Beaver boards.

Patch 14 enables PCI in the Tegra default configuration. Patch 15
increases the prefetchable memory size to accomodate more use-cases and
patch 16 finally adds me as the maintainer of the Tegra PCIe driver in
the MAINTAINERS file.

Note that this patch series depends on patches posted by Thomas
Petazzoni for Marvell PCIe support. They can be found here:

  - [PATCHv5 02/11] PCI: use weak functions for MSI arch-specific functions
    http://www.spinics.net/lists/linux-pci/msg23802.html

  - [PATCHv5 04/11] PCI: Introduce new MSI chip infrastructure
    http://www.spinics.net/lists/linux-pci/msg23797.html

  - [PATCHv5 08/11] ARM: pci: add ->add_bus() and ->remove_bus() hooks to hw_pci
    http://www.spinics.net/lists/linux-pci/msg23801.html

So it would be great if we could set up a stable branch that contains
those three, which could then be pulled into the Marvell and Tegra
branches.

For this series, patches 3, 8 and 9 will require Bjorn's Acked-by so
that Stephen can take them through the Tegra tree, which I think both of
them already agreed on to being the best solution.

Thierry

Jay Agarwal (3):
  PCI: tegra: Add Tegra 30 PCIe support
  ARM: tegra: Enable PCIe controller on Cardhu
  ARM: dts: tegra: Increase prefetchable PCI memory space

Stephen Warren (2):
  PCI: tegra: set up PADS_REFCLK_CFG1
  ARM: tegra: Fix Beaver's PCIe lane configuration

Thierry Reding (11):
  ARM: tegra: Move tegra_pcie_xclk_clamp() to PMC
  ARM: tegra: Move pmc.h to include/linux/tegra-pmc.h
  PCI: tegra: Move PCIe driver to drivers/pci/host
  ARM: tegra: tamonten: Add PCIe support
  ARM: tegra: tec: Add PCIe support
  ARM: tegra: harmony: Initialize PCIe from DT
  ARM: tegra: trimslice: Initialize PCIe from DT
  ARM: tegra: Add Tegra30 PCIe support
  ARM: tegra: Enable PCIe controller on Beaver
  ARM: tegra: Update default configuration (PCIe)
  MAINTAINERS: Add myself as Tegra PCIe maintainer

 .../bindings/pci/nvidia,tegra20-pcie.txt           |  163 ++
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/tegra20-harmony.dts              |   20 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |   17 +-
 arch/arm/boot/dts/tegra20-tec.dts                  |    8 +
 arch/arm/boot/dts/tegra20-trimslice.dts            |   28 +
 arch/arm/boot/dts/tegra20.dtsi                     |   55 +
 arch/arm/boot/dts/tegra30-beaver.dts               |   21 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |   20 +
 arch/arm/boot/dts/tegra30.dtsi                     |   70 +
 arch/arm/configs/tegra_defconfig                   |    5 +-
 arch/arm/mach-tegra/Kconfig                        |    7 +-
 arch/arm/mach-tegra/Makefile                       |    3 -
 arch/arm/mach-tegra/board-harmony-pcie.c           |   89 -
 arch/arm/mach-tegra/board.h                        |    8 -
 arch/arm/mach-tegra/iomap.h                        |    3 -
 arch/arm/mach-tegra/pcie.c                         |  886 ----------
 arch/arm/mach-tegra/pmc.c                          |   16 +
 arch/arm/mach-tegra/tegra.c                        |   24 -
 drivers/pci/host/Kconfig                           |    4 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-tegra.c                       | 1702 ++++++++++++++++++++
 include/linux/tegra-pmc.h                          |   23 +
 23 files changed, 2156 insertions(+), 1024 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
 delete mode 100644 arch/arm/mach-tegra/board-harmony-pcie.c
 delete mode 100644 arch/arm/mach-tegra/pcie.c
 create mode 100644 drivers/pci/host/pci-tegra.c
 create mode 100644 include/linux/tegra-pmc.h

-- 
1.8.1.5

