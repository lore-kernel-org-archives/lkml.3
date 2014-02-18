Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbaBRPbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:31:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50589 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756353AbaBRPbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:31:05 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 14/17 v2] ASoC: pxa: corgi: Update locking around use of DAPM pin API
Date: Tue, 18 Feb 2014 15:22:25 +0000
Message-Id: <1392736948-26623-15-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pin updates in this driver look like they are intended to be done
atomically, update to do so.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/pxa/corgi.c |   42 +++++++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/sound/soc/pxa/corgi.c b/sound/soc/pxa/corgi.c
index 1853d41..9d9c8ad 100644
--- a/sound/soc/pxa/corgi.c
+++ b/sound/soc/pxa/corgi.c
@@ -47,51 +47,55 @@ static int corgi_spk_func;
 
 static void corgi_ext_control(struct snd_soc_dapm_context *dapm)
 {
+	snd_soc_dapm_mutex_lock(dapm);
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
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Mic Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Line Jack");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headset Jack");
 		break;
 	case CORGI_MIC:
 		/* reset = mute headphone */
 		gpio_set_value(CORGI_GPIO_MUTE_L, 0);
 		gpio_set_value(CORGI_GPIO_MUTE_R, 0);
-		snd_soc_dapm_enable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_disable_pin(dapm, "Line Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Mic Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Line Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headset Jack");
 		break;
 	case CORGI_LINE:
 		gpio_set_value(CORGI_GPIO_MUTE_L, 0);
 		gpio_set_value(CORGI_GPIO_MUTE_R, 0);
-		snd_soc_dapm_disable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_enable_pin(dapm, "Line Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Mic Jack");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Line Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headphone Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headset Jack");
 		break;
 	case CORGI_HEADSET:
 		gpio_set_value(CORGI_GPIO_MUTE_L, 0);
 		gpio_set_value(CORGI_GPIO_MUTE_R, 1);
-		snd_soc_dapm_enable_pin(dapm, "Mic Jack");
-		snd_soc_dapm_disable_pin(dapm, "Line Jack");
-		snd_soc_dapm_disable_pin(dapm, "Headphone Jack");
-		snd_soc_dapm_enable_pin(dapm, "Headset Jack");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Mic Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Line Jack");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headphone Jack");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Headset Jack");
 		break;
 	}
 
 	if (corgi_spk_func == CORGI_SPK_ON)
-		snd_soc_dapm_enable_pin(dapm, "Ext Spk");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Ext Spk");
 	else
-		snd_soc_dapm_disable_pin(dapm, "Ext Spk");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Ext Spk");
 
 	/* signal a DAPM event */
-	snd_soc_dapm_sync(dapm);
+	snd_soc_dapm_sync_unlocked(dapm);
+
+	snd_soc_dapm_mutex_unlock(dapm);
 }
 
 static int corgi_startup(struct snd_pcm_substream *substream)
-- 
1.7.2.5

