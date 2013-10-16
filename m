Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935147Ab3JPSEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:04:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab3JPRqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>
Subject: [ 02/50] ALSA: hda - hdmi: Fix channel map switch not taking effect
Date: Wed, 16 Oct 2013 10:44:48 -0700
Message-Id: <20131016174358.650055327@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -930,6 +930,14 @@ static void hdmi_setup_audio_infoframe(s
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
@@ -940,20 +948,10 @@ static void hdmi_setup_audio_infoframe(s
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


