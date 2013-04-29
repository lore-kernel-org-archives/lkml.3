Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563Ab3D2TRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:17:50 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:57119 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760548Ab3D2TRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:17:46 -0400
Message-ID: <517EC757.20801@gmail.com>
Date: Mon, 29 Apr 2013 15:17:43 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        kosaki.motohiro@gmail.com
Subject: [BUGFIX PATCH 3/2] posix-cpu-timers: check_thread_timers() uses task_sched_runtime()
References: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index dc61bc3..651b6c7 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -944,7 +944,8 @@ static void check_thread_timers(struct task_struct *tsk,
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


