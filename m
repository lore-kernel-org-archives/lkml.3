Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaCMJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:25:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32899 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbaCMJTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:19:22 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 00/18] edma/ASoC: dmaengine PCM for AM335x and AM447x
Date: Thu, 13 Mar 2014 11:18:22 +0200
Message-ID: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With this series AM335x and AM447x will use the dmaengine PCM for audio. The
daVinci devices will keep using the davinci-pcm for now since I do not have
means to test them but the code is written in a way that they can be switched
to use the edma-pcm easily (DA850/OMAP-L138 has been tested and audio was
working fine).

To be able to use the dmaengine PCM I needed to make changes to the edma code in
arch/arm/common/ and in drivers/dma/ :
Adding support for DMA pause/resume
Possibility to select non default event queue/TC for cyclic (audio) dma
channels: all devices using the eDMA via dmaengine was assigned to the default
EQ/TC (mmc, i2c, spi, etc, and audio). This is not optimal from system
performance point of view since sharing the same EQ/TC can cause latency spikes
for cyclic channels (long DMA transfers for MMC for example).

While debugging the edma to get things sorted out I noticed that the debug was
too verbose and the important information was hidden even when the we did not
asked for verbose dmaengine debug.
I have included some debug cleanups for the edma dmaengine driver also.

On the ASoC side: the series has been tested on AM335x and AM447x. I have report
that DA850/OMAP-L138 works with this series (which boots w/o DT).

Regards,
Peter
---
Peter Ujfalusi (18):
  platform_data: edma: Be precise with the paRAM struct
  dma: edma: Add support for DMA_PAUSE/RESUME operation
  dma: edma: Set DMA_CYCLIC capability flag
  arm: common: edma: Select event queue 1 as default when booted with DT
  arm: common: edma: Save the number of event queues/TCs
  arm: common: edma: API to request non default queue for a channel
  DMA: edma: Use different eventq for cyclic channels
  dma: edma: Implement device_slave_caps callback
  dma: edma: Simplify direction configuration in edma_config_pset()
  dma: edma: Reduce debug print verbosity for non verbose debugging
  dma: edma: Prefix debug prints where the text were identical in prep
    callbacks
  dma: edma: Add channel number to debug prints
  dma: edma: Print the direction value as well when it is not supported
  ASoC: davinci: Add edma dmaengine platform driver
  ASoC: davinci-mcasp: Use dmaengine based platform driver for
    AM335x/447x
  ASoC: davinci-mcasp: Provide correct filter_data for dmaengine for
    non-DT boot
  ASoC: davinci-mcasp: Assign the dma_data earlier in dai_probe callback
  ASoC: davinci-mcasp: Place constraint on the period size based on FIFO
    config

 arch/arm/common/edma.c             |  34 ++++++++++++-
 drivers/dma/edma.c                 |  92 ++++++++++++++++++++++++++--------
 include/linux/platform_data/edma.h |  20 ++++----
 sound/soc/davinci/Kconfig          |   1 +
 sound/soc/davinci/Makefile         |   2 +-
 sound/soc/davinci/davinci-mcasp.c  | 100 ++++++++++++++++++++++++++++++-------
 sound/soc/davinci/edma-pcm.c       |  77 ++++++++++++++++++++++++++++
 sound/soc/davinci/edma-pcm.h       |  26 ++++++++++
 8 files changed, 303 insertions(+), 49 deletions(-)
 create mode 100644 sound/soc/davinci/edma-pcm.c
 create mode 100644 sound/soc/davinci/edma-pcm.h

-- 
1.9.0

