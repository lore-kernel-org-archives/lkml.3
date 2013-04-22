Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3DVUpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:45:36 -0400
Received: from ven69-h01-31-33-9-98.dsl.sta.abo.bbox.fr ([31.33.9.98]:46598
	"EHLO laptop-kevin.kbaradon.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755322Ab3DVUpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:45:34 -0400
From: Kevin Baradon <kevin.baradon@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kevin Baradon <kevin.baradon@gmail.com>
Subject: [PATCH 2/4] media/rc/imon.c: make send_packet() delay larger for 15c2:0036 [v2]
Date: Mon, 22 Apr 2013 22:09:44 +0200
Message-Id: <1366661386-6720-3-git-send-email-kevin.baradon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366661386-6720-1-git-send-email-kevin.baradon@gmail.com>
References: <1366661386-6720-1-git-send-email-kevin.baradon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imon device 15c2:0036 need a higher delay between send_packet() calls.
Also use interruptible wait to avoid load average going too high (and let caller handle signals).

Signed-off-by: Kevin Baradon <kevin.baradon@gmail.com>
---
 drivers/media/rc/imon.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index e5d1c0d..624fd33 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -112,6 +112,7 @@ struct imon_context {
 	bool tx_control;
 	unsigned char usb_rx_buf[8];
 	unsigned char usb_tx_buf[8];
+	unsigned int send_packet_delay;
 
 	struct tx_t {
 		unsigned char data_buf[35];	/* user data buffer */
@@ -185,6 +186,10 @@ enum {
 	IMON_KEY_PANEL	= 2,
 };
 
+enum {
+	IMON_NEED_20MS_PKT_DELAY = 1
+};
+
 /*
  * USB Device ID for iMON USB Control Boards
  *
@@ -215,7 +220,7 @@ static struct usb_device_id imon_usb_id_table[] = {
 	/* SoundGraph iMON OEM Touch LCD (IR & 4.3" VGA LCD) */
 	{ USB_DEVICE(0x15c2, 0x0035) },
 	/* SoundGraph iMON OEM VFD (IR & VFD) */
-	{ USB_DEVICE(0x15c2, 0x0036) },
+	{ USB_DEVICE(0x15c2, 0x0036), .driver_info = IMON_NEED_20MS_PKT_DELAY },
 	/* device specifics unknown */
 	{ USB_DEVICE(0x15c2, 0x0037) },
 	/* SoundGraph iMON OEM LCD (IR & LCD) */
@@ -535,12 +540,12 @@ static int send_packet(struct imon_context *ictx)
 	kfree(control_req);
 
 	/*
-	 * Induce a mandatory 5ms delay before returning, as otherwise,
+	 * Induce a mandatory delay before returning, as otherwise,
 	 * send_packet can get called so rapidly as to overwhelm the device,
 	 * particularly on faster systems and/or those with quirky usb.
 	 */
-	timeout = msecs_to_jiffies(5);
-	set_current_state(TASK_UNINTERRUPTIBLE);
+	timeout = msecs_to_jiffies(ictx->send_packet_delay);
+	set_current_state(TASK_INTERRUPTIBLE);
 	schedule_timeout(timeout);
 
 	return retval;
@@ -2088,7 +2093,8 @@ static bool imon_find_endpoints(struct imon_context *ictx,
 
 }
 
-static struct imon_context *imon_init_intf0(struct usb_interface *intf)
+static struct imon_context *imon_init_intf0(struct usb_interface *intf,
+					    const struct usb_device_id *id)
 {
 	struct imon_context *ictx;
 	struct urb *rx_urb;
@@ -2128,6 +2134,10 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf)
 	ictx->vendor  = le16_to_cpu(ictx->usbdev_intf0->descriptor.idVendor);
 	ictx->product = le16_to_cpu(ictx->usbdev_intf0->descriptor.idProduct);
 
+	/* default send_packet delay is 5ms but some devices need more */
+	ictx->send_packet_delay = id->driver_info & IMON_NEED_20MS_PKT_DELAY ?
+				  20 : 5;
+
 	ret = -ENODEV;
 	iface_desc = intf->cur_altsetting;
 	if (!imon_find_endpoints(ictx, iface_desc)) {
@@ -2306,7 +2316,7 @@ static int imon_probe(struct usb_interface *interface,
 	first_if_ctx = usb_get_intfdata(first_if);
 
 	if (ifnum == 0) {
-		ictx = imon_init_intf0(interface);
+		ictx = imon_init_intf0(interface, id);
 		if (!ictx) {
 			pr_err("failed to initialize context!\n");
 			ret = -ENODEV;
-- 
1.7.10.4

