Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3HBTqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:46:43 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58102 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755264Ab3HBTqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:46:42 -0400
Date: Fri, 2 Aug 2013 14:46:59 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Add per-process flag to control thp
Message-ID: <20130802194659.GP26476@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Signed-off-by: Robin Holt <holt@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements functionality to allow processes to disable the use of
transparent hugepages through the prctl syscall.

We've determined that some jobs perform significantly better with thp disabled,
and we need a way to control thp on a per-process basis, without relying on
madvise.

---
 include/linux/huge_mm.h    | 14 +++++++++++++-
 include/linux/init_task.h  |  8 ++++++++
 include/linux/sched.h      |  3 +++
 include/uapi/linux/prctl.h |  3 +++
 kernel/fork.c              |  4 ++++
 kernel/sys.c               | 31 +++++++++++++++++++++++++++++++
 6 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b60de92..53af3ca 100644
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
@@ -66,7 +68,7 @@ extern pmd_t *page_check_address_pmd(struct page *page,
 
 extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
-#define transparent_hugepage_enabled(__vma)				\
+#define _transparent_hugepage_enabled(__vma)				\
 	((transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_FLAG) ||				\
 	  (transparent_hugepage_flags &					\
@@ -177,6 +179,11 @@ static inline struct page *compound_trans_head(struct page *page)
 	return page;
 }
 
+static inline int transparent_hugepage_enabled(struct vm_area_struct *vma)
+{
+	return !current->thp_disabled & _transparent_hugepage_enabled(vma);
+}
+
 extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
 
@@ -230,6 +237,11 @@ static inline int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_str
 	return 0;
 }
 
+static inline int transparent_hugepage_enabled(struct vm_area_struct *vma)
+{
+	return _transparent_hugepage_enabled(vma);
+}
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 5cd0f09..aae74fd 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -152,6 +152,13 @@ extern struct task_group root_task_group;
 # define INIT_VTIME(tsk)
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+# define INIT_THP_DISABLED						\
+	.thp_disabled = 0,
+#else
+# define INIT_THP_DISABLED
+#endif
+
 #define INIT_TASK_COMM "swapper"
 
 /*
@@ -222,6 +229,7 @@ extern struct task_group root_task_group;
 	INIT_TASK_RCU_PREEMPT(tsk)					\
 	INIT_CPUSET_SEQ							\
 	INIT_VTIME(tsk)							\
+	INIT_THP_DISABLED						\
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 50d04b9..f084c76 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1406,6 +1406,9 @@ struct task_struct {
 	unsigned int	sequential_io;
 	unsigned int	sequential_io_avg;
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	int thp_disabled;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 289760f..f69780d 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -149,4 +149,7 @@
 
 #define PR_GET_TID_ADDRESS	40
 
+#define PR_SET_THP_DISABLED	41
+#define PR_GET_THP_DISABLED	42
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 403d2bb..0b4afb5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1311,6 +1311,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->sequential_io_avg	= 0;
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	p->thp_disabled = current->thp_disabled;
+#endif
+
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p);
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 771129b..416c8a6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1836,6 +1836,31 @@ static int prctl_get_tid_address(struct task_struct *me, int __user **tid_addr)
 }
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static int prctl_set_thp_disabled(struct task_struct *me)
+{
+	me->thp_disabled = 1;
+	return 0;
+}
+
+static int prctl_get_thp_disabled(struct task_struct *me,
+				  int __user *thp_disabled)
+{
+	return put_user(me->thp_disabled, thp_disabled);
+}
+#else
+static int prctl_set_thp_disabled(struct task_struct *me)
+{
+	return -EINVAL;
+}
+
+static int prctl_get_thp_disabled(struct task_struct *me,
+				  int __user *thp_disabled)
+{
+	return -EINVAL;
+}
+#endif
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -1999,6 +2024,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
 		return current->no_new_privs ? 1 : 0;
+	case PR_SET_THP_DISABLED:
+		error = prctl_set_thp_disabled(me);
+		break;
+	case PR_GET_THP_DISABLED:
+		error = prctl_get_thp_disabled(me, (int __user *) arg2);
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
1.7.12.4

