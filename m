Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbbANODl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:03:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbbANODg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:03:36 -0500
Date: Wed, 14 Jan 2015 06:03:07 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-cebde6d681aa45f96111cfcffc1544cf2a0454ff@git.kernel.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        hpa@zytor.com
Reply-To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, hpa@zytor.com,
        mingo@kernel.org
In-Reply-To: <20150105103554.361872747@infradead.org>
References: <20150105103554.361872747@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/core: Validate rq_clock*() serialization
Git-Commit-ID: cebde6d681aa45f96111cfcffc1544cf2a0454ff
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

Commit-ID:  cebde6d681aa45f96111cfcffc1544cf2a0454ff
Gitweb:     http://git.kernel.org/tip/cebde6d681aa45f96111cfcffc1544cf2a0454ff
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 5 Jan 2015 11:18:10 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 13:34:19 +0100

sched/core: Validate rq_clock*() serialization

rq->clock{,_task} are serialized by rq->lock, verify this.

One immediate fail is the usage in scale_rt_capability, so 'annotate'
that for now, there's more 'funny' there. Maybe change rq->lock into a
raw_seqlock_t?

(Only 32-bit is affected)

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20150105103554.361872747@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: umgwanakikbuti@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c  | 2 +-
 kernel/sched/sched.h | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2a0b302..50ff902 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5948,8 +5948,8 @@ static unsigned long scale_rt_capacity(int cpu)
 	 */
 	age_stamp = ACCESS_ONCE(rq->age_stamp);
 	avg = ACCESS_ONCE(rq->rt_avg);
+	delta = __rq_clock_broken(rq) - age_stamp;
 
-	delta = rq_clock(rq) - age_stamp;
 	if (unlikely(delta < 0))
 		delta = 0;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9a2a45c..bd23732 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -687,13 +687,20 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		raw_cpu_ptr(&runqueues)
 
+static inline u64 __rq_clock_broken(struct rq *rq)
+{
+	return ACCESS_ONCE(rq->clock);
+}
+
 static inline u64 rq_clock(struct rq *rq)
 {
+	lockdep_assert_held(&rq->lock);
 	return rq->clock;
 }
 
 static inline u64 rq_clock_task(struct rq *rq)
 {
+	lockdep_assert_held(&rq->lock);
 	return rq->clock_task;
 }
 
