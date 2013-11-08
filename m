Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab3KHS6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:58:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757775Ab3KHS6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:58:46 -0500
Date: Fri, 8 Nov 2013 20:00:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] uprobes: Add uprobe_task->dup_work/dup_addr
Message-ID: <20131108190003.GA12755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_task->vaddr is a bit strange. First of all it is not really
needed, we can move it into arch_uprobe_task. The generic code uses
it only to pass the additional argument to arch_uprobe_pre_xol(),
and since it is always equal to instruction_pointer() this looks
even more strange.

And both utask->vaddr and and utask->autask have the same scope,
they only have the meaning when the task executes the probed insn
out-of-line. This means it is safe to reuse both in UTASK_RUNNING
state.

OTOH, it is also used by uprobe_copy_process() and dup_xol_work()
for another purpose, this doesn't look clean and doesn't allow to
move this member into arch_uprobe_task.

This patch adds the union with 2 anonymous structs into uprobe_task.

The first struct is autask + vaddr, this way we "almost" move vaddr
into autask.

The second struct has 2 new members for uprobe_copy_process() paths:
->dup_addr which can be used instead ->vaddr, and ->dup_work which
can be used to avoid kmalloc() and simplify the code.

Note that this union will likely have another member(s), we need
something like "private_data_for_handlers" so that the tracing
handlers could use it to communicate with call_fetch() methods.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h |   21 ++++++++++++++++-----
 kernel/events/uprobes.c |   16 ++++------------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 319eae7..366b8b2 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -26,6 +26,7 @@
 
 #include <linux/errno.h>
 #include <linux/rbtree.h>
+#include <linux/types.h>
 
 struct vm_area_struct;
 struct mm_struct;
@@ -72,14 +73,24 @@ enum uprobe_task_state {
  */
 struct uprobe_task {
 	enum uprobe_task_state		state;
-	struct arch_uprobe_task		autask;
 
-	struct return_instance		*return_instances;
-	unsigned int			depth;
-	struct uprobe			*active_uprobe;
+	union {
+		struct {
+			struct arch_uprobe_task	autask;
+			unsigned long		vaddr;
+		};
+
+		struct {
+			struct callback_head	dup_work;
+			unsigned long		dup_addr;
+		};
+	};
 
+	struct uprobe			*active_uprobe;
 	unsigned long			xol_vaddr;
-	unsigned long			vaddr;
+
+	struct return_instance		*return_instances;
+	unsigned int			depth;
 };
 
 /*
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 24b7d6c..2546a7b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1403,12 +1403,10 @@ static void uprobe_warn(struct task_struct *t, const char *msg)
 
 static void dup_xol_work(struct callback_head *work)
 {
-	kfree(work);
-
 	if (current->flags & PF_EXITING)
 		return;
 
-	if (!__create_xol_area(current->utask->vaddr))
+	if (!__create_xol_area(current->utask->dup_addr))
 		uprobe_warn(current, "dup xol area");
 }
 
@@ -1419,7 +1417,6 @@ void uprobe_copy_process(struct task_struct *t, unsigned long flags)
 {
 	struct uprobe_task *utask = current->utask;
 	struct mm_struct *mm = current->mm;
-	struct callback_head *work;
 	struct xol_area *area;
 
 	t->utask = NULL;
@@ -1441,14 +1438,9 @@ void uprobe_copy_process(struct task_struct *t, unsigned long flags)
 	if (mm == t->mm)
 		return;
 
-	/* TODO: move it into the union in uprobe_task */
-	work = kmalloc(sizeof(*work), GFP_KERNEL);
-	if (!work)
-		return uprobe_warn(t, "dup xol area");
-
-	t->utask->vaddr = area->vaddr;
-	init_task_work(work, dup_xol_work);
-	task_work_add(t, work, true);
+	t->utask->dup_addr = area->vaddr;
+	init_task_work(&t->utask->dup_work, dup_xol_work);
+	task_work_add(t, &t->utask->dup_work, true);
 }
 
 /*
-- 
1.5.5.1


