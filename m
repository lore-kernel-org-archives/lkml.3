Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453Ab3K0BvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:51:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab3K0A5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Franz Hsieh <franz.hsieh@canonical.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 37/80] ALSA: hda - Make sure mute LEDs stay on during runtime suspend (Realtek)
Date: Tue, 26 Nov 2013 16:57:06 -0800
Message-Id: <20131127005643.504406669@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2765,6 +2765,23 @@ static void alc269_fixup_mic_mute_hook(v
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
@@ -2784,6 +2801,7 @@ static void alc269_fixup_hp_mute_led(str
 		spec->mute_led_nid = pin - 0x0a + 0x18;
 		spec->gen.vmaster_mute.hook = alc269_fixup_mic_mute_hook;
 		spec->gen.vmaster_mute_enum = 1;
+		codec->power_filter = led_power_filter;
 		snd_printd("Detected mute LED for %x:%d\n", spec->mute_led_nid,
 			   spec->mute_led_polarity);
 		break;
@@ -2799,6 +2817,7 @@ static void alc269_fixup_hp_mute_led_mic
 		spec->mute_led_nid = 0x18;
 		spec->gen.vmaster_mute.hook = alc269_fixup_mic_mute_hook;
 		spec->gen.vmaster_mute_enum = 1;
+		codec->power_filter = led_power_filter;
 	}
 }
 
@@ -2811,6 +2830,7 @@ static void alc269_fixup_hp_mute_led_mic
 		spec->mute_led_nid = 0x19;
 		spec->gen.vmaster_mute.hook = alc269_fixup_mic_mute_hook;
 		spec->gen.vmaster_mute_enum = 1;
+		codec->power_filter = led_power_filter;
 	}
 }
 


