Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbaHHOqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:46:31 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:56838 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbaHHOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:46:28 -0400
X-Sasl-enc: TQRh0TVqnUl74CXo9jPmX2XRjdIwXUurHcY7oxXRm9yF 1407509183
From: Ted Mielczarek <ted@mielczarek.org>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, paul.gortmaker@windriver.com, hor27@gmail.com,
        petr@scssoft.com, magissia@magissia.com, linux-kernel@vger.kernel.org,
        Ted Mielczarek <ted@mielczarek.org>
Subject: [RESEND PATCH] Support Xbox One controllers in xpad driver.
Date: Fri,  8 Aug 2014 10:46:09 -0400
Message-Id: <1407509169-6849-1-git-send-email-ted@mielczarek.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xbox One controllers require an initialization message to start sending data,
so xpad_init_output becomes a required function. The Xbox One controller does
not have LEDs like the Xbox 360 controller, so that functionality is not
implemented. The format of messages controlling rumble is currently
undocumented, so rumble support is not yet implemented.

The only thing I'm not certain about in this patch is the check against bInterfaceNumber in xpad_probe. The Xbox One controller advertises three interfaces with the same interface class, subclass and protocol, and I couldn't see any way to match just the first one using usb_device_id.

Signed-off-by: Ted Mielczarek <ted@mielczarek.org>
---
 drivers/input/joystick/xpad.c | 163 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 149 insertions(+), 14 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 603fe0d..800e2f4 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -95,7 +95,8 @@
 #define XTYPE_XBOX        0
 #define XTYPE_XBOX360     1
 #define XTYPE_XBOX360W    2
-#define XTYPE_UNKNOWN     3
+#define XTYPE_XBOXONE     3
+#define XTYPE_UNKNOWN     4
 
 static bool dpad_to_buttons;
 module_param(dpad_to_buttons, bool, S_IRUGO);
@@ -121,6 +122,7 @@ static const struct xpad_device {
 	{ 0x045e, 0x0287, "Microsoft Xbox Controller S", 0, XTYPE_XBOX },
 	{ 0x045e, 0x0289, "Microsoft X-Box pad v2 (US)", 0, XTYPE_XBOX },
 	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", 0, XTYPE_XBOX360 },
+	{ 0x045e, 0x02d1, "Microsoft X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x045e, 0x0291, "Xbox 360 Wireless Receiver (XBOX)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
 	{ 0x045e, 0x0719, "Xbox 360 Wireless Receiver", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", 0, XTYPE_XBOX },
@@ -245,9 +247,20 @@ static const signed short xpad_abs_triggers[] = {
 	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,1) }, \
 	{ XPAD_XBOX360_VENDOR_PROTOCOL(vend,129) }
 
+/* The Xbox One controller uses subclass 71 and protocol 208. */
+#define XPAD_XBOXONE_VENDOR_PROTOCOL(vend,pr) \
+	.match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_INFO, \
+	.idVendor = (vend), \
+	.bInterfaceClass = USB_CLASS_VENDOR_SPEC, \
+	.bInterfaceSubClass = 71, \
+	.bInterfaceProtocol = (pr)
+#define XPAD_XBOXONE_VENDOR(vend) \
+	{ XPAD_XBOXONE_VENDOR_PROTOCOL(vend,208) }
+
 static struct usb_device_id xpad_table[] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
+	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft X-Box One controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
 	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
 	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
@@ -470,6 +483,101 @@ static void xpad360w_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned cha
 	xpad360_process_packet(xpad, cmd, &data[4]);
 }
 
+/*
+ *	xpadone_process_buttons
+ *
+ *	Process a button update packet from an Xbox one controller.
+ */
+static void xpadone_process_buttons(struct usb_xpad *xpad,
+				struct input_dev *dev,
+				unsigned char *data)
+{
+	/* menu/view buttons */
+	input_report_key(dev, BTN_START,  data[4] & 0x04);
+	input_report_key(dev, BTN_SELECT, data[4] & 0x08);
+
+	/* buttons A,B,X,Y */
+	input_report_key(dev, BTN_A,	data[4] & 0x10);
+	input_report_key(dev, BTN_B,	data[4] & 0x20);
+	input_report_key(dev, BTN_X,	data[4] & 0x40);
+	input_report_key(dev, BTN_Y,	data[4] & 0x80);
+
+	/* digital pad */
+	if (xpad->mapping & MAP_DPAD_TO_BUTTONS) {
+		/* dpad as buttons (left, right, up, down) */
+		input_report_key(dev, BTN_TRIGGER_HAPPY1, data[5] & 0x04);
+		input_report_key(dev, BTN_TRIGGER_HAPPY2, data[5] & 0x08);
+		input_report_key(dev, BTN_TRIGGER_HAPPY3, data[5] & 0x01);
+		input_report_key(dev, BTN_TRIGGER_HAPPY4, data[5] & 0x02);
+	} else {
+		input_report_abs(dev, ABS_HAT0X,
+				 !!(data[5] & 0x08) - !!(data[5] & 0x04));
+		input_report_abs(dev, ABS_HAT0Y,
+				 !!(data[5] & 0x02) - !!(data[5] & 0x01));
+	}
+
+	/* TL/TR */
+	input_report_key(dev, BTN_TL,	data[5] & 0x10);
+	input_report_key(dev, BTN_TR,	data[5] & 0x20);
+
+	/* stick press left/right */
+	input_report_key(dev, BTN_THUMBL, data[5] & 0x40);
+	input_report_key(dev, BTN_THUMBR, data[5] & 0x80);
+
+	if (!(xpad->mapping & MAP_STICKS_TO_NULL)) {
+		/* left stick */
+		input_report_abs(dev, ABS_X,
+				 (__s16) le16_to_cpup((__le16 *)(data + 10)));
+		input_report_abs(dev, ABS_Y,
+				 ~(__s16) le16_to_cpup((__le16 *)(data + 12)));
+
+		/* right stick */
+		input_report_abs(dev, ABS_RX,
+				 (__s16) le16_to_cpup((__le16 *)(data + 14)));
+		input_report_abs(dev, ABS_RY,
+				 ~(__s16) le16_to_cpup((__le16 *)(data + 16)));
+	}
+
+	/* triggers left/right */
+	if (xpad->mapping & MAP_TRIGGERS_TO_BUTTONS) {
+		input_report_key(dev, BTN_TL2,
+				 (__u16) le16_to_cpup((__le16 *)(data + 6)));
+		input_report_key(dev, BTN_TR2,
+				 (__u16) le16_to_cpup((__le16 *)(data + 8)));
+	} else {
+		input_report_abs(dev, ABS_Z,
+				 (__u16) le16_to_cpup((__le16 *)(data + 6)));
+		input_report_abs(dev, ABS_RZ,
+				 (__u16) le16_to_cpup((__le16 *)(data + 8)));
+	}
+}
+
+/*
+ *	xpadone_process_packet
+ *
+ *	Completes a request by converting the data into events for the
+ *	input subsystem. This version is for the Xbox One controller.
+ *
+ *	The report format was gleaned from
+ *	https://github.com/kylelemons/xbox/blob/master/xbox.go
+ */
+
+static void xpadone_process_packet(struct usb_xpad *xpad,
+				u16 cmd, unsigned char *data)
+{
+	struct input_dev *dev = xpad->dev;
+
+	if (data[0] == 0x20) {
+		xpadone_process_buttons(xpad, dev, data);
+	} else if (data[0] == 0x07) {
+		/* the xbox button has its own special report */
+		input_report_key(dev, BTN_MODE, data[4] & 0x01);
+	}
+
+	if (data[0] == 0x20 || data[0] == 0x07)
+		input_sync(dev);
+}
+
 static void xpad_irq_in(struct urb *urb)
 {
 	struct usb_xpad *xpad = urb->context;
@@ -502,6 +610,9 @@ static void xpad_irq_in(struct urb *urb)
 	case XTYPE_XBOX360W:
 		xpad360w_process_packet(xpad, 0, xpad->idata);
 		break;
+	case XTYPE_XBOXONE:
+		xpadone_process_packet(xpad, 0, xpad->idata);
+		break;
 	default:
 		xpad_process_packet(xpad, 0, xpad->idata);
 	}
@@ -535,7 +646,6 @@ static void xpad_bulk_out(struct urb *urb)
 	}
 }
 
-#if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
 static void xpad_irq_out(struct urb *urb)
 {
 	struct usb_xpad *xpad = urb->context;
@@ -593,7 +703,11 @@ static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
 		goto fail2;
 	}
 
-	ep_irq_out = &intf->cur_altsetting->endpoint[1].desc;
+	if (xpad->xtype == XTYPE_XBOXONE)
+		/* Xbox One controller has in/out endpoints swapped. */
+		ep_irq_out = &intf->cur_altsetting->endpoint[0].desc;
+	else
+		ep_irq_out = &intf->cur_altsetting->endpoint[1].desc;
 	usb_fill_int_urb(xpad->irq_out, xpad->udev,
 			 usb_sndintpipe(xpad->udev, ep_irq_out->bEndpointAddress),
 			 xpad->odata, XPAD_PKT_LEN,
@@ -621,11 +735,6 @@ static void xpad_deinit_output(struct usb_xpad *xpad)
 				xpad->odata, xpad->odata_dma);
 	}
 }
-#else
-static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad) { return 0; }
-static void xpad_deinit_output(struct usb_xpad *xpad) {}
-static void xpad_stop_output(struct usb_xpad *xpad) {}
-#endif
 
 #ifdef CONFIG_JOYSTICK_XPAD_FF
 static int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
@@ -692,7 +801,7 @@ static int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect
 
 static int xpad_init_ff(struct usb_xpad *xpad)
 {
-	if (xpad->xtype == XTYPE_UNKNOWN)
+	if (xpad->xtype == XTYPE_UNKNOWN || xpad->xtype == XTYPE_XBOXONE)
 		return 0;
 
 	input_set_capability(xpad->dev, EV_FF, FF_RUMBLE);
@@ -801,6 +910,14 @@ static int xpad_open(struct input_dev *dev)
 	if (usb_submit_urb(xpad->irq_in, GFP_KERNEL))
 		return -EIO;
 
+	if (xpad->xtype == XTYPE_XBOXONE) {
+		/* Xbox one controller needs to be initialized. */
+		xpad->odata[0] = 0x05;
+		xpad->odata[1] = 0x20;
+		xpad->irq_out->transfer_buffer_length = 2;
+		return usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+	}
+
 	return 0;
 }
 
@@ -816,6 +933,7 @@ static void xpad_close(struct input_dev *dev)
 
 static void xpad_set_up_abs(struct input_dev *input_dev, signed short abs)
 {
+	struct usb_xpad *xpad = input_get_drvdata(input_dev);
 	set_bit(abs, input_dev->absbit);
 
 	switch (abs) {
@@ -827,7 +945,10 @@ static void xpad_set_up_abs(struct input_dev *input_dev, signed short abs)
 		break;
 	case ABS_Z:
 	case ABS_RZ:	/* the triggers (if mapped to axes) */
-		input_set_abs_params(input_dev, abs, 0, 255, 0, 0);
+		if (xpad->xtype == XTYPE_XBOXONE)
+			input_set_abs_params(input_dev, abs, 0, 1023, 0, 0);
+		else
+			input_set_abs_params(input_dev, abs, 0, 255, 0, 0);
 		break;
 	case ABS_HAT0X:
 	case ABS_HAT0Y:	/* the d-pad (only if dpad is mapped to axes */
@@ -850,6 +971,15 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 			break;
 	}
 
+	if (xpad_device[i].xtype == XTYPE_XBOXONE
+		&& intf->cur_altsetting->desc.bInterfaceNumber != 0) {
+		/* The Xbox One controller lists three interfaces all with the
+		 * same interface class, subclass and protocol. Differentiate by
+		 * interface number.
+		 */
+		return -ENODEV;
+	}
+
 	xpad = kzalloc(sizeof(struct usb_xpad), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!xpad || !input_dev) {
@@ -920,7 +1050,8 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		__set_bit(xpad_common_btn[i], input_dev->keybit);
 
 	/* set up model-specific ones */
-	if (xpad->xtype == XTYPE_XBOX360 || xpad->xtype == XTYPE_XBOX360W) {
+	if (xpad->xtype == XTYPE_XBOX360 || xpad->xtype == XTYPE_XBOX360W
+		|| xpad->xtype == XTYPE_XBOXONE) {
 		for (i = 0; xpad360_btn[i] >= 0; i++)
 			__set_bit(xpad360_btn[i], input_dev->keybit);
 	} else {
@@ -933,7 +1064,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 			__set_bit(xpad_btn_pad[i], input_dev->keybit);
 	} else {
 		for (i = 0; xpad_abs_pad[i] >= 0; i++)
-		    xpad_set_up_abs(input_dev, xpad_abs_pad[i]);
+			xpad_set_up_abs(input_dev, xpad_abs_pad[i]);
 	}
 
 	if (xpad->mapping & MAP_TRIGGERS_TO_BUTTONS) {
@@ -956,7 +1087,11 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	if (error)
 		goto fail5;
 
-	ep_irq_in = &intf->cur_altsetting->endpoint[0].desc;
+	if (xpad->xtype == XTYPE_XBOXONE)
+		/* Xbox One controller has in/out endpoints swapped. */
+		ep_irq_in = &intf->cur_altsetting->endpoint[1].desc;
+	else
+		ep_irq_in = &intf->cur_altsetting->endpoint[0].desc;
 	usb_fill_int_urb(xpad->irq_in, udev,
 			 usb_rcvintpipe(udev, ep_irq_in->bEndpointAddress),
 			 xpad->idata, XPAD_PKT_LEN, xpad_irq_in,
@@ -1010,7 +1145,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		/*
 		 * Submit the int URB immediately rather than waiting for open
 		 * because we get status messages from the device whether
-		 * or not any controllers are attached.  In fact, it's
+		 * or not any controllers are attached.	 In fact, it's
 		 * exactly the message that a controller has arrived that
 		 * we're waiting for.
 		 */
-- 
1.9.1

