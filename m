Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbaF3Vxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:53:43 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56998 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbaF3Vxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:53:35 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, hpa@zytor.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 02/10] x86_64,vsyscall: Move all of the gate_area code to vsyscall_64.c
Date: Mon, 30 Jun 2014 14:53:13 -0700
Message-Id: <974d645d7f278a692bc061efcf0e5a12aff85a95.1404164803.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code exists for the sole purpose of making the vsyscall page
look sort of like real userspace memory.  Move it so that it lives
with the rest of the vsyscall code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/vsyscall_64.c | 49 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_64.c         | 49 -------------------------------------------
 2 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index e1e1e80..420c468 100644
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
index df1a992..417ea05 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1180,55 +1180,6 @@ int kern_addr_valid(unsigned long addr)
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
-- 
1.9.3

