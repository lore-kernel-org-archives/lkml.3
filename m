Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162348Ab3LFNLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:11:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44763 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162124Ab3LFNFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 253/272] ALSA: hda - Make sure mute LEDs stay on during runtime suspend (Realtek)
Date: Fri,  6 Dec 2013 12:59:02 +0000
Message-Id: <1386334761-25517-254-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit d5b6b65e75ce607c2734227524e11574317a1c1a upstream.

Some HP machines with Realtek codecs have mute LEDs connected to VREF pins.
However when these go into runtime suspend, the pin powers down and its
pin control is disabled, thus disabling the LED too.

This patch fixes that issue by making sure that the pin stays in D0 with
correct pin control.

BugLink: https://bugs.launchpad.net/bugs/1248465
Tested-by: Franz Hsieh <franz.hsieh@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4869049..cfa6340 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2903,6 +2903,23 @@ static void alc269_fixup_mic_mute_hook(void *private_data, int enabled)
 		snd_hda_set_pin_ctl_cache(codec, spec->mute_led_nid, pinval);
 }
 
+/* Make sure the led works even in runtime suspend */
+static unsigned int led_power_filter(struct hda_codec *codec,
+						  hda_nid_t nid,
+						  unsigned int power_state)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (power_state != AC_PWRST_D3 || nid != spec->mute_led_nid)
+		return power_state;
+
+	/* Set pin ctl again, it might have just been set to 0 */
+	snd_hda_set_pin_ctl(codec, nid,
+			    snd_hda_codec_get_pin_target(codec, nid));
+
+	return AC_PWRST_D0;
+}
+
 static void alc269_fixup_hp_mute_led(struct hda_codec *codec,
 				     const struct hda_fixup *fix, int action)
 {
@@ -2922,6 +2939,7 @@ static void alc269_fixup_hp_mute_led(struct hda_codec *codec,
 		spec->mute_led_nid = pin - 0x0a + 0x18;
 		spec->gen.vmaster_mute.hook = alc269_fixup_mic_mute_hook;
 		spec->gen.vmaster_mute_enum = 1;
+		codec->power_filter = led_power_filter;
 		snd_printd("Detected mute LED for %x:%d\n", spec->mute_led_nid,
 			   spec->mute_led_polarity);
 		break;
@@ -2937,6 +2955,7 @@ static void alc269_fixup_hp_mute_led_mic1(struct hda_codec *codec,
 		spec->mute_led_nid = 0x18;
 		spec->gen.vmaster_mute.hook = alc269_fixup_mic_mute_hook;
 		spec->gen.vmaster_mute_enum = 1;
+		codec->power_filter = led_power_filter;
 	}
 }
 
@@ -2949,6 +2968,7 @@ static void alc269_fixup_hp_mute_led_mic2(struct hda_codec *codec,
 		spec->mute_led_nid = 0x19;
 		spec->gen.vmaster_mute.hook = alc269_fixup_mic_mute_hook;
 		spec->gen.vmaster_mute_enum = 1;
+		codec->power_filter = led_power_filter;
 	}
 }
 
-- 
1.8.3.2

