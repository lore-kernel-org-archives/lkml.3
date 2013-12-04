Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3LDFUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 00:20:14 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:63760 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3LDFUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 00:20:05 -0500
Date: Tue, 3 Dec 2013 21:20:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: [patch 3/8] mm, mempolicy: remove per-process flag
In-Reply-To: <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1312032117490.29733@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PF_MEMPOLICY is an unnecessary optimization for CONFIG_SLAB users.
There's no significant performance degradation to checking
current->mempolicy rather than current->flags & PF_MEMPOLICY in the
allocation path, especially since this is considered unlikely().

Per-process flags are a scarce resource so we should free them up
whenever possible and make them available.  We'll be using it shortly for
memcg oom reserves.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/mempolicy.h |  5 -----
 include/linux/sched.h     |  1 -
 kernel/fork.c             |  1 -
 mm/mempolicy.c            | 31 -------------------------------
 mm/slab.c                 |  4 ++--
 5 files changed, 2 insertions(+), 40 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -143,7 +143,6 @@ extern void numa_policy_init(void);
 extern void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new,
 				enum mpol_rebind_step step);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
-extern void mpol_fix_fork_child_flag(struct task_struct *p);
 
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
@@ -266,10 +265,6 @@ static inline void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
 {
 }
 
-static inline void mpol_fix_fork_child_flag(struct task_struct *p)
-{
-}
-
 static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask)
diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1695,7 +1695,6 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_NO_SETAFFINITY 0x04000000	/* Userland is not allowed to meddle with cpus_allowed */
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
-#define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezable */
 #define PF_SUSPEND_TASK 0x80000000      /* this thread called freeze_processes and should not be frozen */
diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1261,7 +1261,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		p->mempolicy = NULL;
 		goto bad_fork_cleanup_cgroup;
 	}
-	mpol_fix_fork_child_flag(p);
 #endif
 #ifdef CONFIG_CPUSETS
 	p->cpuset_mem_spread_rotor = NUMA_NO_NODE;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -796,36 +796,6 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 	return err;
 }
 
-/*
- * Update task->flags PF_MEMPOLICY bit: set iff non-default
- * mempolicy.  Allows more rapid checking of this (combined perhaps
- * with other PF_* flag bits) on memory allocation hot code paths.
- *
- * If called from outside this file, the task 'p' should -only- be
- * a newly forked child not yet visible on the task list, because
- * manipulating the task flags of a visible task is not safe.
- *
- * The above limitation is why this routine has the funny name
- * mpol_fix_fork_child_flag().
- *
- * It is also safe to call this with a task pointer of current,
- * which the static wrapper mpol_set_task_struct_flag() does,
- * for use within this file.
- */
-
-void mpol_fix_fork_child_flag(struct task_struct *p)
-{
-	if (p->mempolicy)
-		p->flags |= PF_MEMPOLICY;
-	else
-		p->flags &= ~PF_MEMPOLICY;
-}
-
-static void mpol_set_task_struct_flag(void)
-{
-	mpol_fix_fork_child_flag(current);
-}
-
 /* Set the process memory policy */
 static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 			     nodemask_t *nodes)
@@ -862,7 +832,6 @@ static long do_set_mempolicy(unsigned short mode, unsigned short flags,
 	}
 	old = current->mempolicy;
 	current->mempolicy = new;
-	mpol_set_task_struct_flag();
 	if (new && new->mode == MPOL_INTERLEAVE &&
 	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
diff --git a/mm/slab.c b/mm/slab.c
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3027,7 +3027,7 @@ out:
 
 #ifdef CONFIG_NUMA
 /*
- * Try allocating on another node if PF_SPREAD_SLAB|PF_MEMPOLICY.
+ * Try allocating on another node if PF_SPREAD_SLAB is a mempolicy is set.
  *
  * If we are in_interrupt, then process context, including cpusets and
  * mempolicy, may not apply and should not be used for allocation policy.
@@ -3259,7 +3259,7 @@ __do_cache_alloc(struct kmem_cache *cache, gfp_t flags)
 {
 	void *objp;
 
-	if (unlikely(current->flags & (PF_SPREAD_SLAB | PF_MEMPOLICY))) {
+	if (current->mempolicy || unlikely(current->flags & PF_SPREAD_SLAB)) {
 		objp = alternate_node_alloc(cache, flags);
 		if (objp)
 			goto out;
