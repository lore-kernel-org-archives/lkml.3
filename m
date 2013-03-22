Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3CVNKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:10:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab3CVNJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:09:51 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 6/7] uretprobes: limit the depth of return probe nestedness
Date: Fri, 22 Mar 2013 14:09:03 +0100
Message-Id: <1363957745-6657-7-git-send-email-anton@redhat.com>
In-Reply-To: <1363957745-6657-1-git-send-email-anton@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Unlike the kretprobes we can't trust userspace, thus must have
protection from user space attacks, this patch limits the return
probes nestedness as a simple remedy for it.
  The intention is to have KISS and bare minimum solution for the
initial implementation in order to not complicate the uretprobes
code.

  In the future we may come up with more sophisticated solution that
should remove this depth limitation, however it is not easy task
and lays beyond this patchset. It should consider things like: breakpoint
address lays outside the stack and stack growth direction, longjmp,
sigaltstack... be able to clean up return instances.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h |  3 +++
 kernel/events/uprobes.c | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 145d466..928d72f 100644
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
@@ -70,6 +72,7 @@ struct uprobe_task {
 	struct arch_uprobe_task		autask;
 
 	struct return_instance		*return_instances;
+	unsigned int			depth;
 	struct uprobe			*active_uprobe;
 
 	unsigned long			xol_vaddr;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 91edd2c..5fb7809 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1392,6 +1392,13 @@ static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
 	if (!utask)
 		return;
 
+	if (utask->depth >= MAX_URETPROBE_DEPTH) {
+		printk_ratelimited(KERN_INFO "urpobe: reached the return probe"
+				" depth limit pid/tgid=%d/%d\n", current->pid,
+				current->tgid);
+		return;
+	}
+
 	prev_ret_vaddr = -1;
 	if (utask->return_instances)
 		prev_ret_vaddr = utask->return_instances->orig_ret_vaddr;
@@ -1431,6 +1438,8 @@ static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
 		ri->uprobe = uprobe;
 		ri->orig_ret_vaddr = ret_vaddr;
 
+		utask->depth++;
+
 		/* add instance to the stack */
 		ri->next = utask->return_instances;
 		utask->return_instances = ri;
@@ -1661,6 +1670,8 @@ static void handle_uretprobe(struct xol_area *area, struct pt_regs *regs)
 		ri = ri->next;
 		kfree(tmp);
 
+		utask->depth--;
+
 		if (!ri || ri->dirty == false) {
 			/*
 			 * This is the first return uprobe (chronologically)
-- 
1.8.1.4

