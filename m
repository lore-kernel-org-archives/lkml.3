Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab3GCSlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:41:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13537 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964797Ab3GCSlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:15 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=J80Yo4RLX5YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=FiMRtfU2xFUA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=-lXg-2p5LUkTD3H9y3wA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184057.813071608@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Robert Butora <robert.butora.fi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [079/141] USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0079-USB-Serial-cypress_M8-Enable-FRWD-Dongle-hidcom-devi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Robert Butora <robert.butora.fi@gmail.com>

[ Upstream commit 6529591e3eef65f0f528a81ac169f6e294b947a7 ]

The patch adds a new HIDCOM device and does not affect other devices
driven by the cypress_M8 module. Changes are:
- add VendorID ProductID to device tables
- skip unstable speed check because FRWD uses 115200bps
- skip reset at probe which is an issue workaround for this
particular device.

Signed-off-by: Robert Butora <robert.butora.fi@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/cypress_m8.c |   18 +++++++++++++++++-
 drivers/usb/serial/cypress_m8.h |    4 ++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 61de7e1..d7a16ba 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -70,6 +70,7 @@ static const struct usb_device_id id_table_earthmate[] = {
 static const struct usb_device_id id_table_cyphidcomrs232[] = {
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
 	{ USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
+	{ USB_DEVICE(VENDOR_ID_FRWD, PRODUCT_ID_CYPHIDCOM_FRWD) },
 	{ }						/* Terminating entry */
 };
 
@@ -83,6 +84,7 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(VENDOR_ID_DELORME, PRODUCT_ID_EARTHMATEUSB_LT20) },
 	{ USB_DEVICE(VENDOR_ID_CYPRESS, PRODUCT_ID_CYPHIDCOM) },
 	{ USB_DEVICE(VENDOR_ID_POWERCOM, PRODUCT_ID_UPS) },
+	{ USB_DEVICE(VENDOR_ID_FRWD, PRODUCT_ID_CYPHIDCOM_FRWD) },
 	{ USB_DEVICE(VENDOR_ID_DAZZLE, PRODUCT_ID_CA42) },
 	{ }						/* Terminating entry */
 };
@@ -235,6 +237,12 @@ static struct usb_serial_driver * const serial_drivers[] = {
  * Cypress serial helper functions
  *****************************************************************************/
 
+/* FRWD Dongle hidcom needs to skip reset and speed checks */
+static inline bool is_frwd(struct usb_device *dev)
+{
+	return ((le16_to_cpu(dev->descriptor.idVendor) == VENDOR_ID_FRWD) &&
+		(le16_to_cpu(dev->descriptor.idProduct) == PRODUCT_ID_CYPHIDCOM_FRWD));
+}
 
 static int analyze_baud_rate(struct usb_serial_port *port, speed_t new_rate)
 {
@@ -244,6 +252,10 @@ static int analyze_baud_rate(struct usb_serial_port *port, speed_t new_rate)
 	if (unstable_bauds)
 		return new_rate;
 
+	/* FRWD Dongle uses 115200 bps */
+	if (is_frwd(port->serial->dev))
+		return new_rate;
+
 	/*
 	 * The general purpose firmware for the Cypress M8 allows for
 	 * a maximum speed of 57600bps (I have no idea whether DeLorme
@@ -452,7 +464,11 @@ static int cypress_generic_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 	}
 
-	usb_reset_configuration(serial->dev);
+	/* Skip reset for FRWD device. It is a workaound:
+	   device hangs if it receives SET_CONFIGURE in Configured
+	   state. */
+	if (!is_frwd(serial->dev))
+		usb_reset_configuration(serial->dev);
 
 	priv->cmd_ctrl = 0;
 	priv->line_control = 0;
diff --git a/drivers/usb/serial/cypress_m8.h b/drivers/usb/serial/cypress_m8.h
index 67cf608..b461311 100644
--- a/drivers/usb/serial/cypress_m8.h
+++ b/drivers/usb/serial/cypress_m8.h
@@ -24,6 +24,10 @@
 #define VENDOR_ID_CYPRESS		0x04b4
 #define PRODUCT_ID_CYPHIDCOM		0x5500
 
+/* FRWD Dongle - a GPS sports watch */
+#define VENDOR_ID_FRWD			0x6737
+#define PRODUCT_ID_CYPHIDCOM_FRWD	0x0001
+
 /* Powercom UPS, chip CY7C63723 */
 #define VENDOR_ID_POWERCOM		0x0d9f
 #define PRODUCT_ID_UPS			0x0002
-- 
1.7.10.4


