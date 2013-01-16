Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab3APQFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:05:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36284 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354Ab3APQFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 127/222] ALSA: hda - Always turn on pins for HDMI/DP
Date: Wed, 16 Jan 2013 13:55:27 -0200
Message-Id: <1358351822-7675-128-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6169b673618bf0b2518ce413b54925782a603f06 upstream.

We've seen the broken HDMI *video* output on some machines with GM965,
and the debugging session pointed that the culprit is the disabled
audio output pins.  Toggling these pins dynamically on demand caused
flickering of HDMI TV.

This patch changes the behavior to keep the pin ON constantly.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=51421

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_hdmi.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 5d52332..f212c37 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -425,9 +425,11 @@ static void hdmi_init_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 	if (get_wcaps(codec, pin_nid) & AC_WCAP_OUT_AMP)
 		snd_hda_codec_write(codec, pin_nid, 0,
 				AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
-	/* Disable pin out until stream is active*/
+	/* Enable pin out: some machines with GM965 gets broken output when
+	 * the pin is disabled or changed while using with HDMI
+	 */
 	snd_hda_codec_write(codec, pin_nid, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, 0);
+			    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
 }
 
 static int hdmi_get_channel_count(struct hda_codec *codec, hda_nid_t cvt_nid)
@@ -1147,17 +1149,11 @@ static int generic_hdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 	struct hdmi_spec *spec = codec->spec;
 	int pin_idx = hinfo_to_pin_index(spec, hinfo);
 	hda_nid_t pin_nid = spec->pins[pin_idx].pin_nid;
-	int pinctl;
 
 	hdmi_set_channel_count(codec, cvt_nid, substream->runtime->channels);
 
 	hdmi_setup_audio_infoframe(codec, pin_idx, substream);
 
-	pinctl = snd_hda_codec_read(codec, pin_nid, 0,
-				    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-	snd_hda_codec_write(codec, pin_nid, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, pinctl | PIN_OUT);
-
 	return hdmi_setup_stream(codec, cvt_nid, pin_nid, stream_tag, format);
 }
 
@@ -1169,7 +1165,6 @@ static int generic_hdmi_playback_pcm_cleanup(struct hda_pcm_stream *hinfo,
 	int cvt_idx, pin_idx;
 	struct hdmi_spec_per_cvt *per_cvt;
 	struct hdmi_spec_per_pin *per_pin;
-	int pinctl;
 
 	snd_hda_codec_cleanup_stream(codec, hinfo->nid);
 
@@ -1188,11 +1183,6 @@ static int generic_hdmi_playback_pcm_cleanup(struct hda_pcm_stream *hinfo,
 			return -EINVAL;
 		per_pin = &spec->pins[pin_idx];
 
-		pinctl = snd_hda_codec_read(codec, per_pin->pin_nid, 0,
-					    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-		snd_hda_codec_write(codec, per_pin->pin_nid, 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL,
-				    pinctl & ~PIN_OUT);
 		snd_hda_spdif_ctls_unassign(codec, pin_idx);
 	}
 
-- 
1.7.9.5

