Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab3KMOfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:35:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759381Ab3KMOfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:35:17 -0500
Date: Wed, 13 Nov 2013 15:36:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] proc: cleanup/simplify get_task_state/task_state_array
Message-ID: <20131113143609.GA10537@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113143552.GA10517@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_task_state() and task_state_array[] look confusing and
suboptimal, it is not clear what it can actually report to
user-space and task_state_array[] blows .data for no reason.

1. state = (tsk->state & TASK_REPORT) | tsk->exit_state is not
   clear. TASK_REPORT is self-documenting but it is not clear
   what ->exit_state can add.

   Move the potential exit_state's (EXIT_ZOMBIE and EXIT_DEAD)
   into TASK_REPORT and use it to calculate the final result.

2. With the change above it is obvious that task_state_array[]
   has the unused entries just to make BUILD_BUG_ON() happy.

   Change this BUILD_BUG_ON() to use TASK_REPORT rather than
   TASK_STATE_MAX and shrink task_state_array[].

3. Turn the "while (state)" loop into fls(state).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/array.c       |   15 +++------------
 include/linux/sched.h |    2 +-
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index cbd0f1b..c995807 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -140,24 +140,15 @@ static const char * const task_state_array[] = {
 	"t (tracing stop)",	/*   8 */
 	"Z (zombie)",		/*  16 */
 	"X (dead)",		/*  32 */
-	"x (dead)",		/*  64 */
-	"K (wakekill)",		/* 128 */
-	"W (waking)",		/* 256 */
-	"P (parked)",		/* 512 */
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)
 {
-	unsigned int state = (tsk->state & TASK_REPORT) | tsk->exit_state;
-	const char * const *p = &task_state_array[0];
+	unsigned int state = (tsk->state | tsk->exit_state) & TASK_REPORT;
 
-	BUILD_BUG_ON(1 + ilog2(TASK_STATE_MAX) != ARRAY_SIZE(task_state_array));
+	BUILD_BUG_ON(1 + ilog2(TASK_REPORT) != ARRAY_SIZE(task_state_array)-1);
 
-	while (state) {
-		p++;
-		state >>= 1;
-	}
-	return *p;
+	return task_state_array[fls(state)];
 }
 
 static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e27baee..ee2c2e6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -163,7 +163,7 @@ extern char ___assert_task_state[1 - 2*!!(
 /* get_task_state() */
 #define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
 				 TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
-				 __TASK_TRACED)
+				 __TASK_TRACED | EXIT_ZOMBIE | EXIT_DEAD)
 
 #define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
 #define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
-- 
1.5.5.1

