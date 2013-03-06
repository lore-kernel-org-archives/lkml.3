Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3CFQPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:15:19 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:46345 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3CFQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:15:14 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 0/9] DMA Engine support for AM33XX
Date: Wed,  6 Mar 2013 11:15:30 -0500
Message-Id: <1362586540-10393-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v8:
	- Removed edma node interrupt-parent property, it is inherited

Changes since v7:
	- Dropped dmaengine compat() patch. It is upstream.
	- Submitted edma_alloc_slot() error checking bug fix separately,
	  now a dependency
	- Fixed bisect issues due to 3/10 hunks that went into 1/10
	- Fixed incorrect IS_ERRVALUE() use in 3/10

Changes since v6:
	- Converted edma_of_read_*() to wrappers around of_property_read_*()
	- Fixed wording on the omap-spi generic DMA properties
	- Added comment/check to clarify that the driver only supports
	  a single EDMA instance when booting from DT

Changes since v5:
	- Dropped mmc portion and moved it to a separate series
	- Incorporate corrected version of dma_request_slave_channel_compat()
	- Fix #defines and enablement of TI_PRIV_EDMA option

Changes since v4:
	- Fixed debug section mismatch in private edma api [01/14]
	- Respun format-patch to catch the platform_data/edma.h rename [01/14]
	- Removed address/size-cells from the EDMA binding [05/14]

Changes since v3:
	- Rebased on 3.8-rc3
	- No longer an RFC
	- Fixed bugs in DT/pdata parsing reported by Vaibhav Bedia
	- Restored all the Davinci pdata to const
	- Removed max_segs hack in favor of using dma_get_channel_caps()
	- Fixed extra parens, __raw_* accessors and, ioremap error checks
	  in xbar handling
	- Removed excess license info in platform_data/edma.h
	- Removed unneeded reserved channels data for AM33xx
	- Removed test-specific pinmuxing from dts files
	- Adjusted mmc1 node to be disabled by default in the dtsi

Changes since v2:
	- Rebased on 3.7-rc1
	- Fixed bug in DT/pdata parsing first found by Gururaja
	  that turned out to be masked by some toolchains
	- Dropped unused mach-omap2/devices.c hsmmc patch
	- Added AM33XX crossbar DMA event mux support
	- Added am335x-evm support

Changes since v1:
	- Rebased on top of mainline from 12250d8
	- Dropped the feature removal schedule patch
	- Implemented dma_request_slave_channel_compat() and
	  converted the mmc and spi drivers to use it
	- Dropped unneeded #address-cells and #size-cells from
	  EDMA DT support
	- Moved private EDMA header to linux/platform_data/ and
	  removed some unneeded definitions
	- Fixed parsing of optional properties

This series adds DMA Engine support for AM33xx, which uses
an EDMA DMAC. The EDMA DMAC has been previously supported by only
a private API implementation (much like the situation with OMAP
DMA) found on the DaVinci family of SoCs.

The series applies on top of 3.9-rc1 and the following patches:

	- edma private api error check fix from 
	  http://www.spinics.net/lists/arm-kernel/msg227886.html

The approach taken is similar to how OMAP DMA is being converted to
DMA Engine support. With the functional EDMA private API already
existing in mach-davinci/dma.c, we first move that to an ARM common
area so it can be shared. Adding DT and runtime PM support to the
private EDMA API implementation allows it to run on AM33xx. AM33xx
*only* boots using DT so the upstream generic DT DMA helpers are
leveraged to register EDMA DMAC with the of_dma framework. SPI (and
MMC in a separate series) are supported using the upstream
dma_request_slave_channel_compat() dmaengine call that allows
compatibility with !DT platforms.

With this series both BeagleBone and the AM335x EVM have working
SPI DMA support (and MMC support with the separate MMC series).

This is tested on BeagleBone with a SPI framebuffer driver and MMC
rootfs. A trivial gpio DMA event misc driver was used to test the
crossbar DMA event support. It is also tested on the AM335x EVM
with the onboard SPI flash and MMC rootfs. Note that MMC can only
be tested with a separate MMC dmaengine/DT series applied.

Regression testing was done on AM180x-EVM (which also makes use
of the EDMA dmaengine driver and the EDMA private API) using SD,
SPI flash, and the onboard audio supported by the ASoC Davinci
driver. Regression testing was also done on a BeagleBoard xM
booting from the legacy board file using MMC rootfs.

Matt Porter (9):
  ARM: davinci: move private EDMA API to arm/common
  ARM: edma: remove unused transfer controller handlers
  ARM: edma: add AM33XX support to the private EDMA API
  dmaengine: edma: enable build for AM33XX
  dmaengine: edma: Add TI EDMA device tree binding
  ARM: dts: add AM33XX EDMA support
  spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
  spi: omap2-mcspi: add generic DMA request support to the DT binding
  ARM: dts: add AM33XX SPI DMA support

 Documentation/devicetree/bindings/dma/ti-edma.txt  |   49 +++
 Documentation/devicetree/bindings/spi/omap-spi.txt |   27 +-
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/am33xx.dtsi                      |   29 ++
 arch/arm/common/Kconfig                            |    3 +
 arch/arm/common/Makefile                           |    1 +
 arch/arm/{mach-davinci/dma.c => common/edma.c}     |  339 +++++++++++++++++---
 arch/arm/mach-davinci/Makefile                     |    2 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c        |    2 +-
 arch/arm/mach-davinci/davinci.h                    |    2 +-
 arch/arm/mach-davinci/devices-tnetv107x.c          |    2 +-
 arch/arm/mach-davinci/devices.c                    |    6 +-
 arch/arm/mach-davinci/dm355.c                      |    2 +-
 arch/arm/mach-davinci/dm365.c                      |    2 +-
 arch/arm/mach-davinci/dm644x.c                     |    2 +-
 arch/arm/mach-davinci/dm646x.c                     |    2 +-
 arch/arm/mach-davinci/include/mach/da8xx.h         |    2 +-
 arch/arm/mach-omap2/Kconfig                        |    1 +
 drivers/dma/Kconfig                                |    2 +-
 drivers/dma/edma.c                                 |    2 +-
 drivers/mmc/host/davinci_mmc.c                     |    1 +
 drivers/spi/spi-omap2-mcspi.c                      |   27 +-
 include/linux/mfd/davinci_voicecodec.h             |    3 +-
 .../mach => include/linux/platform_data}/edma.h    |   90 +-----
 include/linux/platform_data/spi-davinci.h          |    2 +-
 sound/soc/davinci/davinci-evm.c                    |    1 +
 sound/soc/davinci/davinci-pcm.c                    |    1 +
 sound/soc/davinci/davinci-pcm.h                    |    2 +-
 sound/soc/davinci/davinci-sffsdr.c                 |    5 +-
 29 files changed, 450 insertions(+), 160 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt
 rename arch/arm/{mach-davinci/dma.c => common/edma.c} (86%)
 rename {arch/arm/mach-davinci/include/mach => include/linux/platform_data}/edma.h (59%)

-- 
1.7.9.5

