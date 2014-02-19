Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaBSC5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:57:08 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:7506 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751796AbaBSC5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:57:02 -0500
Date: Tue, 18 Feb 2014 21:56:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] sched/deadline: Update total bandwidth when adding new task
Message-ID: <20140218215659.2a3ddd8f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging the crash with the bad nr_running accounting, I hit
another bug where, after running my sched deadline test, I was getting
failures to take a CPU offline. It was giving me a -EBUSY error.

Adding a bunch of trace_printk()s around, I found that the cpu
notifier that called sched_cpu_inactive() was returning a failure. The
overflow value was coming up negative?

Adding more trace_printk()s, I found that task_dead_dl() function was
subtracting the exact amount that was keeping the CPU from going
offline. I then realized that the task_dead_dl() was updating the
total_bw for the task that was going away, but there was nothing that
added to the total_bw when the task came alive. If total_bw is not
zero for a CPU, it will keep that CPU from going offline.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..17f4830 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3178,6 +3178,7 @@ static void
 __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+	struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
 
 	init_dl_task_timer(dl_se);
 	dl_se->dl_runtime = attr->sched_runtime;
@@ -3187,6 +3188,7 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
 	dl_se->dl_throttled = 0;
 	dl_se->dl_new = 1;
+	__dl_add(dl_b, dl_se->dl_bw);
 }
 
 /* Actually do priority change: must hold pi & rq lock. */
