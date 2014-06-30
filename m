Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaF3LzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:55:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52128 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752950AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 104/181] USB: usbtest: add a timeout for scatter-gather tests
Date: Mon, 30 Jun 2014 13:52:05 +0200
Message-Id: <684e9f2e2acc1c5745e7304c073dab0022ef3aea.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 32b36eeae6a859670d2939a7d6136cb5e9ed64f8 upstream.

In usbtest, tests 5 - 8 use the scatter-gather library in usbcore
without any sort of timeout.  If there's a problem in the gadget or
host controller being tested, the test can hang.

This patch adds a 10-second timeout to the tests, so that they will
fail gracefully with an ETIMEDOUT error instead of hanging.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Huang Rui <ray.huang@amd.com>
Tested-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/misc/usbtest.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index d90556eb8da5..9a1297eb1abc 100644
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
2.0.0

