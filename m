Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaBXFNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:13:22 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:65139 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaBXFNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:13:17 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com
Subject: [PATCH 05/10] sched: rewrite update_cpu_load_nohz
Date: Mon, 24 Feb 2014 13:12:20 +0800
Message-Id: <1393218745-8795-6-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1393218745-8795-1-git-send-email-alex.shi@linaro.org>
References: <1393218745-8795-1-git-send-email-alex.shi@linaro.org>
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
1.8.1.2

