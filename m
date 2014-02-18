Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbaBRPdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:33:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50551 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756287AbaBRPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:30:59 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 10/17 v2] ASoC: mfld_machine: Update locking around use of DAPM pin API
Date: Tue, 18 Feb 2014 15:22:21 +0000
Message-Id: <1392736948-26623-11-git-send-email-ckeepax@opensource.wolfsonmicro.com>
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
 sound/soc/intel/mfld_machine.c |   65 +++++++++++++++++++++++++---------------
 1 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/sound/soc/intel/mfld_machine.c b/sound/soc/intel/mfld_machine.c
index d3d4c32..0cef32e 100644
--- a/sound/soc/intel/mfld_machine.c
+++ b/sound/soc/intel/mfld_machine.c
@@ -101,20 +101,27 @@ static int headset_set_switch(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec =  snd_kcontrol_chip(kcontrol);
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
 
 	if (ucontrol->value.integer.value[0] == hs_switch)
 		return 0;
 
+	snd_soc_dapm_mutex_lock(dapm);
+
 	if (ucontrol->value.integer.value[0]) {
 		pr_debug("hs_set HS path\n");
-		snd_soc_dapm_enable_pin(&codec->dapm, "Headphones");
-		snd_soc_dapm_disable_pin(&codec->dapm, "EPOUT");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Headphones");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "EPOUT");
 	} else {
 		pr_debug("hs_set EP path\n");
-		snd_soc_dapm_disable_pin(&codec->dapm, "Headphones");
-		snd_soc_dapm_enable_pin(&codec->dapm, "EPOUT");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headphones");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "EPOUT");
 	}
-	snd_soc_dapm_sync(&codec->dapm);
+
+	snd_soc_dapm_sync_unlocked(dapm);
+
+	snd_soc_dapm_mutex_unlock(dapm);
+
 	hs_switch = ucontrol->value.integer.value[0];
 
 	return 0;
@@ -122,18 +129,20 @@ static int headset_set_switch(struct snd_kcontrol *kcontrol,
 
 static void lo_enable_out_pins(struct snd_soc_codec *codec)
 {
-	snd_soc_dapm_enable_pin(&codec->dapm, "IHFOUTL");
-	snd_soc_dapm_enable_pin(&codec->dapm, "IHFOUTR");
-	snd_soc_dapm_enable_pin(&codec->dapm, "LINEOUTL");
-	snd_soc_dapm_enable_pin(&codec->dapm, "LINEOUTR");
-	snd_soc_dapm_enable_pin(&codec->dapm, "VIB1OUT");
-	snd_soc_dapm_enable_pin(&codec->dapm, "VIB2OUT");
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
+
+	snd_soc_dapm_enable_pin_unlocked(dapm, "IHFOUTL");
+	snd_soc_dapm_enable_pin_unlocked(dapm, "IHFOUTR");
+	snd_soc_dapm_enable_pin_unlocked(dapm, "LINEOUTL");
+	snd_soc_dapm_enable_pin_unlocked(dapm, "LINEOUTR");
+	snd_soc_dapm_enable_pin_unlocked(dapm, "VIB1OUT");
+	snd_soc_dapm_enable_pin_unlocked(dapm, "VIB2OUT");
 	if (hs_switch) {
-		snd_soc_dapm_enable_pin(&codec->dapm, "Headphones");
-		snd_soc_dapm_disable_pin(&codec->dapm, "EPOUT");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "Headphones");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "EPOUT");
 	} else {
-		snd_soc_dapm_disable_pin(&codec->dapm, "Headphones");
-		snd_soc_dapm_enable_pin(&codec->dapm, "EPOUT");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headphones");
+		snd_soc_dapm_enable_pin_unlocked(dapm, "EPOUT");
 	}
 }
 
@@ -148,44 +157,52 @@ static int lo_set_switch(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec =  snd_kcontrol_chip(kcontrol);
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
 
 	if (ucontrol->value.integer.value[0] == lo_dac)
 		return 0;
 
+	snd_soc_dapm_mutex_lock(dapm);
+
 	/* we dont want to work with last state of lineout so just enable all
 	 * pins and then disable pins not required
 	 */
 	lo_enable_out_pins(codec);
+
 	switch (ucontrol->value.integer.value[0]) {
 	case 0:
 		pr_debug("set vibra path\n");
-		snd_soc_dapm_disable_pin(&codec->dapm, "VIB1OUT");
-		snd_soc_dapm_disable_pin(&codec->dapm, "VIB2OUT");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "VIB1OUT");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "VIB2OUT");
 		snd_soc_update_bits(codec, SN95031_LOCTL, 0x66, 0);
 		break;
 
 	case 1:
 		pr_debug("set hs  path\n");
-		snd_soc_dapm_disable_pin(&codec->dapm, "Headphones");
-		snd_soc_dapm_disable_pin(&codec->dapm, "EPOUT");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Headphones");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "EPOUT");
 		snd_soc_update_bits(codec, SN95031_LOCTL, 0x66, 0x22);
 		break;
 
 	case 2:
 		pr_debug("set spkr path\n");
-		snd_soc_dapm_disable_pin(&codec->dapm, "IHFOUTL");
-		snd_soc_dapm_disable_pin(&codec->dapm, "IHFOUTR");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "IHFOUTL");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "IHFOUTR");
 		snd_soc_update_bits(codec, SN95031_LOCTL, 0x66, 0x44);
 		break;
 
 	case 3:
 		pr_debug("set null path\n");
-		snd_soc_dapm_disable_pin(&codec->dapm, "LINEOUTL");
-		snd_soc_dapm_disable_pin(&codec->dapm, "LINEOUTR");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "LINEOUTL");
+		snd_soc_dapm_disable_pin_unlocked(dapm, "LINEOUTR");
 		snd_soc_update_bits(codec, SN95031_LOCTL, 0x66, 0x66);
 		break;
 	}
-	snd_soc_dapm_sync(&codec->dapm);
+
+	snd_soc_dapm_sync_unlocked(dapm);
+
+	snd_soc_dapm_mutex_unlock(dapm);
+
 	lo_dac = ucontrol->value.integer.value[0];
 	return 0;
 }
-- 
1.7.2.5

