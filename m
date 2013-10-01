Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab3JAUjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:39:16 -0400
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:46465 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881Ab3JAUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:39:15 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        =?UTF-8?q?Peter=20Fr=C3=BChberger?= <fritsch@xbmc.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ALSA: hda - hdmi: Add ELD emulation for ATI/AMD codecs
Date: Tue,  1 Oct 2013 23:30:54 +0300
Message-Id: <1380659456-3746-3-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ATI/AMD HDMI/DP codecs do not include standard HDA ELD (EDID-like data)
support.

In place of providing access to an ELD buffer, various vendor-specific
verbs are provided to provide the relevant information. Revision ID 3
and later (0x100300 as reported by procfs codec#X) have support for
providing more information than the previous revisions (but only if
supported by the display driver).

Generate ELD from the information provided by the vendor-specific verbs
on ATI/AMD codecs.

The specification is available at:
http://www.x.org/docs/AMD/AMD_HDA_verbs_v2.pdf

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Tested-by: Peter Frühberger <fritsch@xbmc.org>
---
 sound/pci/hda/hda_eld.c | 157 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index d0d7ac1e..750841e 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -2,6 +2,7 @@
  * Generic routines and proc interface for ELD(EDID Like Data) information
  *
  * Copyright(c) 2008 Intel Corporation.
+ * Copyright (c) 2013 Anssi Hannula <anssi.hannula@iki.fi>
  *
  * Authors:
  * 		Wu Fengguang <wfg@linux.intel.com>
@@ -316,6 +317,9 @@ int snd_hdmi_get_eld_size(struct hda_codec *codec, hda_nid_t nid)
 						 AC_DIPSIZE_ELD_BUF);
 }
 
+static int atihdmi_get_eld(struct hda_codec *codec, hda_nid_t nid,
+			   unsigned char *buf, int *eld_size);
+
 int snd_hdmi_get_eld(struct hda_codec *codec, hda_nid_t nid,
 		     unsigned char *buf, int *eld_size)
 {
@@ -323,6 +327,9 @@ int snd_hdmi_get_eld(struct hda_codec *codec, hda_nid_t nid,
 	int ret = 0;
 	int size;
 
+	if (is_atihdmi(codec))
+		return atihdmi_get_eld(codec, nid, buf, eld_size);
+
 	/*
 	 * ELD size is initialized to zero in caller function. If no errors and
 	 * ELD is valid, actual eld_size is assigned.
@@ -671,3 +678,153 @@ void snd_hdmi_eld_update_pcm_info(struct parsed_hdmi_eld *e,
 	hinfo->maxbps = min(hinfo->maxbps, maxbps);
 	hinfo->channels_max = min(hinfo->channels_max, channels_max);
 }
+
+
+/* ATI/AMD specific stuff (ELD emulation) */
+
+#define ATI_VERB_SET_AUDIO_DESCRIPTOR	0x776
+#define ATI_VERB_SET_SINK_INFO_INDEX	0x780
+#define ATI_VERB_GET_SPEAKER_ALLOCATION	0xf70
+#define ATI_VERB_GET_AUDIO_DESCRIPTOR	0xf76
+#define ATI_VERB_GET_AUDIO_VIDEO_DELAY	0xf7b
+#define ATI_VERB_GET_SINK_INFO_INDEX	0xf80
+#define ATI_VERB_GET_SINK_INFO_DATA	0xf81
+
+#define ATI_SPKALLOC_SPKALLOC		0x007f
+#define ATI_SPKALLOC_TYPE_HDMI		0x0100
+#define ATI_SPKALLOC_TYPE_DISPLAYPORT	0x0200
+
+/* first three bytes are just standard SAD */
+#define ATI_AUDIODESC_CHANNELS		0x00000007
+#define ATI_AUDIODESC_RATES		0x0000ff00
+#define ATI_AUDIODESC_LPCM_STEREO_RATES	0xff000000
+
+/* in standard HDMI VSDB format */
+#define ATI_DELAY_VIDEO_LATENCY		0x000000ff
+#define ATI_DELAY_AUDIO_LATENCY		0x0000ff00
+
+enum ati_sink_info_idx {
+	ATI_INFO_IDX_MANUFACTURER_ID	= 0,
+	ATI_INFO_IDX_PRODUCT_ID		= 1,
+	ATI_INFO_IDX_SINK_DESC_LEN	= 2,
+	ATI_INFO_IDX_PORT_ID_LOW	= 3,
+	ATI_INFO_IDX_PORT_ID_HIGH	= 4,
+	ATI_INFO_IDX_SINK_DESC_FIRST	= 5,
+	ATI_INFO_IDX_SINK_DESC_LAST	= 22, /* max len 18 bytes */
+};
+
+static int atihdmi_get_eld(struct hda_codec *codec, hda_nid_t nid,
+			 unsigned char *buf, int *eld_size)
+{
+	int spkalloc, ati_sad, aud_synch;
+	int sink_desc_len = 0;
+	int pos, i;
+
+	/* ATI/AMD does not have ELD, emulate it */
+
+	spkalloc = snd_hda_codec_read(codec, nid, 0, ATI_VERB_GET_SPEAKER_ALLOCATION, 0);
+
+	if (!spkalloc) {
+		snd_printd(KERN_INFO "HDMI ATI/AMD: no speaker allocation for ELD\n");
+		return -EINVAL;
+	}
+
+	memset(buf, 0, ELD_FIXED_BYTES + ELD_MAX_MNL + ELD_MAX_SAD * 3);
+
+	/* version */
+	buf[0] = ELD_VER_CEA_861D << 3;
+
+	/* speaker allocation from EDID */
+	buf[7] = spkalloc & ATI_SPKALLOC_SPKALLOC;
+
+	/* is DisplayPort? */
+	if (spkalloc & ATI_SPKALLOC_TYPE_DISPLAYPORT)
+		buf[5] |= 0x04;
+
+	pos = ELD_FIXED_BYTES;
+
+	if (is_amdhdmi_rev3(codec)) {
+		int sink_info;
+
+		snd_hda_codec_write(codec, nid, 0, ATI_VERB_SET_SINK_INFO_INDEX, ATI_INFO_IDX_PORT_ID_LOW);
+		sink_info = snd_hda_codec_read(codec, nid, 0, ATI_VERB_GET_SINK_INFO_DATA, 0);
+		put_unaligned_le32(sink_info, buf + 8);
+
+		snd_hda_codec_write(codec, nid, 0, ATI_VERB_SET_SINK_INFO_INDEX, ATI_INFO_IDX_PORT_ID_HIGH);
+		sink_info = snd_hda_codec_read(codec, nid, 0, ATI_VERB_GET_SINK_INFO_DATA, 0);
+		put_unaligned_le32(sink_info, buf + 12);
+
+		snd_hda_codec_write(codec, nid, 0, ATI_VERB_SET_SINK_INFO_INDEX, ATI_INFO_IDX_MANUFACTURER_ID);
+		sink_info = snd_hda_codec_read(codec, nid, 0, ATI_VERB_GET_SINK_INFO_DATA, 0);
+		put_unaligned_le16(sink_info, buf + 16);
+
+		snd_hda_codec_write(codec, nid, 0, ATI_VERB_SET_SINK_INFO_INDEX, ATI_INFO_IDX_PRODUCT_ID);
+		sink_info = snd_hda_codec_read(codec, nid, 0, ATI_VERB_GET_SINK_INFO_DATA, 0);
+		put_unaligned_le16(sink_info, buf + 18);
+
+		snd_hda_codec_write(codec, nid, 0, ATI_VERB_SET_SINK_INFO_INDEX, ATI_INFO_IDX_SINK_DESC_LEN);
+		sink_desc_len = snd_hda_codec_read(codec, nid, 0, ATI_VERB_GET_SINK_INFO_DATA, 0);
+
+		if (sink_desc_len > ELD_MAX_MNL) {
+			snd_printd(KERN_INFO "HDMI ATI/AMD: Truncating HDMI sink description with length %d\n",
+				   sink_desc_len);
+			sink_desc_len = ELD_MAX_MNL;
+		}
+
+		buf[4] |= sink_desc_len;
+
+		for (i = 0; i < sink_desc_len; i++) {
+			snd_hda_codec_write(codec, nid, 0, ATI_VERB_SET_SINK_INFO_INDEX, ATI_INFO_IDX_SINK_DESC_FIRST + i);
+			buf[pos++] = snd_hda_codec_read(codec, nid, 0, ATI_VERB_GET_SINK_INFO_DATA, 0);
+		}
+	}
+
+	for (i = AUDIO_CODING_TYPE_LPCM; i <= AUDIO_CODING_TYPE_WMAPRO; i++) {
+		if (i == AUDIO_CODING_TYPE_SACD || i == AUDIO_CODING_TYPE_DST)
+			continue; /* not handled by ATI/AMD */
+
+		snd_hda_codec_write(codec, nid, 0, ATI_VERB_SET_AUDIO_DESCRIPTOR, i << 3);
+		ati_sad = snd_hda_codec_read(codec, nid, 0, ATI_VERB_GET_AUDIO_DESCRIPTOR, 0);
+
+		if (ati_sad & ATI_AUDIODESC_RATES) {
+			/* format is supported, copy SAD as-is */
+			buf[pos++] = (ati_sad & 0x0000ff) >> 0;
+			buf[pos++] = (ati_sad & 0x00ff00) >> 8;
+			buf[pos++] = (ati_sad & 0xff0000) >> 16;
+		}
+
+		if (i == AUDIO_CODING_TYPE_LPCM
+		    && (ati_sad & ATI_AUDIODESC_LPCM_STEREO_RATES)
+		    && (ati_sad & ATI_AUDIODESC_LPCM_STEREO_RATES) >> 16 != (ati_sad & ATI_AUDIODESC_RATES)) {
+			/* for PCM there is a separate stereo rate mask */
+			buf[pos++] = ((ati_sad & 0x000000ff) & ~ATI_AUDIODESC_CHANNELS) | 0x1;
+			/* rates from the extra byte */
+			buf[pos++] = (ati_sad & 0xff000000) >> 24;
+			buf[pos++] = (ati_sad & 0x00ff0000) >> 16;
+		}
+	}
+
+	if (pos == ELD_FIXED_BYTES + sink_desc_len) {
+		snd_printd(KERN_INFO "HDMI ATI/AMD: no audio descriptors for ELD\n");
+		return -EINVAL;
+	}
+
+	aud_synch = snd_hda_codec_read(codec, nid, 0, ATI_VERB_GET_AUDIO_VIDEO_DELAY, 0);
+	if ((aud_synch & ATI_DELAY_VIDEO_LATENCY) && (aud_synch & ATI_DELAY_AUDIO_LATENCY)) {
+		int video_latency = (aud_synch & ATI_DELAY_VIDEO_LATENCY) - 1;
+		int audio_latency = ((aud_synch & ATI_DELAY_AUDIO_LATENCY) >> 8) - 1;
+
+		if (video_latency > audio_latency)
+			buf[6] = min(video_latency - audio_latency, 0xfa);
+	}
+
+	/* Baseline length */
+	buf[2] = pos - 4;
+
+	/* SAD count */
+	buf[5] |= ((pos - ELD_FIXED_BYTES - sink_desc_len) / 3) << 4;
+
+	*eld_size = pos;
+
+	return 0;
+}
-- 
1.8.1.5

