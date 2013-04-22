Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3DVUpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:45:16 -0400
Received: from ven69-h01-31-33-9-98.dsl.sta.abo.bbox.fr ([31.33.9.98]:46594
	"EHLO laptop-kevin.kbaradon.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754852Ab3DVUpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:45:14 -0400
X-Greylist: delayed 2073 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Apr 2013 16:45:14 EDT
From: Kevin Baradon <kevin.baradon@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kevin Baradon <kevin.baradon@gmail.com>
Subject: [PATCH 1/4] Revert "media/rc/imon.c: make send_packet() delay larger for 15c2:0036"
Date: Mon, 22 Apr 2013 22:09:43 +0200
Message-Id: <1366661386-6720-2-git-send-email-kevin.baradon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366661386-6720-1-git-send-email-kevin.baradon@gmail.com>
References: <1366661386-6720-1-git-send-email-kevin.baradon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit d92f150f9cb80b4df56331d1f42442da78e351f0.
It seems send_packet() is used during initialization, before send_packet_delay is set.

This will be fixed by another patch.

Signed-off-by: Kevin Baradon <kevin.baradon@gmail.com>
---
 drivers/media/rc/imon.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index b8f9f85..e5d1c0d 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -112,7 +112,6 @@ struct imon_context {
 	bool tx_control;
 	unsigned char usb_rx_buf[8];
 	unsigned char usb_tx_buf[8];
-	unsigned int send_packet_delay;
 
 	struct tx_t {
 		unsigned char data_buf[35];	/* user data buffer */
@@ -186,10 +185,6 @@ enum {
 	IMON_KEY_PANEL	= 2,
 };
 
-enum {
-	IMON_NEED_20MS_PKT_DELAY = 1
-};
-
 /*
  * USB Device ID for iMON USB Control Boards
  *
@@ -220,7 +215,7 @@ static struct usb_device_id imon_usb_id_table[] = {
 	/* SoundGraph iMON OEM Touch LCD (IR & 4.3" VGA LCD) */
 	{ USB_DEVICE(0x15c2, 0x0035) },
 	/* SoundGraph iMON OEM VFD (IR & VFD) */
-	{ USB_DEVICE(0x15c2, 0x0036), .driver_info = IMON_NEED_20MS_PKT_DELAY },
+	{ USB_DEVICE(0x15c2, 0x0036) },
 	/* device specifics unknown */
 	{ USB_DEVICE(0x15c2, 0x0037) },
 	/* SoundGraph iMON OEM LCD (IR & LCD) */
@@ -540,12 +535,12 @@ static int send_packet(struct imon_context *ictx)
 	kfree(control_req);
 
 	/*
-	 * Induce a mandatory delay before returning, as otherwise,
+	 * Induce a mandatory 5ms delay before returning, as otherwise,
 	 * send_packet can get called so rapidly as to overwhelm the device,
 	 * particularly on faster systems and/or those with quirky usb.
 	 */
-	timeout = msecs_to_jiffies(ictx->send_packet_delay);
-	set_current_state(TASK_INTERRUPTIBLE);
+	timeout = msecs_to_jiffies(5);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	schedule_timeout(timeout);
 
 	return retval;
@@ -2329,10 +2324,6 @@ static int imon_probe(struct usb_interface *interface,
 
 	}
 
-	/* default send_packet delay is 5ms but some devices need more */
-	ictx->send_packet_delay = id->driver_info & IMON_NEED_20MS_PKT_DELAY ?
-				  20 : 5;
-
 	usb_set_intfdata(interface, ictx);
 
 	if (ifnum == 0) {
-- 
1.7.10.4

