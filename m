Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbbAZM5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:57:24 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:51246 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbbAZMzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:55:05 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Dominik Vogt <vogt@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 3/3] s390/ftrace: hotpatch support for function tracing
Date: Mon, 26 Jan 2015 13:54:54 +0100
Message-Id: <1422276894-31302-4-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012612-0041-0000-0000-000003069DF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of gcc's hotpatch support to generate better code for ftrace
function tracing.
The generated code now contains only a six byte nop in each function
prologue instead of a 24 byte code block which will be runtime patched to
support function tracing.
With the new code generation the runtime overhead for supporting function
tracing is close to zero, while the original code did show a significant
performance impact.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig              |  1 -
 arch/s390/Makefile             | 10 ++++++++++
 arch/s390/include/asm/ftrace.h | 15 +++++++++++++++
 arch/s390/kernel/Makefile      |  4 ++--
 arch/s390/kernel/ftrace.c      | 15 ++++++++++++++-
 arch/s390/kernel/kprobes.c     |  3 ++-
 arch/s390/kernel/mcount.S      |  2 ++
 scripts/recordmcount.pl        |  9 +++++++--
 8 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 7eba5b5723e9..8d11babf9aa5 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -117,7 +117,6 @@ config S390
 	select HAVE_BPF_JIT if 64BIT && PACK_STACK
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_CMPXCHG_LOCAL
-	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DYNAMIC_FTRACE if 64BIT
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS if 64BIT
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index e742ec5de9a7..acb6859c6a95 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -87,6 +87,16 @@ ifeq ($(call cc-option-yn,-mwarn-dynamicstack),y)
 cflags-$(CONFIG_WARN_DYNAMIC_STACK) += -mwarn-dynamicstack
 endif
 
+ifdef CONFIG_FUNCTION_TRACER
+# make use of hotpatch feature if the compiler supports it
+cc_hotpatch	:= -mhotpatch=0,3
+ifeq ($(call cc-option-yn,$(cc_hotpatch)),y)
+CC_FLAGS_FTRACE := $(cc_hotpatch)
+KBUILD_AFLAGS	+= -DCC_USING_HOTPATCH
+KBUILD_CFLAGS	+= -DCC_USING_HOTPATCH
+endif
+endif
+
 KBUILD_CFLAGS	+= -mbackchain -msoft-float $(cflags-y)
 KBUILD_CFLAGS	+= -pipe -fno-strength-reduce -Wno-sign-compare
 KBUILD_AFLAGS	+= $(aflags-y)
diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index abb618f1ead2..836c56290499 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -3,8 +3,12 @@
 
 #define ARCH_SUPPORTS_FTRACE_OPS 1
 
+#ifdef CC_USING_HOTPATCH
+#define MCOUNT_INSN_SIZE	6
+#else
 #define MCOUNT_INSN_SIZE	24
 #define MCOUNT_RETURN_FIXUP	18
+#endif
 
 #ifndef __ASSEMBLY__
 
@@ -37,18 +41,29 @@ struct ftrace_insn {
 static inline void ftrace_generate_nop_insn(struct ftrace_insn *insn)
 {
 #ifdef CONFIG_FUNCTION_TRACER
+#ifdef CC_USING_HOTPATCH
+	/* brcl 0,0 */
+	insn->opc = 0xc004;
+	insn->disp = 0;
+#else
 	/* jg .+24 */
 	insn->opc = 0xc0f4;
 	insn->disp = MCOUNT_INSN_SIZE / 2;
 #endif
+#endif
 }
 
 static inline int is_ftrace_nop(struct ftrace_insn *insn)
 {
 #ifdef CONFIG_FUNCTION_TRACER
+#ifdef CC_USING_HOTPATCH
+	if (insn->disp == 0)
+		return 1;
+#else
 	if (insn->disp == MCOUNT_INSN_SIZE / 2)
 		return 1;
 #endif
+#endif
 	return 0;
 }
 
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 204c43a4c245..31fab2676fe9 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -4,8 +4,8 @@
 
 ifdef CONFIG_FUNCTION_TRACER
 # Don't trace early setup code and tracing code
-CFLAGS_REMOVE_early.o = -pg
-CFLAGS_REMOVE_ftrace.o = -pg
+CFLAGS_REMOVE_early.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_ftrace.o = $(CC_FLAGS_FTRACE)
 endif
 
 #
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 3dabcae40e04..82c19899574f 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -46,6 +46,13 @@
  *	lg	%r14,8(%r15)		# offset 18
  * The jg instruction branches to offset 24 to skip as many instructions
  * as possible.
+ * In case we use gcc's hotpatch feature the original and also the disabled
+ * function prologue contains only a single six byte instruction and looks
+ * like this:
+ * >	brcl	0,0			# offset 0
+ * To enable ftrace the code gets patched like above and afterwards looks
+ * like this:
+ * >	brasl	%r0,ftrace_caller	# offset 0
  */
 
 unsigned long ftrace_plt;
@@ -64,9 +71,15 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 	if (probe_kernel_read(&old, (void *) rec->ip, sizeof(old)))
 		return -EFAULT;
 	if (addr == MCOUNT_ADDR) {
-		/* Initial code replacement; we expect to see stg r14,8(r15) */
+		/* Initial code replacement */
+#ifdef CC_USING_HOTPATCH
+		/* We expect to see brcl 0,0 */
+		ftrace_generate_nop_insn(&orig);
+#else
+		/* We expect to see stg r14,8(r15) */
 		orig.opc = 0xe3e0;
 		orig.disp = 0xf0080024;
+#endif
 		ftrace_generate_nop_insn(&new);
 	} else if (old.opc == BREAKPOINT_INSTRUCTION) {
 		/*
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 1e4c710dfb92..f516edc1fbe3 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -69,7 +69,8 @@ static void copy_instruction(struct kprobe *p)
 		/*
 		 * If kprobes patches the instruction that is morphed by
 		 * ftrace make sure that kprobes always sees the branch
-		 * "jg .+24" that skips the mcount block
+		 * "jg .+24" that skips the mcount block or the "brcl 0,0"
+		 * in case of hotpatch.
 		 */
 		ftrace_generate_nop_insn((struct ftrace_insn *)p->ainsn.insn);
 		p->ainsn.is_ftrace_insn = 1;
diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index b6dfc5bfcb89..e499370fbccb 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -27,7 +27,9 @@ ENTRY(ftrace_caller)
 	.globl	ftrace_regs_caller
 	.set	ftrace_regs_caller,ftrace_caller
 	lgr	%r1,%r15
+#ifndef CC_USING_HOTPATCH
 	aghi	%r0,MCOUNT_RETURN_FIXUP
+#endif
 	aghi	%r15,-STACK_FRAME_SIZE
 	stg	%r1,__SF_BACKCHAIN(%r15)
 	stg	%r1,(STACK_PTREGS_GPRS+15*8)(%r15)
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 537c38ca2e1c..826470d7f000 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -242,8 +242,13 @@ if ($arch eq "x86_64") {
     $cc .= " -m32";
 
 } elsif ($arch eq "s390" && $bits == 64) {
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";
-    $mcount_adjust = -14;
+    if ($cc =~ /-DCC_USING_HOTPATCH/) {
+	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*brcl\\s*0,[0-9a-f]+ <([^\+]*)>\$";
+	$mcount_adjust = 0;
+    } else {
+	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";
+	$mcount_adjust = -14;
+    }
     $alignment = 8;
     $type = ".quad";
     $ld .= " -m elf64_s390";
-- 
2.1.4

