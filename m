Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbbA2LWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:22:25 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:57627 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552AbbA2LWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:22:21 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Peter Rosin <peda@axentia.se>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ASoC: pcm512x: Use the correct range constraints for S24_LE
Date: Thu, 29 Jan 2015 12:21:56 +0100
Message-Id: <1422530516-21779-3-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422530516-21779-1-git-send-email-peda@lysator.liu.se>
References: <1422530516-21779-1-git-send-email-peda@lysator.liu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

This was overlooked in the late change to remove the I2S padding bits
from S24_LE mode. The patch also limits S32_LE mode to 384kHz, the
maximum according to the datasheets.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 sound/soc/codecs/pcm512x.c |   39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index 067d11743c31..884784fb1566 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -356,36 +356,37 @@ static const struct snd_pcm_hw_constraint_list constraints_slave = {
 	.list  = pcm512x_dai_rates,
 };
 
-static const struct snd_interval pcm512x_dai_ranges_64bpf[] = {
-	{
-		.min = 8000,
-		.max = 195312,
-	}, {
-		.min = 250000,
-		.max = 390625,
-	},
-};
-
-static struct snd_pcm_hw_constraint_ranges constraints_64bpf = {
-	.count  = ARRAY_SIZE(pcm512x_dai_ranges_64bpf),
-	.ranges = pcm512x_dai_ranges_64bpf,
-};
-
 static int pcm512x_hw_rule_rate(struct snd_pcm_hw_params *params,
 				struct snd_pcm_hw_rule *rule)
 {
-	struct snd_pcm_hw_constraint_ranges *r = rule->private;
+	struct snd_interval ranges[2];
 	int frame_size;
 
 	frame_size = snd_soc_params_to_frame_size(params);
 	if (frame_size < 0)
 		return frame_size;
 
-	if (frame_size != 64)
+	switch (frame_size) {
+	case 32:
+		/* No hole when the frame size is 32. */
 		return 0;
+	case 48:
+	case 64:
+		/* There is only one hole in the range of supported
+		 * rates, but it moves with the frame size.
+		 */
+		memset(ranges, 0, sizeof(ranges));
+		ranges[0].min = 8000;
+		ranges[0].max = 25000000 / frame_size / 2;
+		ranges[1].min = DIV_ROUND_UP(16000000, frame_size);
+		ranges[1].max = 384000;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	return snd_interval_ranges(hw_param_interval(params, rule->var),
-				   r->count, r->ranges, r->mask);
+				   ARRAY_SIZE(ranges), ranges, 0);
 }
 
 static int pcm512x_dai_startup_master(struct snd_pcm_substream *substream,
@@ -407,7 +408,7 @@ static int pcm512x_dai_startup_master(struct snd_pcm_substream *substream,
 		return snd_pcm_hw_rule_add(substream->runtime, 0,
 					   SNDRV_PCM_HW_PARAM_RATE,
 					   pcm512x_hw_rule_rate,
-					   (void *)&constraints_64bpf,
+					   NULL,
 					   SNDRV_PCM_HW_PARAM_FRAME_BITS,
 					   SNDRV_PCM_HW_PARAM_CHANNELS, -1);
 
-- 
1.7.10.4

