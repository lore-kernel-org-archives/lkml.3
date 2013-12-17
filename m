Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3LQTms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:42:48 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:45820 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3LQTmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:42:43 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v7 0/9] USB Device Controller support for BCM281xx
Date: Tue, 17 Dec 2013 14:42:27 -0500
Message-Id: <1387309356-17195-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v6:
	- Drop dependency on the Exynos generic phy conversion series
	- Bring back original patch that converts s3c-hsotg to use the
	  generic phy layer with a fall back to the old usb style phy
	  support.

Changes since v5:
	- tweak s3c-hsotg Kconfig help message to be more generic

Changes since v4:
	- phy_set/get_bus_width now use an int for bus_width

Changes since v3:
	- Rebased on 3.13-rc3
	- Move struct phy bus_width attribute back into struct phy_attrs
	- Fix build issue on !GENERIC_PHY
	- Update dwc2 binding to reflect optional phy properties
	- Rename bcm-kona-phy.txt binding to bcm-phy.txt
	- Reorder bcm kona phy includes and use bitops
	- phy-names changed to "usb2-phy" to match updated s3c-hsotg
	  generic phy-ification series

Changes since v2:
	- Rebased on 3.13-rc1
	- Fix braces in phy_get_bus_width()/phy_set_bus_width()
	- Drop generic phy conversion to use the same support from
	  the Exynos generic phy conversion series
	- Modify dts support to match the "device" phy name required
	  in the v3 Exynos generic phy conversion
	- Add s3c-hsotg phy_init/phy_exit support
	- Fix typo on reg property in kona phy binding
	- Replace phy driver reg struct with offset defines
	- Move phy soft reset to phy driver init
	- Fix dts node names to match ePAPR conventions

Changes since v1:
	- Convert USB phy driver to generic phy subsystem
	- Add phy bus width apis
	- Drop dwc2 phy bus width DT property in favor of querying the
	  phy provider for bus width
	- Add generic phy/clock properties to dwc2 DT binding
	- Add generic phy subsystem support to s3c-hsotg with the
	  existing usb phy and pdata phy methods as a fallback
	- Split bindings out to separate patches to match the latest
	  DT binding review guidelines

This series adds USB Device Controller support for the Broadcom
BCM281xx family of parts. BCM281xx contains a DWC2 OTG block and
s3c-hsotg is used to support UDC operation.

Part 1 adds phy bus width support to the generic phy subsystem

Parts 2-6 allows s3c-hsotg to build on non-Samsung platforms, supports
the dwc2 binding, adds generic phy layer support, and supports fetching
phy bus width using the generic phy layer.

Parts 7-8 add a generic phy binding and driver for the BCM Kona USB PHY.

Part 9 adds the DT nodes to enable UDC support on both BCM281xx boards
in the kernel.

This series depends on:
	- "Update Kona drivers to use clocks" v4 series
	  https://lkml.org/lkml/2013/12/5/508
	  (relevant portion now queued for 3.14)


Matt Porter (9):
  phy: add phy_get_bus_width()/phy_set_bus_width() calls
  staging: dwc2: update DT binding to add generic clock/phy properties
  usb: gadget: s3c-hsotg: enable build for other platforms
  usb: gadget: s3c-hsotg: add snps,dwc2 compatible string
  usb: gadget: s3c-hsotg: enable generic phy support
  usb: gadget: s3c-hsotg: get phy bus width from phy subsystem
  phy: add Broadcom Kona USB2 PHY DT binding
  phy: add Broadcom Kona USB2 PHY driver
  ARM: dts: add usb udc support to bcm281xx

 Documentation/devicetree/bindings/phy/bcm-phy.txt  |  15 ++
 Documentation/devicetree/bindings/staging/dwc2.txt |  12 ++
 arch/arm/boot/dts/bcm11351-brt.dts                 |   6 +
 arch/arm/boot/dts/bcm11351.dtsi                    |  18 +++
 arch/arm/boot/dts/bcm28155-ap.dts                  |   8 ++
 drivers/phy/Kconfig                                |   6 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-bcm-kona-usb2.c                    | 158 +++++++++++++++++++++
 drivers/usb/gadget/Kconfig                         |   7 +-
 drivers/usb/gadget/s3c-hsotg.c                     |  72 +++++++---
 drivers/usb/gadget/s3c-hsotg.h                     |   1 +
 include/linux/phy/phy.h                            |  28 ++++
 12 files changed, 309 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/bcm-phy.txt
 create mode 100644 drivers/phy/phy-bcm-kona-usb2.c

-- 
1.8.4

