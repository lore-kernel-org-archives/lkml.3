Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbbAILA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:00:26 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44484 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756861AbbAIKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 12/78] s390/3215: fix hanging console issue
Date: Fri,  9 Jan 2015 11:31:21 +0100
Message-Id: <22c60914c060fc8c62f52526411b73ea29eef46f.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 26d766c60f4ea08cd14f0f3435a6db3d6cc2ae96 upstream.

The ccw_device_start in raw3215_start_io can fail. raw3215_try_io
does not check if the request could be started and removes any
pending timer. This can leave the system in a hanging state.
Check for pending request after raw3215_start_io and start a
timer if necessary.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/s390/char/con3215.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index bb86494e2b7b..9a408f6e95db 100644
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
2.2.1

