Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3JSQZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:25:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab3JSQZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:25:20 -0400
Date: Sat, 19 Oct 2013 18:18:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Sullivan <dsulliva@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] hung_task debugging: Add tracepoint to report the hang
Message-ID: <20131019161807.GA7431@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have a feature request, the customer needs something more hookable
than just printk's from check_hung_task() to implement the user-space
watchdog which can potentially resolve the problems which caused the
hang.

The patch simply adds a tracepoint into check_hung_task(), do you
think we can (ab)use tp this way?


And I am just curious, perhaps another patch (below) makes sense too?

Oleg.

------------------------------------------------------------------------------
[PATCH] hung_task debugging: Do not report the same task twice

If a task hangs, check_hung_task() will blame it again and again
until it wakes up or sysctl_hung_task_warnings becomes zero. IMO,
this just adds the unnecessary noise and if another task hangs
after sysctl_hung_task_timeout_secs * sysctl_hung_task_warnings
it won't be reported.

With this patch check_hung_task() simply sets the most significant
bit in ->last_switch_count to mark this task as "already reported".
This bit is cleared if we notice the change in nvcsw/nivcsw, so we
do not skip this task if it hangs again later.

Note that we also ignore the MSB in switch_count, we need this to
avoid the false-positive "already reported". This means that
->last_switch_count is not necessarily equal to ->nvcsw + ->nivcsw
but we do not care, we have enough bits to notice the change.

And this allows to remove the special switch_count == 0 case, just
we need to initialize ->last_switch_count = LONG_MIN.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c      |    2 +-
 kernel/hung_task.c |   19 +++++++++----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8531609..aea397b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -866,7 +866,7 @@ static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 	tsk->min_flt = tsk->maj_flt = 0;
 	tsk->nvcsw = tsk->nivcsw = 0;
 #ifdef CONFIG_DETECT_HUNG_TASK
-	tsk->last_switch_count = tsk->nvcsw + tsk->nivcsw;
+	tsk->last_switch_count = LONG_MIN; /* see check_hung_task() */
 #endif
 
 	tsk->mm = NULL;
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 3952ab1..0f6233c 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -72,7 +72,7 @@ static struct notifier_block panic_block = {
 
 static void check_hung_task(struct task_struct *t, unsigned long timeout)
 {
-	unsigned long switch_count = t->nvcsw + t->nivcsw;
+	unsigned long switch_count;
 
 	/*
 	 * Ensure the task is not frozen.
@@ -81,19 +81,18 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 	if (unlikely(t->flags & (PF_FROZEN | PF_FREEZER_SKIP)))
 	    return;
 
-	/*
-	 * When a freshly created task is scheduled once, changes its state to
-	 * TASK_UNINTERRUPTIBLE without having ever been switched out once, it
-	 * musn't be checked.
-	 */
-	if (unlikely(!switch_count))
-		return;
-
-	if (switch_count != t->last_switch_count) {
+	/* Ignore MSB, see below. LONG_MAX = ~LONG_MIN. */
+	switch_count = (t->nvcsw + t->nivcsw) & LONG_MAX;
+	if (switch_count != (LONG_MAX & t->last_switch_count)) {
 		t->last_switch_count = switch_count;
 		return;
 	}
 
+	/* We use MSB to mark this task as already reported. */
+	if (t->last_switch_count & LONG_MIN)
+		return;
+	t->last_switch_count |= LONG_MIN;
+
 	trace_sched_process_hang(t);
 
 	if (!sysctl_hung_task_warnings)
-- 
1.5.5.1


