Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717Ab3JOVEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:04:42 -0400
Received: from mail-qe0-f47.google.com ([209.85.128.47]:53460 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933674Ab3JOVEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:04:38 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/13] uprobes: add arch write opcode hook
Date: Tue, 15 Oct 2013 17:04:20 -0400
Message-Id: <1381871068-27660-6-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin@rab.in>

Allow arches to write the opcode with a custom function.  ARM needs to
customize the swbp instruction depending on the condition code of the
instruction it replaces.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: David A. Long <dave.long@linaro.org>
---
 include/linux/uprobes.h |  3 +++
 kernel/events/uprobes.c | 21 ++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index a28dcbe..34375da 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -136,6 +136,9 @@ extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_
 extern bool __weak arch_uprobe_ignore(struct arch_uprobe *aup, struct pt_regs *regs);
 extern void __weak arch_uprobe_xol_copy(struct arch_uprobe *auprobe, void *vaddr);
 extern int __weak arch_uprobes_init(void);
+extern void __weak arch_uprobe_write_opcode(struct arch_uprobe *auprobe,
+					    void *vaddr,
+					    uprobe_opcode_t opcode);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 9734a5f..cb01d82 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -248,6 +248,12 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
  * have fixed length instructions.
  */
 
+void __weak arch_uprobe_write_opcode(struct arch_uprobe *auprobe, void *vaddr,
+				     uprobe_opcode_t opcode)
+{
+	memcpy(vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
+}
+
 /*
  * write_opcode - write the opcode at a given virtual address.
  * @mm: the probed process address space.
@@ -260,11 +266,12 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
  * For mm @mm, write the opcode at @vaddr.
  * Return 0 (success) or a negative errno.
  */
-static int write_opcode(struct mm_struct *mm, unsigned long vaddr,
-			uprobe_opcode_t opcode)
+static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
+			unsigned long vaddr, uprobe_opcode_t opcode)
 {
 	struct page *old_page, *new_page;
 	struct vm_area_struct *vma;
+	void *vaddr_new;
 	int ret;
 
 retry:
@@ -285,7 +292,10 @@ retry:
 	__SetPageUptodate(new_page);
 
 	copy_highpage(new_page, old_page);
-	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
+	vaddr_new = kmap_atomic(new_page);
+	arch_uprobe_write_opcode(auprobe, vaddr_new + (vaddr & ~PAGE_MASK),
+				 opcode);
+	kunmap_atomic(vaddr_new);
 
 	ret = anon_vma_prepare(vma);
 	if (ret)
@@ -314,7 +324,7 @@ put_old:
  */
 int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	return write_opcode(mm, vaddr, UPROBE_SWBP_INSN);
+	return write_opcode(auprobe, mm, vaddr, UPROBE_SWBP_INSN);
 }
 
 /**
@@ -329,7 +339,8 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
 int __weak
 set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	return write_opcode(mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
+	return write_opcode(auprobe, mm, vaddr,
+			    *(uprobe_opcode_t *)auprobe->insn);
 }
 
 static int match_uprobe(struct uprobe *l, struct uprobe *r)
-- 
1.8.1.2

