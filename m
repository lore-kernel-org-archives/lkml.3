Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbbAYTHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:07:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbbAYSJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.14 97/98] s390/3215: fix hanging console issue
Date: Sun, 25 Jan 2015 10:07:55 -0800
Message-Id: <20150125180717.096396934@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 26d766c60f4ea08cd14f0f3435a6db3d6cc2ae96 upstream.

The ccw_device_start in raw3215_start_io can fail. raw3215_try_io
does not check if the request could be started and removes any
pending timer. This can leave the system in a hanging state.
Check for pending request after raw3215_start_io and start a
timer if necessary.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/char/con3215.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -288,12 +288,16 @@ static void raw3215_timeout(unsigned lon
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
@@ -317,17 +321,15 @@ static inline void raw3215_try_io(struct
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


