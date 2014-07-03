Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030854AbaGCKGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:06:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51760 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbaGCJWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 063/198] USB: usb_wwan: fix potential NULL-deref at resume
Date: Thu,  3 Jul 2014 10:18:26 +0100
Message-Id: <1404379241-8590-64-git-send-email-luis.henriques@canonical.com>
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

commit 9096f1fbba916c2e052651e9de82fcfb98d4bea7 upstream.

The interrupt urb was submitted unconditionally at resume, something
which could lead to a NULL-pointer dereference in the urb completion
handler as resume may be called after the port and port data is gone.

Fix this by making sure the interrupt urb is only submitted and active
when the port is open.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/usb_wwan.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index ede88f1e09a3..be684101257c 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -388,6 +388,14 @@ int usb_wwan_open(struct tty_struct *tty, struct usb_serial_port *port)
 	portdata = usb_get_serial_port_data(port);
 	intfdata = serial->private;
 
+	if (port->interrupt_in_urb) {
+		err = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
+		if (err) {
+			dev_dbg(&port->dev, "%s: submit int urb failed: %d\n",
+				__func__, err);
+		}
+	}
+
 	/* Start reading from the IN endpoint */
 	for (i = 0; i < N_IN_URB; i++) {
 		urb = portdata->in_urbs[i];
@@ -432,6 +440,7 @@ void usb_wwan_close(struct usb_serial_port *port)
 		usb_kill_urb(portdata->in_urbs[i]);
 	for (i = 0; i < N_OUT_URB; i++)
 		usb_kill_urb(portdata->out_urbs[i]);
+	usb_kill_urb(port->interrupt_in_urb);
 
 	/* balancing - important as an error cannot be handled*/
 	usb_autopm_get_interface_no_resume(serial->interface);
@@ -469,7 +478,6 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 	struct usb_wwan_port_private *portdata;
 	struct urb *urb;
 	u8 *buffer;
-	int err;
 	int i;
 
 	if (!port->bulk_in_size || !port->bulk_out_size)
@@ -509,13 +517,6 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 
 	usb_set_serial_port_data(port, portdata);
 
-	if (port->interrupt_in_urb) {
-		err = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
-		if (err)
-			dev_dbg(&port->dev, "%s: submit irq_in urb failed %d\n",
-				__func__, err);
-	}
-
 	return 0;
 
 bail_out_error2:
@@ -645,22 +646,6 @@ int usb_wwan_resume(struct usb_serial *serial)
 	struct urb *urb;
 	int err = 0;
 
-	/* get the interrupt URBs resubmitted unconditionally */
-	for (i = 0; i < serial->num_ports; i++) {
-		port = serial->port[i];
-		if (!port->interrupt_in_urb) {
-			dev_dbg(&port->dev, "%s: No interrupt URB for port\n", __func__);
-			continue;
-		}
-		err = usb_submit_urb(port->interrupt_in_urb, GFP_NOIO);
-		dev_dbg(&port->dev, "Submitted interrupt URB for port (result %d)\n", err);
-		if (err < 0) {
-			dev_err(&port->dev, "%s: Error %d for interrupt URB\n",
-				__func__, err);
-			goto err_out;
-		}
-	}
-
 	spin_lock_irq(&intfdata->susp_lock);
 	for (i = 0; i < serial->num_ports; i++) {
 		/* walk all ports */
@@ -671,6 +656,16 @@ int usb_wwan_resume(struct usb_serial *serial)
 		if (!portdata || !portdata->opened)
 			continue;
 
+		if (port->interrupt_in_urb) {
+			err = usb_submit_urb(port->interrupt_in_urb,
+					GFP_ATOMIC);
+			if (err) {
+				dev_err(&port->dev,
+					"%s: submit int urb failed: %d\n",
+					__func__, err);
+			}
+		}
+
 		for (j = 0; j < N_IN_URB; j++) {
 			urb = portdata->in_urbs[j];
 			err = usb_submit_urb(urb, GFP_ATOMIC);
-- 
1.9.1

