Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3J2S0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:26:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3J2SFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 07/81] ALSA: hda - hdmi: Fix channel map switch not taking effect
Date: Tue, 29 Oct 2013 11:03:28 -0700
Message-Id: <1383069882-11437-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit 39edac70e9aedf451fccaa851b273ace9fcca0bd upstream.

Currently hdmi_setup_audio_infoframe() reprograms the HDA channel
mapping only when the infoframe is not up-to-date or the non-PCM flag
has changed.

However, when just the channel map has been changed, the infoframe may
still be up-to-date and non-PCM flag may not have changed, so the new
channel map is not actually programmed into the HDA codec.

Notably, this failing case is also always triggered when the device is
already in a prepared state and a new channel map is configured while
changing only the channel positions (for example, plain
"speaker-test -c2 -m FR,FL").

Fix that by always programming the channel map in
hdmi_setup_audio_infoframe(). Tested on Intel HDMI.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 40f5e2d..01b98b0 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -906,6 +906,14 @@ static void hdmi_setup_audio_infoframe(struct hda_codec *codec, int pin_idx,
 	}
 
 	/*
+	 * always configure channel mapping, it may have been changed by the
+	 * user in the meantime
+	 */
+	hdmi_setup_channel_mapping(codec, pin_nid, non_pcm, ca,
+				   channels, per_pin->chmap,
+				   per_pin->chmap_set);
+
+	/*
 	 * sizeof(ai) is used instead of sizeof(*hdmi_ai) or
 	 * sizeof(*dp_ai) to avoid partial match/update problems when
 	 * the user switches between HDMI/DP monitors.
@@ -916,20 +924,10 @@ static void hdmi_setup_audio_infoframe(struct hda_codec *codec, int pin_idx,
 			    "pin=%d channels=%d\n",
 			    pin_nid,
 			    channels);
-		hdmi_setup_channel_mapping(codec, pin_nid, non_pcm, ca,
-					   channels, per_pin->chmap,
-					   per_pin->chmap_set);
 		hdmi_stop_infoframe_trans(codec, pin_nid);
 		hdmi_fill_audio_infoframe(codec, pin_nid,
 					    ai.bytes, sizeof(ai));
 		hdmi_start_infoframe_trans(codec, pin_nid);
-	} else {
-		/* For non-pcm audio switch, setup new channel mapping
-		 * accordingly */
-		if (per_pin->non_pcm != non_pcm)
-			hdmi_setup_channel_mapping(codec, pin_nid, non_pcm, ca,
-						   channels, per_pin->chmap,
-						   per_pin->chmap_set);
 	}
 
 	per_pin->non_pcm = non_pcm;
-- 
1.8.1.2

