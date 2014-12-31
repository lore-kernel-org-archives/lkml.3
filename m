Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaLaPWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:22:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbaLaPWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:22:48 -0500
From: Pratyush Anand <panand@redhat.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com, oleg@redhat.com,
        Pratyush Anand <panand@redhat.com>
Subject: [RFC 3/8] Kernel/uprobe: Define arch_uprobe_exception_notify as __weak
Date: Wed, 31 Dec 2014 20:51:19 +0530
Message-Id: <c40bb09f1edad6899c3855eb56bf4a4f541c49f7.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both ARM and ARM64 handle uprobe exceptions through their own hooks.So
nothing to be done in arch_uprobe_exception_notify except to return
NOTIFY_DONE. Implement this as weak default function and remove
definition from arm arch code.

Signed-off-by: Pratyush Anand <panand@redhat.com>
---
 arch/arm/kernel/uprobes.c |  6 ------
 kernel/events/uprobes.c   | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/uprobes.c b/arch/arm/kernel/uprobes.c
index 56adf9c1fde0..0f3663ca82fc 100644
--- a/arch/arm/kernel/uprobes.c
+++ b/arch/arm/kernel/uprobes.c
@@ -178,12 +178,6 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	instruction_pointer_set(regs, utask->vaddr);
 }
 
-int arch_uprobe_exception_notify(struct notifier_block *self,
-				 unsigned long val, void *data)
-{
-	return NOTIFY_DONE;
-}
-
 static int uprobe_trap_handler(struct pt_regs *regs, unsigned int instr)
 {
 	unsigned long flags;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index cb346f26a22d..027e39ccb778 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1973,6 +1973,24 @@ int uprobe_post_sstep_notifier(struct pt_regs *regs)
 	return 1;
 }
 
+/**
+ * arch_uprobe_exception_notify - Pass uprobe exception notigfication to
+ * architecture
+ * @self: Pointer to notifier_block
+ * @val: Type of exception
+ * @data: Exception specific data
+ * Default implementation of arch_uprobe_exception_notify
+ * Returns NOTIFY_DONE.
+ *
+ * Few architectures like arm and arm64 handle uprobe exceptions through
+ * their own hooks.So nothing to be done here.
+ */
+int __weak arch_uprobe_exception_notify(struct notifier_block *self,
+				 unsigned long val, void *data)
+{
+	return NOTIFY_DONE;
+}
+
 static struct notifier_block uprobe_exception_nb = {
 	.notifier_call		= arch_uprobe_exception_notify,
 	.priority		= INT_MAX-1,	/* notified after kprobes, kgdb */
-- 
2.1.0

