Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbaDBUNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:13:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42799 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758799AbaDBUN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 01/40] ALSA: hda - Fix inconsistent Mic mute LED
Date: Wed,  2 Apr 2014 22:12:47 +0200
Message-Id: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7fe307117db5bd7ec6efb93c563dcf44577b6d2b upstream.

The current code for controlling mic mute LED in patch_sigmatel.c
blindly assumes that there is a single capture switch.  But, there can
be multiple multiple ones, and each of them flips the state, ended up
in an inconsistent state.

For fixing this problem, this patch adds kcontrol to be passed to the
hook function so that the callee can check which switch is being
accessed.  In stac_capture_led_hook(), the state is checked as a
bitmask, and turns on the LED when all capture switches are off.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/hda_generic.c    |  8 ++++----
 sound/pci/hda/hda_generic.h    |  1 +
 sound/pci/hda/patch_conexant.c |  3 ++-
 sound/pci/hda/patch_realtek.c  |  9 ++++++---
 sound/pci/hda/patch_sigmatel.c | 27 +++++++++++++++++----------
 5 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 7d4ccfa48008..31da88bf6c1c 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -3264,7 +3264,7 @@ static int cap_put_caller(struct snd_kcontrol *kcontrol,
 	mutex_unlock(&codec->control_mutex);
 	snd_hda_codec_flush_cache(codec); /* flush the updates */
 	if (err >= 0 && spec->cap_sync_hook)
-		spec->cap_sync_hook(codec, ucontrol);
+		spec->cap_sync_hook(codec, kcontrol, ucontrol);
 	return err;
 }
 
@@ -3385,7 +3385,7 @@ static int cap_single_sw_put(struct snd_kcontrol *kcontrol,
 		return ret;
 
 	if (spec->cap_sync_hook)
-		spec->cap_sync_hook(codec, ucontrol);
+		spec->cap_sync_hook(codec, kcontrol, ucontrol);
 
 	return ret;
 }
@@ -3790,7 +3790,7 @@ static int mux_select(struct hda_codec *codec, unsigned int adc_idx,
 		return 0;
 	snd_hda_activate_path(codec, path, true, false);
 	if (spec->cap_sync_hook)
-		spec->cap_sync_hook(codec, NULL);
+		spec->cap_sync_hook(codec, NULL, NULL);
 	path_power_down_sync(codec, old_path);
 	return 1;
 }
@@ -5233,7 +5233,7 @@ static void init_input_src(struct hda_codec *codec)
 	}
 
 	if (spec->cap_sync_hook)
-		spec->cap_sync_hook(codec, NULL);
+		spec->cap_sync_hook(codec, NULL, NULL);
 }
 
 /* set right pin controls for digital I/O */
diff --git a/sound/pci/hda/hda_generic.h b/sound/pci/hda/hda_generic.h
index 0929a06df812..a1095de808c8 100644
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -274,6 +274,7 @@ struct hda_gen_spec {
 	void (*init_hook)(struct hda_codec *codec);
 	void (*automute_hook)(struct hda_codec *codec);
 	void (*cap_sync_hook)(struct hda_codec *codec,
+			      struct snd_kcontrol *kcontrol,
 			      struct snd_ctl_elem_value *ucontrol);
 
 	/* PCM hooks */
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 96f07ce56603..fde381d02afd 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3282,7 +3282,8 @@ static void cxt_update_headset_mode(struct hda_codec *codec)
 }
 
 static void cxt_update_headset_mode_hook(struct hda_codec *codec,
-			     struct snd_ctl_elem_value *ucontrol)
+					 struct snd_kcontrol *kcontrol,
+					 struct snd_ctl_elem_value *ucontrol)
 {
 	cxt_update_headset_mode(codec);
 }
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index deddee9c1565..6a32c857f704 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -695,7 +695,8 @@ static void alc_inv_dmic_sync(struct hda_codec *codec, bool force)
 }
 
 static void alc_inv_dmic_hook(struct hda_codec *codec,
-			     struct snd_ctl_elem_value *ucontrol)
+			      struct snd_kcontrol *kcontrol,
+			      struct snd_ctl_elem_value *ucontrol)
 {
 	alc_inv_dmic_sync(codec, false);
 }
@@ -3141,7 +3142,8 @@ static void alc269_fixup_hp_gpio_mute_hook(void *private_data, int enabled)
 
 /* turn on/off mic-mute LED per capture hook */
 static void alc269_fixup_hp_gpio_mic_mute_hook(struct hda_codec *codec,
-			       struct snd_ctl_elem_value *ucontrol)
+					       struct snd_kcontrol *kcontrol,
+					       struct snd_ctl_elem_value *ucontrol)
 {
 	struct alc_spec *spec = codec->spec;
 	unsigned int oldval = spec->gpio_led;
@@ -3403,7 +3405,8 @@ static void alc_update_headset_mode(struct hda_codec *codec)
 }
 
 static void alc_update_headset_mode_hook(struct hda_codec *codec,
-			     struct snd_ctl_elem_value *ucontrol)
+					 struct snd_kcontrol *kcontrol,
+					 struct snd_ctl_elem_value *ucontrol)
 {
 	alc_update_headset_mode(codec);
 }
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 6133423821d1..d761c0b879c9 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -195,7 +195,7 @@ struct sigmatel_spec {
 	int default_polarity;
 
 	unsigned int mic_mute_led_gpio; /* capture mute LED GPIO */
-	bool mic_mute_led_on; /* current mic mute state */
+	unsigned int mic_enabled; /* current mic mute state (bitmask) */
 
 	/* stream */
 	unsigned int stream_delay;
@@ -325,19 +325,26 @@ static void stac_gpio_set(struct hda_codec *codec, unsigned int mask,
 
 /* hook for controlling mic-mute LED GPIO */
 static void stac_capture_led_hook(struct hda_codec *codec,
-			       struct snd_ctl_elem_value *ucontrol)
+				  struct snd_kcontrol *kcontrol,
+				  struct snd_ctl_elem_value *ucontrol)
 {
 	struct sigmatel_spec *spec = codec->spec;
-	bool mute;
+	unsigned int mask;
+	bool cur_mute, prev_mute;
 
-	if (!ucontrol)
+	if (!kcontrol || !ucontrol)
 		return;
 
-	mute = !(ucontrol->value.integer.value[0] ||
-		 ucontrol->value.integer.value[1]);
-	if (spec->mic_mute_led_on != mute) {
-		spec->mic_mute_led_on = mute;
-		if (mute)
+	mask = 1U << snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
+	prev_mute = !spec->mic_enabled;
+	if (ucontrol->value.integer.value[0] ||
+	    ucontrol->value.integer.value[1])
+		spec->mic_enabled |= mask;
+	else
+		spec->mic_enabled &= ~mask;
+	cur_mute = !spec->mic_enabled;
+	if (cur_mute != prev_mute) {
+		if (cur_mute)
 			spec->gpio_data |= spec->mic_mute_led_gpio;
 		else
 			spec->gpio_data &= ~spec->mic_mute_led_gpio;
@@ -3974,7 +3981,7 @@ static void stac_setup_gpio(struct hda_codec *codec)
 	if (spec->mic_mute_led_gpio) {
 		spec->gpio_mask |= spec->mic_mute_led_gpio;
 		spec->gpio_dir |= spec->mic_mute_led_gpio;
-		spec->mic_mute_led_on = true;
+		spec->mic_enabled = 0;
 		spec->gpio_data |= spec->mic_mute_led_gpio;
 
 		spec->gen.cap_sync_hook = stac_capture_led_hook;
-- 
1.9.1

