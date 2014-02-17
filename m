Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaBQRCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:02:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40089 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046AbaBQRAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:00:11 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 08/15] ASoC: mfld_machine: Update locking around use of DAPM pin API
Date: Mon, 17 Feb 2014 16:51:36 +0000
Message-Id: <1392655903-24537-9-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
 sound/soc/intel/mfld_machine.c |   43 +++++++++++++++++++++++++++-------------
 1 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/sound/soc/intel/mfld_machine.c b/sound/soc/intel/mfld_machine.c
index d3d4c32..4b60542 100644
--- a/sound/soc/intel/mfld_machine.c
+++ b/sound/soc/intel/mfld_machine.c
@@ -105,15 +105,20 @@ static int headset_set_switch(struct snd_kcontrol *kcontrol,
 	if (ucontrol->value.integer.value[0] == hs_switch)
 		return 0;
 
+	mutex_lock(&codec->dapm.card->dapm_mutex);
+
 	if (ucontrol->value.integer.value[0]) {
 		pr_debug("hs_set HS path\n");
-		snd_soc_dapm_enable_pin(&codec->dapm, "Headphones");
-		snd_soc_dapm_disable_pin(&codec->dapm, "EPOUT");
+		snd_soc_dapm_enable_pin_locked(&codec->dapm, "Headphones");
+		snd_soc_dapm_disable_pin_locked(&codec->dapm, "EPOUT");
 	} else {
 		pr_debug("hs_set EP path\n");
-		snd_soc_dapm_disable_pin(&codec->dapm, "Headphones");
-		snd_soc_dapm_enable_pin(&codec->dapm, "EPOUT");
+		snd_soc_dapm_disable_pin_locked(&codec->dapm, "Headphones");
+		snd_soc_dapm_enable_pin_locked(&codec->dapm, "EPOUT");
 	}
+
+	mutex_unlock(&codec->dapm.card->dapm_mutex);
+
 	snd_soc_dapm_sync(&codec->dapm);
 	hs_switch = ucontrol->value.integer.value[0];
 
@@ -122,19 +127,23 @@ static int headset_set_switch(struct snd_kcontrol *kcontrol,
 
 static void lo_enable_out_pins(struct snd_soc_codec *codec)
 {
-	snd_soc_dapm_enable_pin(&codec->dapm, "IHFOUTL");
-	snd_soc_dapm_enable_pin(&codec->dapm, "IHFOUTR");
-	snd_soc_dapm_enable_pin(&codec->dapm, "LINEOUTL");
-	snd_soc_dapm_enable_pin(&codec->dapm, "LINEOUTR");
-	snd_soc_dapm_enable_pin(&codec->dapm, "VIB1OUT");
-	snd_soc_dapm_enable_pin(&codec->dapm, "VIB2OUT");
+	mutex_lock(&codec->dapm.card->dapm_mutex);
+
+	snd_soc_dapm_enable_pin_locked(&codec->dapm, "IHFOUTL");
+	snd_soc_dapm_enable_pin_locked(&codec->dapm, "IHFOUTR");
+	snd_soc_dapm_enable_pin_locked(&codec->dapm, "LINEOUTL");
+	snd_soc_dapm_enable_pin_locked(&codec->dapm, "LINEOUTR");
+	snd_soc_dapm_enable_pin_locked(&codec->dapm, "VIB1OUT");
+	snd_soc_dapm_enable_pin_locked(&codec->dapm, "VIB2OUT");
 	if (hs_switch) {
-		snd_soc_dapm_enable_pin(&codec->dapm, "Headphones");
-		snd_soc_dapm_disable_pin(&codec->dapm, "EPOUT");
+		snd_soc_dapm_enable_pin_locked(&codec->dapm, "Headphones");
+		snd_soc_dapm_disable_pin_locked(&codec->dapm, "EPOUT");
 	} else {
-		snd_soc_dapm_disable_pin(&codec->dapm, "Headphones");
-		snd_soc_dapm_enable_pin(&codec->dapm, "EPOUT");
+		snd_soc_dapm_disable_pin_locked(&codec->dapm, "Headphones");
+		snd_soc_dapm_enable_pin_locked(&codec->dapm, "EPOUT");
 	}
+
+	mutex_unlock(&codec->dapm.card->dapm_mutex);
 }
 
 static int lo_get_switch(struct snd_kcontrol *kcontrol,
@@ -156,6 +165,9 @@ static int lo_set_switch(struct snd_kcontrol *kcontrol,
 	 * pins and then disable pins not required
 	 */
 	lo_enable_out_pins(codec);
+
+	mutex_lock(&codec->dapm.card->dapm_mutex);
+
 	switch (ucontrol->value.integer.value[0]) {
 	case 0:
 		pr_debug("set vibra path\n");
@@ -185,6 +197,9 @@ static int lo_set_switch(struct snd_kcontrol *kcontrol,
 		snd_soc_update_bits(codec, SN95031_LOCTL, 0x66, 0x66);
 		break;
 	}
+
+	mutex_unlock(&codec->dapm.card->dapm_mutex);
+
 	snd_soc_dapm_sync(&codec->dapm);
 	lo_dac = ucontrol->value.integer.value[0];
 	return 0;
-- 
1.7.2.5

