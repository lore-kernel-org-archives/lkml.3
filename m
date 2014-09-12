Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaILNTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:19:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbaILNTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:19:05 -0400
From: Aaron Tomlin <atomlin@redhat.com>
To: peterz@infradead.org
Cc: mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com, jcastillo@redhat.com,
        atomlin@redhat.com, oleg@redhat.com, riel@redhat.com,
        prarit@redhat.com, jgh@redhat.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, x86@kernel.org, rostedt@goodmis.org,
        hannes@cmpxchg.org, aneesh.kumar@linux.vnet.ibm.com,
        akpm@linux-foundation.org, akpm@google.com,
        linuxppc-dev@lists.ozlabs.org, minchan@kernel.org, mpe@ellerman.id.au
Subject: [PATCH v4 3/3] sched: BUG when stack end location is over written
Date: Fri, 12 Sep 2014 14:16:19 +0100
Message-Id: <1410527779-8133-4-git-send-email-atomlin@redhat.com>
In-Reply-To: <1410527779-8133-1-git-send-email-atomlin@redhat.com>
References: <1410527779-8133-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in the event of a stack overrun a call to schedule()
does not check for this type of corruption. This corruption is
often silent and can go unnoticed. However once the corrupted
region is examined at a later stage, the outcome is undefined
and often results in a sporadic page fault which cannot be
handled.

This patch checks for a stack overrun and takes appropriate
action since the damage is already done, there is no point
in continuing.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 kernel/sched/core.c |  3 +++
 lib/Kconfig.debug   | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ec1a286..6ed1a24 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2660,6 +2660,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
  */
 static inline void schedule_debug(struct task_struct *prev)
 {
+#ifdef CONFIG_SCHED_STACK_END_CHECK
+	BUG_ON(unlikely(task_stack_end_corrupted(prev)));
+#endif
 	/*
 	 * Test if we are atomic. Since do_exit() needs to call into
 	 * schedule() atomically, we ignore that path. Otherwise whine
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a285900..e58163d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -824,6 +824,18 @@ config SCHEDSTATS
 	  application, you can say N to avoid the very slight overhead
 	  this adds.
 
+config SCHED_STACK_END_CHECK
+	bool "Detect stack corruption on calls to schedule()"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option checks for a stack overrun on calls to schedule().
+	  If the stack end location is found to be over written always panic as
+	  the content of the corrupted region can no longer be trusted.
+	  This is to ensure no erroneous behaviour occurs which could result in
+	  data corruption or a sporadic crash at a later stage once the region
+	  is examined. The runtime overhead introduced is minimal.
+
 config TIMER_STATS
 	bool "Collect kernel timers statistics"
 	depends on DEBUG_KERNEL && PROC_FS
-- 
1.9.3

