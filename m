Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbaF1S1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:27:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaF1RvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH 3.15 015/139] USB: usbtest: add a timeout for scatter-gather tests
Date: Sat, 28 Jun 2014 10:46:16 -0700
Message-Id: <20140628174606.063562573@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/misc/usbtest.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

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
@@ -484,6 +484,14 @@ alloc_sglist(int nents, int max, int var
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


