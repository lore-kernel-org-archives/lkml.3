Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbbAEKiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:38:50 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbbAEKhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:37:38 -0500
Message-Id: <20150105103554.361872747@infradead.org>
User-Agent: quilt/0.61-1
Date: Mon, 05 Jan 2015 11:18:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: [RFC][PATCH 1/3] sched: Validate rq_clock*() serialization
References: <20150105101809.860964488@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-sched-rq_clock-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq->clock{,_task} are serialized by rq->lock, verify this.

One immediate fail is the usage in scale_rt_capability, so 'annotate'
that for now, there's more 'funny' there. Maybe change rq->lock into a
raw_seqlock_t?

(Only 32bit is affected)

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/fair.c  |    2 +-
 kernel/sched/sched.h |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5945,8 +5945,8 @@ static unsigned long scale_rt_capacity(i
 	 */
 	age_stamp = ACCESS_ONCE(rq->age_stamp);
 	avg = ACCESS_ONCE(rq->rt_avg);
+	delta = __rq_clock_broken(rq) - age_stamp;
 
-	delta = rq_clock(rq) - age_stamp;
 	if (unlikely(delta < 0))
 		delta = 0;
 
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -687,13 +687,20 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct rq
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
 


