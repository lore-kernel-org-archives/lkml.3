Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbaF3Mlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:41:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867AbaF3MbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 136/181] USB: sierra: fix urb and memory leak on disconnect
Date: Mon, 30 Jun 2014 13:52:37 +0200
Message-Id: <e386ef8e2c352e24b25bd95f01957842bbbf1b92.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 014333f77c0b71123d6ef7d31a9724e0699c9548 upstream.

The delayed-write queue was never emptied on disconnect, something which
would lead to leaked urbs and transfer buffers if the device is
disconnected before being runtime resumed due to a write.

Fixes: e6929a9020ac ("USB: support for autosuspend in sierra while
online")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

