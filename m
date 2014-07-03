Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030325AbaGCJa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:30:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030561AbaGCJZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 175/198] usb: usbtest: Add timetout to simple_io()
Date: Thu,  3 Jul 2014 10:20:18 +0100
Message-Id: <1404379241-8590-176-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit e5e4746510d140261918aecce2e5e3aa4456f7e9 upstream.

Without a timetout some tests e.g. test_halt() can remain stuck forever.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/misc/usbtest.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index a36c46c9318a..41bdbaf70a6d 100644
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
1.9.1

