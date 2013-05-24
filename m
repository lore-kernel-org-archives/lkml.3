Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3EXRpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:45:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab3EXRpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:45:23 -0400
Date: Fri, 24 May 2013 19:41:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Guy Streeter <streeter@redhat.com>, Eric Paris <eparis@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: wait_for_auditd() should use
	TASK_UNINTERRUPTIBLE
Message-ID: <20130524174127.GA17186@redhat.com>
References: <20130524173925.GA17177@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524173925.GA17177@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24, Oleg Nesterov wrote:
>
> audit_log_start() does wait_for_auditd() in a loop until
> audit_backlog_wait_time passes or audit_skb_queue has a room.
>
> If signal_pending() is true this becomes a busy-wait loop,
> schedule() in TASK_INTERRUPTIBLE won't block.

And the code looks strange imho. I think it should be cleanuped,
something like below. But I do not know how can I test this change.

Oleg.

--- x/kernel/audit.c
+++ x/kernel/audit.c
@@ -1053,18 +1053,19 @@ static inline void audit_get_stamp(struc
 /*
  * Wait for auditd to drain the queue a little
  */
-static void wait_for_auditd(unsigned long sleep_time)
+static bool wait_for_auditd(gfp_t gfp_mask)
 {
-	DECLARE_WAITQUEUE(wait, current);
-	set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue(&audit_backlog_wait, &wait);
-
-	if (audit_backlog_limit &&
-	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
-		schedule_timeout(sleep_time);
+	bool can_wait = gfp_mask & __GFP_WAIT;
+	int reserve = can_wait ? 0 : 5;
 
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&audit_backlog_wait, &wait);
+	if (!audit_backlog_limit ||
+	    skb_queue_len(&audit_skb_queue) <= audit_backlog_limit + reserve)
+		return true;
+
+	return can_wait && wait_event_timeout(audit_backlog_wait,
+				!audit_backlog_limit ||
+					skb_queue_len(&audit_skb_queue) <= audit_backlog_limit,
+				audit_backlog_wait_time);
 }
 
 /* Obtain an audit buffer.  This routine does locking to obtain the
@@ -1095,8 +1096,6 @@ struct audit_buffer *audit_log_start(str
 	struct audit_buffer	*ab	= NULL;
 	struct timespec		t;
 	unsigned int		uninitialized_var(serial);
-	int reserve;
-	unsigned long timeout_start = jiffies;
 
 	if (audit_initialized != AUDIT_INITIALIZED)
 		return NULL;
@@ -1104,23 +1103,7 @@ struct audit_buffer *audit_log_start(str
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
+	if (!wait_for_auditd(gfp_mask)) {
 		if (audit_rate_check() && printk_ratelimit())
 			printk(KERN_WARNING
 			       "audit: audit_backlog=%d > "

