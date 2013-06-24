Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3FXTk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:40:59 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53983 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3FXTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 02/32] modpost: remove all traces of cpuinit/cpuexit sections
Date: Mon, 24 Jun 2013 15:30:07 -0400
Message-ID: <1372102237-8757-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete all audit rules that were checking how the .cpuXYZ
related sections were inter-operating with other __init
like sections, now that __cpuinit is gone.  Update the linker
script to not have any knowledge of .cpuinit sections.

[lds.h update courtesy of Ralf Baechle <ralf@linux-mips.org>]

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 include/asm-generic/vmlinux.lds.h | 12 ---------
 scripts/mod/modpost.c             | 52 +++++++--------------------------------
 2 files changed, 9 insertions(+), 55 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 4f27372..796f470 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -174,8 +174,6 @@
 	*(.data)							\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
-	CPU_KEEP(init.data)						\
-	CPU_KEEP(exit.data)						\
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
 	*(.data.unlikely)						\
@@ -362,8 +360,6 @@
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
-		CPU_KEEP(init.rodata)					\
-		CPU_KEEP(exit.rodata)					\
 		MEM_KEEP(init.rodata)					\
 		MEM_KEEP(exit.rodata)					\
 	}								\
@@ -404,8 +400,6 @@
 		*(.text.hot)						\
 		*(.text)						\
 		*(.ref.text)						\
-	CPU_KEEP(init.text)						\
-	CPU_KEEP(exit.text)						\
 	MEM_KEEP(init.text)						\
 	MEM_KEEP(exit.text)						\
 		*(.text.unlikely)
@@ -489,14 +483,12 @@
 /* init and exit section handling */
 #define INIT_DATA							\
 	*(.init.data)							\
-	CPU_DISCARD(init.data)						\
 	MEM_DISCARD(init.data)						\
 	KERNEL_CTORS()							\
 	MCOUNT_REC()							\
 	*(.init.rodata)							\
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()						\
-	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.rodata)					\
 	CLK_OF_TABLES()							\
 	CLKSRC_OF_TABLES()						\
@@ -505,19 +497,15 @@
 
 #define INIT_TEXT							\
 	*(.init.text)							\
-	CPU_DISCARD(init.text)						\
 	MEM_DISCARD(init.text)
 
 #define EXIT_DATA							\
 	*(.exit.data)							\
-	CPU_DISCARD(exit.data)						\
-	CPU_DISCARD(exit.rodata)					\
 	MEM_DISCARD(exit.data)						\
 	MEM_DISCARD(exit.rodata)
 
 #define EXIT_TEXT							\
 	*(.exit.text)							\
-	CPU_DISCARD(exit.text)						\
 	MEM_DISCARD(exit.text)
 
 #define EXIT_CALL							\
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 3d155dd..6216434 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -861,24 +861,23 @@ static void check_section(const char *modname, struct elf_info *elf,
 
 
 #define ALL_INIT_DATA_SECTIONS \
-	".init.setup$", ".init.rodata$", \
-	".cpuinit.rodata$", ".meminit.rodata$", \
-	".init.data$", ".cpuinit.data$", ".meminit.data$"
+	".init.setup$", ".init.rodata$", ".meminit.rodata$", \
+	".init.data$", ".meminit.data$"
 #define ALL_EXIT_DATA_SECTIONS \
-	".exit.data$", ".cpuexit.data$", ".memexit.data$"
+	".exit.data$", ".memexit.data$"
 
 #define ALL_INIT_TEXT_SECTIONS \
-	".init.text$", ".cpuinit.text$", ".meminit.text$"
+	".init.text$", ".meminit.text$"
 #define ALL_EXIT_TEXT_SECTIONS \
-	".exit.text$", ".cpuexit.text$", ".memexit.text$"
+	".exit.text$", ".memexit.text$"
 
 #define ALL_PCI_INIT_SECTIONS	\
 	".pci_fixup_early$", ".pci_fixup_header$", ".pci_fixup_final$", \
 	".pci_fixup_enable$", ".pci_fixup_resume$", \
 	".pci_fixup_resume_early$", ".pci_fixup_suspend$"
 
-#define ALL_XXXINIT_SECTIONS CPU_INIT_SECTIONS, MEM_INIT_SECTIONS
-#define ALL_XXXEXIT_SECTIONS CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS
+#define ALL_XXXINIT_SECTIONS MEM_INIT_SECTIONS
+#define ALL_XXXEXIT_SECTIONS MEM_EXIT_SECTIONS
 
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
 #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
@@ -887,11 +886,9 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define TEXT_SECTIONS ".text$", ".text.unlikely$"
 
 #define INIT_SECTIONS      ".init.*"
-#define CPU_INIT_SECTIONS  ".cpuinit.*"
 #define MEM_INIT_SECTIONS  ".meminit.*"
 
 #define EXIT_SECTIONS      ".exit.*"
-#define CPU_EXIT_SECTIONS  ".cpuexit.*"
 #define MEM_EXIT_SECTIONS  ".memexit.*"
 
 /* init data sections */
@@ -979,48 +976,20 @@ const struct sectioncheck sectioncheck[] = {
 	.mismatch = DATA_TO_ANY_EXIT,
 	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
-/* Do not reference init code/data from cpuinit/meminit code/data */
+/* Do not reference init code/data from meminit code/data */
 {
 	.fromsec = { ALL_XXXINIT_SECTIONS, NULL },
 	.tosec   = { INIT_SECTIONS, NULL },
 	.mismatch = XXXINIT_TO_SOME_INIT,
 	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
-/* Do not reference cpuinit code/data from meminit code/data */
-{
-	.fromsec = { MEM_INIT_SECTIONS, NULL },
-	.tosec   = { CPU_INIT_SECTIONS, NULL },
-	.mismatch = XXXINIT_TO_SOME_INIT,
-	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
-},
-/* Do not reference meminit code/data from cpuinit code/data */
-{
-	.fromsec = { CPU_INIT_SECTIONS, NULL },
-	.tosec   = { MEM_INIT_SECTIONS, NULL },
-	.mismatch = XXXINIT_TO_SOME_INIT,
-	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
-},
-/* Do not reference exit code/data from cpuexit/memexit code/data */
+/* Do not reference exit code/data from memexit code/data */
 {
 	.fromsec = { ALL_XXXEXIT_SECTIONS, NULL },
 	.tosec   = { EXIT_SECTIONS, NULL },
 	.mismatch = XXXEXIT_TO_SOME_EXIT,
 	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
-/* Do not reference cpuexit code/data from memexit code/data */
-{
-	.fromsec = { MEM_EXIT_SECTIONS, NULL },
-	.tosec   = { CPU_EXIT_SECTIONS, NULL },
-	.mismatch = XXXEXIT_TO_SOME_EXIT,
-	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
-},
-/* Do not reference memexit code/data from cpuexit code/data */
-{
-	.fromsec = { CPU_EXIT_SECTIONS, NULL },
-	.tosec   = { MEM_EXIT_SECTIONS, NULL },
-	.mismatch = XXXEXIT_TO_SOME_EXIT,
-	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
-},
 /* Do not use exit code/data from init code */
 {
 	.fromsec = { ALL_INIT_SECTIONS, NULL },
@@ -1089,8 +1058,6 @@ static const struct sectioncheck *section_mismatch(
  * Pattern 2:
  *   Many drivers utilise a *driver container with references to
  *   add, remove, probe functions etc.
- *   These functions may often be marked __cpuinit and we do not want to
- *   warn here.
  *   the pattern is identified by:
  *   tosec   = init or exit section
  *   fromsec = data section
@@ -1249,7 +1216,6 @@ static Elf_Sym *find_elf_symbol2(struct elf_info *elf, Elf_Addr addr,
 /*
  * Convert a section name to the function/data attribute
  * .init.text => __init
- * .cpuinit.data => __cpudata
  * .memexitconst => __memconst
  * etc.
  *
-- 
1.8.1.2

