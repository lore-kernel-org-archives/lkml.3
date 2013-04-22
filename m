Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3DVOc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:32:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51680 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755096Ab3DVOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eldad Zack" <eldad@fogrefinery.com>,
        "Takashi Iwai" <tiwai@suse.de>, "Daniel Mack" <zonque@gmail.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.986123913@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [24/75] ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
@@ -482,7 +482,7 @@ static int snd_usb_nativeinstruments_boo
 {
 	int ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 				  0xaf, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				  cpu_to_le16(1), 0, NULL, 0, 1000);
+				  1, 0, NULL, 0, 1000);
 
 	if (ret < 0)
 		return ret;

