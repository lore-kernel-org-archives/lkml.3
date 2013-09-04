Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934536Ab3IDIxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:53:30 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:56014 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934485Ab3IDIx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:53:28 -0400
X-Greylist: delayed 1581 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2013 04:53:27 EDT
From: Paul Chavent <Paul.Chavent@onera.fr>
To: giometti@enneenne.com, linux-kernel@vger.kernel.org
Cc: Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH] pps : add non blocking option to PPS_FETCH ioctl.
Date: Wed,  4 Sep 2013 10:20:38 +0200
Message-Id: <1378282838-2292-1-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Wed, 04 Sep 2013 10:26:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 drivers/pps/pps.c | 57 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 7173e3a..86ff57e 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -152,35 +152,38 @@ static long pps_cdev_ioctl(struct file *file,
 		if (err)
 			return -EFAULT;
 
-		ev = pps->last_ev;
-
-		/* Manage the timeout */
-		if (fdata.timeout.flags & PPS_TIME_INVALID)
-			err = wait_event_interruptible(pps->queue,
-					ev != pps->last_ev);
-		else {
-			unsigned long ticks;
-
-			dev_dbg(pps->dev, "timeout %lld.%09d\n",
-					(long long) fdata.timeout.sec,
-					fdata.timeout.nsec);
-			ticks = fdata.timeout.sec * HZ;
-			ticks += fdata.timeout.nsec / (NSEC_PER_SEC / HZ);
-
-			if (ticks != 0) {
-				err = wait_event_interruptible_timeout(
-						pps->queue,
-						ev != pps->last_ev,
-						ticks);
-				if (err == 0)
-					return -ETIMEDOUT;
+		if (!(file->f_flags & O_NONBLOCK)) {
+			ev = pps->last_ev;
+
+			/* Manage the timeout */
+			if (fdata.timeout.flags & PPS_TIME_INVALID)
+				err = wait_event_interruptible(pps->queue,
+						ev != pps->last_ev);
+			else {
+				unsigned long ticks;
+
+				dev_dbg(pps->dev, "timeout %lld.%09d\n",
+						(long long) fdata.timeout.sec,
+						fdata.timeout.nsec);
+				ticks = fdata.timeout.sec * HZ;
+				ticks += fdata.timeout.nsec /
+					(NSEC_PER_SEC / HZ);
+
+				if (ticks != 0) {
+					err = wait_event_interruptible_timeout(
+							pps->queue,
+							ev != pps->last_ev,
+							ticks);
+					if (err == 0)
+						return -ETIMEDOUT;
+				}
 			}
-		}
 
-		/* Check for pending signals */
-		if (err == -ERESTARTSYS) {
-			dev_dbg(pps->dev, "pending signal caught\n");
-			return -EINTR;
+			/* Check for pending signals */
+			if (err == -ERESTARTSYS) {
+				dev_dbg(pps->dev, "pending signal caught\n");
+				return -EINTR;
+			}
 		}
 
 		/* Return the fetched timestamp */
-- 
1.7.12.1

