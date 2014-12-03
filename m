Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaLCQjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:39:48 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:45310 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752502AbaLCQjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:39:43 -0500
Message-ID: <547F3CB2.5070306@arm.com>
Date: Wed, 03 Dec 2014 16:39:14 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: [PATCH 5/5] ASoC: dwc: Ensure FIFOs are flushed to prevent channel
 swap
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the FIFOs aren't flushed, the left/right channels may be swapped:
this may occur if the FIFOs are not empty when the streams start.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/designware_i2s.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index 083779d..932abfd 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -258,6 +258,7 @@ static int dw_i2s_hw_params(struct snd_pcm_substream *substream,
 	/* Iterate over set of channels - independently controlled. */
 	do {
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+			i2s_write_reg(dev->i2s_base, TXFFR, 1);
 			i2s_write_reg(dev->i2s_base, TCR(ch_reg),
 				      xfer_resolution);
 			i2s_write_reg(dev->i2s_base, TFCR(ch_reg), 0x02);
@@ -265,6 +266,7 @@ static int dw_i2s_hw_params(struct snd_pcm_substream *substream,
 			i2s_write_reg(dev->i2s_base, IMR(ch_reg), irq & ~0x30);
 			i2s_write_reg(dev->i2s_base, TER(ch_reg), 1);
 		} else {
+			i2s_write_reg(dev->i2s_base, RXFFR, 1);
 			i2s_write_reg(dev->i2s_base, RCR(ch_reg),
 				      xfer_resolution);
 			i2s_write_reg(dev->i2s_base, RFCR(ch_reg), 0x07);
-- 
1.7.1

