Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3JRP6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:58:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277Ab3JRP6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:58:32 -0400
Date: Fri, 18 Oct 2013 17:50:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] uprobes: Change the callsite of
	uprobe_copy_process()
Message-ID: <20131018155011.GA15023@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018154947.GA15002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation for the next patches.

Move the callsite of uprobe_copy_process() in copy_process() down
to the succesfull return. We do not care if copy_process() fails,
uprobe_free_utask() won't be called in this case so the wrong
->utask != NULL doesn't matter.

OTOH, with this change we know that copy_process() can't fail when
uprobe_copy_process() is called, the new task should either return
to user-mode or call do_exit(). This way uprobe_copy_process() can:

	1. setup p->utask != NULL if necessary

	2. setup uprobes_state.xol_area

	3. use task_work_add(p)

Also, move the definition of uprobe_copy_process() down so that it
can see get_utask().

Cc: stable@vger.kernel.org # 3.9+
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |   16 ++++++++--------
 kernel/fork.c           |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ad8e1bd..db7a1dc 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1345,14 +1345,6 @@ void uprobe_free_utask(struct task_struct *t)
 }
 
 /*
- * Called in context of a new clone/fork from copy_process.
- */
-void uprobe_copy_process(struct task_struct *t)
-{
-	t->utask = NULL;
-}
-
-/*
  * Allocate a uprobe_task object for the task if if necessary.
  * Called when the thread hits a breakpoint.
  *
@@ -1368,6 +1360,14 @@ static struct uprobe_task *get_utask(void)
 }
 
 /*
+ * Called in context of a new clone/fork from copy_process.
+ */
+void uprobe_copy_process(struct task_struct *t)
+{
+	t->utask = NULL;
+}
+
+/*
  * Current area->vaddr notion assume the trampoline address is always
  * equal area->vaddr.
  *
diff --git a/kernel/fork.c b/kernel/fork.c
index 086fe73..d3603b8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1373,7 +1373,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	INIT_LIST_HEAD(&p->pi_state_list);
 	p->pi_state_cache = NULL;
 #endif
-	uprobe_copy_process(p);
 	/*
 	 * sigaltstack should be cleared when sharing the same VM
 	 */
@@ -1490,6 +1489,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	perf_event_fork(p);
 
 	trace_task_newtask(p, clone_flags);
+	uprobe_copy_process(p);
 
 	return p;
 
-- 
1.5.5.1

