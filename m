Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaDPCp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:45:28 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44660 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaDPCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:44:36 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: [PATCH V5 5/8] sched: clean up cpu_load update
Date: Wed, 16 Apr 2014 10:43:26 +0800
Message-Id: <1397616209-27275-6-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we don't decay the rq->cpu_load, so we don't need the
pending_updates. But we still want update rq->rt_avg, so
still keep rq->last_load_update_tick and func __update_cpu_load.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/proc.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index a2435c5..057bb9b 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -404,8 +404,7 @@ static void calc_load_account_active(struct rq *this_rq)
  * scheduler tick (TICK_NSEC). With tickless idle this will not be called
  * every tick. We fix it up based on jiffies.
  */
-static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
-			      unsigned long pending_updates)
+static void __update_cpu_load(struct rq *this_rq, unsigned long this_load)
 {
 	this_rq->nr_load_updates++;
 
@@ -449,7 +448,6 @@ void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
 	unsigned long load = get_rq_runnable_load(this_rq);
-	unsigned long pending_updates;
 
 	/*
 	 * bail if there's load or we're actually up-to-date.
@@ -457,10 +455,9 @@ void update_idle_cpu_load(struct rq *this_rq)
 	if (load || curr_jiffies == this_rq->last_load_update_tick)
 		return;
 
-	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
 	this_rq->last_load_update_tick = curr_jiffies;
 
-	__update_cpu_load(this_rq, load, pending_updates);
+	__update_cpu_load(this_rq, load);
 }
 
 /*
@@ -483,7 +480,7 @@ void update_cpu_load_nohz(void)
 		 * We were idle, this means load 0, the current load might be
 		 * !0 due to remote wakeups and the sort.
 		 */
-		__update_cpu_load(this_rq, 0, pending_updates);
+		__update_cpu_load(this_rq, 0);
 	}
 	raw_spin_unlock(&this_rq->lock);
 }
@@ -499,7 +496,7 @@ void update_cpu_load_active(struct rq *this_rq)
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, load, 1);
+	__update_cpu_load(this_rq, load);
 
 	calc_load_account_active(this_rq);
 }
-- 
1.8.3.2

