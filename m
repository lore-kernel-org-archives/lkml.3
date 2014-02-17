Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaBQRBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:01:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40120 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088AbaBQRAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:00:17 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 12/15] ASoC: pxa: corgi: Update locking around use of DAPM pin API
Date: Mon, 17 Feb 2014 16:51:40 +0000
Message-Id: <1392655903-24537-13-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
 sound/soc/pxa/corgi.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/sound/soc/pxa/corgi.c b/sound/soc/pxa/corgi.c
index 1853d41..d29cd0d 100644
--- a/sound/soc/pxa/corgi.c
+++ b/sound/soc/pxa/corgi.c
@@ -47,48 +47,52 @@ static int corgi_spk_func;
 
 static void corgi_ext_control(struct snd_soc_dapm_context *dapm)
 {
+	mutex_lock(&dapm->card->dapm_mutex);
+
 	/* set up jack connection */
 	switch (corgi_jack_func) {
 	case CORGI_HP:
 		/* set = unmute headphone */
 		gpio_set_value(CORGI_GPIO_MUTE_L, 1);
 		gpio_set_value(CORGI_GPIO_MUTE_R, 1);
-		snd_soc_dapm_disable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_disable_pin(dapm, "Line Jack");
-		snd_soc_dapm_enable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Mic Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Line Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headset Jack");
 		break;
 	case CORGI_MIC:
 		/* reset = mute headphone */
 		gpio_set_value(CORGI_GPIO_MUTE_L, 0);
 		gpio_set_value(CORGI_GPIO_MUTE_R, 0);
-		snd_soc_dapm_enable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_disable_pin(dapm, "Line Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Mic Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Line Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headset Jack");
 		break;
 	case CORGI_LINE:
 		gpio_set_value(CORGI_GPIO_MUTE_L, 0);
 		gpio_set_value(CORGI_GPIO_MUTE_R, 0);
-		snd_soc_dapm_disable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_enable_pin(dapm, "Line Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Mic Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Line Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headset Jack");
 		break;
 	case CORGI_HEADSET:
 		gpio_set_value(CORGI_GPIO_MUTE_L, 0);
 		gpio_set_value(CORGI_GPIO_MUTE_R, 1);
-		snd_soc_dapm_enable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_disable_pin(dapm, "Line Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_enable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Mic Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Line Jack");
+		snd_soc_dapm_disable_pin_locked(dapm, "Headphone Jack");
+		snd_soc_dapm_enable_pin_locked(dapm, "Headset Jack");
 		break;
 	}
 
 	if (corgi_spk_func == CORGI_SPK_ON)
-		snd_soc_dapm_enable_pin(dapm, "Ext Spk");
+		snd_soc_dapm_enable_pin_locked(dapm, "Ext Spk");
 	else
-		snd_soc_dapm_disable_pin(dapm, "Ext Spk");
+		snd_soc_dapm_disable_pin_locked(dapm, "Ext Spk");
+
+	mutex_unlock(&dapm->card->dapm_mutex);
 
 	/* signal a DAPM event */
 	snd_soc_dapm_sync(dapm);
-- 
1.7.2.5

