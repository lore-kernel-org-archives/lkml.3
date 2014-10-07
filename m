Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbaJGT2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:28:09 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:59958 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaJGT2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:28:04 -0400
From: minyard@acm.org
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 2/3] Move generic dwarf2 operations from x86 to asm-generic
Date: Tue,  7 Oct 2014 14:27:13 -0500
Message-Id: <1412710034-16908-3-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1412710034-16908-1-git-send-email-minyard@acm.org>
References: <1412710034-16908-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

A lot of arch/x86/include/asm/dwarf2.h was generic, move it to
asm-generic so other arches can get to it.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 arch/x86/include/asm/dwarf2.h | 74 +----------------------------------------
 include/asm-generic/dwarf2.h  | 77 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 73 deletions(-)
 create mode 100644 include/asm-generic/dwarf2.h

diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index f6f1598..3360e2a 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -1,79 +1,7 @@
 #ifndef _ASM_X86_DWARF2_H
 #define _ASM_X86_DWARF2_H
 
-#ifndef __ASSEMBLY__
-#warning "asm/dwarf2.h should be only included in pure assembly files"
-#endif
-
-/*
- * Macros for dwarf2 CFI unwind table entries.
- * See "as.info" for details on these pseudo ops. Unfortunately
- * they are only supported in very new binutils, so define them
- * away for older version.
- */
-
-#ifdef CONFIG_AS_CFI
-
-#define CFI_STARTPROC		.cfi_startproc
-#define CFI_ENDPROC		.cfi_endproc
-#define CFI_DEF_CFA		.cfi_def_cfa
-#define CFI_DEF_CFA_REGISTER	.cfi_def_cfa_register
-#define CFI_DEF_CFA_OFFSET	.cfi_def_cfa_offset
-#define CFI_ADJUST_CFA_OFFSET	.cfi_adjust_cfa_offset
-#define CFI_OFFSET		.cfi_offset
-#define CFI_REL_OFFSET		.cfi_rel_offset
-#define CFI_REGISTER		.cfi_register
-#define CFI_RESTORE		.cfi_restore
-#define CFI_REMEMBER_STATE	.cfi_remember_state
-#define CFI_RESTORE_STATE	.cfi_restore_state
-#define CFI_UNDEFINED		.cfi_undefined
-#define CFI_ESCAPE		.cfi_escape
-
-#ifdef CONFIG_AS_CFI_SIGNAL_FRAME
-#define CFI_SIGNAL_FRAME	.cfi_signal_frame
-#else
-#define CFI_SIGNAL_FRAME
-#endif
-
-#if defined(CONFIG_AS_CFI_SECTIONS) && defined(__ASSEMBLY__)
-	/*
-	 * Emit CFI data in .debug_frame sections, not .eh_frame sections.
-	 * The latter we currently just discard since we don't do DWARF
-	 * unwinding at runtime.  So only the offline DWARF information is
-	 * useful to anyone.  Note we should not use this directive if this
-	 * file is used in the vDSO assembly, or if vmlinux.lds.S gets
-	 * changed so it doesn't discard .eh_frame.
-	 */
-	.cfi_sections .debug_frame
-#endif
-
-#else
-
-/*
- * Due to the structure of pre-exisiting code, don't use assembler line
- * comment character # to ignore the arguments. Instead, use a dummy macro.
- */
-.macro cfi_ignore a=0, b=0, c=0, d=0
-.endm
-
-#define CFI_STARTPROC		cfi_ignore
-#define CFI_ENDPROC		cfi_ignore
-#define CFI_DEF_CFA		cfi_ignore
-#define CFI_DEF_CFA_REGISTER	cfi_ignore
-#define CFI_DEF_CFA_OFFSET	cfi_ignore
-#define CFI_ADJUST_CFA_OFFSET	cfi_ignore
-#define CFI_OFFSET		cfi_ignore
-#define CFI_REL_OFFSET		cfi_ignore
-#define CFI_REGISTER		cfi_ignore
-#define CFI_RESTORE		cfi_ignore
-#define CFI_REMEMBER_STATE	cfi_ignore
-#define CFI_RESTORE_STATE	cfi_ignore
-#define CFI_UNDEFINED		cfi_ignore
-#define CFI_ESCAPE		cfi_ignore
-#define CFI_SIGNAL_FRAME	cfi_ignore
-
-#endif
-
+#include <asm-generic/dwarf2.h>
 /*
  * An attempt to make CFI annotations more or less
  * correct and shorter. It is implied that you know
diff --git a/include/asm-generic/dwarf2.h b/include/asm-generic/dwarf2.h
new file mode 100644
index 0000000..19a677f
--- /dev/null
+++ b/include/asm-generic/dwarf2.h
@@ -0,0 +1,77 @@
+#ifndef _ASM_GENERIC_DWARF2_H
+#define _ASM_GENERIC_DWARF2_H
+
+#ifndef __ASSEMBLY__
+#warning "asm/dwarf2.h should be only included in pure assembly files"
+#endif
+
+/*
+ * Macros for dwarf2 CFI unwind table entries.
+ * See "as.info" for details on these pseudo ops. Unfortunately
+ * they are only supported in very new binutils, so define them
+ * away for older version.
+ */
+
+#ifdef CONFIG_AS_CFI
+
+#define CFI_STARTPROC		.cfi_startproc
+#define CFI_ENDPROC		.cfi_endproc
+#define CFI_DEF_CFA		.cfi_def_cfa
+#define CFI_DEF_CFA_REGISTER	.cfi_def_cfa_register
+#define CFI_DEF_CFA_OFFSET	.cfi_def_cfa_offset
+#define CFI_ADJUST_CFA_OFFSET	.cfi_adjust_cfa_offset
+#define CFI_OFFSET		.cfi_offset
+#define CFI_REL_OFFSET		.cfi_rel_offset
+#define CFI_REGISTER		.cfi_register
+#define CFI_RESTORE		.cfi_restore
+#define CFI_REMEMBER_STATE	.cfi_remember_state
+#define CFI_RESTORE_STATE	.cfi_restore_state
+#define CFI_UNDEFINED		.cfi_undefined
+#define CFI_ESCAPE		.cfi_escape
+
+#ifdef CONFIG_AS_CFI_SIGNAL_FRAME
+#define CFI_SIGNAL_FRAME	.cfi_signal_frame
+#else
+#define CFI_SIGNAL_FRAME
+#endif
+
+#if defined(CONFIG_AS_CFI_SECTIONS) && defined(__ASSEMBLY__)
+	/*
+	 * Emit CFI data in .debug_frame sections, not .eh_frame sections.
+	 * The latter we currently just discard since we don't do DWARF
+	 * unwinding at runtime.  So only the offline DWARF information is
+	 * useful to anyone.  Note we should not use this directive if this
+	 * file is used in the vDSO assembly, or if vmlinux.lds.S gets
+	 * changed so it doesn't discard .eh_frame.
+	 */
+	.cfi_sections .debug_frame
+#endif
+
+#else
+
+/*
+ * Due to the structure of pre-exisiting code, don't use assembler line
+ * comment character # to ignore the arguments. Instead, use a dummy macro.
+ */
+.macro cfi_ignore a=0, b=0, c=0, d=0
+.endm
+
+#define CFI_STARTPROC		cfi_ignore
+#define CFI_ENDPROC		cfi_ignore
+#define CFI_DEF_CFA		cfi_ignore
+#define CFI_DEF_CFA_REGISTER	cfi_ignore
+#define CFI_DEF_CFA_OFFSET	cfi_ignore
+#define CFI_ADJUST_CFA_OFFSET	cfi_ignore
+#define CFI_OFFSET		cfi_ignore
+#define CFI_REL_OFFSET		cfi_ignore
+#define CFI_REGISTER		cfi_ignore
+#define CFI_RESTORE		cfi_ignore
+#define CFI_REMEMBER_STATE	cfi_ignore
+#define CFI_RESTORE_STATE	cfi_ignore
+#define CFI_UNDEFINED		cfi_ignore
+#define CFI_ESCAPE		cfi_ignore
+#define CFI_SIGNAL_FRAME	cfi_ignore
+
+#endif
+
+#endif /* _ASM_GENERIC_DWARF2_H */
-- 
1.8.3.1

