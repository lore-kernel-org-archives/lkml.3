Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3GAKFC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:05:02 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64073 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GAKFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:05:00 -0400
Date: Mon, 1 Jul 2013 12:04:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v3.11
Message-ID: <20130701100456.GA17145@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

   HEAD: 719038de98bc8479b771c582a1e4a1e86079da22 x86/intel/cacheinfo: Shut up last long-standing warning

Two changes:

 - Extend 32-bit double fault debugging aid to 64-bit
 - Fix a build warning

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86: Extend #DF debugging aid to 64-bit
      x86/intel/cacheinfo: Shut up last long-standing warning


 arch/x86/Kconfig.debug                             |  1 -
 arch/x86/include/asm/processor.h                   |  2 +-
 arch/x86/kernel/Makefile                           |  2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              | 52 +++++++++++-----------
 .../x86/kernel/{doublefault_32.c => doublefault.c} | 15 +++++++
 arch/x86/kernel/traps.c                            |  3 ++
 6 files changed, 45 insertions(+), 30 deletions(-)
 rename arch/x86/kernel/{doublefault_32.c => doublefault.c} (84%)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index c198b7e..b6a7701 100644
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
index 22224b3..5b87d52 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -981,5 +981,5 @@ bool xen_set_default_idle(void);
 #endif
 
 void stop_this_cpu(void *dummy);
-
+void df_debug(struct pt_regs *regs, long error_code);
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7bd3bd3..4ce822e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -67,7 +67,7 @@ obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-y				+= kprobes/
 obj-$(CONFIG_MODULES)		+= module.o
-obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
+obj-$(CONFIG_DOUBLEFAULT)	+= doublefault.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 7c6f7d5..8dc72dd 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -618,36 +618,34 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 		 * parameters cpuid leaf to find the cache details
 		 */
 		for (i = 0; i < num_cache_leaves; i++) {
-			struct _cpuid4_info_regs this_leaf;
+			struct _cpuid4_info_regs this_leaf = {};
 			int retval;
 
 			retval = cpuid4_cache_lookup_regs(i, &this_leaf);
-			if (retval >= 0) {
-				switch (this_leaf.eax.split.level) {
-				case 1:
-					if (this_leaf.eax.split.type ==
-							CACHE_TYPE_DATA)
-						new_l1d = this_leaf.size/1024;
-					else if (this_leaf.eax.split.type ==
-							CACHE_TYPE_INST)
-						new_l1i = this_leaf.size/1024;
-					break;
-				case 2:
-					new_l2 = this_leaf.size/1024;
-					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
-					index_msb = get_count_order(num_threads_sharing);
-					l2_id = c->apicid & ~((1 << index_msb) - 1);
-					break;
-				case 3:
-					new_l3 = this_leaf.size/1024;
-					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
-					index_msb = get_count_order(
-							num_threads_sharing);
-					l3_id = c->apicid & ~((1 << index_msb) - 1);
-					break;
-				default:
-					break;
-				}
+			if (retval < 0)
+				continue;
+
+			switch (this_leaf.eax.split.level) {
+			case 1:
+				if (this_leaf.eax.split.type == CACHE_TYPE_DATA)
+					new_l1d = this_leaf.size/1024;
+				else if (this_leaf.eax.split.type == CACHE_TYPE_INST)
+					new_l1i = this_leaf.size/1024;
+				break;
+			case 2:
+				new_l2 = this_leaf.size/1024;
+				num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
+				index_msb = get_count_order(num_threads_sharing);
+				l2_id = c->apicid & ~((1 << index_msb) - 1);
+				break;
+			case 3:
+				new_l3 = this_leaf.size/1024;
+				num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
+				index_msb = get_count_order(num_threads_sharing);
+				l3_id = c->apicid & ~((1 << index_msb) - 1);
+				break;
+			default:
+				break;
 			}
 		}
 	}
diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault.c
similarity index 84%
rename from arch/x86/kernel/doublefault_32.c
rename to arch/x86/kernel/doublefault.c
index 155a13f..5d3fe8d 100644
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
index 772e2a8..167d481 100644
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
