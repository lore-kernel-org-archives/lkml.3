Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaDJEOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:14:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934718AbaDJDWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 055/134] ALSA: hda - Always turn on pins for HDMI/DP
Date: Wed,  9 Apr 2014 20:22:51 -0700
Message-Id: <20140410032307.242971198@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -425,9 +425,11 @@ static void hdmi_init_pin(struct hda_cod
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
@@ -1152,17 +1154,11 @@ static int generic_hdmi_playback_pcm_pre
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
 
@@ -1174,7 +1170,6 @@ static int generic_hdmi_playback_pcm_cle
 	int cvt_idx, pin_idx;
 	struct hdmi_spec_per_cvt *per_cvt;
 	struct hdmi_spec_per_pin *per_pin;
-	int pinctl;
 
 	snd_hda_codec_cleanup_stream(codec, hinfo->nid);
 
@@ -1193,11 +1188,6 @@ static int generic_hdmi_playback_pcm_cle
 			return -EINVAL;
 		per_pin = &spec->pins[pin_idx];
 
-		pinctl = snd_hda_codec_read(codec, per_pin->pin_nid, 0,
-					    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-		snd_hda_codec_write(codec, per_pin->pin_nid, 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL,
-				    pinctl & ~PIN_OUT);
 		snd_hda_spdif_ctls_unassign(codec, pin_idx);
 	}
 


