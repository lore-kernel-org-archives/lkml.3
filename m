Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3JRP5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab3JRP5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:57:34 -0400
Date: Fri, 18 Oct 2013 17:50:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] uprobes: Change uprobe_copy_process() to dup
	return_instances
Message-ID: <20131018155022.GA15040@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018154947.GA15002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_copy_process() assumes that the new child doesn't need
->utask, it should be allocated by demand.

But this is not true if the forking task has the pending ret-
probes, the child should report them as well and thus it needs
the copy of parent's ->return_instances chain. Otherwise the
child crashes when it returns from the probed function.

Alternatively we could cleanup the child's stack, but this needs
per-arch changes and this is not what we want. At least systemtap
expects a .return in the child too.

Note: this change alone doesn't fix the problem, see the next
change.

Cc: stable@vger.kernel.org # 3.9+
Reported-by: Martin Cermak <mcermak@redhat.com>
Reported-by: David Smith <dsmith@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c836135..67b65c8 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1366,12 +1366,55 @@ static struct uprobe_task *get_utask(void)
 	return current->utask;
 }
 
+static int dup_utask(struct task_struct *t, struct uprobe_task *o_utask)
+{
+	struct uprobe_task *n_utask;
+	struct return_instance **p, *o, *n;
+
+	n_utask = kzalloc(sizeof(struct uprobe_task), GFP_KERNEL);
+	if (!n_utask)
+		return -ENOMEM;
+	t->utask = n_utask;
+
+	p = &n_utask->return_instances;
+	for (o = o_utask->return_instances; o; o = o->next) {
+		n = kmalloc(sizeof(struct return_instance), GFP_KERNEL);
+		if (!n)
+			return -ENOMEM;
+
+		*n = *o;
+		atomic_inc(&n->uprobe->ref);
+		n->next = NULL;
+
+		*p = n;
+		p = &n->next;
+		n_utask->depth++;
+	}
+
+	return 0;
+}
+
+static void uprobe_warn(struct task_struct *t, const char *msg)
+{
+	pr_warn("uprobe: %s:%d failed to %s\n",
+			current->comm, current->pid, msg);
+}
+
 /*
  * Called in context of a new clone/fork from copy_process.
  */
 void uprobe_copy_process(struct task_struct *t)
 {
+	struct uprobe_task *utask = current->utask;
+	struct mm_struct *mm = current->mm;
+
 	t->utask = NULL;
+
+	if (mm == t->mm || !utask || !utask->return_instances)
+		return;
+
+	if (dup_utask(t, utask))
+		return uprobe_warn(t, "dup ret instances");
 }
 
 /*
-- 
1.5.5.1

