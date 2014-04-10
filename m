Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188AbaDJDok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:44:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934654AbaDJDWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Torsten Schenk <torsten.schenk@zoho.com>, Takashi Iwai <tiwai@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 106/134] ALSA: 6fire: fix DMA issues with URB transfer_buffer usage
Date: Wed,  9 Apr 2014 20:23:42 -0700
Message-Id: <20140410032313.411059306@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/6fire/comm.c |   38 +++++++++++++++++++++++++++++++++-----
 sound/usb/6fire/comm.h |    2 +-
 2 files changed, 34 insertions(+), 6 deletions(-)

--- a/sound/usb/6fire/comm.c
+++ b/sound/usb/6fire/comm.c
@@ -110,19 +110,37 @@ static int usb6fire_comm_send_buffer(u8
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
@@ -135,6 +153,12 @@ int __devinit usb6fire_comm_init(struct
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
@@ -152,6 +176,7 @@ int __devinit usb6fire_comm_init(struct
 	urb->interval = 1;
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret < 0) {
+		kfree(rt->receiver_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create comm data receiver.");
 		return ret;
@@ -170,6 +195,9 @@ void usb6fire_comm_abort(struct sfire_ch
 
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
@@ -24,7 +24,7 @@ struct comm_runtime {
 	struct sfire_chip *chip;
 
 	struct urb receiver;
-	u8 receiver_buffer[COMM_RECEIVER_BUFSIZE];
+	u8 *receiver_buffer;
 
 	u8 serial; /* urb serial */
 


