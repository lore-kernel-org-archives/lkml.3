Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaBQOMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:12:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43515 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaBQOMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:12:00 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
Subject: [PATCH] sched/deadline: Test for CPU's presence explicitly
Date: Mon, 17 Feb 2014 09:12:33 -0500
Message-Id: <1392646353-1874-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A hot-removed CPU may have ID that is numerically larger than the number of
existing CPUs in the system (e.g. we can unplug CPU 4 from a system that
has CPUs 0, 1 and 4).

Thus the WARN_ONs should check whether the CPU in question is currently
present, not whether its ID value is less than num_present_cpus().

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 kernel/sched/cpudeadline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 045fc74..5b8838b 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -70,7 +70,7 @@ static void cpudl_heapify(struct cpudl *cp, int idx)
 
 static void cpudl_change_key(struct cpudl *cp, int idx, u64 new_dl)
 {
-	WARN_ON(idx > num_present_cpus() || idx == IDX_INVALID);
+	WARN_ON(!cpu_present(idx) || idx == IDX_INVALID);
 
 	if (dl_time_before(new_dl, cp->elements[idx].dl)) {
 		cp->elements[idx].dl = new_dl;
@@ -117,7 +117,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	}
 
 out:
-	WARN_ON(best_cpu > num_present_cpus() && best_cpu != -1);
+	WARN_ON(!cpu_present(best_cpu) && best_cpu != -1);
 
 	return best_cpu;
 }
@@ -137,7 +137,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 	int old_idx, new_cpu;
 	unsigned long flags;
 
-	WARN_ON(cpu > num_present_cpus());
+	WARN_ON(!cpu_present(cpu));
 
 	raw_spin_lock_irqsave(&cp->lock, flags);
 	old_idx = cp->cpu_to_idx[cpu];
-- 
1.8.1.4

