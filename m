Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3IKE7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab3IKE5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:10 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=kYiTJMKh-TAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PhVDAlR6LUIA:10 a=VwQbUJbxAAAA:8 a=jKjxfLc-AAAA:8 a=IHFY8QVhW4d7QAvyAB8A:9 a=pFGTP7irh_kA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=-sOABqQNq7apPKm_:21 a=qeKDZ7ebFawAZ7jC:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042921.090994612@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Torsten Schenk <torsten.schenk@zoho.com>, Takashi Iwai <tiwai@suse.de>
Subject: [173/251] ALSA: 6fire: fix DMA issues with URB transfer_buffer usage
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0173-ALSA-6fire-fix-DMA-issues-with-URB-transfer_buffer-u.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

[ Upstream commit ddb6b5a964371e8e52e696b2b258bda144c8bd3f ]

Patch fixes 6fire not to use stack as URB transfer_buffer. URB buffers need to
be DMA-able, which stack is not. Furthermore, transfer_buffer should not be
allocated as part of larger device structure because DMA coherency issues and
patch fixes this issue too.

Cc: stable@vger.kernel.org
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Tested-by: Torsten Schenk <torsten.schenk@zoho.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/6fire/comm.c |   38 +++++++++++++++++++++++++++++++++-----
 sound/usb/6fire/comm.h |    2 +-
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/sound/usb/6fire/comm.c b/sound/usb/6fire/comm.c
index 6c3d531..8e68be7 100644
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
 	rt->serial = 1;
 	rt->chip = chip;
 	usb_init_urb(urb);
@@ -152,6 +176,7 @@ int __devinit usb6fire_comm_init(struct sfire_chip *chip)
 	urb->interval = 1;
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret < 0) {
+		kfree(rt->receiver_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create comm data receiver.");
 		return ret;
@@ -170,6 +195,9 @@ void usb6fire_comm_abort(struct sfire_chip *chip)
 
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
1.7.10.4


