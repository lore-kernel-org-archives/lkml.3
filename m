Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab3HNKnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:43:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34703 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab3HNKi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 66/75] ALSA: 6fire: fix DMA issues with URB transfer_buffer usage
Date: Wed, 14 Aug 2013 11:36:55 +0100
Message-Id: <1376476624-10011-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/6fire/comm.c | 38 +++++++++++++++++++++++++++++++++-----
 sound/usb/6fire/comm.h |  2 +-
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/sound/usb/6fire/comm.c b/sound/usb/6fire/comm.c
index 1a75c36..ed3f828 100644
--- a/sound/usb/6fire/comm.c
+++ b/sound/usb/6fire/comm.c
@@ -110,19 +110,37 @@ static int usb6fire_comm_send_buffer(u8 *buffer, struct usb_device *dev)
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
@@ -135,6 +153,12 @@ int __devinit usb6fire_comm_init(struct sfire_chip *chip)
 	if (!rt)
 		return -ENOMEM;
 
+	rt->receiver_buffer = kzalloc(COMM_RECEIVER_BUFSIZE, GFP_KERNEL);
+	if (!rt->receiver_buffer) {
+		kfree(rt);
+		return -ENOMEM;
+	}
+
 	urb = &rt->receiver;
 	rt->serial = 1;
 	rt->chip = chip;
@@ -153,6 +177,7 @@ int __devinit usb6fire_comm_init(struct sfire_chip *chip)
 	urb->interval = 1;
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret < 0) {
+		kfree(rt->receiver_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create comm data receiver.");
 		return ret;
@@ -171,6 +196,9 @@ void usb6fire_comm_abort(struct sfire_chip *chip)
 
 void usb6fire_comm_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->comm);
+	struct comm_runtime *rt = chip->comm;
+
+	kfree(rt->receiver_buffer);
+	kfree(rt);
 	chip->comm = NULL;
 }
diff --git a/sound/usb/6fire/comm.h b/sound/usb/6fire/comm.h
index d2af0a5..fca24e3 100644
--- a/sound/usb/6fire/comm.h
+++ b/sound/usb/6fire/comm.h
@@ -24,7 +24,7 @@ struct comm_runtime {
 	struct sfire_chip *chip;
 
 	struct urb receiver;
-	u8 receiver_buffer[COMM_RECEIVER_BUFSIZE];
+	u8 *receiver_buffer;
 
 	u8 serial; /* urb serial */
 
-- 
1.8.3.2

