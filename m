Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaGIMig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:38:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36364 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaGIMie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:38:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 00/10] OMAP: GPMC: NAND: Introduce GPMC APIs for OMAP NAND
Date: Wed, 9 Jul 2014 15:37:20 +0300
Message-ID: <1404909450-11970-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following hardware modules/registers are meant for NAND controller driver
usage:
- NAND I/O control (NAND address, data, command registers)
- Prefetch/Write-post engine
- ECC/BCH engine

However, these registers sit in the GPMC controller's register space and there
need to be some sane way to access them from the OMAP NAND controller driver.

Till now the GPMC driver was populating a data structure (struct gpmc_nand_regs)
with the register addresses and passing it to the OMAP NAND driver via platform
data. This mechanism cannot be used for true Device tree support as custom
platform data passing mechanism doesn't seem to work. Moreover, direct
access to these registers must be limited to the GPMC driver. This calls for
a few custom OMAP GPMC specific APIs that the OMAP NAND driver can use
to access these GPMC space registers.

This series attempts to add the following new APIs and gets rid of
'struct gpmc_nand_regs' and 'gpmc_update_nand_regs()'.

-For NAND I/O control registers
u32 omap_gpmc_read_reg(int cs, enum omap_gpmc_reg reg);
void omap_gpmc_write_reg(int cs, enum omap_gpmc_reg reg, u32 val);

-For Prefetch engine
int omap_gpmc_prefetch_start(int cs, int fifo_th, bool dma,
			     u32 count, int is_write);
int omap_gpmc_prefetch_stop(int cs);
u32 omap_gpmc_get_prefetch_count(void);
u32 omap_gpmc_get_prefetch_fifo_count(void);

-For ECC/BCH engine
void omap_gpmc_ecc_disable(void);
void omap_gpmc_ecc_configure_enable(int cs, bool ecc16, u8 ecc_size0,
				    u8 ecc_size1, bool use_bch,
				    enum omap_gpmc_bch_type bch_type,
				    u8 bch_sectors, u8 bch_wrap_mode);
void omap_gpmc_ecc_get_result(int length, u32 *result);
void omap_gpmc_ecc_get_bch_result(int length, u8 sector, u32 *result);

These APIs don't implement any logic to serialize access to the
NAND/Prefetch/ECC registers. It is upto the NAND controller driver
to ensure that. As these modules can only handle one NAND controller context
at a time, we set the nand_chip->hwcontrol to point to a single
controller instance even if there are multiple NAND chips on different
Chip select spaces. The NAND base driver then takes care of serializing
access to the NAND controller (and ECC) through nandchip->hwcontrol->lock.

NOTE: Patches are still untested and only meant for review.

cheers,
-roger
---
Roger Quadros (10):
  mtd: nand: omap: Use a single hardware controller instance
  mtd: nand: omap: Always use chip->ecc.steps for BCH sector count
  OMAP: GPMC: Introduce APIs to access NAND control registers
  mtd: nand: omap: Use GPMC APIs for NAND control
  OMAP: GPMC: Introduce APIs for accessing Prefetch/Write-post engine
  mtd: nand: omap: Use GPMC APIs for accessing Prefetch engine
  OMAP: GPMC: Introduce APIs for Configuring ECC Engine
  OMAP: GPMC: Introduce APIs to get ECC/BCH results
  mtd: nand: omap: Use GPMC APIs for accessing ECC/BCH engine
  OMAP: GPMC: NAND: Don't pass NAND/ECC/BCH register adresses to NAND
    driver

 arch/arm/mach-omap2/gpmc-nand.c              |   2 -
 arch/arm/mach-omap2/gpmc.c                   | 464 +++++++++++++++++++++++----
 arch/arm/mach-omap2/gpmc.h                   |   1 -
 drivers/mtd/nand/omap2.c                     | 397 +++++++++--------------
 include/linux/omap-gpmc-nand.h               | 106 ++++++
 include/linux/platform_data/mtd-nand-omap2.h |   5 +-
 6 files changed, 663 insertions(+), 312 deletions(-)
 create mode 100644 include/linux/omap-gpmc-nand.h

-- 
1.8.3.2

