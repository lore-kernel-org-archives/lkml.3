Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab3KWPjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:39:22 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57575 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3KWPhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:37:31 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 05/10] posix-timers: Remove useless clock sample on timers cleanup
Date: Sat, 23 Nov 2013 16:37:15 +0100
Message-Id: <1385221040-24731-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a0b2062b0904ef07944c4a6e4d0f88ee44f1e9f2
("posix_timers: fix racy timer delta caching on task exit") forgot
to remove the arguments used for timer caching.

Fix this leftover.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index a815ddb..bf49832 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -399,8 +399,7 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 	return ret;
 }
 
-static void cleanup_timers_list(struct list_head *head,
-				unsigned long long curr)
+static void cleanup_timers_list(struct list_head *head)
 {
 	struct cpu_timer_list *timer, *next;
 
@@ -414,16 +413,11 @@ static void cleanup_timers_list(struct list_head *head,
  * time for later timer_gettime calls to return.
  * This must be called with the siglock held.
  */
-static void cleanup_timers(struct list_head *head,
-			   cputime_t utime, cputime_t stime,
-			   unsigned long long sum_exec_runtime)
+static void cleanup_timers(struct list_head *head)
 {
-
-	cputime_t ptime = utime + stime;
-
-	cleanup_timers_list(head, cputime_to_expires(ptime));
-	cleanup_timers_list(++head, cputime_to_expires(utime));
-	cleanup_timers_list(++head, sum_exec_runtime);
+	cleanup_timers_list(head);
+	cleanup_timers_list(++head);
+	cleanup_timers_list(++head);
 }
 
 /*
@@ -433,24 +427,14 @@ static void cleanup_timers(struct list_head *head,
  */
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
-	cputime_t utime, stime;
-
 	add_device_randomness((const void*) &tsk->se.sum_exec_runtime,
 						sizeof(unsigned long long));
-	task_cputime(tsk, &utime, &stime);
-	cleanup_timers(tsk->cpu_timers,
-		       utime, stime, tsk->se.sum_exec_runtime);
+	cleanup_timers(tsk->cpu_timers);
 
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
-	struct signal_struct *const sig = tsk->signal;
-	cputime_t utime, stime;
-
-	task_cputime(tsk, &utime, &stime);
-	cleanup_timers(tsk->signal->cpu_timers,
-		       utime + sig->utime, stime + sig->stime,
-		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
+	cleanup_timers(tsk->signal->cpu_timers);
 }
 
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
-- 
1.8.3.1

