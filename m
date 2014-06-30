Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaF3Vrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:47:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51714 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaF3Vqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:46:30 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v3 0/5] Add Keystone PCIe controller driver
Date: Mon, 30 Jun 2014 17:45:15 -0400
Message-ID: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PCIe controller driver for Keystone SoCs. This
is based on v2 of the series posted to the mailing list.
Keystone PCI controller is based on version 3.65 of the DW
hardware. This driver re-uses some of the DW core driver
functions and required modification in some to support
the old DW h/w based Keystone driver.

Please review and let me know if you have any comments.

CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Mohit Kumar <mohit.kumar@st.com>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Pratyush Anand <pratyush.anand@st.com>
CC: Richard Zhu <r65037@freescale.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>
CC: Marek Vasut <marex@denx.de>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Randy Dunlap <rdunlap@infradead.org>
CC: Grant Likely <grant.likely@linaro.org> 

Changelog:

v3
 - DW application register handling code is now part of
   Keystone PCI driver. RFC had this code part of Keystone
   PCI driver, then V1 moved this to a separate file to
   re-use on other platforms that uses this version of the
   DW h/w. Then based on comments against v2, this is moved
   back to Keystone driver.
 - Keystone SerDes phy driver is removed from this series so that
   this can be merged independent of that patch
 - added msi_set_irq()/clear_irq() API's to support Keystone

V2
 - Split the designware pcie enhancement patch to multiple
   patches based on functionality added
 - Remove the quirk code and add a patch to fix mps/mrss
   tuning for ARM. Use kernel command line parameter
   pci=pcie_bus_perf to work with Keystone PCI Controller.
   Following patch addressed this.
     [PATCH v1] ARM: pci: add call to pcie_bus_configure_settings()
 - Add documentation for device tree bindings
 - Add separate interrupt controller nodes for MSI and Legacy
   IRQs and use irq map for legacy IRQ
 - Use compatibility to identify v3.65 version of the DW hardware
   and use it to customize the designware common code.
 - Use reg property for configuration space instead of range
 - Other minor updates based on code inspection. 

V1
 - Add an interrupt controller node for Legacy irq chip and use
   interrupt map/map-mask property to map legacy IRQs A/B/C/D
 - Add a Phy driver to replace the original serdes driver
 - Move common application register handling code to a separate
   file to allow re-use across other platforms that use older
   DW PCIe h/w
 - PCI quirk for maximum read request size. Check and override only
   if the maximum is higher than what controller can handle.
 - Converted to a module platform driver.

Murali Karicheri (5):
  PCI: designware: add rd[wr]_other_conf API
  PCI: designware: refactor MSI code to work with v3.65 dw hardware
  PCI: designware: refactor host init code to re-use on keystone PCI
  PCI: designware: enhance dw core driver to support Keystone PCI host
    controller
  PCI: add PCI controller for Keystone PCIe h/w

 .../devicetree/bindings/pci/designware-pcie.txt    |    2 +
 .../devicetree/bindings/pci/pci-keystone.txt       |   69 +++
 drivers/pci/host/Kconfig                           |    5 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-keystone-dw.c                 |  523 ++++++++++++++++++++
 drivers/pci/host/pci-keystone.c                    |  381 ++++++++++++++
 drivers/pci/host/pci-keystone.h                    |   56 +++
 drivers/pci/host/pcie-designware.c                 |  206 ++++++--
 drivers/pci/host/pcie-designware.h                 |   17 +-
 9 files changed, 1207 insertions(+), 53 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/pci-keystone.txt
 create mode 100644 drivers/pci/host/pci-keystone-dw.c
 create mode 100644 drivers/pci/host/pci-keystone.c
 create mode 100644 drivers/pci/host/pci-keystone.h

-- 
1.7.9.5

