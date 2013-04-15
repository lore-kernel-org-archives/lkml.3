Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3DOCR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:17:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3DOCRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:17:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>, Daniel Mack <zonque@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 01/11] ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*
Date: Sun, 14 Apr 2013 19:17:33 -0700
Message-Id: <20130415020614.191781961@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415020614.067692418@linuxfoundation.org>
References: <20130415020614.067692418@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_quirks.c |    4 ++--
 sound/usb/quirks.c       |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -396,7 +396,7 @@ static int snd_nativeinstruments_control
 	else
 		ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-				  0, cpu_to_le16(wIndex),
+				  0, wIndex,
 				  &tmp, sizeof(tmp), 1000);
 	up_read(&mixer->chip->shutdown_rwsem);
 
@@ -427,7 +427,7 @@ static int snd_nativeinstruments_control
 	else
 		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-				  cpu_to_le16(wValue), cpu_to_le16(wIndex),
+				  wValue, wIndex,
 				  NULL, 0, 1000);
 	up_read(&mixer->chip->shutdown_rwsem);
 
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -455,7 +455,7 @@ static int snd_usb_nativeinstruments_boo
 {
 	int ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 				  0xaf, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				  cpu_to_le16(1), 0, NULL, 0, 1000);
+				  1, 0, NULL, 0, 1000);
 
 	if (ret < 0)
 		return ret;


