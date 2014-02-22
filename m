Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaBVVGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 16:06:41 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41860 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaBVVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 16:06:40 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 22 Feb 2014 13:06:29 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>,
        Feng Tang <feng.tang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Jacob Shin <jacob.shin@amd.com>,
        Jan Beulich <JBeulich@suse.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>, Rob Landley <rob@landley.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH v3 2/2] x86: Support compiling out human-friendly processor
 feature names
Message-ID: <a1e8c9861230c5215284b1219e0b31b3b75d1ba0.1393103020.git.josh@joshtriplett.org>
References: <296de15c8addece6dada4ddac982b3934d8ff6fa.1393098813.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <296de15c8addece6dada4ddac982b3934d8ff6fa.1393098813.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The table mapping CPUID bits to human-readable strings takes up a
non-trivial amount of space, and only exists to support /proc/cpuinfo
and a couple of kernel messages.  Since programs depend on the format of
/proc/cpuinfo, force inclusion of the table when building with /proc
support; otherwise, support omitting that table to save space, in which
case the kernel messages will print features numerically instead.

In addition to saving 1408 bytes out of vmlinux, this also saves 1373
bytes out of the uncompressed setup code, which contributes directly to
the size of bzImage.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v3: Fix build issue for clean builds, introduced in v2.

v2: Incorporate feedback from H. Peter Anvin:
    - Remove unnecessary ifdefs.
    - Print numeric feature flags in word:bit form.

 arch/x86/Kconfig                  | 12 +++++++
 arch/x86/boot/Makefile            |  7 ++--
 arch/x86/boot/cpu.c               | 68 +++++++++++++++++++++++----------------
 arch/x86/include/asm/cpufeature.h |  7 ++++
 arch/x86/kernel/cpu/Makefile      |  3 +-
 arch/x86/kernel/cpu/common.c      |  4 +--
 6 files changed, 69 insertions(+), 32 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..4dfdbdc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -127,6 +127,7 @@ config X86
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
 	select HAVE_CC_STACKPROTECTOR
+	select X86_FEATURE_NAMES if PROC_FS
 
 config INSTRUCTION_DECODER
 	def_bool y
@@ -304,6 +305,17 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config X86_FEATURE_NAMES
+	bool "Processor feature human-readable names"
+	default y
+	---help---
+	  This option compiles in a table of x86 feature bits and corresponding
+	  names.  This is required to support /proc/cpuinfo and a few kernel
+	  messages.  You can disable this to save space, at the expense of
+	  making those few kernel messages show numeric feature bits instead.
+
+	  If in doubt, say Y.
+
 config X86_X2APIC
 	bool "Support x2apic"
 	depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 878df7e..ce72b48 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -35,17 +35,20 @@ setup-y		+= video-vesa.o
 setup-y		+= video-bios.o
 
 targets		+= $(setup-y)
-hostprogs-y	:= mkcpustr tools/build
+hostprogs-y	:= tools/build
+hostprogs-$(CONFIG_X86_FEATURE_NAMES) += mkcpustr
 
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include \
 		    -include include/generated/autoconf.h \
 	            -D__EXPORTED_HEADERS__
 
+ifdef CONFIG_X86_FEATURE_NAMES
 $(obj)/cpu.o: $(obj)/cpustr.h
+endif
 
 quiet_cmd_cpustr = CPUSTR  $@
       cmd_cpustr = $(obj)/mkcpustr > $@
-targets		+= cpustr.h
+targets-$(CONFIG_X86_FEATURE_NAMES) += cpustr.h
 $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 	$(call if_changed,cpustr)
 
diff --git a/arch/x86/boot/cpu.c b/arch/x86/boot/cpu.c
index 6ec6bb6..29207f6 100644
--- a/arch/x86/boot/cpu.c
+++ b/arch/x86/boot/cpu.c
@@ -16,7 +16,9 @@
  */
 
 #include "boot.h"
+#ifdef CONFIG_X86_FEATURE_NAMES
 #include "cpustr.h"
+#endif
 
 static char *cpu_name(int level)
 {
@@ -32,11 +34,48 @@ static char *cpu_name(int level)
 	}
 }
 
+static void show_cap_strs(u32 *err_flags)
+{
+	int i, j;
+#ifdef CONFIG_X86_FEATURE_NAMES
+	const unsigned char *msg_strs = (const unsigned char *)x86_cap_strs;
+	for (i = 0; i < NCAPINTS; i++) {
+		u32 e = err_flags[i];
+		for (j = 0; j < 32; j++) {
+			if (msg_strs[0] < i ||
+			    (msg_strs[0] == i && msg_strs[1] < j)) {
+				/* Skip to the next string */
+				msg_strs += 2;
+				while (*msg_strs++)
+					;
+			}
+			if (e & 1) {
+				if (msg_strs[0] == i &&
+				    msg_strs[1] == j &&
+				    msg_strs[2])
+					printf("%s ", msg_strs+2);
+				else
+					printf("%d:%d ", i, j);
+			}
+			e >>= 1;
+		}
+	}
+#else
+	for (i = 0; i < NCAPINTS; i++) {
+		u32 e = err_flags[i];
+		for (j = 0; j < 32; j++) {
+			if (e & 1)
+				printf("%d:%d ", i, j);
+			e >>= 1;
+		}
+	}
+#endif
+}
+
 int validate_cpu(void)
 {
 	u32 *err_flags;
 	int cpu_level, req_level;
-	const unsigned char *msg_strs;
 
 	check_cpu(&cpu_level, &req_level, &err_flags);
 
@@ -49,34 +88,9 @@ int validate_cpu(void)
 	}
 
 	if (err_flags) {
-		int i, j;
 		puts("This kernel requires the following features "
 		     "not present on the CPU:\n");
-
-		msg_strs = (const unsigned char *)x86_cap_strs;
-
-		for (i = 0; i < NCAPINTS; i++) {
-			u32 e = err_flags[i];
-
-			for (j = 0; j < 32; j++) {
-				if (msg_strs[0] < i ||
-				    (msg_strs[0] == i && msg_strs[1] < j)) {
-					/* Skip to the next string */
-					msg_strs += 2;
-					while (*msg_strs++)
-						;
-				}
-				if (e & 1) {
-					if (msg_strs[0] == i &&
-					    msg_strs[1] == j &&
-					    msg_strs[2])
-						printf("%s ", msg_strs+2);
-					else
-						printf("%d:%d ", i, j);
-				}
-				e >>= 1;
-			}
-		}
+		show_cap_strs(err_flags);
 		putchar('\n');
 		return -1;
 	} else {
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e099f95..75bc12b 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -237,8 +237,15 @@
 #include <asm/asm.h>
 #include <linux/bitops.h>
 
+#ifdef CONFIG_X86_FEATURE_NAMES
 extern const char * const x86_cap_flags[NCAPINTS*32];
 extern const char * const x86_power_flags[32];
+#define X86_CAP_FMT "%s"
+#define x86_cap_flag(flag) x86_cap_flags[flag]
+#else
+#define X86_CAP_FMT "%d:%d"
+#define x86_cap_flag(flag) ((flag) >> 5), ((flag) & 31)
+#endif
 
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 64038d8..043c97d 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -13,11 +13,12 @@ nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o scattered.o topology.o
-obj-y			+= capflags.o powerflags.o common.o
+obj-y			+= common.o
 obj-y			+= rdrand.o
 obj-y			+= match.o
 
 obj-$(CONFIG_PROC_FS)	+= proc.o
+obj-$(CONFIG_X86_FEATURE_NAMES) += capflags.o powerflags.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8e28bf2..3991a81 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -336,8 +336,8 @@ static void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
 			continue;
 
 		printk(KERN_WARNING
-		       "CPU: CPU feature %s disabled, no CPUID level 0x%x\n",
-				x86_cap_flags[df->feature], df->level);
+		       "CPU: CPU feature " X86_CAP_FMT " disabled, no CPUID level 0x%x\n",
+				x86_cap_flag(df->feature), df->level);
 	}
 }
 
-- 
1.9.0

