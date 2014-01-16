Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaAPVBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 16:01:52 -0500
Received: from relay2.sgi.com ([192.48.179.30]:55614 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750754AbaAPVBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:01:49 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFC PATCHv2 1/2] Add mm flag to control THP
Date: Thu, 16 Jan 2014 15:01:43 -0600
Message-Id: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an mm flag (MMF_THP_DISABLE) to disable transparent
hugepages using prctl.

Changes for v2:

* Pulled code for prctl helper functions into prctl to make things more
  concise.
* Changed PRCTL_SET_THP_DISABLE to accept an argument to set/clear the
  THP_DISABLE bit, instead of having two separate PRCTLs for this.
* Removed ifdef in prctl.h that defined MMF_THP_DISABLE based on whether
  or not CONFIG_TRANSPARENT_HUGEPAGE was set.
* Added code to get khugepaged to ignore mm_structs with THP disabled.

The main motivation behind this patch is to provide a way to disable THP
for jobs where the code cannot be modified and using a malloc hook with
madvise is not an option (i.e. statically allocated data).  This patch
allows us to do just that, without affecting other jobs running on the
system.

We need to do this sort of thing for jobs where THP hurts performance,
due to the possibility of increased remote memory accesses that can be
created by situations such as the following:

When you touch 1 byte of an untouched, contiguous 2MB chunk, a THP will
be handed out, and the THP will be stuck on whatever node the chunk was
originally referenced from.  If many remote nodes need to do work on that
same chunk, they'll be making remote accesses.

With THP disabled, 4K pages can be handed out to separate nodes as
they're needed, greatly reducing the amount of remote accesses to memory.

Here are some results showing the improvement that my test case gets
when the MMF_THP_DISABLE flag is clear vs. set:

MMF_THP_DISABLE clear:

# perf stat -a -r 3 ./prctl_wrapper_mmv2 0 ./thp_pthread -C 0 -m 0 -c 512 -b 256g

 Performance counter stats for './prctl_wrapper_mmv2 0 ./thp_pthread -C 0 -m 0 -c 512 -b 256g' (3 runs):

  267537198.932548 task-clock                #  641.115 CPUs utilized            ( +-  0.03% ) [100.00%]
           909,086 context-switches          #    0.000 M/sec                    ( +-  0.07% ) [100.00%]
             1,004 CPU-migrations            #    0.000 M/sec                    ( +-  1.49% ) [100.00%]
           137,942 page-faults               #    0.000 M/sec                    ( +-  1.70% )
350,607,742,932,846 cycles                    #    1.311 GHz                      ( +-  0.03% ) [100.00%]
523,280,989,487,579 stalled-cycles-frontend   #  149.25% frontend cycles idle     ( +-  0.04% ) [100.00%]
395,143,659,263,350 stalled-cycles-backend    #  112.70% backend  cycles idle     ( +-  0.24% ) [100.00%]
147,359,655,811,699 instructions              #    0.42  insns per cycle
                                             #    3.55  stalled cycles per insn  ( +-  0.05% ) [100.00%]
26,897,860,986,646 branches                  #  100.539 M/sec                    ( +-  0.10% ) [100.00%]
     1,264,232,340 branch-misses             #    0.00% of all branches          ( +-  0.65% )

     417.299580464 seconds time elapsed                                          ( +-  0.03% )

MMF_THP_DISABLE set:

# perf stat -a -r 3 ./prctl_wrapper_mmv2 1 ./thp_pthread -C 0 -m 0 -c 512 -b 256g

 Performance counter stats for './prctl_wrapper_mmv2 1 ./thp_pthread -C 0 -m 0 -c 512 -b 256g' (3 runs):

  142442476.218751 task-clock                #  642.085 CPUs utilized            ( +-  0.74% ) [100.00%]
           520,084 context-switches          #    0.000 M/sec                    ( +-  0.79% ) [100.00%]
               853 CPU-migrations            #    0.000 M/sec                    ( +- 14.53% ) [100.00%]
        62,396,741 page-faults               #    0.000 M/sec                    ( +-  0.01% )
155,509,431,078,100 cycles                    #    1.092 GHz                      ( +-  0.75% ) [100.00%]
213,552,817,573,474 stalled-cycles-frontend   #  137.32% frontend cycles idle     ( +-  1.23% ) [100.00%]
117,337,842,556,506 stalled-cycles-backend    #   75.45% backend  cycles idle     ( +-  2.09% ) [100.00%]
178,809,541,860,114 instructions              #    1.15  insns per cycle
                                             #    1.19  stalled cycles per insn  ( +-  0.18% ) [100.00%]
26,295,305,012,722 branches                  #  184.603 M/sec                    ( +-  0.42% ) [100.00%]
       754,391,541 branch-misses             #    0.00% of all branches          ( +-  0.50% )

     221.843813599 seconds time elapsed                                          ( +-  0.75% )

As you can see, this particular test gets about a 2x performance boost
when THP is turned off.  Here's a link to the test, along with the
wrapper that I used:

http://oss.sgi.com/projects/memtests/thp_pthread_mmprctlv2.tar.gz

There are still a few things that might need tweaked here, but I wanted
to get the patch out there to get a discussion started.  Two things I
noted from the old patch discussion that will likely need to be
addressed are:

* Patch doesn't currently account for get_user_pages allocations.  I'm
  actually not sure if this needs to be addressed.  From what I know, get
  user pages calls down to handle_mm_fault, which should prevent THPs
  from being handed out where necessary.  If anybody can confirm that,
  it would be appreciated.
* Current behavior is to have fork()/exec()'d processes inherit the
  flag.  Andrew Morton pointed out some possible issues with this, so we
  may need to rethink this behavior.
  - If parent process has THP disabled, and forks off a child, the child
    will also have THP disabled.  This may not be the desired behavior.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org

---
 include/linux/huge_mm.h    |  6 ++++--
 include/linux/sched.h      |  6 +++++-
 include/uapi/linux/prctl.h |  3 +++
 kernel/sys.c               | 11 +++++++++++
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 91672e2..475f59f 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_HUGE_MM_H
 #define _LINUX_HUGE_MM_H
 
+#include <linux/sched.h>
+
 extern int do_huge_pmd_anonymous_page(struct mm_struct *mm,
 				      struct vm_area_struct *vma,
 				      unsigned long address, pmd_t *pmd,
@@ -74,7 +76,8 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 	   (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&			\
 	   ((__vma)->vm_flags & VM_HUGEPAGE))) &&			\
 	 !((__vma)->vm_flags & VM_NOHUGEPAGE) &&			\
-	 !is_vma_temporary_stack(__vma))
+	 !is_vma_temporary_stack(__vma) &&				\
+	 !test_bit(MMF_THP_DISABLE, &(__vma)->vm_mm->flags))
 #define transparent_hugepage_defrag(__vma)				\
 	((transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)) ||			\
@@ -227,7 +230,6 @@ static inline int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_str
 {
 	return 0;
 }
-
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53f97eb..0ff0c74 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -373,7 +373,11 @@ extern int get_dumpable(struct mm_struct *mm);
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 
-#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
+#define MMF_THP_DISABLE		21	/* disable THP for this mm */
+#define MMF_THP_DISABLE_MASK	(1 << MMF_THP_DISABLE)
+
+#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK | MMF_THP_DISABLE_MASK)
+
 
 struct sighand_struct {
 	atomic_t		count;
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 289760f..58afc04 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -149,4 +149,7 @@
 
 #define PR_GET_TID_ADDRESS	40
 
+#define PR_SET_THP_DISABLE	41
+#define PR_GET_THP_DISABLE	42
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index c723113..097bfaa 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1998,6 +1998,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
 		return current->no_new_privs ? 1 : 0;
+	case PR_SET_THP_DISABLE:
+		if (arg2)
+			set_bit(MMF_THP_DISABLE, &me->mm->flags);
+		else
+			clear_bit(MMF_THP_DISABLE, &me->mm->flags);
+		break;
+	case PR_GET_THP_DISABLE:
+		error = put_user(test_bit(MMF_THP_DISABLE,
+				 &me->mm->flags),
+				 (int __user *) arg2);
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
1.7.12.4

