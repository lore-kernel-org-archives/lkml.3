Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaFPQye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:54:34 -0400
Received: from mx.exactcode.de ([85.10.202.90]:35878 "EHLO mx.exactcode.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbaFPQyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:54:32 -0400
X-Greylist: delayed 1671 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 12:54:32 EDT
From: ExactCODE <rene@exactcode.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Microsoft Sufrace Dock USB Ethernet
Message-Id: <13982460-3633-4BA4-A466-31E5A27C2F41@exactcode.com>
Date: Mon, 16 Jun 2014 18:26:27 +0200
To: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
X-Mailer: Apple Mail (2.1878.2)
X-Spam-Score: -1.7 (-)
X-Spam-Report: Spam detection software, running on the system "exactcode.de", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Currently the cdc_ether driver is matched for the Microsoft
	Surface Dock USB port, however it does not work and will not send/receive
	any packets. Instead using the r8152 driver explicitly appears to work fine
	for me, so far. [...] 
	Content analysis details:   (-1.7 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.5 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-0.2 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2042]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the cdc_ether driver is matched for the Microsoft Surface Dock USB port,
however it does not work and will not send/receive any packets. Instead using the
r8152 driver explicitly appears to work fine for me, so far.

 Signed-off-by: René Rebe <rene@exactcode.com>

--- linux-3.15/drivers/net/usb/cdc_ether.c.orig	2014-06-16 18:01:08.153110776 +0200
+++ linux-3.15/drivers/net/usb/cdc_ether.c	2014-06-16 18:03:21.465111094 +0200
@@ -659,6 +659,13 @@
 	.driver_info = 0,
 },
 
+/* Microsoft Surface Dock Ethernet Adapter */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(0x045e, 0x07ab, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* Samsung USB Ethernet Adapters */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, 0xa101, USB_CLASS_COMM,
--- linux-3.15/drivers/net/usb/r8152.c.orig	2014-06-16 18:00:54.873110744 +0200
+++ linux-3.15/drivers/net/usb/r8152.c	2014-06-16 18:04:45.721111295 +0200
@@ -459,6 +459,9 @@
 #define PRODUCT_ID_RTL8152		0x8152
 #define PRODUCT_ID_RTL8153		0x8153
 
+#define VENDOR_ID_MICROSOFT		0x045e
+#define PRODUCT_ID_MICROSOFT		0x07ab
+
 #define VENDOR_ID_SAMSUNG		0x04e8
 #define PRODUCT_ID_SAMSUNG		0xa101
 
@@ -3381,6 +3384,22 @@
 		}
 		break;
 
+	case VENDOR_ID_MICROSOFT:
+		switch (id->idProduct) {
+		case PRODUCT_ID_MICROSOFT:
+			ops->init		= r8152b_init;
+			ops->enable		= rtl8152_enable;
+			ops->disable		= rtl8152_disable;
+			ops->up			= r8152b_exit_oob;
+			ops->down		= rtl8152_down;
+			ops->unload		= rtl8152_unload;
+			ret = 0;
+			break;
+		default:
+			break;
+		}
+		break;
+
 	case VENDOR_ID_SAMSUNG:
 		switch (id->idProduct) {
 		case PRODUCT_ID_SAMSUNG:
@@ -3512,6 +3531,7 @@
 static struct usb_device_id rtl8152_table[] = {
 	{USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8152)},
 	{USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8153)},
+	{USB_DEVICE(VENDOR_ID_MICROSOFT, PRODUCT_ID_MICROSOFT)},
 	{USB_DEVICE(VENDOR_ID_SAMSUNG, PRODUCT_ID_SAMSUNG)},
 	{}
 };
-- 
ExactCODE GmbH, Jaegerstr. 67, DE-10117 Berlin
DE Legal: Amtsgericht Berlin (Charlottenburg) HRB 105123B, Tax-ID#: DE251602478
Managing Director: René Rebe
http://exactcode.com | http://exactscan.com | http://ocrkit.com | http://t2-project.org | http://rene.rebe.de

