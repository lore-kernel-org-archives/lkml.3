Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3FRMGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:06:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab3FRLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robert Butora <robert.butora.fi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 20/93] USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device
Date: Tue, 18 Jun 2013 12:42:28 +0100
Message-Id: <1371555821-12820-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Butora <robert.butora.fi@gmail.com>

commit 6529591e3eef65f0f528a81ac169f6e294b947a7 upstream.

The patch adds a new HIDCOM device and does not affect other devices
driven by the cypress_M8 module. Changes are:
- add VendorID ProductID to device tables
- skip unstable speed check because FRWD uses 115200bps
- skip reset at probe which is an issue workaround for this
particular device.

Signed-off-by: Robert Butora <robert.butora.fi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/cypress_m8.c | 18 +++++++++++++++++-
 drivers/usb/serial/cypress_m8.h |  4 ++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index dec5b2f..83a9b0e 100644
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
@@ -452,7 +464,11 @@ static int generic_startup(struct usb_serial *serial)
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
1.8.1.2

