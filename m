Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3I0Nio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:38:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3I0N2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:22 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 31/63] mm: numa: only unmap migrate-on-fault VMAs
Date: Fri, 27 Sep 2013 14:27:16 +0100
Message-Id: <1380288468-5551-32-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a 90% regression observed with a large Oracle performance test
on a 4 node system. Profiles indicated that the overhead was due to
contention on sp_lock when looking up shared memory policies. These
policies do not have the appropriate flags to allow them to be
automatically balanced so trapping faults on them is pointless. This
patch skips VMAs that do not have MPOL_F_MOF set.

[riel@redhat.com: Initial patch]
Reviewed-by: Rik van Riel <riel@redhat.com>
Reported-and-tested-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mempolicy.h |  1 +
 kernel/sched/fair.c       |  2 +-
 mm/mempolicy.c            | 24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 0d7df39..f6b2c4d 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -136,6 +136,7 @@ struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 
 struct mempolicy *get_vma_policy(struct task_struct *tsk,
 		struct vm_area_struct *vma, unsigned long addr);
+bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma);
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f136057..f9329d5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1130,7 +1130,7 @@ void task_numa_work(struct callback_head *work)
 		vma = mm->mmap;
 	}
 	for (; vma; vma = vma->vm_next) {
-		if (!vma_migratable(vma))
+		if (!vma_migratable(vma) || !vma_policy_mof(p, vma))
 			continue;
 
 		do {
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index adc93b2..54004a8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1633,6 +1633,30 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
 	return pol;
 }
 
+bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
+{
+	struct mempolicy *pol = get_task_policy(task);
+	if (vma) {
+		if (vma->vm_ops && vma->vm_ops->get_policy) {
+			bool ret = false;
+
+			pol = vma->vm_ops->get_policy(vma, vma->vm_start);
+			if (pol && (pol->flags & MPOL_F_MOF))
+				ret = true;
+			mpol_cond_put(pol);
+
+			return ret;
+		} else if (vma->vm_policy) {
+			pol = vma->vm_policy;
+		}
+	}
+
+	if (!pol)
+		return default_policy.flags & MPOL_F_MOF;
+
+	return pol->flags & MPOL_F_MOF;
+}
+
 static int apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
 {
 	enum zone_type dynamic_policy_zone = policy_zone;
-- 
1.8.1.4

