Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3JMMBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 08:01:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43691 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3JMMBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 08:01:35 -0400
Date: Sun, 13 Oct 2013 05:01:22 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-dd78b97367bd575918204cc89107c1479d3fc1a7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381450698-28710-2-git-send-email-keescook@chromium.org>
References: <1381450698-28710-2-git-send-email-keescook@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, boot: Move CPU flags out of cpucheck
Git-Commit-ID: dd78b97367bd575918204cc89107c1479d3fc1a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 13 Oct 2013 05:01:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd78b97367bd575918204cc89107c1479d3fc1a7
Gitweb:     http://git.kernel.org/tip/dd78b97367bd575918204cc89107c1479d3fc1a7
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 10 Oct 2013 17:18:13 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 13 Oct 2013 03:12:02 -0700

x86, boot: Move CPU flags out of cpucheck

Refactor the CPU flags handling out of the cpucheck routines so that
they can be reused by the future ASLR routines (in order to detect CPU
features like RDRAND and RDTSC).

This reworks has_eflag() and has_fpu() to be used on both 32-bit and
64-bit, and refactors the calls to cpuid to make them PIC-safe on 32-bit.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/1381450698-28710-2-git-send-email-keescook@chromium.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/Makefile              |   2 +-
 arch/x86/boot/boot.h                |  10 +---
 arch/x86/boot/compressed/Makefile   |   2 +-
 arch/x86/boot/compressed/cpuflags.c |  12 +++++
 arch/x86/boot/cpucheck.c            |  86 -----------------------------
 arch/x86/boot/cpuflags.c            | 104 ++++++++++++++++++++++++++++++++++++
 arch/x86/boot/cpuflags.h            |  19 +++++++
 7 files changed, 138 insertions(+), 97 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 379814b..0da2e37 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -20,7 +20,7 @@ targets		:= vmlinux.bin setup.bin setup.elf bzImage
 targets		+= fdimage fdimage144 fdimage288 image.iso mtools.conf
 subdir-		:= compressed
 
-setup-y		+= a20.o bioscall.o cmdline.o copy.o cpu.o cpucheck.o
+setup-y		+= a20.o bioscall.o cmdline.o copy.o cpu.o cpuflags.o cpucheck.o
 setup-y		+= early_serial_console.o edd.o header.o main.o mca.o memory.o
 setup-y		+= pm.o pmjump.o printf.o regs.o string.o tty.o video.o
 setup-y		+= video-mode.o version.o
diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index ef72bae..50f8c5e 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -26,9 +26,8 @@
 #include <asm/boot.h>
 #include <asm/setup.h>
 #include "bitops.h"
-#include <asm/cpufeature.h>
-#include <asm/processor-flags.h>
 #include "ctype.h"
+#include "cpuflags.h"
 
 /* Useful macros */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
@@ -307,14 +306,7 @@ static inline int cmdline_find_option_bool(const char *option)
 	return __cmdline_find_option_bool(cmd_line_ptr, option);
 }
 
-
 /* cpu.c, cpucheck.c */
-struct cpu_features {
-	int level;		/* Family, or 64 for x86-64 */
-	int model;
-	u32 flags[NCAPINTS];
-};
-extern struct cpu_features cpu;
 int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr);
 int validate_cpu(void);
 
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index dcd90df..3312f1b 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -27,7 +27,7 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
-	$(obj)/piggy.o
+	$(obj)/piggy.o $(obj)/cpuflags.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
diff --git a/arch/x86/boot/compressed/cpuflags.c b/arch/x86/boot/compressed/cpuflags.c
new file mode 100644
index 0000000..931cba6
--- /dev/null
+++ b/arch/x86/boot/compressed/cpuflags.c
@@ -0,0 +1,12 @@
+#ifdef CONFIG_RANDOMIZE_BASE
+
+#include "../cpuflags.c"
+
+bool has_cpuflag(int flag)
+{
+	get_flags();
+
+	return test_bit(flag, cpu.flags);
+}
+
+#endif
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 4d3ff03..e1f3c16 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -28,8 +28,6 @@
 #include <asm/required-features.h>
 #include <asm/msr-index.h>
 
-struct cpu_features cpu;
-static u32 cpu_vendor[3];
 static u32 err_flags[NCAPINTS];
 
 static const int req_level = CONFIG_X86_MINIMUM_CPU_FAMILY;
@@ -69,90 +67,6 @@ static int is_transmeta(void)
 	       cpu_vendor[2] == A32('M', 'x', '8', '6');
 }
 
-static int has_fpu(void)
-{
-	u16 fcw = -1, fsw = -1;
-	u32 cr0;
-
-	asm("movl %%cr0,%0" : "=r" (cr0));
-	if (cr0 & (X86_CR0_EM|X86_CR0_TS)) {
-		cr0 &= ~(X86_CR0_EM|X86_CR0_TS);
-		asm volatile("movl %0,%%cr0" : : "r" (cr0));
-	}
-
-	asm volatile("fninit ; fnstsw %0 ; fnstcw %1"
-		     : "+m" (fsw), "+m" (fcw));
-
-	return fsw == 0 && (fcw & 0x103f) == 0x003f;
-}
-
-static int has_eflag(u32 mask)
-{
-	u32 f0, f1;
-
-	asm("pushfl ; "
-	    "pushfl ; "
-	    "popl %0 ; "
-	    "movl %0,%1 ; "
-	    "xorl %2,%1 ; "
-	    "pushl %1 ; "
-	    "popfl ; "
-	    "pushfl ; "
-	    "popl %1 ; "
-	    "popfl"
-	    : "=&r" (f0), "=&r" (f1)
-	    : "ri" (mask));
-
-	return !!((f0^f1) & mask);
-}
-
-static void get_flags(void)
-{
-	u32 max_intel_level, max_amd_level;
-	u32 tfms;
-
-	if (has_fpu())
-		set_bit(X86_FEATURE_FPU, cpu.flags);
-
-	if (has_eflag(X86_EFLAGS_ID)) {
-		asm("cpuid"
-		    : "=a" (max_intel_level),
-		      "=b" (cpu_vendor[0]),
-		      "=d" (cpu_vendor[1]),
-		      "=c" (cpu_vendor[2])
-		    : "a" (0));
-
-		if (max_intel_level >= 0x00000001 &&
-		    max_intel_level <= 0x0000ffff) {
-			asm("cpuid"
-			    : "=a" (tfms),
-			      "=c" (cpu.flags[4]),
-			      "=d" (cpu.flags[0])
-			    : "a" (0x00000001)
-			    : "ebx");
-			cpu.level = (tfms >> 8) & 15;
-			cpu.model = (tfms >> 4) & 15;
-			if (cpu.level >= 6)
-				cpu.model += ((tfms >> 16) & 0xf) << 4;
-		}
-
-		asm("cpuid"
-		    : "=a" (max_amd_level)
-		    : "a" (0x80000000)
-		    : "ebx", "ecx", "edx");
-
-		if (max_amd_level >= 0x80000001 &&
-		    max_amd_level <= 0x8000ffff) {
-			u32 eax = 0x80000001;
-			asm("cpuid"
-			    : "+a" (eax),
-			      "=c" (cpu.flags[6]),
-			      "=d" (cpu.flags[1])
-			    : : "ebx");
-		}
-	}
-}
-
 /* Returns a bitmask of which words we have error bits in */
 static int check_flags(void)
 {
diff --git a/arch/x86/boot/cpuflags.c b/arch/x86/boot/cpuflags.c
new file mode 100644
index 0000000..b02544a
--- /dev/null
+++ b/arch/x86/boot/cpuflags.c
@@ -0,0 +1,104 @@
+#include <linux/types.h>
+#include "bitops.h"
+
+#include <asm/processor-flags.h>
+#include <asm/required-features.h>
+#include <asm/msr-index.h>
+#include "cpuflags.h"
+
+struct cpu_features cpu;
+u32 cpu_vendor[3];
+
+static bool loaded_flags;
+
+static int has_fpu(void)
+{
+	u16 fcw = -1, fsw = -1;
+	unsigned long cr0;
+
+	asm volatile("mov %%cr0,%0" : "=r" (cr0));
+	if (cr0 & (X86_CR0_EM|X86_CR0_TS)) {
+		cr0 &= ~(X86_CR0_EM|X86_CR0_TS);
+		asm volatile("mov %0,%%cr0" : : "r" (cr0));
+	}
+
+	asm volatile("fninit ; fnstsw %0 ; fnstcw %1"
+		     : "+m" (fsw), "+m" (fcw));
+
+	return fsw == 0 && (fcw & 0x103f) == 0x003f;
+}
+
+int has_eflag(unsigned long mask)
+{
+	unsigned long f0, f1;
+
+	asm volatile("pushf	\n\t"
+		     "pushf	\n\t"
+		     "pop %0	\n\t"
+		     "mov %0,%1	\n\t"
+		     "xor %2,%1	\n\t"
+		     "push %1	\n\t"
+		     "popf	\n\t"
+		     "pushf	\n\t"
+		     "pop %1	\n\t"
+		     "popf"
+		     : "=&r" (f0), "=&r" (f1)
+		     : "ri" (mask));
+
+	return !!((f0^f1) & mask);
+}
+
+/* Handle x86_32 PIC using ebx. */
+#if defined(__i386__) && defined(__PIC__)
+# define EBX_REG "=r"
+#else
+# define EBX_REG "=b"
+#endif
+
+static inline void cpuid(u32 id, u32 *a, u32 *b, u32 *c, u32 *d)
+{
+	asm volatile(".ifnc %%ebx,%3 ; movl  %%ebx,%3 ; .endif	\n\t"
+		     "cpuid					\n\t"
+		     ".ifnc %%ebx,%3 ; xchgl %%ebx,%3 ; .endif	\n\t"
+		    : "=a" (*a), "=c" (*c), "=d" (*d), EBX_REG (*b)
+		    : "a" (id)
+	);
+}
+
+void get_flags(void)
+{
+	u32 max_intel_level, max_amd_level;
+	u32 tfms;
+	u32 ignored;
+
+	if (loaded_flags)
+		return;
+	loaded_flags = true;
+
+	if (has_fpu())
+		set_bit(X86_FEATURE_FPU, cpu.flags);
+
+	if (has_eflag(X86_EFLAGS_ID)) {
+		cpuid(0x0, &max_intel_level, &cpu_vendor[0], &cpu_vendor[2],
+		      &cpu_vendor[1]);
+
+		if (max_intel_level >= 0x00000001 &&
+		    max_intel_level <= 0x0000ffff) {
+			cpuid(0x1, &tfms, &ignored, &cpu.flags[4],
+			      &cpu.flags[0]);
+			cpu.level = (tfms >> 8) & 15;
+			cpu.model = (tfms >> 4) & 15;
+			if (cpu.level >= 6)
+				cpu.model += ((tfms >> 16) & 0xf) << 4;
+		}
+
+		cpuid(0x80000000, &max_amd_level, &ignored, &ignored,
+		      &ignored);
+
+		if (max_amd_level >= 0x80000001 &&
+		    max_amd_level <= 0x8000ffff) {
+			cpuid(0x80000001, &ignored, &ignored, &cpu.flags[6],
+			      &cpu.flags[1]);
+		}
+	}
+}
diff --git a/arch/x86/boot/cpuflags.h b/arch/x86/boot/cpuflags.h
new file mode 100644
index 0000000..9bb4e25
--- /dev/null
+++ b/arch/x86/boot/cpuflags.h
@@ -0,0 +1,19 @@
+#ifndef BOOT_CPUFLAGS_H
+#define BOOT_CPUFLAGS_H
+
+#include <asm/cpufeature.h>
+#include <asm/processor-flags.h>
+
+struct cpu_features {
+	int level;		/* Family, or 64 for x86-64 */
+	int model;
+	u32 flags[NCAPINTS];
+};
+
+extern struct cpu_features cpu;
+extern u32 cpu_vendor[3];
+
+int has_eflag(unsigned long mask);
+void get_flags(void);
+
+#endif
