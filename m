Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965601AbaLLJ0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:26:08 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:35921 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934654AbaLLJ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:26:04 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] ASoC: dwc: Iterate over all channels
Date: Fri, 12 Dec 2014 09:25:02 +0000
Message-Id: <494c09d07353babe621dd292c96723dcdddccd68.1418372910.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1418372910.git.Andrew.Jackson@arm.com>
References: <cover.1418372910.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1418372910.git.Andrew.Jackson@arm.com>
References: <cover.1418372910.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

The Designware core can be configured with up to four stereo channels.
Each stereo channel is individually configured so, when the driver's
hw_params call is made, each requested stereo channel has to be
programmed.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/designware_i2s.c |   39 ++++++++++++++++++---------------------
 1 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index b9d6a25..1d26ded 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -209,16 +209,9 @@ static int dw_i2s_hw_params(struct snd_pcm_substream *substream,
 
 	switch (config->chan_nr) {
 	case EIGHT_CHANNEL_SUPPORT:
-		ch_reg = 3;
-		break;
 	case SIX_CHANNEL_SUPPORT:
-		ch_reg = 2;
-		break;
 	case FOUR_CHANNEL_SUPPORT:
-		ch_reg = 1;
-		break;
 	case TWO_CHANNEL_SUPPORT:
-		ch_reg = 0;
 		break;
 	default:
 		dev_err(dev->dev, "channel not supported\n");
@@ -227,20 +220,24 @@ static int dw_i2s_hw_params(struct snd_pcm_substream *substream,
 
 	i2s_disable_channels(dev, substream->stream);
 
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		i2s_write_reg(dev->i2s_base, TXFFR, 1);
-		i2s_write_reg(dev->i2s_base, TCR(ch_reg), xfer_resolution);
-		i2s_write_reg(dev->i2s_base, TFCR(ch_reg), 0x02);
-		irq = i2s_read_reg(dev->i2s_base, IMR(ch_reg));
-		i2s_write_reg(dev->i2s_base, IMR(ch_reg), irq & ~0x30);
-		i2s_write_reg(dev->i2s_base, TER(ch_reg), 1);
-	} else {
-		i2s_write_reg(dev->i2s_base, RXFFR, 1);
-		i2s_write_reg(dev->i2s_base, RCR(ch_reg), xfer_resolution);
-		i2s_write_reg(dev->i2s_base, RFCR(ch_reg), 0x07);
-		irq = i2s_read_reg(dev->i2s_base, IMR(ch_reg));
-		i2s_write_reg(dev->i2s_base, IMR(ch_reg), irq & ~0x03);
-		i2s_write_reg(dev->i2s_base, RER(ch_reg), 1);
+	for (ch_reg = 0; ch_reg < (config->chan_nr / 2); ch_reg++) {
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+			i2s_write_reg(dev->i2s_base, TXFFR, 1);
+			i2s_write_reg(dev->i2s_base, TCR(ch_reg),
+				      xfer_resolution);
+			i2s_write_reg(dev->i2s_base, TFCR(ch_reg), 0x02);
+			irq = i2s_read_reg(dev->i2s_base, IMR(ch_reg));
+			i2s_write_reg(dev->i2s_base, IMR(ch_reg), irq & ~0x30);
+			i2s_write_reg(dev->i2s_base, TER(ch_reg), 1);
+		} else {
+			i2s_write_reg(dev->i2s_base, RXFFR, 1);
+			i2s_write_reg(dev->i2s_base, RCR(ch_reg),
+				      xfer_resolution);
+			i2s_write_reg(dev->i2s_base, RFCR(ch_reg), 0x07);
+			irq = i2s_read_reg(dev->i2s_base, IMR(ch_reg));
+			i2s_write_reg(dev->i2s_base, IMR(ch_reg), irq & ~0x03);
+			i2s_write_reg(dev->i2s_base, RER(ch_reg), 1);
+		}
 	}
 
 	i2s_write_reg(dev->i2s_base, CCR, ccr);
-- 
1.7.1

