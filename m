Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaGHTRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:17:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54349 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755760AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.232251643@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 032/125] USB: usb_wwan: fix urb leak at shutdown
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/usb_wwan.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -434,12 +434,26 @@ int usb_wwan_open(struct tty_struct *tty
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
 
 	dbg("%s", __func__);
 	portdata = usb_get_serial_port_data(port);
@@ -450,6 +464,14 @@ void usb_wwan_close(struct usb_serial_po
 		portdata->opened = 0;
 		spin_unlock_irq(&intfdata->susp_lock);
 
+		for (;;) {
+			urb = usb_get_from_anchor(&portdata->delayed);
+			if (!urb)
+				break;
+			unbusy_queued_urb(urb, portdata);
+			usb_autopm_put_interface_async(serial->interface);
+		}
+
 		for (i = 0; i < N_IN_URB; i++)
 			usb_kill_urb(portdata->in_urbs[i]);
 		for (i = 0; i < N_OUT_URB; i++)
@@ -666,18 +688,6 @@ int usb_wwan_suspend(struct usb_serial *
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

