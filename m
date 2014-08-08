Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbaHHWfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:35:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40083 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbaHHUlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mengdong Lin <mengdong.lin@intel.com>, Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 014/259] ALSA: hda - verify pin:cvt connection on preparing a stream for Intel HDMI codec
Date: Fri,  8 Aug 2014 13:37:17 -0700
Message-Id: <1407530482-4483-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengdong Lin <mengdong.lin@intel.com>

commit 2df6742f613840a0b0a1590fb28f7af5b058a673 upstream.

This is a temporary fix for some Intel HDMI codecs to avoid no sound output for
a resuming playback after S3.

After S3, the audio driver restores pin:cvt connection selections by
snd_hda_codec_resume_cache(). However this can happen before the gfx side is
ready and such connect selection is overlooked by HW. After gfx is ready, the
pins make the default selection again. And this will cause multiple pins share
a same convertor and mute control will affect each other. Thus a resumed audio
playback become silent after S3.

This patch verifies pin:cvt connection on preparing a stream, to assure the pin
selects the right convetor and an assigned convertor is not shared by other
unused pins. Apply this fix-up on Haswell, Broadwell and Valleyview (Baytrail).

We need this temporary fix before a reliable software communication channel is
established between audio and gfx, to sync audio/gfx operations.

Signed-off-by: Mengdong Lin <mengdong.lin@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 5cef6e1..9c67b07 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -68,6 +68,7 @@ struct hdmi_spec_per_pin {
 	hda_nid_t pin_nid;
 	int num_mux_nids;
 	hda_nid_t mux_nids[HDA_MAX_CONNECTIONS];
+	int mux_idx;
 	hda_nid_t cvt_nid;
 
 	struct hda_codec *codec;
@@ -1343,6 +1344,8 @@ static int hdmi_choose_cvt(struct hda_codec *codec,
 	if (cvt_idx == spec->num_cvts)
 		return -ENODEV;
 
+	per_pin->mux_idx = mux_idx;
+
 	if (cvt_id)
 		*cvt_id = cvt_idx;
 	if (mux_id)
@@ -1351,6 +1354,22 @@ static int hdmi_choose_cvt(struct hda_codec *codec,
 	return 0;
 }
 
+/* Assure the pin select the right convetor */
+static void intel_verify_pin_cvt_connect(struct hda_codec *codec,
+			struct hdmi_spec_per_pin *per_pin)
+{
+	hda_nid_t pin_nid = per_pin->pin_nid;
+	int mux_idx, curr;
+
+	mux_idx = per_pin->mux_idx;
+	curr = snd_hda_codec_read(codec, pin_nid, 0,
+					  AC_VERB_GET_CONNECT_SEL, 0);
+	if (curr != mux_idx)
+		snd_hda_codec_write_cache(codec, pin_nid, 0,
+					    AC_VERB_SET_CONNECT_SEL,
+					    mux_idx);
+}
+
 /* Intel HDMI workaround to fix audio routing issue:
  * For some Intel display codecs, pins share the same connection list.
  * So a conveter can be selected by multiple pins and playback on any of these
@@ -1775,6 +1794,19 @@ static int generic_hdmi_playback_pcm_prepare(struct hda_pcm_stream *hinfo,
 	bool non_pcm;
 	int pinctl;
 
+	if (is_haswell_plus(codec) || is_valleyview(codec)) {
+		/* Verify pin:cvt selections to avoid silent audio after S3.
+		 * After S3, the audio driver restores pin:cvt selections
+		 * but this can happen before gfx is ready and such selection
+		 * is overlooked by HW. Thus multiple pins can share a same
+		 * default convertor and mute control will affect each other,
+		 * which can cause a resumed audio playback become silent
+		 * after S3.
+		 */
+		intel_verify_pin_cvt_connect(codec, per_pin);
+		intel_not_share_assigned_cvt(codec, pin_nid, per_pin->mux_idx);
+	}
+
 	non_pcm = check_non_pcm_per_cvt(codec, cvt_nid);
 	mutex_lock(&per_pin->lock);
 	per_pin->channels = substream->runtime->channels;
-- 
1.9.1

