Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444Ab3DCQBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:01:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762254Ab3DCQBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:01:44 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH v1 4/9] uretprobes/ppc: Hijack return address
Date: Wed,  3 Apr 2013 18:00:34 +0200
Message-Id: <1365004839-21982-5-git-send-email-anton@redhat.com>
In-Reply-To: <1365004839-21982-1-git-send-email-anton@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hijack the return address and replace it with a trampoline address.
PowerPC implementation.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 arch/powerpc/include/asm/uprobes.h |  1 +
 arch/powerpc/kernel/uprobes.c      | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
index b532060..2301602 100644
--- a/arch/powerpc/include/asm/uprobes.h
+++ b/arch/powerpc/include/asm/uprobes.h
@@ -51,4 +51,5 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
index bc77834..567b975 100644
--- a/arch/powerpc/kernel/uprobes.c
+++ b/arch/powerpc/kernel/uprobes.c
@@ -188,3 +188,16 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 	return false;
 }
+
+unsigned long
+arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
+{
+	unsigned long orig_ret_vaddr;
+
+	orig_ret_vaddr = regs->link;
+
+	/* Replace the return addr with trampoline addr */
+	regs->link = trampoline_vaddr;
+
+	return orig_ret_vaddr;
+}
-- 
1.8.1.4

