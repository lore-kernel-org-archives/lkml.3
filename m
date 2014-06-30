Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbaF3L6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:58:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52085 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 013/181] sched: Make scale_rt_power() deal with backward clocks
Date: Mon, 30 Jun 2014 13:50:34 +0200
Message-Id: <5ff029e2b396ac09fc52addd73bb0f4003c70ef2.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cadefd3d6cc914d95163ba1eda766bfe7ce1e5b7 upstream.

Mike reported that, while unlikely, its entirely possible for
scale_rt_power() to see the time go backwards. This yields rather
'interesting' results.

So like all other sites that deal with clocks; make this one ignore
backward clock movement too.

Reported-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140227094035.GZ9987@twins.programming.kicks-ass.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/sched/fair.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 25658d2c68d0..898622244bdf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4404,6 +4404,7 @@ static unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available, age_stamp, avg;
+	s64 delta;
 
 	/*
 	 * Since we're reading these variables without serialization make sure
@@ -4412,7 +4413,11 @@ static unsigned long scale_rt_power(int cpu)
 	age_stamp = ACCESS_ONCE(rq->age_stamp);
 	avg = ACCESS_ONCE(rq->rt_avg);
 
-	total = sched_avg_period() + (rq_clock(rq) - age_stamp);
+	delta = rq_clock(rq) - age_stamp;
+	if (unlikely(delta < 0))
+		delta = 0;
+
+	total = sched_avg_period() + delta;
 
 	if (unlikely(total < avg)) {
 		/* Ensures that power won't end up being negative */
-- 
2.0.0

