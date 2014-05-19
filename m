Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaESNIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:08:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbaESNIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:08:13 -0400
Date: Mon, 19 May 2014 06:07:29 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-7cysnkw1gik45r864t1nkudh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, rostedt@goodmis.org,
        tj@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, rostedt@goodmis.org,
        tj@kernel.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpupri: Replace NR_CPUS arrays
Git-Commit-ID: eb6c66ad14087b1fec14871374aa34a135aab971
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

Commit-ID:  eb6c66ad14087b1fec14871374aa34a135aab971
Gitweb:     http://git.kernel.org/tip/eb6c66ad14087b1fec14871374aa34a135aab971
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 14 May 2014 16:04:26 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 21:47:34 +0900

sched/cpupri: Replace NR_CPUS arrays

Tejun reported that his resume was failing due to order-3 allocations
from sched_domain building.

Replace the NR_CPUS arrays in there with a dynamically allocated
array.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-7cysnkw1gik45r864t1nkudh@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/cpupri.c | 7 +++++++
 kernel/sched/cpupri.h | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 3031bac..8834243 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -30,6 +30,7 @@
 #include <linux/gfp.h>
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
+#include <linux/slab.h>
 #include "cpupri.h"
 
 /* Convert between a 140 based task->prio, and our 102 based cpupri */
@@ -218,8 +219,13 @@ int cpupri_init(struct cpupri *cp)
 			goto cleanup;
 	}
 
+	cp->cpu_to_pri = kcalloc(nr_cpu_ids, sizeof(int), GFP_KERNEL);
+	if (!cp->cpu_to_pri)
+		goto cleanup;
+
 	for_each_possible_cpu(i)
 		cp->cpu_to_pri[i] = CPUPRI_INVALID;
+
 	return 0;
 
 cleanup:
@@ -236,6 +242,7 @@ void cpupri_cleanup(struct cpupri *cp)
 {
 	int i;
 
+	kfree(cp->cpu_to_pri);
 	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++)
 		free_cpumask_var(cp->pri_to_cpu[i].mask);
 }
diff --git a/kernel/sched/cpupri.h b/kernel/sched/cpupri.h
index f6d7561..6b03334 100644
--- a/kernel/sched/cpupri.h
+++ b/kernel/sched/cpupri.h
@@ -17,7 +17,7 @@ struct cpupri_vec {
 
 struct cpupri {
 	struct cpupri_vec pri_to_cpu[CPUPRI_NR_PRIORITIES];
-	int               cpu_to_pri[NR_CPUS];
+	int *cpu_to_pri;
 };
 
 #ifdef CONFIG_SMP
