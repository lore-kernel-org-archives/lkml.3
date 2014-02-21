Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaBUUdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:33:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaBUUcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:32:20 -0500
Date: Fri, 21 Feb 2014 12:31:41 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-4df1638cfaf9b2b7ad993979a41965acab9cd156@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        juri.lelli@gmail.com
In-Reply-To: <20140219135335.7e74abd4@gandalf.local.home>
References: <20140219135335.7e74abd4@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/deadline: Fix overflow to handle period=
 =0 and deadline!=0
Git-Commit-ID: 4df1638cfaf9b2b7ad993979a41965acab9cd156
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4df1638cfaf9b2b7ad993979a41965acab9cd156
Gitweb:     http://git.kernel.org/tip/4df1638cfaf9b2b7ad993979a41965acab9cd156
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Wed, 19 Feb 2014 13:53:35 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:27:09 +0100

sched/deadline: Fix overflow to handle period==0 and deadline!=0

While debugging the crash with the bad nr_running accounting, I hit
another bug where, after running my sched deadline test, I was getting
failures to take a CPU offline. It was giving me a -EBUSY error.

Adding a bunch of trace_printk()s around, I found that the cpu
notifier that called sched_cpu_inactive() was returning a failure. The
overflow value was coming up negative?

Talking this over with Juri, the problem is that the total_bw update was
suppose to be made by dl_overflow() which, during my tests, seemed to
not be called. Adding more trace_printk()s, it wasn't that it wasn't
called, but it exited out right away with the check of new_bw being
equal to p->dl.dl_bw. The new_bw calculates the ratio between period and
runtime. The bug is that if you set a deadline, you do not need to set
a period if you plan on the period being equal to the deadline. That
is, if period is zero and deadline is not, then the system call should
set the period to be equal to the deadline. This is done elsewhere in
the code.

The fix is easy, check if period is set, and if it is not, then use the
deadline.

Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140219135335.7e74abd4@gandalf.local.home
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..2491448 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1952,7 +1952,7 @@ static int dl_overflow(struct task_struct *p, int policy,
 {
 
 	struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
-	u64 period = attr->sched_period;
+	u64 period = attr->sched_period ?: attr->sched_deadline;
 	u64 runtime = attr->sched_runtime;
 	u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
 	int cpus, err = -1;
