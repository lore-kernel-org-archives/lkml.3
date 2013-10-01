Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3JAUhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:37:11 -0400
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:55920 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656Ab3JAUhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:37:07 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        =?UTF-8?q?Peter=20Fr=C3=BChberger?= <fritsch@xbmc.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ALSA: hda - hdmi: Disable ramp-up/down for non-PCM on AMD codecs
Date: Tue,  1 Oct 2013 23:30:56 +0300
Message-Id: <1380659456-3746-5-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent AMD HDMI codecs (revision ID 3 and later, 0x100300 as reported by
procfs codec#0) have a configurable ramp-up/down functionality.

The documentation ( http://www.x.org/docs/AMD/AMD_HDA_verbs_v2.pdf )
specifies that 180 (meaning 180/256 =~ 0.7) is recommended for PCM and 0
for non-PCM.

Apply the recommended values according to provided S/PDIF AES0 settings.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
---
 sound/pci/hda/patch_hdmi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index c0cd4ca..22f30fe 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2673,6 +2673,10 @@ static int patch_nvhdmi_8ch_7x(struct hda_codec *codec)
 #define ATI_VERB_GET_MULTICHANNEL_7	0xf88
 #define ATI_VERB_GET_MULTICHANNEL_MODE	0xf89
 
+/* AMD specific HDA cvt verbs */
+#define ATI_VERB_SET_RAMP_RATE		0x770
+#define ATI_VERB_GET_RAMP_RATE		0xf70
+
 #define ATI_OUT_ENABLE 0x1
 
 #define ATI_HBR_CAPABLE 0x01
@@ -2824,6 +2828,7 @@ static int atihdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 					unsigned int format,
 					struct snd_pcm_substream *substream)
 {
+	hda_nid_t cvt_nid = hinfo->nid;
 	struct hdmi_spec *spec = codec->spec;
 	int pin_idx = hinfo_to_pin_index(spec, hinfo);
 	struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
@@ -2853,6 +2858,15 @@ static int atihdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 		return -EINVAL;
 	}
 
+	if (is_amdhdmi_rev3(codec)) {
+		int ramp_rate = 180; /* default as per spec */
+		/* disable ramp-up/down for non-pcm as per spec */
+		if (format & AC_FMT_TYPE_NON_PCM)
+			ramp_rate = 0;
+
+		snd_hda_codec_write(codec, cvt_nid, 0, ATI_VERB_SET_RAMP_RATE, ramp_rate);
+	}
+
 	return generic_hdmi_playback_pcm_prepare(hinfo, codec, stream_tag, format, substream);
 }
 
-- 
1.8.1.5

