Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaAOEIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:08:21 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45758 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAOEIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:08:19 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        Alex Shi <alex.shi@linaro.org>
Subject: [RFC PATCH] sched: find the latest idle cpu
Date: Wed, 15 Jan 2014 12:07:59 +0800
Message-Id: <1389758879-19951-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we just try to find least load cpu. If some cpus idled,
we just pick the first cpu in cpu mask.

In fact we can get the interrupted idle cpu or the latest idled cpu,
then we may get the benefit from both latency and power.
The selected cpu maybe not the best, since other cpu may be interrupted
during our selecting. But be captious costs too much.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c7395d9..fb52d26 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4167,6 +4167,26 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 			min_load = load;
 			idlest = i;
 		}
+#ifdef CONFIG_NO_HZ_COMMON
+		/*
+		 * Coarsely to get the latest idle cpu for shorter latency and
+		 * possible power benefit.
+		 */
+		if (!min_load) {
+			struct tick_sched *ts = &per_cpu(tick_cpu_sched, i);
+
+			s64 latest_wake = 0;
+			/* idle cpu doing irq */
+			if (ts->inidle && !ts->idle_active)
+				idlest = i;
+			/* the cpu resched */
+			else if (!ts->inidle)
+				idlest = i;
+			/* find latest idle cpu */
+			else if (ktime_to_us(ts->idle_entrytime) > latest_wake)
+				idlest = i;
+		}
+#endif
 	}
 
 	return idlest;
-- 
1.8.1.2

