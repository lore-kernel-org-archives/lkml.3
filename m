Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbaF1TYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:24:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaF1RrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.4 27/43] USB: sierra: fix urb and memory leak on disconnect
Date: Sat, 28 Jun 2014 10:46:18 -0700
Message-Id: <20140628174451.044300406@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 014333f77c0b71123d6ef7d31a9724e0699c9548 upstream.

The delayed-write queue was never emptied on disconnect, something which
would lead to leaked urbs and transfer buffers if the device is
disconnected before being runtime resumed due to a write.

Fixes: e6929a9020ac ("USB: support for autosuspend in sierra while
online")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/sierra.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -801,6 +801,7 @@ static void sierra_close(struct usb_seri
 	struct usb_serial *serial = port->serial;
 	struct sierra_port_private *portdata;
 	struct sierra_intf_private *intfdata = port->serial->private;
+	struct urb *urb;
 
 
 	dev_dbg(&port->dev, "%s\n", __func__);
@@ -825,6 +826,17 @@ static void sierra_close(struct usb_seri
 		portdata->opened = 0;
 		spin_unlock_irq(&intfdata->susp_lock);
 
+		for (;;) {
+			urb = usb_get_from_anchor(&portdata->delayed);
+			if (!urb)
+				break;
+			kfree(urb->transfer_buffer);
+			usb_free_urb(urb);
+			usb_autopm_put_interface_async(serial->interface);
+			spin_lock(&portdata->lock);
+			portdata->outstanding_urbs--;
+			spin_unlock(&portdata->lock);
+		}
 
 		/* Stop reading urbs */
 		sierra_stop_rx_urbs(port);


