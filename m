Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaLOPPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:15:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaLOO1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jurgen Kramer <gtmkramer@xs4all.nl>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 026/168] ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devices
Date: Mon, 15 Dec 2014 14:24:40 +0000
Message-Id: <1418653622-21105-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jurgen Kramer <gtmkramer@xs4all.nl>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/quirks.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 19a921eb75f1..337067cce251 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1146,6 +1146,20 @@ void snd_usb_ctl_msg_quirk(struct usb_device *dev, unsigned int pipe,
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

