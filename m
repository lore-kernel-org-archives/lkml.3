Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3LQVXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 16:23:12 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46769 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3LQVXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 16:23:10 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 1/2] sched/nohz: add debugfs control over sched_tick_max_deferment
Date: Tue, 17 Dec 2013 13:23:07 -0800
Message-Id: <1387315388-31676-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 5ac63c9a995a..4b1fe3e69fe4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2175,6 +2175,8 @@ void scheduler_tick(void)
 }
 
 #ifdef CONFIG_NO_HZ_FULL
+static u32 sched_tick_max_deferment = HZ;
+
 /**
  * scheduler_tick_max_deferment
  *
@@ -2193,13 +2195,25 @@ u64 scheduler_tick_max_deferment(void)
 	struct rq *rq = this_rq();
 	unsigned long next, now = ACCESS_ONCE(jiffies);
 
-	next = rq->last_sched_tick + HZ;
+	if (sched_tick_max_deferment == -1)
+		return KTIME_MAX;
+
+	next = rq->last_sched_tick + sched_tick_max_deferment;
 
 	if (time_before_eq(next, now))
 		return 0;
 
 	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
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
1.8.3

