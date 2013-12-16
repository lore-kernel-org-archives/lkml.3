Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab3LPQu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:50:29 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46776 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3LPQto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:49:44 -0500
From: jean.pihet@linaro.org
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Arnaldo <acme@ghostprotocols.net>, Will Deacon <will.deacon@arm.com>
Cc: patches@linaro.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 2/3] ARM64: perf: wire up perf_regs and unwind support
Date: Mon, 16 Dec 2013 17:49:21 +0100
Message-Id: <52af2f26.41590e0a.0251.ffffd953@mx.google.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387212562-8128-1-git-send-email-y>
References: <1387212562-8128-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <jean.pihet@linaro.org>

This patch hooks in the perf_regs and libunwind code for ARM64.
The tools/perf/arch/arm64 is created; it contains the arch specific
code for DWARF unwinding.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 tools/perf/arch/arm64/Makefile            |  7 +++
 tools/perf/arch/arm64/include/perf_regs.h | 88 +++++++++++++++++++++++++++++++
 tools/perf/arch/arm64/util/dwarf-regs.c   | 81 ++++++++++++++++++++++++++++
 tools/perf/arch/arm64/util/unwind.c       | 82 ++++++++++++++++++++++++++++
 tools/perf/config/Makefile                |  8 ++-
 5 files changed, 265 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/arch/arm64/Makefile
 create mode 100644 tools/perf/arch/arm64/include/perf_regs.h
 create mode 100644 tools/perf/arch/arm64/util/dwarf-regs.c
 create mode 100644 tools/perf/arch/arm64/util/unwind.c

diff --git a/tools/perf/arch/arm64/Makefile b/tools/perf/arch/arm64/Makefile
new file mode 100644
index 0000000..fe9b61e
--- /dev/null
+++ b/tools/perf/arch/arm64/Makefile
@@ -0,0 +1,7 @@
+ifndef NO_DWARF
+PERF_HAVE_DWARF_REGS := 1
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+endif
+ifndef NO_LIBUNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
+endif
diff --git a/tools/perf/arch/arm64/include/perf_regs.h b/tools/perf/arch/arm64/include/perf_regs.h
new file mode 100644
index 0000000..a8a9683
--- /dev/null
+++ b/tools/perf/arch/arm64/include/perf_regs.h
@@ -0,0 +1,88 @@
+#ifndef ARCH_PERF_REGS_H
+#define ARCH_PERF_REGS_H
+
+#include <stdlib.h>
+#include "../../util/types.h"
+#include <asm/perf_regs.h>
+
+#define PERF_REGS_MASK	((1ULL << PERF_REG_ARM_MAX) - 1)
+#define PERF_REG_IP	PERF_REG_ARM_PC
+#define PERF_REG_SP	PERF_REG_ARM_SP
+
+static inline const char *perf_reg_name(int id)
+{
+	switch (id) {
+	case PERF_REG_ARM_X0:
+		return "x0";
+	case PERF_REG_ARM_X1:
+		return "x1";
+	case PERF_REG_ARM_X2:
+		return "x2";
+	case PERF_REG_ARM_X3:
+		return "x3";
+	case PERF_REG_ARM_X4:
+		return "x4";
+	case PERF_REG_ARM_X5:
+		return "x5";
+	case PERF_REG_ARM_X6:
+		return "x6";
+	case PERF_REG_ARM_X7:
+		return "x7";
+	case PERF_REG_ARM_X8:
+		return "x8";
+	case PERF_REG_ARM_X9:
+		return "x9";
+	case PERF_REG_ARM_X10:
+		return "x10";
+	case PERF_REG_ARM_X11:
+		return "x11";
+	case PERF_REG_ARM_X12:
+		return "x12";
+	case PERF_REG_ARM_X13:
+		return "x13";
+	case PERF_REG_ARM_X14:
+		return "x14";
+	case PERF_REG_ARM_X15:
+		return "x15";
+	case PERF_REG_ARM_X16:
+		return "x16";
+	case PERF_REG_ARM_X17:
+		return "x17";
+	case PERF_REG_ARM_X18:
+		return "x18";
+	case PERF_REG_ARM_X19:
+		return "x19";
+	case PERF_REG_ARM_X20:
+		return "x20";
+	case PERF_REG_ARM_X21:
+		return "x21";
+	case PERF_REG_ARM_X22:
+		return "x22";
+	case PERF_REG_ARM_X23:
+		return "x23";
+	case PERF_REG_ARM_X24:
+		return "x24";
+	case PERF_REG_ARM_X25:
+		return "x25";
+	case PERF_REG_ARM_X26:
+		return "x26";
+	case PERF_REG_ARM_X27:
+		return "x27";
+	case PERF_REG_ARM_X28:
+		return "x28";
+	case PERF_REG_ARM_FP:
+		return "fp";
+	case PERF_REG_ARM_SP:
+		return "sp";
+	case PERF_REG_ARM_LR:
+		return "lr";
+	case PERF_REG_ARM_PC:
+		return "pc";
+	default:
+		return NULL;
+	}
+
+	return NULL;
+}
+
+#endif /* ARCH_PERF_REGS_H */
diff --git a/tools/perf/arch/arm64/util/dwarf-regs.c b/tools/perf/arch/arm64/util/dwarf-regs.c
new file mode 100644
index 0000000..23d319e
--- /dev/null
+++ b/tools/perf/arch/arm64/util/dwarf-regs.c
@@ -0,0 +1,81 @@
+/*
+ * Mapping of DWARF debug register numbers into register names.
+ *
+ * Copyright (C) 2010 Will Deacon, ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stddef.h>
+#include <dwarf-regs.h>
+
+struct pt_regs_dwarfnum {
+	const char *name;
+	unsigned int dwarfnum;
+};
+
+#define STR(s) #s
+#define REG_DWARFNUM_NAME(r, num) {.name = r, .dwarfnum = num}
+#define GPR_DWARFNUM_NAME(num) \
+	{.name = STR(%r##num), .dwarfnum = num}
+#define REG_DWARFNUM_END {.name = NULL, .dwarfnum = 0}
+
+/*
+ * Reference:
+ * http://infocenter.arm.com/help/topic/com.arm.doc.ihi0057b/IHI0057B_aadwarf64.pdf
+ */
+static const struct pt_regs_dwarfnum regdwarfnum_table[] = {
+	GPR_DWARFNUM_NAME(0),
+	GPR_DWARFNUM_NAME(1),
+	GPR_DWARFNUM_NAME(2),
+	GPR_DWARFNUM_NAME(3),
+	GPR_DWARFNUM_NAME(4),
+	GPR_DWARFNUM_NAME(5),
+	GPR_DWARFNUM_NAME(6),
+	GPR_DWARFNUM_NAME(7),
+	GPR_DWARFNUM_NAME(8),
+	GPR_DWARFNUM_NAME(9),
+	GPR_DWARFNUM_NAME(10),
+	GPR_DWARFNUM_NAME(11),
+	GPR_DWARFNUM_NAME(12),
+	GPR_DWARFNUM_NAME(13),
+	GPR_DWARFNUM_NAME(14),
+	GPR_DWARFNUM_NAME(15),
+	GPR_DWARFNUM_NAME(16),
+	GPR_DWARFNUM_NAME(17),
+	GPR_DWARFNUM_NAME(18),
+	GPR_DWARFNUM_NAME(19),
+	GPR_DWARFNUM_NAME(20),
+	GPR_DWARFNUM_NAME(21),
+	GPR_DWARFNUM_NAME(22),
+	GPR_DWARFNUM_NAME(23),
+	GPR_DWARFNUM_NAME(24),
+	GPR_DWARFNUM_NAME(25),
+	GPR_DWARFNUM_NAME(26),
+	GPR_DWARFNUM_NAME(27),
+	GPR_DWARFNUM_NAME(28),
+	REG_DWARFNUM_NAME("%fp", 29),
+	REG_DWARFNUM_NAME("%lr", 30),
+	REG_DWARFNUM_NAME("%sp", 31),
+	REG_DWARFNUM_NAME("%pc", 32),
+	REG_DWARFNUM_END,
+};
+
+/**
+ * get_arch_regstr() - lookup register name from it's DWARF register number
+ * @n:	the DWARF register number
+ *
+ * get_arch_regstr() returns the name of the register in struct
+ * regdwarfnum_table from it's DWARF register number. If the register is not
+ * found in the table, this returns NULL;
+ */
+const char *get_arch_regstr(unsigned int n)
+{
+	const struct pt_regs_dwarfnum *roff;
+	for (roff = regdwarfnum_table; roff->name != NULL; roff++)
+		if (roff->dwarfnum == n)
+			return roff->name;
+	return NULL;
+}
diff --git a/tools/perf/arch/arm64/util/unwind.c b/tools/perf/arch/arm64/util/unwind.c
new file mode 100644
index 0000000..490bd5b
--- /dev/null
+++ b/tools/perf/arch/arm64/util/unwind.c
@@ -0,0 +1,82 @@
+
+#include <errno.h>
+#include <libunwind.h>
+#include "perf_regs.h"
+#include "../../util/unwind.h"
+
+int unwind__arch_reg_id(int regnum)
+{
+	switch (regnum) {
+	case UNW_AARCH64_X0:
+		return PERF_REG_ARM_X0;
+	case UNW_AARCH64_X1:
+		return PERF_REG_ARM_X1;
+	case UNW_AARCH64_X2:
+		return PERF_REG_ARM_X2;
+	case UNW_AARCH64_X3:
+		return PERF_REG_ARM_X3;
+	case UNW_AARCH64_X4:
+		return PERF_REG_ARM_X4;
+	case UNW_AARCH64_X5:
+		return PERF_REG_ARM_X5;
+	case UNW_AARCH64_X6:
+		return PERF_REG_ARM_X6;
+	case UNW_AARCH64_X7:
+		return PERF_REG_ARM_X7;
+	case UNW_AARCH64_X8:
+		return PERF_REG_ARM_X8;
+	case UNW_AARCH64_X9:
+		return PERF_REG_ARM_X9;
+	case UNW_AARCH64_X10:
+		return PERF_REG_ARM_X10;
+	case UNW_AARCH64_X11:
+		return PERF_REG_ARM_X11;
+	case UNW_AARCH64_X12:
+		return PERF_REG_ARM_X12;
+	case UNW_AARCH64_X13:
+		return PERF_REG_ARM_X13;
+	case UNW_AARCH64_X14:
+		return PERF_REG_ARM_X14;
+	case UNW_AARCH64_X15:
+		return PERF_REG_ARM_X15;
+	case UNW_AARCH64_X16:
+		return PERF_REG_ARM_X16;
+	case UNW_AARCH64_X17:
+		return PERF_REG_ARM_X17;
+	case UNW_AARCH64_X18:
+		return PERF_REG_ARM_X18;
+	case UNW_AARCH64_X19:
+		return PERF_REG_ARM_X19;
+	case UNW_AARCH64_X20:
+		return PERF_REG_ARM_X20;
+	case UNW_AARCH64_X21:
+		return PERF_REG_ARM_X21;
+	case UNW_AARCH64_X22:
+		return PERF_REG_ARM_X22;
+	case UNW_AARCH64_X23:
+		return PERF_REG_ARM_X23;
+	case UNW_AARCH64_X24:
+		return PERF_REG_ARM_X24;
+	case UNW_AARCH64_X25:
+		return PERF_REG_ARM_X25;
+	case UNW_AARCH64_X26:
+		return PERF_REG_ARM_X26;
+	case UNW_AARCH64_X27:
+		return PERF_REG_ARM_X27;
+	case UNW_AARCH64_X28:
+		return PERF_REG_ARM_X28;
+	case UNW_AARCH64_X29:
+		return PERF_REG_ARM_FP;
+	case UNW_AARCH64_X30:
+		return PERF_REG_ARM_LR;
+	case UNW_AARCH64_SP:
+		return PERF_REG_ARM_SP;
+	case UNW_AARCH64_PC:
+		return PERF_REG_ARM_PC;
+	default:
+		pr_err("unwind: invalid reg id %d\n", regnum);
+		return -EINVAL;
+	}
+
+	return -EINVAL;
+}
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f7d11a8..658295c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -31,11 +31,17 @@ ifeq ($(ARCH),x86_64)
   endif
   NO_PERF_REGS := 0
 endif
+
 ifeq ($(ARCH),arm)
   NO_PERF_REGS := 0
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
 endif
 
+ifeq ($(ARCH),arm64)
+  NO_PERF_REGS := 0
+  LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
+endif
+
 ifeq ($(NO_PERF_REGS),0)
   CFLAGS += -DHAVE_PERF_REGS_SUPPORT
 endif
@@ -329,7 +335,7 @@ ifndef NO_LIBUNWIND
     msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
     NO_LIBUNWIND := 1
   else
-    ifeq ($(ARCH),arm)
+    ifeq ($(ARCH),$(filter $(ARCH),arm arm64))
       $(call feature_check,libunwind-debug-frame)
       ifneq ($(feature-libunwind-debug-frame), 1)
         msg := $(warning No debug_frame support found in libunwind);
-- 
1.7.11.7

