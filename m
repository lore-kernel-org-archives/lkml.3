Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3ISNGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:06:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36967 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab3ISNGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:06:15 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balajitk@ti.com>, <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 00/15] Add SATA support for TI OMAP5 and DRA7 SoCs
Date: Thu, 19 Sep 2013 16:05:28 +0300
Message-ID: <1379595943-14622-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds SATA controller support for the Texas Instruments
OMAP5 and DRA7 platforms.

As the SATA controller is compatible with AHCI, we use the ahci_platform
driver and just provide the glue logic.

The AHCI controller is enclosed within a TI specific Wrapper that controls
the controller power mode. Patch 9 adds a driver for this wrapper.

The controller is linked to a SATA (PIPE3) PHY, which needs to be clocked
and powered up before it can be used. We do that with the help of the
generic PHY framework [2] in Patch 8.

Patches 1 to 7 adapt the the PHY driver to the Generic PHY framework.

Patches 9 to 15 provide platform adaptation code for OMAP5 and DRA7.

Patches are based on v3.12-rc1 with the following patches on top
[1] - omap control usb multiple instance support
      http://article.gmane.org/gmane.linux.ports.arm.kernel/267587
      git://github.com/rogerq/linux.git usb-control-module

[2] - Generic PHY framework
      git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git testing

[3] - Clock DT support
      git://gitorious.org/~kristo/omap-pm/omap-pm-work.git mainline-3.11-rc3-omap-dt-clks-v5

[4] - PHY framework mis cleanup
      https://lkml.org/lkml/2013/9/2/313

NOTE: [2], [3] and [4] will cause merge conflicts and need to be resolved manually.
A merged tree is available for reference/testing at

git://github.com/rogerq/linux.git ti-3.12-sata

Tested on omap5-uevm and dra7-evm with Gen2 SATA hard drive.

Known issues:
- Gen3 SATA SSD does not work due to some issue with PHY speed negotiation.

cheers,
-roger

---
Balaji T K (3):
  ata: ahci_platform: Manage SATA PHY
  arm: dts: omap5: add sata node
  arm: dts: dra7: add sata node

Benoit Cousson (1):
  arm: omap5: hwmod: add missing ocp2scp hwmod data

Keshava Munegowda (1):
  ARM: omap5: hwmod: Add ocp2scp3 and sata hwmods

Kishon Vijay Abraham I (2):
  phy: rename struct omap_control_usb to struct omap_control_phy
  phy: omap-pipe3: use generic clock names

Nikhil Devshatwar (1):
  ARM: DRA7: hwmod: Add ocp2scp3 and sata hwmods

Roger Quadros (7):
  phy: omap-control: Update DT binding information
  ARM: dts: omap5: Add clocks to usb3_phy node
  phy: omap-pipe3: Add SATA DPLL support
  phy: omap-pipe3: update compatibility string and DT binding
  ARM: dts: omap5: Update usb3phy node
  ata: ti_sata: Add Texas Instruments SATA Wrapper driver
  ARM: dts: omap5: add ocp2scp1 address resource

 .../devicetree/bindings/ata/ahci-platform.txt      |    2 +-
 Documentation/devicetree/bindings/ata/ti-sata.txt  |   31 ++
 Documentation/devicetree/bindings/phy/omap-phy.txt |   26 ++-
 Documentation/devicetree/bindings/usb/omap-usb.txt |   23 --
 arch/arm/boot/dts/dra7.dtsi                        |   49 ++++
 arch/arm/boot/dts/omap5.dtsi                       |   56 ++++-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         |  117 ++++++++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |   40 +++-
 drivers/ata/Kconfig                                |    8 +
 drivers/ata/Makefile                               |    1 +
 drivers/ata/ahci.h                                 |    2 +
 drivers/ata/ahci_platform.c                        |   31 ++-
 drivers/ata/sata_ti.c                              |  160 +++++++++++
 drivers/phy/Kconfig                                |   14 +-
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-omap-control.c                     |  300 ++++++++++++++++++++
 drivers/phy/phy-omap-pipe3.c                       |  157 ++++++-----
 drivers/phy/phy-omap-usb2.c                        |    9 +-
 drivers/usb/musb/omap2430.c                        |    2 +-
 drivers/usb/phy/Kconfig                            |   10 -
 drivers/usb/phy/Makefile                           |    1 -
 drivers/usb/phy/phy-omap-control.c                 |  300 --------------------
 include/linux/phy/omap_control_phy.h               |   83 ++++++
 include/linux/phy/omap_pipe3.h                     |    6 +
 include/linux/usb/omap_control_usb.h               |   83 ------
 25 files changed, 1013 insertions(+), 499 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/ti-sata.txt
 create mode 100644 drivers/ata/sata_ti.c
 create mode 100644 drivers/phy/phy-omap-control.c
 delete mode 100644 drivers/usb/phy/phy-omap-control.c
 create mode 100644 include/linux/phy/omap_control_phy.h
 delete mode 100644 include/linux/usb/omap_control_usb.h

-- 
1.7.4.1

