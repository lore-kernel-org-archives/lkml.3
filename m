Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbaFEARX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:17:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaFDXWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anssi Hannula <anssi.hannula@iki.fi>,
        Stephan Raue <stephan@openelec.tv>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 146/228] ALSA: hda - hdmi: Set converter channel count even without sink
Date: Wed,  4 Jun 2014 16:22:55 -0700
Message-Id: <20140604232352.714226121@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1123,8 +1123,10 @@ static void hdmi_setup_audio_infoframe(s
 					    AMP_OUT_UNMUTE);
 
 	eld = &per_pin->sink_eld;
-	if (!eld->monitor_present)
+	if (!eld->monitor_present) {
+		hdmi_set_channel_count(codec, per_pin->cvt_nid, channels);
 		return;
+	}
 
 	if (!non_pcm && per_pin->chmap_set)
 		ca = hdmi_manual_channel_allocation(channels, per_pin->chmap);


