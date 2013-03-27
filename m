Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3C0Iaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:30:30 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:49522 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039Ab3C0IaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:30:24 -0400
Message-ID: <1364373022.1390.331.camel@x61.thuisdomein>
Subject: [PATCH] ALSA: hda - Clean up documentation a bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Wed, 27 Mar 2013 09:30:22 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2013 08:30:22.0363 (UTC) FILETIME=[52A286B0:01CE2AC5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SND_HDA_POWER_SAVE was removed in v3.6.7, see commit
83012a7ccbb90dee33c97a004b3e374f988612af ("ALSA: hda - Clean up
CONFIG_SND_HDA_POWER_SAVE"). Clean up hda's documentation to reflect
that.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I send this to the sound maintainers. I guess this they need to send
it to the Documentation maintainer (after review).

1) Most changes are rather straightforward. However, I updated the
copies of struct hda_bus_ops and and struct hda_codec_ops to their
current value. So the docs now describe a mix of the current status and
the old status. I'm not sure whether that won't just make things
confusing.

 Documentation/sound/alsa/HD-Audio.txt  |  3 ---
 Documentation/sound/alsa/hda_codec.txt | 36 ++++++++++++++++++++++------------
 Documentation/sound/alsa/powersave.txt |  4 ++--
 3 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/Documentation/sound/alsa/HD-Audio.txt b/Documentation/sound/alsa/HD-Audio.txt
index d4faa63..529d2b0 100644
--- a/Documentation/sound/alsa/HD-Audio.txt
+++ b/Documentation/sound/alsa/HD-Audio.txt
@@ -326,9 +326,6 @@ hwdep option above.  When enabled, you'll have some sysfs files under
 the corresponding hwdep directory.  See "HD-audio reconfiguration"
 section below.
 
-`CONFIG_SND_HDA_POWER_SAVE` option enables the power-saving feature.
-See "Power-saving" section below.
-
 
 Codec Proc-File
 ~~~~~~~~~~~~~~~
diff --git a/Documentation/sound/alsa/hda_codec.txt b/Documentation/sound/alsa/hda_codec.txt
index de8efbc..c36b24d 100644
--- a/Documentation/sound/alsa/hda_codec.txt
+++ b/Documentation/sound/alsa/hda_codec.txt
@@ -45,12 +45,22 @@ These fields, private_data, pci and modelname are all optional.
 The ops field contains the callback functions as the following:
 
 struct hda_bus_ops {
-	int (*command)(struct hda_codec *codec, hda_nid_t nid, int direct,
-		       unsigned int verb, unsigned int parm);
-	unsigned int (*get_response)(struct hda_codec *codec);
+	int (*command)(struct hda_bus *bus, unsigned int cmd);
+	unsigned int (*get_response)(struct hda_bus *bus, unsigned int addr);
 	void (*private_free)(struct hda_bus *);
-#ifdef CONFIG_SND_HDA_POWER_SAVE
-	void (*pm_notify)(struct hda_codec *codec);
+	int (*attach_pcm)(struct hda_bus *bus, struct hda_codec *codec,
+			  struct hda_pcm *pcm);
+	void (*bus_reset)(struct hda_bus *bus);
+#ifdef CONFIG_PM
+	void (*pm_notify)(struct hda_bus *bus, bool power_up);
+#endif
+#ifdef CONFIG_SND_HDA_DSP_LOADER
+	int (*load_dsp_prepare)(struct hda_bus *bus, unsigned int format,
+				unsigned int byte_size,
+				struct snd_dma_buffer *bufp);
+	void (*load_dsp_trigger)(struct hda_bus *bus, bool start);
+	void (*load_dsp_cleanup)(struct hda_bus *bus,
+				 struct snd_dma_buffer *dmab);
 #endif
 };
 
@@ -62,12 +72,11 @@ be given.
 The third, private_free callback, is optional.  It's called in the
 destructor to release any necessary data in the lowlevel driver.
 
-The pm_notify callback is available only with
-CONFIG_SND_HDA_POWER_SAVE kconfig.  It's called when the codec needs
-to power up or may power down.  The controller should check the all
-belonging codecs on the bus whether they are actually powered off
-(check codec->power_on), and optionally the driver may power down the
-controller side, too.
+The pm_notify callback is available only with CONFIG_PM enabled.
+It's called when the codec needs to power up or may power down.  The
+controller should check the all belonging codecs on the bus whether
+they are actually powered off (check codec->power_on), and optionally
+the driver may power down the controller side, too.
 
 The bus instance is created via snd_hda_bus_new().  You need to pass
 the card instance, the template, and the pointer to store the
@@ -248,14 +257,15 @@ set the codec->patch_ops field.  This is defined as below:
 		int (*init)(struct hda_codec *codec);
 		void (*free)(struct hda_codec *codec);
 		void (*unsol_event)(struct hda_codec *codec, unsigned int res);
+		void (*set_power_state)(struct hda_codec *codec, hda_nid_t fg,
+					unsigned int power_state);
 	#ifdef CONFIG_PM
 		int (*suspend)(struct hda_codec *codec, pm_message_t state);
 		int (*resume)(struct hda_codec *codec);
-	#endif
-	#ifdef CONFIG_SND_HDA_POWER_SAVE
 		int (*check_power_status)(struct hda_codec *codec,
 					  hda_nid_t nid);
 	#endif
+		void (*reboot_notify)(struct hda_codec *codec);
 	};
 
 The build_controls callback is called from snd_hda_build_controls().
diff --git a/Documentation/sound/alsa/powersave.txt b/Documentation/sound/alsa/powersave.txt
index 9657e80..8f780ae 100644
--- a/Documentation/sound/alsa/powersave.txt
+++ b/Documentation/sound/alsa/powersave.txt
@@ -2,8 +2,8 @@ Notes on Power-Saving Mode
 ==========================
 
 AC97 and HD-audio drivers have the automatic power-saving mode.
-This feature is enabled via Kconfig CONFIG_SND_AC97_POWER_SAVE
-and CONFIG_SND_HDA_POWER_SAVE options, respectively.
+This feature is enabled via Kconfig option CONFIG_PM. AC97 needs
+option CONFIG_SND_AC97_POWER_SAVE additionally.
 
 With the automatic power-saving, the driver turns off the codec power
 appropriately when no operation is required.  When no applications use
-- 
1.7.11.7

