Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab3J1KcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:32:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:13717 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab3J1KcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:32:03 -0400
X-Spam-Score: -100.8
Message-ID: <526E3CE2.2070405@asianux.com>
Date: Mon, 28 Oct 2013 18:30:58 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>,
        James Hogan <james.hogan@imgtec.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: use ASM_NL instead of ';' for assembler new line character
 in the macro
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some toolchains, they use another character as newline in a macro
(e.g. arc uses '`'), so for generic assembly code, need use ASM_NL (a
macro) instead of ';' for it.

Since "linux/export.h" are mainly used for exporting work, then our fix
more likely belongs to "linux/linkage.h", and we need add the related
checking in "linkage.h".

Also need notice 80 columns wrap, and '\t' for each line.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/include/asm/linkage.h    |    2 +
 include/asm-generic/vmlinux.lds.h |  350 +++++++++++++++++++------------------
 include/linux/linkage.h           |   19 ++-
 3 files changed, 190 insertions(+), 181 deletions(-)

diff --git a/arch/arc/include/asm/linkage.h b/arch/arc/include/asm/linkage.h
index 0283e9e..66ee552 100644
--- a/arch/arc/include/asm/linkage.h
+++ b/arch/arc/include/asm/linkage.h
@@ -11,6 +11,8 @@
 
 #ifdef __ASSEMBLY__
 
+#define ASM_NL		 `	/* use '`' to mark new line in macro */
+
 /* Can't use the ENTRY macro in linux/linkage.h
  * gas considers ';' as comment vs. newline
  */
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bc2121f..0ca99a9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -10,28 +10,28 @@
  * ENTRY(...)
  * SECTIONS
  * {
- *	. = START;
- *	__init_begin = .;
+ *	. = START
+ *	__init_begin = .
  *	HEAD_TEXT_SECTION
  *	INIT_TEXT_SECTION(PAGE_SIZE)
  *	INIT_DATA_SECTION(...)
  *	PERCPU_SECTION(CACHELINE_SIZE)
- *	__init_end = .;
+ *	__init_end = .
  *
- *	_stext = .;
+ *	_stext = .
  *	TEXT_SECTION = 0
- *	_etext = .;
+ *	_etext = .
  *
- *      _sdata = .;
+ *      _sdata = .
  *	RO_DATA_SECTION(PAGE_SIZE)
  *	RW_DATA_SECTION(...)
- *	_edata = .;
+ *	_edata = .
  *
  *	EXCEPTION_TABLE(...)
  *	NOTES
  *
  *	BSS_SECTION(0, 0, 0)
- *	_end = .;
+ *	_end = .
  *
  *	STABS_DEBUG
  *	DWARF_DEBUG
@@ -52,7 +52,7 @@
 #define LOAD_OFFSET 0
 #endif
 
-#include <linux/export.h>
+#include <linux/linkage.h>
 
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
@@ -85,63 +85,65 @@
 #endif
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
-#define MCOUNT_REC()	. = ALIGN(8);				\
-			VMLINUX_SYMBOL(__start_mcount_loc) = .; \
-			*(__mcount_loc)				\
-			VMLINUX_SYMBOL(__stop_mcount_loc) = .;
+#define MCOUNT_REC()	. = ALIGN(8) ASM_NL				\
+			VMLINUX_SYMBOL(__start_mcount_loc) = . ASM_NL   \
+			*(__mcount_loc)					\
+			VMLINUX_SYMBOL(__stop_mcount_loc) = . ASM_NL
 #else
 #define MCOUNT_REC()
 #endif
 
 #ifdef CONFIG_TRACE_BRANCH_PROFILING
-#define LIKELY_PROFILE()	VMLINUX_SYMBOL(__start_annotated_branch_profile) = .; \
-				*(_ftrace_annotated_branch)			      \
-				VMLINUX_SYMBOL(__stop_annotated_branch_profile) = .;
+#define LIKELY_PROFILE()						    \
+		VMLINUX_SYMBOL(__start_annotated_branch_profile) = . ASM_NL \
+		*(_ftrace_annotated_branch)				    \
+		VMLINUX_SYMBOL(__stop_annotated_branch_profile) = . ASM_NL
 #else
 #define LIKELY_PROFILE()
 #endif
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
-#define BRANCH_PROFILE()	VMLINUX_SYMBOL(__start_branch_profile) = .;   \
-				*(_ftrace_branch)			      \
-				VMLINUX_SYMBOL(__stop_branch_profile) = .;
+#define BRANCH_PROFILE()						\
+		VMLINUX_SYMBOL(__start_branch_profile) = . ASM_NL	\
+		*(_ftrace_branch)					\
+		VMLINUX_SYMBOL(__stop_branch_profile) = . ASM_NL
 #else
 #define BRANCH_PROFILE()
 #endif
 
 #ifdef CONFIG_EVENT_TRACING
-#define FTRACE_EVENTS()	. = ALIGN(8);					\
-			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
-			*(_ftrace_events)				\
-			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
+#define FTRACE_EVENTS()	. = ALIGN(8) ASM_NL				 \
+			VMLINUX_SYMBOL(__start_ftrace_events) = . ASM_NL \
+			*(_ftrace_events)				 \
+			VMLINUX_SYMBOL(__stop_ftrace_events) = . ASM_NL
 #else
 #define FTRACE_EVENTS()
 #endif
 
 #ifdef CONFIG_TRACING
-#define TRACE_PRINTKS() VMLINUX_SYMBOL(__start___trace_bprintk_fmt) = .;      \
+#define TRACE_PRINTKS() VMLINUX_SYMBOL(__start___trace_bprintk_fmt) = . ASM_NL \
 			 *(__trace_printk_fmt) /* Trace_printk fmt' pointer */ \
-			 VMLINUX_SYMBOL(__stop___trace_bprintk_fmt) = .;
-#define TRACEPOINT_STR() VMLINUX_SYMBOL(__start___tracepoint_str) = .;	\
-			 *(__tracepoint_str) /* Trace_printk fmt' pointer */ \
-			 VMLINUX_SYMBOL(__stop___tracepoint_str) = .;
+			 VMLINUX_SYMBOL(__stop___trace_bprintk_fmt) = . ASM_NL
+#define TRACEPOINT_STR() VMLINUX_SYMBOL(__start___tracepoint_str) = . ASM_NL   \
+			 *(__tracepoint_str) /* Trace_printk fmt' pointer */   \
+			 VMLINUX_SYMBOL(__stop___tracepoint_str) = . ASM_NL
 #else
 #define TRACE_PRINTKS()
 #define TRACEPOINT_STR()
 #endif
 
 #ifdef CONFIG_FTRACE_SYSCALLS
-#define TRACE_SYSCALLS() . = ALIGN(8);					\
-			 VMLINUX_SYMBOL(__start_syscalls_metadata) = .;	\
-			 *(__syscalls_metadata)				\
-			 VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
+#define TRACE_SYSCALLS() . = ALIGN(8) ASM_NL				       \
+			 VMLINUX_SYMBOL(__start_syscalls_metadata) = . ASM_NL  \
+			 *(__syscalls_metadata)				       \
+			 VMLINUX_SYMBOL(__stop_syscalls_metadata) = . ASM_NL
 #else
 #define TRACE_SYSCALLS()
 #endif
 
 #ifdef CONFIG_CLKSRC_OF
-#define CLKSRC_OF_TABLES() . = ALIGN(8);				\
-			   VMLINUX_SYMBOL(__clksrc_of_table) = .;	\
+#define CLKSRC_OF_TABLES() . = ALIGN(8) ASM_NL				\
+			   VMLINUX_SYMBOL(__clksrc_of_table) = . ASM_NL	\
 			   *(__clksrc_of_table)				\
 			   *(__clksrc_of_table_end)
 #else
@@ -150,8 +152,8 @@
 
 #ifdef CONFIG_IRQCHIP
 #define IRQCHIP_OF_MATCH_TABLE()					\
-	. = ALIGN(8);							\
-	VMLINUX_SYMBOL(__irqchip_begin) = .;				\
+	. = ALIGN(8) ASM_NL						\
+	VMLINUX_SYMBOL(__irqchip_begin) = . ASM_NL			\
 	*(__irqchip_of_table)		  				\
 	*(__irqchip_of_end)
 #else
@@ -159,19 +161,19 @@
 #endif
 
 #ifdef CONFIG_COMMON_CLK
-#define CLK_OF_TABLES() . = ALIGN(8);				\
-			VMLINUX_SYMBOL(__clk_of_table) = .;	\
-			*(__clk_of_table)			\
+#define CLK_OF_TABLES() . = ALIGN(8) ASM_NL				\
+			VMLINUX_SYMBOL(__clk_of_table) = . ASM_NL	\
+			*(__clk_of_table)				\
 			*(__clk_of_table_end)
 #else
 #define CLK_OF_TABLES()
 #endif
 
 #define KERNEL_DTB()							\
-	STRUCT_ALIGN();							\
-	VMLINUX_SYMBOL(__dtb_start) = .;				\
+	STRUCT_ALIGN() ASM_NL						\
+	VMLINUX_SYMBOL(__dtb_start) = . ASM_NL				\
 	*(.dtb.init.rodata)						\
-	VMLINUX_SYMBOL(__dtb_end) = .;
+	VMLINUX_SYMBOL(__dtb_end) = . ASM_NL
 
 /* .data section */
 #define DATA_DATA							\
@@ -181,17 +183,17 @@
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
 	*(.data.unlikely)						\
-	STRUCT_ALIGN();							\
+	STRUCT_ALIGN() ASM_NL						\
 	*(__tracepoints)						\
 	/* implement dynamic printk debug */				\
-	. = ALIGN(8);                                                   \
-	VMLINUX_SYMBOL(__start___jump_table) = .;                       \
+	. = ALIGN(8) ASM_NL                                             \
+	VMLINUX_SYMBOL(__start___jump_table) = . ASM_NL                 \
 	*(__jump_table)                                                 \
-	VMLINUX_SYMBOL(__stop___jump_table) = .;                        \
-	. = ALIGN(8);							\
-	VMLINUX_SYMBOL(__start___verbose) = .;                          \
+	VMLINUX_SYMBOL(__stop___jump_table) = . ASM_NL                  \
+	. = ALIGN(8) ASM_NL						\
+	VMLINUX_SYMBOL(__start___verbose) = . ASM_NL                    \
 	*(__verbose)                                                    \
-	VMLINUX_SYMBOL(__stop___verbose) = .;				\
+	VMLINUX_SYMBOL(__stop___verbose) = . ASM_NL			\
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
@@ -201,42 +203,42 @@
  * Data section helpers
  */
 #define NOSAVE_DATA							\
-	. = ALIGN(PAGE_SIZE);						\
-	VMLINUX_SYMBOL(__nosave_begin) = .;				\
+	. = ALIGN(PAGE_SIZE) ASM_NL					\
+	VMLINUX_SYMBOL(__nosave_begin) = . ASM_NL			\
 	*(.data..nosave)						\
-	. = ALIGN(PAGE_SIZE);						\
-	VMLINUX_SYMBOL(__nosave_end) = .;
+	. = ALIGN(PAGE_SIZE) ASM_NL					\
+	VMLINUX_SYMBOL(__nosave_end) = . ASM_NL
 
 #define PAGE_ALIGNED_DATA(page_align)					\
-	. = ALIGN(page_align);						\
+	. = ALIGN(page_align) ASM_NL					\
 	*(.data..page_aligned)
 
 #define READ_MOSTLY_DATA(align)						\
-	. = ALIGN(align);						\
+	. = ALIGN(align) ASM_NL						\
 	*(.data..read_mostly)						\
-	. = ALIGN(align);
+	. = ALIGN(align) ASM_NL
 
 #define CACHELINE_ALIGNED_DATA(align)					\
-	. = ALIGN(align);						\
+	. = ALIGN(align) ASM_NL						\
 	*(.data..cacheline_aligned)
 
 #define INIT_TASK_DATA(align)						\
-	. = ALIGN(align);						\
+	. = ALIGN(align) ASM_NL						\
 	*(.data..init_task)
 
 /*
  * Read only Data
  */
 #define RO_DATA_SECTION(align)						\
-	. = ALIGN((align));						\
+	. = ALIGN((align)) ASM_NL					\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start_rodata) = .;			\
+		VMLINUX_SYMBOL(__start_rodata) = . ASM_NL		\
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
-		. = ALIGN(8);						\
-		VMLINUX_SYMBOL(__start___tracepoints_ptrs) = .;		\
+		. = ALIGN(8) ASM_NL					\
+		VMLINUX_SYMBOL(__start___tracepoints_ptrs) = . ASM_NL	\
 		*(__tracepoints_ptrs)	/* Tracepoints: pointer array */\
-		VMLINUX_SYMBOL(__stop___tracepoints_ptrs) = .;		\
+		VMLINUX_SYMBOL(__stop___tracepoints_ptrs) = . ASM_NL	\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
 	}								\
 									\
@@ -248,106 +250,106 @@
 									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
-		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
+		VMLINUX_SYMBOL(__start_pci_fixups_early) = . ASM_NL	\
 		*(.pci_fixup_early)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_early) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_header) = .;		\
+		VMLINUX_SYMBOL(__end_pci_fixups_early) = . ASM_NL	\
+		VMLINUX_SYMBOL(__start_pci_fixups_header) = . ASM_NL	\
 		*(.pci_fixup_header)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_header) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_final) = .;		\
+		VMLINUX_SYMBOL(__end_pci_fixups_header) = . ASM_NL	\
+		VMLINUX_SYMBOL(__start_pci_fixups_final) = . ASM_NL	\
 		*(.pci_fixup_final)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_final) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_enable) = .;		\
+		VMLINUX_SYMBOL(__end_pci_fixups_final) = . ASM_NL	\
+		VMLINUX_SYMBOL(__start_pci_fixups_enable) = . ASM_NL	\
 		*(.pci_fixup_enable)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_enable) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_resume) = .;		\
+		VMLINUX_SYMBOL(__end_pci_fixups_enable) = . ASM_NL	\
+		VMLINUX_SYMBOL(__start_pci_fixups_resume) = . ASM_NL	\
 		*(.pci_fixup_resume)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_resume) = .;		\
-		VMLINUX_SYMBOL(__start_pci_fixups_resume_early) = .;	\
+		VMLINUX_SYMBOL(__end_pci_fixups_resume) = . ASM_NL	\
+		VMLINUX_SYMBOL(__start_pci_fixups_resume_early) = . ASM_NL \
 		*(.pci_fixup_resume_early)				\
-		VMLINUX_SYMBOL(__end_pci_fixups_resume_early) = .;	\
-		VMLINUX_SYMBOL(__start_pci_fixups_suspend) = .;		\
+		VMLINUX_SYMBOL(__end_pci_fixups_resume_early) = . ASM_NL \
+		VMLINUX_SYMBOL(__start_pci_fixups_suspend) = . ASM_NL	\
 		*(.pci_fixup_suspend)					\
-		VMLINUX_SYMBOL(__end_pci_fixups_suspend) = .;		\
+		VMLINUX_SYMBOL(__end_pci_fixups_suspend) = . ASM_NL	\
 	}								\
 									\
 	/* Built-in firmware blobs */					\
 	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
-		VMLINUX_SYMBOL(__start_builtin_fw) = .;			\
+		VMLINUX_SYMBOL(__start_builtin_fw) = . ASM_NL		\
 		*(.builtin_fw)						\
-		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
+		VMLINUX_SYMBOL(__end_builtin_fw) = . ASM_NL		\
 	}								\
 									\
 	TRACEDATA							\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
+		VMLINUX_SYMBOL(__start___ksymtab) = . ASM_NL		\
 		*(SORT(___ksymtab+*))					\
-		VMLINUX_SYMBOL(__stop___ksymtab) = .;			\
+		VMLINUX_SYMBOL(__stop___ksymtab) = . ASM_NL		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__ksymtab_gpl     : AT(ADDR(__ksymtab_gpl) - LOAD_OFFSET) {	\
-		VMLINUX_SYMBOL(__start___ksymtab_gpl) = .;		\
+		VMLINUX_SYMBOL(__start___ksymtab_gpl) = . ASM_NL	\
 		*(SORT(___ksymtab_gpl+*))				\
-		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = .;		\
+		VMLINUX_SYMBOL(__stop___ksymtab_gpl) = . ASM_NL		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__ksymtab_unused  : AT(ADDR(__ksymtab_unused) - LOAD_OFFSET) {	\
-		VMLINUX_SYMBOL(__start___ksymtab_unused) = .;		\
+		VMLINUX_SYMBOL(__start___ksymtab_unused) = . ASM_NL	\
 		*(SORT(___ksymtab_unused+*))				\
-		VMLINUX_SYMBOL(__stop___ksymtab_unused) = .;		\
+		VMLINUX_SYMBOL(__stop___ksymtab_unused) = . ASM_NL	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__ksymtab_unused_gpl : AT(ADDR(__ksymtab_unused_gpl) - LOAD_OFFSET) { \
-		VMLINUX_SYMBOL(__start___ksymtab_unused_gpl) = .;	\
+		VMLINUX_SYMBOL(__start___ksymtab_unused_gpl) = . ASM_NL	\
 		*(SORT(___ksymtab_unused_gpl+*))			\
-		VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl) = .;	\
+		VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl) = . ASM_NL	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__ksymtab_gpl_future : AT(ADDR(__ksymtab_gpl_future) - LOAD_OFFSET) { \
-		VMLINUX_SYMBOL(__start___ksymtab_gpl_future) = .;	\
+		VMLINUX_SYMBOL(__start___ksymtab_gpl_future) = . ASM_NL	\
 		*(SORT(___ksymtab_gpl_future+*))			\
-		VMLINUX_SYMBOL(__stop___ksymtab_gpl_future) = .;	\
+		VMLINUX_SYMBOL(__stop___ksymtab_gpl_future) = . ASM_NL	\
 	}								\
 									\
 	/* Kernel symbol table: Normal symbols */			\
 	__kcrctab         : AT(ADDR(__kcrctab) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start___kcrctab) = .;			\
+		VMLINUX_SYMBOL(__start___kcrctab) = . ASM_NL		\
 		*(SORT(___kcrctab+*))					\
-		VMLINUX_SYMBOL(__stop___kcrctab) = .;			\
+		VMLINUX_SYMBOL(__stop___kcrctab) = . ASM_NL		\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only symbols */			\
 	__kcrctab_gpl     : AT(ADDR(__kcrctab_gpl) - LOAD_OFFSET) {	\
-		VMLINUX_SYMBOL(__start___kcrctab_gpl) = .;		\
+		VMLINUX_SYMBOL(__start___kcrctab_gpl) = . ASM_NL	\
 		*(SORT(___kcrctab_gpl+*))				\
-		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = .;		\
+		VMLINUX_SYMBOL(__stop___kcrctab_gpl) = . ASM_NL		\
 	}								\
 									\
 	/* Kernel symbol table: Normal unused symbols */		\
 	__kcrctab_unused  : AT(ADDR(__kcrctab_unused) - LOAD_OFFSET) {	\
-		VMLINUX_SYMBOL(__start___kcrctab_unused) = .;		\
+		VMLINUX_SYMBOL(__start___kcrctab_unused) = . ASM_NL	\
 		*(SORT(___kcrctab_unused+*))				\
-		VMLINUX_SYMBOL(__stop___kcrctab_unused) = .;		\
+		VMLINUX_SYMBOL(__stop___kcrctab_unused) = . ASM_NL	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-only unused symbols */		\
 	__kcrctab_unused_gpl : AT(ADDR(__kcrctab_unused_gpl) - LOAD_OFFSET) { \
-		VMLINUX_SYMBOL(__start___kcrctab_unused_gpl) = .;	\
+		VMLINUX_SYMBOL(__start___kcrctab_unused_gpl) = . ASM_NL	\
 		*(SORT(___kcrctab_unused_gpl+*))			\
-		VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl) = .;	\
+		VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl) = . ASM_NL	\
 	}								\
 									\
 	/* Kernel symbol table: GPL-future-only symbols */		\
 	__kcrctab_gpl_future : AT(ADDR(__kcrctab_gpl_future) - LOAD_OFFSET) { \
-		VMLINUX_SYMBOL(__start___kcrctab_gpl_future) = .;	\
+		VMLINUX_SYMBOL(__start___kcrctab_gpl_future) = . ASM_NL	\
 		*(SORT(___kcrctab_gpl_future+*))			\
-		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
+		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = . ASM_NL	\
 	}								\
 									\
 	/* Kernel symbol table: strings */				\
@@ -364,20 +366,20 @@
 									\
 	/* Built-in module parameters. */				\
 	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
-		VMLINUX_SYMBOL(__start___param) = .;			\
+		VMLINUX_SYMBOL(__start___param) = . ASM_NL		\
 		*(__param)						\
-		VMLINUX_SYMBOL(__stop___param) = .;			\
+		VMLINUX_SYMBOL(__stop___param) = . ASM_NL		\
 	}								\
 									\
 	/* Built-in module versions. */					\
 	__modver : AT(ADDR(__modver) - LOAD_OFFSET) {			\
-		VMLINUX_SYMBOL(__start___modver) = .;			\
+		VMLINUX_SYMBOL(__start___modver) = . ASM_NL		\
 		*(__modver)						\
-		VMLINUX_SYMBOL(__stop___modver) = .;			\
-		. = ALIGN((align));					\
-		VMLINUX_SYMBOL(__end_rodata) = .;			\
+		VMLINUX_SYMBOL(__stop___modver) = . ASM_NL		\
+		. = ALIGN((align)) ASM_NL				\
+		VMLINUX_SYMBOL(__end_rodata) = . ASM_NL			\
 	}								\
-	. = ALIGN((align));
+	. = ALIGN((align)) ASM_NL
 
 /* RODATA & RO_DATA provided for backward compatibility.
  * All archs are supposed to use RO_DATA() */
@@ -386,15 +388,15 @@
 
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
-		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
+		VMLINUX_SYMBOL(__security_initcall_start) = . ASM_NL	\
 		*(.security_initcall.init) 				\
-		VMLINUX_SYMBOL(__security_initcall_end) = .;		\
+		VMLINUX_SYMBOL(__security_initcall_end) = . ASM_NL	\
 	}
 
 /* .text section. Map to function alignment to avoid address changes
  * during second ld run in second ld pass when generating System.map */
 #define TEXT_TEXT							\
-		ALIGN_FUNCTION();					\
+		ALIGN_FUNCTION() ASM_NL					\
 		*(.text.hot)						\
 		*(.text)						\
 		*(.ref.text)						\
@@ -406,37 +408,37 @@
 /* sched.text is aling to function alignment to secure we have same
  * address even at second ld pass when generating System.map */
 #define SCHED_TEXT							\
-		ALIGN_FUNCTION();					\
-		VMLINUX_SYMBOL(__sched_text_start) = .;			\
+		ALIGN_FUNCTION() ASM_NL					\
+		VMLINUX_SYMBOL(__sched_text_start) = . ASM_NL		\
 		*(.sched.text)						\
-		VMLINUX_SYMBOL(__sched_text_end) = .;
+		VMLINUX_SYMBOL(__sched_text_end) = . ASM_NL
 
 /* spinlock.text is aling to function alignment to secure we have same
  * address even at second ld pass when generating System.map */
 #define LOCK_TEXT							\
-		ALIGN_FUNCTION();					\
-		VMLINUX_SYMBOL(__lock_text_start) = .;			\
+		ALIGN_FUNCTION() ASM_NL					\
+		VMLINUX_SYMBOL(__lock_text_start) = . ASM_NL		\
 		*(.spinlock.text)					\
-		VMLINUX_SYMBOL(__lock_text_end) = .;
+		VMLINUX_SYMBOL(__lock_text_end) = . ASM_NL
 
 #define KPROBES_TEXT							\
-		ALIGN_FUNCTION();					\
-		VMLINUX_SYMBOL(__kprobes_text_start) = .;		\
+		ALIGN_FUNCTION() ASM_NL					\
+		VMLINUX_SYMBOL(__kprobes_text_start) = . ASM_NL		\
 		*(.kprobes.text)					\
-		VMLINUX_SYMBOL(__kprobes_text_end) = .;
+		VMLINUX_SYMBOL(__kprobes_text_end) = . ASM_NL
 
 #define ENTRY_TEXT							\
-		ALIGN_FUNCTION();					\
-		VMLINUX_SYMBOL(__entry_text_start) = .;			\
+		ALIGN_FUNCTION() ASM_NL					\
+		VMLINUX_SYMBOL(__entry_text_start) = . ASM_NL		\
 		*(.entry.text)						\
-		VMLINUX_SYMBOL(__entry_text_end) = .;
+		VMLINUX_SYMBOL(__entry_text_end) = . ASM_NL
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 #define IRQENTRY_TEXT							\
-		ALIGN_FUNCTION();					\
-		VMLINUX_SYMBOL(__irqentry_text_start) = .;		\
+		ALIGN_FUNCTION() ASM_NL					\
+		VMLINUX_SYMBOL(__irqentry_text_start) = . ASM_NL	\
 		*(.irqentry.text)					\
-		VMLINUX_SYMBOL(__irqentry_text_end) = .;
+		VMLINUX_SYMBOL(__irqentry_text_end) = . ASM_NL
 #else
 #define IRQENTRY_TEXT
 #endif
@@ -444,7 +446,7 @@
 /* Section used for early init (in .S files) */
 #define HEAD_TEXT  *(.head.text)
 
-#define HEAD_TEXT_SECTION							\
+#define HEAD_TEXT_SECTION						\
 	.head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {		\
 		HEAD_TEXT						\
 	}
@@ -453,28 +455,28 @@
  * Exception table
  */
 #define EXCEPTION_TABLE(align)						\
-	. = ALIGN(align);						\
+	. = ALIGN(align) ASM_NL						\
 	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start___ex_table) = .;			\
+		VMLINUX_SYMBOL(__start___ex_table) = . ASM_NL		\
 		*(__ex_table)						\
-		VMLINUX_SYMBOL(__stop___ex_table) = .;			\
+		VMLINUX_SYMBOL(__stop___ex_table) = . ASM_NL		\
 	}
 
 /*
  * Init task
  */
 #define INIT_TASK_DATA_SECTION(align)					\
-	. = ALIGN(align);						\
+	. = ALIGN(align) ASM_NL						\
 	.data..init_task :  AT(ADDR(.data..init_task) - LOAD_OFFSET) {	\
 		INIT_TASK_DATA(align)					\
 	}
 
 #ifdef CONFIG_CONSTRUCTORS
-#define KERNEL_CTORS()	. = ALIGN(8);			   \
-			VMLINUX_SYMBOL(__ctors_start) = .; \
-			*(.ctors)			   \
-			*(.init_array)			   \
-			VMLINUX_SYMBOL(__ctors_end) = .;
+#define KERNEL_CTORS()	. = ALIGN(8) ASM_NL			   \
+			VMLINUX_SYMBOL(__ctors_start) = . ASM_NL   \
+			*(.ctors)				   \
+			*(.init_array)				   \
+			VMLINUX_SYMBOL(__ctors_end) = . ASM_NL
 #else
 #define KERNEL_CTORS()
 #endif
@@ -515,7 +517,7 @@
  * zeroed during startup
  */
 #define SBSS(sbss_align)						\
-	. = ALIGN(sbss_align);						\
+	. = ALIGN(sbss_align) ASM_NL					\
 	.sbss : AT(ADDR(.sbss) - LOAD_OFFSET) {				\
 		*(.sbss)						\
 		*(.scommon)						\
@@ -530,7 +532,7 @@
 #endif
 
 #define BSS(bss_align)							\
-	. = ALIGN(bss_align);						\
+	. = ALIGN(bss_align) ASM_NL					\
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {				\
 		BSS_FIRST_SECTIONS					\
 		*(.bss..page_aligned)					\
@@ -581,11 +583,11 @@
 
 #ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
-	. = ALIGN(8);							\
+	. = ALIGN(8) ASM_NL						\
 	__bug_table : AT(ADDR(__bug_table) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__start___bug_table) = .;		\
+		VMLINUX_SYMBOL(__start___bug_table) = . ASM_NL		\
 		*(__bug_table)						\
-		VMLINUX_SYMBOL(__stop___bug_table) = .;			\
+		VMLINUX_SYMBOL(__stop___bug_table) = . ASM_NL		\
 	}
 #else
 #define BUG_TABLE
@@ -593,11 +595,11 @@
 
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
-	. = ALIGN(4);							\
+	. = ALIGN(4) ASM_NL						\
 	.tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(__tracedata_start) = .;			\
+		VMLINUX_SYMBOL(__tracedata_start) = . ASM_NL		\
 		*(.tracedata)						\
-		VMLINUX_SYMBOL(__tracedata_end) = .;			\
+		VMLINUX_SYMBOL(__tracedata_end) = . ASM_NL		\
 	}
 #else
 #define TRACEDATA
@@ -605,24 +607,24 @@
 
 #define NOTES								\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
-		VMLINUX_SYMBOL(__start_notes) = .;			\
+		VMLINUX_SYMBOL(__start_notes) = . ASM_NL		\
 		*(.note.*)						\
-		VMLINUX_SYMBOL(__stop_notes) = .;			\
+		VMLINUX_SYMBOL(__stop_notes) = . ASM_NL			\
 	}
 
 #define INIT_SETUP(initsetup_align)					\
-		. = ALIGN(initsetup_align);				\
-		VMLINUX_SYMBOL(__setup_start) = .;			\
+		. = ALIGN(initsetup_align) ASM_NL			\
+		VMLINUX_SYMBOL(__setup_start) = . ASM_NL		\
 		*(.init.setup)						\
-		VMLINUX_SYMBOL(__setup_end) = .;
+		VMLINUX_SYMBOL(__setup_end) = . ASM_NL
 
 #define INIT_CALLS_LEVEL(level)						\
-		VMLINUX_SYMBOL(__initcall##level##_start) = .;		\
+		VMLINUX_SYMBOL(__initcall##level##_start) = . ASM_NL	\
 		*(.initcall##level##.init)				\
 		*(.initcall##level##s.init)				\
 
 #define INIT_CALLS							\
-		VMLINUX_SYMBOL(__initcall_start) = .;			\
+		VMLINUX_SYMBOL(__initcall_start) = . ASM_NL		\
 		*(.initcallearly.init)					\
 		INIT_CALLS_LEVEL(0)					\
 		INIT_CALLS_LEVEL(1)					\
@@ -633,24 +635,24 @@
 		INIT_CALLS_LEVEL(rootfs)				\
 		INIT_CALLS_LEVEL(6)					\
 		INIT_CALLS_LEVEL(7)					\
-		VMLINUX_SYMBOL(__initcall_end) = .;
+		VMLINUX_SYMBOL(__initcall_end) = . ASM_NL
 
 #define CON_INITCALL							\
-		VMLINUX_SYMBOL(__con_initcall_start) = .;		\
+		VMLINUX_SYMBOL(__con_initcall_start) = . ASM_NL		\
 		*(.con_initcall.init)					\
-		VMLINUX_SYMBOL(__con_initcall_end) = .;
+		VMLINUX_SYMBOL(__con_initcall_end) = . ASM_NL
 
 #define SECURITY_INITCALL						\
-		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
+		VMLINUX_SYMBOL(__security_initcall_start) = . ASM_NL	\
 		*(.security_initcall.init)				\
-		VMLINUX_SYMBOL(__security_initcall_end) = .;
+		VMLINUX_SYMBOL(__security_initcall_end) = . ASM_NL
 
 #ifdef CONFIG_BLK_DEV_INITRD
 #define INIT_RAM_FS							\
-	. = ALIGN(4);							\
-	VMLINUX_SYMBOL(__initramfs_start) = .;				\
+	. = ALIGN(4) ASM_NL						\
+	VMLINUX_SYMBOL(__initramfs_start) = . ASM_NL			\
 	*(.init.ramfs)							\
-	. = ALIGN(8);							\
+	. = ALIGN(8) ASM_NL						\
 	*(.init.ramfs.info)
 #else
 #define INIT_RAM_FS
@@ -685,16 +687,16 @@
  * sharing between subsections for different purposes.
  */
 #define PERCPU_INPUT(cacheline)						\
-	VMLINUX_SYMBOL(__per_cpu_start) = .;				\
+	VMLINUX_SYMBOL(__per_cpu_start) = . ASM_NL			\
 	*(.data..percpu..first)						\
-	. = ALIGN(PAGE_SIZE);						\
+	. = ALIGN(PAGE_SIZE) ASM_NL					\
 	*(.data..percpu..page_aligned)					\
-	. = ALIGN(cacheline);						\
+	. = ALIGN(cacheline) ASM_NL					\
 	*(.data..percpu..readmostly)					\
-	. = ALIGN(cacheline);						\
+	. = ALIGN(cacheline) ASM_NL					\
 	*(.data..percpu)						\
 	*(.data..percpu..shared_aligned)				\
-	VMLINUX_SYMBOL(__per_cpu_end) = .;
+	VMLINUX_SYMBOL(__per_cpu_end) = . ASM_NL
 
 /**
  * PERCPU_VADDR - define output section for percpu area
@@ -721,12 +723,12 @@
  * address, use PERCPU_SECTION.
  */
 #define PERCPU_VADDR(cacheline, vaddr, phdr)				\
-	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
+	VMLINUX_SYMBOL(__per_cpu_load) = . ASM_NL			\
 	.data..percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
 				- LOAD_OFFSET) {			\
 		PERCPU_INPUT(cacheline)					\
 	} phdr								\
-	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data..percpu);
+	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data..percpu) ASM_NL
 
 /**
  * PERCPU_SECTION - define output section for percpu area, simple version
@@ -741,9 +743,9 @@
  * .data..percpu which is required for relocatable x86_32 configuration.
  */
 #define PERCPU_SECTION(cacheline)					\
-	. = ALIGN(PAGE_SIZE);						\
+	. = ALIGN(PAGE_SIZE) ASM_NL					\
 	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
-		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
+		VMLINUX_SYMBOL(__per_cpu_load) = . ASM_NL		\
 		PERCPU_INPUT(cacheline)					\
 	}
 
@@ -767,7 +769,7 @@
  *
  * use 0 as page_align if page_aligned data is not used */
 #define RW_DATA_SECTION(cacheline, pagealigned, inittask)		\
-	. = ALIGN(PAGE_SIZE);						\
+	. = ALIGN(PAGE_SIZE) ASM_NL					\
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {				\
 		INIT_TASK_DATA(inittask)				\
 		NOSAVE_DATA						\
@@ -779,11 +781,11 @@
 	}
 
 #define INIT_TEXT_SECTION(inittext_align)				\
-	. = ALIGN(inittext_align);					\
+	. = ALIGN(inittext_align) ASM_NL				\
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {		\
-		VMLINUX_SYMBOL(_sinittext) = .;				\
+		VMLINUX_SYMBOL(_sinittext) = . ASM_NL			\
 		INIT_TEXT						\
-		VMLINUX_SYMBOL(_einittext) = .;				\
+		VMLINUX_SYMBOL(_einittext) = . ASM_NL			\
 	}
 
 #define INIT_DATA_SECTION(initsetup_align)				\
@@ -797,9 +799,9 @@
 	}
 
 #define BSS_SECTION(sbss_align, bss_align, stop_align)			\
-	. = ALIGN(sbss_align);						\
-	VMLINUX_SYMBOL(__bss_start) = .;				\
+	. = ALIGN(sbss_align) ASM_NL					\
+	VMLINUX_SYMBOL(__bss_start) = . ASM_NL				\
 	SBSS(sbss_align)						\
 	BSS(bss_align)							\
-	. = ALIGN(stop_align);						\
-	VMLINUX_SYMBOL(__bss_stop) = .;
+	. = ALIGN(stop_align) ASM_NL					\
+	VMLINUX_SYMBOL(__bss_stop) = . ASM_NL
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index d3e8ad2..a6a42dd 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -6,6 +6,11 @@
 #include <linux/export.h>
 #include <asm/linkage.h>
 
+/* Some toolchains use other characters (e.g. '`') to mark new line in macro */
+#ifndef ASM_NL
+#define ASM_NL		 ;
+#endif
+
 #ifdef __cplusplus
 #define CPP_ASMLINKAGE extern "C"
 #else
@@ -75,21 +80,21 @@
 
 #ifndef ENTRY
 #define ENTRY(name) \
-  .globl name; \
-  ALIGN; \
-  name:
+	.globl name ASM_NL \
+	ALIGN ASM_NL \
+	name:
 #endif
 #endif /* LINKER_SCRIPT */
 
 #ifndef WEAK
 #define WEAK(name)	   \
-	.weak name;	   \
+	.weak name ASM_NL   \
 	name:
 #endif
 
 #ifndef END
 #define END(name) \
-  .size name, .-name
+	.size name, .-name
 #endif
 
 /* If symbol 'name' is treated as a subroutine (gets called, and returns)
@@ -98,8 +103,8 @@
  */
 #ifndef ENDPROC
 #define ENDPROC(name) \
-  .type name, @function; \
-  END(name)
+	.type name, @function ASM_NL \
+	END(name)
 #endif
 
 #endif
-- 
1.7.7.6
