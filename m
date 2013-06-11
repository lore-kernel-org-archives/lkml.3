Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3FKUPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:15:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab3FKUD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 36/79] ALSA: hda - Allow setting automute/automic hooks after parsing
Date: Tue, 11 Jun 2013 13:03:02 -0700
Message-Id: <20130611195317.171975358@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 77afe0e94884ae40de29cd813a1fb7ddee583591 upstream.

Some codec drivers (VIA codecs and some Realtek fixups) set the
automute and automic hooks after calling
snd_hda_gen_parse_auto_config().  In the current code, the hook
pointers are referred only in snd_hda_gen_parse_auto_config() and
passed to snd_hda_jack_detect_enable_callback(), thus changing the
hook values won't change the actually called callbacks properly.

This patch fixes this bug by setting the static functions as the
primary callback functions for the jack detection, and let them
calling the appropriate hooks dynamically.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -3671,6 +3671,36 @@ static void update_automute_all(struct h
 		snd_hda_gen_mic_autoswitch(codec, NULL);
 }
 
+/* call appropriate hooks */
+static void call_hp_automute(struct hda_codec *codec, struct hda_jack_tbl *jack)
+{
+	struct hda_gen_spec *spec = codec->spec;
+	if (spec->hp_automute_hook)
+		spec->hp_automute_hook(codec, jack);
+	else
+		snd_hda_gen_hp_automute(codec, jack);
+}
+
+static void call_line_automute(struct hda_codec *codec,
+			       struct hda_jack_tbl *jack)
+{
+	struct hda_gen_spec *spec = codec->spec;
+	if (spec->line_automute_hook)
+		spec->line_automute_hook(codec, jack);
+	else
+		snd_hda_gen_line_automute(codec, jack);
+}
+
+static void call_mic_autoswitch(struct hda_codec *codec,
+				struct hda_jack_tbl *jack)
+{
+	struct hda_gen_spec *spec = codec->spec;
+	if (spec->mic_autoswitch_hook)
+		spec->mic_autoswitch_hook(codec, jack);
+	else
+		snd_hda_gen_mic_autoswitch(codec, jack);
+}
+
 /*
  * Auto-Mute mode mixer enum support
  */
@@ -3805,9 +3835,7 @@ static int check_auto_mute_availability(
 		snd_printdd("hda-codec: Enable HP auto-muting on NID 0x%x\n",
 			    nid);
 		snd_hda_jack_detect_enable_callback(codec, nid, HDA_GEN_HP_EVENT,
-						    spec->hp_automute_hook ?
-						    spec->hp_automute_hook :
-						    snd_hda_gen_hp_automute);
+						    call_hp_automute);
 		spec->detect_hp = 1;
 	}
 
@@ -3820,9 +3848,7 @@ static int check_auto_mute_availability(
 				snd_printdd("hda-codec: Enable Line-Out auto-muting on NID 0x%x\n", nid);
 				snd_hda_jack_detect_enable_callback(codec, nid,
 								    HDA_GEN_FRONT_EVENT,
-								    spec->line_automute_hook ?
-								    spec->line_automute_hook :
-								    snd_hda_gen_line_automute);
+								    call_line_automute);
 				spec->detect_lo = 1;
 			}
 		spec->automute_lo_possible = spec->detect_hp;
@@ -3864,9 +3890,7 @@ static bool auto_mic_check_imux(struct h
 		snd_hda_jack_detect_enable_callback(codec,
 						    spec->am_entry[i].pin,
 						    HDA_GEN_MIC_EVENT,
-						    spec->mic_autoswitch_hook ?
-						    spec->mic_autoswitch_hook :
-						    snd_hda_gen_mic_autoswitch);
+						    call_mic_autoswitch);
 	return true;
 }
 


