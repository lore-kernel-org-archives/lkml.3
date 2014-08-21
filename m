Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaHUTER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbaHUTEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:04:15 -0400
Date: Thu, 21 Aug 2014 21:01:17 +0200
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
Subject: [PATCH 2/4] mempolicy: fix show_numa_map() vs exec() +
	do_set_mempolicy() race
Message-ID: <20140821190117.GC8703@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820192207.GA8524@redhat.com> <20140821190020.GA8703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821190020.GA8703@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9e7814404b77 "hold task->mempolicy while numa_maps scans." fixed the
race with the exiting task but this is not enough.

The current code assumes that get_vma_policy(task) should either see
task->mempolicy == NULL or it should be equal to ->task_mempolicy saved
by hold_task_mempolicy(), so we can never race with __mpol_put(). But
this can only work if we can't race with do_set_mempolicy(), and thus
we can't race with another do_set_mempolicy() or do_exit() after that.

However, do_set_mempolicy()->down_write(mmap_sem) can not prevent this
race. This task can exec, change it's ->mm, and call do_set_mempolicy()
after that; in this case they take 2 different locks.

Change hold_task_mempolicy() to use get_task_policy(), it never returns
NULL, and change show_numa_map() to use __get_vma_policy() or fall back
to proc_priv->task_mempolicy.

Note: this is the minimal fix, we will cleanup this code later. I think
hold_task_mempolicy() and release_task_mempolicy() should die, we can
move this logic into show_numa_map(). Or we can move get_task_policy()
outside of ->mmap_sem and !CONFIG_NUMA code at least.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |   33 +++++++++------------------------
 1 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 9d7a9a6..7810aba 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -87,32 +87,14 @@ unsigned long task_statm(struct mm_struct *mm,
 
 #ifdef CONFIG_NUMA
 /*
- * These functions are for numa_maps but called in generic **maps seq_file
- * ->start(), ->stop() ops.
- *
- * numa_maps scans all vmas under mmap_sem and checks their mempolicy.
- * Each mempolicy object is controlled by reference counting. The problem here
- * is how to avoid accessing dead mempolicy object.
- *
- * Because we're holding mmap_sem while reading seq_file, it's safe to access
- * each vma's mempolicy, no vma objects will never drop refs to mempolicy.
- *
- * A task's mempolicy (task->mempolicy) has different behavior. task->mempolicy
- * is set and replaced under mmap_sem but unrefed and cleared under task_lock().
- * So, without task_lock(), we cannot trust get_vma_policy() because we cannot
- * gurantee the task never exits under us. But taking task_lock() around
- * get_vma_plicy() causes lock order problem.
- *
- * To access task->mempolicy without lock, we hold a reference count of an
- * object pointed by task->mempolicy and remember it. This will guarantee
- * that task->mempolicy points to an alive object or NULL in numa_maps accesses.
+ * Save get_task_policy() for show_numa_map().
  */
 static void hold_task_mempolicy(struct proc_maps_private *priv)
 {
 	struct task_struct *task = priv->task;
 
 	task_lock(task);
-	priv->task_mempolicy = task->mempolicy;
+	priv->task_mempolicy = get_task_policy(task);
 	mpol_get(priv->task_mempolicy);
 	task_unlock(task);
 }
@@ -1423,7 +1405,6 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	struct vm_area_struct *vma = v;
 	struct numa_maps *md = &numa_priv->md;
 	struct file *file = vma->vm_file;
-	struct task_struct *task = proc_priv->task;
 	struct mm_struct *mm = vma->vm_mm;
 	struct mm_walk walk = {};
 	struct mempolicy *pol;
@@ -1443,9 +1424,13 @@ static int show_numa_map(struct seq_file *m, void *v, int is_pid)
 	walk.private = md;
 	walk.mm = mm;
 
-	pol = get_vma_policy(task, vma, vma->vm_start);
-	mpol_to_str(buffer, sizeof(buffer), pol);
-	mpol_cond_put(pol);
+	pol = __get_vma_policy(vma, vma->vm_start);
+	if (pol) {
+		mpol_to_str(buffer, sizeof(buffer), pol);
+		mpol_cond_put(pol);
+	} else {
+		mpol_to_str(buffer, sizeof(buffer), proc_priv->task_mempolicy);
+	}
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
-- 
1.5.5.1


