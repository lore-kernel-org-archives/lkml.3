Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbbA2JtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:49:01 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44814 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759304AbbA2JEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Jackson <Andrew.Jackson@arm.com>,
        Mark Brown <broonie@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 011/176] ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap
Date: Wed, 28 Jan 2015 15:27:21 +0100
Message-Id: <e3ab75edf0292a413a45448b993775ba4cc4dbd9.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3475c3d034d7f276a474c8bd53f44b48c8bf669d upstream.

Flush the FIFOs when the stream is prepared for use.  This avoids
an inadvertent swapping of the left/right channels if the FIFOs are
not empty at startup.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/dwc/designware_i2s.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index 25c31f1655f6..2f6357578616 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -263,6 +263,19 @@ static void dw_i2s_shutdown(struct snd_pcm_substream *substream,
 	snd_soc_dai_set_dma_data(dai, substream, NULL);
 }
 
+static int dw_i2s_prepare(struct snd_pcm_substream *substream,
+			  struct snd_soc_dai *dai)
+{
+	struct dw_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		i2s_write_reg(dev->i2s_base, TXFFR, 1);
+	else
+		i2s_write_reg(dev->i2s_base, RXFFR, 1);
+
+	return 0;
+}
+
 static int dw_i2s_trigger(struct snd_pcm_substream *substream,
 		int cmd, struct snd_soc_dai *dai)
 {
@@ -294,6 +307,7 @@ static struct snd_soc_dai_ops dw_i2s_dai_ops = {
 	.startup	= dw_i2s_startup,
 	.shutdown	= dw_i2s_shutdown,
 	.hw_params	= dw_i2s_hw_params,
+	.prepare	= dw_i2s_prepare,
 	.trigger	= dw_i2s_trigger,
 };
 
-- 
2.2.2

