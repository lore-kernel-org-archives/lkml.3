Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3LRKK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:10:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42188 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3LRKKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:10:23 -0500
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <ray.huang@amd.com>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/2] usb: usbtest: Add timetout to simple_io()
Date: Wed, 18 Dec 2013 15:40:10 +0530
Message-ID: <1387361411-15139-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without a timetout some tests e.g. test_halt() can remain stuck forever.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/misc/usbtest.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index b415282..6294e1b 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -10,6 +10,7 @@
 
 #include <linux/usb.h>
 
+#define SIMPLE_IO_TIMEOUT	10000	/* in milliseconds */
 
 /*-------------------------------------------------------------------------*/
 
@@ -366,6 +367,7 @@ static int simple_io(
 	int			max = urb->transfer_buffer_length;
 	struct completion	completion;
 	int			retval = 0;
+	unsigned long		expire;
 
 	urb->context = &completion;
 	while (retval == 0 && iterations-- > 0) {
@@ -378,9 +380,15 @@ static int simple_io(
 		if (retval != 0)
 			break;
 
-		/* NOTE:  no timeouts; can't be broken out of by interrupt */
-		wait_for_completion(&completion);
-		retval = urb->status;
+		expire = msecs_to_jiffies(SIMPLE_IO_TIMEOUT);
+		if (!wait_for_completion_timeout(&completion, expire)) {
+			usb_kill_urb(urb);
+			retval = (urb->status == -ENOENT ?
+				  -ETIMEDOUT : urb->status);
+		} else {
+			retval = urb->status;
+		}
+
 		urb->dev = udev;
 		if (retval == 0 && usb_pipein(urb->pipe))
 			retval = simple_check_buf(tdev, urb);
-- 
1.8.3.2

