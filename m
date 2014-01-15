Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaAOCmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:42:47 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:36498 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaAOCmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:42:33 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s0F2gRnZ019202, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <oliver@neukum.org>, <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 3/3] r8152: ecm and vendor modes coexist
Date: Wed, 15 Jan 2014 10:42:16 +0800
Message-ID: <1389753736-2218-4-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389753736-2218-1-git-send-email-hayeswang@realtek.com>
References: <1389250232-8663-1-git-send-email-hayeswang@realtek.com>
 <1389753736-2218-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the limitation that the ecm and r8152 drivers couldn't coexist.
 - Remove the devices from the blacklist of relative drivers.
 - Remove usb_driver_set_configuration() from r8152 driver.
 - Modify the id_table of the r8152 driver for the vendor mode only.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/cdc_ether.c |  9 ---------
 drivers/net/usb/r8152.c     | 18 ++++++++----------
 drivers/net/usb/r815x.c     |  8 --------
 3 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 640406a..7d32be8 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -653,15 +653,6 @@ static const struct usb_device_id	products[] = {
 	.driver_info = 0,
 },
 
-#if defined(CONFIG_USB_RTL8152) || defined(CONFIG_USB_RTL8152_MODULE)
-/* Samsung USB Ethernet Adapters */
-{
-	USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, 0xa101, USB_CLASS_COMM,
-			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-	.driver_info = 0,
-},
-#endif
-
 /* WHITELIST!!!
  *
  * CDC Ether uses two interfaces, not necessarily consecutive.
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index eab078b..31d13ca 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2013 Realtek Semiconductor Corp. All rights reserved.
+ *  Copyright (c) 2014 Realtek Semiconductor Corp. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -24,7 +24,7 @@
 #include <linux/ipv6.h>
 
 /* Version Information */
-#define DRIVER_VERSION "v1.03.0 (2013/12/26)"
+#define DRIVER_VERSION "v1.04.0 (2014/01/15)"
 #define DRIVER_AUTHOR "Realtek linux nic maintainers <nic_swsd@realtek.com>"
 #define DRIVER_DESC "Realtek RTL8152/RTL8153 Based USB Ethernet Adapters"
 #define MODULENAME "r8152"
@@ -450,6 +450,9 @@ enum rtl8152_flags {
 #define MCU_TYPE_PLA			0x0100
 #define MCU_TYPE_USB			0x0000
 
+#define REALTEK_USB_DEVICE(vend, prod)	\
+	USB_DEVICE_INTERFACE_CLASS(vend, prod, USB_CLASS_VENDOR_SPEC)
+
 struct rx_desc {
 	__le32 opts1;
 #define RX_LEN_MASK			0x7fff
@@ -2738,11 +2741,6 @@ static int rtl8152_probe(struct usb_interface *intf,
 	struct net_device *netdev;
 	int ret;
 
-	if (udev->actconfig->desc.bConfigurationValue != 1) {
-		usb_driver_set_configuration(udev, 1);
-		return -ENODEV;
-	}
-
 	netdev = alloc_etherdev(sizeof(struct r8152));
 	if (!netdev) {
 		dev_err(&intf->dev, "Out of memory\n");
@@ -2823,9 +2821,9 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 
 /* table of devices that work with this driver */
 static struct usb_device_id rtl8152_table[] = {
-	{USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8152)},
-	{USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8153)},
-	{USB_DEVICE(VENDOR_ID_SAMSUNG, PRODUCT_ID_SAMSUNG)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8152)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8153)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, PRODUCT_ID_SAMSUNG)},
 	{}
 };
 
diff --git a/drivers/net/usb/r815x.c b/drivers/net/usb/r815x.c
index 5fd2ca6..f0a8791 100644
--- a/drivers/net/usb/r815x.c
+++ b/drivers/net/usb/r815x.c
@@ -216,21 +216,13 @@ static const struct usb_device_id products[] = {
 {
 	USB_DEVICE_AND_INTERFACE_INFO(REALTEK_VENDOR_ID, 0x8152, USB_CLASS_COMM,
 			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-#if defined(CONFIG_USB_RTL8152) || defined(CONFIG_USB_RTL8152_MODULE)
-	.driver_info = 0,
-#else
 	.driver_info = (unsigned long) &r8152_info,
-#endif
 },
 
 {
 	USB_DEVICE_AND_INTERFACE_INFO(REALTEK_VENDOR_ID, 0x8153, USB_CLASS_COMM,
 			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
-#if defined(CONFIG_USB_RTL8152) || defined(CONFIG_USB_RTL8152_MODULE)
-	.driver_info = 0,
-#else
 	.driver_info = (unsigned long) &r8153_info,
-#endif
 },
 
 	{ },		/* END */
-- 
1.8.4.2

