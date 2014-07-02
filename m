Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaGBL3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:29:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33798 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGBL3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:29:47 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <lars@metafoo.de>,
        <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, <joelf@ti.com>, <nsekhar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 0/4] ALSA/dmaengine: Fix 3 bytes physical sample support
Date: Wed, 2 Jul 2014 14:29:26 +0300
Message-ID: <1404300570-14082-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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
In snd_dmaengine_pcm_open() we should check the slave_caps of the dma if it
supports DMA_SLAVE_BUSWIDTH_3_BYTES. Based on this information we initialize
the runtime->hw.formats: if DMA_SLAVE_BUSWIDTH_3_BYTES is not supported or
the slave_caps is not provided by the driver we mask out the 24 bits
physical width sample formats so they will be not available for user space
to pick. If the DMA_SLAVE_BUSWIDTH_3_BYTES is supported _3LE/_3BE formats
will not be masked so later on they can be valid if both CPU and codec dai
supports them.

Regards,
Peter
---
Peter Ujfalusi (4):
  dma: Support for 3 bytes word size
  dma: edma: Declare DMA_SLAVE_BUSWIDTH_3_BYTES as supported buswidth
  ALSA: pcm_dmaengine: Use the available wrapper to get physical width
  ALSA: pcm_dmaengine: Correct support for 3 physical bytes samples

 drivers/dma/edma.c         |  1 +
 include/linux/dmaengine.h  |  1 +
 sound/core/pcm_dmaengine.c | 41 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 41 insertions(+), 2 deletions(-)

-- 
2.0.0

