Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaLFPUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:20:30 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47713 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752091AbaLFPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jurgen Kramer <gtmkramer@xs4all.nl>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 43/66] ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devices
Date: Sat,  6 Dec 2014 16:07:35 +0100
Message-Id: <38446d657f98f5bc266ec46eaaa87f2bd9880768.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jurgen Kramer <gtmkramer@xs4all.nl>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6e84a8d7ac3ba246ef44e313e92bc16a1da1b04a upstream.

This patch adds a USB control message delay quirk for a few specific Marantz/Denon
devices. Without the delay the DACs will not work properly and produces the
following type of messages:

Nov 15 10:09:21 orwell kernel: [   91.342880] usb 3-13: clock source 41 is not valid, cannot use
Nov 15 10:09:21 orwell kernel: [   91.343775] usb 3-13: clock source 41 is not valid, cannot use

There are likely other Marantz/Denon devices using the same USB module which exhibit the
same problems. But as this cannot be verified I limited the patch to the devices
I could test.

The following two devices are covered by this path:
- Marantz SA-14S1
- Marantz HD-DAC1

Signed-off-by: Jurgen Kramer <gtmkramer@xs4all.nl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/usb/quirks.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 0df9ede99dfd..3fbb4553ba40 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1127,6 +1127,20 @@ void snd_usb_ctl_msg_quirk(struct usb_device *dev, unsigned int pipe,
 	if ((le16_to_cpu(dev->descriptor.idVendor) == 0x23ba) &&
 	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		mdelay(20);
+
+	/* Marantz/Denon devices with USB DAC functionality need a delay
+	 * after each class compliant request
+	 */
+	if ((le16_to_cpu(dev->descriptor.idVendor) == 0x154e) &&
+	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS) {
+
+		switch (le16_to_cpu(dev->descriptor.idProduct)) {
+		case 0x3005: /* Marantz HD-DAC1 */
+		case 0x3006: /* Marantz SA-14S1 */
+			mdelay(20);
+			break;
+		}
+	}
 }
 
 /*
-- 
2.1.3

