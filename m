Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888AbaF3Mbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:31:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964858AbaF3Mbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 131/181] USB: usb_wwan: fix potential NULL-deref at resume
Date: Mon, 30 Jun 2014 13:52:32 +0200
Message-Id: <2846637492b0a817882133dd7d8449f3e48d894b.1404128998.git.jslaby@suse.cz>
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

commit 9096f1fbba916c2e052651e9de82fcfb98d4bea7 upstream.

The interrupt urb was submitted unconditionally at resume, something
which could lead to a NULL-pointer dereference in the urb completion
handler as resume may be called after the port and port data is gone.

Fix this by making sure the interrupt urb is only submitted and active
when the port is open.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/usb_wwan.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index f155018a91a5..ee142cbc7c1f 100644
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
@@ -454,6 +462,7 @@ void usb_wwan_close(struct usb_serial_port *port)
 		usb_kill_urb(portdata->in_urbs[i]);
 	for (i = 0; i < N_OUT_URB; i++)
 		usb_kill_urb(portdata->out_urbs[i]);
+	usb_kill_urb(port->interrupt_in_urb);
 
 	/* balancing - important as an error cannot be handled*/
 	usb_autopm_get_interface_no_resume(serial->interface);
@@ -491,7 +500,6 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 	struct usb_wwan_port_private *portdata;
 	struct urb *urb;
 	u8 *buffer;
-	int err;
 	int i;
 
 	if (!port->bulk_in_size || !port->bulk_out_size)
@@ -531,13 +539,6 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 
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
@@ -655,22 +656,6 @@ int usb_wwan_resume(struct usb_serial *serial)
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
@@ -681,6 +666,16 @@ int usb_wwan_resume(struct usb_serial *serial)
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
2.0.0

