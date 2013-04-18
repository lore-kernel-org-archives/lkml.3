Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967086Ab3DRJ06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:26:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40235 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758448Ab3DRJSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eldad Zack <eldad@fogrefinery.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 48/72] ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*
Date: Thu, 18 Apr 2013 10:16:33 +0100
Message-Id: <1366276617-3553-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eldad Zack <eldad@fogrefinery.com>

commit 889d66848b12d891248b03abcb2a42047f8e172a upstream.

The usb_control_msg() function expects __u16 types and performs
the endianness conversions by itself.
However, in three places, a conversion is performed before it is
handed over to usb_control_msg(), which leads to a double conversion
(= no conversion):
* snd_usb_nativeinstruments_boot_quirk()
* snd_nativeinstruments_control_get()
* snd_nativeinstruments_control_put()

Caught by sparse:

sound/usb/mixer_quirks.c:512:38: warning: incorrect type in argument 6 (different base types)
sound/usb/mixer_quirks.c:512:38:    expected unsigned short [unsigned] [usertype] index
sound/usb/mixer_quirks.c:512:38:    got restricted __le16 [usertype] <noident>
sound/usb/mixer_quirks.c:543:35: warning: incorrect type in argument 5 (different base types)
sound/usb/mixer_quirks.c:543:35:    expected unsigned short [unsigned] [usertype] value
sound/usb/mixer_quirks.c:543:35:    got restricted __le16 [usertype] <noident>
sound/usb/mixer_quirks.c:543:56: warning: incorrect type in argument 6 (different base types)
sound/usb/mixer_quirks.c:543:56:    expected unsigned short [unsigned] [usertype] index
sound/usb/mixer_quirks.c:543:56:    got restricted __le16 [usertype] <noident>
sound/usb/quirks.c:502:35: warning: incorrect type in argument 5 (different base types)
sound/usb/quirks.c:502:35:    expected unsigned short [unsigned] [usertype] value
sound/usb/quirks.c:502:35:    got restricted __le16 [usertype] <noident>

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
Acked-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/mixer_quirks.c | 4 ++--
 sound/usb/quirks.c       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index e4c808d..10a7247f 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -467,7 +467,7 @@ static int snd_nativeinstruments_control_get(struct snd_kcontrol *kcontrol,
 	else
 		ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-				  0, cpu_to_le16(wIndex),
+				  0, wIndex,
 				  &tmp, sizeof(tmp), 1000);
 	up_read(&mixer->chip->shutdown_rwsem);
 
@@ -498,7 +498,7 @@ static int snd_nativeinstruments_control_put(struct snd_kcontrol *kcontrol,
 	else
 		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-				  cpu_to_le16(wValue), cpu_to_le16(wIndex),
+				  wValue, wIndex,
 				  NULL, 0, 1000);
 	up_read(&mixer->chip->shutdown_rwsem);
 
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index c46171a..b7fa802 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -486,7 +486,7 @@ static int snd_usb_nativeinstruments_boot_quirk(struct usb_device *dev)
 {
 	int ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 				  0xaf, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				  cpu_to_le16(1), 0, NULL, 0, 1000);
+				  1, 0, NULL, 0, 1000);
 
 	if (ret < 0)
 		return ret;
-- 
1.8.1.2

