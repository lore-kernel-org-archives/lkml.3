Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3GAQEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:04:48 -0400
Received: from multi.imgtec.com ([194.200.65.239]:10418 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab3GAQEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:04:46 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, James Hogan <james.hogan@imgtec.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Anton Vorontsov" <anton.vorontsov@linaro.org>
Subject: [PATCH 1/5] metag: use clear_tasks_mm_cpumask()
Date: Mon, 1 Jul 2013 17:04:15 +0100
Message-ID: <1372694659-30176-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_07_01_17_04_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for process->mm is not enough because process' main thread may
exit or detach its mm via use_mm(), but other threads may still have a
valid mm.

To fix this we would need to use find_lock_task_mm(), which would walk
up all threads and returns an appropriate task (with task lock held).

clear_tasks_mm_cpumask() was introduced in v3.5-rc1 to fix this issue,
so let's use it for metag too.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/metag/kernel/smp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index 86fdda4..b813515 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -276,7 +276,6 @@ static DECLARE_COMPLETION(cpu_killed);
 int __cpuexit __cpu_disable(void)
 {
 	unsigned int cpu = smp_processor_id();
-	struct task_struct *p;
 
 	/*
 	 * Take this CPU offline.  Once we clear this, we can't return,
@@ -296,12 +295,7 @@ int __cpuexit __cpu_disable(void)
 	flush_cache_all();
 	local_flush_tlb_all();
 
-	read_lock(&tasklist_lock);
-	for_each_process(p) {
-		if (p->mm)
-			cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
-	}
-	read_unlock(&tasklist_lock);
+	clear_tasks_mm_cpumask(cpu);
 
 	return 0;
 }
-- 
1.8.1.2


