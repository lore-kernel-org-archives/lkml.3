Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbaCEOZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:25:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40982 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbaCEOZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hsin-Yu Chao <hychao@chromium.org>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 059/131] ALSA: hda/ca0132 - setup/cleanup streams
Date: Wed,  5 Mar 2014 14:23:03 +0000
Message-Id: <1394029455-23128-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yu Chao <hychao@chromium.org>

commit 28fba95087a7f3d107a3a6728aef7dbfaf3fd782 upstream.

When a HDMI stream is opened with the same stream tag
as a following opened stream to ca0132, audio will be
heard from two ports simultaneously.
Fix this issue by change to use snd_hda_codec_setup_stream
and snd_hda_codec_cleanup_stream instead, so that an
inactive stream can be marked as 'dirty' when found
with a conflict stream tag, and then get purified.

Signed-off-by: Hsin-Yu Chao <hychao@chromium.org>
Reviewed-by: Chih-Chung Chang <chihchung@chromium.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_ca0132.c | 66 +++++---------------------------------------
 1 file changed, 7 insertions(+), 59 deletions(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 6e9876f..1e1e4b2 100644
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
@@ -2726,7 +2672,7 @@ static int ca0132_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	ca0132_setup_stream(codec, spec->dacs[0], stream_tag, 0, format);
+	snd_hda_codec_setup_stream(codec, spec->dacs[0], stream_tag, 0, format);
 
 	return 0;
 }
@@ -2745,7 +2691,7 @@ static int ca0132_playback_pcm_cleanup(struct hda_pcm_stream *hinfo,
 	if (spec->effects_switch[PLAY_ENHANCEMENT - EFFECT_START_NID])
 		msleep(50);
 
-	ca0132_cleanup_stream(codec, spec->dacs[0]);
+	snd_hda_codec_cleanup_stream(codec, spec->dacs[0]);
 
 	return 0;
 }
@@ -2824,8 +2770,8 @@ static int ca0132_capture_pcm_prepare(struct hda_pcm_stream *hinfo,
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	ca0132_setup_stream(codec, spec->adcs[substream->number],
-			    stream_tag, 0, format);
+	snd_hda_codec_setup_stream(codec, spec->adcs[substream->number],
+				   stream_tag, 0, format);
 
 	return 0;
 }
@@ -2839,7 +2785,7 @@ static int ca0132_capture_pcm_cleanup(struct hda_pcm_stream *hinfo,
 	if (spec->dsp_state == DSP_DOWNLOADING)
 		return 0;
 
-	ca0132_cleanup_stream(codec, hinfo->nid);
+	snd_hda_codec_cleanup_stream(codec, hinfo->nid);
 	return 0;
 }
 
@@ -4742,6 +4688,8 @@ static int patch_ca0132(struct hda_codec *codec)
 		return err;
 
 	codec->patch_ops = ca0132_patch_ops;
+	codec->pcm_format_first = 1;
+	codec->no_sticky_stream = 1;
 
 	return 0;
 }
-- 
1.9.0

