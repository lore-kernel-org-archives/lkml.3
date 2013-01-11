Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3AKFoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 00:44:20 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:34465 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3AKFoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 00:44:18 -0500
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
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
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v4 00/14] DMA Engine support for AM33XX
Date: Fri, 11 Jan 2013 00:48:36 -0500
Message-Id: <1357883330-5364-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

The series applies on top of 3.8-rc3 and the following patches:

	- TPS65910 REGMAP_IRQ build fix:
	  https://patchwork.kernel.org/patch/1857701/
	- dmaengine DT support from Vinod's dmaengine_dt branch in
	  git://git.infradead.org/users/vkoul/slave-dma.git since
	  027478851791df751176398be02a3b1c5f6aa824
	- edma dmaengine driver fix:
	  https://patchwork.kernel.org/patch/1961521/
	- dmaengine dma_get_channel_caps v2:
	  https://patchwork.kernel.org/patch/1961601/
	- dmaengine edma driver channel caps support v2:
	  https://patchwork.kernel.org/patch/1961591/

The approach taken is similar to how OMAP DMA is being converted to
DMA Engine support. With the functional EDMA private API already
existing in mach-davinci/dma.c, we first move that to an ARM common
area so it can be shared. Adding DT and runtime PM support to the
private EDMA API implementation allows it to run on AM33xx. AM33xx
*only* boots using DT so we leverage Jon's generic DT DMA helpers to
register EDMA DMAC with the of_dma framework and then add support
for calling the dma_request_slave_channel() API to both the mmc
and spi drivers.

With this series both BeagleBone and the AM335x EVM have working
MMC and SPI support.

This is tested on BeagleBone with a SPI framebuffer driver and MMC
rootfs. A trivial gpio DMA event misc driver was used to test the
crossbar DMA event support. It is also tested on the AM335x EVM
with the onboard SPI flash and MMC rootfs. The branch at
https://github.com/ohporter/linux/tree/edma-dmaengine-am33xx-v4
has the complete series, dependencies, and some test
drivers/defconfigs.

Regression testing was done on AM180x-EVM (which also makes use
of the EDMA dmaengine driver and the EDMA private API) using SD,
SPI flash, and the onboard audio supported by the ASoC Davinci
driver. Regression testing was also done on a BeagleBoard xM
booting from the legacy board file using MMC rootfs.

Matt Porter (14):
  ARM: davinci: move private EDMA API to arm/common
  ARM: edma: remove unused transfer controller handlers
  ARM: edma: add AM33XX support to the private EDMA API
  dmaengine: edma: enable build for AM33XX
  dmaengine: edma: Add TI EDMA device tree binding
  ARM: dts: add AM33XX EDMA support
  dmaengine: add dma_request_slave_channel_compat()
  mmc: omap_hsmmc: convert to dma_request_slave_channel_compat()
  mmc: omap_hsmmc: set max_segs based on dma engine limitations
  mmc: omap_hsmmc: add generic DMA request support to the DT binding
  ARM: dts: add AM33XX MMC support
  spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
  spi: omap2-mcspi: add generic DMA request support to the DT binding
  ARM: dts: add AM33XX SPI DMA support

 Documentation/devicetree/bindings/dma/ti-edma.txt  |   51 +
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   25 +-
 Documentation/devicetree/bindings/spi/omap-spi.txt |   28 +-
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/am335x-bone.dts                  |    7 +
 arch/arm/boot/dts/am335x-evm.dts                   |    7 +
 arch/arm/boot/dts/am335x-evmsk.dts                 |    7 +
 arch/arm/boot/dts/am33xx.dtsi                      |   58 +
 arch/arm/common/Kconfig                            |    3 +
 arch/arm/common/Makefile                           |    1 +
 arch/arm/common/edma.c                             | 1847 ++++++++++++++++++++
 arch/arm/mach-davinci/Makefile                     |    2 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c        |    2 +-
 arch/arm/mach-davinci/davinci.h                    |    2 +-
 arch/arm/mach-davinci/devices-tnetv107x.c          |    2 +-
 arch/arm/mach-davinci/devices.c                    |    7 +-
 arch/arm/mach-davinci/dm355.c                      |    2 +-
 arch/arm/mach-davinci/dm365.c                      |    2 +-
 arch/arm/mach-davinci/dm644x.c                     |    2 +-
 arch/arm/mach-davinci/dm646x.c                     |    2 +-
 arch/arm/mach-davinci/dma.c                        | 1588 -----------------
 arch/arm/mach-davinci/include/mach/da8xx.h         |    2 +-
 arch/arm/mach-davinci/include/mach/edma.h          |  267 ---
 arch/arm/plat-omap/Kconfig                         |    1 +
 drivers/dma/Kconfig                                |    2 +-
 drivers/dma/edma.c                                 |    2 +-
 drivers/mmc/host/davinci_mmc.c                     |    1 +
 drivers/mmc/host/omap_hsmmc.c                      |   16 +-
 drivers/spi/spi-omap2-mcspi.c                      |   65 +-
 include/linux/dmaengine.h                          |   10 +
 include/linux/mfd/davinci_voicecodec.h             |    3 +-
 include/linux/platform_data/edma.h                 |  183 ++
 include/linux/platform_data/spi-davinci.h          |    2 +-
 sound/soc/davinci/davinci-evm.c                    |    1 +
 sound/soc/davinci/davinci-pcm.c                    |    1 +
 sound/soc/davinci/davinci-pcm.h                    |    2 +-
 sound/soc/davinci/davinci-sffsdr.c                 |    6 +-
 37 files changed, 2310 insertions(+), 1900 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt
 create mode 100644 arch/arm/common/edma.c
 delete mode 100644 arch/arm/mach-davinci/dma.c
 delete mode 100644 arch/arm/mach-davinci/include/mach/edma.h
 create mode 100644 include/linux/platform_data/edma.h

-- 
1.7.9.5

