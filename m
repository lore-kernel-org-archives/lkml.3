Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaBQRAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:00:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40160 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113AbaBQRAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:00:20 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 14/15] ASoC: pxa: spitz: Update locking around use of DAPM pin API
Date: Mon, 17 Feb 2014 16:51:42 +0000
Message-Id: <1392655903-24537-15-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
 sound/soc/pxa/spitz.c |   49 +++++++++++++++++++++++++++----------------------
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/sound/soc/pxa/spitz.c b/sound/soc/pxa/spitz.c
index fc052d8..e755919 100644
--- a/sound/soc/pxa/spitz.c
+++ b/sound/soc/pxa/spitz.c
@@ -46,60 +46,65 @@ static int spitz_mic_gpio;
 
 static void spitz_ext_control(struct snd_soc_dapm_context *dapm)
 {
+	mutex_lock(&dapm->card->dapm_mutex);
+
 	if (spitz_spk_func == SPITZ_SPK_ON)
-		snd_soc_dapm_enable_pin(dapm, "Ext Spk");
+		snd_soc_dapm_enable_pin_locked(dapm, "Ext Spk");
 	else
-		snd_soc_dapm_disable_pin(dapm, "Ext Spk");
+		snd_soc_dapm_disable_pin_locked(dapm, "Ext Spk");
 
 	/* set up jack connection */
 	switch (spitz_jack_func) {
 	case SPITZ_HP:
 		/* enable and unmute hp jack, disable mic bias */
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
-		snd_soc_dapm_disable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_disable_pin(dapm, "Line Jack");
-		snd_soc_dapm_enable_pin(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Mic Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Line Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Headphone Jack");
 		gpio_set_value(SPITZ_GPIO_MUTE_L, 1);
 		gpio_set_value(SPITZ_GPIO_MUTE_R, 1);
 		break;
 	case SPITZ_MIC:
 		/* enable mic jack and bias, mute hp */
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
-		snd_soc_dapm_disable_pin(dapm, "Line Jack");
-		snd_soc_dapm_enable_pin(dapm, "Mic Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Line Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Mic Jack");
 		gpio_set_value(SPITZ_GPIO_MUTE_L, 0);
 		gpio_set_value(SPITZ_GPIO_MUTE_R, 0);
 		break;
 	case SPITZ_LINE:
 		/* enable line jack, disable mic bias and mute hp */
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
-		snd_soc_dapm_disable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_enable_pin(dapm, "Line Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Mic Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Line Jack");
 		gpio_set_value(SPITZ_GPIO_MUTE_L, 0);
 		gpio_set_value(SPITZ_GPIO_MUTE_R, 0);
 		break;
 	case SPITZ_HEADSET:
 		/* enable and unmute headset jack enable mic bias, mute L hp */
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_enable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_disable_pin(dapm, "Line Jack");
-		snd_soc_dapm_enable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Mic Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Line Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Headset Jack");
 		gpio_set_value(SPITZ_GPIO_MUTE_L, 0);
 		gpio_set_value(SPITZ_GPIO_MUTE_R, 1);
 		break;
 	case SPITZ_HP_OFF:
 
 		/* jack removed, everything off */
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
-		snd_soc_dapm_disable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_disable_pin(dapm, "Line Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Mic Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Line Jack");
 		gpio_set_value(SPITZ_GPIO_MUTE_L, 0);
 		gpio_set_value(SPITZ_GPIO_MUTE_R, 0);
 		break;
 	}
+
+	mutex_unlock(&dapm->card->dapm_mutex);
+
 	snd_soc_dapm_sync(dapm);
 }
 
-- 
1.7.2.5

