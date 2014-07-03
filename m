Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020AbaGCEwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:52:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47451 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaGCEwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:52:12 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <lars@metafoo.de>,
        <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, <joelf@ti.com>, <nsekhar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH v3 0/5] ALSA/ASoC/dmaengine: Fix 3 bytes physical sample support
Date: Thu, 3 Jul 2014 07:51:51 +0300
Message-ID: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v2 (in patch 3):
- Replace BIT(bits / 8) with (1 << (bits / 8)) as pointed out by Takashi
- Use switch (addr_widths) to filter non valid physical widths, like -EINVAL or
  widths not dividable by 8.
  The same check could be done with:
  if (bits > 0 && bits <=64 && !(bits % 8) && (addr_widths & (1 << (bits / 8))))
  But I think the switch() implementation is more readable.

Changes since v1:
- the hw.formats mask preparation moved to dmaengine_pcm_set_runtime_hwparams()
- we prepare the mask for all supported sample formats based on the physical
  width of the sample and on the slave_caps information.

I have noticed while switching the daVinci audio to dmaengine_pcm that the _3LE
and _3BE support is not working correctly via dmaengine_pcm:
In case of _3LE/_3BE formats the samples are stored in 3 consecutive bytes
without padding it to 4 bytes. This means that the DMA needs to be able to
support 3 bytes word length in order to read/write the samples from memory
correctly. Originally the code treated 24 bits physical length samples as
they were 32 bits which leads to corruption when playing or recording audio.

To fix the support for 3 bytes physical samples the dma driver also need to have
support for such data arrangement. eDMA does have support for it in HW and the
legacy davinci-pcm platform driver w/o dmaengine was able to support such
formats.

First step is to add DMA_SLAVE_BUSWIDTH_3_BYTES to dma_slave_buswidth for
engines and users to select 3 bytes as bus width.

Followed by:
In dmaengine_pcm_set_runtime_hwparams() we should check the slave_caps of the
dma if it supports the give sample physical width of the sample. Based on this
information we initialize the hw.formats: masking out all non supported formats
based on the physical width.
In case the dma driver does not implement the slave_caps the default assumption
is that it supports 1, 2 and 4 bytes widths.

Regards,
Peter
---
Peter Ujfalusi (5):
  dma: Support for 3 bytes word size
  ALSA: pcm_dmaengine: Use the available wrapper to get physical width
  ASoC: generic-dmaengine-pcm: Prepare formats mask for valid physical
    sample sizes
  ALSA: pcm_dmaengine: Correct support for 24bits physical sample widths
  dma: edma: Declare DMA_SLAVE_BUSWIDTH_3_BYTES as supported buswidth

 drivers/dma/edma.c                    |  1 +
 include/linux/dmaengine.h             |  1 +
 sound/core/pcm_dmaengine.c            |  4 +++-
 sound/soc/soc-generic-dmaengine-pcm.c | 37 ++++++++++++++++++++++++++++++++++-
 4 files changed, 41 insertions(+), 2 deletions(-)

-- 
2.0.0

