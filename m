Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaGHTP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:15:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54357 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764AbaGHTIm (ORCPT
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
Message-ID: <lsq.1404846110.910982806@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 033/125] USB: usb_wwan: fix potential blocked I/O
 after resume
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

commit fb7ad4f93d9f0f7d49beda32f5e7becb94b29a4d upstream.

Keep trying to submit urbs rather than bail out on first read-urb
submission error, which would also prevent I/O for any further ports
from being resumed.

Instead keep an error count, for all types of failed submissions, and
let USB core know that something went wrong.

Also make sure to always clear the suspended flag. Currently a failed
read-urb submission would prevent cached writes as well as any
subsequent writes from being submitted until next suspend-resume cycle,
something which may not even necessarily happen.

Note that USB core currently only logs an error if an interface resume
failed.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/usb_wwan.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -688,12 +688,12 @@ int usb_wwan_suspend(struct usb_serial *
 }
 EXPORT_SYMBOL(usb_wwan_suspend);
 
-static void play_delayed(struct usb_serial_port *port)
+static int play_delayed(struct usb_serial_port *port)
 {
 	struct usb_wwan_intf_private *data;
 	struct usb_wwan_port_private *portdata;
 	struct urb *urb;
-	int err;
+	int err = 0;
 
 	portdata = usb_get_serial_port_data(port);
 	data = port->serial->private;
@@ -710,6 +710,8 @@ static void play_delayed(struct usb_seri
 			break;
 		}
 	}
+
+	return err;
 }
 
 int usb_wwan_resume(struct usb_serial *serial)
@@ -719,7 +721,8 @@ int usb_wwan_resume(struct usb_serial *s
 	struct usb_wwan_intf_private *intfdata = serial->private;
 	struct usb_wwan_port_private *portdata;
 	struct urb *urb;
-	int err = 0;
+	int err;
+	int err_count = 0;
 
 	dbg("%s entered", __func__);
 	/* get the interrupt URBs resubmitted unconditionally */
@@ -734,7 +737,7 @@ int usb_wwan_resume(struct usb_serial *s
 		if (err < 0) {
 			err("%s: Error %d for interrupt URB of port%d",
 			    __func__, err, i);
-			goto err_out;
+			err_count++;
 		}
 	}
 
@@ -748,22 +751,27 @@ int usb_wwan_resume(struct usb_serial *s
 		if (!portdata->opened)
 			continue;
 
+		err = play_delayed(port);
+		if (err)
+			err_count++;
+
 		for (j = 0; j < N_IN_URB; j++) {
 			urb = portdata->in_urbs[j];
 			err = usb_submit_urb(urb, GFP_ATOMIC);
 			if (err < 0) {
 				err("%s: Error %d for bulk URB %d",
 				    __func__, err, i);
-				spin_unlock_irq(&intfdata->susp_lock);
-				goto err_out;
+				err_count++;
 			}
 		}
-		play_delayed(port);
 	}
 	intfdata->suspended = 0;
 	spin_unlock_irq(&intfdata->susp_lock);
-err_out:
-	return err;
+
+	if (err_count)
+		return -EIO;
+
+	return 0;
 }
 EXPORT_SYMBOL(usb_wwan_resume);
 #endif

