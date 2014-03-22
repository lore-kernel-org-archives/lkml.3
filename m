Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbaCVJXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 05:23:17 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59373 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaCVJXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 05:23:14 -0400
From: Felix Rueegg <felix.rueegg@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        magissia@magissia.com, jms.576@gmail.com, paul.gortmaker@windriver.com,
        petr@scssoft.com, thor27@gmail.com,
        Felix Rueegg <felix.rueegg@gmail.com>
Subject: [PATCH] input: xpad - add queue for interrupt out transfers
Date: Sat, 22 Mar 2014 10:15:23 +0100
Message-Id: <1395479723-5730-1-git-send-email-felix.rueegg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xpad_play_effect() directly calls usb_submit_urb() to send a force
feedback command to the device. This causes the urb to fail with a
warning (URB submitted while active) when xpad_play_effect() is called
mutliple times in close succession. The issue also happens when a led
command is sent at the same time as a force feedback command, since they
use the same urb.

This patch fixes the issue by adding a buffer to queue all interrupt out
transfers (similar to the implementation in the iforce driver).

Signed-off-by: Felix Rueegg <felix.rueegg@gmail.com>
---
 drivers/input/joystick/xpad.c | 212 +++++++++++++++++++++++++++++++-----------
 1 file changed, 158 insertions(+), 54 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 603fe0d..6147ad7 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -77,6 +77,7 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/module.h>
+#include <linux/circ_buf.h>
 #include <linux/usb/input.h>
 
 #define DRIVER_AUTHOR "Marko Friedemann <mfr@bmx-chemnitz.de>"
@@ -97,6 +98,15 @@
 #define XTYPE_XBOX360W    2
 #define XTYPE_UNKNOWN     3
 
+/* queue for interrupt out transfers */
+#define XMIT_SIZE         256
+#define XMIT_INC(var, n)		\
+	do {				\
+		var += n;		\
+		var &= XMIT_SIZE - 1;	\
+	} while (0)
+#define XPAD_XMIT_RUNNING 0
+
 static bool dpad_to_buttons;
 module_param(dpad_to_buttons, bool, S_IRUGO);
 MODULE_PARM_DESC(dpad_to_buttons, "Map D-PAD to buttons rather than axes for unknown pads");
@@ -282,7 +292,11 @@ struct usb_xpad {
 	struct urb *irq_out;		/* urb for interrupt out report */
 	unsigned char *odata;		/* output data */
 	dma_addr_t odata_dma;
-	struct mutex odata_mutex;
+
+	struct circ_buf xmit;		/* queue for interrupt out transfers */
+	unsigned char xmit_data[XMIT_SIZE];
+	unsigned long xmit_flags[1];
+	spinlock_t xmit_lock;
 #endif
 
 #if defined(CONFIG_JOYSTICK_XPAD_LEDS)
@@ -536,38 +550,133 @@ static void xpad_bulk_out(struct urb *urb)
 }
 
 #if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
+void xpad_irq_xmit(struct usb_xpad *xpad)
+{
+	int length, c, err;
+	unsigned long flags;
+
+	spin_lock_irqsave(&xpad->xmit_lock, flags);
+
+	if (xpad->xmit.head == xpad->xmit.tail) {
+		clear_bit(XPAD_XMIT_RUNNING, xpad->xmit_flags);
+		goto out_unlock;
+	}
+
+	/* copy packet length */
+	length = xpad->xmit.buf[xpad->xmit.tail];
+	XMIT_INC(xpad->xmit.tail, 1);
+
+	xpad->irq_out->transfer_buffer_length = length;
+
+	/* copy packet data */
+	c = CIRC_CNT_TO_END(xpad->xmit.head, xpad->xmit.tail, XMIT_SIZE);
+	if (length < c)
+		c = length;
+
+	memcpy(xpad->odata,
+	       &xpad->xmit.buf[xpad->xmit.tail],
+	       c);
+	if (length != c) {
+		memcpy(xpad->odata + c,
+		       &xpad->xmit.buf[0],
+		       length - c);
+	}
+	XMIT_INC(xpad->xmit.tail, length);
+
+	err = usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+	if (err < 0) {
+		clear_bit(XPAD_XMIT_RUNNING, xpad->xmit_flags);
+
+		/* -ENODEV: device disconnected */
+		if (err == -ENODEV)
+			goto out_unlock;
+
+		dev_warn(&xpad->intf->dev, "usb_submit_urb failed %d\n", err);
+	}
+	/*
+	 * The XPAD_XMIT_RUNNING bit is not cleared here. That's intended.
+	 * As long as the urb completion handler is not called, the transmiting
+	 * is considered to be running
+	 */
+out_unlock:
+	spin_unlock_irqrestore(&xpad->xmit_lock, flags);
+}
+
+int xpad_send_packet(struct usb_xpad *xpad, u8 length, u8 *data)
+{
+	int head, tail, empty, c;
+	unsigned long flags;
+
+	spin_lock_irqsave(&xpad->xmit_lock, flags);
+
+	/* update head and tail of xmit buffer */
+	head = xpad->xmit.head;
+	tail = xpad->xmit.tail;
+
+	if (CIRC_SPACE(head, tail, XMIT_SIZE) < length + 1) {
+		dev_warn(&xpad->dev->dev,
+			 "not enough space in xmit buffer to send new packet\n");
+		spin_unlock_irqrestore(&xpad->xmit_lock, flags);
+		return -1;
+	}
+
+	empty = head == tail;
+	XMIT_INC(xpad->xmit.head, length + 1);
+
+	/* store packet length in xmit buffer */
+	xpad->xmit.buf[head] = length;
+	XMIT_INC(head, 1);
+
+	/* store packet data in xmit buffer */
+	c = CIRC_SPACE_TO_END(head, tail, XMIT_SIZE);
+	if (length < c)
+		c = length;
+
+	memcpy(&xpad->xmit.buf[head],
+	       data,
+	       c);
+	if (length != c) {
+		memcpy(&xpad->xmit.buf[0],
+		       data + c,
+		       length - c);
+	}
+	XMIT_INC(head, length);
+
+	spin_unlock_irqrestore(&xpad->xmit_lock, flags);
+
+	/* if necessary, start the transmission */
+	if (empty && !test_and_set_bit(XPAD_XMIT_RUNNING, xpad->xmit_flags))
+		xpad_irq_xmit(xpad);
+
+	return 0;
+}
+
 static void xpad_irq_out(struct urb *urb)
 {
 	struct usb_xpad *xpad = urb->context;
 	struct device *dev = &xpad->intf->dev;
-	int retval, status;
+	int status;
 
 	status = urb->status;
 
 	switch (status) {
 	case 0:
 		/* success */
+		xpad_irq_xmit(xpad);
 		return;
-
 	case -ECONNRESET:
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
 		dev_dbg(dev, "%s - urb shutting down with status: %d\n",
 			__func__, status);
-		return;
-
+		break;
 	default:
 		dev_dbg(dev, "%s - nonzero urb status received: %d\n",
 			__func__, status);
-		goto exit;
 	}
 
-exit:
-	retval = usb_submit_urb(urb, GFP_ATOMIC);
-	if (retval)
-		dev_err(dev, "%s - usb_submit_urb failed with result %d\n",
-			__func__, retval);
+	clear_bit(XPAD_XMIT_RUNNING, xpad->xmit_flags);
 }
 
 static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
@@ -585,7 +694,8 @@ static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
 		goto fail1;
 	}
 
-	mutex_init(&xpad->odata_mutex);
+	spin_lock_init(&xpad->xmit_lock);
+	xpad->xmit.buf = xpad->xmit_data;
 
 	xpad->irq_out = usb_alloc_urb(0, GFP_KERNEL);
 	if (!xpad->irq_out) {
@@ -631,6 +741,7 @@ static void xpad_stop_output(struct usb_xpad *xpad) {}
 static int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
 {
 	struct usb_xpad *xpad = input_get_drvdata(dev);
+	u8 pdata[12];
 
 	if (effect->type == FF_RUMBLE) {
 		__u16 strong = effect->u.rumble.strong_magnitude;
@@ -639,45 +750,39 @@ static int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect
 		switch (xpad->xtype) {
 
 		case XTYPE_XBOX:
-			xpad->odata[0] = 0x00;
-			xpad->odata[1] = 0x06;
-			xpad->odata[2] = 0x00;
-			xpad->odata[3] = strong / 256;	/* left actuator */
-			xpad->odata[4] = 0x00;
-			xpad->odata[5] = weak / 256;	/* right actuator */
-			xpad->irq_out->transfer_buffer_length = 6;
-
-			return usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+			pdata[0] = 0x00;
+			pdata[1] = 0x06;
+			pdata[2] = 0x00;
+			pdata[3] = strong / 256;	/* left actuator */
+			pdata[4] = 0x00;
+			pdata[5] = weak / 256;		/* right actuator */
+			return xpad_send_packet(xpad, 6, pdata);
 
 		case XTYPE_XBOX360:
-			xpad->odata[0] = 0x00;
-			xpad->odata[1] = 0x08;
-			xpad->odata[2] = 0x00;
-			xpad->odata[3] = strong / 256;  /* left actuator? */
-			xpad->odata[4] = weak / 256;	/* right actuator? */
-			xpad->odata[5] = 0x00;
-			xpad->odata[6] = 0x00;
-			xpad->odata[7] = 0x00;
-			xpad->irq_out->transfer_buffer_length = 8;
-
-			return usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+			pdata[0] = 0x00;
+			pdata[1] = 0x08;
+			pdata[2] = 0x00;
+			pdata[3] = strong / 256;	/* left actuator? */
+			pdata[4] = weak / 256;		/* right actuator? */
+			pdata[5] = 0x00;
+			pdata[6] = 0x00;
+			pdata[7] = 0x00;
+			return xpad_send_packet(xpad, 8, pdata);
 
 		case XTYPE_XBOX360W:
-			xpad->odata[0] = 0x00;
-			xpad->odata[1] = 0x01;
-			xpad->odata[2] = 0x0F;
-			xpad->odata[3] = 0xC0;
-			xpad->odata[4] = 0x00;
-			xpad->odata[5] = strong / 256;
-			xpad->odata[6] = weak / 256;
-			xpad->odata[7] = 0x00;
-			xpad->odata[8] = 0x00;
-			xpad->odata[9] = 0x00;
-			xpad->odata[10] = 0x00;
-			xpad->odata[11] = 0x00;
-			xpad->irq_out->transfer_buffer_length = 12;
-
-			return usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+			pdata[0] = 0x00;
+			pdata[1] = 0x01;
+			pdata[2] = 0x0F;
+			pdata[3] = 0xC0;
+			pdata[4] = 0x00;
+			pdata[5] = strong / 256;
+			pdata[6] = weak / 256;
+			pdata[7] = 0x00;
+			pdata[8] = 0x00;
+			pdata[9] = 0x00;
+			pdata[10] = 0x00;
+			pdata[11] = 0x00;
+			return xpad_send_packet(xpad, 12, pdata);
 
 		default:
 			dev_dbg(&xpad->dev->dev,
@@ -715,14 +820,13 @@ struct xpad_led {
 
 static void xpad_send_led_command(struct usb_xpad *xpad, int command)
 {
+	u8 pdata[3];
+
 	if (command >= 0 && command < 14) {
-		mutex_lock(&xpad->odata_mutex);
-		xpad->odata[0] = 0x01;
-		xpad->odata[1] = 0x03;
-		xpad->odata[2] = command;
-		xpad->irq_out->transfer_buffer_length = 3;
-		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
-		mutex_unlock(&xpad->odata_mutex);
+		pdata[0] = 0x01;
+		pdata[1] = 0x03;
+		pdata[2] = command;
+		xpad_send_packet(xpad, 3, pdata);
 	}
 }
 
-- 
1.9.1

