Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbaF1TGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:06:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaF1Rs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 36/77] USB: sierra: fix urb and memory leak on disconnect
Date: Sat, 28 Jun 2014 10:46:29 -0700
Message-Id: <20140628174523.420564160@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/serial/sierra.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -767,6 +767,7 @@ static void sierra_close(struct usb_seri
 	struct usb_serial *serial = port->serial;
 	struct sierra_port_private *portdata;
 	struct sierra_intf_private *intfdata = port->serial->private;
+	struct urb *urb;
 
 	portdata = usb_get_serial_port_data(port);
 
@@ -788,6 +789,18 @@ static void sierra_close(struct usb_seri
 	portdata->opened = 0;
 	spin_unlock_irq(&intfdata->susp_lock);
 
+	for (;;) {
+		urb = usb_get_from_anchor(&portdata->delayed);
+		if (!urb)
+			break;
+		kfree(urb->transfer_buffer);
+		usb_free_urb(urb);
+		usb_autopm_put_interface_async(serial->interface);
+		spin_lock(&portdata->lock);
+		portdata->outstanding_urbs--;
+		spin_unlock(&portdata->lock);
+	}
+
 	sierra_stop_rx_urbs(port);
 	for (i = 0; i < portdata->num_in_urbs; i++) {
 		sierra_release_urb(portdata->in_urbs[i]);


