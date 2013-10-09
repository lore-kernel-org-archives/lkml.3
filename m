Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab3JIR3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:29:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3JIR3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:29:43 -0400
Date: Wed, 9 Oct 2013 10:29:03 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-fc3147245d193bd0f57307859c698fa28a20b0fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, jmario@redhat.com,
        riel@redhat.com, srikar@linux.vnet.ibm.com, aarcange@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, jmario@redhat.com,
        riel@redhat.com, aarcange@redhat.com, srikar@linux.vnet.ibm.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1381141781-10992-32-git-send-email-mgorman@suse.de>
References: <1381141781-10992-32-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm: numa:
  Limit NUMA scanning to migrate-on-fault VMAs
Git-Commit-ID: fc3147245d193bd0f57307859c698fa28a20b0fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:29:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc3147245d193bd0f57307859c698fa28a20b0fe
Gitweb:     http://git.kernel.org/tip/fc3147245d193bd0f57307859c698fa28a20b0fe
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:09 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:38 +0200

mm: numa: Limit NUMA scanning to migrate-on-fault VMAs

There is a 90% regression observed with a large Oracle performance test
on a 4 node system. Profiles indicated that the overhead was due to
contention on sp_lock when looking up shared memory policies. These
policies do not have the appropriate flags to allow them to be
automatically balanced so trapping faults on them is pointless. This
patch skips VMAs that do not have MPOL_F_MOF set.

[riel@redhat.com: Initial patch]

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-and-tested-by: Joe Mario <jmario@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-32-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mempolicy.h |  1 +
 kernel/sched/fair.c       |  2 +-
 mm/mempolicy.c            | 24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index da6716b..ea4d249 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -136,6 +136,7 @@ struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 
 struct mempolicy *get_vma_policy(struct task_struct *tsk,
 		struct vm_area_struct *vma, unsigned long addr);
+bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma);
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 61ec0d4..d98175d 100644
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
index 196d8da..0e895a2 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1679,6 +1679,30 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
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
