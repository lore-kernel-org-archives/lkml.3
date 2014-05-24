Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaEXHDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:03:20 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35147 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaEXHC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:26 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 19/24] ARM64: Add vdso for ILP32 and use it for the signal return.
Date: Sat, 24 May 2014 00:02:14 -0700
Message-Id: <1400914939-9708-20-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the VDSO for ILP32. We need to use a different VDSO than LP64 since ILP32 uses ELF32 while LP64 uses ELF64.

After this patch, signal handling works mostly.  In that signals go through their action and then returned correctly.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/vdso.h                 |    4 +
 arch/arm64/kernel/Makefile                    |    5 +
 arch/arm64/kernel/signal.c                    |    4 +
 arch/arm64/kernel/vdso-ilp32/.gitignore       |    2 +
 arch/arm64/kernel/vdso-ilp32/Makefile         |   72 ++++++++++++++++++
 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S     |   33 ++++++++
 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S |  100 +++++++++++++++++++++++++
 arch/arm64/kernel/vdso.c                      |   53 +++++++++++--
 8 files changed, 266 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm64/kernel/vdso-ilp32/.gitignore
 create mode 100644 arch/arm64/kernel/vdso-ilp32/Makefile
 create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S
 create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S

diff --git a/arch/arm64/include/asm/vdso.h b/arch/arm64/include/asm/vdso.h
index 839ce00..84050c6 100644
--- a/arch/arm64/include/asm/vdso.h
+++ b/arch/arm64/include/asm/vdso.h
@@ -29,6 +29,10 @@
 
 #include <generated/vdso-offsets.h>
 
+#ifdef CONFIG_ARM64_ILP32
+#include <generated/vdso-ilp32-offsets.h>
+#endif
+
 #define VDSO_SYMBOL(base, name)						   \
 ({									   \
 	(void *)(vdso_offset_##name - VDSO_LBASE + (unsigned long)(base)); \
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 00c0da4..986962d 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -24,6 +24,7 @@ arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
 
 obj-y					+= $(arm64-obj-y) vdso/
+obj-$(CONFIG_ARM64_ILP32)		+= vdso-ilp32/
 obj-m					+= $(arm64-obj-m)
 head-y					:= head.o
 extra-y					:= $(head-y) vmlinux.lds
@@ -31,3 +32,7 @@ extra-y					:= $(head-y) vmlinux.lds
 # vDSO - this must be built first to generate the symbol offsets
 $(call objectify,$(arm64-obj-y)): $(obj)/vdso/vdso-offsets.h
 $(obj)/vdso/vdso-offsets.h: $(obj)/vdso
+
+# vDSO - this must be built first to generate the symbol offsets
+$(call objectify,$(arm64-obj-y)): $(obj)/vdso-ilp32/vdso-ilp32-offsets.h
+$(obj)/vdso-ilp32/vdso-ilp32-offsets.h: $(obj)/vdso-ilp32
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 8168613..fd49b58 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -233,6 +233,10 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 
 	if (ka->sa.sa_flags & SA_RESTORER)
 		sigtramp = ka->sa.sa_restorer;
+#ifdef CONFIG_ARM64_ILP32
+	else if (is_ilp32_compat_task())
+		sigtramp = VDSO_SYMBOL(current->mm->context.vdso, sigtramp_ilp32);
+#endif
 	else
 		sigtramp = VDSO_SYMBOL(current->mm->context.vdso, sigtramp);
 
diff --git a/arch/arm64/kernel/vdso-ilp32/.gitignore b/arch/arm64/kernel/vdso-ilp32/.gitignore
new file mode 100644
index 0000000..61806c3
--- /dev/null
+++ b/arch/arm64/kernel/vdso-ilp32/.gitignore
@@ -0,0 +1,2 @@
+vdso-ilp32.lds
+vdso-ilp32-offsets.h
diff --git a/arch/arm64/kernel/vdso-ilp32/Makefile b/arch/arm64/kernel/vdso-ilp32/Makefile
new file mode 100644
index 0000000..c8f5472
--- /dev/null
+++ b/arch/arm64/kernel/vdso-ilp32/Makefile
@@ -0,0 +1,72 @@
+#
+# Building a vDSO image for AArch64.
+#
+# Author: Will Deacon <will.deacon@arm.com>
+# Heavily based on the vDSO Makefiles for other archs.
+#
+
+obj-ilp32-vdso := gettimeofday-ilp32.o note-ilp32.o sigreturn-ilp32.o
+
+# Build rules
+targets := $(obj-ilp32-vdso) vdso-ilp32.so vdso-ilp32.so.dbg
+obj-ilp32-vdso := $(addprefix $(obj)/, $(obj-ilp32-vdso))
+
+ccflags-y := -shared -fno-common -fno-builtin
+ccflags-y += -nostdlib -Wl,-soname=linux-ilp32-vdso.so.1 \
+		$(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
+
+obj-y += vdso-ilp32.o
+extra-y += vdso-ilp32.lds vdso-ilp32-offsets.h
+CPPFLAGS_vdso-ilp32.lds += -P -C -U$(ARCH) -mabi=ilp32
+
+# Force dependency (incbin is bad)
+$(obj)/vdso-ilp32.o : $(obj)/vdso-ilp32.so
+
+# Link rule for the .so file, .lds has to be first
+$(obj)/vdso-ilp32.so.dbg: $(src)/vdso-ilp32.lds $(obj-ilp32-vdso)
+	$(call if_changed,vdso-ilp32ld)
+
+# Strip rule for the .so file
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg FORCE
+	$(call if_changed,objcopy)
+
+# Generate VDSO offsets using helper script
+gen-vdsosym := $(srctree)/$(src)/../vdso/gen_vdso_offsets.sh
+quiet_cmd_vdsosym = VDSOSYM $@
+define cmd_vdsosym
+	$(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@ && \
+	cp $@ include/generated/
+endef
+
+$(obj)/vdso-ilp32-offsets.h: $(obj)/vdso-ilp32.so.dbg FORCE
+	$(call if_changed,vdsosym)
+
+# Assembly rules for the .S files
+#$(obj-ilp32-vdso): %.o: $(src)/../vdso/$(subst -ilp32,,%.S)
+#	$(call if_changed_dep,vdso-ilp32as)
+
+$(obj)/gettimeofday-ilp32.o: $(src)/../vdso/gettimeofday.S
+	$(call if_changed_dep,vdso-ilp32as)
+
+$(obj)/note-ilp32.o: $(src)/../vdso/note.S
+	$(call if_changed_dep,vdso-ilp32as)
+
+$(obj)/sigreturn-ilp32.o: $(src)/../vdso/sigreturn.S
+	$(call if_changed_dep,vdso-ilp32as)
+
+# Actual build commands
+quiet_cmd_vdso-ilp32ld = VDSOILP32L $@
+      cmd_vdso-ilp32ld = $(CC) $(c_flags) -mabi=ilp32  -Wl,-n -Wl,-T $^ -o $@
+quiet_cmd_vdso-ilp32as = VDSOILP32A $@
+      cmd_vdso-ilp32as = $(CC) $(a_flags) -mabi=ilp32 -c -o $@ $<
+
+# Install commands for the unstripped file
+quiet_cmd_vdso_install = INSTALL $@
+      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
+
+vdso-ilp32.so: $(obj)/vdso-ilp32.so.dbg
+	@mkdir -p $(MODLIB)/vdso
+	$(call cmd,vdso_install)
+
+vdso_install: vdso-ilp32.so
diff --git a/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S b/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S
new file mode 100644
index 0000000..46ac072
--- /dev/null
+++ b/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <linux/const.h>
+#include <asm/page.h>
+
+	__PAGE_ALIGNED_DATA
+
+	.globl vdso_ilp32_start, vdso_ilp32_end
+	.balign PAGE_SIZE
+vdso_ilp32_start:
+	.incbin "arch/arm64/kernel/vdso-ilp32/vdso-ilp32.so"
+	.balign PAGE_SIZE
+vdso_ilp32_end:
+
+	.previous
diff --git a/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S b/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S
new file mode 100644
index 0000000..345d816
--- /dev/null
+++ b/arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S
@@ -0,0 +1,100 @@
+/*
+ * GNU linker script for the VDSO library.
+ *
+ * Copyright (C) 2012 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ * Heavily based on the vDSO linker scripts for other archs.
+ */
+
+#include <linux/const.h>
+#include <asm/page.h>
+#include <asm/vdso.h>
+
+/*OUTPUT_FORMAT("elf32-littleaarch64", "elf32-bigaarch64", "elf32-littleaarch64")
+OUTPUT_ARCH(aarch64)
+*/
+SECTIONS
+{
+	. = VDSO_LBASE + SIZEOF_HEADERS;
+
+	.hash		: { *(.hash) }			:text
+	.gnu.hash	: { *(.gnu.hash) }
+	.dynsym		: { *(.dynsym) }
+	.dynstr		: { *(.dynstr) }
+	.gnu.version	: { *(.gnu.version) }
+	.gnu.version_d	: { *(.gnu.version_d) }
+	.gnu.version_r	: { *(.gnu.version_r) }
+
+	.note		: { *(.note.*) }		:text	:note
+
+	. = ALIGN(16);
+
+	.text		: { *(.text*) }			:text	=0xd503201f
+	PROVIDE (__etext = .);
+	PROVIDE (_etext = .);
+	PROVIDE (etext = .);
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+
+	.rodata		: { *(.rodata*) }		:text
+
+	_end = .;
+	PROVIDE(end = .);
+
+	. = ALIGN(PAGE_SIZE);
+	PROVIDE(_vdso_data = .);
+
+	/DISCARD/	: {
+		*(.note.GNU-stack)
+		*(.data .data.* .gnu.linkonce.d.* .sdata*)
+		*(.bss .sbss .dynbss .dynsbss)
+	}
+}
+
+/*
+ * We must supply the ELF program headers explicitly to get just one
+ * PT_LOAD segment, and set the flags explicitly to make segments read-only.
+ */
+PHDRS
+{
+	text		PT_LOAD		FLAGS(5) FILEHDR PHDRS; /* PF_R|PF_X */
+	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
+	note		PT_NOTE		FLAGS(4);		/* PF_R */
+	eh_frame_hdr	PT_GNU_EH_FRAME;
+}
+
+/*
+ * This controls what symbols we export from the DSO.
+ */
+VERSION
+{
+	LINUX_2.6.39 {
+	global:
+		__kernel_rt_sigreturn;
+		__kernel_gettimeofday;
+		__kernel_clock_gettime;
+		__kernel_clock_getres;
+	local: *;
+	};
+}
+
+/*
+ * Make the sigreturn code visible to the kernel.
+ */
+VDSO_sigtramp_ilp32		= __kernel_rt_sigreturn;
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 31e995b..fee8964 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -40,6 +40,12 @@ extern char vdso_start, vdso_end;
 static unsigned long vdso_pages;
 static struct page **vdso_pagelist;
 
+#ifdef CONFIG_ARM64_ILP32
+extern char vdso_ilp32_start, vdso_ilp32_end;
+static unsigned long vdso_ilp32_pages;
+static struct page **vdso_ilp32_pagelist;
+#endif
+
 /*
  * The vDSO data page.
  */
@@ -104,45 +110,78 @@ int aarch32_setup_vectors_page(struct linux_binprm *bprm, int uses_interp)
 }
 #endif /* CONFIG_AARCH32_EL0 */
 
-static int __init vdso_init(void)
+static inline int __init vdso_init_common(char *vdso_start, char *vdso_end,
+					  unsigned long *vdso_pagesp,
+					  struct page ***vdso_pagelistp)
 {
 	int i;
+	unsigned long vdso_pages;
+	struct page **vdso_pagelist;
 
-	if (memcmp(&vdso_start, "\177ELF", 4)) {
+	if (memcmp(vdso_start, "\177ELF", 4)) {
 		pr_err("vDSO is not a valid ELF object!\n");
 		return -EINVAL;
 	}
 
-	vdso_pages = (&vdso_end - &vdso_start) >> PAGE_SHIFT;
+	vdso_pages = (vdso_end - vdso_start) >> PAGE_SHIFT;
+	*vdso_pagesp = vdso_pages;
 	pr_info("vdso: %ld pages (%ld code, %ld data) at base %p\n",
-		vdso_pages + 1, vdso_pages, 1L, &vdso_start);
+		vdso_pages + 1, vdso_pages, 1L, vdso_start);
 
 	/* Allocate the vDSO pagelist, plus a page for the data. */
 	vdso_pagelist = kcalloc(vdso_pages + 1, sizeof(struct page *),
 				GFP_KERNEL);
+	*vdso_pagelistp = vdso_pagelist;
 	if (vdso_pagelist == NULL)
 		return -ENOMEM;
 
 	/* Grab the vDSO code pages. */
 	for (i = 0; i < vdso_pages; i++)
-		vdso_pagelist[i] = virt_to_page(&vdso_start + i * PAGE_SIZE);
+		vdso_pagelist[i] = virt_to_page(vdso_start + i * PAGE_SIZE);
 
 	/* Grab the vDSO data page. */
 	vdso_pagelist[i] = virt_to_page(vdso_data);
 
 	return 0;
 }
+
+static int __init vdso_init(void)
+{
+	return vdso_init_common(&vdso_start, &vdso_end,
+				&vdso_pages, &vdso_pagelist);
+}
 arch_initcall(vdso_init);
 
+#ifdef CONFIG_ARM64_ILP32
+static int __init vdso_ilp32_init(void)
+{
+	return vdso_init_common(&vdso_ilp32_start, &vdso_ilp32_end,
+				&vdso_ilp32_pages, &vdso_ilp32_pagelist);
+}
+arch_initcall(vdso_ilp32_init);
+#endif
+
 int arch_setup_additional_pages(struct linux_binprm *bprm,
 				int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long vdso_base, vdso_mapping_len;
 	int ret;
+	struct page **pagelist;
+	unsigned long pages;
 
 	/* Be sure to map the data page */
-	vdso_mapping_len = (vdso_pages + 1) << PAGE_SHIFT;
+#ifdef CONFIG_ARM64_ILP32
+	if (is_ilp32_compat_task()) {
+		pages = vdso_ilp32_pages;
+		pagelist = vdso_ilp32_pagelist;
+	} else
+#endif
+	{
+		pages = vdso_pages;
+		pagelist = vdso_pagelist;
+	}
+	vdso_mapping_len = (pages + 1) << PAGE_SHIFT;
 
 	down_write(&mm->mmap_sem);
 	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
@@ -155,7 +194,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 	ret = install_special_mapping(mm, vdso_base, vdso_mapping_len,
 				      VM_READ|VM_EXEC|
 				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-				      vdso_pagelist);
+				      pagelist);
 	if (ret) {
 		mm->context.vdso = NULL;
 		goto up_fail;
-- 
1.7.2.5

