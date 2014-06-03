Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbaFCNhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:37:01 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61776 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaFCNg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:36:59 -0400
Date: Tue, 3 Jun 2014 15:36:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode changes for v3.16
Message-ID: <20140603133653.GA28635@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus

   # HEAD: 65cef1311d5d212fd3d48a43678536dc878ca288 x86, microcode: Add a disable chicken bit

A microcode-debugging boot flag plus related refactoring.

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86, boot: Carve out early cmdline parsing function
      x86, microcode: Add a disable chicken bit


 arch/x86/include/asm/cmdline.h             |  6 +++
 arch/x86/include/asm/microcode.h           |  1 +
 arch/x86/kernel/cpu/microcode/core.c       |  6 +++
 arch/x86/kernel/cpu/microcode/core_early.c | 37 +++++++++++++
 arch/x86/lib/Makefile                      |  2 +-
 arch/x86/lib/cmdline.c                     | 84 ++++++++++++++++++++++++++++++
 6 files changed, 135 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/cmdline.h
 create mode 100644 arch/x86/lib/cmdline.c

diff --git a/arch/x86/include/asm/cmdline.h b/arch/x86/include/asm/cmdline.h
new file mode 100644
index 0000000..e01f7f7
--- /dev/null
+++ b/arch/x86/include/asm/cmdline.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_X86_CMDLINE_H
+#define _ASM_X86_CMDLINE_H
+
+int cmdline_find_option_bool(const char *cmdline_ptr, const char *option);
+
+#endif /* _ASM_X86_CMDLINE_H */
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index b59827e..64dc362 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -25,6 +25,7 @@ struct cpu_signature {
 struct device;
 
 enum ucode_state { UCODE_ERROR, UCODE_OK, UCODE_NFOUND };
+extern bool dis_ucode_ldr;
 
 struct microcode_ops {
 	enum ucode_state (*request_microcode_user) (int cpu,
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 15c9876..dd9d619 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -97,6 +97,9 @@ MODULE_LICENSE("GPL");
 
 static struct microcode_ops	*microcode_ops;
 
+bool dis_ucode_ldr;
+module_param(dis_ucode_ldr, bool, 0);
+
 /*
  * Synchronization.
  *
@@ -546,6 +549,9 @@ static int __init microcode_init(void)
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	int error;
 
+	if (dis_ucode_ldr)
+		return 0;
+
 	if (c->x86_vendor == X86_VENDOR_INTEL)
 		microcode_ops = init_intel_microcode();
 	else if (c->x86_vendor == X86_VENDOR_AMD)
diff --git a/arch/x86/kernel/cpu/microcode/core_early.c b/arch/x86/kernel/cpu/microcode/core_early.c
index be7f851..5f28a64 100644
--- a/arch/x86/kernel/cpu/microcode/core_early.c
+++ b/arch/x86/kernel/cpu/microcode/core_early.c
@@ -17,9 +17,11 @@
  *	2 of the License, or (at your option) any later version.
  */
 #include <linux/module.h>
+#include <asm/microcode.h>
 #include <asm/microcode_intel.h>
 #include <asm/microcode_amd.h>
 #include <asm/processor.h>
+#include <asm/cmdline.h>
 
 #define QCHAR(a, b, c, d) ((a) + ((b) << 8) + ((c) << 16) + ((d) << 24))
 #define CPUID_INTEL1 QCHAR('G', 'e', 'n', 'u')
@@ -72,10 +74,33 @@ static int x86_family(void)
 	return x86;
 }
 
+static bool __init check_loader_disabled_bsp(void)
+{
+#ifdef CONFIG_X86_32
+	const char *cmdline = (const char *)__pa_nodebug(boot_command_line);
+	const char *opt	    = "dis_ucode_ldr";
+	const char *option  = (const char *)__pa_nodebug(opt);
+	bool *res = (bool *)__pa_nodebug(&dis_ucode_ldr);
+
+#else /* CONFIG_X86_64 */
+	const char *cmdline = boot_command_line;
+	const char *option  = "dis_ucode_ldr";
+	bool *res = &dis_ucode_ldr;
+#endif
+
+	if (cmdline_find_option_bool(cmdline, option))
+		*res = true;
+
+	return *res;
+}
+
 void __init load_ucode_bsp(void)
 {
 	int vendor, x86;
 
+	if (check_loader_disabled_bsp())
+		return;
+
 	if (!have_cpuid_p())
 		return;
 
@@ -96,10 +121,22 @@ void __init load_ucode_bsp(void)
 	}
 }
 
+static bool check_loader_disabled_ap(void)
+{
+#ifdef CONFIG_X86_32
+	return __pa_nodebug(dis_ucode_ldr);
+#else
+	return dis_ucode_ldr;
+#endif
+}
+
 void load_ucode_ap(void)
 {
 	int vendor, x86;
 
+	if (check_loader_disabled_ap())
+		return;
+
 	if (!have_cpuid_p())
 		return;
 
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index eabcb6e..4d4f96a 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -16,7 +16,7 @@ clean-files := inat-tables.c
 
 obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
-lib-y := delay.o misc.o
+lib-y := delay.o misc.o cmdline.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
diff --git a/arch/x86/lib/cmdline.c b/arch/x86/lib/cmdline.c
new file mode 100644
index 0000000..422db00
--- /dev/null
+++ b/arch/x86/lib/cmdline.c
@@ -0,0 +1,84 @@
+/*
+ * This file is part of the Linux kernel, and is made available under
+ * the terms of the GNU General Public License version 2.
+ *
+ * Misc librarized functions for cmdline poking.
+ */
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <asm/setup.h>
+
+static inline int myisspace(u8 c)
+{
+	return c <= ' ';	/* Close enough approximation */
+}
+
+/**
+ * Find a boolean option (like quiet,noapic,nosmp....)
+ *
+ * @cmdline: the cmdline string
+ * @option: option string to look for
+ *
+ * Returns the position of that @option (starts counting with 1)
+ * or 0 on not found.
+ */
+int cmdline_find_option_bool(const char *cmdline, const char *option)
+{
+	char c;
+	int len, pos = 0, wstart = 0;
+	const char *opptr = NULL;
+	enum {
+		st_wordstart = 0,	/* Start of word/after whitespace */
+		st_wordcmp,	/* Comparing this word */
+		st_wordskip,	/* Miscompare, skip */
+	} state = st_wordstart;
+
+	if (!cmdline)
+		return -1;      /* No command line */
+
+	len = min_t(int, strlen(cmdline), COMMAND_LINE_SIZE);
+	if (!len)
+		return 0;
+
+	while (len--) {
+		c = *(char *)cmdline++;
+		pos++;
+
+		switch (state) {
+		case st_wordstart:
+			if (!c)
+				return 0;
+			else if (myisspace(c))
+				break;
+
+			state = st_wordcmp;
+			opptr = option;
+			wstart = pos;
+			/* fall through */
+
+		case st_wordcmp:
+			if (!*opptr)
+				if (!c || myisspace(c))
+					return wstart;
+				else
+					state = st_wordskip;
+			else if (!c)
+				return 0;
+			else if (c != *opptr++)
+				state = st_wordskip;
+			else if (!len)		/* last word and is matching */
+				return wstart;
+			break;
+
+		case st_wordskip:
+			if (!c)
+				return 0;
+			else if (myisspace(c))
+				state = st_wordstart;
+			break;
+		}
+	}
+
+	return 0;	/* Buffer overrun */
+}
