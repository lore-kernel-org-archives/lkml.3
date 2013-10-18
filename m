Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab3JRP5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:57:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab3JRP5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:57:40 -0400
Date: Fri, 18 Oct 2013 17:50:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] uprobes: Teach uprobe_copy_process() to handle
	CLONE_VFORK
Message-ID: <20131018155028.GA15050@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018154947.GA15002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_copy_process() does nothing if the child shares ->mm with
the forking process, but there is a special case: CLONE_VFORK.
In this case it would be more correct to do dup_utask() but avoid
dup_xol(). This is not that important, the child should not unwind
its stack too much, this can corrupt the parent's stack, but at
least we need this to allow to ret-probe __vfork() itself.

Note: in theory, it would be better to check task_pt_regs(p)->sp
instead of CLONE_VFORK, we need to dup_utask() if and only if the
child can return from the function called by the parent. But this
needs the arch-dependant helper, and I think that nobody actually
does clone(same_stack, CLONE_VM).

Cc: stable@vger.kernel.org # 3.9+
Reported-by: Martin Cermak <mcermak@redhat.com>
Reported-by: David Smith <dsmith@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h |    4 ++--
 kernel/events/uprobes.c |   10 ++++++++--
 kernel/fork.c           |    2 +-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 06f28be..13a7f13 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -117,7 +117,7 @@ extern void uprobe_start_dup_mmap(void);
 extern void uprobe_end_dup_mmap(void);
 extern void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm);
 extern void uprobe_free_utask(struct task_struct *t);
-extern void uprobe_copy_process(struct task_struct *t);
+extern void uprobe_copy_process(struct task_struct *t, unsigned long flags);
 extern unsigned long __weak uprobe_get_swbp_addr(struct pt_regs *regs);
 extern int uprobe_post_sstep_notifier(struct pt_regs *regs);
 extern int uprobe_pre_sstep_notifier(struct pt_regs *regs);
@@ -174,7 +174,7 @@ static inline unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
 static inline void uprobe_free_utask(struct task_struct *t)
 {
 }
-static inline void uprobe_copy_process(struct task_struct *t)
+static inline void uprobe_copy_process(struct task_struct *t, unsigned long flags)
 {
 }
 static inline void uprobe_clear_state(struct mm_struct *mm)
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 098b401..78cf8a4 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1415,7 +1415,7 @@ static void dup_xol_work(struct callback_head *work)
 /*
  * Called in context of a new clone/fork from copy_process.
  */
-void uprobe_copy_process(struct task_struct *t)
+void uprobe_copy_process(struct task_struct *t, unsigned long flags)
 {
 	struct uprobe_task *utask = current->utask;
 	struct mm_struct *mm = current->mm;
@@ -1424,7 +1424,10 @@ void uprobe_copy_process(struct task_struct *t)
 
 	t->utask = NULL;
 
-	if (mm == t->mm || !utask || !utask->return_instances)
+	if (!utask || !utask->return_instances)
+		return;
+
+	if (mm == t->mm && !(flags & CLONE_VFORK))
 		return;
 
 	if (dup_utask(t, utask))
@@ -1435,6 +1438,9 @@ void uprobe_copy_process(struct task_struct *t)
 	if (!area)
 		return uprobe_warn(t, "dup xol area");
 
+	if (mm == t->mm)
+		return;
+
 	/* TODO: move it into the union in uprobe_task */
 	work = kmalloc(sizeof(*work), GFP_KERNEL);
 	if (!work)
diff --git a/kernel/fork.c b/kernel/fork.c
index d3603b8..8531609 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1489,7 +1489,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	perf_event_fork(p);
 
 	trace_task_newtask(p, clone_flags);
-	uprobe_copy_process(p);
+	uprobe_copy_process(p, clone_flags);
 
 	return p;
 
-- 
1.5.5.1

