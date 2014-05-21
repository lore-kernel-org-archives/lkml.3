Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaEUXW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:22:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43338 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbaEUXWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:22:16 -0400
Date: Wed, 21 May 2014 16:21:58 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-a62c34bd2a8a3f159945becd57401e478818d51c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gorcunov@openvz.org, xemul@parallels.com, luto@amacapital.net,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, xemul@parallels.com, luto@amacapital.net,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <276b39b6b645fb11e345457b503f17b83c2c6fd0.1400538962.git.luto@amacapital.net>
References: <276b39b6b645fb11e345457b503f17b83c2c6fd0.1400538962.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, mm:
  Improve _install_special_mapping and fix x86 vdso naming
Git-Commit-ID: a62c34bd2a8a3f159945becd57401e478818d51c
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

Commit-ID:  a62c34bd2a8a3f159945becd57401e478818d51c
Gitweb:     http://git.kernel.org/tip/a62c34bd2a8a3f159945becd57401e478818d51c
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 19 May 2014 15:58:33 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 May 2014 11:38:42 -0700

x86, mm: Improve _install_special_mapping and fix x86 vdso naming

Using arch_vma_name to give special mappings a name is awkward.  x86
currently implements it by comparing the start address of the vma to
the expected address of the vdso.  This requires tracking the start
address of special mappings and is probably buggy if a special vma
is split or moved.

Improve _install_special_mapping to just name the vma directly.  Use
it to give the x86 vvar area a name, which should make CRIU's life
easier.

As a side effect, the vvar area will show up in core dumps.  This
could be considered weird and is fixable.

[hpa: I say we accept this as-is but be prepared to deal with knocking
 out the vvars from core dumps if this becomes a problem.]

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/276b39b6b645fb11e345457b503f17b83c2c6fd0.1400538962.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/vdso.h  |  6 ++-
 arch/x86/mm/init_64.c        |  3 --
 arch/x86/vdso/vdso2c.h       |  5 ++-
 arch/x86/vdso/vdso32-setup.c |  7 ----
 arch/x86/vdso/vma.c          | 25 ++++++++-----
 include/linux/mm.h           |  4 +-
 include/linux/mm_types.h     |  6 +++
 mm/mmap.c                    | 89 +++++++++++++++++++++++++++++---------------
 8 files changed, 94 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index d0a2c90..30be253 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -7,10 +7,14 @@
 
 #ifndef __ASSEMBLER__
 
+#include <linux/mm_types.h>
+
 struct vdso_image {
 	void *data;
 	unsigned long size;   /* Always a multiple of PAGE_SIZE */
-	struct page **pages;  /* Big enough for data/size page pointers */
+
+	/* text_mapping.pages is big enough for data/size page pointers */
+	struct vm_special_mapping text_mapping;
 
 	unsigned long alt, alt_len;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 6f88184..9deb59b 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1223,9 +1223,6 @@ int in_gate_area_no_mm(unsigned long addr)
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
-	if (vma->vm_mm && vma->vm_start ==
-	    (long __force)vma->vm_mm->context.vdso)
-		return "[vdso]";
 	if (vma == &gate_vma)
 		return "[vsyscall]";
 	return NULL;
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index ed2e894..3dcc61e 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -136,7 +136,10 @@ static int GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	fprintf(outfile, "const struct vdso_image %s = {\n", name);
 	fprintf(outfile, "\t.data = raw_data,\n");
 	fprintf(outfile, "\t.size = %lu,\n", data_size);
-	fprintf(outfile, "\t.pages = pages,\n");
+	fprintf(outfile, "\t.text_mapping = {\n");
+	fprintf(outfile, "\t\t.name = \"[vdso]\",\n");
+	fprintf(outfile, "\t\t.pages = pages,\n");
+	fprintf(outfile, "\t},\n");
 	if (alt_sec) {
 		fprintf(outfile, "\t.alt = %lu,\n",
 			(unsigned long)alt_sec->sh_offset);
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index c3ed708..e4f7781 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -119,13 +119,6 @@ __initcall(ia32_binfmt_init);
 
 #else  /* CONFIG_X86_32 */
 
-const char *arch_vma_name(struct vm_area_struct *vma)
-{
-	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
-		return "[vdso]";
-	return NULL;
-}
-
 struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
 	return NULL;
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 8ad0081..e1513c4 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -30,7 +30,8 @@ void __init init_vdso_image(const struct vdso_image *image)
 
 	BUG_ON(image->size % PAGE_SIZE != 0);
 	for (i = 0; i < npages; i++)
-		image->pages[i] = virt_to_page(image->data + i*PAGE_SIZE);
+		image->text_mapping.pages[i] =
+			virt_to_page(image->data + i*PAGE_SIZE);
 
 	apply_alternatives((struct alt_instr *)(image->data + image->alt),
 			   (struct alt_instr *)(image->data + image->alt +
@@ -91,6 +92,10 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 	unsigned long addr;
 	int ret = 0;
 	static struct page *no_pages[] = {NULL};
+	static struct vm_special_mapping vvar_mapping = {
+		.name = "[vvar]",
+		.pages = no_pages,
+	};
 
 	if (calculate_addr) {
 		addr = vdso_addr(current->mm->start_stack,
@@ -112,21 +117,23 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 	/*
 	 * MAYWRITE to allow gdb to COW and set breakpoints
 	 */
-	ret = install_special_mapping(mm,
-				      addr,
-				      image->size,
-				      VM_READ|VM_EXEC|
-				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-				      image->pages);
+	vma = _install_special_mapping(mm,
+				       addr,
+				       image->size,
+				       VM_READ|VM_EXEC|
+				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
+				       &image->text_mapping);
 
-	if (ret)
+	if (IS_ERR(vma)) {
+		ret = PTR_ERR(vma);
 		goto up_fail;
+	}
 
 	vma = _install_special_mapping(mm,
 				       addr + image->size,
 				       image->sym_end_mapping - image->size,
 				       VM_READ,
-				       no_pages);
+				       &vvar_mapping);
 
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 63f8d4e..05aab09 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1782,7 +1782,9 @@ extern struct file *get_mm_exe_file(struct mm_struct *mm);
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
 extern struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
-				   unsigned long flags, struct page **pages);
+				   unsigned long flags,
+				   const struct vm_special_mapping *spec);
+/* This is an obsolete alternative to _install_special_mapping. */
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 8967e20..22c6f4e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -510,4 +510,10 @@ static inline void clear_tlb_flush_pending(struct mm_struct *mm)
 }
 #endif
 
+struct vm_special_mapping
+{
+	const char *name;
+	struct page **pages;
+};
+
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/mm/mmap.c b/mm/mmap.c
index b1202cf..52bbc95 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2872,6 +2872,31 @@ int may_expand_vm(struct mm_struct *mm, unsigned long npages)
 	return 1;
 }
 
+static int special_mapping_fault(struct vm_area_struct *vma,
+				 struct vm_fault *vmf);
+
+/*
+ * Having a close hook prevents vma merging regardless of flags.
+ */
+static void special_mapping_close(struct vm_area_struct *vma)
+{
+}
+
+static const char *special_mapping_name(struct vm_area_struct *vma)
+{
+	return ((struct vm_special_mapping *)vma->vm_private_data)->name;
+}
+
+static const struct vm_operations_struct special_mapping_vmops = {
+	.close = special_mapping_close,
+	.fault = special_mapping_fault,
+	.name = special_mapping_name,
+};
+
+static const struct vm_operations_struct legacy_special_mapping_vmops = {
+	.close = special_mapping_close,
+	.fault = special_mapping_fault,
+};
 
 static int special_mapping_fault(struct vm_area_struct *vma,
 				struct vm_fault *vmf)
@@ -2887,7 +2912,13 @@ static int special_mapping_fault(struct vm_area_struct *vma,
 	 */
 	pgoff = vmf->pgoff - vma->vm_pgoff;
 
-	for (pages = vma->vm_private_data; pgoff && *pages; ++pages)
+	if (vma->vm_ops == &legacy_special_mapping_vmops)
+		pages = vma->vm_private_data;
+	else
+		pages = ((struct vm_special_mapping *)vma->vm_private_data)->
+			pages;
+
+	for (; pgoff && *pages; ++pages)
 		pgoff--;
 
 	if (*pages) {
@@ -2900,30 +2931,11 @@ static int special_mapping_fault(struct vm_area_struct *vma,
 	return VM_FAULT_SIGBUS;
 }
 
-/*
- * Having a close hook prevents vma merging regardless of flags.
- */
-static void special_mapping_close(struct vm_area_struct *vma)
-{
-}
-
-static const struct vm_operations_struct special_mapping_vmops = {
-	.close = special_mapping_close,
-	.fault = special_mapping_fault,
-};
-
-/*
- * Called with mm->mmap_sem held for writing.
- * Insert a new vma covering the given region, with the given flags.
- * Its pages are supplied by the given array of struct page *.
- * The array can be shorter than len >> PAGE_SHIFT if it's null-terminated.
- * The region past the last page supplied will always produce SIGBUS.
- * The array pointer and the pages it points to are assumed to stay alive
- * for as long as this mapping might exist.
- */
-struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
-			    unsigned long addr, unsigned long len,
-			    unsigned long vm_flags, struct page **pages)
+static struct vm_area_struct *__install_special_mapping(
+	struct mm_struct *mm,
+	unsigned long addr, unsigned long len,
+	unsigned long vm_flags, const struct vm_operations_struct *ops,
+	void *priv)
 {
 	int ret;
 	struct vm_area_struct *vma;
@@ -2940,8 +2952,8 @@ struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
 	vma->vm_flags = vm_flags | mm->def_flags | VM_DONTEXPAND | VM_SOFTDIRTY;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
-	vma->vm_ops = &special_mapping_vmops;
-	vma->vm_private_data = pages;
+	vma->vm_ops = ops;
+	vma->vm_private_data = priv;
 
 	ret = insert_vm_struct(mm, vma);
 	if (ret)
@@ -2958,12 +2970,31 @@ out:
 	return ERR_PTR(ret);
 }
 
+/*
+ * Called with mm->mmap_sem held for writing.
+ * Insert a new vma covering the given region, with the given flags.
+ * Its pages are supplied by the given array of struct page *.
+ * The array can be shorter than len >> PAGE_SHIFT if it's null-terminated.
+ * The region past the last page supplied will always produce SIGBUS.
+ * The array pointer and the pages it points to are assumed to stay alive
+ * for as long as this mapping might exist.
+ */
+struct vm_area_struct *_install_special_mapping(
+	struct mm_struct *mm,
+	unsigned long addr, unsigned long len,
+	unsigned long vm_flags, const struct vm_special_mapping *spec)
+{
+	return __install_special_mapping(mm, addr, len, vm_flags,
+					 &special_mapping_vmops, (void *)spec);
+}
+
 int install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
-	struct vm_area_struct *vma = _install_special_mapping(mm,
-			    addr, len, vm_flags, pages);
+	struct vm_area_struct *vma = __install_special_mapping(
+		mm, addr, len, vm_flags, &legacy_special_mapping_vmops,
+		(void *)pages);
 
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
