Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422879Ab3FTVIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:08:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37431 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422860Ab3FTVID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:08:03 -0400
From: Joel A Fernandes <joelagnel@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
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
Subject: [PATCH v12 00/11] DMA Engine support for AM33XX
Date: Thu, 20 Jun 2013 16:06:36 -0500
Message-ID: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel A Fernandes <agnel.joel@gmail.com>

This series is remaining of Matt Porter's EDMA patches for AM33XX EDMA support
with changes for few pending review comments on v11 series.

Also included are EDMA config and build options for OMAP2PLUS and Davinci by
selecting DMADEVICES, and options to enable MMCSD on Davinci (da8xx_omapl).

Currently this is required for AM33XX (Beaglebone or EVM) to access MMC
and be able mount to rootfs and boot till command prompt over MMC.
Unless there are other pending review comments, I hope this series can
make it into 3.11 merge window, the dependent series has been posted at [1]
and completed review.

Tested EDMA on AM1808 EVM and AM33XX Beaglebone with MMC.

Sekhar Nori has posted a GIT PULL [1] which has 2 patches this series depends on:
[1] http://www.spinics.net/lists/arm-kernel/msg251503.html

Changes since v11:
	- Fixed several style issues and warnings
	- Broke up the build option patch into smaller ones
	- Various miscellaneous fixups addressed from v10 feedback

Changes since v10:
	- Reworked documentation based on Arnd's feedback
	- Moved EDMA bindings documentation earlier in series
	- Dropped mention on am33xx on 2/8 and 3/8 in the series

Changes since v9:
    - Droped reserved and queue DT entries from Documentation
    for now from the original patch series.
    - Drop DT entries that are non-hardware-description
    - Split EDMA xbar support out of original EDMA DT parsing patch
    to keep it easier for review.
    - Rewrite shift and offset calculation xbar event mapping.
    - Setup default one-to-one mapping for queue_priority and queue_tc
    mapping as discussed in.
    - Split out xbar stuff to separate patch.

	Reference discussion:
   https://patchwork.kernel.org/patch/2226761/

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

The series applies on top of 3.10-rc4.

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


Joel A Fernandes (3):
  edma: config: Enable config options for EDMA
  da8xx: config: Enable MMC and FS options
  ARM: davinci: Fix compiler warnings in devices-da8xx

Matt Porter (8):
  dmaengine: edma: Add TI EDMA device tree binding
  ARM: edma: Add DT and runtime PM support to the private EDMA API
  ARM: edma: Add EDMA crossbar event mux support
  dmaengine: edma: enable build for AM33XX
  spi: omap2-mcspi: add generic DMA request support to the DT binding
  spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
  ARM: dts: add AM33XX EDMA support
  ARM: dts: add AM33XX SPI DMA support

 Documentation/devicetree/bindings/dma/ti-edma.txt  |   34 +++
 Documentation/devicetree/bindings/spi/omap-spi.txt |   27 ++-
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/am33xx.dtsi                      |   22 ++
 arch/arm/common/edma.c                             |  242 ++++++++++++++++++--
 arch/arm/configs/da8xx_omapl_defconfig             |    3 +
 arch/arm/mach-davinci/devices-da8xx.c              |    8 +-
 arch/arm/mach-omap2/Kconfig                        |    2 +
 drivers/dma/Kconfig                                |    4 +-
 drivers/spi/spi-omap2-mcspi.c                      |   64 ++++--
 include/linux/platform_data/edma.h                 |    5 +-
 11 files changed, 369 insertions(+), 43 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt

-- 
1.7.9.5

