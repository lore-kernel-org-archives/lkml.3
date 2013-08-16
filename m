Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab3HPWw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:52:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51868 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab3HPWlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 054/133] USB: mos7840: fix race in led handling
Date: Fri, 16 Aug 2013 15:33:16 -0700
Message-Id: <1376692475-28413-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 05cf0dec5ccc696a7636c84b265b477173498156 upstream.

Fix race in LED handling introduced by commit 0eafe4de ("USB: serial:
mos7840: add support for MCS7810 devices") which reused the port control
urb for manipulating the LED without making sure that the urb is not
already in use. This could lead to the control urb being manipulated
while in flight.

Fix by adding a dedicated LED urb and ctrlrequest along with a LED-busy
flag to handle concurrency.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/mos7840.c | 59 +++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 343a179..0116855 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -185,6 +185,7 @@
 
 enum mos7840_flag {
 	MOS7840_FLAG_CTRL_BUSY,
+	MOS7840_FLAG_LED_BUSY,
 };
 
 static const struct usb_device_id id_table[] = {
@@ -242,9 +243,10 @@ struct moschip_port {
 
 	/* For device(s) with LED indicator */
 	bool has_led;
-	bool led_flag;
 	struct timer_list led_timer1;	/* Timer for LED on */
 	struct timer_list led_timer2;	/* Timer for LED off */
+	struct urb *led_urb;
+	struct usb_ctrlrequest *led_dr;
 
 	unsigned long flags;
 };
@@ -562,7 +564,7 @@ static void mos7840_set_led_async(struct moschip_port *mcs, __u16 wval,
 				__u16 reg)
 {
 	struct usb_device *dev = mcs->port->serial->dev;
-	struct usb_ctrlrequest *dr = mcs->dr;
+	struct usb_ctrlrequest *dr = mcs->led_dr;
 
 	dr->bRequestType = MCS_WR_RTYPE;
 	dr->bRequest = MCS_WRREQ;
@@ -570,10 +572,10 @@ static void mos7840_set_led_async(struct moschip_port *mcs, __u16 wval,
 	dr->wIndex = cpu_to_le16(reg);
 	dr->wLength = cpu_to_le16(0);
 
-	usb_fill_control_urb(mcs->control_urb, dev, usb_sndctrlpipe(dev, 0),
+	usb_fill_control_urb(mcs->led_urb, dev, usb_sndctrlpipe(dev, 0),
 		(unsigned char *)dr, NULL, 0, mos7840_set_led_callback, NULL);
 
-	usb_submit_urb(mcs->control_urb, GFP_ATOMIC);
+	usb_submit_urb(mcs->led_urb, GFP_ATOMIC);
 }
 
 static void mos7840_set_led_sync(struct usb_serial_port *port, __u16 reg,
@@ -599,7 +601,19 @@ static void mos7840_led_flag_off(unsigned long arg)
 {
 	struct moschip_port *mcs = (struct moschip_port *) arg;
 
-	mcs->led_flag = false;
+	clear_bit_unlock(MOS7840_FLAG_LED_BUSY, &mcs->flags);
+}
+
+static void mos7840_led_activity(struct usb_serial_port *port)
+{
+	struct moschip_port *mos7840_port = usb_get_serial_port_data(port);
+
+	if (test_and_set_bit_lock(MOS7840_FLAG_LED_BUSY, &mos7840_port->flags))
+		return;
+
+	mos7840_set_led_async(mos7840_port, 0x0301, MODEM_CONTROL_REGISTER);
+	mod_timer(&mos7840_port->led_timer1,
+				jiffies + msecs_to_jiffies(LED_ON_MS));
 }
 
 /*****************************************************************************
@@ -804,14 +818,8 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 		return;
 	}
 
-	/* Turn on LED */
-	if (mos7840_port->has_led && !mos7840_port->led_flag) {
-		mos7840_port->led_flag = true;
-		mos7840_set_led_async(mos7840_port, 0x0301,
-					MODEM_CONTROL_REGISTER);
-		mod_timer(&mos7840_port->led_timer1,
-				jiffies + msecs_to_jiffies(LED_ON_MS));
-	}
+	if (mos7840_port->has_led)
+		mos7840_led_activity(port);
 
 	mos7840_port->read_urb_busy = true;
 	retval = usb_submit_urb(mos7840_port->read_urb, GFP_ATOMIC);
@@ -1517,13 +1525,8 @@ static int mos7840_write(struct tty_struct *tty, struct usb_serial_port *port,
 	data1 = urb->transfer_buffer;
 	dev_dbg(&port->dev, "bulkout endpoint is %d\n", port->bulk_out_endpointAddress);
 
-	/* Turn on LED */
-	if (mos7840_port->has_led && !mos7840_port->led_flag) {
-		mos7840_port->led_flag = true;
-		mos7840_set_led_sync(port, MODEM_CONTROL_REGISTER, 0x0301);
-		mod_timer(&mos7840_port->led_timer1,
-				jiffies + msecs_to_jiffies(LED_ON_MS));
-	}
+	if (mos7840_port->has_led)
+		mos7840_led_activity(port);
 
 	/* send it down the pipe */
 	status = usb_submit_urb(urb, GFP_ATOMIC);
@@ -2546,6 +2549,14 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 	if (device_type == MOSCHIP_DEVICE_ID_7810) {
 		mos7840_port->has_led = true;
 
+		mos7840_port->led_urb = usb_alloc_urb(0, GFP_KERNEL);
+		mos7840_port->led_dr = kmalloc(sizeof(*mos7840_port->led_dr),
+								GFP_KERNEL);
+		if (!mos7840_port->led_urb || !mos7840_port->led_dr) {
+			status = -ENOMEM;
+			goto error;
+		}
+
 		init_timer(&mos7840_port->led_timer1);
 		mos7840_port->led_timer1.function = mos7840_led_off;
 		mos7840_port->led_timer1.expires =
@@ -2558,8 +2569,6 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			jiffies + msecs_to_jiffies(LED_OFF_MS);
 		mos7840_port->led_timer2.data = (unsigned long)mos7840_port;
 
-		mos7840_port->led_flag = false;
-
 		/* Turn off LED */
 		mos7840_set_led_sync(port, MODEM_CONTROL_REGISTER, 0x0300);
 	}
@@ -2581,6 +2590,8 @@ out:
 	}
 	return 0;
 error:
+	kfree(mos7840_port->led_dr);
+	usb_free_urb(mos7840_port->led_urb);
 	kfree(mos7840_port->dr);
 	kfree(mos7840_port->ctrl_buf);
 	usb_free_urb(mos7840_port->control_urb);
@@ -2601,6 +2612,10 @@ static int mos7840_port_remove(struct usb_serial_port *port)
 
 		del_timer_sync(&mos7840_port->led_timer1);
 		del_timer_sync(&mos7840_port->led_timer2);
+
+		usb_kill_urb(mos7840_port->led_urb);
+		usb_free_urb(mos7840_port->led_urb);
+		kfree(mos7840_port->led_dr);
 	}
 	usb_kill_urb(mos7840_port->control_urb);
 	usb_free_urb(mos7840_port->control_urb);
-- 
1.8.1.2

