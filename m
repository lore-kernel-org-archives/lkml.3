Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbaCDU3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:29:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbaCDUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hsin-Yu Chao <hychao@chromium.org>,
        Chih-Chung Chang <chihchung@chromium.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 41/97] ALSA: hda/ca0132 - setup/cleanup streams
Date: Tue,  4 Mar 2014 12:03:54 -0800
Message-Id: <20140304200347.401251662@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |   66 ++++---------------------------------------
 1 file changed, 7 insertions(+), 59 deletions(-)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2662,60 +2662,6 @@ static bool dspload_wait_loaded(struct h
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
@@ -2726,7 +2672,7 @@ static int ca0132_playback_pcm_prepare(s
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	ca0132_setup_stream(codec, spec->dacs[0], stream_tag, 0, format);
+	snd_hda_codec_setup_stream(codec, spec->dacs[0], stream_tag, 0, format);
 
 	return 0;
 }
@@ -2745,7 +2691,7 @@ static int ca0132_playback_pcm_cleanup(s
 	if (spec->effects_switch[PLAY_ENHANCEMENT - EFFECT_START_NID])
 		msleep(50);
 
-	ca0132_cleanup_stream(codec, spec->dacs[0]);
+	snd_hda_codec_cleanup_stream(codec, spec->dacs[0]);
 
 	return 0;
 }
@@ -2824,8 +2770,8 @@ static int ca0132_capture_pcm_prepare(st
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	ca0132_setup_stream(codec, spec->adcs[substream->number],
-			    stream_tag, 0, format);
+	snd_hda_codec_setup_stream(codec, spec->adcs[substream->number],
+				   stream_tag, 0, format);
 
 	return 0;
 }
@@ -2839,7 +2785,7 @@ static int ca0132_capture_pcm_cleanup(st
 	if (spec->dsp_state == DSP_DOWNLOADING)
 		return 0;
 
-	ca0132_cleanup_stream(codec, hinfo->nid);
+	snd_hda_codec_cleanup_stream(codec, hinfo->nid);
 	return 0;
 }
 
@@ -4742,6 +4688,8 @@ static int patch_ca0132(struct hda_codec
 		return err;
 
 	codec->patch_ops = ca0132_patch_ops;
+	codec->pcm_format_first = 1;
+	codec->no_sticky_stream = 1;
 
 	return 0;
 }


