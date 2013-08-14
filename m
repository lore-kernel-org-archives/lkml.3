Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab3HNKhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:37:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34388 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592Ab3HNKhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 06/75] USB: mos7840: fix race in register handling
Date: Wed, 14 Aug 2013 11:35:55 +0100
Message-Id: <1376476624-10011-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d8a083cc746664916d9d36ed9e4d08a29525f245 upstream.

Fix race in mos7840_get_reg which unconditionally manipulated the
control urb (which may already be in use) by adding a control-urb busy
flag.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7840.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 297847b..fb0357f 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -188,6 +188,10 @@
 #define LED_ON_MS	500
 #define LED_OFF_MS	500
 
+enum mos7840_flag {
+	MOS7840_FLAG_CTRL_BUSY,
+};
+
 static int device_type;
 
 static const struct usb_device_id id_table[] = {
@@ -248,6 +252,8 @@ struct moschip_port {
 	bool led_flag;
 	struct timer_list led_timer1;	/* Timer for LED on */
 	struct timer_list led_timer2;	/* Timer for LED off */
+
+	unsigned long flags;
 };
 
 static bool debug;
@@ -508,11 +514,11 @@ static void mos7840_control_callback(struct urb *urb)
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d", __func__,
 		    status);
-		return;
+		goto out;
 	default:
 		dbg("%s - nonzero urb status received: %d", __func__,
 		    status);
-		return;
+		goto out;
 	}
 
 	dbg("%s urb buffer size is %d", __func__, urb->actual_length);
@@ -525,6 +531,8 @@ static void mos7840_control_callback(struct urb *urb)
 		mos7840_handle_new_msr(mos7840_port, regval);
 	else if (mos7840_port->MsrLsr == 1)
 		mos7840_handle_new_lsr(mos7840_port, regval);
+out:
+	clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mos7840_port->flags);
 }
 
 static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
@@ -535,6 +543,9 @@ static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
 	unsigned char *buffer = mcs->ctrl_buf;
 	int ret;
 
+	if (test_and_set_bit_lock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags))
+		return -EBUSY;
+
 	dr->bRequestType = MCS_RD_RTYPE;
 	dr->bRequest = MCS_RDREQ;
 	dr->wValue = cpu_to_le16(Wval);	/* 0 */
@@ -546,6 +557,9 @@ static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
 			     mos7840_control_callback, mcs);
 	mcs->control_urb->transfer_buffer_length = 2;
 	ret = usb_submit_urb(mcs->control_urb, GFP_ATOMIC);
+	if (ret)
+		clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags);
+
 	return ret;
 }
 
-- 
1.8.3.2

