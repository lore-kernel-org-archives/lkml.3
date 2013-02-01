Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161049Ab3BAKsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:48:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:38694 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422682Ab3BAKsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:48:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Hanisch <fhanisch@uni-potsdam.de>,
        Matthew Robbetts <wingfeathera@gmail.com>,
        Michael Beer <beerml@sigma6audio.de>, Daniel Mack <daniel@caiaq.de>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 09/15] ALSA: usb-audio: fix invalid length check for RME and other UAC 2 devices
Date: Fri,  1 Feb 2013 11:48:42 +0100
Message-Id: <20130201104757.141048264@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104756.470588207@linuxfoundation.org>
References: <20130201104756.470588207@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit d56268fb108c7c21e19933588ca4d94652585183 upstream.

Commit 23caaf19b11e (ALSA: usb-mixer: Add support for Audio Class v2.0)
forgot to adjust the length check for UAC 2.0 feature unit descriptors.
This would make the code abort on encountering a feature unit without
per-channel controls, and thus prevented the driver to work with any
device having such a unit, such as the RME Babyface or Fireface UCX.

Reported-by: Florian Hanisch <fhanisch@uni-potsdam.de>
Tested-by: Matthew Robbetts <wingfeathera@gmail.com>
Tested-by: Michael Beer <beerml@sigma6audio.de>
Cc: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1238,16 +1238,23 @@ static int parse_audio_feature_unit(stru
 		}
 		channels = (hdr->bLength - 7) / csize - 1;
 		bmaControls = hdr->bmaControls;
+		if (hdr->bLength < 7 + csize) {
+			snd_printk(KERN_ERR "usbaudio: unit %u: "
+				   "invalid UAC_FEATURE_UNIT descriptor\n",
+				   unitid);
+			return -EINVAL;
+		}
 	} else {
 		struct uac2_feature_unit_descriptor *ftr = _ftr;
 		csize = 4;
 		channels = (hdr->bLength - 6) / 4 - 1;
 		bmaControls = ftr->bmaControls;
-	}
-
-	if (hdr->bLength < 7 || !csize || hdr->bLength < 7 + csize) {
-		snd_printk(KERN_ERR "usbaudio: unit %u: invalid UAC_FEATURE_UNIT descriptor\n", unitid);
-		return -EINVAL;
+		if (hdr->bLength < 6 + csize) {
+			snd_printk(KERN_ERR "usbaudio: unit %u: "
+				   "invalid UAC_FEATURE_UNIT descriptor\n",
+				   unitid);
+			return -EINVAL;
+		}
 	}
 
 	/* parse the source unit */


