Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbbA0M3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:29:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35332 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664AbbA0MT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Reinhard Speyerer <rspmn@arcor.de>, Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 093/126] USB: qcserial/option: make AT URCs work for Sierra Wireless MC73xx
Date: Tue, 27 Jan 2015 12:16:38 +0000
Message-Id: <1422361031-19364-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c   | 11 ++++++++++-
 drivers/usb/serial/qcserial.c |  1 -
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e87219a0f2f7..0cdbb6c56674 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -234,6 +234,8 @@ static void option_instat_callback(struct urb *urb);
 
 #define QUALCOMM_VENDOR_ID			0x05C6
 
+#define SIERRA_VENDOR_ID			0x1199
+
 #define CMOTECH_VENDOR_ID			0x16d8
 #define CMOTECH_PRODUCT_6001			0x6001
 #define CMOTECH_PRODUCT_CMU_300			0x6002
@@ -511,7 +513,7 @@ enum option_blacklist_reason {
 		OPTION_BLACKLIST_RESERVED_IF = 2
 };
 
-#define MAX_BL_NUM  8
+#define MAX_BL_NUM  11
 struct option_blacklist_info {
 	/* bitfield of interface numbers for OPTION_BLACKLIST_SENDSETUP */
 	const unsigned long sendsetup;
@@ -600,6 +602,11 @@ static const struct option_blacklist_info telit_le920_blacklist = {
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
@@ -1097,6 +1104,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000)}, /* SIMCom SIM5218 */
+	{ USB_DEVICE_INTERFACE_CLASS(SIERRA_VENDOR_ID, 0x68c0, 0xff),
+	  .driver_info = (kernel_ulong_t)&sierra_mc73xx_blacklist }, /* MC73xx */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6003),
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index cb3e14780a7e..9c63897b3a56 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -142,7 +142,6 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x0f3d, 0x68a2)},	/* Sierra Wireless MC7700 */
 	{DEVICE_SWI(0x114f, 0x68a2)},	/* Sierra Wireless MC7750 */
 	{DEVICE_SWI(0x1199, 0x68a2)},	/* Sierra Wireless MC7710 */
-	{DEVICE_SWI(0x1199, 0x68c0)},	/* Sierra Wireless MC73xx */
 	{DEVICE_SWI(0x1199, 0x901c)},	/* Sierra Wireless EM7700 */
 	{DEVICE_SWI(0x1199, 0x901f)},	/* Sierra Wireless EM7355 */
 	{DEVICE_SWI(0x1199, 0x9040)},	/* Sierra Wireless Modem */
-- 
2.1.4

