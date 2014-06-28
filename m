Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbaF1Rvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:51:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaF1Rvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.15 051/139] USB: usb_wwan: fix urb leak at shutdown
Date: Sat, 28 Jun 2014 10:46:52 -0700
Message-Id: <20140628174607.770165465@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/usb_wwan.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -414,12 +414,26 @@ int usb_wwan_open(struct tty_struct *tty
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
 
@@ -428,6 +442,14 @@ void usb_wwan_close(struct usb_serial_po
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
@@ -596,18 +618,6 @@ int usb_wwan_suspend(struct usb_serial *
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


