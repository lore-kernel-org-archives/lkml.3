Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaCFW6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:58:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaCFW62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:58:28 -0500
Date: Thu, 6 Mar 2014 14:58:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140306145826.4453a8edbfcf18cd2e9fa8c1@linux-foundation.org>
In-Reply-To: <20140306180852.b1515db3cccc1622172524c0@canb.auug.org.au>
References: <20140306180852.b1515db3cccc1622172524c0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 18:08:52 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> ...
>
> and on and on ...
> 
> Caused by commit 0d9ad4220e6d ("mm: per-thread vma caching") which adds
> the include of linux/vmacache.h (which includes linux/mm.h) into
> linux/sched.h ... There is a reason that we did not include linux/mm.h
> into sched.h.

Yeah.

> --- /dev/null
> +++ b/include/linux/vmacachedefs.h
> @@ -0,0 +1,9 @@
> +
> +#ifndef __LINUX_VMACACHEDEFS_H
> +#define __LINUX_VMACACHEDEFS_H
> +
> +#define VMACACHE_BITS 2
> +#define VMACACHE_SIZE (1U << VMACACHE_BITS)
> +#define VMACACHE_MASK (VMACACHE_SIZE - 1)
> +
> +#endif /* __LINUX_VMACACHEDEFS_H */

I just did pretty much the same thing:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-per-thread-vma-caching-fix-3

Attempt to untangle header files.

Prior to this patch:

mm.h does not require sched.h
sched.h does not require mm.h
sched.h requires vmacache.h
vmacache.h requires mm.h

After this patch:

mm.h still does not require sched.h
sched.h still does not require mm.h
sched.h does not require vmacache.h
mm.h does not require vmacache.h
vmacache.h requires (and includes) mm.h
vmacache.h requires (and includes) sched.h

To do all this, the three "#define VMACACHE_foo" lines were moved to
sched.h.

The inclusions of sched.h and mm.h into vmacache.h are actually unrequired
because the .c files include mm.h and sched.h directly, but I put them in
there for cargo-cult reasons.

vmacache_flush() no longer needs to be implemented in cpp - make it so.

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/include/asm/mmu_context.h |    2 ++
 fs/exec.c                                |    1 +
 fs/proc/task_mmu.c                       |    1 +
 include/linux/sched.h                    |    5 ++++-
 include/linux/vmacache.h                 |   12 +++++-------
 kernel/debug/debug_core.c                |    1 +
 kernel/fork.c                            |    2 ++
 mm/mmap.c                                |    1 +
 mm/nommu.c                               |    1 +
 mm/vmacache.c                            |    1 +
 10 files changed, 19 insertions(+), 8 deletions(-)

diff -puN arch/unicore32/include/asm/mmu_context.h~mm-per-thread-vma-caching-fix-3 arch/unicore32/include/asm/mmu_context.h
--- a/arch/unicore32/include/asm/mmu_context.h~mm-per-thread-vma-caching-fix-3
+++ a/arch/unicore32/include/asm/mmu_context.h
@@ -14,6 +14,8 @@
 
 #include <linux/compiler.h>
 #include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/io.h>
 
 #include <asm/cacheflush.h>
diff -puN fs/exec.c~mm-per-thread-vma-caching-fix-3 fs/exec.c
--- a/fs/exec.c~mm-per-thread-vma-caching-fix-3
+++ a/fs/exec.c
@@ -26,6 +26,7 @@
 #include <linux/file.h>
 #include <linux/fdtable.h>
 #include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/swap.h>
diff -puN fs/proc/task_mmu.c~mm-per-thread-vma-caching-fix-3 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-per-thread-vma-caching-fix-3
+++ a/fs/proc/task_mmu.c
@@ -1,4 +1,5 @@
 #include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/hugetlb.h>
 #include <linux/huge_mm.h>
 #include <linux/mount.h>
diff -puN include/linux/mm_types.h~mm-per-thread-vma-caching-fix-3 include/linux/mm_types.h
diff -puN include/linux/sched.h~mm-per-thread-vma-caching-fix-3 include/linux/sched.h
--- a/include/linux/sched.h~mm-per-thread-vma-caching-fix-3
+++ a/include/linux/sched.h
@@ -23,7 +23,6 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
-#include <linux/vmacache.h>
 #include <linux/preempt_mask.h>
 
 #include <asm/page.h>
@@ -131,6 +130,10 @@ struct perf_event_context;
 struct blk_plug;
 struct filename;
 
+#define VMACACHE_BITS 2
+#define VMACACHE_SIZE (1U << VMACACHE_BITS)
+#define VMACACHE_MASK (VMACACHE_SIZE - 1)
+
 /*
  * List of flags we want to share for kernel threads,
  * if only because they are not used by them anyway.
diff -puN include/linux/vmacache.h~mm-per-thread-vma-caching-fix-3 include/linux/vmacache.h
--- a/include/linux/vmacache.h~mm-per-thread-vma-caching-fix-3
+++ a/include/linux/vmacache.h
@@ -1,21 +1,19 @@
 #ifndef __LINUX_VMACACHE_H
 #define __LINUX_VMACACHE_H
 
+#include <linux/sched.h>
 #include <linux/mm.h>
 
-#define VMACACHE_BITS 2
-#define VMACACHE_SIZE (1U << VMACACHE_BITS)
-#define VMACACHE_MASK (VMACACHE_SIZE - 1)
 /*
  * Hash based on the page number. Provides a good hit rate for
  * workloads with good locality and those with random accesses as well.
  */
 #define VMACACHE_HASH(addr) ((addr >> PAGE_SHIFT) & VMACACHE_MASK)
 
-#define vmacache_flush(tsk)					 \
-	do {							 \
-		memset(tsk->vmacache, 0, sizeof(tsk->vmacache)); \
-	} while (0)
+static inline void vmacache_flush(struct task_struct *tsk)
+{
+	memset(tsk->vmacache, 0, sizeof(tsk->vmacache));
+}
 
 extern void vmacache_flush_all(struct mm_struct *mm);
 extern void vmacache_update(unsigned long addr, struct vm_area_struct *newvma);
diff -puN kernel/debug/debug_core.c~mm-per-thread-vma-caching-fix-3 kernel/debug/debug_core.c
--- a/kernel/debug/debug_core.c~mm-per-thread-vma-caching-fix-3
+++ a/kernel/debug/debug_core.c
@@ -49,6 +49,7 @@
 #include <linux/pid.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/rcupdate.h>
 
 #include <asm/cacheflush.h>
diff -puN kernel/fork.c~mm-per-thread-vma-caching-fix-3 kernel/fork.c
--- a/kernel/fork.c~mm-per-thread-vma-caching-fix-3
+++ a/kernel/fork.c
@@ -28,6 +28,8 @@
 #include <linux/mman.h>
 #include <linux/mmu_notifier.h>
 #include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/nsproxy.h>
 #include <linux/capability.h>
 #include <linux/cpu.h>
diff -puN mm/Makefile~mm-per-thread-vma-caching-fix-3 mm/Makefile
diff -puN mm/mmap.c~mm-per-thread-vma-caching-fix-3 mm/mmap.c
--- a/mm/mmap.c~mm-per-thread-vma-caching-fix-3
+++ a/mm/mmap.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/shm.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
diff -puN mm/nommu.c~mm-per-thread-vma-caching-fix-3 mm/nommu.c
--- a/mm/nommu.c~mm-per-thread-vma-caching-fix-3
+++ a/mm/nommu.c
@@ -15,6 +15,7 @@
 
 #include <linux/export.h>
 #include <linux/mm.h>
+#include <linux/vmacache.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/file.h>
diff -puN mm/vmacache.c~mm-per-thread-vma-caching-fix-3 mm/vmacache.c
--- a/mm/vmacache.c~mm-per-thread-vma-caching-fix-3
+++ a/mm/vmacache.c
@@ -2,6 +2,7 @@
  * Copyright (C) 2014 Davidlohr Bueso.
  */
 #include <linux/sched.h>
+#include <linux/mm.h>
 #include <linux/vmacache.h>
 
 /*
_

