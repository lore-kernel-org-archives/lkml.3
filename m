Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbaJ1LOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:14:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51365 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbaJ1LOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:14:45 -0400
Date: Tue, 28 Oct 2014 04:14:34 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-b93590901a01a6d036b3b7c856bcc5724fdb9911@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, mingo@kernel.org,
        tglx@linutronix.de, hpa@zytor.com
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        luto@amacapital.net, mingo@kernel.org, hpa@zytor.com
In-Reply-To: <a7ee266773671a05f00b7175ca65a0dd812d2e4b.1411494540.git.luto@amacapital.net>
References: <a7ee266773671a05f00b7175ca65a0dd812d2e4b.1411494540.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86_64/vsyscall:
  Move all of the gate_area code to vsyscall_64.c
Git-Commit-ID: b93590901a01a6d036b3b7c856bcc5724fdb9911
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b93590901a01a6d036b3b7c856bcc5724fdb9911
Gitweb:     http://git.kernel.org/tip/b93590901a01a6d036b3b7c856bcc5724fdb9911
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 23 Sep 2014 10:50:51 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:22:08 +0100

x86_64/vsyscall: Move all of the gate_area code to vsyscall_64.c

This code exists for the sole purpose of making the vsyscall
page look sort of like real userspace memory.  Move it so that
it lives with the rest of the vsyscall code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/a7ee266773671a05f00b7175ca65a0dd812d2e4b.1411494540.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/vsyscall_64.c | 49 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_64.c         | 49 -------------------------------------------
 2 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 957779f..521d5ed 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -284,6 +284,55 @@ sigsegv:
 }
 
 /*
+ * A pseudo VMA to allow ptrace access for the vsyscall page.  This only
+ * covers the 64bit vsyscall page now. 32bit has a real VMA now and does
+ * not need special handling anymore:
+ */
+static const char *gate_vma_name(struct vm_area_struct *vma)
+{
+	return "[vsyscall]";
+}
+static struct vm_operations_struct gate_vma_ops = {
+	.name = gate_vma_name,
+};
+static struct vm_area_struct gate_vma = {
+	.vm_start	= VSYSCALL_ADDR,
+	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
+	.vm_page_prot	= PAGE_READONLY_EXEC,
+	.vm_flags	= VM_READ | VM_EXEC,
+	.vm_ops		= &gate_vma_ops,
+};
+
+struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (!mm || mm->context.ia32_compat)
+		return NULL;
+#endif
+	return &gate_vma;
+}
+
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
+{
+	struct vm_area_struct *vma = get_gate_vma(mm);
+
+	if (!vma)
+		return 0;
+
+	return (addr >= vma->vm_start) && (addr < vma->vm_end);
+}
+
+/*
+ * Use this when you have no reliable mm, typically from interrupt
+ * context. It is less reliable than using a task's mm and may give
+ * false positives.
+ */
+int in_gate_area_no_mm(unsigned long addr)
+{
+	return (addr & PAGE_MASK) == VSYSCALL_ADDR;
+}
+
+/*
  * Assume __initcall executes before all user space. Hopefully kmod
  * doesn't violate that. We'll find out if it does.
  */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4cb8763..dd9ca9b 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1193,55 +1193,6 @@ int kern_addr_valid(unsigned long addr)
 	return pfn_valid(pte_pfn(*pte));
 }
 
-/*
- * A pseudo VMA to allow ptrace access for the vsyscall page.  This only
- * covers the 64bit vsyscall page now. 32bit has a real VMA now and does
- * not need special handling anymore:
- */
-static const char *gate_vma_name(struct vm_area_struct *vma)
-{
-	return "[vsyscall]";
-}
-static struct vm_operations_struct gate_vma_ops = {
-	.name = gate_vma_name,
-};
-static struct vm_area_struct gate_vma = {
-	.vm_start	= VSYSCALL_ADDR,
-	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
-	.vm_page_prot	= PAGE_READONLY_EXEC,
-	.vm_flags	= VM_READ | VM_EXEC,
-	.vm_ops		= &gate_vma_ops,
-};
-
-struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
-{
-#ifdef CONFIG_IA32_EMULATION
-	if (!mm || mm->context.ia32_compat)
-		return NULL;
-#endif
-	return &gate_vma;
-}
-
-int in_gate_area(struct mm_struct *mm, unsigned long addr)
-{
-	struct vm_area_struct *vma = get_gate_vma(mm);
-
-	if (!vma)
-		return 0;
-
-	return (addr >= vma->vm_start) && (addr < vma->vm_end);
-}
-
-/*
- * Use this when you have no reliable mm, typically from interrupt
- * context. It is less reliable than using a task's mm and may give
- * false positives.
- */
-int in_gate_area_no_mm(unsigned long addr)
-{
-	return (addr & PAGE_MASK) == VSYSCALL_ADDR;
-}
-
 static unsigned long probe_memory_block_size(void)
 {
 	/* start from 2g */
