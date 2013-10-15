Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab3JOVEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:04:38 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61735 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181Ab3JOVEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:04:36 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/13] uprobes: allow arch access to xol slot
Date: Tue, 15 Oct 2013 17:04:18 -0400
Message-Id: <1381871068-27660-4-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Allow arches to customize how the instruction is filled into the xol
slot.  ARM will use this to insert an undefined instruction after the
real instruction in order to simulate a single step of the instruction
without hardware support.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: David A. Long <dave.long@linaro.org>
---
 include/linux/uprobes.h |  1 +
 kernel/events/uprobes.c | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 80116c9..2556ab6 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -134,6 +134,7 @@ extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned l
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
 extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs);
+extern void __weak arch_uprobe_xol_copy(struct arch_uprobe *auprobe, void *vaddr);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 3955172..22d0121 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1238,6 +1238,11 @@ static unsigned long xol_take_insn_slot(struct xol_area *area)
 	return slot_addr;
 }
 
+void __weak arch_uprobe_xol_copy(struct arch_uprobe *auprobe, void *vaddr)
+{
+	memcpy(vaddr, auprobe->insn, MAX_UINSN_BYTES);
+}
+
 /*
  * xol_get_insn_slot - allocate a slot for xol.
  * Returns the allocated slot address or 0.
@@ -1246,6 +1251,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 {
 	struct xol_area *area;
 	unsigned long xol_vaddr;
+	void *kaddr;
 
 	area = get_xol_area();
 	if (!area)
@@ -1256,7 +1262,9 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
 		return 0;
 
 	/* Initialize the slot */
-	copy_to_page(area->page, xol_vaddr, uprobe->arch.insn, MAX_UINSN_BYTES);
+	kaddr = kmap_atomic(area->page);
+	arch_uprobe_xol_copy(&uprobe->arch, kaddr + (xol_vaddr & ~PAGE_MASK));
+	kunmap_atomic(kaddr);
 	/*
 	 * We probably need flush_icache_user_range() but it needs vma.
 	 * This should work on supported architectures too.
-- 
1.8.1.2

