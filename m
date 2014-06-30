Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbaF3MjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:39:23 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932233AbaF3Mbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 132/181] USB: usb_wwan: fix potential blocked I/O after resume
Date: Mon, 30 Jun 2014 13:52:33 +0200
Message-Id: <8e40ae5a4547a752fd7778097e0ab6948c51f27f.1404128998.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/usb_wwan.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index ee142cbc7c1f..ad5fff4399d7 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -623,12 +623,12 @@ int usb_wwan_suspend(struct usb_serial *serial, pm_message_t message)
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
@@ -645,6 +645,8 @@ static void play_delayed(struct usb_serial_port *port)
 			break;
 		}
 	}
+
+	return err;
 }
 
 int usb_wwan_resume(struct usb_serial *serial)
@@ -654,7 +656,8 @@ int usb_wwan_resume(struct usb_serial *serial)
 	struct usb_wwan_intf_private *intfdata = serial->private;
 	struct usb_wwan_port_private *portdata;
 	struct urb *urb;
-	int err = 0;
+	int err;
+	int err_count = 0;
 
 	spin_lock_irq(&intfdata->susp_lock);
 	for (i = 0; i < serial->num_ports; i++) {
@@ -673,25 +676,31 @@ int usb_wwan_resume(struct usb_serial *serial)
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
2.0.0

