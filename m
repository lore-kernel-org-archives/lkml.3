Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804Ab3IHDjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:39:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56087 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755974Ab3IHDTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.57899609@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [039/121] USB: mos7840: fix race in register handling
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d8a083cc746664916d9d36ed9e4d08a29525f245 upstream.

Fix race in mos7840_get_reg which unconditionally manipulated the
control urb (which may already be in use) by adding a control-urb busy
flag.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mos7840.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -185,6 +185,10 @@
 #define URB_TRANSFER_BUFFER_SIZE        32	/* URB Size  */
 
 
+enum mos7840_flag {
+	MOS7840_FLAG_CTRL_BUSY,
+};
+
 static const struct usb_device_id moschip_port_id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7840)},
 	{USB_DEVICE(USB_VENDOR_ID_MOSCHIP, MOSCHIP_DEVICE_ID_7820)},
@@ -258,6 +262,8 @@ struct moschip_port {
 	struct urb *write_urb_pool[NUM_URBS];
 	char busy[NUM_URBS];
 	bool read_urb_busy;
+
+	unsigned long flags;
 };
 
 
@@ -519,11 +525,11 @@ static void mos7840_control_callback(str
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
@@ -536,6 +542,8 @@ static void mos7840_control_callback(str
 		mos7840_handle_new_msr(mos7840_port, regval);
 	else if (mos7840_port->MsrLsr == 1)
 		mos7840_handle_new_lsr(mos7840_port, regval);
+out:
+	clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mos7840_port->flags);
 }
 
 static int mos7840_get_reg(struct moschip_port *mcs, __u16 Wval, __u16 reg,
@@ -546,6 +554,9 @@ static int mos7840_get_reg(struct moschi
 	unsigned char *buffer = mcs->ctrl_buf;
 	int ret;
 
+	if (test_and_set_bit_lock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags))
+		return -EBUSY;
+
 	dr->bRequestType = MCS_RD_RTYPE;
 	dr->bRequest = MCS_RDREQ;
 	dr->wValue = cpu_to_le16(Wval);	/* 0 */
@@ -557,6 +568,9 @@ static int mos7840_get_reg(struct moschi
 			     mos7840_control_callback, mcs);
 	mcs->control_urb->transfer_buffer_length = 2;
 	ret = usb_submit_urb(mcs->control_urb, GFP_ATOMIC);
+	if (ret)
+		clear_bit_unlock(MOS7840_FLAG_CTRL_BUSY, &mcs->flags);
+
 	return ret;
 }
 

