Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3JAUmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:42:09 -0400
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:55199 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024Ab3JAUmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:42:07 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        =?UTF-8?q?Peter=20Fr=C3=BChberger?= <fritsch@xbmc.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ALSA: hda - hdmi: Add HBR bitstreaming support for ATI/AMD HDMI codecs
Date: Tue,  1 Oct 2013 23:30:55 +0300
Message-Id: <1380659456-3746-4-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ATI/AMD HDMI codecs do not include standard HDA HDMI HBR support (which
is required for bitstreaming DTS-HD and Dolby TrueHD), instead they have
custom verbs for checking and enabling it.

Add support for the ATI/AMD HDMI HBR verbs.

The specification is available at:
http://www.x.org/docs/AMD/AMD_HDA_verbs_v2.pdf

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Tested-by: Peter Frühberger <fritsch@xbmc.org>
---
 sound/pci/hda/patch_hdmi.c | 65 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 19adb01..c0cd4ca 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1140,7 +1140,7 @@ static int hdmi_setup_stream(struct hda_codec *codec, hda_nid_t cvt_nid,
 					    new_pinctl);
 
 	}
-	if (is_hbr_format(format) && !new_pinctl) {
+	if (is_hbr_format(format) && !new_pinctl && !is_atihdmi(codec)) {
 		snd_printdd("hdmi_setup_stream: HBR is not supported\n");
 		return -EINVAL;
 	}
@@ -2654,6 +2654,7 @@ static int patch_nvhdmi_8ch_7x(struct hda_codec *codec)
 #define ATI_VERB_SET_MULTICHANNEL_23	0x778
 #define ATI_VERB_SET_MULTICHANNEL_45	0x779
 #define ATI_VERB_SET_MULTICHANNEL_67	0x77a
+#define ATI_VERB_SET_HBR_CONTROL	0x77c
 #define ATI_VERB_SET_MULTICHANNEL_1	0x785
 #define ATI_VERB_SET_MULTICHANNEL_3	0x786
 #define ATI_VERB_SET_MULTICHANNEL_5	0x787
@@ -2665,6 +2666,7 @@ static int patch_nvhdmi_8ch_7x(struct hda_codec *codec)
 #define ATI_VERB_GET_MULTICHANNEL_23	0xf78
 #define ATI_VERB_GET_MULTICHANNEL_45	0xf79
 #define ATI_VERB_GET_MULTICHANNEL_67	0xf7a
+#define ATI_VERB_GET_HBR_CONTROL	0xf7c
 #define ATI_VERB_GET_MULTICHANNEL_1	0xf85
 #define ATI_VERB_GET_MULTICHANNEL_3	0xf86
 #define ATI_VERB_GET_MULTICHANNEL_5	0xf87
@@ -2673,6 +2675,9 @@ static int patch_nvhdmi_8ch_7x(struct hda_codec *codec)
 
 #define ATI_OUT_ENABLE 0x1
 
+#define ATI_HBR_CAPABLE 0x01
+#define ATI_HBR_ENABLE 0x10
+
 static void atihdmi_set_ca(struct hda_codec *codec, hda_nid_t pin_nid, int ca)
 {
 	printk("ATI: setting ca %d\n", ca);
@@ -2813,6 +2818,63 @@ static int atihdmi_get_chan_slot(struct hda_codec *codec, hda_nid_t pin_nid, int
 }
 #endif
 
+static int atihdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
+					struct hda_codec *codec,
+					unsigned int stream_tag,
+					unsigned int format,
+					struct snd_pcm_substream *substream)
+{
+	struct hdmi_spec *spec = codec->spec;
+	int pin_idx = hinfo_to_pin_index(spec, hinfo);
+	struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
+	hda_nid_t pin_nid = per_pin->pin_nid;
+	int hbr_ctl, hbr_ctl_new;
+
+	hbr_ctl = snd_hda_codec_read(codec, pin_nid, 0, ATI_VERB_GET_HBR_CONTROL, 0);
+	if (hbr_ctl & ATI_HBR_CAPABLE) {
+		if (is_hbr_format(format))
+			hbr_ctl_new = hbr_ctl | ATI_HBR_ENABLE;
+		else
+			hbr_ctl_new = hbr_ctl & ~ATI_HBR_ENABLE;
+
+		snd_printdd("atihdmi_playback_pcm_prepare: "
+				"NID=0x%x, %shbr-ctl=0x%x\n",
+				pin_nid,
+				hbr_ctl == hbr_ctl_new ? "" : "new-",
+				hbr_ctl_new);
+
+		if (hbr_ctl != hbr_ctl_new)
+			snd_hda_codec_write(codec, pin_nid, 0,
+						ATI_VERB_SET_HBR_CONTROL,
+						hbr_ctl_new);
+
+	} else if (is_hbr_format(format)) {
+		snd_printdd("atihdmi_playback_pcm_prepare: HBR is not supported\n");
+		return -EINVAL;
+	}
+
+	return generic_hdmi_playback_pcm_prepare(hinfo, codec, stream_tag, format, substream);
+}
+
+static int atihdmi_build_pcms(struct hda_codec *codec)
+{
+	struct hdmi_spec *spec = codec->spec;
+	int err, pin_idx;
+
+	err = generic_hdmi_build_pcms(codec);
+
+	if (err)
+		return err;
+
+	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
+		struct hda_pcm *info = get_pcm_rec(spec, pin_idx);
+
+		info->stream[SNDRV_PCM_STREAM_PLAYBACK].ops.prepare = atihdmi_playback_pcm_prepare;
+	}
+
+	return 0;
+}
+
 static int atihdmi_init(struct hda_codec *codec)
 {
 	struct hdmi_spec *spec = codec->spec;
@@ -2849,6 +2911,7 @@ static int patch_atihdmi(struct hda_codec *codec)
 		return err;
 
 	codec->patch_ops.init = atihdmi_init;
+	codec->patch_ops.build_pcms = atihdmi_build_pcms;
 
 	/* ATI/AMD converters do not advertise all of their capabilities */
 	spec = codec->spec;
-- 
1.8.1.5

