Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaDPCpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:45:31 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41732 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaDPCom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:44:42 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: [PATCH V5 6/8] sched: rewrite update_cpu_load_nohz
Date: Wed, 16 Apr 2014 10:43:27 +0800
Message-Id: <1397616209-27275-7-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After change to sched_avg, the cpu load in idle exit was decayed.
So, it maybe near zero if waking a long time sleep task, or, a full
non-decay load if waking a new forked task. Then, we can use it to
reflect the cpu load, don't need to pretend 0.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/proc.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index 057bb9b..383c4ba 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -461,28 +461,13 @@ void update_idle_cpu_load(struct rq *this_rq)
 }
 
 /*
- * Called from tick_nohz_idle_exit() -- try and fix up the ticks we missed.
+ * Called from tick_nohz_idle_exit()
  */
 void update_cpu_load_nohz(void)
 {
 	struct rq *this_rq = this_rq();
-	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long pending_updates;
-
-	if (curr_jiffies == this_rq->last_load_update_tick)
-		return;
 
-	raw_spin_lock(&this_rq->lock);
-	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
-	if (pending_updates) {
-		this_rq->last_load_update_tick = curr_jiffies;
-		/*
-		 * We were idle, this means load 0, the current load might be
-		 * !0 due to remote wakeups and the sort.
-		 */
-		__update_cpu_load(this_rq, 0);
-	}
-	raw_spin_unlock(&this_rq->lock);
+	update_idle_cpu_load(this_rq);
 }
 #endif /* CONFIG_NO_HZ */
 
-- 
1.8.3.2

