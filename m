Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaEHKmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:42:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbaEHKmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:42:53 -0400
Date: Thu, 8 May 2014 03:42:02 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6ccdc84b81a0a6c09a7f0427761d2f8cecfc2218@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, tglx@linutronix.de, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, tglx@linutronix.de, len.brown@intel.com
In-Reply-To: <20140424100047.GP11096@twins.programming.kicks-ass.net>
References: <20140424100047.GP11096@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Skip double execution of pick_next_task_fair()
Git-Commit-ID: 6ccdc84b81a0a6c09a7f0427761d2f8cecfc2218
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

Commit-ID:  6ccdc84b81a0a6c09a7f0427761d2f8cecfc2218
Gitweb:     http://git.kernel.org/tip/6ccdc84b81a0a6c09a7f0427761d2f8cecfc2218
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 24 Apr 2014 12:00:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:51:35 +0200

sched: Skip double execution of pick_next_task_fair()

Tim wrote:

 "The current code will call pick_next_task_fair a second time in the
  slow path if we did not pull any task in our first try.  This is
  really unnecessary as we already know no task can be pulled and it
  doubles the delay for the cpu to enter idle.

  We instrumented some network workloads and that saw that
  pick_next_task_fair is frequently called twice before a cpu enters
  idle.  The call to pick_next_task_fair can add non trivial latency as
  it calls load_balance which runs find_busiest_group on an hierarchy of
  sched domains spanning the cpus for a large system.  For some 4 socket
  systems, we saw almost 0.25 msec spent per call of pick_next_task_fair
  before a cpu can be idled."

Optimize the second call away for the common case and document the
dependency.

Reported-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <len.brown@intel.com>
Link: http://lkml.kernel.org/r/20140424100047.GP11096@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e62c65a..28921ec 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2592,8 +2592,14 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 	if (likely(prev->sched_class == class &&
 		   rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq, prev);
-		if (likely(p && p != RETRY_TASK))
-			return p;
+		if (unlikely(p == RETRY_TASK))
+			goto again;
+
+		/* assumes fair_sched_class->next == idle_sched_class */
+		if (unlikely(!p))
+			p = idle_sched_class.pick_next_task(rq, prev);
+
+		return p;
 	}
 
 again:
