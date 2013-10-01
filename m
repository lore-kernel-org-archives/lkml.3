Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3JAUjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:39:19 -0400
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:50523 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab3JAUjP (ORCPT
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
Subject: [PATCH 1/4] ALSA: hda - hdmi: Add ATI/AMD multi-channel audio support
Date: Tue,  1 Oct 2013 23:30:53 +0300
Message-Id: <1380659456-3746-2-git-send-email-anssi.hannula@iki.fi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
References: <1380659456-3746-1-git-send-email-anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ATI/AMD codecs do not support all the standard HDA HDMI/DP functions,
instead various vendor-specific verbs are provided.

This commit addresses these missing functions:
- standard channel mapping support
- standard infoframe configuration support

ATI/AMD provides their own verbs that allow the following:
- setting CA for infoframe
- setting down-mix information for infoframe
- channel pair remapping
- individual channel remapping (revision ID 3+, 0x100300+)

The documentation for the verbs has now been released by AMD:
http://www.x.org/docs/AMD/AMD_HDA_verbs_v2.pdf

Add support for the ATI/AMD specific verbs and use them instead of the
generic methods on ATI/AMD codecs. This allows multi-channel PCM audio
to work.

Channel remapping is restricted to pairwise mapping on codecs with
revision ID 2 (0x100200 as reported by procfs codec#X) or lower. This
means cards up to Radeon HD7670 as far as I know. This will not affect
standard multi-channel modes since these codecs support automatic
FC-LFE swapping for HDMI.

ATI/AMD codecs do not advertise all of their supported rates, formats
and channel counts, therefore that information is forced accordingly so
that all HDMI 1.x PCM parameters are marked as supported.

Support for multiple ports is also added to patch_atihdmi so that
0x1002aa01 codecs with multiple ports will work properly when switched
back to that patch.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Tested-by: Peter Frühberger <fritsch@xbmc.org>
---
 sound/pci/hda/hda_local.h  |   5 +
 sound/pci/hda/patch_hdmi.c | 355 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 317 insertions(+), 43 deletions(-)

diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
index 2e7493e..7c0b89e 100644
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -786,4 +786,9 @@ static inline void snd_hda_eld_proc_free(struct hda_codec *codec,
 #define SND_PRINT_CHANNEL_ALLOCATION_ADVISED_BUFSIZE 80
 void snd_print_channel_allocation(int spk_alloc, char *buf, int buflen);
 
+/* shared with patch_hdmi.c and hda_eld.c */
+#define is_atihdmi(codec) (((codec)->vendor_id & 0xffff0000) == 0x10020000)
+#define is_amdhdmi_rev3(codec) \
+	((codec)->vendor_id == 0x1002791a && ((codec)->revision_id & 0xff00) >= 0x0300)
+
 #endif /* __SOUND_HDA_LOCAL_H */
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 3d8cd044..19adb01 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -6,6 +6,7 @@
  *  Copyright (c) 2006 ATI Technologies Inc.
  *  Copyright (c) 2008 NVIDIA Corp.  All rights reserved.
  *  Copyright (c) 2008 Wei Ni <wni@nvidia.com>
+ *  Copyright (c) 2013 Anssi Hannula <anssi.hannula@iki.fi>
  *
  *  Authors:
  *			Wu Fengguang <wfg@linux.intel.com>
@@ -46,6 +47,9 @@ MODULE_PARM_DESC(static_hdmi_pcm, "Don't restrict PCM parameters per ELD info");
 
 #define is_haswell(codec)  ((codec)->vendor_id == 0x80862807)
 
+/* is_atihdmi() and is_amdhdmi_rev3() are in hda_local.h */
+#define has_amd_full_remap_support(codec) is_amdhdmi_rev3(codec)
+
 struct hdmi_spec_per_cvt {
 	hda_nid_t cvt_nid;
 	int assigned;
@@ -89,7 +93,7 @@ struct hdmi_spec {
 
 	struct hdmi_eld temp_eld;
 	/*
-	 * Non-generic ATI/NVIDIA specific
+	 * Non-generic VIA/NVIDIA specific
 	 */
 	struct hda_multi_out multiout;
 	struct hda_pcm_stream pcm_playback;
@@ -573,6 +577,20 @@ static int hdmi_channel_allocation(struct hdmi_eld *eld, int channels)
 	return ca;
 }
 
+#ifdef CONFIG_SND_DEBUG_VERBOSE
+static int atihdmi_get_chan_slot(struct hda_codec *codec, hda_nid_t pin_nid, int asp_slot);
+
+static int hdmi_get_chan_slot(struct hda_codec *codec, hda_nid_t pin_nid, int asp_slot)
+{
+	if (is_atihdmi(codec))
+		return atihdmi_get_chan_slot(codec, pin_nid, asp_slot);
+
+	return snd_hda_codec_read(codec, pin_nid, 0,
+				  AC_VERB_GET_HDMI_CHAN_SLOT,
+				  asp_slot);
+}
+#endif
+
 static void hdmi_debug_channel_mapping(struct hda_codec *codec,
 				       hda_nid_t pin_nid)
 {
@@ -581,14 +599,26 @@ static void hdmi_debug_channel_mapping(struct hda_codec *codec,
 	int slot;
 
 	for (i = 0; i < 8; i++) {
-		slot = snd_hda_codec_read(codec, pin_nid, 0,
-						AC_VERB_GET_HDMI_CHAN_SLOT, i);
+		slot = hdmi_get_chan_slot(codec, pin_nid, i);
 		printk(KERN_DEBUG "HDMI: ASP channel %d => slot %d\n",
 						slot >> 4, slot & 0xf);
 	}
 #endif
 }
 
+static int atihdmi_set_chan_slot(struct hda_codec *codec, hda_nid_t pin_nid,
+				  int chanslot_setup);
+
+static int hdmi_set_chan_slot(struct hda_codec *codec, hda_nid_t pin_nid,
+			       int chanslot_setup)
+{
+	if (is_atihdmi(codec))
+		return atihdmi_set_chan_slot(codec, pin_nid, chanslot_setup);
+
+	return snd_hda_codec_write(codec, pin_nid, 0,
+				   AC_VERB_SET_HDMI_CHAN_SLOT,
+				   chanslot_setup);
+}
 
 static void hdmi_std_setup_channel_mapping(struct hda_codec *codec,
 				       hda_nid_t pin_nid,
@@ -617,9 +647,8 @@ static void hdmi_std_setup_channel_mapping(struct hda_codec *codec,
 	}
 
 	for (i = 0; i < 8; i++) {
-		err = snd_hda_codec_write(codec, pin_nid, 0,
-					  AC_VERB_SET_HDMI_CHAN_SLOT,
-					  non_pcm ? non_pcm_mapping[i] : hdmi_channel_mapping[ca][i]);
+		err = hdmi_set_chan_slot(codec, pin_nid,
+					 non_pcm ? non_pcm_mapping[i] : hdmi_channel_mapping[ca][i]);
 		if (err) {
 			snd_printdd(KERN_NOTICE
 				    "HDMI: channel mapping failed\n");
@@ -728,8 +757,7 @@ static int hdmi_manual_setup_channel_mapping(struct hda_codec *codec,
 		else
 			val = 0xf;
 		val |= (i << 4);
-		err = snd_hda_codec_write(codec, pin_nid, 0,
-					  AC_VERB_SET_HDMI_CHAN_SLOT, val);
+		err = hdmi_set_chan_slot(codec, pin_nid, val);
 		if (err)
 			return -EINVAL;
 	}
@@ -883,6 +911,8 @@ static bool hdmi_infoframe_uptodate(struct hda_codec *codec, hda_nid_t pin_nid,
 	return true;
 }
 
+static void atihdmi_set_ca(struct hda_codec *codec, hda_nid_t pin_nid, int ca);
+
 static void hdmi_setup_audio_infoframe(struct hda_codec *codec,
 				       struct hdmi_spec_per_pin *per_pin,
 				       bool non_pcm)
@@ -912,6 +942,16 @@ static void hdmi_setup_audio_infoframe(struct hda_codec *codec,
 	if (ca < 0)
 		ca = 0;
 
+	if (is_atihdmi(codec)) {
+		/* for ATI/AMD we just want to map channels and set ca */
+		hdmi_setup_channel_mapping(codec, pin_nid, non_pcm, ca,
+					   channels, per_pin->chmap,
+					   per_pin->chmap_set);
+		atihdmi_set_ca(codec, pin_nid, ca);
+		per_pin->non_pcm = non_pcm;
+		return;
+	}
+
 	memset(&ai, 0, sizeof(ai));
 	if (eld->info.conn_type == 0) { /* HDMI */
 		struct hdmi_audio_infoframe *hdmi_ai = &ai.hdmi;
@@ -1603,6 +1643,8 @@ static int hdmi_chmap_ctl_info(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
+static int atihdmi_swap_fc_lfe(int pos);
+
 static int hdmi_chmap_ctl_tlv(struct snd_kcontrol *kcontrol, int op_flag,
 			      unsigned int size, unsigned int __user *tlv)
 {
@@ -1613,6 +1655,10 @@ static int hdmi_chmap_ctl_tlv(struct snd_kcontrol *kcontrol, int op_flag,
 		FL | FR | RL | RR | LFE | FC | RLC | RRC;
 	unsigned int __user *dst;
 	int chs, count = 0;
+	int tlv_type = SNDRV_CTL_TLVT_CHMAP_VAR;
+
+	if (is_atihdmi(codec) && !has_amd_full_remap_support(codec))
+		tlv_type = SNDRV_CTL_TLVT_CHMAP_PAIRED;
 
 	if (size < 8)
 		return -ENOMEM;
@@ -1620,19 +1666,35 @@ static int hdmi_chmap_ctl_tlv(struct snd_kcontrol *kcontrol, int op_flag,
 		return -EFAULT;
 	size -= 8;
 	dst = tlv + 2;
-	for (chs = 2; chs <= spec->channels_max; chs++) {
+	for (chs = 2; chs <= spec->channels_max;
+	     chs += (tlv_type == SNDRV_CTL_TLVT_CHMAP_PAIRED) ? 2 : 1) {
 		int i, c;
 		struct cea_channel_speaker_allocation *cap;
 		cap = channel_allocations;
 		for (i = 0; i < ARRAY_SIZE(channel_allocations); i++, cap++) {
 			int chs_bytes = chs * 4;
-			if (cap->channels != chs)
+
+			if (tlv_type == SNDRV_CTL_TLVT_CHMAP_PAIRED) {
+				int chanpairs = 0;
+				/* in paired mode we need to take into account
+				 * the occupied channel pairs instead of just the
+				 * channel count */
+				for (c = 0; c < 7; c += 2) {
+					if (cap->speakers[c] || cap->speakers[c+1])
+						chanpairs++;
+				}
+				if (chanpairs * 2 != chs)
+					continue;
+
+			} else if (cap->channels != chs)
 				continue;
+
 			if (cap->spk_mask & ~valid_mask)
 				continue;
 			if (size < 8)
 				return -ENOMEM;
-			if (put_user(SNDRV_CTL_TLVT_CHMAP_VAR, dst) ||
+
+			if (put_user(tlv_type, dst) ||
 			    put_user(chs_bytes, dst + 1))
 				return -EFAULT;
 			dst += 2;
@@ -1643,10 +1705,27 @@ static int hdmi_chmap_ctl_tlv(struct snd_kcontrol *kcontrol, int op_flag,
 			size -= chs_bytes;
 			count += chs_bytes;
 			for (c = 7; c >= 0; c--) {
-				int spk = cap->speakers[c];
-				if (!spk)
-					continue;
-				if (put_user(spk_to_chmap(spk), dst))
+				int spk;
+				int chan = c;
+				int chpos;
+
+				if (tlv_type == SNDRV_CTL_TLVT_CHMAP_PAIRED)
+					chan = 7 - atihdmi_swap_fc_lfe(7 - chan);
+
+				spk = cap->speakers[chan];
+				if (spk)
+					chpos = spk_to_chmap(spk);
+				else {
+					/* We need to reserve an N/A channel in paired mode
+					 * if the companion channel is occupied. */
+					if (tlv_type == SNDRV_CTL_TLVT_CHMAP_PAIRED
+					    && cap->speakers[chan + (chan % 2 ? -1 : 1)])
+						chpos = SNDRV_CHMAP_NA;
+					else
+						continue;
+				}
+
+				if (put_user(chpos, dst))
 					return -EFAULT;
 				dst++;
 			}
@@ -1672,6 +1751,18 @@ static int hdmi_chmap_ctl_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
+static int atihdmi_pairwise_chmap_check_order(struct hda_codec *codec, int ca,
+					      int chs, unsigned char *map);
+
+static int hdmi_chmap_check_order(struct hda_codec *codec, int ca,
+				  int chs, unsigned char *map)
+{
+	if (is_atihdmi(codec) && !has_amd_full_remap_support(codec))
+		return atihdmi_pairwise_chmap_check_order(codec, ca, chs, map);
+
+	return 0; /* anything can be remapped as needed */
+}
+
 static int hdmi_chmap_ctl_put(struct snd_kcontrol *kcontrol,
 			      struct snd_ctl_elem_value *ucontrol)
 {
@@ -1683,7 +1774,7 @@ static int hdmi_chmap_ctl_put(struct snd_kcontrol *kcontrol,
 	unsigned int ctl_idx;
 	struct snd_pcm_substream *substream;
 	unsigned char chmap[8];
-	int i, ca, prepared = 0;
+	int i, err, ca, prepared = 0;
 
 	ctl_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
 	substream = snd_pcm_chmap_substream(info, ctl_idx);
@@ -1707,6 +1798,9 @@ static int hdmi_chmap_ctl_put(struct snd_kcontrol *kcontrol,
 	ca = hdmi_manual_channel_allocation(ARRAY_SIZE(chmap), chmap);
 	if (ca < 0)
 		return -EINVAL;
+	err = hdmi_chmap_check_order(codec, ca, ARRAY_SIZE(chmap), chmap);
+	if (err < 0)
+		return -EINVAL;
 	per_pin->chmap_set = true;
 	memcpy(per_pin->chmap, chmap, sizeof(chmap));
 	if (prepared)
@@ -2551,48 +2645,223 @@ static int patch_nvhdmi_8ch_7x(struct hda_codec *codec)
 
 /*
  * ATI-specific implementations
- *
- * FIXME: we may omit the whole this and use the generic code once after
- * it's confirmed to work.
  */
 
-#define ATIHDMI_CVT_NID		0x02	/* audio converter */
-#define ATIHDMI_PIN_NID		0x03	/* HDMI output pin */
+/* ATI/AMD specific HDA pin verbs, see the AMD HDA Verbs specification */
+#define ATI_VERB_SET_CHANNEL_ALLOCATION	0x771
+#define ATI_VERB_SET_DOWNMIX_INFO	0x772
+#define ATI_VERB_SET_MULTICHANNEL_01	0x777
+#define ATI_VERB_SET_MULTICHANNEL_23	0x778
+#define ATI_VERB_SET_MULTICHANNEL_45	0x779
+#define ATI_VERB_SET_MULTICHANNEL_67	0x77a
+#define ATI_VERB_SET_MULTICHANNEL_1	0x785
+#define ATI_VERB_SET_MULTICHANNEL_3	0x786
+#define ATI_VERB_SET_MULTICHANNEL_5	0x787
+#define ATI_VERB_SET_MULTICHANNEL_7	0x788
+#define ATI_VERB_SET_MULTICHANNEL_MODE	0x789
+#define ATI_VERB_GET_CHANNEL_ALLOCATION	0xf71
+#define ATI_VERB_GET_DOWNMIX_INFO	0xf72
+#define ATI_VERB_GET_MULTICHANNEL_01	0xf77
+#define ATI_VERB_GET_MULTICHANNEL_23	0xf78
+#define ATI_VERB_GET_MULTICHANNEL_45	0xf79
+#define ATI_VERB_GET_MULTICHANNEL_67	0xf7a
+#define ATI_VERB_GET_MULTICHANNEL_1	0xf85
+#define ATI_VERB_GET_MULTICHANNEL_3	0xf86
+#define ATI_VERB_GET_MULTICHANNEL_5	0xf87
+#define ATI_VERB_GET_MULTICHANNEL_7	0xf88
+#define ATI_VERB_GET_MULTICHANNEL_MODE	0xf89
+
+#define ATI_OUT_ENABLE 0x1
+
+static void atihdmi_set_ca(struct hda_codec *codec, hda_nid_t pin_nid, int ca)
+{
+	printk("ATI: setting ca %d\n", ca);
+	snd_hda_codec_write(codec, pin_nid, 0, ATI_VERB_SET_CHANNEL_ALLOCATION, ca);
+}
+
+static int atihdmi_swap_fc_lfe(int pos)
+{
+	/*
+	 * Older ATI/AMD without channel-wise mapping
+	 * have automatic FC/LFE swap built-in.
+	 */
+
+	switch (pos) {
+		/* see channel_allocations[].speakers[] */
+		case 2: return 3;
+		case 3: return 2;
+		default: break;
+	}
+
+	return pos;
+}
 
-static int atihdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
-					struct hda_codec *codec,
-					unsigned int stream_tag,
-					unsigned int format,
-					struct snd_pcm_substream *substream)
+static int atihdmi_pairwise_chmap_check_order(struct hda_codec *codec, int ca,
+					      int chs, unsigned char *map)
+{
+	struct cea_channel_speaker_allocation *cap;
+	int i, j;
+
+	/* check that only channel pairs need to be remapped on old ATI/AMD */
+
+	cap = &channel_allocations[get_channel_allocation_order(ca)];
+	for (i = 0; i < chs; ++i) {
+		int mask = to_spk_mask(map[i]);
+		bool ok = false;
+		bool companion_ok = false;
+
+		if (!mask)
+			continue;
+
+		for (j = 0 + i % 2; j < 8; j += 2) {
+			int chan_idx = 7 - atihdmi_swap_fc_lfe(j);
+			if (cap->speakers[chan_idx] == mask) {
+				/* channel is in a supported position */
+				ok = true;
+
+				if (i % 2 == 0 && i + 1 < chs) {
+					/* even channel, check the odd companion */
+					int comp_chan_idx = 7 - atihdmi_swap_fc_lfe(j + 1);
+					int comp_mask_req = to_spk_mask(map[i+1]);
+					int comp_mask_act = cap->speakers[comp_chan_idx];
+
+					if (comp_mask_req == comp_mask_act)
+						companion_ok = true;
+					else
+						return -EINVAL;
+				}
+				break;
+			}
+		}
+
+		if (!ok)
+			return -EINVAL;
+
+		if (companion_ok)
+			i++; /* companion channel already checked */
+	}
+
+	return 0;
+}
+
+static int atihdmi_set_chan_slot(struct hda_codec *codec, hda_nid_t pin_nid,
+				 int chanslot_setup)
+{
+	int hdmi_slot = chanslot_setup & 0xf;
+	int stream_channel = chanslot_setup >> 4;
+	int verb;
+	int ati_channel_setup = 0;
+
+	if (hdmi_slot > 7)
+		return -EINVAL;
+
+	if (!has_amd_full_remap_support(codec)) {
+		hdmi_slot = atihdmi_swap_fc_lfe(hdmi_slot);
+
+		/* In case this is an odd slot but without stream channel, do not
+		 * disable the slot since the corresponding even slot could have a
+		 * channel. In case neither have a channel, the slot pair will be
+		 * disabled when this function is called for the even slot. */
+		if (hdmi_slot % 2 != 0 && stream_channel == 0xf)
+			return 0;
+
+		hdmi_slot -= hdmi_slot % 2;
+
+		if (stream_channel != 0xf)
+			stream_channel -= stream_channel % 2;
+	}
+
+	verb = ATI_VERB_SET_MULTICHANNEL_01 + hdmi_slot/2 + (hdmi_slot % 2) * 0x00e;
+
+	/* ati_channel_setup format: [7..4] = stream_channel_id, [1] = mute, [0] = enable */
+
+	if (stream_channel != 0xf)
+		ati_channel_setup = (stream_channel << 4) | ATI_OUT_ENABLE;
+
+	return snd_hda_codec_write(codec, pin_nid, 0, verb, ati_channel_setup);
+}
+
+#ifdef CONFIG_SND_DEBUG_VERBOSE
+static int atihdmi_get_chan_slot(struct hda_codec *codec, hda_nid_t pin_nid, int asp_slot)
+{
+	bool was_odd = false;
+	int ati_asp_slot = asp_slot;
+	int verb;
+	int ati_channel_setup;
+
+	/* emulate AC_VERB_GET_HDMI_CHAN_SLOT */
+
+	if (asp_slot > 7)
+		return -EINVAL;
+
+	if (!has_amd_full_remap_support(codec)) {
+		ati_asp_slot = atihdmi_swap_fc_lfe(asp_slot);
+		if (ati_asp_slot % 2 != 0) {
+			ati_asp_slot -= 1;
+			was_odd = true;
+		}
+	}
+
+	verb = ATI_VERB_GET_MULTICHANNEL_01 + ati_asp_slot/2 + (ati_asp_slot % 2) * 0x00e;
+
+	ati_channel_setup = snd_hda_codec_read(codec, pin_nid, 0, verb, 0);
+
+	if (!(ati_channel_setup & ATI_OUT_ENABLE))
+		return (0xf << 4) | asp_slot;
+
+	return ((ati_channel_setup & 0xf0) + ((!!was_odd) << 4)) | asp_slot;
+}
+#endif
+
+static int atihdmi_init(struct hda_codec *codec)
 {
 	struct hdmi_spec *spec = codec->spec;
-	struct hdmi_spec_per_cvt *per_cvt = get_cvt(spec, 0);
-	int chans = substream->runtime->channels;
-	int i, err;
+	int pin_idx, err;
 
-	err = simple_playback_pcm_prepare(hinfo, codec, stream_tag, format,
-					  substream);
-	if (err < 0)
+	err = generic_hdmi_init(codec);
+
+	if (err)
 		return err;
-	snd_hda_codec_write(codec, per_cvt->cvt_nid, 0,
-			    AC_VERB_SET_CVT_CHAN_COUNT, chans - 1);
-	/* FIXME: XXX */
-	for (i = 0; i < chans; i++) {
-		snd_hda_codec_write(codec, per_cvt->cvt_nid, 0,
-				    AC_VERB_SET_HDMI_CHAN_SLOT,
-				    (i << 4) | i);
+
+	for (pin_idx = 0; pin_idx < spec->num_pins; pin_idx++) {
+		struct hdmi_spec_per_pin *per_pin = get_pin(spec, pin_idx);
+
+		/* make sure downmix information in infoframe is zero */
+		snd_hda_codec_write(codec, per_pin->pin_nid, 0, ATI_VERB_SET_DOWNMIX_INFO, 0);
+
+		/* enable channel-wise remap mode if supported */
+		if (has_amd_full_remap_support(codec))
+			snd_hda_codec_write(codec, per_pin->pin_nid, 0, ATI_VERB_SET_MULTICHANNEL_MODE, 1);
 	}
+
 	return 0;
 }
 
 static int patch_atihdmi(struct hda_codec *codec)
 {
 	struct hdmi_spec *spec;
-	int err = patch_simple_hdmi(codec, ATIHDMI_CVT_NID, ATIHDMI_PIN_NID);
-	if (err < 0)
+	struct hdmi_spec_per_cvt *per_cvt;
+	int err, cvt_idx;
+
+	err = patch_generic_hdmi(codec);
+
+	if (err)
 		return err;
+
+	codec->patch_ops.init = atihdmi_init;
+
+	/* ATI/AMD converters do not advertise all of their capabilities */
 	spec = codec->spec;
-	spec->pcm_playback.ops.prepare = atihdmi_playback_pcm_prepare;
+	for (cvt_idx = 0; cvt_idx < spec->num_cvts; cvt_idx++) {
+		per_cvt = get_cvt(spec, cvt_idx);
+		per_cvt->channels_max = max(per_cvt->channels_max, 8u);
+		per_cvt->rates |= SUPPORTED_RATES;
+		per_cvt->formats |= SUPPORTED_FORMATS;
+		per_cvt->maxbps = max(per_cvt->maxbps, 24u);
+	}
+
+	spec->channels_max = max(spec->channels_max, 8u);
+
 	return 0;
 }
 
@@ -2612,7 +2881,7 @@ static const struct hda_codec_preset snd_hda_preset_hdmi[] = {
 { .id = 0x1002793c, .name = "RS600 HDMI",	.patch = patch_atihdmi },
 { .id = 0x10027919, .name = "RS600 HDMI",	.patch = patch_atihdmi },
 { .id = 0x1002791a, .name = "RS690/780 HDMI",	.patch = patch_atihdmi },
-{ .id = 0x1002aa01, .name = "R6xx HDMI",	.patch = patch_generic_hdmi },
+{ .id = 0x1002aa01, .name = "R6xx HDMI",	.patch = patch_atihdmi },
 { .id = 0x10951390, .name = "SiI1390 HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x10951392, .name = "SiI1392 HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x17e80047, .name = "Chrontel HDMI",	.patch = patch_generic_hdmi },
-- 
1.8.1.5

