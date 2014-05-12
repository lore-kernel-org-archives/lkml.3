Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbaELMqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:46:30 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:35708 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbaELMq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:46:28 -0400
Date: Mon, 12 May 2014 15:43:44 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Armin Rigo <arigo@tunes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCHv2 0/2] remap_file_pages() decommission
Message-ID: <20140512124344.GA26865@node.dhcp.inet.fi>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
 <20140508160205.A0EC7E009B@blue.fi.intel.com>
 <CA+55aFw9eiaFtr+c4gcGSWG=pPeqDnX5aPQMVMqX1XkPF30ahg@mail.gmail.com>
 <20140509140536.F06BFE009B@blue.fi.intel.com>
 <CA+55aFz9Yo7OC03tKt2wsdd8cDi00yxvMwszrsOsx0ZVEh6zqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz9Yo7OC03tKt2wsdd8cDi00yxvMwszrsOsx0ZVEh6zqQ@mail.gmail.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 08:14:08AM -0700, Linus Torvalds wrote:
> On Fri, May 9, 2014 at 7:05 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> >
> > Hm. I'm confused here. Do we have any limit forced per-user?
> 
> Sure we do. See "struct user_struct". We limit max number of
> processes, open files, signals etc.
> 
> > I only see things like rlimits which are copied from parrent.
> > Is it what you want?
> 
> No, rlimits are per process (although in some cases what they limit
> are counted per user despite the _limits_ of those resources then
> being settable per thread).
> 
> So I was just thinking that if we raise the per-mm default limits,
> maybe we should add a global per-user limit to make it harder for a
> user to use tons and toms of vma's.

Here's the first attempt.

I'm not completely happy about current_user(). It means we rely on that
user of mm owner task is always equal to user of current. Not sure if it's
always the case.

Other option is to make MM_OWNER is always on and lookup proper user
through task_cred_xxx(rcu_dereference(mm->owner), user).

>From 5ee6f6dd721ada8eb66c84a91003ac1e3eb2970a Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Mon, 12 May 2014 15:13:12 +0300
Subject: [PATCH] mm: add per-user limit on mapping count

We're going to increase per-mm map_count. To avoid non-obvious memory
abuse by creating a lot of VMA's, let's introduce per-user limit.

The limit is implemented as sysctl. For now value of limit is pretty
arbitrary -- 2^20.

sizeof(vm_area_struct) with my kernel config (DEBUG_KERNEL=n) is 184
bytes. It means with the limit user can use up to 184 MiB of RAM in
VMAs.

The limit is not applicable for root (INIT_USER).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/unicore32/include/asm/mmu_context.h |  2 +-
 include/linux/sched.h                    | 27 +++++++++++++++++++++++++++
 include/linux/sched/sysctl.h             |  1 +
 kernel/fork.c                            |  3 ++-
 kernel/sysctl.c                          |  8 ++++++++
 mm/mmap.c                                | 17 +++++++++--------
 mm/mremap.c                              |  2 +-
 mm/nommu.c                               |  7 ++++---
 8 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/include/asm/mmu_context.h
index ef470a7a3d0f..f370d74339da 100644
--- a/arch/unicore32/include/asm/mmu_context.h
+++ b/arch/unicore32/include/asm/mmu_context.h
@@ -76,7 +76,7 @@ do { \
 			mm->mmap = NULL; \
 		rb_erase(&high_vma->vm_rb, &mm->mm_rb); \
 		vmacache_invalidate(mm); \
-		mm->map_count--; \
+		dec_map_count(mm); \
 		remove_vma(high_vma); \
 	} \
 } while (0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c79f757..f9f12c503d14 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -56,6 +56,7 @@ struct sched_param {
 #include <linux/llist.h>
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
+#include <linux/sched/sysctl.h>
 
 #include <asm/processor.h>
 
@@ -747,6 +748,7 @@ struct user_struct {
 	atomic_t processes;	/* How many processes does this user have? */
 	atomic_t files;		/* How many open files does this user have? */
 	atomic_t sigpending;	/* How many pending signals does this user have? */
+	atomic_t map_count;	/* How many mapping does this user have? */
 #ifdef CONFIG_INOTIFY_USER
 	atomic_t inotify_watches; /* How many inotify watches does this user have? */
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
@@ -2991,4 +2993,29 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+static inline void inc_map_count(struct mm_struct *mm)
+{
+	mm->map_count++;
+	atomic_inc(&current_user()->map_count);
+}
+
+static inline void dec_map_count(struct mm_struct *mm)
+{
+	mm->map_count--;
+	atomic_dec(&current_user()->map_count);
+}
+
+static inline bool map_count_check(struct mm_struct *mm, int limit_offset)
+{
+	struct user_struct *user = current_user();
+	if (mm->map_count > sysctl_max_map_count + limit_offset)
+		return true;
+	if (user == INIT_USER)
+		return false;
+	if (atomic_read(&user->map_count) >
+			sysctl_max_map_count_per_user + limit_offset)
+		return true;
+	return false;
+}
+
 #endif
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 8045a554cafb..ce66c4697dbf 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -30,6 +30,7 @@ enum { sysctl_hung_task_timeout_secs = 0 };
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 
 extern int sysctl_max_map_count;
+extern long sysctl_max_map_count_per_user;
 
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
diff --git a/kernel/fork.c b/kernel/fork.c
index 54a8d26f612f..8ea1c538c79e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -454,7 +454,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		rb_link = &tmp->vm_rb.rb_right;
 		rb_parent = &tmp->vm_rb;
 
-		mm->map_count++;
+		inc_map_count(mm);
 		retval = copy_page_range(mm, oldmm, mpnt);
 
 		if (tmp->vm_ops && tmp->vm_ops->open)
@@ -600,6 +600,7 @@ void __mmdrop(struct mm_struct *mm)
 {
 	BUG_ON(mm == &init_mm);
 	mm_free_pgd(mm);
+	atomic_sub(mm->map_count, &current_user()->map_count);
 	destroy_context(mm);
 	mmu_notifier_mm_destroy(mm);
 	check_mm(mm);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 74f5b580fe34..4efe2ed927f2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1316,6 +1316,14 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
+	{
+		.procname	= "max_map_count_per_user",
+		.data		= &sysctl_max_map_count_per_user,
+		.maxlen		= sizeof(sysctl_max_map_count_per_user),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+	},
 #else
 	{
 		.procname	= "nr_trim_pages",
diff --git a/mm/mmap.c b/mm/mmap.c
index b1202cf81f4b..8e2d581347f6 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -89,6 +89,7 @@ int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;  /* heuristic ove
 int sysctl_overcommit_ratio __read_mostly = 50;	/* default is 50% */
 unsigned long sysctl_overcommit_kbytes __read_mostly;
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
+long sysctl_max_map_count_per_user __read_mostly = 1UL << 20;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
 unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
 /*
@@ -652,7 +653,7 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (mapping)
 		mutex_unlock(&mapping->i_mmap_mutex);
 
-	mm->map_count++;
+	inc_map_count(mm);
 	validate_mm(mm);
 }
 
@@ -669,7 +670,7 @@ static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 			   &prev, &rb_link, &rb_parent))
 		BUG();
 	__vma_link(mm, vma, prev, rb_link, rb_parent);
-	mm->map_count++;
+	inc_map_count(mm);
 }
 
 static inline void
@@ -865,7 +866,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 		}
 		if (next->anon_vma)
 			anon_vma_merge(vma, next);
-		mm->map_count--;
+		dec_map_count(mm);
 		mpol_put(vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
 		/*
@@ -1259,7 +1260,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
                return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count)
+	if (map_count_check(mm, 0))
 		return -ENOMEM;
 
 	/* Obtain the address to map to. we verify (or select) it and ensure
@@ -2378,7 +2379,7 @@ detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
 	vma->vm_prev = NULL;
 	do {
 		vma_rb_erase(vma, &mm->mm_rb);
-		mm->map_count--;
+		dec_map_count(mm);
 		tail_vma = vma;
 		vma = vma->vm_next;
 	} while (vma && vma->vm_start < end);
@@ -2468,7 +2469,7 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 	      unsigned long addr, int new_below)
 {
-	if (mm->map_count >= sysctl_max_map_count)
+	if (map_count_check(mm, -1))
 		return -ENOMEM;
 
 	return __split_vma(mm, vma, addr, new_below);
@@ -2517,7 +2518,7 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 		 * not exceed its limit; but let map_count go just above
 		 * its limit temporarily, to help free resources as expected.
 		 */
-		if (end < vma->vm_end && mm->map_count >= sysctl_max_map_count)
+		if (end < vma->vm_end && map_count_check(mm, -1))
 			return -ENOMEM;
 
 		error = __split_vma(mm, vma, start, 0);
@@ -2637,7 +2638,7 @@ static unsigned long do_brk(unsigned long addr, unsigned long len)
 	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count > sysctl_max_map_count)
+	if (map_count_check(mm, 0))
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
diff --git a/mm/mremap.c b/mm/mremap.c
index 05f1180e9f21..f0e34e87828d 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -252,7 +252,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	 * We'd prefer to avoid failure later on in do_munmap:
 	 * which may split one vma into three before unmapping.
 	 */
-	if (mm->map_count >= sysctl_max_map_count - 3)
+	if (map_count_check(mm, -4))
 		return -ENOMEM;
 
 	/*
diff --git a/mm/nommu.c b/mm/nommu.c
index 85f8d6698d48..5b60bd88405c 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -64,6 +64,7 @@ int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
 unsigned long sysctl_overcommit_kbytes __read_mostly;
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
+long sysctl_max_map_count_per_user __read_mostly = 1UL << 20;
 int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
 unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
@@ -710,7 +711,7 @@ static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
 
 	BUG_ON(!vma->vm_region);
 
-	mm->map_count++;
+	inc_map_count(mm);
 	vma->vm_mm = mm;
 
 	protect_vma(vma, vma->vm_flags);
@@ -779,7 +780,7 @@ static void delete_vma_from_mm(struct vm_area_struct *vma)
 
 	protect_vma(vma, 0);
 
-	mm->map_count--;
+	dec_map_count(mm);
 	for (i = 0; i < VMACACHE_SIZE; i++) {
 		/* if the vma is cached, invalidate the entire cache */
 		if (curr->vmacache[i] == vma) {
@@ -1554,7 +1555,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (vma->vm_file)
 		return -ENOMEM;
 
-	if (mm->map_count >= sysctl_max_map_count)
+	if (check_map_count(mm, -1))
 		return -ENOMEM;
 
 	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
-- 
 Kirill A. Shutemov
