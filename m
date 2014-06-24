Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaFXP6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:58:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbaFXP5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:57:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mengdong Lin <mengdong.lin@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.15 53/61] ALSA: hda - verify pin:converter connection on unsol event for HSW and VLV
Date: Tue, 24 Jun 2014 11:51:36 -0400
Message-Id: <20140624154955.207546097@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengdong Lin <mengdong.lin@intel.com>

commit b4f75aea553a2146bbdd159c397a2ac42cbb9902 upstream.

This patch will verify the pin's coverter selection for an active stream
when an unsol event reports this pin becomes available again after a display
mode change or hot-plug event.

For Haswell+ and Valleyview: display mode change or hot-plug can change the
transcoder:port connection and make all the involved audio pins share the 1st
converter. So the stream using 1st convertor will flow to multiple pins
but active streams using other converters will fail. This workaround
is to assure the pin selects the right conveter and an assigned converter is
not shared by other unused pins.

Signed-off-by: Mengdong Lin <mengdong.lin@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1598,10 +1598,18 @@ static bool hdmi_present_sense(struct hd
 		 * Re-setup pin and infoframe. This is needed e.g. when
 		 * - sink is first plugged-in (infoframe is not set up if !monitor_present)
 		 * - transcoder can change during stream playback on Haswell
+		 *   and this can make HW reset converter selection on a pin.
 		 */
-		if (eld->eld_valid && !old_eld_valid && per_pin->setup)
+		if (eld->eld_valid && !old_eld_valid && per_pin->setup) {
+			if (is_haswell_plus(codec) || is_valleyview(codec)) {
+				intel_verify_pin_cvt_connect(codec, per_pin);
+				intel_not_share_assigned_cvt(codec, pin_nid,
+							per_pin->mux_idx);
+			}
+
 			hdmi_setup_audio_infoframe(codec, per_pin,
 						   per_pin->non_pcm);
+		}
 	}
 
 	if (eld_changed)


