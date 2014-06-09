Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbaFII6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58542 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anssi Hannula <anssi.hannula@iki.fi>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 095/146] ALSA: hda - hdmi: Set converter channel count even without sink
Date: Mon,  9 Jun 2014 10:50:30 +0200
Message-Id: <33d531477c11345db670fe7f2d9c5910773a1789.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anssi Hannula <anssi.hannula@iki.fi>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f06ab794af7055d0949b09885f79f8b493deec64 upstream.

Since commit 1df5a06a ("ALSA: hda - hdmi: Fix programmed active channel
count") channel count is no longer being set if monitor_present is 0.
This is because setting the count was moved after the CA value is
determined, which is only after the monitor_present check in
hdmi_setup_audio_infoframe().

Unfortunately, in some cases, such as with a non-spec-compliant codec or
with a problematic video driver, monitor_present is always 0. As a
specific example, this seems to happen with gen1 ATV (SiI1390 codec),
causing left-channel-only stereo playback (multi-channel playback has
apparently never worked with this codec despite it reporting 8 channels,
reason unknown).

Simply setting converter channel count without setting the pin infoframe
and channel mapping as well does not theoretically make much sense as
this will just mean they are out-of-sync and multichannel playback will
have a wrong channel mapping.

However, adding back just setting the converter channel count even in
no-monitor case is the safest change which at least fixes the stereo
playback regression on SiI1390 codec. Do that.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Reported-by: Stephan Raue <stephan@openelec.tv>
Tested-by: Stephan Raue <stephan@openelec.tv>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_hdmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 23e0bc6d6568..2949c8d34d33 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1023,8 +1023,10 @@ static void hdmi_setup_audio_infoframe(struct hda_codec *codec,
 					    AMP_OUT_UNMUTE);
 
 	eld = &per_pin->sink_eld;
-	if (!eld->monitor_present)
+	if (!eld->monitor_present) {
+		hdmi_set_channel_count(codec, per_pin->cvt_nid, channels);
 		return;
+	}
 
 	if (!non_pcm && per_pin->chmap_set)
 		ca = hdmi_manual_channel_allocation(channels, per_pin->chmap);
-- 
1.9.3

