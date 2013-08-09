Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030251Ab3HIGW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:22:27 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59811 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967388Ab3HIGWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:22:25 -0400
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: alsa-devel@alsa-project.org
Cc: "Felipe F. Tonello" <eu@felipetonello.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] ALSA: Added jack detection KControl support
Date: Thu,  8 Aug 2013 23:21:55 -0700
Message-Id: <1376029315-3217-1-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375430365-13232-2-git-send-email-eu@felipetonello.com>
References: <1375430365-13232-2-git-send-email-eu@felipetonello.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

This patch adds jack support for ALSA KControl.

This support is necessary since the new kcontrol is used by user-space
daemons, such as PulseAudio(>=2.0), to do jack detection.)

Also, HDA's CONFIG_SND_HDA_INPUT_JACK is disabled because it causes to use standard
snd_jack_new() to create jacks. This can cause conflict since this codec creates
jack controls directly.

It makes sure that all codecs using ALSA jack API are updated to use the new
API.

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
---
 include/sound/control.h            |  2 +-
 include/sound/jack.h               |  8 ++--
 include/sound/soc.h                |  2 +-
 sound/core/Kconfig                 |  1 +
 sound/core/ctljack.c               |  3 +-
 sound/core/jack.c                  | 88 +++++++++++++++++++++++++++++++++++---
 sound/pci/hda/Kconfig              |  8 ----
 sound/pci/oxygen/xonar_wm87x6.c    |  2 +-
 sound/soc/fsl/wm1133-ev1.c         |  4 +-
 sound/soc/mid-x86/mfld_machine.c   |  4 +-
 sound/soc/omap/ams-delta.c         |  2 +-
 sound/soc/omap/omap-abe-twl6040.c  |  2 +-
 sound/soc/omap/omap-twl4030.c      |  2 +-
 sound/soc/omap/rx51.c              |  4 +-
 sound/soc/pxa/hx4700.c             |  2 +-
 sound/soc/pxa/palm27x.c            |  2 +-
 sound/soc/pxa/ttc-dkb.c            |  6 +--
 sound/soc/pxa/z2.c                 |  2 +-
 sound/soc/samsung/goni_wm8994.c    |  5 ++-
 sound/soc/samsung/h1940_uda1380.c  |  2 +-
 sound/soc/samsung/littlemill.c     | 10 ++---
 sound/soc/samsung/lowland.c        |  6 +--
 sound/soc/samsung/rx1950_uda1380.c |  2 +-
 sound/soc/samsung/smartq_wm8987.c  |  2 +-
 sound/soc/samsung/speyside.c       |  6 +--
 sound/soc/samsung/tobermory.c      |  4 +-
 sound/soc/soc-jack.c               |  5 ++-
 sound/soc/tegra/tegra_alc5632.c    |  2 +-
 sound/soc/tegra/tegra_rt5640.c     |  2 +-
 sound/soc/tegra/tegra_wm8903.c     |  4 +-
 30 files changed, 135 insertions(+), 59 deletions(-)

diff --git a/include/sound/control.h b/include/sound/control.h
index 5358892..ffeb6b6 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -242,6 +242,6 @@ void snd_ctl_sync_vmaster(struct snd_kcontrol *kctl, bool hook_only);
 struct snd_kcontrol *
 snd_kctl_jack_new(const char *name, int idx, void *private_data);
 void snd_kctl_jack_report(struct snd_card *card,
-			  struct snd_kcontrol *kctl, bool status);
+                          struct snd_kcontrol *kctl, bool status);
 
 #endif	/* __SOUND_CONTROL_H */
diff --git a/include/sound/jack.h b/include/sound/jack.h
index 5891657..0d36f20 100644
--- a/include/sound/jack.h
+++ b/include/sound/jack.h
@@ -26,6 +26,7 @@
 #include <sound/core.h>
 
 struct input_dev;
+struct snd_kcontrol;
 
 /**
  * Jack types which can be reported.  These values are used as a
@@ -58,11 +59,12 @@ enum snd_jack_types {
 
 struct snd_jack {
 	struct input_dev *input_dev;
+	struct snd_kcontrol *kctl[SND_JACK_SWITCH_TYPES]; /* control for each key */
 	int registered;
 	int type;
 	const char *id;
 	char name[100];
-	unsigned int key[6];   /* Keep in sync with definitions above */
+	unsigned int key[SND_JACK_SWITCH_TYPES];   /* Keep in sync with definitions above */
 	void *private_data;
 	void (*private_free)(struct snd_jack *);
 };
@@ -70,7 +72,7 @@ struct snd_jack {
 #ifdef CONFIG_SND_JACK
 
 int snd_jack_new(struct snd_card *card, const char *id, int type,
-		 struct snd_jack **jack);
+                 int idx, struct snd_jack **jack);
 void snd_jack_set_parent(struct snd_jack *jack, struct device *parent);
 int snd_jack_set_key(struct snd_jack *jack, enum snd_jack_types type,
 		     int keytype);
@@ -80,7 +82,7 @@ void snd_jack_report(struct snd_jack *jack, int status);
 #else
 
 static inline int snd_jack_new(struct snd_card *card, const char *id, int type,
-			       struct snd_jack **jack)
+                               int idx, struct snd_jack **jack)
 {
 	return 0;
 }
diff --git a/include/sound/soc.h b/include/sound/soc.h
index 6eabee7..31bea52 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -436,7 +436,7 @@ int snd_soc_platform_trigger(struct snd_pcm_substream *substream,
 
 /* Jack reporting */
 int snd_soc_jack_new(struct snd_soc_codec *codec, const char *id, int type,
-		     struct snd_soc_jack *jack);
+                     int idx, struct snd_soc_jack *jack);
 void snd_soc_jack_report(struct snd_soc_jack *jack, int status, int mask);
 int snd_soc_jack_add_pins(struct snd_soc_jack *jack, int count,
 			  struct snd_soc_jack_pin *pins);
diff --git a/sound/core/Kconfig b/sound/core/Kconfig
index c0c2f57..8167615 100644
--- a/sound/core/Kconfig
+++ b/sound/core/Kconfig
@@ -20,6 +20,7 @@ config SND_COMPRESS_OFFLOAD
 # to avoid having to force INPUT on.
 config SND_JACK
 	bool
+	select SND_KCTL_JACK
 
 config SND_SEQUENCER
 	tristate "Sequencer support"
diff --git a/sound/core/ctljack.c b/sound/core/ctljack.c
index e4b38fb..441158d 100644
--- a/sound/core/ctljack.c
+++ b/sound/core/ctljack.c
@@ -14,7 +14,7 @@
 #include <sound/core.h>
 #include <sound/control.h>
 
-#define jack_detect_kctl_info	snd_ctl_boolean_mono_info
+#define	jack_detect_kctl_info	snd_ctl_boolean_mono_info
 
 static int jack_detect_kctl_get(struct snd_kcontrol *kcontrol,
 				struct snd_ctl_elem_value *ucontrol)
@@ -38,6 +38,7 @@ snd_kctl_jack_new(const char *name, int idx, void *private_data)
 	kctl = snd_ctl_new1(&jack_detect_kctl, private_data);
 	if (!kctl)
 		return NULL;
+
 	snprintf(kctl->id.name, sizeof(kctl->id.name), "%s Jack", name);
 	kctl->id.index = idx;
 	kctl->private_value = 0;
diff --git a/sound/core/jack.c b/sound/core/jack.c
index b35fe73..128154b 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <sound/jack.h>
 #include <sound/core.h>
+#include <sound/control.h>
 
 static int jack_switch_types[SND_JACK_SWITCH_TYPES] = {
 	SW_HEADPHONE_INSERT,
@@ -37,6 +38,7 @@ static int jack_switch_types[SND_JACK_SWITCH_TYPES] = {
 static int snd_jack_dev_free(struct snd_device *device)
 {
 	struct snd_jack *jack = device->device_data;
+	int i;
 
 	if (jack->private_free)
 		jack->private_free(jack);
@@ -48,19 +50,54 @@ static int snd_jack_dev_free(struct snd_device *device)
 	else
 		input_free_device(jack->input_dev);
 
+	/* Free available KControls*/
+	for (i = 0; i < SND_JACK_SWITCH_TYPES; ++i)
+		if (jack->kctl[i])
+			snd_ctl_remove(device->card, jack->kctl[i]);
+
 	kfree(jack->id);
 	kfree(jack);
 
 	return 0;
 }
 
+const char * jack_get_name_by_key(const char *name, int key)
+{
+	char *jack_name;
+	size_t jack_name_size;
+	const char *key_name;
+
+	switch(key) {
+	case SW_HEADPHONE_INSERT: key_name = "Headphone"; break;
+	case SW_MICROPHONE_INSERT: key_name = "Mic"; break;
+	case SW_LINEOUT_INSERT: key_name = "Line Out"; break;
+	case SW_JACK_PHYSICAL_INSERT: key_name = "Mechanical"; break;
+	case SW_VIDEOOUT_INSERT: key_name = "Video Out"; break;
+	case SW_LINEIN_INSERT: key_name = "Line In"; break;
+	default: key_name = "Unknown";
+	}
+
+	/* Avoid duplicate name in KControl */
+	if (strcmp(name, key_name) != 0) {
+		/* allocate necessary memory space only */
+		jack_name_size = strlen(name) + strlen(key_name) + 4;
+		jack_name = kmalloc(jack_name_size, GFP_KERNEL);
+
+		snprintf(jack_name, jack_name_size, "%s (%s)", name, key_name);
+	} else {
+		jack_name = (char *)name;
+	}
+
+	return jack_name;
+}
+
 static int snd_jack_dev_register(struct snd_device *device)
 {
 	struct snd_jack *jack = device->device_data;
 	struct snd_card *card = device->card;
 	int err, i;
 
-	snprintf(jack->name, sizeof(jack->name), "%s %s",
+	snprintf(jack->name, sizeof(jack->name), "%s %s Jack",
 		 card->shortname, jack->id);
 	jack->input_dev->name = jack->name;
 
@@ -81,6 +118,18 @@ static int snd_jack_dev_register(struct snd_device *device)
 		input_set_capability(jack->input_dev, EV_KEY, jack->key[i]);
 	}
 
+	/* We don't need to free the control, it's freed by snd_ctl_add itself
+	   if an error occur */
+	for (i = 0; i < SND_JACK_SWITCH_TYPES; ++i)
+		if (jack->kctl[i]) {
+			err = snd_ctl_add(card, jack->kctl[i]);
+			if (err < 0) {
+				pr_notice("%s: ALSA Jack Control not available for '%s'\n", __func__,
+				          jack_get_name_by_key(jack->id, jack_switch_types[i]));
+				jack->kctl[i] = NULL;
+			}
+		}
+
 	err = input_register_device(jack->input_dev);
 	if (err == 0)
 		jack->registered = 1;
@@ -91,22 +140,31 @@ static int snd_jack_dev_register(struct snd_device *device)
 /**
  * snd_jack_new - Create a new jack
  * @card:  the card instance
- * @id:    an identifying string for this jack
+ * @id:    an identifying string for this jack, " Jack" is appended to the
+ *         string
  * @type:  a bitmask of enum snd_jack_type values that can be detected by
  *         this jack
+ * @idx:   The index of the ALSA control created to represent the jack.
  * @jjack: Used to provide the allocated jack object to the caller.
  *
  * Creates a new jack object.
  *
+ * This function creates a Jack Kcontrol for each @type id as "@id @type Jack".
+ * Eg.: A jack with @type SND_JACK_HEADSET will have two KControls created,
+ * "@id Headphone Jack" and "@id Mic Jack". If @id and @type strings are
+ * equals, then this KControl will be named "@id Jack" only.
+ *
  * Return: Zero if successful, or a negative error code on failure.
  * On success @jjack will be initialised.
  */
 int snd_jack_new(struct snd_card *card, const char *id, int type,
-		 struct snd_jack **jjack)
+                 int idx, struct snd_jack **jjack)
 {
 	struct snd_jack *jack;
+	struct snd_kcontrol *kctl;
 	int err;
 	int i;
+
 	static struct snd_device_ops ops = {
 		.dev_free = snd_jack_dev_free,
 		.dev_register = snd_jack_dev_register,
@@ -129,10 +187,20 @@ int snd_jack_new(struct snd_card *card, const char *id, int type,
 	jack->type = type;
 
 	for (i = 0; i < SND_JACK_SWITCH_TYPES; i++)
-		if (type & (1 << i))
+		if (type & (1 << i)) {
 			input_set_capability(jack->input_dev, EV_SW,
 					     jack_switch_types[i]);
 
+			/* card is the private_data */
+			kctl = snd_kctl_jack_new(jack_get_name_by_key(id, jack_switch_types[i]), idx, card);
+			if (!kctl) {
+				err = -ENOMEM;
+				goto fail_kctl;
+			}
+
+			jack->kctl[i] = kctl;
+		}
+
 	err = snd_device_new(card, SNDRV_DEV_JACK, jack, &ops);
 	if (err < 0)
 		goto fail_input;
@@ -141,6 +209,11 @@ int snd_jack_new(struct snd_card *card, const char *id, int type,
 
 	return 0;
 
+fail_kctl:
+	for (i = 0; i < SND_JACK_SWITCH_TYPES; ++i)
+		if (jack->kctl[i])
+			snd_ctl_remove(card, jack->kctl[i]);
+
 fail_input:
 	input_free_device(jack->input_dev);
 	kfree(jack->id);
@@ -232,10 +305,15 @@ void snd_jack_report(struct snd_jack *jack, int status)
 
 	for (i = 0; i < ARRAY_SIZE(jack_switch_types); i++) {
 		int testbit = 1 << i;
-		if (jack->type & testbit)
+		if (jack->type & testbit) {
 			input_report_switch(jack->input_dev,
 					    jack_switch_types[i],
 					    status & testbit);
+
+			/* Update ALSA KControl interface */
+			snd_kctl_jack_report((struct snd_card *)jack->kctl[i]->private_data,
+			                     jack->kctl[i], status & testbit);
+		}
 	}
 
 	input_sync(jack->input_dev);
diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
index 59c5e9c..561abc7 100644
--- a/sound/pci/hda/Kconfig
+++ b/sound/pci/hda/Kconfig
@@ -65,14 +65,6 @@ config SND_HDA_INPUT_BEEP_MODE
 	  Set 1 to always enable the digital beep interface for HD-audio by
 	  default.
 
-config SND_HDA_INPUT_JACK
-	bool "Support jack plugging notification via input layer"
-	depends on INPUT=y || INPUT=SND
-	select SND_JACK
-	help
-	  Say Y here to enable the jack plugging notification via
-	  input layer.
-
 config SND_HDA_PATCH_LOADER
 	bool "Support initialization patch loading for HD-audio"
 	select FW_LOADER
diff --git a/sound/pci/oxygen/xonar_wm87x6.c b/sound/pci/oxygen/xonar_wm87x6.c
index 6ce6860..d3816b1 100644
--- a/sound/pci/oxygen/xonar_wm87x6.c
+++ b/sound/pci/oxygen/xonar_wm87x6.c
@@ -286,7 +286,7 @@ static void xonar_ds_init(struct oxygen *chip)
 	xonar_enable_output(chip);
 
 	snd_jack_new(chip->card, "Headphone",
-		     SND_JACK_HEADPHONE, &data->hp_jack);
+	             SND_JACK_HEADPHONE, 0, &data->hp_jack);
 	xonar_ds_handle_hp_jack(chip);
 
 	snd_component_add(chip->card, "WM8776");
diff --git a/sound/soc/fsl/wm1133-ev1.c b/sound/soc/fsl/wm1133-ev1.c
index fce6325..50f96d4 100644
--- a/sound/soc/fsl/wm1133-ev1.c
+++ b/sound/soc/fsl/wm1133-ev1.c
@@ -221,14 +221,14 @@ static int wm1133_ev1_init(struct snd_soc_pcm_runtime *rtd)
 				ARRAY_SIZE(wm1133_ev1_map));
 
 	/* Headphone jack detection */
-	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE, &hp_jack);
+	snd_soc_jack_new(codec, "Headphone", SND_JACK_HEADPHONE, 0, &hp_jack);
 	snd_soc_jack_add_pins(&hp_jack, ARRAY_SIZE(hp_jack_pins),
 			      hp_jack_pins);
 	wm8350_hp_jack_detect(codec, WM8350_JDR, &hp_jack, SND_JACK_HEADPHONE);
 
 	/* Microphone jack detection */
 	snd_soc_jack_new(codec, "Microphone",
-			 SND_JACK_MICROPHONE | SND_JACK_BTN_0, &mic_jack);
+	                 SND_JACK_MICROPHONE | SND_JACK_BTN_0, 0, &mic_jack);
 	snd_soc_jack_add_pins(&mic_jack, ARRAY_SIZE(mic_jack_pins),
 			      mic_jack_pins);
 	wm8350_mic_jack_detect(codec, &mic_jack, SND_JACK_MICROPHONE,
diff --git a/sound/soc/mid-x86/mfld_machine.c b/sound/soc/mid-x86/mfld_machine.c
index ee36384..e52c836 100644
--- a/sound/soc/mid-x86/mfld_machine.c
+++ b/sound/soc/mid-x86/mfld_machine.c
@@ -254,8 +254,8 @@ static int mfld_init(struct snd_soc_pcm_runtime *runtime)
 
 	/* Headset and button jack detection */
 	ret_val = snd_soc_jack_new(codec, "Intel(R) MID Audio Jack",
-			SND_JACK_HEADSET | SND_JACK_BTN_0 |
-			SND_JACK_BTN_1, &mfld_jack);
+	                           SND_JACK_HEADSET | SND_JACK_BTN_0 |
+	                           SND_JACK_BTN_1, 0, &mfld_jack);
 	if (ret_val) {
 		pr_err("jack creation failed\n");
 		return ret_val;
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index 6294464..4ffa38e 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -491,7 +491,7 @@ static int ams_delta_cx20442_init(struct snd_soc_pcm_runtime *rtd)
 	/* Add hook switch - can be used to control the codec from userspace
 	 * even if line discipline fails */
 	ret = snd_soc_jack_new(rtd->codec, "hook_switch",
-				SND_JACK_HEADSET, &ams_delta_hook_switch);
+	                       SND_JACK_HEADSET, 0, &ams_delta_hook_switch);
 	if (ret)
 		dev_warn(card->dev,
 				"Failed to allocate resources for hook switch, "
diff --git a/sound/soc/omap/omap-abe-twl6040.c b/sound/soc/omap/omap-abe-twl6040.c
index 70cd5c7..a63038b 100644
--- a/sound/soc/omap/omap-abe-twl6040.c
+++ b/sound/soc/omap/omap-abe-twl6040.c
@@ -194,7 +194,7 @@ static int omap_abe_twl6040_init(struct snd_soc_pcm_runtime *rtd)
 	/* Headset jack detection only if it is supported */
 	if (priv->jack_detection) {
 		ret = snd_soc_jack_new(codec, "Headset Jack",
-					SND_JACK_HEADSET, &hs_jack);
+		                       SND_JACK_HEADSET, 0, &hs_jack);
 		if (ret)
 			return ret;
 
diff --git a/sound/soc/omap/omap-twl4030.c b/sound/soc/omap/omap-twl4030.c
index 2a9324f..07ba4d3 100644
--- a/sound/soc/omap/omap-twl4030.c
+++ b/sound/soc/omap/omap-twl4030.c
@@ -190,7 +190,7 @@ static int omap_twl4030_init(struct snd_soc_pcm_runtime *rtd)
 		hs_jack_gpios[0].gpio = priv->jack_detect;
 
 		ret = snd_soc_jack_new(codec, "Headset Jack", SND_JACK_HEADSET,
-				       &priv->hs_jack);
+		                       0, &priv->hs_jack);
 		if (ret)
 			return ret;
 
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 611179c..2cec19a 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -318,8 +318,8 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* AV jack detection */
 	err = snd_soc_jack_new(codec, "AV Jack",
-			       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
-			       &rx51_av_jack);
+	                       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
+	                       0, &rx51_av_jack);
 	if (err)
 		return err;
 	err = snd_soc_jack_add_gpios(&rx51_av_jack,
diff --git a/sound/soc/pxa/hx4700.c b/sound/soc/pxa/hx4700.c
index dcc9b04..82fd557 100644
--- a/sound/soc/pxa/hx4700.c
+++ b/sound/soc/pxa/hx4700.c
@@ -138,7 +138,7 @@ static int hx4700_ak4641_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* Jack detection API stuff */
 	err = snd_soc_jack_new(codec, "Headphone Jack",
-				SND_JACK_HEADPHONE, &hs_jack);
+	                       SND_JACK_HEADPHONE, 0, &hs_jack);
 	if (err)
 		return err;
 
diff --git a/sound/soc/pxa/palm27x.c b/sound/soc/pxa/palm27x.c
index e1ffcdd..264be5e 100644
--- a/sound/soc/pxa/palm27x.c
+++ b/sound/soc/pxa/palm27x.c
@@ -98,7 +98,7 @@ static int palm27x_ac97_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* Jack detection API stuff */
 	err = snd_soc_jack_new(codec, "Headphone Jack",
-				SND_JACK_HEADPHONE, &hs_jack);
+	                       SND_JACK_HEADPHONE, 0, &hs_jack);
 	if (err)
 		return err;
 
diff --git a/sound/soc/pxa/ttc-dkb.c b/sound/soc/pxa/ttc-dkb.c
index f4ea4f6..1a462cb 100644
--- a/sound/soc/pxa/ttc-dkb.c
+++ b/sound/soc/pxa/ttc-dkb.c
@@ -87,12 +87,12 @@ static int ttc_pm860x_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* Headset jack detection */
 	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE
-			| SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2,
-			&hs_jack);
+	                 | SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2,
+	                 0, &hs_jack);
 	snd_soc_jack_add_pins(&hs_jack, ARRAY_SIZE(hs_jack_pins),
 			      hs_jack_pins);
 	snd_soc_jack_new(codec, "Microphone Jack", SND_JACK_MICROPHONE,
-			 &mic_jack);
+	                 0, &mic_jack);
 	snd_soc_jack_add_pins(&mic_jack, ARRAY_SIZE(mic_jack_pins),
 			      mic_jack_pins);
 
diff --git a/sound/soc/pxa/z2.c b/sound/soc/pxa/z2.c
index 76ccb17..082fd24 100644
--- a/sound/soc/pxa/z2.c
+++ b/sound/soc/pxa/z2.c
@@ -144,7 +144,7 @@ static int z2_wm8750_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* Jack detection API stuff */
 	ret = snd_soc_jack_new(codec, "Headset Jack", SND_JACK_HEADSET,
-				&hs_jack);
+	                       0, &hs_jack);
 	if (ret)
 		goto err;
 
diff --git a/sound/soc/samsung/goni_wm8994.c b/sound/soc/samsung/goni_wm8994.c
index 415ad81..bdd70a9 100644
--- a/sound/soc/samsung/goni_wm8994.c
+++ b/sound/soc/samsung/goni_wm8994.c
@@ -115,8 +115,9 @@ static int goni_wm8994_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* Headset jack detection */
 	ret = snd_soc_jack_new(codec, "Headset Jack",
-			SND_JACK_HEADSET | SND_JACK_MECHANICAL | SND_JACK_AVOUT,
-			&jack);
+	                       SND_JACK_HEADSET | SND_JACK_MECHANICAL |
+	                       SND_JACK_AVOUT,
+	                       0, &jack);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/samsung/h1940_uda1380.c b/sound/soc/samsung/h1940_uda1380.c
index fa91376..66b5a33 100644
--- a/sound/soc/samsung/h1940_uda1380.c
+++ b/sound/soc/samsung/h1940_uda1380.c
@@ -187,7 +187,7 @@ static int h1940_uda1380_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_enable_pin(dapm, "Mic Jack");
 
 	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE,
-		&hp_jack);
+	                 0, &hp_jack);
 
 	snd_soc_jack_add_pins(&hp_jack, ARRAY_SIZE(hp_jack_pins),
 		hp_jack_pins);
diff --git a/sound/soc/samsung/littlemill.c b/sound/soc/samsung/littlemill.c
index bfb91f3..46344f3 100644
--- a/sound/soc/samsung/littlemill.c
+++ b/sound/soc/samsung/littlemill.c
@@ -261,11 +261,11 @@ static int littlemill_late_probe(struct snd_soc_card *card)
 		return ret;
 
 	ret = snd_soc_jack_new(codec, "Headset",
-			       SND_JACK_HEADSET | SND_JACK_MECHANICAL |
-			       SND_JACK_BTN_0 | SND_JACK_BTN_1 |
-			       SND_JACK_BTN_2 | SND_JACK_BTN_3 |
-			       SND_JACK_BTN_4 | SND_JACK_BTN_5,
-			       &littlemill_headset);
+	                       SND_JACK_HEADSET | SND_JACK_MECHANICAL |
+	                       SND_JACK_BTN_0 | SND_JACK_BTN_1 |
+	                       SND_JACK_BTN_2 | SND_JACK_BTN_3 |
+	                       SND_JACK_BTN_4 | SND_JACK_BTN_5,
+	                       0, &littlemill_headset);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/samsung/lowland.c b/sound/soc/samsung/lowland.c
index 570cf52..1e6a3df 100644
--- a/sound/soc/samsung/lowland.c
+++ b/sound/soc/samsung/lowland.c
@@ -57,9 +57,9 @@ static int lowland_wm5100_init(struct snd_soc_pcm_runtime *rtd)
 	}
 
 	ret = snd_soc_jack_new(codec, "Headset",
-			       SND_JACK_LINEOUT | SND_JACK_HEADSET |
-			       SND_JACK_BTN_0,
-			       &lowland_headset);
+	                       SND_JACK_LINEOUT | SND_JACK_HEADSET |
+	                       SND_JACK_BTN_0,
+	                       0, &lowland_headset);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/samsung/rx1950_uda1380.c b/sound/soc/samsung/rx1950_uda1380.c
index 704460a..588ad72 100644
--- a/sound/soc/samsung/rx1950_uda1380.c
+++ b/sound/soc/samsung/rx1950_uda1380.c
@@ -232,7 +232,7 @@ static int rx1950_uda1380_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_enable_pin(dapm, "Mic Jack");
 
 	snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE,
-		&hp_jack);
+	                 0, &hp_jack);
 
 	snd_soc_jack_add_pins(&hp_jack, ARRAY_SIZE(hp_jack_pins),
 		hp_jack_pins);
diff --git a/sound/soc/samsung/smartq_wm8987.c b/sound/soc/samsung/smartq_wm8987.c
index 58ae323..71a17a5 100644
--- a/sound/soc/samsung/smartq_wm8987.c
+++ b/sound/soc/samsung/smartq_wm8987.c
@@ -167,7 +167,7 @@ static int smartq_wm8987_init(struct snd_soc_pcm_runtime *rtd)
 
 	/* Headphone jack detection */
 	err = snd_soc_jack_new(codec, "Headphone Jack",
-			       SND_JACK_HEADPHONE, &smartq_jack);
+	                       SND_JACK_HEADPHONE, 0, &smartq_jack);
 	if (err)
 		return err;
 
diff --git a/sound/soc/samsung/speyside.c b/sound/soc/samsung/speyside.c
index 57df90d..feff3fb 100644
--- a/sound/soc/samsung/speyside.c
+++ b/sound/soc/samsung/speyside.c
@@ -154,9 +154,9 @@ static int speyside_wm8996_init(struct snd_soc_pcm_runtime *rtd)
 	gpio_direction_output(WM8996_HPSEL_GPIO, speyside_jack_polarity);
 
 	ret = snd_soc_jack_new(codec, "Headset",
-			       SND_JACK_LINEOUT | SND_JACK_HEADSET |
-			       SND_JACK_BTN_0,
-			       &speyside_headset);
+	                       SND_JACK_LINEOUT | SND_JACK_HEADSET |
+	                       SND_JACK_BTN_0,
+	                       0, &speyside_headset);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/samsung/tobermory.c b/sound/soc/samsung/tobermory.c
index f21ff60..e498e7c 100644
--- a/sound/soc/samsung/tobermory.c
+++ b/sound/soc/samsung/tobermory.c
@@ -178,8 +178,8 @@ static int tobermory_late_probe(struct snd_soc_card *card)
 		return ret;
 
 	ret = snd_soc_jack_new(codec, "Headset",
-			       SND_JACK_HEADSET | SND_JACK_BTN_0,
-			       &tobermory_headset);
+	                       SND_JACK_HEADSET | SND_JACK_BTN_0,
+	                       0, &tobermory_headset);
 	if (ret)
 		return ret;
 
diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index 0bb5ccc..3275ab9 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -26,6 +26,7 @@
  * @id:    an identifying string for this jack
  * @type:  a bitmask of enum snd_jack_type values that can be detected by
  *         this jack
+ * @idx:   The index of the ALSA control created to represent the jack.
  * @jack:  structure to use for the jack
  *
  * Creates a new jack object.
@@ -34,7 +35,7 @@
  * On success jack will be initialised.
  */
 int snd_soc_jack_new(struct snd_soc_codec *codec, const char *id, int type,
-		     struct snd_soc_jack *jack)
+                     int idx, struct snd_soc_jack *jack)
 {
 	mutex_init(&jack->mutex);
 	jack->codec = codec;
@@ -42,7 +43,7 @@ int snd_soc_jack_new(struct snd_soc_codec *codec, const char *id, int type,
 	INIT_LIST_HEAD(&jack->jack_zones);
 	BLOCKING_INIT_NOTIFIER_HEAD(&jack->notifier);
 
-	return snd_jack_new(codec->card->snd_card, id, type, &jack->jack);
+	return snd_jack_new(codec->card->snd_card, id, type, idx, &jack->jack);
 }
 EXPORT_SYMBOL_GPL(snd_soc_jack_new);
 
diff --git a/sound/soc/tegra/tegra_alc5632.c b/sound/soc/tegra/tegra_alc5632.c
index 48d05d9..1a44af9 100644
--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -110,7 +110,7 @@ static int tegra_alc5632_asoc_init(struct snd_soc_pcm_runtime *rtd)
 	struct tegra_alc5632 *machine = snd_soc_card_get_drvdata(codec->card);
 
 	snd_soc_jack_new(codec, "Headset Jack", SND_JACK_HEADSET,
-			 &tegra_alc5632_hs_jack);
+	                 0, &tegra_alc5632_hs_jack);
 	snd_soc_jack_add_pins(&tegra_alc5632_hs_jack,
 			ARRAY_SIZE(tegra_alc5632_hs_jack_pins),
 			tegra_alc5632_hs_jack_pins);
diff --git a/sound/soc/tegra/tegra_rt5640.c b/sound/soc/tegra/tegra_rt5640.c
index 08794f9..aad20f2 100644
--- a/sound/soc/tegra/tegra_rt5640.c
+++ b/sound/soc/tegra/tegra_rt5640.c
@@ -112,7 +112,7 @@ static int tegra_rt5640_asoc_init(struct snd_soc_pcm_runtime *rtd)
 	struct tegra_rt5640 *machine = snd_soc_card_get_drvdata(codec->card);
 
 	snd_soc_jack_new(codec, "Headphones", SND_JACK_HEADPHONE,
-			 &tegra_rt5640_hp_jack);
+	                 0, &tegra_rt5640_hp_jack);
 	snd_soc_jack_add_pins(&tegra_rt5640_hp_jack,
 			ARRAY_SIZE(tegra_rt5640_hp_jack_pins),
 			tegra_rt5640_hp_jack_pins);
diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index 4ac7373..3f38d31 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -179,7 +179,7 @@ static int tegra_wm8903_init(struct snd_soc_pcm_runtime *rtd)
 	if (gpio_is_valid(machine->gpio_hp_det)) {
 		tegra_wm8903_hp_jack_gpio.gpio = machine->gpio_hp_det;
 		snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE,
-				&tegra_wm8903_hp_jack);
+		                 0, &tegra_wm8903_hp_jack);
 		snd_soc_jack_add_pins(&tegra_wm8903_hp_jack,
 					ARRAY_SIZE(tegra_wm8903_hp_jack_pins),
 					tegra_wm8903_hp_jack_pins);
@@ -189,7 +189,7 @@ static int tegra_wm8903_init(struct snd_soc_pcm_runtime *rtd)
 	}
 
 	snd_soc_jack_new(codec, "Mic Jack", SND_JACK_MICROPHONE,
-			 &tegra_wm8903_mic_jack);
+	                 0, &tegra_wm8903_mic_jack);
 	snd_soc_jack_add_pins(&tegra_wm8903_mic_jack,
 			      ARRAY_SIZE(tegra_wm8903_mic_jack_pins),
 			      tegra_wm8903_mic_jack_pins);
-- 
1.8.3.1

