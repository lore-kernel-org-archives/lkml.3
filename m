Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaIZTpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:45:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:51378 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbaIZTpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:45:34 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, Kevin Hilman <khilman@linaro.org>
Subject: [PATCH] sched/nohz: add debugfs control over sched_tick_max_deferment
Date: Fri, 26 Sep 2014 12:45:32 -0700
Message-Id: <1411760732-14102-1-git-send-email-khilman@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@linaro.org>

Allow debugfs override of sched_tick_max_deferment in order to ease
finding/fixing the remaining issues with full nohz.

The value to be written is in jiffies, and -1 means the max deferment
is disabled (scheduler_tick_max_deferment() returns KTIME_MAX.)

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 kernel/sched/core.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc1638b33449..dee044a5d447 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2514,6 +2514,8 @@ void scheduler_tick(void)
 }
 
 #ifdef CONFIG_NO_HZ_FULL
+static u32 sched_tick_max_deferment = HZ;
+
 /**
  * scheduler_tick_max_deferment
  *
@@ -2532,13 +2534,25 @@ u64 scheduler_tick_max_deferment(void)
 	struct rq *rq = this_rq();
 	unsigned long next, now = ACCESS_ONCE(jiffies);
 
-	next = rq->last_sched_tick + HZ;
+	if (sched_tick_max_deferment == -1)
+		return KTIME_MAX;
+
+	next = rq->last_sched_tick + sched_tick_max_deferment;
 
 	if (time_before_eq(next, now))
 		return 0;
 
 	return jiffies_to_nsecs(next - now);
 }
+
+static __init int sched_nohz_full_init_debug(void)
+{
+	debugfs_create_u32("sched_tick_max_deferment", 0644, NULL,
+			   &sched_tick_max_deferment);
+
+	return 0;
+}
+late_initcall(sched_nohz_full_init_debug);
 #endif
 
 notrace unsigned long get_parent_ip(unsigned long addr)
-- 
2.1.0

