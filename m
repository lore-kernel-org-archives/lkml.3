Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab3FCUun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223Ab3FCUul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:50:41 -0400
Date: Mon, 3 Jun 2013 22:46:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Guy Streeter <streeter@redhat.com>, Eric Paris <eparis@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/1] audit: cleanup audit_log_start/wait_for_auditd mess
Message-ID: <20130603204620.GB21574@redhat.com>
References: <20130603204559.GA21574@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603204559.GA21574@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_log_start() tries to obfusticate the code/logic and
reimplements wait_event_timeout() in a very confusing way.

Just change wait_for_auditd() to use wait_event_timeout()
and return bool.

Also remove the unnecessary "ab = NULL" initialization.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/audit.c |   45 +++++++++++++--------------------------------
 1 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..af0a04d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1051,20 +1051,19 @@ static inline void audit_get_stamp(struct audit_context *ctx,
 }
 
 /*
- * Wait for auditd to drain the queue a little
+ * Wait for auditd to drain audit_skb_queue if it is full
  */
-static void wait_for_auditd(unsigned long sleep_time)
+static bool wait_for_auditd(gfp_t gfp_mask)
 {
-	DECLARE_WAITQUEUE(wait, current);
-	set_current_state(TASK_UNINTERRUPTIBLE);
-	add_wait_queue(&audit_backlog_wait, &wait);
-
-	if (audit_backlog_limit &&
-	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
-		schedule_timeout(sleep_time);
-
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&audit_backlog_wait, &wait);
+	/* Atomic callers use can 5 more entries over the limit */
+	if (!(gfp_mask & __GFP_WAIT))
+		return skb_queue_len(&audit_skb_queue) <=
+					audit_backlog_limit + 5;
+
+	return wait_event_timeout(audit_backlog_wait,
+		!audit_backlog_limit ||
+			skb_queue_len(&audit_skb_queue) <= audit_backlog_limit,
+		audit_backlog_wait_time);
 }
 
 /* Obtain an audit buffer.  This routine does locking to obtain the
@@ -1092,11 +1091,9 @@ static void wait_for_auditd(unsigned long sleep_time)
 struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 				     int type)
 {
-	struct audit_buffer	*ab	= NULL;
+	struct audit_buffer	*ab;
 	struct timespec		t;
 	unsigned int		uninitialized_var(serial);
-	int reserve;
-	unsigned long timeout_start = jiffies;
 
 	if (audit_initialized != AUDIT_INITIALIZED)
 		return NULL;
@@ -1104,23 +1101,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	if (unlikely(audit_filter_type(type)))
 		return NULL;
 
-	if (gfp_mask & __GFP_WAIT)
-		reserve = 0;
-	else
-		reserve = 5; /* Allow atomic callers to go up to five
-				entries over the normal backlog limit */
-
-	while (audit_backlog_limit
-	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
-		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time) {
-			unsigned long sleep_time;
-
-			sleep_time = timeout_start + audit_backlog_wait_time -
-					jiffies;
-			if ((long)sleep_time > 0)
-				wait_for_auditd(sleep_time);
-			continue;
-		}
+	if (audit_backlog_limit && !wait_for_auditd(gfp_mask)) {
 		if (audit_rate_check() && printk_ratelimit())
 			printk(KERN_WARNING
 			       "audit: audit_backlog=%d > "
-- 
1.5.5.1


