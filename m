Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaDRNHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:07:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38753 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaDRNHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:07:09 -0400
Date: Fri, 18 Apr 2014 06:06:08 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-cadefd3d6cc914d95163ba1eda766bfe7ce1e5b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bitbucket@online.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bitbucket@online.de, tglx@linutronix.de
In-Reply-To: <20140227094035.GZ9987@twins.programming.kicks-ass.net>
References: <20140227094035.GZ9987@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Make scale_rt_power()
  deal with backward clocks
Git-Commit-ID: cadefd3d6cc914d95163ba1eda766bfe7ce1e5b7
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

Commit-ID:  cadefd3d6cc914d95163ba1eda766bfe7ce1e5b7
Gitweb:     http://git.kernel.org/tip/cadefd3d6cc914d95163ba1eda766bfe7ce1e5b7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 27 Feb 2014 10:40:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:07:21 +0200

sched: Make scale_rt_power() deal with backward clocks

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
---
 kernel/sched/fair.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..5e157f1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5564,6 +5564,7 @@ static unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available, age_stamp, avg;
+	s64 delta;
 
 	/*
 	 * Since we're reading these variables without serialization make sure
@@ -5572,7 +5573,11 @@ static unsigned long scale_rt_power(int cpu)
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
