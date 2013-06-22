Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3FVS4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 14:56:44 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:48362
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751090Ab3FVS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 14:56:41 -0400
From: Anders Hammarquist <iko@iko.pp.se>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Anders Hammarquist <iko@iko.pp.se>
Subject: [PATCH 2/2] Remove static sizing of usb_device_id arrays
Date: Sat, 22 Jun 2013 20:55:59 +0200
Message-Id: <1371927359-13977-2-git-send-email-iko@iko.pp.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371927359-13977-1-git-send-email-iko@iko.pp.se>
References: <20130621235603.GA1603@kroah.com>
 <1371927359-13977-1-git-send-email-iko@iko.pp.se>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Sat, 22 Jun 2013 20:56:35 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Anders Hammarquist <iko@iko.pp.se>
---
 drivers/usb/serial/ti_usb_3410_5052.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 26c1161..441c788 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -60,7 +60,20 @@
 #define TI_READ_URB_STOPPED	2
 
 #define TI_EXTRA_VID_PID_COUNT	5
-
+#define TI_EXTRA_VID_PID_INITALIZER {0}, {0}, {0}, {0}, {0}
+
+/* Check that TI_EXTRA_VID_PID_COUNT and TI_EXTRA_VID_PID_INITALIZER match.
+   On x86, this wastes one byte of __init space to provide a compile-time
+   error if you do not match up the definitions of TI_EXTRA_VID_PID_COUNT and
+   TI_EXTRA_VID_PID_INITIALIZER. Expect space waste up to sizeof(void *) for
+   other architectures. */
+__init void __ti_extra_vid_pid_test(void)
+{
+	struct { char a; } ti_extra_vid_pid_initializer[] =
+        	{ TI_EXTRA_VID_PID_INITALIZER };
+	BUILD_BUG_ON(ARRAY_SIZE(ti_extra_vid_pid_initializer) !=
+        	TI_EXTRA_VID_PID_COUNT);
+}
 
 /* Structures */
 
@@ -158,7 +171,7 @@ static unsigned int product_5052_count;
 /* the array dimension is the number of default entries plus */
 /* TI_EXTRA_VID_PID_COUNT user defined entries plus 1 terminating */
 /* null entry */
-static struct usb_device_id ti_id_table_3410[16+TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_3410[] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -175,16 +188,20 @@ static struct usb_device_id ti_id_table_3410[16+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_PRODUCT_ID) },
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
+	TI_EXTRA_VID_PID_INITALIZER, /* space for run-time VID-PID pairs */
+	{0} /* End of array maker */
 };
 
-static struct usb_device_id ti_id_table_5052[5+TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_5052[] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_BOOT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5152_BOOT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_EEPROM_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
+	TI_EXTRA_VID_PID_INITALIZER, /* space for run-time VID-PID pairs */
+	{0} /* End of array maker */
 };
 
-static struct usb_device_id ti_id_table_combined[20+2*TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_combined[] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -205,7 +222,9 @@ static struct usb_device_id ti_id_table_combined[20+2*TI_EXTRA_VID_PID_COUNT+1]
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_PRODUCT_ID) },
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
-	{ }
+	TI_EXTRA_VID_PID_INITALIZER, /* space for run-time VID-PID pairs */
+	TI_EXTRA_VID_PID_INITALIZER, /* Two needed, combined 3410 and 5052 */
+	{0} /* End of array maker */
 };
 
 static struct usb_serial_driver ti_1port_device = {
-- 
1.7.10.4

