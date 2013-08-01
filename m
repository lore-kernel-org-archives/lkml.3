Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab3HAXrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:47:12 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:62911 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818Ab3HAXqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:46:01 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] uprobes: allow arch-specific initialization
Date: Thu,  1 Aug 2013 19:45:48 -0400
Message-Id: <1375400753-3454-5-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
References: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin@rab.in>

Add a weak function for any architecture-specific initialization.  ARM
will use this to register the handlers for the undefined instructions it
uses to implement uprobes.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: David A. Long <dave.long@linaro.org>
---
 include/linux/uprobes.h |  1 +
 kernel/events/uprobes.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index f6287f0..6feae5d 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -135,6 +135,7 @@ extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned l
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs);
 extern void __weak arch_uprobe_xol_copy(struct arch_uprobe *auprobe, void *vaddr);
+extern int __weak arch_uprobes_init(void);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 64471bd..5004f6f 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1862,8 +1862,14 @@ static struct notifier_block uprobe_exception_nb = {
 	.priority		= INT_MAX-1,	/* notified after kprobes, kgdb */
 };
 
+int __weak __init arch_uprobes_init(void)
+{
+	return 0;
+}
+
 static int __init init_uprobes(void)
 {
+	int ret;
 	int i;
 
 	for (i = 0; i < UPROBES_HASH_SZ; i++)
@@ -1872,6 +1878,10 @@ static int __init init_uprobes(void)
 	if (percpu_init_rwsem(&dup_mmap_sem))
 		return -ENOMEM;
 
+	ret = arch_uprobes_init();
+	if (ret)
+		return ret;
+
 	return register_die_notifier(&uprobe_exception_nb);
 }
 module_init(init_uprobes);
-- 
1.8.1.2

