Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbaF1SpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:45:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbaF1Rtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.14 043/110] USB: usb_wwan: fix write and suspend race
Date: Sat, 28 Jun 2014 10:46:40 -0700
Message-Id: <20140628174547.713993946@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -579,20 +579,17 @@ static void stop_read_write_urbs(struct
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


