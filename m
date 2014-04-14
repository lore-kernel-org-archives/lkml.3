Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbaDNQ0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:26:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57444 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbaDNQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:26:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 25/38] tick-sched: don't call local_softirq_pending() thrice in can_stop_idle_tick()
Date: Mon, 14 Apr 2014 21:53:47 +0530
Message-Id: <46cbce23e1293fd2257ec2ad55026f0d673b9fa6.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can_stop_idle_tick() checks if a local softirq is pending or not, and in case
it is pending we call the same routine two more times.

Rather store the value in a local variable and reuse it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5a99859..b7b09b9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -691,6 +691,8 @@ static void tick_nohz_full_stop_tick(struct tick_sched *ts)
 
 static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 {
+	unsigned int softirq;
+
 	/*
 	 * If this cpu is offline and it is the one which updates
 	 * jiffies, then give up the assignment and let it be taken by
@@ -712,13 +714,11 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	if (need_resched())
 		return false;
 
-	if (unlikely(local_softirq_pending())) {
+	if (unlikely((softirq = local_softirq_pending()))) {
 		static int ratelimit;
 
-		if (ratelimit < 10 &&
-		    (local_softirq_pending() & SOFTIRQ_STOP_IDLE_MASK)) {
-			pr_warn("NOHZ: local_softirq_pending %02x\n",
-				(unsigned int) local_softirq_pending());
+		if (ratelimit < 10 && (softirq & SOFTIRQ_STOP_IDLE_MASK)) {
+			pr_warn("NOHZ: local_softirq_pending %02x\n", softirq);
 			ratelimit++;
 		}
 		return false;
-- 
1.7.12.rc2.18.g61b472e

