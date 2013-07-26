Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab3GZS0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:26:49 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:40588 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759281Ab3GZS0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:26:02 -0400
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        "Felipe F. Tonello" <eu@felipetonello.com>
Subject: [PATCH 2/4] ALSA: HDA: Updating jack implementation according new ALSA Jacks
Date: Fri, 26 Jul 2013 11:25:31 -0700
Message-Id: <1374863133-6745-3-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

ALSA standard jacks already are implemented using ALSA KControl. So there is
no need implement that itself or to use snd_jack for input events only.

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
---
 sound/pci/hda/Kconfig     |  8 --------
 sound/pci/hda/hda_codec.h |  2 --
 sound/pci/hda/hda_jack.c  | 38 +++++++++++++++++---------------------
 sound/pci/hda/hda_jack.h  |  4 +---
 4 files changed, 18 insertions(+), 34 deletions(-)

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
diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
index 701c2e0..ca7be59 100644
--- a/sound/pci/hda/hda_codec.h
+++ b/sound/pci/hda/hda_codec.h
@@ -912,10 +912,8 @@ struct hda_codec {
 	unsigned long jackpoll_interval; /* In jiffies. Zero means no poll, rely on unsol events */
 	struct delayed_work jackpoll_work;
 
-#ifdef CONFIG_SND_HDA_INPUT_JACK
 	/* jack detection */
 	struct snd_array jacks;
-#endif
 
 	/* fix-up list */
 	int fixup_id;
diff --git a/sound/pci/hda/hda_jack.c b/sound/pci/hda/hda_jack.c
index 3fd2973..6be1a0c 100644
--- a/sound/pci/hda/hda_jack.c
+++ b/sound/pci/hda/hda_jack.c
@@ -112,7 +112,6 @@ EXPORT_SYMBOL_HDA(snd_hda_jack_tbl_new);
 
 void snd_hda_jack_tbl_clear(struct hda_codec *codec)
 {
-#ifdef CONFIG_SND_HDA_INPUT_JACK
 	/* free jack instances manually when clearing/reconfiguring */
 	if (!codec->bus->shutdown && codec->jacktbl.list) {
 		struct hda_jack_tbl *jack = codec->jacktbl.list;
@@ -122,7 +121,6 @@ void snd_hda_jack_tbl_clear(struct hda_codec *codec)
 				snd_device_free(codec->bus->card, jack->jack);
 		}
 	}
-#endif
 	snd_array_free(&codec->jacktbl);
 }
 
@@ -283,17 +281,15 @@ void snd_hda_jack_report_sync(struct hda_codec *codec)
 			if (!jack->kctl)
 				continue;
 			state = get_jack_plug_state(jack->pin_sense);
-			snd_kctl_jack_report(codec->bus->card, jack->kctl, state);
-#ifdef CONFIG_SND_HDA_INPUT_JACK
-			if (jack->jack)
+			if (jack->phantom_jack)
+				snd_kctl_jack_report(codec->bus->card, jack->kctl, state);
+			else if (jack->jack)
 				snd_jack_report(jack->jack,
 						state ? jack->type : 0);
-#endif
 		}
 }
 EXPORT_SYMBOL_HDA(snd_hda_jack_report_sync);
 
-#ifdef CONFIG_SND_HDA_INPUT_JACK
 /* guess the jack type from the pin-config */
 static int get_input_jack_type(struct hda_codec *codec, hda_nid_t nid)
 {
@@ -320,7 +316,6 @@ static void hda_free_jack_priv(struct snd_jack *jack)
 	jacks->nid = 0;
 	jacks->jack = NULL;
 }
-#endif
 
 /**
  * snd_hda_jack_add_kctl - Add a kctl for the given pin
@@ -340,29 +335,30 @@ static int __snd_hda_jack_add_kctl(struct hda_codec *codec, hda_nid_t nid,
 		return 0;
 	if (jack->kctl)
 		return 0; /* already created */
-	kctl = snd_kctl_jack_new(name, idx, codec);
-	if (!kctl)
-		return -ENOMEM;
-	err = snd_hda_ctl_add(codec, nid, kctl);
-	if (err < 0)
-		return err;
-	jack->kctl = kctl;
+
 	jack->phantom_jack = !!phantom_jack;
 
-	state = snd_hda_jack_detect(codec, nid);
-	snd_kctl_jack_report(codec->bus->card, kctl, state);
-#ifdef CONFIG_SND_HDA_INPUT_JACK
-	if (!phantom_jack) {
+	/* If it's phantom jack only creates kcontrol jack elem */
+	if (jack->phantom_jack) {
+		kctl = snd_kctl_jack_new(name, idx, codec);
+		if (!kctl)
+			return -ENOMEM;
+		err = snd_hda_ctl_add(codec, nid, kctl);
+		if (err < 0)
+			return err;
+		jack->kctl = kctl;
+	} else {
+		state = snd_hda_jack_detect(codec, nid);
 		jack->type = get_input_jack_type(codec, nid);
 		err = snd_jack_new(codec->bus->card, name, jack->type,
-				   &jack->jack);
+		                   idx, &jack->jack);
 		if (err < 0)
 			return err;
+		jack->kctl = jack->jack->kctl;
 		jack->jack->private_data = jack;
 		jack->jack->private_free = hda_free_jack_priv;
 		snd_jack_report(jack->jack, state ? jack->type : 0);
 	}
-#endif
 	return 0;
 }
 
diff --git a/sound/pci/hda/hda_jack.h b/sound/pci/hda/hda_jack.h
index ec12abd..d4701d2 100644
--- a/sound/pci/hda/hda_jack.h
+++ b/sound/pci/hda/hda_jack.h
@@ -30,11 +30,9 @@ struct hda_jack_tbl {
 	unsigned int phantom_jack:1;    /* a fixed, always present port? */
 	hda_nid_t gating_jack;		/* valid when gating jack plugged */
 	hda_nid_t gated_jack;		/* gated is dependent on this jack */
-	struct snd_kcontrol *kctl;	/* assigned kctl for jack-detection */
-#ifdef CONFIG_SND_HDA_INPUT_JACK
+	struct snd_kcontrol *kctl;      /* assigned kctl for jack-detection */
 	int type;
 	struct snd_jack *jack;
-#endif
 };
 
 struct hda_jack_tbl *
-- 
1.8.1.4

