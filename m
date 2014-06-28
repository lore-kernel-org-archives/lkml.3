Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaF1T0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:26:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaF1RrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.4 23/43] USB: usb_wwan: fix potential blocked I/O after resume
Date: Sat, 28 Jun 2014 10:46:14 -0700
Message-Id: <20140628174450.868682825@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/usb_wwan.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -692,12 +692,12 @@ int usb_wwan_suspend(struct usb_serial *
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
@@ -714,6 +714,8 @@ static void play_delayed(struct usb_seri
 			break;
 		}
 	}
+
+	return err;
 }
 
 int usb_wwan_resume(struct usb_serial *serial)
@@ -723,7 +725,8 @@ int usb_wwan_resume(struct usb_serial *s
 	struct usb_wwan_intf_private *intfdata = serial->private;
 	struct usb_wwan_port_private *portdata;
 	struct urb *urb;
-	int err = 0;
+	int err;
+	int err_count = 0;
 
 	dbg("%s entered", __func__);
 
@@ -744,25 +747,31 @@ int usb_wwan_resume(struct usb_serial *s
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


