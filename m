Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab3GZS0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:26:04 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:37092 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3GZS0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:26:00 -0400
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        "Felipe F. Tonello" <eu@felipetonello.com>
Subject: [PATCH 1/4] ALSA: Added jack detection kcontrol support
Date: Fri, 26 Jul 2013 11:25:30 -0700
Message-Id: <1374863133-6745-2-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

This patch adds jack support for alsa kcontrol.

This support is necessary since the new kcontrol is used by user-space
daemons, such as PulseAudio(>=2.0), to do jack detection.)

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
---
 include/sound/jack.h |  6 ++++--
 sound/core/Kconfig   |  1 +
 sound/core/ctljack.c |  3 ++-
 sound/core/jack.c    | 29 +++++++++++++++++++++++++++--
 4 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/include/sound/jack.h b/include/sound/jack.h
index 5891657..dc62b74 100644
--- a/include/sound/jack.h
+++ b/include/sound/jack.h
@@ -26,6 +26,7 @@
 #include <sound/core.h>
 
 struct input_dev;
+struct snd_kcontrol;
 
 /**
  * Jack types which can be reported.  These values are used as a
@@ -58,6 +59,7 @@ enum snd_jack_types {
 
 struct snd_jack {
 	struct input_dev *input_dev;
+	struct snd_kcontrol *kctl;
 	int registered;
 	int type;
 	const char *id;
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
index e4b38fb..59aa6d0 100644
--- a/sound/core/ctljack.c
+++ b/sound/core/ctljack.c
@@ -38,7 +38,8 @@ snd_kctl_jack_new(const char *name, int idx, void *private_data)
 	kctl = snd_ctl_new1(&jack_detect_kctl, private_data);
 	if (!kctl)
 		return NULL;
-	snprintf(kctl->id.name, sizeof(kctl->id.name), "%s Jack", name);
+
+	strlcpy(kctl->id.name, name, sizeof(kctl->id.name));
 	kctl->id.index = idx;
 	kctl->private_value = 0;
 	return kctl;
diff --git a/sound/core/jack.c b/sound/core/jack.c
index b35fe73..b2757b1 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <sound/jack.h>
 #include <sound/core.h>
+#include <sound/control.h>
 
 static int jack_switch_types[SND_JACK_SWITCH_TYPES] = {
 	SW_HEADPHONE_INSERT,
@@ -48,6 +49,7 @@ static int snd_jack_dev_free(struct snd_device *device)
 	else
 		input_free_device(jack->input_dev);
 
+	snd_ctl_remove(device->card, jack->kctl);
 	kfree(jack->id);
 	kfree(jack);
 
@@ -85,26 +87,36 @@ static int snd_jack_dev_register(struct snd_device *device)
 	if (err == 0)
 		jack->registered = 1;
 
+	/* We don't need to free the control, it's freed by snd_ctl_add itself
+	   if an error occur */
+	err = snd_ctl_add(card, jack->kctl);
+
 	return err;
 }
 
 /**
  * snd_jack_new - Create a new jack
  * @card:  the card instance
- * @id:    an identifying string for this jack
+ * @id:    an identifying string for this jack, " Jack" is appended to the
+ *         string
  * @type:  a bitmask of enum snd_jack_type values that can be detected by
  *         this jack
+ * @idx:   index of this control item
  * @jjack: Used to provide the allocated jack object to the caller.
  *
  * Creates a new jack object.
  *
+ * This function creates a Jack Kcontrol, which is exported to user space via
+ * ALSA Controls.
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
 	static struct snd_device_ops ops = {
@@ -117,6 +129,7 @@ int snd_jack_new(struct snd_card *card, const char *id, int type,
 		return -ENOMEM;
 
 	jack->id = kstrdup(id, GFP_KERNEL);
+	sprintf((char *)jack->id, "%s Jack", jack->id);
 
 	jack->input_dev = input_allocate_device();
 	if (jack->input_dev == NULL) {
@@ -137,6 +150,15 @@ int snd_jack_new(struct snd_card *card, const char *id, int type,
 	if (err < 0)
 		goto fail_input;
 
+	/* card is the private_data */
+	kctl = snd_kctl_jack_new(jack->id, idx, card);
+	if (!kctl) {
+		err = -ENOMEM;
+		goto fail_input;
+	}
+
+	jack->kctl = kctl;
+
 	*jjack = jack;
 
 	return 0;
@@ -239,6 +261,9 @@ void snd_jack_report(struct snd_jack *jack, int status)
 	}
 
 	input_sync(jack->input_dev);
+
+	/* Update ALSA KControl interface */
+	snd_kctl_jack_report((struct snd_card *)jack->kctl->private_data, jack->kctl, !!status);
 }
 EXPORT_SYMBOL(snd_jack_report);
 
-- 
1.8.1.4

