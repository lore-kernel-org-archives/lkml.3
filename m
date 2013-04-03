Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762597Ab3DCQC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:02:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759408Ab3DCQCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:02:25 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH v1 7/9] uretprobes: Limit the depth of return probe nestedness
Date: Wed,  3 Apr 2013 18:00:37 +0200
Message-Id: <1365004839-21982-8-git-send-email-anton@redhat.com>
In-Reply-To: <1365004839-21982-1-git-send-email-anton@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the kretprobes we can't trust userspace, thus must have
protection from user space attacks. User-space have  "unlimited"
stack, and this patch limits the return probes nestedness as a
simple remedy for it.

Note that this implementation leaks return_instance on siglongjmp
until exit()/exec().

The intention is to have KISS and bare minimum solution for the
initial implementation in order to not complicate the uretprobes
code.

In the future we may come up with more sophisticated solution that
remove this depth limitation. It is not easy task and lays beyond
this patchset.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h |  3 +++
 kernel/events/uprobes.c | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 5f8960e..d7bcf10 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -38,6 +38,8 @@ struct inode;
 #define UPROBE_HANDLER_REMOVE		1
 #define UPROBE_HANDLER_MASK		1
 
+#define MAX_URETPROBE_DEPTH		64
+
 enum uprobe_filter_ctx {
 	UPROBE_FILTER_REGISTER,
 	UPROBE_FILTER_UNREGISTER,
@@ -72,6 +74,7 @@ struct uprobe_task {
 	struct arch_uprobe_task		autask;
 
 	struct return_instance		*return_instances;
+	unsigned int			depth;
 	struct uprobe			*active_uprobe;
 
 	unsigned long			xol_vaddr;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index d129c1d..489f5e3 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1381,6 +1381,13 @@ static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
 	if (!utask)
 		return;
 
+	if (utask->depth >= MAX_URETPROBE_DEPTH) {
+		printk_ratelimited(KERN_INFO "uprobe: omit uretprobe due to"
+				" nestedness limit pid/tgid=%d/%d\n",
+				current->pid, current->tgid);
+		return;
+	}
+
 	ri = kzalloc(sizeof(struct return_instance), GFP_KERNEL);
 	if (!ri)
 		goto fail;
@@ -1416,6 +1423,8 @@ static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
 	ri->orig_ret_vaddr = orig_ret_vaddr;
 	ri->chained = chained;
 
+	utask->depth++;
+
 	/* add instance to the stack */
 	ri->next = utask->return_instances;
 	utask->return_instances = ri;
@@ -1652,6 +1661,8 @@ static bool handler_uretprobe(struct pt_regs *regs)
 		if (!chained)
 			break;
 
+		utask->depth--;
+
 		BUG_ON(!ri);
 	}
 
-- 
1.8.1.4

