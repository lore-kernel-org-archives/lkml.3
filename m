Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbbA2JIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:08:49 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44935 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932760AbbA2JIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:43 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Jaburek <jjaburek@redhat.com>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 029/176] ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC
Date: Wed, 28 Jan 2015 15:27:39 +0100
Message-Id: <3d041411e3b467708e64f2bbb7b5d8b0885150aa.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Jaburek <jjaburek@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d70a1b9893f820fdbcdffac408c909c50f2e6b43 upstream.

The Arcam rPAC seems to have the same problem - whenever anything
(alsamixer, udevd, 3.9+ kernel from 60af3d037eb8c, ..) attempts to
access mixer / control interface of the card, the firmware "locks up"
the entire device, resulting in
  SNDRV_PCM_IOCTL_HW_PARAMS failed (-5): Input/output error
from alsa-lib.

Other operating systems can somehow read the mixer (there seems to be
playback volume/mute), but any manipulation is ignored by the device
(which has hardware volume controls).

Signed-off-by: Jiri Jaburek <jjaburek@redhat.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/usb/mixer_maps.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 0339d464791a..4df31b0f94a3 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -322,8 +322,11 @@ static struct usbmix_name_map hercules_usb51_map[] = {
 	{ 0 }				/* terminator */
 };
 
-static const struct usbmix_name_map kef_x300a_map[] = {
-	{ 10, NULL }, /* firmware locks up (?) when we try to access this FU */
+/* some (all?) SCMS USB3318 devices are affected by a firmware lock up
+ * when anything attempts to access FU 10 (control)
+ */
+static const struct usbmix_name_map scms_usb3318_map[] = {
+	{ 10, NULL },
 	{ 0 }
 };
 
@@ -415,8 +418,14 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.map = ebox44_map,
 	},
 	{
+		/* KEF X300A */
 		.id = USB_ID(0x27ac, 0x1000),
-		.map = kef_x300a_map,
+		.map = scms_usb3318_map,
+	},
+	{
+		/* Arcam rPAC */
+		.id = USB_ID(0x25c4, 0x0003),
+		.map = scms_usb3318_map,
 	},
 	{ 0 } /* terminator */
 };
-- 
2.2.2

