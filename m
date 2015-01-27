Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbbA0MRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:17:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121AbbA0MQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:16:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Jackson <Andrew.Jackson@arm.com>, Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 005/126] ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap
Date: Tue, 27 Jan 2015 12:15:10 +0000
Message-Id: <1422361031-19364-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jackson <Andrew.Jackson@arm.com>

commit 3475c3d034d7f276a474c8bd53f44b48c8bf669d upstream.

Flush the FIFOs when the stream is prepared for use.  This avoids
an inadvertent swapping of the left/right channels if the FIFOs are
not empty at startup.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.4

