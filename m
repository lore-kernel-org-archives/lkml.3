Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaCYRVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:21:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbaCYRVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 29/81] ALSA: usb-audio: Add a quirk for Plantronics Gamecom 780
Date: Tue, 25 Mar 2014 10:15:42 -0700
Message-Id: <1395767794-5012-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 19570d747795f0ecff79403698b868dc5ad7fa86 upstream.

Plantronics Gamecom 780 headset has a firmware problem, and when the
FU 0x09 volume is changed, it results in either too loud or silence
except for a very narrow range.  This patch provides a workaround,
ignoring the node, initialize the volume in a sane value and keep
untouched.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=65251
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/mixer_maps.c | 10 ++++++++++
 sound/usb/quirks.c     | 14 ++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 0e2ed3d..65e1d7a 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -322,6 +322,12 @@ static struct usbmix_name_map hercules_usb51_map[] = {
 	{ 0 }				/* terminator */
 };
 
+/* Plantronics Gamecom 780 has a broken volume control, better to disable it */
+static struct usbmix_name_map gamecom780_map[] = {
+	{ 9, NULL }, /* FU, speaker out */
+	{}
+};
+
 /*
  * Control map entries
  */
@@ -358,6 +364,10 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x046d, 0x09a4),
 		.ignore_ctl_error = 1,
 	},
+	{	/* Plantronics GameCom 780 */
+		.id = USB_ID(0x047f, 0xc010),
+		.map = gamecom780_map,
+	},
 	{
 		/* Hercules DJ Console (Windows Edition) */
 		.id = USB_ID(0x06f8, 0xb000),
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index f581c3e..d138d1ef 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -445,6 +445,18 @@ static int snd_usb_cm6206_boot_quirk(struct usb_device *dev)
 	return err;
 }
 
+/* quirk for Plantronics GameCom 780 with CM6302 chip */
+static int snd_usb_gamecon780_boot_quirk(struct usb_device *dev)
+{
+	/* set the initial volume and don't change; other values are either
+	 * too loud or silent due to firmware bug (bko#65251)
+	 */
+	u8 buf[2] = { 0x74, 0xdc };
+	return snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), UAC_SET_CUR,
+			USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_OUT,
+			UAC_FU_VOLUME << 8, 9 << 8, buf, 2);
+}
+
 /*
  * This call will put the synth in "USB send" mode, i.e it will send MIDI
  * messages through USB (this is disabled at startup). The synth will
@@ -756,6 +768,8 @@ int snd_usb_apply_boot_quirk(struct usb_device *dev,
 		return snd_usb_nativeinstruments_boot_quirk(dev);
 	case USB_ID(0x0763, 0x2012):  /* M-Audio Fast Track Pro USB */
 		return snd_usb_fasttrackpro_boot_quirk(dev);
+	case USB_ID(0x047f, 0xc010): /* Plantronics Gamecom 780 */
+		return snd_usb_gamecon780_boot_quirk(dev);
 	}
 
 	return 0;
-- 
1.8.3.2

