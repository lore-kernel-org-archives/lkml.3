Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbbALSkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:40:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58374 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbbALSap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Jaburek <jjaburek@redhat.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 188/216] ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC
Date: Mon, 12 Jan 2015 18:29:26 +0000
Message-Id: <1421087394-2712-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Jaburek <jjaburek@redhat.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/mixer_maps.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index d1d72ff50347..621bc9ebb55e 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -328,8 +328,11 @@ static struct usbmix_name_map gamecom780_map[] = {
 	{}
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
 
@@ -425,8 +428,14 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
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
2.1.4

