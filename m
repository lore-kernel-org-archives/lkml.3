Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaBQRAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:00:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40046 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbaBQRAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:00:05 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 04/15] ASoC: wm5100: Update locking around use of DAPM pin API
Date: Mon, 17 Feb 2014 16:51:32 +0000
Message-Id: <1392655903-24537-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1392655903-24537-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pin updates in this driver look like they are intended to be done
atomically, update to do so.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm5100.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 4e3e31a..c69992b 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2117,8 +2117,13 @@ int wm5100_detect(struct snd_soc_codec *codec, struct snd_soc_jack *jack)
 				    WM5100_ACCDET_RATE_MASK);
 
 		/* We need the charge pump to power MICBIAS */
-		snd_soc_dapm_force_enable_pin(&codec->dapm, "CP2");
-		snd_soc_dapm_force_enable_pin(&codec->dapm, "SYSCLK");
+		mutex_lock(&codec->dapm.card->dapm_mutex);
+
+		snd_soc_dapm_force_enable_pin_locked(&codec->dapm, "CP2");
+		snd_soc_dapm_force_enable_pin_locked(&codec->dapm, "SYSCLK");
+
+		mutex_unlock(&codec->dapm.card->dapm_mutex);
+
 		snd_soc_dapm_sync(&codec->dapm);
 
 		/* We start off just enabling microphone detection - even a
-- 
1.7.2.5

