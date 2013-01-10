Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3AJXCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:02:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab3AJXCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:02:40 -0500
From: Josh Stone <jistone@redhat.com>
To: oleg@redhat.com, srikar@linux.vnet.ibm.com
Cc: mingo@kernel.org, peterz@infradead.org, anton@redhat.com,
        linux-kernel@vger.kernel.org, Josh Stone <jistone@redhat.com>
Subject: [PATCH] uprobes: Add exports for module use
Date: Thu, 10 Jan 2013 15:01:46 -0800
Message-Id: <1357858906-9711-1-git-send-email-jistone@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original pull message for uprobes (commit 654443e2) noted:

  This tree includes uprobes support in 'perf probe' - but SystemTap
  (and other tools) can take advantage of user probe points as well.

In order to actually be usable in module-based tools like SystemTap, the
interface needs to be exported.  This patch first adds the obvious
exports for uprobe_register and uprobe_unregister.  Then it also adds
one for task_user_regset_view, which is necessary to get the correct
state of userspace registers.

Signed-off-by: Josh Stone <jistone@redhat.com>
---
 kernel/events/uprobes.c | 3 +++
 kernel/ptrace.c         | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index dea7acf..1db8cb6 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -27,6 +27,7 @@
 #include <linux/pagemap.h>	/* read_mapping_page */
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/export.h>
 #include <linux/rmap.h>		/* anon_vma_prepare */
 #include <linux/mmu_notifier.h>	/* set_pte_at_notify */
 #include <linux/swap.h>		/* try_to_free_swap */
@@ -873,6 +874,7 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(uprobe_register);
 
 /*
  * uprobe_unregister - unregister a already registered probe.
@@ -904,6 +906,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 	if (uprobe)
 		put_uprobe(uprobe);
 }
+EXPORT_SYMBOL_GPL(uprobe_unregister);
 
 static struct rb_node *
 find_node_in_range(struct inode *inode, loff_t min, loff_t max)
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1599157..24eee5d 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -673,6 +673,13 @@ static int ptrace_regset(struct task_struct *task, int req, unsigned int type,
 					     kiov->iov_len, kiov->iov_base);
 }
 
+/*
+ * This is declared in linux/regset.h and defined in machine-dependent
+ * code.  We put the export here, near the primary machine-neutral use,
+ * to ensure no machine forgets it.
+ */
+EXPORT_SYMBOL_GPL(task_user_regset_view);
+
 #endif
 
 int ptrace_request(struct task_struct *child, long request,
-- 
1.7.11.7

