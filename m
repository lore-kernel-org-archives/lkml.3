Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaBGDmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 22:42:03 -0500
Received: from mail-ob0-f201.google.com ([209.85.214.201]:57266 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaBGDmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 22:42:01 -0500
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Feb 2014 22:42:00 EST
From: Hsin-Yu Chao <hychao@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dylan Reid <dgreid@chromium.org>,
        Chih-Chung Chang <chihchung@chromium.org>, Xi Wang <xi.wang@gmail.com>,
        Hsin-Yu Chao <hychao@chromium.org>,
        Ian Minett <ian_minett@creativelabs.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ALSA: hda/ca0132 - setup/cleanup streams
Date: Fri,  7 Feb 2014 11:35:29 +0800
Message-Id: <1391744130-15043-1-git-send-email-hychao@chromium.org>
X-Mailer: git-send-email 1.9.0.rc1.175.g0b1dcb5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a HDMI stream is opened with the same stream tag
as a following opened stream to ca0132, audio will be
heard from two ports simultaneously.
Fix this issue by change to use snd_hda_codec_setup_stream
and snd_hda_codec_cleanup_stream instead, so that an
inactive stream can be marked as 'dirty' when found
with a conflict stream tag, and then get purified.

Signed-off-by: Hsin-Yu Chao <hychao@chromium.org>
Reviewed-by: Chih-Chung Chang <chihchung@chromium.org>
---
 sound/pci/hda/patch_ca0132.c | 68 ++++++--------------------------------------
 1 file changed, 9 insertions(+), 59 deletions(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 54d1479..59104dc 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2662,60 +2662,6 @@ static bool dspload_wait_loaded(struct hda_codec *codec)
 }
 
 /*
- * PCM stuffs
- */
-static void ca0132_setup_stream(struct hda_codec *codec, hda_nid_t nid,
-				 u32 stream_tag,
-				 int channel_id, int format)
-{
-	unsigned int oldval, newval;
-
-	if (!nid)
-		return;
-
-	snd_printdd(
-		   "ca0132_setup_stream: NID=0x%x, stream=0x%x, "
-		   "channel=%d, format=0x%x\n",
-		   nid, stream_tag, channel_id, format);
-
-	/* update the format-id if changed */
-	oldval = snd_hda_codec_read(codec, nid, 0,
-				    AC_VERB_GET_STREAM_FORMAT,
-				    0);
-	if (oldval != format) {
-		msleep(20);
-		snd_hda_codec_write(codec, nid, 0,
-				    AC_VERB_SET_STREAM_FORMAT,
-				    format);
-	}
-
-	oldval = snd_hda_codec_read(codec, nid, 0, AC_VERB_GET_CONV, 0);
-	newval = (stream_tag << 4) | channel_id;
-	if (oldval != newval) {
-		snd_hda_codec_write(codec, nid, 0,
-				    AC_VERB_SET_CHANNEL_STREAMID,
-				    newval);
-	}
-}
-
-static void ca0132_cleanup_stream(struct hda_codec *codec, hda_nid_t nid)
-{
-	unsigned int val;
-
-	if (!nid)
-		return;
-
-	snd_printdd(KERN_INFO "ca0132_cleanup_stream: NID=0x%x\n", nid);
-
-	val = snd_hda_codec_read(codec, nid, 0, AC_VERB_GET_CONV, 0);
-	if (!val)
-		return;
-
-	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_STREAM_FORMAT, 0);
-	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_CHANNEL_STREAMID, 0);
-}
-
-/*
  * PCM callbacks
  */
 static int ca0132_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
@@ -2726,7 +2672,9 @@ static int ca0132_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	ca0132_setup_stream(codec, spec->dacs[0], stream_tag, 0, format);
+	ca0132_toggle_dac_format(codec);
+
+	snd_hda_codec_setup_stream(codec, spec->dacs[0], stream_tag, 0, format);
 
 	return 0;
 }
@@ -2745,7 +2693,7 @@ static int ca0132_playback_pcm_cleanup(struct hda_pcm_stream *hinfo,
 	if (spec->effects_switch[PLAY_ENHANCEMENT - EFFECT_START_NID])
 		msleep(50);
 
-	ca0132_cleanup_stream(codec, spec->dacs[0]);
+	snd_hda_codec_cleanup_stream(codec, spec->dacs[0]);
 
 	return 0;
 }
@@ -2824,8 +2772,8 @@ static int ca0132_capture_pcm_prepare(struct hda_pcm_stream *hinfo,
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	ca0132_setup_stream(codec, spec->adcs[substream->number],
-			    stream_tag, 0, format);
+	snd_hda_codec_setup_stream(codec, spec->adcs[substream->number],
+				   stream_tag, 0, format);
 
 	return 0;
 }
@@ -2839,7 +2787,7 @@ static int ca0132_capture_pcm_cleanup(struct hda_pcm_stream *hinfo,
 	if (spec->dsp_state == DSP_DOWNLOADING)
 		return 0;
 
-	ca0132_cleanup_stream(codec, hinfo->nid);
+	snd_hda_codec_cleanup_stream(codec, hinfo->nid);
 	return 0;
 }
 
@@ -4742,6 +4690,8 @@ static int patch_ca0132(struct hda_codec *codec)
 		return err;
 
 	codec->patch_ops = ca0132_patch_ops;
+	codec->pcm_format_first = 1;
+	codec->no_sticky_stream = 1;
 
 	return 0;
 }
-- 
1.9.0.rc1.175.g0b1dcb5

