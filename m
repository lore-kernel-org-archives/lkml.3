Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab3ICEqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 00:46:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab3ICEqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 00:46:08 -0400
Date: Tue, 3 Sep 2013 00:46:03 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Chuck Anderson <chuck.anderson@oracle.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, Dan Duval <dan.duval@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] audit: fix soft lockups and udevd errors when audit
 is overrun
Message-ID: <20130903004603.18e4e8c1@redhat.com>
In-Reply-To: <52255B4A.6070804@oracle.com>
References: <52255B4A.6070804@oracle.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/myQLKF=3lD16TMk.14L4NW3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/myQLKF=3lD16TMk.14L4NW3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 02 Sep 2013 20:45:14 -0700
Chuck Anderson <chuck.anderson@oracle.com> wrote:

> The two patches that follow in separate emails resolve soft lockups and
> udevd reported errors that prevented a large memory 3.8 system from booting.
> 
> The patches are based on 3.11-rc7.
> 
> I believe it is the same issue recently posted as:
> 
>    [RFC] audit: avoid soft lockup in audit_log_start()
>    https://lkml.org/lkml/2013/8/28/626

Nice to see someone else looking into this! And Thanks for CC'ing me.

I've a couple of news to you.

First, I've tried to apply your series but got this:

[lcapitulino@volcano linux-2.6]$ git am ~/audit-fix.mbox
Applying: audit: fix soft lockups due to loop in audit_log_start() wh,en audit_backlog_limit exceeded
fatal: corrupt patch at line 23
Patch failed at 0001 audit: fix soft lockups due to loop in audit_log_start() wh,en audit_backlog_limit exceeded
The copy of the patch that failed is found in:
   /home/lcapitulino/work/src/upstream/linux-2.6/.git/rebase-apply/patch
When you have resolved this problem, run "git am --resolved".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
[lcapitulino@volcano linux-2.6]$

Now, I was a few minutes a away before sending a different fix I cooked
this evening when I got your series in my inbox. So I really wanted to give
this a try and applied the first patch manually (resulting version is
attached). The softlockup is gone, but I still get a hang for several
seconds just like I did with my first rfc.

I found a very easy way to reproduce the problem and our analysis is
similar, but our solutions differs.

I'm going to send my solution right now, sorry for any mistakes it's
almost 1h AM here but I really wanted to give your version a try before
sending my version (and before going to bed). If you send a v2 I'll try
it again and we can discuss our approaches.

--MP_/myQLKF=3lD16TMk.14L4NW3
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=chuck.patch

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..8255d9b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -103,9 +103,11 @@ static int	audit_rate_limit;
 
 /* Number of outstanding audit_buffers allowed. */
 static int	audit_backlog_limit = 64;
-static int	audit_backlog_wait_time = 60 * HZ;
 static int	audit_backlog_wait_overflow = 0;
 
+#define AUDIT_BACKLOG_WAIT_TIME (60 * HZ)
+static int audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
+
 /* The identity of the user shutting down the audit system. */
 kuid_t		audit_sig_uid = INVALID_UID;
 pid_t		audit_sig_pid = -1;
@@ -1053,14 +1055,14 @@ static inline void audit_get_stamp(struct audit_context *ctx,
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
@@ -1095,8 +1097,8 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	struct audit_buffer	*ab	= NULL;
 	struct timespec		t;
 	unsigned int		uninitialized_var(serial);
-	int reserve;
 	unsigned long timeout_start = jiffies;
+	int limit;
 
 	if (audit_initialized != AUDIT_INITIALIZED)
 		return NULL;
@@ -1104,22 +1106,21 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	if (unlikely(audit_filter_type(type)))
 		return NULL;
 
-	if (gfp_mask & __GFP_WAIT)
-		reserve = 0;
-	else
-		reserve = 5; /* Allow atomic callers to go up to five
-				entries over the normal backlog limit */
+	limit = audit_backlog_limit;
+	 if (!(gfp_mask & __GFP_WAIT))
+	 	limit += 5;
 
 	while (audit_backlog_limit
-	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
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
@@ -1133,6 +1134,8 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 		return NULL;
 	}
 
+	audit_backlog_wait_time = AUDIT_BACKLOG_WAIT_TIME;
+
 	ab = audit_buffer_alloc(ctx, gfp_mask, type);
 	if (!ab) {
 		audit_log_lost("out of memory in audit_log_start");

--MP_/myQLKF=3lD16TMk.14L4NW3--
