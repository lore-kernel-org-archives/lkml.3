Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3EGEEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:04:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760346Ab3EGD6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:54 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=C85d1Gu8pxIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=jakkqOUl1FMA:10 a=lVtvZNkcAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z9hppVypvsQCDiRzgicA:9 a=-ng5EX9Dtv0A:10 a=MSl-tDqOz04A:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035847.975861650@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eldad Zack <eldad@fogrefinery.com>, Daniel Mack <zonque@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [042/126] ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0042-ALSA-usb-audio-fix-endianness-bug-in-snd_nativeinstr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eldad Zack <eldad@fogrefinery.com>

[ Upstream commit 889d66848b12d891248b03abcb2a42047f8e172a ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/mixer_quirks.c |    4 ++--
 sound/usb/quirks.c       |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index ae2b714..76e7dda 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -493,7 +493,7 @@ static int snd_nativeinstruments_control_get(struct snd_kcontrol *kcontrol,
 	else
 		ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-				  0, cpu_to_le16(wIndex),
+				  0, wIndex,
 				  &tmp, sizeof(tmp), 1000);
 	up_read(&mixer->chip->shutdown_rwsem);
 
@@ -524,7 +524,7 @@ static int snd_nativeinstruments_control_put(struct snd_kcontrol *kcontrol,
 	else
 		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), bRequest,
 				  USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-				  cpu_to_le16(wValue), cpu_to_le16(wIndex),
+				  wValue, wIndex,
 				  NULL, 0, 1000);
 	up_read(&mixer->chip->shutdown_rwsem);
 
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 0f58b4b..213ecad 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -484,7 +484,7 @@ static int snd_usb_nativeinstruments_boot_quirk(struct usb_device *dev)
 {
 	int ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 				  0xaf, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				  cpu_to_le16(1), 0, NULL, 0, 1000);
+				  1, 0, NULL, 0, 1000);
 
 	if (ret < 0)
 		return ret;
-- 
1.7.10.4


