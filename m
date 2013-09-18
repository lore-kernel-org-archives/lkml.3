Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3IRTIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab3IRTID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:08:03 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Guy Streeter <streeter@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 3/8] audit: make use of remaining sleep time from wait_for_auditd
Date: Wed, 18 Sep 2013 15:06:48 -0400
Message-Id: <7bc5797ceea17efeaa7fe5a161519260d112af87.1379530867.git.rgb@redhat.com>
In-Reply-To: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
In-Reply-To: <cover.1379530867.git.rgb@redhat.com>
References: <cover.1379530867.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If wait_for_auditd() times out, go immediately to the error function rather
than retesting the loop conditions.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 772725e..42c68db 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1054,18 +1054,21 @@ static inline void audit_get_stamp(struct audit_context *ctx,
 /*
  * Wait for auditd to drain the queue a little
  */
-static void wait_for_auditd(unsigned long sleep_time)
+static unsigned long wait_for_auditd(unsigned long sleep_time)
 {
+	unsigned long timeout = sleep_time;
 	DECLARE_WAITQUEUE(wait, current);
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&audit_backlog_wait, &wait);
 
 	if (audit_backlog_limit &&
 	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
-		schedule_timeout(sleep_time);
+		timeout = schedule_timeout(sleep_time);
 
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&audit_backlog_wait, &wait);
+
+	return timeout;
 }
 
 /* Obtain an audit buffer.  This routine does locking to obtain the
@@ -1119,8 +1122,9 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 			sleep_time = timeout_start + audit_backlog_wait_time -
 					jiffies;
 			if ((long)sleep_time > 0) {
-				wait_for_auditd(sleep_time);
-				continue;
+				sleep_time = wait_for_auditd(sleep_time);
+				if ((long)sleep_time > 0)
+					continue;
 			}
 		}
 		if (audit_rate_check() && printk_ratelimit())
-- 
1.7.1

