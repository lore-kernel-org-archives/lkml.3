Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3BCPBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:01:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34623 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753650Ab3BCO6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:25 -0500
Message-Id: <20130203144652.800844922@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Clemens Ladisch <clemens@ladisch.de>,
        Florian Hanisch <fhanisch@uni-potsdam.de>,
        Matthew Robbetts <wingfeathera@gmail.com>,
        Michael Beer <beerml@sigma6audio.de>, Daniel Mack <daniel@caiaq.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 099/128] ALSA: usb-audio: fix invalid length check for RME and other UAC 2
 devices
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/mixer.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index ed4d89c..e90daf8 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1331,16 +1331,23 @@ static int parse_audio_feature_unit(struct mixer_build *state, int unitid, void
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


