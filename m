Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbaHTT1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:27:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbaHTT1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:27:01 -0400
Date: Wed, 20 Aug 2014 21:23:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mempolicy: remove the "task" arg of vma_policy_mof()
	and simplify it
Message-ID: <20140820192355.GE8524@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820192207.GA8524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820192207.GA8524@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. vma_policy_mof(task) is simply not safe unless task == current,
   it can race with do_exit()->mpol_put(). Remove this arg and update
   its single caller.

2. vma can not be NULL, remove this check and simplify the code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/mempolicy.h |    2 +-
 kernel/sched/fair.c       |    2 +-
 mm/mempolicy.c            |   25 +++++++++++--------------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index f230a97..5e4bfce 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -136,7 +136,7 @@ struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 
 struct mempolicy *get_vma_policy(struct task_struct *tsk,
 		struct vm_area_struct *vma, unsigned long addr);
-bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma);
+bool vma_policy_mof(struct vm_area_struct *vma);
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86..82088b2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1946,7 +1946,7 @@ void task_numa_work(struct callback_head *work)
 		vma = mm->mmap;
 	}
 	for (; vma; vma = vma->vm_next) {
-		if (!vma_migratable(vma) || !vma_policy_mof(p, vma))
+		if (!vma_migratable(vma) || !vma_policy_mof(vma))
 			continue;
 
 		/*
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b86b08e..ad27bbc 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1646,27 +1646,24 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
 	return pol;
 }
 
-bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
+bool vma_policy_mof(struct vm_area_struct *vma)
 {
-	struct mempolicy *pol = NULL;
-
-	if (vma) {
-		if (vma->vm_ops && vma->vm_ops->get_policy) {
-			bool ret = false;
+	struct mempolicy *pol;
 
-			pol = vma->vm_ops->get_policy(vma, vma->vm_start);
-			if (pol && (pol->flags & MPOL_F_MOF))
-				ret = true;
-			mpol_cond_put(pol);
+	if (vma->vm_ops && vma->vm_ops->get_policy) {
+		bool ret = false;
 
-			return ret;
-		}
+		pol = vma->vm_ops->get_policy(vma, vma->vm_start);
+		if (pol && (pol->flags & MPOL_F_MOF))
+			ret = true;
+		mpol_cond_put(pol);
 
-		pol = vma->vm_policy;
+		return ret;
 	}
 
+	pol = vma->vm_policy;
 	if (!pol)
-		pol = get_task_policy(task);
+		pol = get_task_policy(current);
 
 	return pol->flags & MPOL_F_MOF;
 }
-- 
1.5.5.1


