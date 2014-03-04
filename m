Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbaCDUYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:24:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbaCDUFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dylan Reid <dgreid@chromium.org>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 45/97] ASoC: max98090: sync regcache on entering STANDBY
Date: Tue,  4 Mar 2014 12:03:58 -0800
Message-Id: <20140304200347.513144019@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Reid <dgreid@chromium.org>

commit c42c8922c46d33ed769e99618bdfba06866a0c72 upstream.

Sync regcache when entering STANDBY from OFF.  ON isn't entered with
OFF as the current state, so the registers were not being re-synced
after suspend/resume.

The 98088 and 98095 already call regcache_sync from STANDBY.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/max98090.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1755,16 +1755,6 @@ static int max98090_set_bias_level(struc
 
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
@@ -1778,6 +1768,16 @@ static int max98090_set_bias_level(struc
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


