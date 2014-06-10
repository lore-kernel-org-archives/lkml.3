Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaFJTwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:52:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35349 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbaFJTv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 153/160] ALSA: hda - hdmi: Set converter channel count even without sink
Date: Tue, 10 Jun 2014 12:46:33 -0700
Message-Id: <1402429600-20477-154-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 6baac44..a21a325 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1120,8 +1120,10 @@ static void hdmi_setup_audio_infoframe(struct hda_codec *codec,
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
1.9.1

