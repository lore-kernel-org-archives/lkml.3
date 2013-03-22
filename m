Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab3CVNLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:11:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab3CVNJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:09:35 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 3/7] uretprobes/x86: hijack return address
Date: Fri, 22 Mar 2013 14:09:00 +0100
Message-Id: <1363957745-6657-4-git-send-email-anton@redhat.com>
In-Reply-To: <1363957745-6657-1-git-send-email-anton@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Hijack the return address and replace it with a trampoline address.

RFCv5 changes:
  - change the fail return code, because orig_ret_vaddr=0 is possible
  - style fixup
RFCv2 changes:
  - remove ->doomed flag, kill task immediately

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 arch/x86/include/asm/uprobes.h |  1 +
 arch/x86/kernel/uprobes.c      | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 8ff8be7..6e51979 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -55,4 +55,5 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 0ba4cfb..05d357e 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -697,3 +697,32 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 		send_sig(SIGTRAP, current, 0);
 	return ret;
 }
+
+unsigned long
+arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
+{
+	int rasize, ncopied;
+	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
+
+	rasize = is_ia32_task() ? 4 : 8;
+	ncopied = copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize);
+	if (unlikely(ncopied))
+		return -1;
+
+	/* check whether address has been already hijacked */
+	if (orig_ret_vaddr == trampoline_vaddr)
+		return orig_ret_vaddr;
+
+	ncopied = copy_to_user((void __user *)regs->sp, &trampoline_vaddr, rasize);
+	if (unlikely(ncopied)) {
+		if (ncopied != rasize) {
+			printk(KERN_ERR "uprobe: return address clobbered: "
+					"pid=%d, %%sp=%#lx, %%ip=%#lx\n",
+					current->pid, regs->sp, regs->ip);
+			/* kill task immediately */
+			send_sig(SIGSEGV, current, 0);
+		}
+	}
+
+	return orig_ret_vaddr;
+}
-- 
1.8.1.4

