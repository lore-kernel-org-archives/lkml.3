Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3KGNhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:37:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53290 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3KGNhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:37:37 -0500
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>, <stern@rowland.harvard.edu>, <bigeasy@linutronix.de>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, George Cherian <george.cherian@ti.com>
Subject: [PATCH] usb: gadget: f_mass_storage: call try_to_freeze only when its safe
Date: Thu, 7 Nov 2013 19:07:19 +0530
Message-ID: <1383831439-25558-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call try_to_freeze() in sleep_thread() only when its safe to sleep.
do_read() and do_write() calls sleep_thread with lock held.
Make sure these wont call try_to_freeze() by passing can_freeze flag
to sleep_thread.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/gadget/f_mass_storage.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index a03ba2c..f2d0d4b 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -602,13 +602,14 @@ static bool start_out_transfer(struct fsg_common *common, struct fsg_buffhd *bh)
 	return true;
 }
 
-static int sleep_thread(struct fsg_common *common)
+static int sleep_thread(struct fsg_common *common, bool can_freeze)
 {
 	int	rc = 0;
 
 	/* Wait until a signal arrives or we are woken up */
 	for (;;) {
-		try_to_freeze();
+		if (can_freeze)
+			try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (signal_pending(current)) {
 			rc = -EINTR;
@@ -682,7 +683,7 @@ static int do_read(struct fsg_common *common)
 		/* Wait for the next buffer to become available */
 		bh = common->next_buffhd_to_fill;
 		while (bh->state != BUF_STATE_EMPTY) {
-			rc = sleep_thread(common);
+			rc = sleep_thread(common, false);
 			if (rc)
 				return rc;
 		}
@@ -937,7 +938,7 @@ static int do_write(struct fsg_common *common)
 		}
 
 		/* Wait for something to happen */
-		rc = sleep_thread(common);
+		rc = sleep_thread(common, false);
 		if (rc)
 			return rc;
 	}
@@ -1504,7 +1505,7 @@ static int throw_away_data(struct fsg_common *common)
 		}
 
 		/* Otherwise wait for something to happen */
-		rc = sleep_thread(common);
+		rc = sleep_thread(common, true);
 		if (rc)
 			return rc;
 	}
@@ -1625,7 +1626,7 @@ static int send_status(struct fsg_common *common)
 	/* Wait for the next buffer to become available */
 	bh = common->next_buffhd_to_fill;
 	while (bh->state != BUF_STATE_EMPTY) {
-		rc = sleep_thread(common);
+		rc = sleep_thread(common, true);
 		if (rc)
 			return rc;
 	}
@@ -1828,7 +1829,7 @@ static int do_scsi_command(struct fsg_common *common)
 	bh = common->next_buffhd_to_fill;
 	common->next_buffhd_to_drain = bh;
 	while (bh->state != BUF_STATE_EMPTY) {
-		rc = sleep_thread(common);
+		rc = sleep_thread(common, true);
 		if (rc)
 			return rc;
 	}
@@ -2174,7 +2175,7 @@ static int get_next_command(struct fsg_common *common)
 	/* Wait for the next buffer to become available */
 	bh = common->next_buffhd_to_fill;
 	while (bh->state != BUF_STATE_EMPTY) {
-		rc = sleep_thread(common);
+		rc = sleep_thread(common, true);
 		if (rc)
 			return rc;
 	}
@@ -2193,7 +2194,7 @@ static int get_next_command(struct fsg_common *common)
 
 	/* Wait for the CBW to arrive */
 	while (bh->state != BUF_STATE_FULL) {
-		rc = sleep_thread(common);
+		rc = sleep_thread(common, true);
 		if (rc)
 			return rc;
 	}
@@ -2379,7 +2380,7 @@ static void handle_exception(struct fsg_common *common)
 			}
 			if (num_active == 0)
 				break;
-			if (sleep_thread(common))
+			if (sleep_thread(common, true))
 				return;
 		}
 
@@ -2516,7 +2517,7 @@ static int fsg_main_thread(void *common_)
 		}
 
 		if (!common->running) {
-			sleep_thread(common);
+			sleep_thread(common, true);
 			continue;
 		}
 
-- 
1.8.1

