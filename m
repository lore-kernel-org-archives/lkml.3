Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaEULVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:21:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36783 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaEULVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:21:48 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <pekon@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <robertcnelson@gmail.com>, <jg1.han@samsung.com>,
        <dwmw2@infradead.org>, <javier@dowhile0.org>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 00/16] OMAP: GPMC: Restructure OMAP GPMC driver (NAND)
Date: Wed, 21 May 2014 14:20:48 +0300
Message-ID: <1400671264-10702-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The existing OMAP GPMC driver has been suffering from ad-hoc architecture
with no clear separation between GPMC driver, Chip Select timing/settings and
Memory Device driver. The device tree implementation also reflects the same
issues.

The purpose of this series is to clean up the OMAP GPMC driver architecture,
provide a cleaner device tree implementation and finally move the gpmc driver
out of arch/arm/mach-omap2 so that it can be used by other non-OMAP
TI platforms.

This series tries to solve the problem as follows

For non-DT boot:
- Create a GPMC platform data structure that holds chip select
  information as well as child platform device
- Board files will build this structure using a helper function
  gpmc_generic_init()
- GPMC driver will configure the chip select region and create the
  platform device for each chip select region. Introduce gpmc_probe_legacy()
  for this purpose.

For DT boot:
- The GPMC controller node should have a chip select (CS) node for each used
  chip select. The CS node must have a child device node for each device
  attached to that chip select. Properties for that child are GPMC agnostic.

  i.e.
	gpmc {
		cs0 {
			nand0 {
			}
		};

		cs1 {
			nor0 {
			}
		}
		...
	};

- The meaning of ranges and how address mapping is done has changed.
  Ranges should now contain 2 ranges
  - GPMC I/O map. This map will be partitioned among the
    chip select (CS) nodes.
  - GPMC register map. This is common for all the CS nodes.
    
- Chip select (CS) number is no longer specified via reg property. Instead
  it is specified via the gpmc,cs property in the CS node.

For NAND:
- Move interrupt handling from GPMC driver to NAND driver. GPMC driver has nothing to do
  with interrupts.
- Expose GPMC register space to NAND driver. Both GPMC and NAND drivers share the same
  register space but don't use the same registers so it is safe. A clear partitioning couldn't
  be done since the GPMC config registers are interleaved with the NAND registers.
- Add compatible id. Move NAND DT parsing code from GPMC to NAND driver.

For now the series only addresses the OMAP NAND driver. I'm working at the moment
to fix other GPMC tied drivers as well (onenand, smc91x, smsc91xx, usb-tusb6010).

Tested on:
- omap3-beagle

NOTE: This series is only for review and most likely breaks everything apart from NAND on beagle board.
I hope to get review comments early so that I can avoid any major rework.

Thanks.

--
cheers,
-roger

Roger Quadros (16):
  ARM: OMAP2+: gpmc: Add platform data
  ARM: OMAP2+: gpmc: Add gpmc timings and settings to platform data
  ARM: OMAP2+: gmpc: add gpmc_generic_init()
  ARM: OMAP2+: gpmc: use platform data to configure CS space and
    poplulate device
  ARM: OMAP2+: gpmc: Use low level read/write for context save/restore
  ARM: OMAP2+: gpmc: add NAND specific setup
  ARM: OMAP2+: nand: Update gpmc_nand_init() to use generic_gpmc_init()
  mtd: nand: omap: Fix build warning
  mtd: nand: omap: Move IRQ handling from GPMC to NAND driver
  mtd: nand: omap: Move gpmc_update_nand_reg to nand driver
  mtd: nand: omap: Move NAND write protect code from GPMC to NAND driver
  mtd: nand: omap: Copy platform data parameters to omap_nand_info data
  mtd: nand: omap: True device tree support
  ARM: OMAP: gpmc: Update DT binding documentation
  mtd: nand: omap: Update DT binding documentation
  ARM: dts: omap3-beagle: Add NAND device

 Documentation/devicetree/bindings/bus/ti-gpmc.txt  | 109 ++-
 .../devicetree/bindings/mtd/gpmc-nand.txt          |  86 ++-
 arch/arm/boot/dts/omap3-beagle.dts                 |  66 ++
 arch/arm/mach-omap2/gpmc-nand.c                    |  85 +--
 arch/arm/mach-omap2/gpmc.c                         | 781 +++++++++++----------
 arch/arm/mach-omap2/gpmc.h                         | 151 +---
 arch/arm/mach-omap2/io.c                           |   2 +
 drivers/mtd/nand/omap2.c                           | 365 ++++++++--
 include/linux/platform_data/gpmc-omap.h            | 168 +++++
 include/linux/platform_data/mtd-nand-omap2.h       |  10 +-
 10 files changed, 1103 insertions(+), 720 deletions(-)
 create mode 100644 include/linux/platform_data/gpmc-omap.h

-- 
1.8.3.2

