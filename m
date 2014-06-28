Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbaF1TM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:12:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaF1Rr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 29/77] USB: usb_wwan: fix write and suspend race
Date: Sat, 28 Jun 2014 10:46:22 -0700
Message-Id: <20140628174523.033050507@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 170fad9e22df0063eba0701adb966786d7a4ec5a upstream.

Fix race between write() and suspend() which could lead to writes being
dropped (or I/O while suspended) if the device is runtime suspended
while a write request is being processed.

Specifically, suspend() releases the susp_lock after determining the
device is idle but before setting the suspended flag, thus leaving a
window where a concurrent write() can submit an urb.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb_wwan.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -583,20 +583,17 @@ static void stop_read_write_urbs(struct
 int usb_wwan_suspend(struct usb_serial *serial, pm_message_t message)
 {
 	struct usb_wwan_intf_private *intfdata = serial->private;
-	int b;
 
+	spin_lock_irq(&intfdata->susp_lock);
 	if (PMSG_IS_AUTO(message)) {
-		spin_lock_irq(&intfdata->susp_lock);
-		b = intfdata->in_flight;
-		spin_unlock_irq(&intfdata->susp_lock);
-
-		if (b)
+		if (intfdata->in_flight) {
+			spin_unlock_irq(&intfdata->susp_lock);
 			return -EBUSY;
+		}
 	}
-
-	spin_lock_irq(&intfdata->susp_lock);
 	intfdata->suspended = 1;
 	spin_unlock_irq(&intfdata->susp_lock);
+
 	stop_read_write_urbs(serial);
 
 	return 0;


