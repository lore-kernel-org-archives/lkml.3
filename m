Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3IKFaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:30:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3IKE5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:23 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=f0FrvSTHPa0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=yC5reMIkl0wA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=z9odyffjMVvEqKmo1QkA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=V_Yy7p-dmLMIClnr:21 a=MQLoCDqbYLHyd0ny:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042914.281583653@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [132/251] USB: mos7840: fix device-type detection
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0132-USB-mos7840-fix-device-type-detection.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit 40c24f2893ba0ba7df485871f6aac0c197ceef5b ]

Fix race in device-type detection introduced by commit 0eafe4de ("USB:
serial: mos7840: add support for MCS7810 devices") which used a static
variable to hold the device type.

Move type detection to probe and use serial data to store the device
type.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/mos7840.c |   75 ++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 40 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 2e218ee..ed55ac0 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -191,8 +191,6 @@ enum mos7840_flag {
 	MOS7840_FLAG_CTRL_BUSY,
 };
 
-static int device_type;
-
 static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
@@ -893,18 +891,6 @@ static void mos7840_bulk_out_data_callback(struct urb *urb)
 /************************************************************************/
 /*       D R I V E R  T T Y  I N T E R F A C E  F U N C T I O N S       */
 /************************************************************************/
-#ifdef MCSSerialProbe
-static int mos7840_serial_probe(struct usb_serial *serial,
-				const struct usb_device_id *id)
-{
-
-	/*need to implement the mode_reg reading and updating\
-	   structures usb_serial_ device_type\
-	   (i.e num_ports, num_bulkin,bulkout etc) */
-	/* Also we can update the changes  attach */
-	return 1;
-}
-#endif
 
 /*****************************************************************************
  * mos7840_open
@@ -2415,38 +2401,48 @@ static int mos7810_check(struct usb_serial *serial)
 	return 0;
 }
 
-static int mos7840_calc_num_ports(struct usb_serial *serial)
+static int mos7840_probe(struct usb_serial *serial,
+				const struct usb_device_id *id)
 {
-	__u16 data = 0x00;
+	u16 product = serial->dev->descriptor.idProduct;
 	u8 *buf;
-	int mos7840_num_ports;
+	int device_type;
+
+	if (product == MOSCHIP_DEVICE_ID_7810 ||
+		product == MOSCHIP_DEVICE_ID_7820) {
+		device_type = product;
+		goto out;
+	}
 
 	buf = kzalloc(VENDOR_READ_LENGTH, GFP_KERNEL);
-	if (buf) {
-		usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+	if (!buf)
+		return -ENOMEM;
+
+	usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 			MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, buf,
 			VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
-		data = *buf;
-		kfree(buf);
-	}
 
-	if (serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7810 ||
-		serial->dev->descriptor.idProduct == MOSCHIP_DEVICE_ID_7820) {
-		device_type = serial->dev->descriptor.idProduct;
-	} else {
-		/* For a MCS7840 device GPIO0 must be set to 1 */
-		if ((data & 0x01) == 1)
-			device_type = MOSCHIP_DEVICE_ID_7840;
-		else if (mos7810_check(serial))
-			device_type = MOSCHIP_DEVICE_ID_7810;
-		else
-			device_type = MOSCHIP_DEVICE_ID_7820;
-	}
+	/* For a MCS7840 device GPIO0 must be set to 1 */
+	if (buf[0] & 0x01)
+		device_type = MOSCHIP_DEVICE_ID_7840;
+	else if (mos7810_check(serial))
+		device_type = MOSCHIP_DEVICE_ID_7810;
+	else
+		device_type = MOSCHIP_DEVICE_ID_7820;
+
+	kfree(buf);
+out:
+	usb_set_serial_data(serial, (void *)device_type);
+
+	return 0;
+}
+
+static int mos7840_calc_num_ports(struct usb_serial *serial)
+{
+	int device_type = (int)usb_get_serial_data(serial);
+	int mos7840_num_ports;
 
 	mos7840_num_ports = (device_type >> 4) & 0x000F;
-	serial->num_bulk_in = mos7840_num_ports;
-	serial->num_bulk_out = mos7840_num_ports;
-	serial->num_ports = mos7840_num_ports;
 
 	return mos7840_num_ports;
 }
@@ -2454,6 +2450,7 @@ static int mos7840_calc_num_ports(struct usb_serial *serial)
 static int mos7840_port_probe(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
+	int device_type = (int)usb_get_serial_data(serial);
 	struct moschip_port *mos7840_port;
 	int status;
 	int pnum;
@@ -2744,9 +2741,7 @@ static struct usb_serial_driver moschip7840_4port_device = {
 	.throttle = mos7840_throttle,
 	.unthrottle = mos7840_unthrottle,
 	.calc_num_ports = mos7840_calc_num_ports,
-#ifdef MCSSerialProbe
-	.probe = mos7840_serial_probe,
-#endif
+	.probe = mos7840_probe,
 	.ioctl = mos7840_ioctl,
 	.set_termios = mos7840_set_termios,
 	.break_ctl = mos7840_break,
-- 
1.7.10.4


