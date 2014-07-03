Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaGCEw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:52:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47469 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbaGCEwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:52:21 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <lars@metafoo.de>,
        <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, <joelf@ti.com>, <nsekhar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH v3 4/5] ALSA: pcm_dmaengine: Correct support for 24bits physical sample widths
Date: Thu, 3 Jul 2014 07:51:55 +0300
Message-ID: <1404363116-10538-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
References: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of _3LE/_3BE formats the samples are stored in 3 consecutive bytes
without padding it to 4 bytes. This means that the DMA needs to be able to
support 3 bytes word length in order to read/write the samples from memory
correctly. Originally the code treated 24 bits physical length samples as
they were 32 bits which leads to corruption when playing or recording audio.

The hw.formats field has already been prepared to exclude formats not
supported by the DMA engine in use, which means that only on platforms where
3 bytes is supported by the DMA will be able to use this format.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/core/pcm_dmaengine.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
index d5611ec80381..6542c4083594 100644
--- a/sound/core/pcm_dmaengine.c
+++ b/sound/core/pcm_dmaengine.c
@@ -72,6 +72,8 @@ int snd_hwparams_to_dma_slave_config(const struct snd_pcm_substream *substream,
 		buswidth = DMA_SLAVE_BUSWIDTH_1_BYTE;
 	else if (bits == 16)
 		buswidth = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	else if (bits == 24)
+		buswidth = DMA_SLAVE_BUSWIDTH_3_BYTES;
 	else if (bits <= 32)
 		buswidth = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	else
-- 
2.0.0

