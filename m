Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab3KMR06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:26:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52933 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab3KMR0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:26:23 -0500
Date: Wed, 13 Nov 2013 09:25:41 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-911b2898b3c9fe0048e9485ad1629ed4fce330fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, peterz@infradead.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, pjt@google.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com
In-Reply-To: <20131111172925.GG26898@twins.programming.kicks-ass.net>
References: <20131111172925.GG26898@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Optimize task_sched_runtime()
Git-Commit-ID: 911b2898b3c9fe0048e9485ad1629ed4fce330fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 09:25:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  911b2898b3c9fe0048e9485ad1629ed4fce330fd
Gitweb:     http://git.kernel.org/tip/911b2898b3c9fe0048e9485ad1629ed4fce330fd
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 11 Nov 2013 18:21:56 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Nov 2013 13:33:54 +0100

sched: Optimize task_sched_runtime()

Large multi-threaded apps like to hit this using do_sys_times() and
then queue up on the rq->lock.

Avoid when possible.

Larry reported ~20% performance increase his test case.

Reported-by: Larry Woodman <lwoodman@redhat.com>
Suggested-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131111172925.GG26898@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1deccd7..c180860 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2253,6 +2253,20 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	struct rq *rq;
 	u64 ns = 0;
 
+#if defined(CONFIG_64BIT) && defined(CONFIG_SMP)
+	/*
+	 * 64-bit doesn't need locks to atomically read a 64bit value.
+	 * So we have a optimization chance when the task's delta_exec is 0.
+	 * Reading ->on_cpu is racy, but this is ok.
+	 *
+	 * If we race with it leaving cpu, we'll take a lock. So we're correct.
+	 * If we race with it entering cpu, unaccounted time is 0. This is
+	 * indistinguishable from the read occurring a few cycles earlier.
+	 */
+	if (!p->on_cpu)
+		return p->se.sum_exec_runtime;
+#endif
+
 	rq = task_rq_lock(p, &flags);
 	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, p, &flags);
