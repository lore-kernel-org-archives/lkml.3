Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab3D3DSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 23:18:43 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:39741 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab3D3DSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 23:18:40 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 08/10] posix-cpu-timers: check_thread_timers() uses task_sched_runtime()
Date: Mon, 29 Apr 2013 23:17:16 -0400
Message-Id: <1367291838-5490-9-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

A type of tsk->se.sum_exec_runtime is u64. Thus reading it is racy when
running 32bit. We should use task_sched_runtime().

Cc: Olivier Langlois <olivier@trillion01.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/posix-cpu-timers.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c69b8d8..4043282 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -958,7 +958,8 @@ static void check_thread_timers(struct task_struct *tsk,
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires.sched) {
+		unsigned long long runtime = task_sched_runtime(tsk, false);
+		if (!--maxfire || runtime < t->expires.sched) {
 			tsk->cputime_expires.sched_exp = t->expires.sched;
 			break;
 		}
-- 
1.7.1

