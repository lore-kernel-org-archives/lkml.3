Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967504Ab3HIB6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967479Ab3HIB6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 026/102] USB: mos7840: fix race in register handling
Date: Thu,  8 Aug 2013 18:57:02 -0700
Message-Id: <20130809015015.977967888@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d8a083cc746664916d9d36ed9e4d08a29525f245 upstream.

Fix race in mos7840_get_reg which unconditionally manipulated the
control urb (which may already be in use) by adding a control-urb busy
flag.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

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
@@ -241,6 +245,8 @@ struct moschip_port {
 	bool led_flag;
 	struct timer_list led_timer1;	/* Timer for LED on */
 	struct timer_list led_timer2;	/* Timer for LED off */
+
+	unsigned long flags;
 };
 
 /*
@@ -467,10 +473,10 @@ static void mos7840_control_callback(str
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
@@ -483,6 +489,8 @@ static void mos7840_control_callback(str
 		mos7840_handle_new_msr(mos7840_port, regval);
 	else if (mos7840_port->MsrLsr == 1)
 		mos7840_handle_new_lsr(mos7840_port, regval);
+out:
+	clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mos7840_port->flags);
 }
 
 static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
@@ -493,6 +501,9 @@ static int mos7840_get_reg(struct moschi
 	unsigned char *buffer = mcs->ctrl_buf;
 	int ret;
 
+	if (test_and_set_bit_lock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags))
+		return -EBUSY;
+
 	dr->bRequestType = MCS_RD_RTYPE;
 	dr->bRequest = MCS_RDREQ;
 	dr->wValue = cpu_to_le16(Wval);	/* 0 */
@@ -504,6 +515,9 @@ static int mos7840_get_reg(struct moschi
 			     mos7840_control_callback, mcs);
 	mcs->control_urb->transfer_buffer_length = 2;
 	ret = usb_submit_urb(mcs->control_urb, GFP_ATOMIC);
+	if (ret)
+		clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags);
+
 	return ret;
 }
 


