Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3D2SER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:04:17 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:46314 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756904Ab3D2SEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:04:16 -0400
Message-ID: <1367258649.8833.19.camel@Wailaba2>
Subject: [PATCH v3 1/3] posix_timers: do not account group_exec_runtime for
 dying autoreaped tasks
From: Olivier Langlois <olivier@olivierlanglois.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 29 Apr 2013 14:04:09 -0400
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:olivierlanglois.net} {sentby:smtp auth 173.178.230.31 authed with olivier@olivierlanglois.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Forbids the cputimer to drift ahead of its process clock by
blocking its update when a tick occurs while a autoreaping task
is currently in do_exit() between the call to release_task() and
its final call to schedule().

Any task stats update after having called release_task() will
be lost because they are added to the global process stats located
in the signal struct from release_task().

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 kernel/sched/fair.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..52d7b10 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -708,7 +708,15 @@ static void update_curr(struct cfs_rq *cfs_rq)
 
                trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
                cpuacct_charge(curtask, delta_exec);
-               account_group_exec_runtime(curtask, delta_exec);
+               /*
+                * Do not update the cputimer if the task is already released by
+                * release_task().
+                *
+                * it would preferable to defer the autoreap release_task
+                * after the last context switch but harder to do.
+                */
+               if (likely(curtask->sighand))
+                       account_group_exec_runtime(curtask, delta_exec);
        }
 
        account_cfs_rq_runtime(cfs_rq, delta_exec);
-- 
1.8.2.1


