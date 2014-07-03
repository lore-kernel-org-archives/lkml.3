Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030840AbaGCKGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:06:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51766 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaGCJWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 064/198] USB: usb_wwan: fix potential blocked I/O after resume
Date: Thu,  3 Jul 2014 10:18:27 +0100
Message-Id: <1404379241-8590-65-git-send-email-luis.henriques@canonical.com>
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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/usb_wwan.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index be684101257c..f5a001929029 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -613,12 +613,12 @@ static void unbusy_queued_urb(struct urb *urb, struct usb_wwan_port_private *por
 	}
 }
 
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
@@ -635,6 +635,8 @@ static void play_delayed(struct usb_serial_port *port)
 			break;
 		}
 	}
+
+	return err;
 }
 
 int usb_wwan_resume(struct usb_serial *serial)
@@ -644,7 +646,8 @@ int usb_wwan_resume(struct usb_serial *serial)
 	struct usb_wwan_intf_private *intfdata = serial->private;
 	struct usb_wwan_port_private *portdata;
 	struct urb *urb;
-	int err = 0;
+	int err;
+	int err_count = 0;
 
 	spin_lock_irq(&intfdata->susp_lock);
 	for (i = 0; i < serial->num_ports; i++) {
@@ -663,25 +666,31 @@ int usb_wwan_resume(struct usb_serial *serial)
 				dev_err(&port->dev,
 					"%s: submit int urb failed: %d\n",
 					__func__, err);
+				err_count++;
 			}
 		}
 
+		err = play_delayed(port);
+		if (err)
+			err_count++;
+
 		for (j = 0; j < N_IN_URB; j++) {
 			urb = portdata->in_urbs[j];
 			err = usb_submit_urb(urb, GFP_ATOMIC);
 			if (err < 0) {
 				dev_err(&port->dev, "%s: Error %d for bulk URB %d\n",
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
-- 
1.9.1

