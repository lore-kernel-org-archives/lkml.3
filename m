Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbaF3Mbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:31:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964844AbaF3Mbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:37 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 130/181] USB: usb_wwan: fix urb leak at shutdown
Date: Mon, 30 Jun 2014 13:52:31 +0200
Message-Id: <a7ce85c750bd587927638f0e39bcb1277dc30ccd.1404128998.git.jslaby@suse.cz>
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

commit 79eed03e77d481b55d85d1cfe5a1636a0d3897fd upstream.

The delayed-write queue was never emptied at shutdown (close), something
which could lead to leaked urbs if the port is closed before being
runtime resumed due to a write.

When this happens the output buffer would not drain on close
(closing_wait timeout), and after consecutive opens, writes could be
corrupted with previously buffered data, transfered with reduced
throughput or completely blocked.

Note that unbusy_queued_urb() was simply moved out of CONFIG_PM.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/usb_wwan.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index ede88f1e09a3..f155018a91a5 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -414,12 +414,26 @@ int usb_wwan_open(struct tty_struct *tty, struct usb_serial_port *port)
 }
 EXPORT_SYMBOL(usb_wwan_open);
 
+static void unbusy_queued_urb(struct urb *urb,
+					struct usb_wwan_port_private *portdata)
+{
+	int i;
+
+	for (i = 0; i < N_OUT_URB; i++) {
+		if (urb == portdata->out_urbs[i]) {
+			clear_bit(i, &portdata->out_busy);
+			break;
+		}
+	}
+}
+
 void usb_wwan_close(struct usb_serial_port *port)
 {
 	int i;
 	struct usb_serial *serial = port->serial;
 	struct usb_wwan_port_private *portdata;
 	struct usb_wwan_intf_private *intfdata = port->serial->private;
+	struct urb *urb;
 
 	portdata = usb_get_serial_port_data(port);
 
@@ -428,6 +442,14 @@ void usb_wwan_close(struct usb_serial_port *port)
 	portdata->opened = 0;
 	spin_unlock_irq(&intfdata->susp_lock);
 
+	for (;;) {
+		urb = usb_get_from_anchor(&portdata->delayed);
+		if (!urb)
+			break;
+		unbusy_queued_urb(urb, portdata);
+		usb_autopm_put_interface_async(serial->interface);
+	}
+
 	for (i = 0; i < N_IN_URB; i++)
 		usb_kill_urb(portdata->in_urbs[i]);
 	for (i = 0; i < N_OUT_URB; i++)
@@ -600,18 +622,6 @@ int usb_wwan_suspend(struct usb_serial *serial, pm_message_t message)
 }
 EXPORT_SYMBOL(usb_wwan_suspend);
 
-static void unbusy_queued_urb(struct urb *urb, struct usb_wwan_port_private *portdata)
-{
-	int i;
-
-	for (i = 0; i < N_OUT_URB; i++) {
-		if (urb == portdata->out_urbs[i]) {
-			clear_bit(i, &portdata->out_busy);
-			break;
-		}
-	}
-}
-
 static void play_delayed(struct usb_serial_port *port)
 {
 	struct usb_wwan_intf_private *data;
-- 
2.0.0

