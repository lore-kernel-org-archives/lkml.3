Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab3IHDoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:44:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56093 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756575Ab3IHDTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Torsten Schenk" <torsten.schenk@zoho.com>,
        "Jussi Kivilinna" <jussi.kivilinna@iki.fi>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.839623771@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [058/121] ALSA: 6fire: fix DMA issues with URB transfer_buffer usage
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

commit ddb6b5a964371e8e52e696b2b258bda144c8bd3f upstream.

Patch fixes 6fire not to use stack as URB transfer_buffer. URB buffers need to
be DMA-able, which stack is not. Furthermore, transfer_buffer should not be
allocated as part of larger device structure because DMA coherency issues and
patch fixes this issue too.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Tested-by: Torsten Schenk <torsten.schenk@zoho.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/6fire/comm.c | 38 +++++++++++++++++++++++++++++++++-----
 sound/usb/6fire/comm.h |  2 +-
 2 files changed, 34 insertions(+), 6 deletions(-)

--- a/sound/usb/6fire/comm.c
+++ b/sound/usb/6fire/comm.c
@@ -111,19 +111,37 @@ static int usb6fire_comm_send_buffer(u8
 static int usb6fire_comm_write8(struct comm_runtime *rt, u8 request,
 		u8 reg, u8 value)
 {
-	u8 buffer[13]; /* 13: maximum length of message */
+	u8 *buffer;
+	int ret;
+
+	/* 13: maximum length of message */
+	buffer = kmalloc(13, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
 
 	usb6fire_comm_init_buffer(buffer, 0x00, request, reg, value, 0x00);
-	return usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+	ret = usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+
+	kfree(buffer);
+	return ret;
 }
 
 static int usb6fire_comm_write16(struct comm_runtime *rt, u8 request,
 		u8 reg, u8 vl, u8 vh)
 {
-	u8 buffer[13]; /* 13: maximum length of message */
+	u8 *buffer;
+	int ret;
+
+	/* 13: maximum length of message */
+	buffer = kmalloc(13, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
 
 	usb6fire_comm_init_buffer(buffer, 0x00, request, reg, vl, vh);
-	return usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+	ret = usb6fire_comm_send_buffer(buffer, rt->chip->dev);
+
+	kfree(buffer);
+	return ret;
 }
 
 int __devinit usb6fire_comm_init(struct sfire_chip *chip)
@@ -136,6 +154,12 @@ int __devinit usb6fire_comm_init(struct
 	if (!rt)
 		return -ENOMEM;
 
+	rt->receiver_buffer = kzalloc(COMM_RECEIVER_BUFSIZE, GFP_KERNEL);
+	if (!rt->receiver_buffer) {
+		kfree(rt);
+		return -ENOMEM;
+	}
+
 	rt->serial = 1;
 	rt->chip = chip;
 	usb_init_urb(urb);
@@ -153,6 +177,7 @@ int __devinit usb6fire_comm_init(struct
 	urb->interval = 1;
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret < 0) {
+		kfree(rt->receiver_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create comm data receiver.");
 		return ret;
@@ -171,6 +196,9 @@ void usb6fire_comm_abort(struct sfire_ch
 
 void usb6fire_comm_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->comm);
+	struct comm_runtime *rt = chip->comm;
+
+	kfree(rt->receiver_buffer);
+	kfree(rt);
 	chip->comm = NULL;
 }
--- a/sound/usb/6fire/comm.h
+++ b/sound/usb/6fire/comm.h
@@ -25,7 +25,7 @@ struct comm_runtime {
 	struct sfire_chip *chip;
 
 	struct urb receiver;
-	u8 receiver_buffer[COMM_RECEIVER_BUFSIZE];
+	u8 *receiver_buffer;
 
 	u8 serial; /* urb serial */
 

