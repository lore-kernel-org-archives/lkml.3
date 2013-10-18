Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3JRP6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:58:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493Ab3JRP5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:57:40 -0400
Date: Fri, 18 Oct 2013 17:50:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] uprobes: Change uprobe_copy_process() to dup
	xol_area
Message-ID: <20131018155025.GA15043@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018154947.GA15002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This finally fixes the serious bug in uretprobes: a forked child
crashes if the parent called fork() with the pending ret probe.

Trivial test-case:

	# perf probe -x /lib/libc.so.6 __fork%return
	# perf record -e probe_libc:__fork perl -le 'fork || print "OK"'

(the child doesn't print "OK", it is killed by SIGSEGV)

If the child returns from the probed function it actually returns
to trampoline_vaddr, because it got the copy of parent's stack
mangled by prepare_uretprobe() when the parent entered this func.

It crashes because a) this address is not mapped and b) until the
previous change it doesn't have the proper->return_instances info.

This means that uprobe_copy_process() has to create xol_area which
has the trampoline slot, and its vaddr should be equal to parent's
xol_area->vaddr.

Unfortunately, uprobe_copy_process() can not simply do
__create_xol_area(child, xol_area->vaddr). This could actually work
but perf_event_mmap() doesn't expect the usage of foreign ->mm. So
we offload this to task_work_run(), and pass the argument via not
yet used utask->vaddr.

We know that this vaddr is fine for install_special_mapping(), the
necessary hole was recently "created" by dup_mmap() which skips the
parent's VM_DONTCOPY area, and nobody else could use the new mm.

Unfortunately, this also means that we can not handle the errors
properly, we obviously can not abort the already completed fork().
So we simply print the warning if GFP_KERNEL allocation (the only
possible reason) fails.

Cc: stable@vger.kernel.org # 3.9+
Reported-by: Martin Cermak <mcermak@redhat.com>
Reported-by: David Smith <dsmith@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 67b65c8..098b401 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -35,6 +35,7 @@
 #include <linux/kdebug.h>	/* notifier mechanism */
 #include "../../mm/internal.h"	/* munlock_vma_page */
 #include <linux/percpu-rwsem.h>
+#include <linux/task_work.h>
 
 #include <linux/uprobes.h>
 
@@ -1400,6 +1401,17 @@ static void uprobe_warn(struct task_struct *t, const char *msg)
 			current->comm, current->pid, msg);
 }
 
+static void dup_xol_work(struct callback_head *work)
+{
+	kfree(work);
+
+	if (current->flags & PF_EXITING)
+		return;
+
+	if (!__create_xol_area(current->utask->vaddr))
+		uprobe_warn(current, "dup xol area");
+}
+
 /*
  * Called in context of a new clone/fork from copy_process.
  */
@@ -1407,6 +1419,8 @@ void uprobe_copy_process(struct task_struct *t)
 {
 	struct uprobe_task *utask = current->utask;
 	struct mm_struct *mm = current->mm;
+	struct callback_head *work;
+	struct xol_area *area;
 
 	t->utask = NULL;
 
@@ -1415,6 +1429,20 @@ void uprobe_copy_process(struct task_struct *t)
 
 	if (dup_utask(t, utask))
 		return uprobe_warn(t, "dup ret instances");
+
+	/* The task can fork() after dup_xol_work() fails */
+	area = mm->uprobes_state.xol_area;
+	if (!area)
+		return uprobe_warn(t, "dup xol area");
+
+	/* TODO: move it into the union in uprobe_task */
+	work = kmalloc(sizeof(*work), GFP_KERNEL);
+	if (!work)
+		return uprobe_warn(t, "dup xol area");
+
+	utask->vaddr = area->vaddr;
+	init_task_work(work, dup_xol_work);
+	task_work_add(t, work, true);
 }
 
 /*
-- 
1.5.5.1

