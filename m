Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaJVQLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:11:36 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53937 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754121AbaJVPpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 00/59] dmaengine: Implement generic slave capabilities retrieval
Date: Wed, 22 Oct 2014 17:43:14 +0200
Message-Id: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As we discussed a couple of weeks ago, this is the third attempt at
creating a generic behaviour for slave capabilities retrieval so that
generic layers using dmaengine can actually rely on that.

That has been done mostly through two steps: by moving out the
sub-commands of the device_control callback, so that the dmaengine
core can then infer from that wether a sub-command is implemented, and
then by moving the slave properties, such as the supported buswidth,
to the structure dma_device itself.

Comments are as usual appreciated!

Thanks,
Maxime

Changes from v2:
  - Reworked dma_chan_get/dma_chan_put in order to optionally use
    device_alloc_chan_resources/device_free_chan_resources
  - Modified a few client drivers that were still calling
    device_control directly to use the dmaengine API instead
  - Totally remove device_control and device_slave_config
  - Move device_control BUG_ON removal earlier in the patch set to
    avoid breaking the bisectability
  - Converted rapidio tsi721 driver too.
  - Minor cosmetics changes and fixes suggested by Laurent Pinchart
    and Andy Shevchenko
  - Fixed a few build warnings
  - Collected the various Acked-by
  - Rebased on top of 3.18-rc1

Changes from v1:
  - Add a flag to trigger the generic slave caps mechanism
  - Add a warning whenever this flag is not set, or when a
    device_control callback is still defined
  - Migrate all existing users to use the new callbacks, and the
    generic slave capabilities

Maxime Ripard (59):
  crypto: ux500: Use dmaengine_terminate_all API
  serial: at91: Use dmaengine_slave_config API
  dmaengine: Make the destination abbreviation coherent
  dmaengine: Rework dma_chan_get
  dmaengine: Make channel allocation callbacks optional
  dmaengine: Introduce a device_config callback
  dmaengine: split out pause/resume operations from device_control
  dmaengine: Add device_terminate_all callback
  dmaengine: Remove the need to declare device_control
  dmaengine: Create a generic dma_slave_caps callback
  dmaengine: Move slave caps to dma_device
  dmaengine: pl08x: Split device_control
  dmaengine: hdmac: Split device_control
  dmaengine: bcm2835: Split device_control
  dmaengine: coh901318: Split device_control
  dmaengine: cppi41: Split device_control
  dmaengine: jz4740: Split device_control
  dmaengine: dw: Split device_control
  dmaengine: edma: Split device_control
  dmaengine: ep93xx: Split device_control
  dmaengine: fsl-edma: Split device_control
  dmaengine: imx: Split device_control
  dmaengine: imx-sdma: Split device_control
  dmaengine: intel-mid-dma: Split device_control
  dmaengine: ipu-idmac: Split device_control
  dmaengine: k3: Split device_control
  dmaengine: mmp-pdma: Split device_control
  dmaengine: mmp-tdma: Split device_control
  dmaengine: moxart: Split device_control
  dmaengine: fsl-dma: Split device_control
  dmaengine: mpc512x: Split device_control
  dmaengine: mxs: Split device_control
  dmaengine: nbpfaxi: Split device_control
  dmaengine: omap: Split device_control
  dmaengine: pl330: Split device_control
  dmaengine: bam-dma: Split device_control
  dmaengine: s3c24xx: Split device_control
  dmaengine: sa11x0: Split device_control
  dmaengine: sh: Split device_control
  dmaengine: sirf: Split device_control
  dmaengine: sun6i: Split device_control
  dmaengine: d40: Split device_control
  dmaengine: tegra20: Split device_control
  dmaengine: xilinx: Split device_control
  dmaengine: mv_xor: Remove device_control
  dmaengine: pch-dma: Rename device_control
  dmaengine: td: Rename device_control
  dmaengine: txx9: Rename device_control
  dmaengine: rapidio: tsi721: Rename device_control
  dmaengine: bcm2835: Declare slave capabilities for the generic code
  dmaengine: fsl-edma: Declare slave capabilities for the generic code
  dmaengine: edma: Declare slave capabilities for the generic code
  dmaengine: nbpfaxi: Declare slave capabilities for the generic code
  dmaengine: omap: Declare slave capabilities for the generic code
  dmaengine: pl330: Declare slave capabilities for the generic code
  dmaengine: sirf: Declare slave capabilities for the generic code
  dmaengine: sun6i: Declare slave capabilities for the generic code
  dmaengine: Add a warning for drivers not using the generic slave caps
    retrieval
  dmaengine: Remove device_control and device_slave_caps

 drivers/crypto/ux500/cryp/cryp_core.c |   4 +-
 drivers/crypto/ux500/hash/hash_core.c |   2 +-
 drivers/dma/amba-pl08x.c              | 156 +++++++++++++++------------
 drivers/dma/at_hdmac.c                | 121 ++++++++++++---------
 drivers/dma/bcm2835-dma.c             |  47 +++-----
 drivers/dma/coh901318.c               | 137 +++++++++++------------
 drivers/dma/cppi41.c                  |  30 +-----
 drivers/dma/dma-jz4740.c              |  20 +---
 drivers/dma/dmaengine.c               |  51 +++++----
 drivers/dma/dw/core.c                 |  82 +++++++-------
 drivers/dma/edma.c                    |  71 ++++--------
 drivers/dma/ep93xx_dma.c              |  41 ++-----
 drivers/dma/fsl-edma.c                | 124 ++++++++++-----------
 drivers/dma/fsldma.c                  |  91 ++++++----------
 drivers/dma/imx-dma.c                 | 103 +++++++++---------
 drivers/dma/imx-sdma.c                |  66 ++++++------
 drivers/dma/intel_mid_dma.c           |  25 ++---
 drivers/dma/ipu/ipu_idmac.c           |  96 +++++++++--------
 drivers/dma/k3dma.c                   | 197 ++++++++++++++++++----------------
 drivers/dma/mmp_pdma.c                | 109 ++++++++++---------
 drivers/dma/mmp_tdma.c                |  82 +++++++-------
 drivers/dma/moxart-dma.c              |  25 +----
 drivers/dma/mpc512x_dma.c             | 111 +++++++++----------
 drivers/dma/mv_xor.c                  |   9 --
 drivers/dma/mxs-dma.c                 |  59 ++++------
 drivers/dma/nbpfaxi.c                 | 111 +++++++++----------
 drivers/dma/omap-dma.c                |  70 ++++--------
 drivers/dma/pch_dma.c                 |   8 +-
 drivers/dma/pl330.c                   | 127 ++++++++++------------
 drivers/dma/qcom_bam_dma.c            |  85 +++++++--------
 drivers/dma/s3c24xx-dma.c             |  75 +++++++------
 drivers/dma/sa11x0-dma.c              | 158 ++++++++++++++-------------
 drivers/dma/sh/shdma-base.c           |  72 ++++++-------
 drivers/dma/sirf-dma.c                |  60 +++--------
 drivers/dma/ste_dma40.c               |  60 +++++------
 drivers/dma/sun6i-dma.c               | 159 ++++++++++++++-------------
 drivers/dma/tegra20-apb-dma.c         |  22 +---
 drivers/dma/timb_dma.c                |   8 +-
 drivers/dma/txx9dmac.c                |   9 +-
 drivers/dma/xilinx/xilinx_vdma.c      |  29 ++---
 drivers/rapidio/devices/tsi721_dma.c  |   8 +-
 drivers/tty/serial/atmel_serial.c     |  10 +-
 include/linux/dmaengine.h             | 122 ++++++++++++---------
 sound/soc/soc-generic-dmaengine-pcm.c |   2 +-
 44 files changed, 1409 insertions(+), 1645 deletions(-)

-- 
2.1.1

