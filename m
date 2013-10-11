Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3JKMrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:47:11 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:54507 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab3JKMrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:47:09 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: giometti@enneenne.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH] pps : add non blocking option to PPS_FETCH ioctl.
Date: Fri, 11 Oct 2013 14:40:32 +0200
Message-Id: <1381495232-12152-1-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Fri, 11 Oct 2013 14:47:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PPS_FETCH ioctl is blocking still the reception of a PPS
event. But, in some case, one may immediately need the last event
date. This patch allow to get the result of PPS_FETCH if the device
has the O_NONBLOCK flag set.

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
---
 drivers/pps/pps.c | 57 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 2f07cd6..983f50c 100644
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

