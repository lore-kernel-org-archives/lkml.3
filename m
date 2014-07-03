Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965189AbaGCJ2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:28:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52655 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774AbaGCJZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 189/198] USB: usb_wwan: fix urb leak at shutdown
Date: Thu,  3 Jul 2014 10:20:32 +0100
Message-Id: <1404379241-8590-190-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/usb_wwan.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index f5a001929029..ad5fff4399d7 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -422,12 +422,26 @@ int usb_wwan_open(struct tty_struct *tty, struct usb_serial_port *port)
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
 
@@ -436,6 +450,14 @@ void usb_wwan_close(struct usb_serial_port *port)
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
@@ -601,18 +623,6 @@ int usb_wwan_suspend(struct usb_serial *serial, pm_message_t message)
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
 static int play_delayed(struct usb_serial_port *port)
 {
 	struct usb_wwan_intf_private *data;
-- 
1.9.1

