Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaJCVz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:55:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaJCVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:55:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adam Richter <adam_richter2004@yahoo.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 044/238] ALSA: hda - Fix invalid pin powermap without jack detection
Date: Fri,  3 Oct 2014 14:29:19 -0700
Message-Id: <20141003212915.068332733@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -559,8 +559,8 @@ static void stac_init_power_map(struct h
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
@@ -4212,11 +4212,18 @@ static int stac_parse_auto_config(struct
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
@@ -4328,7 +4335,7 @@ static int stac_suspend(struct hda_codec
 #endif /* CONFIG_PM */
 
 static const struct hda_codec_ops stac_patch_ops = {
-	.build_controls = snd_hda_gen_build_controls,
+	.build_controls = stac_build_controls,
 	.build_pcms = snd_hda_gen_build_pcms,
 	.init = stac_init,
 	.free = stac_free,


