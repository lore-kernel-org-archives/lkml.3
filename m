Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaEVWYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:24:25 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58077 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEVWYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:24:22 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/3] x86_64,vsyscall: Move all of the gate_area code to vsyscall_64.c
Date: Thu, 22 May 2014 15:24:14 -0700
Message-Id: <8760101d36049c65129c5ad76a6781184f8ddccd.1400797362.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1400797362.git.luto@amacapital.net>
References: <cover.1400797362.git.luto@amacapital.net>
In-Reply-To: <cover.1400797362.git.luto@amacapital.net>
References: <cover.1400797362.git.luto@amacapital.net>
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
index ea5b570..ad84894 100644
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
index bdcde58..1390b7b 100644
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
 #ifdef CONFIG_X86_UV
 unsigned long memory_block_size_bytes(void)
 {
-- 
1.9.0

