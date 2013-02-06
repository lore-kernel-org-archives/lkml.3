Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab3BFWev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:34:51 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:53507 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3BFWeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:34:50 -0500
Date: Wed, 6 Feb 2013 14:34:45 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.9] workqueue: replace WORK_CPU_NONE/LAST with
 WORK_CPU_END
Message-ID: <20130206223445.GE2875@htj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Now that workqueue has moved away from gcwqs, workqueue no longer has
the need to have a CPU identifier indicating "no cpu associated" - we
now use WORK_OFFQ_POOL_NONE instead - and most uses of WORK_CPU_NONE
are gone.

The only left usage is as the end marker for for_each_*wq*()
iterators, where the name WORK_CPU_NONE is confusing w/o actual
WORK_CPU_NONE usages.  Similarly, WORK_CPU_LAST which equals
WORK_CPU_NONE no longer makes sense.

Replace both WORK_CPU_NONE and LAST with WORK_CPU_END.  This patch
doesn't introduce any functional difference.

tj: s/WORK_CPU_LAST/WORK_CPU_END/ and rewrote description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello, Lai.

I massaged the patch and am committing this to wq/for-3.9.  I think
I'm gonna go through the series, massage other patches too and apply
them, mostly because I wanna make progress on custom pool
implementation and it seems like iterating this series the normal way
would take quite some time.

Thanks!

 include/linux/workqueue.h |    3 +--
 kernel/workqueue.c        |   10 +++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -57,8 +57,7 @@ enum {
 
 	/* special cpu IDs */
 	WORK_CPU_UNBOUND	= NR_CPUS,
-	WORK_CPU_NONE		= NR_CPUS + 1,
-	WORK_CPU_LAST		= WORK_CPU_NONE,
+	WORK_CPU_END		= NR_CPUS + 1,
 
 	/*
 	 * Reserve 7 bits off of cwq pointer w/ debugobjects turned
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -258,7 +258,7 @@ static inline int __next_wq_cpu(int cpu,
 		if (sw & 2)
 			return WORK_CPU_UNBOUND;
 	}
-	return WORK_CPU_NONE;
+	return WORK_CPU_END;
 }
 
 static inline int __next_cwq_cpu(int cpu, const struct cpumask *mask,
@@ -282,17 +282,17 @@ static inline int __next_cwq_cpu(int cpu
  */
 #define for_each_wq_cpu(cpu)						\
 	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, 3);		\
-	     (cpu) < WORK_CPU_NONE;					\
+	     (cpu) < WORK_CPU_END;					\
 	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, 3))
 
 #define for_each_online_wq_cpu(cpu)					\
 	for ((cpu) = __next_wq_cpu(-1, cpu_online_mask, 3);		\
-	     (cpu) < WORK_CPU_NONE;					\
+	     (cpu) < WORK_CPU_END;					\
 	     (cpu) = __next_wq_cpu((cpu), cpu_online_mask, 3))
 
 #define for_each_cwq_cpu(cpu, wq)					\
 	for ((cpu) = __next_cwq_cpu(-1, cpu_possible_mask, (wq));	\
-	     (cpu) < WORK_CPU_NONE;					\
+	     (cpu) < WORK_CPU_END;					\
 	     (cpu) = __next_cwq_cpu((cpu), cpu_possible_mask, (wq)))
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
@@ -3796,7 +3796,7 @@ static int __init init_workqueues(void)
 
 	/* make sure we have enough bits for OFFQ pool ID */
 	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
-		     WORK_CPU_LAST * NR_STD_WORKER_POOLS);
+		     WORK_CPU_END * NR_STD_WORKER_POOLS);
 
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
