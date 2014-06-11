Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaFKJR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:17:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59744 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbaFKI5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:57:24 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 00/36] OMAP: GPMC: Restructure and move OMAP GPMC driver out of mach-omap2
Date: Wed, 11 Jun 2014 11:56:05 +0300
Message-ID: <1402477001-31132-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a complete functional set to get the gpmc driver out of mach-omap2
and into drivers/memory. The DT binding remains the same except for the
following minor changes
- compatible property is required for NAND & OneNAND nodes
- Second register space and interrupts properties are required for
  NAND controller node
- ti,onenand-sync-rw property added for OneNAND node.

The series does the following changes
- Move GPMC IRQ and NAND register handling to NAND driver.
  The entire GPMC register space is made available to the NAND driver.
- Clean up NAND device tree handling. Don't rely on legacy platform device
  i.e. don't call gpmc_nand_init()
- Add 2 public APIs omap_gpmc_retime() and omap_gpmc_get_clk_period()
  omap_gpmc_retime() allows to reconfigure the GPMC settings and timings
  for the specified Chip select region.
  omap_gpmc_get_clk_period() allows to query the GPMC_CLK (external clock)
  period, to perform timing calculations.
  Both functions will be needed by the OneNAND driver since it calculates
  device timings on the fly and needs to change from Asynchronous mode
  to Synchronous mode.
- Setup OneNAND in Asynchronous mode by default and move Synchronous
  setting code into OneNAND driver.
- Clean up OneNAND device tree handling. Don't rely on legacy platform device
  i.e. don't call gpmc_onenand_init()
- Introduce gpmc_generic_init() that should be used by board files to specify
  GPMC chip select setting/timing and platform device within that Chip Select.
- Stop using all gpmc*() that are meant to be private to GPMC driver.
- Move GPMC driver into drivers/memory

Tested on:

- beagleboard C4: NAND
- Nokia N900: OneNAND

Changelog:

[1] RFC patch - https://lkml.org/lkml/2014/5/21/218

cheers,
-roger

---
Roger Quadros (36):
  ARM: OMAP3: hwmod: Fix gpmc memory resource space
  ARM: dts: OMAP2+: Fix GPMC register space size
  ARM: OMAP2+: gpmc: Add platform data
  ARM: OMAP2+: gpmc: Add gpmc timings and settings to platform data
  mtd: nand: omap: Move IRQ handling from GPMC to NAND driver
  mtd: nand: omap: Move gpmc_update_nand_reg to nand driver
  mtd: nand: omap: Move NAND write protect code from GPMC to NAND driver
  mtd: nand: omap: Copy platform data parameters to omap_nand_info data
  mtd: nand: omap: Clean up device tree support
  ARM: dts: OMAP2+: Fix NAND device nodes
  mtd: nand: omap: Update DT binding documentation
  ARM: dts: omap3-beagle: Add NAND device
  ARM: OMAP2+: gpmc.c: sanity check bank-width DT property
  ARM: OMAP2+: gpmc: Allow drivers to reconfigure GPMC settings &
    timings
  ARM: OMAP2+: gpmc: Allow drivers to query GPMC_CLK period
  mtd: onenand: omap: Remove regulator management code
  ARM: OMAP2+: gpmc-onenand: Use Async settings/timings by default
  ARM: OMAP2+: gpmc-onenand: Move Synchronous setting code to drivers/
  mtd: onenand: omap: Use devres managed resources
  mtd: onenand: omap: Clean up device tree support
  ARM: dts: OMAP2+: Fix OneNAND device nodes
  ARM: OMAP2+: gmpc: add gpmc_generic_init()
  ARM: OMAP2+: gpmc: use platform data to configure CS space and
    poplulate device
  ARM: OMAP2+: gpmc: add NAND specific setup
  ARM: OMAP2+: gpmc: Support multiple Chip Selects per device
  ARM: OMAP2+: gpmc-smc91x: Get rid of retime() from
    omap_smc91x_platform_data
  ARM: OMAP2+: usb-tusb6010: Use omap_gpmc_retime()
  ARM: OMAP2+: nand: Update gpmc_nand_init() to use generic_gpmc_init()
  ARM: OMAP2+: gpmc-smc91x: Use gpmc_generic_init()
  ARM: OMAP2+: gpmc-smsc911x: Use gpmc_generic_init()
  ARM: OMAP2: usb-tusb6010: Use gpmc_generic_init()
  ARM: OMAP2+: onenand: Use gpmc_generic_init()
  ARM: OMAP2+: board-flash: Use gpmc_generic_init() for NOR
  ARM: OMAP2+: gpmc: Make externally unused functions/defines private
  ARM: OMAP2+: gpmc: move GPMC driver into drivers/memory
  ARM: OMAP2+: defconfig: Enable TI GPMC driver

 .../devicetree/bindings/mtd/gpmc-nand.txt          |   16 +-
 .../devicetree/bindings/mtd/gpmc-onenand.txt       |    4 +
 arch/arm/boot/dts/am335x-evm.dts                   |    8 +-
 arch/arm/boot/dts/am335x-igep0033.dtsi             |    8 +-
 arch/arm/boot/dts/am33xx.dtsi                      |    2 +-
 arch/arm/boot/dts/am4372.dtsi                      |    2 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |    8 +-
 arch/arm/boot/dts/omap2420-n8x0-common.dtsi        |    5 +-
 arch/arm/boot/dts/omap2420.dtsi                    |    2 +-
 arch/arm/boot/dts/omap2430.dtsi                    |    2 +-
 arch/arm/boot/dts/omap3-beagle.dts                 |   53 +
 arch/arm/boot/dts/omap3-devkit8000.dts             |    9 +-
 arch/arm/boot/dts/omap3-evm-37xx.dts               |   10 +-
 arch/arm/boot/dts/omap3-igep0020.dts               |   10 +-
 arch/arm/boot/dts/omap3-igep0030.dts               |    8 +-
 arch/arm/boot/dts/omap3-ldp.dts                    |   10 +-
 arch/arm/boot/dts/omap3-lilly-a83x.dtsi            |   10 +-
 arch/arm/boot/dts/omap3-lilly-dbb056.dts           |    7 +-
 arch/arm/boot/dts/omap3-n900.dts                   |    6 +-
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |    6 +-
 arch/arm/boot/dts/omap3.dtsi                       |    2 +-
 arch/arm/boot/dts/omap3430-sdp.dts                 |   14 +-
 arch/arm/boot/dts/omap4.dtsi                       |    2 +-
 arch/arm/boot/dts/omap5.dtsi                       |    2 +-
 arch/arm/configs/omap2plus_defconfig               |    2 +
 arch/arm/mach-omap2/Makefile                       |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    8 +-
 arch/arm/mach-omap2/board-flash.c                  |   28 +-
 arch/arm/mach-omap2/gpmc-nand.c                    |   66 +-
 arch/arm/mach-omap2/gpmc-onenand.c                 |  351 +---
 arch/arm/mach-omap2/gpmc-smc91x.c                  |   91 +-
 arch/arm/mach-omap2/gpmc-smc91x.h                  |    1 -
 arch/arm/mach-omap2/gpmc-smsc911x.c                |   76 +-
 arch/arm/mach-omap2/gpmc.c                         | 1872 --------------------
 arch/arm/mach-omap2/gpmc.h                         |  221 +--
 arch/arm/mach-omap2/gpmc_legacy.c                  |  296 ++++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |    2 +-
 arch/arm/mach-omap2/usb-tusb6010.c                 |  172 +-
 drivers/memory/Kconfig                             |   10 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/ti-gpmc.c                           | 1829 +++++++++++++++++++
 drivers/mtd/nand/Kconfig                           |    2 +-
 drivers/mtd/nand/omap2.c                           |  364 +++-
 drivers/mtd/onenand/Kconfig                        |    6 +-
 drivers/mtd/onenand/omap2.c                        |  456 +++--
 include/linux/platform_data/gpmc-omap.h            |  189 ++
 include/linux/platform_data/mtd-nand-omap2.h       |   10 +-
 include/linux/platform_data/mtd-onenand-omap2.h    |    7 +-
 48 files changed, 3361 insertions(+), 2907 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/gpmc.c
 create mode 100644 arch/arm/mach-omap2/gpmc_legacy.c
 create mode 100644 drivers/memory/ti-gpmc.c
 create mode 100644 include/linux/platform_data/gpmc-omap.h

-- 
1.8.3.2

