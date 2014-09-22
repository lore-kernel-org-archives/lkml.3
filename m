Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaIVQYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:24:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60390 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaIVQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:24:10 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        mturquette@linaro.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [PATCH 6/7] sched: Make sched entity usage tracking scale-invariant
Date: Mon, 22 Sep 2014 17:24:06 +0100
Message-Id: <1411403047-32010-7-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 22 Sep 2014 16:24:07.0893 (UTC) FILETIME=[A24A3050:01CFD681]
X-MC-Unique: 114092217240806701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8MGOR2T029518

Apply scale-invariance correction factor to usage tracking as well.

cc: Paul Turner <pjt@google.com>
cc: Ben Segall <bsegall@google.com>

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d8a8c83..c7aa8c1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2302,9 +2302,9 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 							int runnable,
 							int running)
 {
-	u64 delta, periods;
-	u32 runnable_contrib;
-	int delta_w, decayed = 0;
+	u64 delta, scaled_delta, periods;
+	u32 runnable_contrib, scaled_runnable_contrib;
+	int delta_w, scaled_delta_w, decayed = 0;
 	u32 scale_cap = arch_scale_load_capacity(cpu);
 
 	delta = now - sa->last_runnable_update;
@@ -2339,11 +2339,12 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 		 */
 		delta_w = 1024 - delta_w;
 
+		scaled_delta_w = (delta_w * scale_cap) >> SCHED_CAPACITY_SHIFT;
+
 		if (runnable)
-			sa->runnable_avg_sum += (delta_w * scale_cap)
-					>> SCHED_CAPACITY_SHIFT;
+			sa->runnable_avg_sum += scaled_delta_w;
 		if (running)
-			sa->usage_avg_sum += delta_w;
+			sa->usage_avg_sum += scaled_delta_w;
 		sa->runnable_avg_period += delta_w;
 
 		delta -= delta_w;
@@ -2361,20 +2362,23 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
 		runnable_contrib = __compute_runnable_contrib(periods);
 
-		if (runnable)
-			sa->runnable_avg_sum += (runnable_contrib * scale_cap)
+		scaled_runnable_contrib = (runnable_contrib * scale_cap)
 						>> SCHED_CAPACITY_SHIFT;
+
+		if (runnable)
+			sa->runnable_avg_sum +=  scaled_runnable_contrib;
 		if (running)
-			sa->usage_avg_sum += runnable_contrib;
+			sa->usage_avg_sum +=  scaled_runnable_contrib;
 		sa->runnable_avg_period += runnable_contrib;
 	}
 
 	/* Remainder of delta accrued against u_0` */
+	scaled_delta = (delta * scale_cap) >> SCHED_CAPACITY_SHIFT;
+
 	if (runnable)
-		sa->runnable_avg_sum += (delta * scale_cap)
-				>> SCHED_CAPACITY_SHIFT;
+		sa->runnable_avg_sum += scaled_delta;
 	if (running)
-		sa->usage_avg_sum += delta;
+		sa->usage_avg_sum += scaled_delta;
 	sa->runnable_avg_period += delta;
 
 	return decayed;
-- 
1.7.9.5


