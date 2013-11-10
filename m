Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab3KJTYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 14:24:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42592 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3KJTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 14:24:06 -0500
Date: Sun, 10 Nov 2013 19:23:47 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>, ARM SoC <arm@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] DMA mask updates
Message-ID: <20131110192347.GA16101@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Andrew,

Please incorporate the DMA mask changes, which can be found at:

	git://git.linaro.org/people/rmk/linux-arm.git for-linus-dma-masks

with SHA1 26ba47b18318abe7dadbe9294a611c0e932651d8.

This series cleans up the handling of DMA masks in a lot of drivers,
fixing some bugs as we go.  

Some of the more serious errors include:
- drivers which only set their coherent DMA mask if the attempt to set
  the streaming mask fails.
- drivers which test for a NULL dma mask pointer, and then set the dma
  mask pointer to a location in their module .data section - which will
  cause problems if the module is reloaded.

To counter these, I have introduced two helper functions:
- dma_set_mask_and_coherent() takes care of setting both the streaming
  and coherent masks at the same time, with the correct error handling
  as specified by the API.
- dma_coerce_mask_and_coherent() which resolves the problem of drivers
  forcefully setting DMA masks.  This is more a marker for future work
  to further clean these locations up - the code which creates the
  devices really should be initialising these, but to fix that in one
  go along with this change could potentially be very disruptive.

The last thing this series does is prise away some of Linux's addition
to "DMA addresses are physical addresses and RAM always starts at zero".
We have ARM LPAE systems where all system memory is above 4GB physical,
hence having DMA masks interpreted by (eg) the block layers as describing
physical addresses in the range 0..DMAMASK fails on these platforms.
Santosh Shilimkar addresses this in this series; the patches were copied
to the appropriate people multiple times but were ignored.

Fixing this also gets rid of some ARM weirdness in the setup of the
max*pfn variables, and brings ARM into line with every other Linux
architecture as far as those go.

Two conflicts are expected - one in drivers/usb/musb/davinci.c which
is a trivial case of adding the musb_resources[2], and the other in
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c.  This one should
look something like this - this resolution has been in linux-next:

diff --cc drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index e6c3e663f6c0,b42f89ce02ef..000000000000
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@@ -12072,9 -12117,12 +12117,8 @@@ static int bnx2x_set_coherency_mask(str
  {
        struct device *dev = &bp->pdev->dev;
  
-       if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) == 0) {
-               bp->flags |= USING_DAC_FLAG;
-       } else if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32)) != 0) {
 -      if (dma_set_mask(dev, DMA_BIT_MASK(64)) == 0) {
 -              if (dma_set_coherent_mask(dev, DMA_BIT_MASK(64)) != 0) {
 -                      dev_err(dev, "dma_set_coherent_mask failed, aborting\n")
;
 -                      return -EIO;
 -              }
 -      } else if (dma_set_mask(dev, DMA_BIT_MASK(32)) != 0) {
++      if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) != 0 &&
++          dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32)) != 0) {
                dev_err(dev, "System does not support DMA, aborting\n");
                return -EIO;
        }


This will update the following files:

 Documentation/DMA-API-HOWTO.txt                   |   37 +++++++++------
 Documentation/DMA-API.txt                         |    8 +++
 arch/arm/include/asm/dma-mapping.h                |    8 +++
 arch/arm/mm/dma-mapping.c                         |   51 ++++++++++++++++++---
 arch/arm/mm/init.c                                |   12 +++---
 arch/arm/mm/mm.h                                  |    2 +
 arch/powerpc/kernel/vio.c                         |    3 +-
 block/blk-settings.c                              |    8 ++--
 drivers/amba/bus.c                                |    6 +--
 drivers/ata/pata_ixp4xx_cf.c                      |    5 ++-
 drivers/ata/pata_octeon_cf.c                      |    5 +-
 drivers/block/nvme-core.c                         |   10 ++---
 drivers/crypto/ixp4xx_crypto.c                    |   48 ++++++++++----------
 drivers/dma/amba-pl08x.c                          |    5 ++
 drivers/dma/dw/platform.c                         |    8 +--
 drivers/dma/edma.c                                |   10 +++--
 drivers/dma/imx-sdma.c                            |    4 ++
 drivers/dma/pl330.c                               |    4 ++
 drivers/firmware/dcdbas.c                         |   32 ++++++++-----
 drivers/firmware/google/gsmi.c                    |   13 +++--
 drivers/gpu/drm/exynos/exynos_drm_drv.c           |    6 ++-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c          |    5 +-
 drivers/media/platform/omap3isp/isp.c             |    6 +-
 drivers/media/platform/omap3isp/isp.h             |    3 -
 drivers/mmc/card/queue.c                          |    3 +-
 drivers/mmc/host/sdhci-acpi.c                     |    5 +-
 drivers/net/ethernet/broadcom/b44.c               |    3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |    8 +---
 drivers/net/ethernet/brocade/bna/bnad.c           |   13 ++----
 drivers/net/ethernet/emulex/benet/be_main.c       |   12 +----
 drivers/net/ethernet/intel/e1000/e1000_main.c     |    9 +---
 drivers/net/ethernet/intel/e1000e/netdev.c        |   18 +++-----
 drivers/net/ethernet/intel/igb/igb_main.c         |   18 +++-----
 drivers/net/ethernet/intel/igbvf/netdev.c         |   18 +++-----
 drivers/net/ethernet/intel/ixgb/ixgb_main.c       |   16 ++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |   15 ++----
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   15 ++----
 drivers/net/ethernet/nxp/lpc_eth.c                |    6 ++-
 drivers/net/ethernet/octeon/octeon_mgmt.c         |    5 +-
 drivers/net/ethernet/sfc/efx.c                    |   12 +-----
 drivers/net/wireless/b43/dma.c                    |    9 +---
 drivers/net/wireless/b43legacy/dma.c              |    9 +---
 drivers/of/platform.c                             |    3 -
 drivers/parport/parport_pc.c                      |    8 +++-
 drivers/scsi/scsi_lib.c                           |    2 +-
 drivers/staging/dwc2/platform.c                   |    5 +-
 drivers/staging/et131x/et131x.c                   |   17 +------
 drivers/staging/imx-drm/imx-drm-core.c            |    8 +++-
 drivers/staging/imx-drm/ipuv3-crtc.c              |    4 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c       |    5 +--
 drivers/usb/chipidea/ci_hdrc_imx.c                |    7 +--
 drivers/usb/dwc3/dwc3-exynos.c                    |    7 +--
 drivers/usb/gadget/lpc32xx_udc.c                  |    4 +-
 drivers/usb/host/bcma-hcd.c                       |    3 +-
 drivers/usb/host/ehci-atmel.c                     |    7 +--
 drivers/usb/host/ehci-octeon.c                    |    4 +-
 drivers/usb/host/ehci-omap.c                      |   10 ++--
 drivers/usb/host/ehci-orion.c                     |    7 +--
 drivers/usb/host/ehci-platform.c                  |   10 ++--
 drivers/usb/host/ehci-s5p.c                       |    7 +--
 drivers/usb/host/ehci-spear.c                     |    7 +--
 drivers/usb/host/ehci-tegra.c                     |    7 +--
 drivers/usb/host/ohci-at91.c                      |    9 ++--
 drivers/usb/host/ohci-exynos.c                    |    7 +--
 drivers/usb/host/ohci-nxp.c                       |    5 +-
 drivers/usb/host/ohci-octeon.c                    |    5 +-
 drivers/usb/host/ohci-omap3.c                     |   10 ++--
 drivers/usb/host/ohci-pxa27x.c                    |    8 ++--
 drivers/usb/host/ohci-sa1111.c                    |    6 +++
 drivers/usb/host/ohci-spear.c                     |    7 +--
 drivers/usb/host/ssb-hcd.c                        |    3 +-
 drivers/usb/host/uhci-platform.c                  |    7 +--
 drivers/usb/musb/am35x.c                          |   50 +++++++-------------
 drivers/usb/musb/da8xx.c                          |   49 +++++++-------------
 drivers/usb/musb/davinci.c                        |   48 +++++++-------------
 drivers/usb/musb/tusb6010.c                       |   49 +++++++-------------
 drivers/video/amba-clcd.c                         |    5 ++
 include/linux/amba/bus.h                          |    2 -
 include/linux/dma-mapping.h                       |   31 +++++++++++++
 sound/arm/pxa2xx-pcm.c                            |   10 ++---
 sound/soc/atmel/atmel-pcm.c                       |   11 ++---
 sound/soc/blackfin/bf5xx-ac97-pcm.c               |   11 ++---
 sound/soc/blackfin/bf5xx-i2s-pcm.c                |   10 ++---
 sound/soc/davinci/davinci-pcm.c                   |    9 +---
 sound/soc/fsl/fsl_dma.c                           |    9 +---
 sound/soc/fsl/imx-pcm-fiq.c                       |   12 ++---
 sound/soc/fsl/mpc5200_dma.c                       |   10 ++---
 sound/soc/jz4740/jz4740-pcm.c                     |   12 ++---
 sound/soc/kirkwood/kirkwood-dma.c                 |    9 +---
 sound/soc/nuc900/nuc900-pcm.c                     |    9 ++--
 sound/soc/omap/omap-pcm.c                         |   11 ++---
 sound/soc/pxa/pxa2xx-pcm.c                        |   11 ++---
 sound/soc/s6000/s6000-pcm.c                       |    9 +---
 sound/soc/samsung/dma.c                           |   11 ++---
 sound/soc/samsung/idma.c                          |   11 ++---
 95 files changed, 515 insertions(+), 576 deletions(-)

through these changes:

Philippe Retornaz (1):
      ARM: 7857/1: dma: imx-sdma: setup dma mask

Russell King (46):
      DMA-API: provide a helper to set both DMA and coherent DMA masks
      DMA-API: net: brocade/bna/bnad.c: fix 32-bit DMA mask handling
      DMA-API: net: intel/e1000e: fix 32-bit DMA mask handling
      DMA-API: net: intel/igb: fix 32-bit DMA mask handling
      DMA-API: net: intel/igbvf: fix 32-bit DMA mask handling
      DMA-API: net: intel/ixgb: fix 32-bit DMA mask handling
      DMA-API: net: intel/ixgbe: fix 32-bit DMA mask handling
      DMA-API: net: intel/ixgbevf: fix 32-bit DMA mask handling
      DMA-API: net: broadcom/b44: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: net: broadcom/bnx2x: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: net: emulex/benet: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: net: intel/e1000: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: net: sfc/efx.c: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: net: b43: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: net: b43legacy: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: ppc: vio.c: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: block: nvme-core: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: staging: et131x: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: media: dt3155v4l: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: usb: bcma: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: usb: ssb-hcd: replace dma_set_mask()+dma_set_coherent_mask() with new helper
      DMA-API: amba: get rid of separate dma_mask
      DMA-API: dma: pl08x: add dma_set_mask_and_coherent() call
      DMA-API: dma: pl330: add dma_set_mask_and_coherent() call
      DMA-API: video: clcd: add dma_set_mask_and_coherent() call
      DMA-API: usb: ohci-sa1111: add a note about DMA masks
      DMA-API: provide a helper to setup DMA masks
      DMA-API: sound: fix dma mask handling in a lot of drivers
      DMA-API: ata: pata_octeon_cf: convert to use dma_coerce_mask_and_coherent()
      DMA-API: dma: dw_dmac.c: convert to use dma_coerce_mask_and_coherent()
      DMA-API: media: omap3isp: use dma_coerce_mask_and_coherent()
      DMA-API: mmc: sdhci-acpi: use dma_coerce_mask_and_coherent()
      DMA-API: net: nxp/lpc_eth: use dma_coerce_mask_and_coherent()
      DMA-API: net: octeon: use dma_coerce_mask_and_coherent()
      DMA-API: parport: parport_pc.c: use dma_coerce_mask_and_coherent()
      DMA-API: usb: use dma_set_coherent_mask()
      DMA-API: usb: use new dma_coerce_mask_and_coherent()
      DMA-API: staging: use dma_set_coherent_mask()
      DMA-API: others: use dma_set_coherent_mask()
      DMA-API: crypto: fix ixp4xx crypto platform device support
      DMA-API: crypto: remove last references to 'static struct device *dev'
      DMA-API: usb: musb: use platform_device_register_full() to avoid directly messing with dma masks
      DMA-API: dma: edma.c: no need to explicitly initialize DMA masks
      DMA-API: dcdbas: update DMA mask handing
      DMA-API: firmware/google/gsmi.c: avoid direct access to DMA masks
      ARM: DMA-API: better handing of DMA masks for coherent allocations

Santosh Shilimkar (5):
      ARM: 7794/1: block: Rename parameter dma_mask to max_addr for blk_queue_bounce_limit()
      ARM: 7795/1: mm: dma-mapping: Add dma_max_pfn(dev) helper function
      ARM: 7796/1: scsi: Use dma_max_pfn(dev) helper for bounce_limit calculations
      ARM: 7797/1: mmc: Use dma_max_pfn(dev) helper for bounce_limit calculations
      ARM: 7805/1: mm: change max*pfn to include the physical offset of memory

Thanks.
