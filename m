Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbaGCKGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:06:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51750 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbaGCJWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 062/198] USB: usb_wwan: fix write and suspend race
Date: Thu,  3 Jul 2014 10:18:25 +0100
Message-Id: <1404379241-8590-63-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/usb_wwan.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 80c16d84156a..ede88f1e09a3 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -583,20 +583,17 @@ static void stop_read_write_urbs(struct usb_serial *serial)
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
-- 
1.9.1

