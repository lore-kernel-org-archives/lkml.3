Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbaBGLyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:54:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42579 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbaBGLw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Warren <swarren@nvidia.com>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 230/233] ALSA: hda/hdmi - allow PIN_OUT to be dynamically enabled
Date: Fri,  7 Feb 2014 11:47:29 +0000
Message-Id: <1391773652-25214-231-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 75fae117a5dbde5ab984fa5c60705758cfbc6433 upstream.

Commit 384a48d71520 "ALSA: hda: HDMI: Support codecs with fewer cvts
than pins" dynamically enabled each pin widget's PIN_OUT only when the
pin was actively in use. This was required on certain NVIDIA CODECs for
correct operation. Specifically, if multiple pin widgets each had their
mux input select the same audio converter widget and each pin widget had
PIN_OUT enabled, then only one of the pin widgets would actually receive
the audio, and often not the one the user wanted!

However, this apparently broke some Intel systems, and commit
6169b673618b "ALSA: hda - Always turn on pins for HDMI/DP" reverted the
dynamic setting of PIN_OUT. This in turn broke the afore-mentioned NVIDIA
CODECs.

This change supports either dynamic or static handling of PIN_OUT,
selected by a flag set up during CODEC initialization. This flag is
enabled for all recent NVIDIA GPUs.

Reported-by: Uosis <uosisl@gmail.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 7f4c726..6fbcba5 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -86,6 +86,9 @@ struct hdmi_spec {
 	unsigned int channels_max; /* max over all cvts */
 
 	struct hdmi_eld temp_eld;
+
+	bool dyn_pin_out;
+
 	/*
 	 * Non-generic ATI/NVIDIA specific
 	 */
@@ -450,15 +453,25 @@ static void hdmi_write_dip_byte(struct hda_codec *codec, hda_nid_t pin_nid,
 
 static void hdmi_init_pin(struct hda_codec *codec, hda_nid_t pin_nid)
 {
+	struct hdmi_spec *spec = codec->spec;
+	int pin_out;
+
 	/* Unmute */
 	if (get_wcaps(codec, pin_nid) & AC_WCAP_OUT_AMP)
 		snd_hda_codec_write(codec, pin_nid, 0,
 				AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
-	/* Enable pin out: some machines with GM965 gets broken output when
-	 * the pin is disabled or changed while using with HDMI
-	 */
+
+	if (spec->dyn_pin_out)
+		/* Disable pin out until stream is active */
+		pin_out = 0;
+	else
+		/* Enable pin out: some machines with GM965 gets broken output
+		 * when the pin is disabled or changed while using with HDMI
+		 */
+		pin_out = PIN_OUT;
+
 	snd_hda_codec_write(codec, pin_nid, 0,
-			    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
+			    AC_VERB_SET_PIN_WIDGET_CONTROL, pin_out);
 }
 
 static int hdmi_get_channel_count(struct hda_codec *codec, hda_nid_t cvt_nid)
@@ -1539,6 +1552,7 @@ static int generic_hdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 	struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
 	hda_nid_t pin_nid = per_pin->pin_nid;
 	bool non_pcm;
+	int pinctl;
 
 	non_pcm = check_non_pcm_per_cvt(codec, cvt_nid);
 	per_pin->channels = substream->runtime->channels;
@@ -1548,6 +1562,14 @@ static int generic_hdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 
 	hdmi_setup_audio_infoframe(codec, per_pin, non_pcm);
 
+	if (spec->dyn_pin_out) {
+		pinctl = snd_hda_codec_read(codec, pin_nid, 0,
+					    AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
+		snd_hda_codec_write(codec, pin_nid, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL,
+				    pinctl | PIN_OUT);
+	}
+
 	return hdmi_setup_stream(codec, cvt_nid, pin_nid, stream_tag, format);
 }
 
@@ -1567,6 +1589,7 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
 	int cvt_idx, pin_idx;
 	struct hdmi_spec_per_cvt *per_cvt;
 	struct hdmi_spec_per_pin *per_pin;
+	int pinctl;
 
 	if (hinfo->nid) {
 		cvt_idx = cvt_nid_to_cvt_index(spec, hinfo->nid);
@@ -1583,6 +1606,14 @@ static int hdmi_pcm_close(struct hda_pcm_stream *hinfo,
 			return -EINVAL;
 		per_pin = get_pin(spec, pin_idx);
 
+		if (spec->dyn_pin_out) {
+			pinctl = snd_hda_codec_read(codec, per_pin->pin_nid, 0,
+					AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
+			snd_hda_codec_write(codec, per_pin->pin_nid, 0,
+					    AC_VERB_SET_PIN_WIDGET_CONTROL,
+					    pinctl & ~PIN_OUT);
+		}
+
 		snd_hda_spdif_ctls_unassign(codec, pin_idx);
 		per_pin->chmap_set = false;
 		memset(per_pin->chmap, 0, sizeof(per_pin->chmap));
@@ -2572,6 +2603,7 @@ static int patch_nvhdmi(struct hda_codec *codec)
 		return err;
 
 	spec = codec->spec;
+	spec->dyn_pin_out = true;
 
 	return 0;
 }
-- 
1.8.3.2

