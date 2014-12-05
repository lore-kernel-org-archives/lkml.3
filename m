Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaLEXku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:40:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaLEWqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jurgen Kramer <gtmkramer@xs4all.nl>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.17 064/122] ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devices
Date: Fri,  5 Dec 2014 14:43:58 -0800
Message-Id: <20141205223315.284945988@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1146,6 +1146,20 @@ void snd_usb_ctl_msg_quirk(struct usb_de
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


