Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935314AbaKNMvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:51:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50681 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935256AbaKNMvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:51:12 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-da-5465fabd5a76
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yury Gribov <y.gribov@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH v2 2/2] UBSan: run-time undefined behavior sanity checker
Date: Fri, 14 Nov 2014 15:50:46 +0300
Message-id: <1415969446-26356-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1415969446-26356-1-git-send-email-a.ryabinin@samsung.com>
References: <1415969446-26356-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7p7f6WGGPxdomGx7dcjNos569ew
	WTw50M5oMeFhG7vFtI3iFis7H7BaLGxbwmLxZ9cOJovLu+awWTyeNY/N4tKBBUwWLfsuMFkc
	7z3AZPH2znQWi8VHbjNbbN40ldnix4bHrBaHPi9mchDy2DnrLrvHgk2lHptXaHlsWtXJ5vHu
	3Dl2jxMzfrN4LO6bzOrx8ektFo8LXdke7/ddZfPo27KK0ePMgiPsHp83yXmcaPnCGsAXxWWT
	kpqTWZZapG+XwJXx9HMza8Hbm4wVT281MjcwvtzE2MXIwSEhYCLRMz+4i5ETyBSTuHBvPVsX
	IxeHkMBSRon2rY1QTh+TxM3JJ9hBqtgE9CT+zdrOBmKLCChIbO59xgpSxCzwlkVi3ua7zCAJ
	YQFPiQcrDzKC2CwCqhJP/uxiArF5BdwkXndfgtosJ7F1nTdImFPAXWLC9IssILYQUMnEwzeY
	JjDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREhlfdjAuPmZ1iFGAg1GJh9egIDVE
	iDWxrLgy9xCjBAezkgjv9+dAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzC3hu0micebFfbLahy
	e0n24xPOW8/x3EhW3e5X/MjbaHnjrLtbzsnopZx9/tbDL26T4Z+UW28jigOZCy8aFRzrnT4t
	4Qbbti3mvfvcT1R9lXvJIzRL49SrPTPXpyw6dUlpi/SW52bXmQ/qsy7jPH3Cs+uO3/+n++SO
	yzgF3DePjDyu8+rLbL1nSizFGYmGWsxFxYkAorp2CGoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UBSan uses compile-time instrumentation to catch undefined behavior (UB).
Compiler inserts code that perform certain kinds of checks before
operations that could cause UB. If check fails (i.e. UB detected)
__ubsan_handle_* function called to print error message.

So the most of the work is done by compiler. This patch just
implements ubsan handlers printing errors.

GCC has this capability since 4.9 [1] (see -fsanitize=undefined
option and its suboptions).
However upcoming GCC 5.0 has more checkers implemented [2].
Article [3] has a bit more details about UBSan in the GCC.

Different kinds of checks could be enabled via boot parameter:
ubsan_handle=OEAINVBSLU.
If ubsan_handle not present in cmdline default options are used: ELNVBSLU

	O - different kinds of overflows
	E - negation overflow, division overflow, division by zero.
	A - misaligned memory access.
	I - load from/store to an object with insufficient space.
	N - null argument declared with nonnull attribute,
	  returned null from function which never returns null, null ptr dereference.
	V - variable size array with non-positive length
	B - out-of-bounds accesses.
	S - shifting out-of-bounds.
	L - load of invalid value (value out of range for the enum type, loading other then 0/1 to bool type)
	U - __builtin_unreachable() was called

[1] - https://gcc.gnu.org/onlinedocs/gcc-4.9.0/gcc/Debugging-Options.html
[2] - https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
[3] - http://developerblog.redhat.com/2014/10/16/gcc-undefined-behavior-sanitizer-ubsan/

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 Documentation/ubsan.txt               |  69 +++++
 Makefile                              |  10 +-
 arch/x86/Kconfig                      |   1 +
 arch/x86/boot/Makefile                |   1 +
 arch/x86/boot/compressed/Makefile     |   1 +
 arch/x86/realmode/rm/Makefile         |   1 +
 arch/x86/vdso/Makefile                |   2 +
 drivers/firmware/efi/libstub/Makefile |   1 +
 include/linux/sched.h                 |   3 +
 lib/Kconfig.debug                     |  22 ++
 lib/Makefile                          |   3 +
 lib/ubsan.c                           | 567 ++++++++++++++++++++++++++++++++++
 lib/ubsan.h                           |  84 +++++
 scripts/Makefile.lib                  |   6 +
 14 files changed, 770 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ubsan.txt
 create mode 100644 lib/ubsan.c
 create mode 100644 lib/ubsan.h

diff --git a/Documentation/ubsan.txt b/Documentation/ubsan.txt
new file mode 100644
index 0000000..04d6aa6
--- /dev/null
+++ b/Documentation/ubsan.txt
@@ -0,0 +1,69 @@
+Undefined Behavior Sanitizer - UBSan
+
+Overview
+========
+
+UBSan is a runtime undefined behaviour checker.
+
+UBSan uses compile-time instrumentation to catch undefined behavior (UB).
+Compiler inserts code that perform certain kinds of checks before operations
+that may cause UB. If check fails (i.e. UB detected) __ubsan_handle_*
+function called to print error message.
+
+GCC has that feature since 4.9 [1] (see -fsanitize=undefined option and its suboptions).
+Upcoming GCC 5.0 has more checkers implemented [2].
+
+Usage
+=======
+
+To enable UBSAN configure kernel with:
+
+	  CONFIG_UBSAN=y
+
+and to check the entire kernel:
+
+        CONFIG_UBSAN_SANITIZE_ALL=y
+
+To enable instrumentation for specific files or directories, add a line
+similar to the following to the respective kernel Makefile:
+
+        For a single file (e.g. main.o):
+                UBSAN_SANITIZE_main.o := y
+
+        For all files in one directory:
+                UBSAN_SANITIZE := y
+
+To exclude files from being instrumented even if CONFIG_UBSAN_SANITIZE_ALL=y,
+use:
+
+                UBSAN_SANITIZE_main.o := n
+        and:
+                UBSAN_SANITIZE := n
+
+Various types of checkers may be enabled via boot parameter, e.g.:
+     ubsan_handle=OEAINVBSLU
+
+Possible options are:
+        O - different kinds of integer overflows
+        E - negation overflow, division overflow, division by zero.
+        A - misaligned memory access.
+        I - load from/store to an object with insufficient space.
+        N - passing NULL as argument declared with nonnull attribute,
+             returned null from function which never returns null,
+             null ptr dereference.
+        V - variable size array with non-positive length
+        B - out-of-bounds memory accesses
+        S - shifting out-of-bounds
+        L - load of invalid value (value out of range for the enum type,
+              loading other then 0/1 to bool type)
+        U - __builtin_unreachable() was called
+
+If ubsan_handle not present in cmdline the default options are used: ELNVBSLU.
+Additionally option 'A' (misaligned access checks) enabled by default if
+architecture doesn't support unaligned accesses.
+
+References
+==========
+
+[1] - https://gcc.gnu.org/onlinedocs/gcc-4.9.0/gcc/Debugging-Options.html
+[2] - https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
diff --git a/Makefile b/Makefile
index bc7eb6a..007e06b 100644
--- a/Makefile
+++ b/Makefile
@@ -377,6 +377,7 @@ LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
+CFLAGS_UBSAN	= $(call cc-option, -fsanitize=undefined)
 
 
 # Use USERINCLUDE when you must reference the UAPI directories only.
@@ -421,7 +422,7 @@ export MAKE AWK GENKSYMS INSTALLKERNEL PERL PYTHON UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
-export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
+export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV CFLAGS_UBSAN
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
@@ -670,6 +671,13 @@ endif
 endif
 KBUILD_CFLAGS += $(stackp-flag)
 
+ifdef CONFIG_UBSAN
+  ifeq ($(CFLAGS_UBSAN),)
+    $(warning Cannot use CONFIG_UBSAN: \
+             -fsanitize=undefined not supported by compiler)
+  endif
+endif
+
 ifeq ($(COMPILER),clang)
 KBUILD_CPPFLAGS += $(call cc-option,-Qunused-arguments,)
 KBUILD_CPPFLAGS += $(call cc-option,-Wno-unknown-warning-option,)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a67..359d8ba 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -55,6 +55,7 @@ config X86
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_GRAPH_FP_TEST
+	select HAVE_ARCH_UBSAN_SANTIZE_ALL
 	select HAVE_SYSCALL_TRACEPOINTS
 	select SYSCTL_EXCEPTION_TRACE
 	select HAVE_KVM
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 5b016e2..95bf522 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -57,6 +57,7 @@ endif
 KBUILD_CFLAGS	:= $(USERINCLUDE) $(REALMODE_CFLAGS) -D_SETUP
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
+UBSAN_SANITIZE := n
 
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 704f58a..16940f8 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -19,6 +19,7 @@ KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
+UBSAN_SANITIZE :=n
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 7c0d7be..5c48444 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -69,3 +69,4 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) $(REALMODE_CFLAGS) -D_SETUP -D_WAKEUP \
 		   -I$(srctree)/arch/x86/boot
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
+UBSAN_SANITIZE := n
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 5a4affe..3054473 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -4,6 +4,8 @@
 
 KBUILD_CFLAGS += $(DISABLE_LTO)
 
+UBSAN_SANITIZE := n
+
 VDSO64-$(CONFIG_X86_64)		:= y
 VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
 VDSO32-$(CONFIG_X86_32)		:= y
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index b14bc2b..7b07624 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -19,6 +19,7 @@ KBUILD_CFLAGS			:= $(cflags-y) \
 				   $(call cc-option,-fno-stack-protector)
 
 GCOV_PROFILE			:= n
+UBSAN_SANITIZE			:= n
 
 lib-y				:= efi-stub-helper.o
 lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..36d0e89 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1483,6 +1483,9 @@ struct task_struct {
 	struct held_lock held_locks[MAX_LOCK_DEPTH];
 	gfp_t lockdep_reclaim_gfp;
 #endif
+#ifdef CONFIG_UBSAN
+	unsigned int in_ubsan;
+#endif
 
 /* journalling filesystem info */
 	void *journal_info;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4e35a5d..8e80d7c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -646,6 +646,28 @@ config DEBUG_SHIRQ
 	  Drivers ought to be able to handle interrupts coming in at those
 	  points; some don't and need to be caught.
 
+config HAVE_ARCH_UBSAN_SANTIZE_ALL
+	bool
+
+config UBSAN
+	bool "Undefined behaviour sanity checker"
+	help
+	  This option enables undefined behaviour sanity checker
+	  Compile-time instrumentation is used to detect various undefined
+	  behaviours in runtime. Various types of checks may be enabled
+	  via boot parameter ubsan_handle (see: Documentation/ubsan.txt).
+
+config UBSAN_SANITIZE_ALL
+	bool "Enable instrumentation for the entire kernel"
+	depends on UBSAN
+	depends on HAVE_ARCH_UBSAN_SANTIZE_ALL
+	default y
+	help
+	  This option activates instrumentation for the entire kernel.
+	  If you don't enable this option, you have to explicitly specify
+	  UBSAN_SANITIZE := y for the files/directories you want to check for UB.
+
+
 menu "Debug Lockups and Hangs"
 
 config LOCKUP_DETECTOR
diff --git a/lib/Makefile b/lib/Makefile
index 7512dc9..d8c05c68 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -196,3 +196,6 @@ quiet_cmd_build_OID_registry = GEN     $@
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+obj-$(CONFIG_UBSAN) += ubsan.o
+
+UBSAN_SANITIZE_ubsan.o := n
diff --git a/lib/ubsan.c b/lib/ubsan.c
new file mode 100644
index 0000000..d946e79
--- /dev/null
+++ b/lib/ubsan.c
@@ -0,0 +1,567 @@
+/*
+ * UBSan error reporting functions
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author: Andrey Ryabinin <a.ryabinin@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/bug.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+
+#include "ubsan.h"
+
+const char *type_check_kinds[] = {
+	"load of",
+	"store to",
+	"reference binding to",
+	"member access within",
+	"member call on",
+	"constructor call on",
+	"downcast of",
+	"downcast of"
+};
+
+enum {
+	SUM_OVERFLOW,
+	SUB_OVERFLOW,
+	MUL_OVERFLOW,
+	NEG_OVERFLOW,
+	DIVREM_OVERFLOW,
+	ALIGNMENT,
+	OBJECT_SIZE,
+	NONNULL_ARG,
+	NONNULL_RET,
+	NULL_PTR,
+	VLA_BOUND,
+	OUT_OF_BOUNDS,
+	SHIFT_OUT_OF_BOUNDS,
+	INVALID_LOAD,
+	UNREACHABLE,
+	HANDLERS_END,
+};
+
+/*
+ * By default enable everything except signed overflows and
+ * misaligned accesses
+ */
+static unsigned long ubsan_handle = GENMASK(HANDLERS_END, 0) &
+	~(BIT_MASK(SUM_OVERFLOW) | BIT_MASK(SUB_OVERFLOW) |
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+		BIT_MASK(ALIGNMENT) |
+#endif
+		BIT_MASK(MUL_OVERFLOW));
+
+#define REPORTED_BIT 31
+
+#if (BITS_PER_LONG == 64) && defined(__BIG_ENDIAN)
+#define COLUMN_MASK (~(1U << REPORTED_BIT))
+#define LINE_MASK   (~0U)
+#else
+#define COLUMN_MASK   (~0U)
+#define LINE_MASK (~(1U << REPORTED_BIT))
+#endif
+
+#define VALUE_LENGTH 40
+
+static bool was_reported(struct source_location *location)
+{
+	return test_and_set_bit(REPORTED_BIT, &location->reported);
+}
+
+static void print_source_location(const char *prefix,
+				struct source_location *loc)
+{
+	pr_err("%s %s:%d:%d\n", prefix, loc->file_name,
+		loc->line & LINE_MASK, loc->column & COLUMN_MASK);
+}
+
+static void enable_handler(unsigned int handler)
+{
+	set_bit(handler, &ubsan_handle);
+}
+
+static bool handler_enabled(unsigned int handler)
+{
+	return test_bit(handler, &ubsan_handle);
+}
+
+static bool suppress_report(unsigned int handler, struct source_location *loc)
+{
+	return current->in_ubsan || !handler_enabled(handler)
+		|| was_reported(loc);
+}
+
+static bool type_is_int(struct type_descriptor *type)
+{
+	return type->type_kind == type_kind_int;
+}
+
+static bool type_is_signed(struct type_descriptor *type)
+{
+	WARN_ON(!type_is_int(type));
+	return  type->type_info & 1;
+}
+
+static unsigned type_bit_width(struct type_descriptor *type)
+{
+	return 1 << (type->type_info >> 1);
+}
+
+static bool is_inline_int(struct type_descriptor *type)
+{
+	unsigned inline_bits = sizeof(unsigned long)*8;
+	unsigned bits = type_bit_width(type);
+
+	WARN_ON(!type_is_int(type));
+
+	return bits <= inline_bits;
+}
+
+static s_max get_signed_val(struct type_descriptor *type, unsigned long val)
+{
+	if (is_inline_int(type)) {
+		unsigned extra_bits = sizeof(s_max)*8 - type_bit_width(type);
+		return ((s_max)val) << extra_bits >> extra_bits;
+	}
+
+	if (type_bit_width(type) == 64)
+		return *(s64 *)val;
+
+	return *(s_max *)val;
+}
+
+static bool val_is_negative(struct type_descriptor *type, unsigned long val)
+{
+	return type_is_signed(type) && get_signed_val(type, val) < 0;
+}
+
+static u_max get_unsigned_val(struct type_descriptor *type, unsigned long val)
+{
+	if (is_inline_int(type))
+		return val;
+
+	if (type_bit_width(type) == 64)
+		return *(u64 *)val;
+
+	return *(u_max *)val;
+}
+
+static void val_to_string(char *str, size_t size, struct type_descriptor *type,
+	unsigned long value)
+{
+	u_max val = get_unsigned_val(type, value);
+
+	if (type_is_int(type)) {
+		if (type_bit_width(type) == 128)
+			scnprintf(str, size, "0x%08x%08x%08x%08x",
+				(u32)(val >> 96),
+				(u32)(val >> 64),
+				(u32)(val >> 32),
+				(u32)(val));
+		else if (type_is_signed(type))
+			scnprintf(str, size, "%lld",
+				(s64)get_signed_val(type, value));
+		else
+			scnprintf(str, size, "%llu",
+				(u64)get_unsigned_val(type, value));
+	}
+}
+
+static bool location_is_valid(struct source_location *loc)
+{
+	return loc->file_name != NULL;
+}
+
+static DEFINE_SPINLOCK(report_lock);
+
+static void ubsan_prologue(struct source_location *location,
+			unsigned long *flags)
+{
+	current->in_ubsan++;
+	spin_lock_irqsave(&report_lock, *flags);
+
+	pr_err("========================================"
+		"========================================\n");
+	print_source_location("UBSan: Undefined behaviour in", location);
+}
+
+static void ubsan_epilogue(unsigned long *flags)
+{
+	dump_stack();
+	pr_err("========================================"
+		"========================================\n");
+	spin_unlock_irqrestore(&report_lock, *flags);
+	current->in_ubsan--;
+}
+
+static void handle_overflow(struct overflow_data *data, unsigned long lhs,
+			unsigned long rhs, unsigned int handler, char op)
+{
+
+	struct type_descriptor *type = data->type;
+	unsigned long flags;
+	char lhs_val_str[VALUE_LENGTH];
+	char rhs_val_str[VALUE_LENGTH];
+
+	if (suppress_report(handler, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(lhs_val_str, sizeof(lhs_val_str), type, lhs);
+	val_to_string(rhs_val_str, sizeof(rhs_val_str), type, rhs);
+	pr_err("%s integer overflow:\n",
+		type_is_signed(type) ? "signed" : "unsigned");
+	pr_err("%s %c %s cannot be represented in type %s\n",
+		lhs_val_str,
+		op,
+		rhs_val_str,
+		type->type_name);
+
+	ubsan_epilogue(&flags);
+}
+
+void __ubsan_handle_add_overflow(struct overflow_data *data,
+				unsigned long lhs,
+				unsigned long rhs)
+{
+
+	handle_overflow(data, lhs, rhs, SUM_OVERFLOW, '+');
+}
+EXPORT_SYMBOL(__ubsan_handle_add_overflow);
+
+void __ubsan_handle_sub_overflow(struct overflow_data *data,
+				unsigned long lhs,
+				unsigned long rhs)
+{
+	handle_overflow(data, lhs, rhs, SUB_OVERFLOW, '-');
+}
+EXPORT_SYMBOL(__ubsan_handle_sub_overflow);
+
+void __ubsan_handle_mul_overflow(struct overflow_data *data,
+				unsigned long lhs,
+				unsigned long rhs)
+{
+	handle_overflow(data, lhs, rhs, MUL_OVERFLOW, '*');
+}
+EXPORT_SYMBOL(__ubsan_handle_mul_overflow);
+
+void __ubsan_handle_negate_overflow(struct overflow_data *data,
+				unsigned long old_val)
+{
+	unsigned long flags;
+	char old_val_str[VALUE_LENGTH];
+
+	if (suppress_report(NEG_OVERFLOW, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
+
+	pr_err("negation of %s cannot be represented in type %s:\n",
+		old_val_str, data->type->type_name);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_negate_overflow);
+
+
+void __ubsan_handle_divrem_overflow(struct overflow_data *data,
+				unsigned long lhs,
+				unsigned long rhs)
+{
+	unsigned long flags;
+	char rhs_val_str[VALUE_LENGTH];
+
+	if (suppress_report(DIVREM_OVERFLOW, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(rhs_val_str, sizeof(rhs_val_str), data->type, rhs);
+
+	if (type_is_signed(data->type) && get_signed_val(data->type, rhs) == -1)
+		pr_err("division of %s by -1 cannot be represented in type %s\n",
+			rhs_val_str, data->type->type_name);
+	else
+		pr_err("division by zero\n");
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_divrem_overflow);
+
+static void handle_null_ptr_deref(struct type_mismatch_data *data)
+{
+	unsigned long flags;
+
+	if (suppress_report(NULL_PTR, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	pr_err("%s null pointer of type %s\n",
+		type_check_kinds[data->type_check_kind],
+		data->type->type_name);
+
+	ubsan_epilogue(&flags);
+}
+
+static void handle_missaligned_access(struct type_mismatch_data *data,
+				unsigned long ptr)
+{
+	unsigned long flags;
+
+	if (suppress_report(ALIGNMENT, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	pr_err("%s misaligned address %p for type %s\n",
+		type_check_kinds[data->type_check_kind],
+		(void *)ptr, data->type->type_name);
+	pr_err("which requires %ld byte alignment\n", data->alignment);
+
+	ubsan_epilogue(&flags);
+}
+
+static void handle_object_size_mismatch(struct type_mismatch_data *data,
+					unsigned long ptr)
+{
+	unsigned long flags;
+
+	if (suppress_report(OBJECT_SIZE, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+	pr_err("%s address %pk with insufficient space\n",
+		type_check_kinds[data->type_check_kind],
+		(void *) ptr);
+	pr_err("for an object of type %s\n", data->type->type_name);
+	ubsan_epilogue(&flags);
+}
+
+void __ubsan_handle_type_mismatch(struct type_mismatch_data *data,
+				unsigned long ptr)
+{
+
+	if (!ptr)
+		handle_null_ptr_deref(data);
+	else if (data->alignment && !IS_ALIGNED(ptr, data->alignment))
+		handle_missaligned_access(data, ptr);
+	else
+		handle_object_size_mismatch(data, ptr);
+}
+EXPORT_SYMBOL(__ubsan_handle_type_mismatch);
+
+void __ubsan_handle_nonnull_arg(struct nonnull_arg_data *data)
+{
+	unsigned long flags;
+
+	if (suppress_report(NONNULL_ARG, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	pr_err("null pointer passed as argument %d, declared with nonnull attribute\n",
+		data->arg_index);
+
+	if (location_is_valid(&data->attr_location))
+		print_source_location("nonnull attribute declared in ",
+				&data->attr_location);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_nonnull_arg);
+
+void __ubsan_handle_nonnull_return(struct nonnull_return_data *data)
+{
+	unsigned long flags;
+
+	if (suppress_report(NONNULL_RET, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	pr_err("null pointer returned from function declared to never return null\n");
+
+	if (location_is_valid(&data->attr_location))
+		print_source_location("returns_nonnull attribute specified in",
+				&data->attr_location);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_nonnull_return);
+
+void __ubsan_handle_vla_bound_not_positive(struct vla_bound_data *data,
+					unsigned long bound)
+{
+	unsigned long flags;
+	char bound_str[VALUE_LENGTH];
+
+	if (suppress_report(VLA_BOUND, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(bound_str, sizeof(bound_str), data->type, bound);
+	pr_err("variable length array bound value %s <= 0\n", bound_str);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_vla_bound_not_positive);
+
+void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data,
+				unsigned long index)
+{
+	unsigned long flags;
+	char index_str[VALUE_LENGTH];
+
+	if (suppress_report(OUT_OF_BOUNDS, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(index_str, sizeof(index_str), data->index_type, index);
+	pr_err("index %s is out of range for type %s\n", index_str,
+		data->array_type->type_name);
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_out_of_bounds);
+
+void __ubsan_handle_shift_out_of_bounds(
+	struct shift_out_of_bounds_data *data,
+	unsigned long lhs,
+	unsigned long rhs)
+{
+	unsigned long flags;
+	struct type_descriptor *rhs_type = data->rhs_type;
+	struct type_descriptor *lhs_type = data->lhs_type;
+	char rhs_str[VALUE_LENGTH];
+	char lhs_str[VALUE_LENGTH];
+
+	if (suppress_report(SHIFT_OUT_OF_BOUNDS, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(rhs_str, sizeof(rhs_str), rhs_type, rhs);
+	val_to_string(lhs_str, sizeof(lhs_str), lhs_type, lhs);
+
+	if (val_is_negative(rhs_type, rhs))
+		pr_err("shift exponent %s is negative\n", rhs_str);
+
+	else if (get_unsigned_val(rhs_type, rhs) >=
+		type_bit_width(lhs_type))
+		pr_err("shift exponent %s is to large for %u-bit type %s\n",
+			rhs_str,
+			type_bit_width(lhs_type),
+			lhs_type->type_name);
+	else if (val_is_negative(lhs_type, lhs))
+		pr_err("left shift of negative value %s\n",
+			lhs_str);
+	else
+		pr_err("left shift of %s by %s places cannot be"
+			"represented in type %s\n",
+			lhs_str, rhs_str,
+			lhs_type->type_name);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_shift_out_of_bounds);
+
+void __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
+{
+	unsigned long flags;
+
+	if (suppress_report(UNREACHABLE, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+	pr_err("calling __builtin_unreachable()\n");
+	ubsan_epilogue(&flags);
+
+}
+EXPORT_SYMBOL(__ubsan_handle_builtin_unreachable);
+
+void __ubsan_handle_load_invalid_value(struct invalid_value_data *data,
+				unsigned long val)
+{
+	unsigned long flags;
+	char val_str[VALUE_LENGTH];
+
+	if (suppress_report(INVALID_LOAD, &data->location))
+		return;
+
+	ubsan_prologue(&data->location, &flags);
+
+	val_to_string(val_str, sizeof(val_str), data->type, val);
+
+	pr_err("load of value %s is not a valid value for type %s\n",
+		val_str, data->type->type_name);
+
+	ubsan_epilogue(&flags);
+}
+EXPORT_SYMBOL(__ubsan_handle_load_invalid_value);
+
+static int __init setup_ubsan_handlers(char *str)
+{
+	ubsan_handle = 0;
+
+	for (; *str; str++) {
+		switch (tolower(*str)) {
+		case 'o':
+			enable_handler(SUM_OVERFLOW);
+			enable_handler(SUB_OVERFLOW);
+			enable_handler(MUL_OVERFLOW);
+			break;
+		case 'e':
+			enable_handler(NEG_OVERFLOW);
+			enable_handler(DIVREM_OVERFLOW);
+			break;
+		case 'a':
+			enable_handler(ALIGNMENT);
+			break;
+		case 'i':
+			enable_handler(OBJECT_SIZE);
+			break;
+		case 'n':
+			enable_handler(NONNULL_ARG);
+			enable_handler(NONNULL_RET);
+			enable_handler(NULL_PTR);
+			break;
+		case 'v':
+			enable_handler(VLA_BOUND);
+			break;
+		case 'b':
+			enable_handler(OUT_OF_BOUNDS);
+			break;
+		case 's':
+			enable_handler(SHIFT_OUT_OF_BOUNDS);
+			break;
+		case 'l':
+			enable_handler(INVALID_LOAD);
+			break;
+		case 'u':
+			enable_handler(UNREACHABLE);
+			break;
+		default:
+			pr_err("skipping unknown option '%c'\n", *str);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+early_param("ubsan_handle", setup_ubsan_handlers);
diff --git a/lib/ubsan.h b/lib/ubsan.h
new file mode 100644
index 0000000..7407127
--- /dev/null
+++ b/lib/ubsan.h
@@ -0,0 +1,84 @@
+#ifndef _LIB_UBSAN_H
+#define _LIB_UBSAN_H
+
+enum {
+	type_kind_int = 0,
+	type_kind_float = 1,
+	type_unknown = 0xffff
+};
+
+struct type_descriptor {
+	u16 type_kind;
+	u16 type_info;
+	char type_name[1];
+};
+
+struct source_location {
+	const char *file_name;
+	union {
+		unsigned long reported;
+		struct {
+			u32 line;
+			u32 column;
+		};
+	};
+};
+
+struct overflow_data {
+	struct source_location location;
+	struct type_descriptor *type;
+};
+
+struct type_mismatch_data {
+	struct source_location location;
+	struct type_descriptor *type;
+	unsigned long alignment;
+	unsigned char type_check_kind;
+};
+
+struct nonnull_arg_data {
+	struct source_location location;
+	struct source_location attr_location;
+	int arg_index;
+};
+
+struct nonnull_return_data {
+	struct source_location location;
+	struct source_location attr_location;
+};
+
+struct vla_bound_data {
+	struct source_location location;
+	struct type_descriptor *type;
+};
+
+struct out_of_bounds_data {
+	struct source_location location;
+	struct type_descriptor *array_type;
+	struct type_descriptor *index_type;
+};
+
+struct shift_out_of_bounds_data {
+	struct source_location location;
+	struct type_descriptor *lhs_type;
+	struct type_descriptor *rhs_type;
+};
+
+struct unreachable_data {
+	struct source_location location;
+};
+
+struct invalid_value_data {
+	struct source_location location;
+	struct type_descriptor *type;
+};
+
+#ifdef CONFIG_ARCH_SUPPORTS_INT128
+typedef __int128 s_max;
+typedef unsigned __int128 u_max;
+#else
+typedef s64 s_max;
+typedef u64 u_max;
+#endif
+
+#endif
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 54be19a..3f631b9 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -119,6 +119,12 @@ _c_flags += $(if $(patsubst n%,, \
 		$(CFLAGS_GCOV))
 endif
 
+ifeq ($(CONFIG_UBSAN),y)
+_c_flags += $(if $(patsubst n%,, \
+		$(UBSAN_SANITIZE_$(basetarget).o)$(UBSAN_SANITIZE)$(CONFIG_UBSAN_SANITIZE_ALL)), \
+		$(CFLAGS_UBSAN))
+endif
+
 # If building the kernel in a separate objtree expand all occurrences
 # of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
 
-- 
2.1.3

