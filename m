Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbbALSFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:05:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbbALSFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 004/216] s390/3215: fix hanging console issue
Date: Mon, 12 Jan 2015 18:02:01 +0000
Message-Id: <1421085933-32536-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 26d766c60f4ea08cd14f0f3435a6db3d6cc2ae96 upstream.

The ccw_device_start in raw3215_start_io can fail. raw3215_try_io
does not check if the request could be started and removes any
pending timer. This can leave the system in a hanging state.
Check for pending request after raw3215_start_io and start a
timer if necessary.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/char/con3215.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 5af7f0bd6125..a6d47e5eee9e 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -288,12 +288,16 @@ static void raw3215_timeout(unsigned long __data)
 	unsigned long flags;
 
 	spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
-	if (raw->flags & RAW3215_TIMER_RUNS) {
-		del_timer(&raw->timer);
-		raw->flags &= ~RAW3215_TIMER_RUNS;
-		if (!(raw->port.flags & ASYNC_SUSPENDED)) {
-			raw3215_mk_write_req(raw);
-			raw3215_start_io(raw);
+	raw->flags &= ~RAW3215_TIMER_RUNS;
+	if (!(raw->port.flags & ASYNC_SUSPENDED)) {
+		raw3215_mk_write_req(raw);
+		raw3215_start_io(raw);
+		if ((raw->queued_read || raw->queued_write) &&
+		    !(raw->flags & RAW3215_WORKING) &&
+		    !(raw->flags & RAW3215_TIMER_RUNS)) {
+			raw->timer.expires = RAW3215_TIMEOUT + jiffies;
+			add_timer(&raw->timer);
+			raw->flags |= RAW3215_TIMER_RUNS;
 		}
 	}
 	spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
@@ -317,17 +321,15 @@ static inline void raw3215_try_io(struct raw3215_info *raw)
 		    (raw->flags & RAW3215_FLUSHING)) {
 			/* execute write requests bigger than minimum size */
 			raw3215_start_io(raw);
-			if (raw->flags & RAW3215_TIMER_RUNS) {
-				del_timer(&raw->timer);
-				raw->flags &= ~RAW3215_TIMER_RUNS;
-			}
-		} else if (!(raw->flags & RAW3215_TIMER_RUNS)) {
-			/* delay small writes */
-			raw->timer.expires = RAW3215_TIMEOUT + jiffies;
-			add_timer(&raw->timer);
-			raw->flags |= RAW3215_TIMER_RUNS;
 		}
 	}
+	if ((raw->queued_read || raw->queued_write) &&
+	    !(raw->flags & RAW3215_WORKING) &&
+	    !(raw->flags & RAW3215_TIMER_RUNS)) {
+		raw->timer.expires = RAW3215_TIMEOUT + jiffies;
+		add_timer(&raw->timer);
+		raw->flags |= RAW3215_TIMER_RUNS;
+	}
 }
 
 /*
-- 
2.1.4

