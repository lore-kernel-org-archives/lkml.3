Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab3KMIQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:16:35 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58549 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759287Ab3KMIQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:16:31 -0500
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 1/2] sched/mm: add finish_switch_mm function
Date: Wed, 13 Nov 2013 09:16:13 +0100
Message-Id: <1384330574-18418-2-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111308-2966-0000-0000-00000958746C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The switch_mm function is called with the task_lock and/or with
request queue lock. Add finish_switch_mm to allow an architecture
to execute some code after the mm has been switched but without
any locks held. One use case is the s390 architecture which will
use this to wait for the completion of TLB flush operations.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/mmu_context.h |    6 ++++++
 kernel/sched/core.c         |    7 +++++--
 mm/mmu_context.c            |    3 +--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmu_context.h b/include/linux/mmu_context.h
index 70fffeb..0971c37 100644
--- a/include/linux/mmu_context.h
+++ b/include/linux/mmu_context.h
@@ -1,9 +1,15 @@
 #ifndef _LINUX_MMU_CONTEXT_H
 #define _LINUX_MMU_CONTEXT_H
 
+#include <asm/mmu_context.h>
+
 struct mm_struct;
 
 void use_mm(struct mm_struct *mm);
 void unuse_mm(struct mm_struct *mm);
 
+#ifndef finish_switch_mm
+#define finish_switch_mm(mm, tsk) do { } while (0)
+#endif
+
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1deccd7..89409cb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -32,7 +32,7 @@
 #include <linux/init.h>
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
-#include <asm/mmu_context.h>
+#include <linux/mmu_context.h>
 #include <linux/interrupt.h>
 #include <linux/capability.h>
 #include <linux/completion.h>
@@ -1996,6 +1996,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	perf_event_task_sched_in(prev, current);
 	finish_lock_switch(rq, prev);
 	finish_arch_post_lock_switch();
+	finish_switch_mm(current->mm, current);
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
@@ -4140,8 +4141,10 @@ void idle_task_exit(void)
 
 	BUG_ON(cpu_online(smp_processor_id()));
 
-	if (mm != &init_mm)
+	if (mm != &init_mm) {
 		switch_mm(mm, &init_mm, current);
+		finish_switch_mm(&init_mm, current);
+	}
 	mmdrop(mm);
 }
 
diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index 8a8cd02..11b3d47 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -8,8 +8,6 @@
 #include <linux/export.h>
 #include <linux/sched.h>
 
-#include <asm/mmu_context.h>
-
 /*
  * use_mm
  *	Makes the calling kernel thread take on the specified
@@ -31,6 +29,7 @@ void use_mm(struct mm_struct *mm)
 	tsk->mm = mm;
 	switch_mm(active_mm, mm, tsk);
 	task_unlock(tsk);
+	finish_switch_mm(mm, tsk);
 
 	if (active_mm != mm)
 		mmdrop(active_mm);
-- 
1.7.9.5

