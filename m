Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab3JQQuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:50:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab3JQQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:50:16 -0400
Date: Thu, 17 Oct 2013 09:49:20 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-7c3f2ab7b844f1a859afbc3d41925e8a0faba5fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <20131015103507.GF10651@twins.programming.kicks-ass.net>
References: <20131015103507.GF10651@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Add missing rmb()
Git-Commit-ID: 7c3f2ab7b844f1a859afbc3d41925e8a0faba5fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 09:49:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c3f2ab7b844f1a859afbc3d41925e8a0faba5fa
Gitweb:     http://git.kernel.org/tip/7c3f2ab7b844f1a859afbc3d41925e8a0faba5fa
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 15 Oct 2013 12:35:07 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Oct 2013 14:22:13 +0200

sched/rt: Add missing rmb()

While discussing the proposed SCHED_DEADLINE patches which in parts
mimic the existing FIFO code it was noticed that the wmb in
rt_set_overloaded() didn't have a matching barrier.

The only site using rt_overloaded() to test the rto_count is
pull_rt_task() and we should issue a matching rmb before then assuming
there's an rto_mask bit set.

Without that smp_rmb() in there we could actually miss seeing the
rto_mask bit.

Also, change to using smp_[wr]mb(), even though this is SMP only code;
memory barriers without smp_ always make me think they're against
hardware of some sort.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: vincent.guittot@linaro.org
Cc: luca.abeni@unitn.it
Cc: bruce.ashfield@windriver.com
Cc: dhaval.giani@gmail.com
Cc: rostedt@goodmis.org
Cc: hgu1972@gmail.com
Cc: oleg@redhat.com
Cc: fweisbec@gmail.com
Cc: darren@dvhart.com
Cc: johan.eker@ericsson.com
Cc: p.faure@akatech.ch
Cc: paulmck@linux.vnet.ibm.com
Cc: raistlin@linux.it
Cc: claudio@evidence.eu.com
Cc: insop.song@gmail.com
Cc: michael@amarulasolutions.com
Cc: liming.wang@windriver.com
Cc: fchecconi@gmail.com
Cc: jkacur@redhat.com
Cc: tommaso.cucinotta@sssup.it
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: harald.gustafsson@ericsson.com
Cc: nicola.manica@disi.unitn.it
Cc: tglx@linutronix.de
Link: http://lkml.kernel.org/r/20131015103507.GF10651@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e9304cd..a848f52 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -246,8 +246,10 @@ static inline void rt_set_overload(struct rq *rq)
 	 * if we should look at the mask. It would be a shame
 	 * if we looked at the mask, but the mask was not
 	 * updated yet.
+	 *
+	 * Matched by the barrier in pull_rt_task().
 	 */
-	wmb();
+	smp_wmb();
 	atomic_inc(&rq->rd->rto_count);
 }
 
@@ -1626,6 +1628,12 @@ static int pull_rt_task(struct rq *this_rq)
 	if (likely(!rt_overloaded(this_rq)))
 		return 0;
 
+	/*
+	 * Match the barrier from rt_set_overloaded; this guarantees that if we
+	 * see overloaded we must also see the rto_mask bit.
+	 */
+	smp_rmb();
+
 	for_each_cpu(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
