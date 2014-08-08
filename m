Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769AbaHHWfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:35:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40088 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbaHHUlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mengdong Lin <mengdong.lin@intel.com>, Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 013/259] ALSA: hda - verify pin:converter connection on unsol event for HSW and VLV
Date: Fri,  8 Aug 2014 13:37:16 -0700
Message-Id: <1407530482-4483-14-git-send-email-kamal@canonical.com>
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
Cc: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 65d6dc0..5cef6e1 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1576,10 +1576,18 @@ static bool hdmi_present_sense(struct hdmi_spec_per_pin *per_pin, int repoll)
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
-- 
1.9.1

