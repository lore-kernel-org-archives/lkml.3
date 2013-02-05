Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab3BEWLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:11:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab3BEWLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:11:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Mack <daniel@caiaq.de>, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 62/93] ALSA: usb-audio: fix invalid length check for RME and other UAC 2 devices
Date: Tue,  5 Feb 2013 20:06:51 -0200
Message-Id: <1360102042-10732-63-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/usb/mixer.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 298070e..41e8bfb 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1259,16 +1259,23 @@ static int parse_audio_feature_unit(struct mixer_build *state, int unitid, void
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
-- 
1.7.9.5

