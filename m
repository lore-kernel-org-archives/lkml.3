Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbaGCKIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:08:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51721 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbaGCJWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 057/198] USB: sierra: fix urb and memory leak on disconnect
Date: Thu,  3 Jul 2014 10:18:20 +0100
Message-Id: <1404379241-8590-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/sierra.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 5f7f64f70044..0988887e2059 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -767,6 +767,7 @@ static void sierra_close(struct usb_serial_port *port)
 	struct usb_serial *serial = port->serial;
 	struct sierra_port_private *portdata;
 	struct sierra_intf_private *intfdata = port->serial->private;
+	struct urb *urb;
 
 	portdata = usb_get_serial_port_data(port);
 
@@ -788,6 +789,18 @@ static void sierra_close(struct usb_serial_port *port)
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
-- 
1.9.1

