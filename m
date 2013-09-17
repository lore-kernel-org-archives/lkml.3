Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab3IQMqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:46:02 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43954 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3IQMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:44:07 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        mans@mansr.com, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [RFC PATCH 07/11] ARM: PIE: Add support for updating PIE relocations
Date: Tue, 17 Sep 2013 05:43:33 -0700
Message-Id: <1379421817-15759-8-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for updating PIE relocations under ARM. This
is necessary in the case that the same PIE must run both with
virtual mapping (MMU enabled) and physical mapping (MMU
disabled).

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 arch/arm/include/asm/pie.h | 42 +++++++++++++++++++++++++
 arch/arm/kernel/pie.c      |  9 ++++++
 arch/arm/libpie/Makefile   |  2 +-
 arch/arm/libpie/relocate.S | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 128 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/asm/pie.h
 create mode 100644 arch/arm/libpie/relocate.S

diff --git a/arch/arm/include/asm/pie.h b/arch/arm/include/asm/pie.h
new file mode 100644
index 0000000..977f11d
--- /dev/null
+++ b/arch/arm/include/asm/pie.h
@@ -0,0 +1,42 @@
+/*
+ *  arch/arm/include/asm/pie.h
+ *
+ *  Copyright 2013 Texas Instruments, Inc
+ *	Russ Dill <russ.dill@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASMARM_PIE_H
+#define _ASMARM_PIE_H
+
+#include <linux/pie.h>
+
+#ifdef CONFIG_PIE
+extern void __pie_relocate(void);
+extern void __pie___pie_relocate(void);
+
+#define pie_relocate_from_pie()						\
+	__asm__ __volatile__("bl __pie_relocate\n"			\
+	: : : "cc", "memory", "lr", "r4", "r5", "r6", "r7", "r8", "r9");
+
+static inline void pie_relocate_from_kern(struct pie_chunk *chunk)
+{
+	void (*fn)(void) = fn_to_pie(chunk, &__pie___pie_relocate);
+	__asm__ __volatile__("" : : : "cc", "memory", "r4", "r5", "r6",
+				"r7", "r8", "r9");
+	fn();
+}
+#else
+
+#define pie_relocate_from_pie() do {} while(0)
+
+static inline void pie_relocate_from_kern(struct pie_chunk *chunk)
+{
+}
+
+#endif
+
+#endif
diff --git a/arch/arm/kernel/pie.c b/arch/arm/kernel/pie.c
index 5dff5d6..598562f 100644
--- a/arch/arm/kernel/pie.c
+++ b/arch/arm/kernel/pie.c
@@ -12,10 +12,12 @@
 #include <linux/elf.h>
 
 #include <asm/elf.h>
+#include <asm/pie.h>
 
 extern char __pie_rel_dyn_start[];
 extern char __pie_rel_dyn_end[];
 extern char __pie_tail_offset[];
+extern char __pie_reloc_offset[];
 
 struct arm_pie_tail {
 	int count;
@@ -72,12 +74,19 @@ int pie_arch_fixup(struct pie_chunk *chunk, void *base, void *tail,
 						unsigned long offset)
 {
 	struct arm_pie_tail *pie_tail = tail;
+	void *reloc;
 	int i;
 
 	/* Perform relocation fixups for given offset */
 	for (i = 0; i < pie_tail->count; i++)
 		*((uintptr_t *) (pie_tail->offset[i] + base)) += offset;
 
+	/* Store the PIE offset to tail and recol func */
+	*kern_to_pie(chunk, (uintptr_t *) __pie_tail_offset) = tail - base;
+	reloc = kern_to_pie(chunk,
+				(void *) fnptr_to_addr(&__pie___pie_relocate));
+	*kern_to_pie(chunk, (uintptr_t *) __pie_reloc_offset) = reloc - base;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pie_arch_fixup);
diff --git a/arch/arm/libpie/Makefile b/arch/arm/libpie/Makefile
index 5662e99..b1ac52a 100644
--- a/arch/arm/libpie/Makefile
+++ b/arch/arm/libpie/Makefile
@@ -3,7 +3,7 @@
 #
 ccflags-y	:= -fpic -mno-single-pic-base -fno-builtin
 
-obj-y		:= empty.o
+obj-y		:= relocate.o empty.o
 obj-y		+= lib1funcs.o ashldi3.o string.o
 
 # string library code (-Os is enforced to keep it much smaller)
diff --git a/arch/arm/libpie/relocate.S b/arch/arm/libpie/relocate.S
new file mode 100644
index 0000000..70cc36e
--- /dev/null
+++ b/arch/arm/libpie/relocate.S
@@ -0,0 +1,76 @@
+/*
+ * arch/arm/libpie/relocate.S - Relocation updating for PIEs
+ *
+ * Copyright 2013 Texas Instruments, Inc.
+ *	Russ Dill <russ.dill@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+
+/*
+ * Update relocations based on current pc
+ *
+ * On exit:
+ *  r4-r9 corrupted
+ */
+
+ENTRY(__pie_relocate)
+	/* Calculate offset of our code compared to existing relocations */
+	ldr	r4, pie_relocate_address
+	adr	r5, __pie_relocate
+	subs	r6, r5, r4
+	moveq	pc, lr			/* 0 offset, no need to do anything */
+
+	/* Base of PIE group */
+	ldr	r7, reloc_offset
+	sub	r5, r5, r7
+
+	/* Calculate address of tail */
+	ldr	r7, tail_offset
+	add	r7, r7, r5
+
+	/* First byte of tail is number of entries */
+	ldr	r8, [r7], #4
+	add	r8, r7, r8, lsl #2
+
+	/*
+	 * r5 - current base address of PIE group
+	 * r6 - fixup offset needed for relocs
+	 * r7 - relocs start
+	 * r8 - relocs end
+	 */
+
+1:
+	cmp	r7, r8
+	ldrne	r4, [r7], #4	/* Load next reloc offset */
+
+	addne	r4, r4, r5	/* Calculate address of reloc entry */
+	ldrne	r9, [r4]
+	addne	r9, r9, r6	/* Fixup reloc entry */
+	strne	r9, [r4]
+
+	bne	1b
+
+	mov	pc, lr
+ENDPROC(__pie_relocate)
+
+/*
+ * This ends up in the .rel.dyn section and can be used to read the current
+ * relocation offset
+ */
+pie_relocate_address:
+	.long 	__pie_relocate
+
+/* Offset from PIE section start to reloc function */
+.global reloc_offset
+reloc_offset:
+	.space	4
+
+/* Offset from PIE section start to tail */
+.globl tail_offset
+tail_offset:
+	.space	4
-- 
1.8.3.2

