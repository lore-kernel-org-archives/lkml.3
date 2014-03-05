Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281AbaCEP0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:26:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40805 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbaCEOY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dylan Reid <dgreid@chromium.org>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 024/131] ASoC: max98090: sync regcache on entering STANDBY
Date: Wed,  5 Mar 2014 14:22:28 +0000
Message-Id: <1394029455-23128-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Reid <dgreid@chromium.org>

commit c42c8922c46d33ed769e99618bdfba06866a0c72 upstream.

Sync regcache when entering STANDBY from OFF.  ON isn't entered with
OFF as the current state, so the registers were not being re-synced
after suspend/resume.

The 98088 and 98095 already call regcache_sync from STANDBY.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/max98090.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index ad5313f..b8f9fc5 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1769,16 +1769,6 @@ static int max98090_set_bias_level(struct snd_soc_codec *codec,
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
-		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
-			ret = regcache_sync(max98090->regmap);
-
-			if (ret != 0) {
-				dev_err(codec->dev,
-					"Failed to sync cache: %d\n", ret);
-				return ret;
-			}
-		}
-
 		if (max98090->jack_state == M98090_JACK_STATE_HEADSET) {
 			/*
 			 * Set to normal bias level.
@@ -1792,6 +1782,16 @@ static int max98090_set_bias_level(struct snd_soc_codec *codec,
 		break;
 
 	case SND_SOC_BIAS_STANDBY:
+		if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
+			ret = regcache_sync(max98090->regmap);
+			if (ret != 0) {
+				dev_err(codec->dev,
+					"Failed to sync cache: %d\n", ret);
+				return ret;
+			}
+		}
+		break;
+
 	case SND_SOC_BIAS_OFF:
 		/* Set internal pull-up to lowest power mode */
 		snd_soc_update_bits(codec, M98090_REG_JACK_DETECT,
-- 
1.9.0

