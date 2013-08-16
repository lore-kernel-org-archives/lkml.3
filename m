Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3HPWnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:43:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51943 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab3HPWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 052/133] USB: mos7840: fix race in register handling
Date: Fri, 16 Aug 2013 15:33:14 -0700
Message-Id: <1376692475-28413-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d8a083cc746664916d9d36ed9e4d08a29525f245 upstream.

Fix race in mos7840_get_reg which unconditionally manipulated the
control urb (which may already be in use) by adding a control-urb busy
flag.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/mos7840.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 06ca54a..eab52f6 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -183,6 +183,10 @@
 #define LED_ON_MS	500
 #define LED_OFF_MS	500
 
+enum mos7840_flag {
+	MOS7840_FLAG_CTRL_BUSY,
+};
+
 static int device_type;
 
 static const struct usb_device_id id_table[] = {
@@ -243,6 +247,8 @@ struct moschip_port {
 	bool led_flag;
 	struct timer_list led_timer1;	/* Timer for LED on */
 	struct timer_list led_timer2;	/* Timer for LED off */
+
+	unsigned long flags;
 };
 
 /*
@@ -487,10 +493,10 @@ static void mos7840_control_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
 		dev_dbg(dev, "%s - urb shutting down with status: %d\n", __func__, status);
-		return;
+		goto out;
 	default:
 		dev_dbg(dev, "%s - nonzero urb status received: %d\n", __func__, status);
-		return;
+		goto out;
 	}
 
 	dev_dbg(dev, "%s urb buffer size is %d\n", __func__, urb->actual_length);
@@ -503,6 +509,8 @@ static void mos7840_control_callback(struct urb *urb)
 		mos7840_handle_new_msr(mos7840_port, regval);
 	else if (mos7840_port->MsrLsr == 1)
 		mos7840_handle_new_lsr(mos7840_port, regval);
+out:
+	clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mos7840_port->flags);
 }
 
 static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
@@ -513,6 +521,9 @@ static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
 	unsigned char *buffer = mcs->ctrl_buf;
 	int ret;
 
+	if (test_and_set_bit_lock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags))
+		return -EBUSY;
+
 	dr->bRequestType = MCS_RD_RTYPE;
 	dr->bRequest = MCS_RDREQ;
 	dr->wValue = cpu_to_le16(Wval);	/* 0 */
@@ -524,6 +535,9 @@ static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
 			     mos7840_control_callback, mcs);
 	mcs->control_urb->transfer_buffer_length = 2;
 	ret = usb_submit_urb(mcs->control_urb, GFP_ATOMIC);
+	if (ret)
+		clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags);
+
 	return ret;
 }
 
-- 
1.8.1.2

