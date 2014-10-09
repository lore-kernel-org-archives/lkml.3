Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbaJIV1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:27:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59403 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbaJIVJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 088/163] ALSA: hda - Fix invalid pin powermap without jack detection
Date: Thu,  9 Oct 2014 14:01:53 -0700
Message-Id: <1412888588-26755-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 7a9744cb455e6faa287e148394b4b422a6f3c5c4 upstream.

When a driver is set up without the jack detection explicitly (either
by passing a model option or via a specific fixup), the pin powermap
of IDT/STAC codecs is set up wrongly, resulting in the silence
output.  It's because of a logic failure in stac_init_power_map().
It tries to avoid creating a callback for the pins that have other
auto-hp and auto-mic callbacks, but the check is done in a wrong way
at a wrong time.  The stac_init_power_map() should be called after
creating other jack detection ctls, and the jack callback should be
created only for jack-detectable widgets.

This patch fixes the check in stac_init_power_map() and its callee
at the right place, after snd_hda_gen_build_controls().

Reported-by: Adam Richter <adam_richter2004@yahoo.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_sigmatel.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index c7b0ba6..4b62db6 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -541,8 +541,8 @@ static void stac_init_power_map(struct hda_codec *codec)
 		if (snd_hda_jack_tbl_get(codec, nid))
 			continue;
 		if (def_conf == AC_JACK_PORT_COMPLEX &&
-		    !(spec->vref_mute_led_nid == nid ||
-		      is_jack_detectable(codec, nid))) {
+		    spec->vref_mute_led_nid != nid &&
+		    is_jack_detectable(codec, nid)) {
 			snd_hda_jack_detect_enable_callback(codec, nid,
 							    STAC_PWR_EVENT,
 							    jack_update_power);
@@ -4194,11 +4194,18 @@ static int stac_parse_auto_config(struct hda_codec *codec)
 			return err;
 	}
 
-	stac_init_power_map(codec);
-
 	return 0;
 }
 
+static int stac_build_controls(struct hda_codec *codec)
+{
+	int err = snd_hda_gen_build_controls(codec);
+
+	if (err < 0)
+		return err;
+	stac_init_power_map(codec);
+	return 0;
+}
 
 static int stac_init(struct hda_codec *codec)
 {
@@ -4332,7 +4339,7 @@ static void stac_set_power_state(struct hda_codec *codec, hda_nid_t fg,
 #endif /* CONFIG_PM */
 
 static const struct hda_codec_ops stac_patch_ops = {
-	.build_controls = snd_hda_gen_build_controls,
+	.build_controls = stac_build_controls,
 	.build_pcms = snd_hda_gen_build_pcms,
 	.init = stac_init,
 	.free = stac_free,
-- 
1.9.1

