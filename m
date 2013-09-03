Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab3ICDuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:50:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42081 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759327Ab3ICDt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:49:59 -0400
Message-ID: <52255C5E.3090903@oracle.com>
Date: Mon, 02 Sep 2013 20:49:50 -0700
From: Chuck Anderson <chuck.anderson@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Dan Duval <dan.duval@oracle.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] audit: fix soft lockups due to loop in audit_log_start()
 wh,en audit_backlog_limit exceeded
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit: fix softlockups due to loop in audit_log_start() when 
audit_backlog_limit exceeded

author: Dan Duval <dan.duval@oracle.com>

This patch fixes a bug in kernel/audit that can cause many soft lockups
and prevent the boot of a large memory 3.8 system:

   BUG: soft lockup - CPU#66 stuck for 22s! [udevd:9559]
   RIP: 0010:[<ffffffff810d1d06>]  [<ffffffff810d1d06>] 
audit_log_start+0xe6/0x350
   Call Trace:
    [<ffffffff8108ea30>] ? try_to_wake_up+0x2d0/0x2d0
    [<ffffffff810d8d6f>] audit_log_exit+0x3f/0x590
    [<ffffffff810d975d>] __audit_syscall_exit+0x28d/0x2c0
    [<ffffffff815e0440>] sysret_audit+0x17/0x21

audit_log_start() will call wait_for_auditd() to delay returning an
audit_buffer if there are too many SKBs on audit_skb_queue.
wait_for_auditd() puts itself on the audit_backlog_wait queue and
sleeps for sleep_time jiffies or until it is (normally) woken when
kauditd takes an SKB off of audit_skb_queue.  wait_for_auditd() returns
to audit_log_start() which checks to see if audit_skb_queue still has
too many SKBs.  If there are still too many, audit_log_start() will
continue to call wait_for_auditd() in a loop until
audit_backlog_wait_time has passed.  audit_log_start() will then
complain ("backlog limit exceeded"); set audit_backlog_wait_time
to NULL so other waiters will fall out of the loop when woken up; wake
up any waiters in wait_for_auditd(); return NULL which tells the caller
that an audit_buffer could not be allocated.

A bug in audit_log_start() prevents it from breaking out of the
wait_for_auditd() loop when audit_backlog_wait_time has passed.
Instead, it will loop in the audit_skb_queue-is-too-long while-loop
eventually causing a soft lockup.  There can (and most likely will)
be multiple threads looping.  The fix is to continue in the while-loop
only if sleep_time was greater than 0 (audit_backlog_wait_time has not
passed).

Another bug in audit_log_start() prevents audit_backlog_wait_time from
working as expected.  audit_backlog_wait_time is normally the time
period that audit_log_start() will wait for the number of SKBs on
audit_skb_queue to fall below the too-many threshold.  If
audit_backlog_wait_time passes, audit_log_start() will set it to
audit_backlog_wait_overflow, which is zero, and wake up any waiters in
wait_for_auditd().  audit_backlog_wait_time is now zero so the waiters
will fall out of the loop when they return to audit_log_start().  That
is expected behavior.  But audit_backlog_wait_time is not reset to its
initial value when audit_skb_queue's length is no longer too long.
Subsequent calls to audit_log_start() when audit_skb_queue is too long
will not wait in wait_for_auditd(), instead returning NULL.  The fix
is to set audit_backlog_wait_time to its initial value when
audit_skb_queue passes the size test, potentially resetting it.

A third issue is to have both audit_log_start() and wait_for_auditd()
use the same limit value for the length of audit_skb_queue.  It isn't
necessary today but (1) assumptions may change in the future and (2)
is one less oddity for a reader to have to verify.

Signed-off-by: Dan Duval <dan.duval@oracle.com>
Signed-off-by: Chuck Anderson <chuck.anderson@oracle.com>
---
  kernel/audit.c |   28 ++++++++++++++++------------
  1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..9a78dde 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -103,9 +103,11 @@ static int	audit_rate_limit;

  /* Number of outstanding audit_buffers allowed. */
  static int	audit_backlog_limit = 64;
-static int	audit_backlog_wait_time = 60 * HZ;
  static int	audit_backlog_wait_overflow = 0;

+#define AUDIT_BACKLOG_WAIT_TIME (60 * HZ)
+static int	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
+
  /* The identity of the user shutting down the audit system. */
  kuid_t		audit_sig_uid = INVALID_UID;
  pid_t		audit_sig_pid = -1;
@@ -1053,14 +1055,14 @@ static inline void audit_get_stamp(struct 
audit_context
*ctx,
  /*
   * Wait for auditd to drain the queue a little
   */
-static void wait_for_auditd(unsigned long sleep_time)
+static void wait_for_auditd(unsigned long sleep_time, int limit)
  {
  	DECLARE_WAITQUEUE(wait, current);
  	set_current_state(TASK_UNINTERRUPTIBLE);
  	add_wait_queue(&audit_backlog_wait, &wait);

  	if (audit_backlog_limit &&
-	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
+	    skb_queue_len(&audit_skb_queue) > limit)
  		schedule_timeout(sleep_time);

  	__set_current_state(TASK_RUNNING);
@@ -1095,8 +1097,8 @@ struct audit_buffer *audit_log_start(struct 
audit_context
*ctx, gfp_t gfp_mask,
  	struct audit_buffer	*ab	= NULL;
  	struct timespec		t;
  	unsigned int		uninitialized_var(serial);
-	int reserve;
  	unsigned long timeout_start = jiffies;
+	int limit;

  	if (audit_initialized != AUDIT_INITIALIZED)
  		return NULL;
@@ -1104,22 +1106,22 @@ struct audit_buffer *audit_log_start(struct 
audit_contex
t *ctx, gfp_t gfp_mask,
  	if (unlikely(audit_filter_type(type)))
  		return NULL;

-	if (gfp_mask & __GFP_WAIT)
-		reserve = 0;
-	else
-		reserve = 5; /* Allow atomic callers to go up to five
+	limit = audit_backlog_limit;
+	if (!(gfp_mask & __GFP_WAIT))
+		limit += 5;  /* Allow atomic callers to go up to five
  				entries over the normal backlog limit */

  	while (audit_backlog_limit
-	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserv
e) {
+	       && skb_queue_len(&audit_skb_queue) > limit) {
  		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time) {
  			unsigned long sleep_time;

  			sleep_time = timeout_start + audit_backlog_wait_time -
  					jiffies;
-			if ((long)sleep_time > 0)
-				wait_for_auditd(sleep_time);
-			continue;
+			if ((long)sleep_time > 0) {
+				wait_for_auditd(sleep_time, limit);
+				continue;
+			}
  		}
  		if (audit_rate_check() && printk_ratelimit())
  			printk(KERN_WARNING
@@ -1133,6 +1135,8 @@ struct audit_buffer *audit_log_start(struct 
audit_context
*ctx, gfp_t gfp_mask,
  		return NULL;
  	}

+	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
+
  	ab = audit_buffer_alloc(ctx, gfp_mask, type);
  	if (!ab) {
  		audit_log_lost("out of memory in audit_log_start");
-- 
1.7.1
