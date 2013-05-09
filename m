Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3EIJ7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:59:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48247 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab3EIJ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:59:43 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86: Extend #DF debugging aid to 64-bit
Date: Thu,  9 May 2013 12:02:29 +0200
Message-Id: <1368093749-31296-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It is sometimes very helpful to be able to pinpoint the location which
causes a double fault before it turns into a triple fault and the
machine reboots. We have this for 32-bit already so extend it to 64-bit.
On 64-bit we get the register snapshot at #DF time and not from the
first exception which actually causes the #DF. It should be close
enough, though.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Kconfig.debug                              |  1 -
 arch/x86/include/asm/processor.h                    |  2 +-
 arch/x86/kernel/Makefile                            |  2 +-
 arch/x86/kernel/{doublefault_32.c => doublefault.c} | 15 +++++++++++++++
 arch/x86/kernel/traps.c                             |  3 +++
 5 files changed, 20 insertions(+), 3 deletions(-)
 rename arch/x86/kernel/{doublefault_32.c => doublefault.c} (84%)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index c198b7e13e7b..b6a770132b67 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -122,7 +122,6 @@ config DEBUG_NX_TEST
 config DOUBLEFAULT
 	default y
 	bool "Enable doublefault exception handler" if EXPERT
-	depends on X86_32
 	---help---
 	  This option allows trapping of rare doublefault exceptions that
 	  would otherwise cause a system to silently reboot. Disabling this
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 22224b3b43bb..5b87d52eed0b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -981,5 +981,5 @@ bool xen_set_default_idle(void);
 #endif
 
 void stop_this_cpu(void *dummy);
-
+void df_debug(struct pt_regs *regs, long error_code);
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7bd3bd310106..acb3b031f711 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -67,7 +67,7 @@ obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-y				+= kprobes/
 obj-$(CONFIG_MODULES)		+= module.o
-obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
+obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault.c
similarity index 84%
rename from arch/x86/kernel/doublefault_32.c
rename to arch/x86/kernel/doublefault.c
index 155a13f33ed8..5d3fe8d36e4a 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault.c
@@ -9,6 +9,8 @@
 #include <asm/processor.h>
 #include <asm/desc.h>
 
+#ifdef CONFIG_X86_32
+
 #define DOUBLEFAULT_STACKSIZE (1024)
 static unsigned long doublefault_stack[DOUBLEFAULT_STACKSIZE];
 #define STACK_START (unsigned long)(doublefault_stack+DOUBLEFAULT_STACKSIZE)
@@ -67,3 +69,16 @@ struct tss_struct doublefault_tss __cacheline_aligned = {
 		.__cr3		= __pa_nodebug(swapper_pg_dir),
 	}
 };
+
+/* dummy for do_double_fault() call */
+void df_debug(struct pt_regs *regs, long error_code) {}
+
+#else /* !CONFIG_X86_32 */
+
+void df_debug(struct pt_regs *regs, long error_code)
+{
+	pr_emerg("PANIC: double fault, error_code: 0x%lx\n", error_code);
+	show_regs(regs);
+	panic("Machine halted.");
+}
+#endif
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 772e2a846dec..167d481c5fd3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -254,6 +254,9 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_nr = X86_TRAP_DF;
 
+#ifdef CONFIG_DOUBLEFAULT
+	df_debug(regs, error_code);
+#endif
 	/*
 	 * This is always a kernel trap and never fixable (and thus must
 	 * never return).
-- 
1.8.3.rc0

