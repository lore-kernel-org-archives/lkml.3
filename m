Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030551AbaGCJc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:32:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030544AbaGCJZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 176/198] USB: usbtest: add a timeout for scatter-gather tests
Date: Thu,  3 Jul 2014 10:20:19 +0100
Message-Id: <1404379241-8590-177-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 32b36eeae6a859670d2939a7d6136cb5e9ed64f8 upstream.

In usbtest, tests 5 - 8 use the scatter-gather library in usbcore
without any sort of timeout.  If there's a problem in the gadget or
host controller being tested, the test can hang.

This patch adds a 10-second timeout to the tests, so that they will
fail gracefully with an ETIMEDOUT error instead of hanging.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Huang Rui <ray.huang@amd.com>
Tested-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/misc/usbtest.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 41bdbaf70a6d..98438b90838f 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -7,7 +7,7 @@
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
 #include <linux/mutex.h>
-
+#include <linux/timer.h>
 #include <linux/usb.h>
 
 #define SIMPLE_IO_TIMEOUT	10000	/* in milliseconds */
@@ -484,6 +484,14 @@ alloc_sglist(int nents, int max, int vary)
 	return sg;
 }
 
+static void sg_timeout(unsigned long _req)
+{
+	struct usb_sg_request	*req = (struct usb_sg_request *) _req;
+
+	req->status = -ETIMEDOUT;
+	usb_sg_cancel(req);
+}
+
 static int perform_sglist(
 	struct usbtest_dev	*tdev,
 	unsigned		iterations,
@@ -495,6 +503,9 @@ static int perform_sglist(
 {
 	struct usb_device	*udev = testdev_to_usbdev(tdev);
 	int			retval = 0;
+	struct timer_list	sg_timer;
+
+	setup_timer_on_stack(&sg_timer, sg_timeout, (unsigned long) req);
 
 	while (retval == 0 && iterations-- > 0) {
 		retval = usb_sg_init(req, udev, pipe,
@@ -505,7 +516,10 @@ static int perform_sglist(
 
 		if (retval)
 			break;
+		mod_timer(&sg_timer, jiffies +
+				msecs_to_jiffies(SIMPLE_IO_TIMEOUT));
 		usb_sg_wait(req);
+		del_timer_sync(&sg_timer);
 		retval = req->status;
 
 		/* FIXME check resulting data pattern */
-- 
1.9.1

