Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbbAYSYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:24:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbbAYSKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Reinhard Speyerer <rspmn@arcor.de>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.18 145/183] USB: qcserial/option: make AT URCs work for Sierra Wireless MC73xx
Date: Sun, 25 Jan 2015 10:07:47 -0800
Message-Id: <20150125180816.469536296@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinhard Speyerer <rspmn@arcor.de>

commit d80c0d14183516f184a5ac88e11008ee4c7d2a2e upstream.

As has been discussed in the thread starting with
https://lkml.kernel.org/g/549748e9.d+SiJzqu50f1r4lSAL043YSc@arcor.de
Sierra Wireless MC73xx devices with USB VID/PID 0x1199:0x68c0 require the
option_send_setup() code to be used on the USB interface for the AT port
to make unsolicited response codes work correctly. Move these devices from
the qcserial driver where they have been added by commit
70a3615fc07c2330ed7c1e922f3c44f4a67c0762 ("usb: qcserial: add Sierra Wireless
MC73xx") to the option driver and add a MC73xx-specific blacklist
to ensure that
1. the sendsetup code is not used for the DIAG/DM and NMEA interfaces
2. the option driver does not attach to the QMI/network interfaces

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c   |   11 ++++++++++-
 drivers/usb/serial/qcserial.c |    1 -
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -234,6 +234,8 @@ static void option_instat_callback(struc
 
 #define QUALCOMM_VENDOR_ID			0x05C6
 
+#define SIERRA_VENDOR_ID			0x1199
+
 #define CMOTECH_VENDOR_ID			0x16d8
 #define CMOTECH_PRODUCT_6001			0x6001
 #define CMOTECH_PRODUCT_CMU_300			0x6002
@@ -512,7 +514,7 @@ enum option_blacklist_reason {
 		OPTION_BLACKLIST_RESERVED_IF = 2
 };
 
-#define MAX_BL_NUM  8
+#define MAX_BL_NUM  11
 struct option_blacklist_info {
 	/* bitfield of interface numbers for OPTION_BLACKLIST_SENDSETUP */
 	const unsigned long sendsetup;
@@ -601,6 +603,11 @@ static const struct option_blacklist_inf
 	.reserved = BIT(1) | BIT(5),
 };
 
+static const struct option_blacklist_info sierra_mc73xx_blacklist = {
+	.sendsetup = BIT(0) | BIT(2),
+	.reserved = BIT(8) | BIT(10) | BIT(11),
+};
+
 static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -1098,6 +1105,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000)}, /* SIMCom SIM5218 */
+	{ USB_DEVICE_INTERFACE_CLASS(SIERRA_VENDOR_ID, 0x68c0, 0xff),
+	  .driver_info = (kernel_ulong_t)&sierra_mc73xx_blacklist }, /* MC73xx */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6003),
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -142,7 +142,6 @@ static const struct usb_device_id id_tab
 	{DEVICE_SWI(0x0f3d, 0x68a2)},	/* Sierra Wireless MC7700 */
 	{DEVICE_SWI(0x114f, 0x68a2)},	/* Sierra Wireless MC7750 */
 	{DEVICE_SWI(0x1199, 0x68a2)},	/* Sierra Wireless MC7710 */
-	{DEVICE_SWI(0x1199, 0x68c0)},	/* Sierra Wireless MC73xx */
 	{DEVICE_SWI(0x1199, 0x901c)},	/* Sierra Wireless EM7700 */
 	{DEVICE_SWI(0x1199, 0x901f)},	/* Sierra Wireless EM7355 */
 	{DEVICE_SWI(0x1199, 0x9040)},	/* Sierra Wireless Modem */


