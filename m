Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbaGHTPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:15:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54356 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755767AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.18141931@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 031/125] USB: usb_wwan: fix write and suspend race
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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/usb_wwan.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -647,22 +647,19 @@ EXPORT_SYMBOL(usb_wwan_release);
 int usb_wwan_suspend(struct usb_serial *serial, pm_message_t message)
 {
 	struct usb_wwan_intf_private *intfdata = serial->private;
-	int b;
 
 	dbg("%s entered", __func__);
 
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

