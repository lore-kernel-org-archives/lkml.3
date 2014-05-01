Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaEAGcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:32:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaEAGb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:31:58 -0400
Date: Wed, 30 Apr 2014 23:31:40 -0700
From: tip-bot for Jean Pihet <tipbot@zytor.com>
Message-ID: <tip-8ab596afb97bc9e2f9140dc1d993e81749acff42@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, will.deacon@arm.com, jean.pihet@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, will.deacon@arm.com, jean.pihet@linaro.org,
        tglx@linutronix.de
In-Reply-To: <1398688353-3737-1-git-send-email-jean.pihet@linaro.org>
References: <1398688353-3737-1-git-send-email-jean.pihet@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools ARM64:
  Wire up perf_regs and unwind support
Git-Commit-ID: 8ab596afb97bc9e2f9140dc1d993e81749acff42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ab596afb97bc9e2f9140dc1d993e81749acff42
Gitweb:     http://git.kernel.org/tip/8ab596afb97bc9e2f9140dc1d993e81749acff42
Author:     Jean Pihet <jean.pihet@linaro.org>
AuthorDate: Mon, 28 Apr 2014 14:32:33 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 29 Apr 2014 15:31:19 +0200

perf tools ARM64: Wire up perf_regs and unwind support

This patch hooks in the perf_regs and libunwind code for ARM64.
The tools/perf/arch/arm64 is created; it contains the arch specific
code for DWARF unwinding.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Link: http://lkml.kernel.org/r/1398688353-3737-1-git-send-email-jean.pihet@linaro.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/arch/{arm => arm64}/Makefile            |  0
 tools/perf/arch/arm64/include/perf_regs.h          | 88 ++++++++++++++++++++++
 .../perf/arch/{powerpc => arm64}/util/dwarf-regs.c | 26 +++----
 tools/perf/arch/arm64/util/unwind-libunwind.c      | 82 ++++++++++++++++++++
 tools/perf/config/Makefile                         |  8 +-
 5 files changed, 186 insertions(+), 18 deletions(-)

diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm64/Makefile
similarity index 100%
copy from tools/perf/arch/arm/Makefile
copy to tools/perf/arch/arm64/Makefile
diff --git a/tools/perf/arch/arm64/include/perf_regs.h b/tools/perf/arch/arm64/include/perf_regs.h
new file mode 100644
index 0000000..2359546
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
+#define PERF_REGS_MASK	((1ULL << PERF_REG_ARM64_MAX) - 1)
+#define PERF_REG_IP	PERF_REG_ARM64_PC
+#define PERF_REG_SP	PERF_REG_ARM64_SP
+
+static inline const char *perf_reg_name(int id)
+{
+	switch (id) {
+	case PERF_REG_ARM64_X0:
+		return "x0";
+	case PERF_REG_ARM64_X1:
+		return "x1";
+	case PERF_REG_ARM64_X2:
+		return "x2";
+	case PERF_REG_ARM64_X3:
+		return "x3";
+	case PERF_REG_ARM64_X4:
+		return "x4";
+	case PERF_REG_ARM64_X5:
+		return "x5";
+	case PERF_REG_ARM64_X6:
+		return "x6";
+	case PERF_REG_ARM64_X7:
+		return "x7";
+	case PERF_REG_ARM64_X8:
+		return "x8";
+	case PERF_REG_ARM64_X9:
+		return "x9";
+	case PERF_REG_ARM64_X10:
+		return "x10";
+	case PERF_REG_ARM64_X11:
+		return "x11";
+	case PERF_REG_ARM64_X12:
+		return "x12";
+	case PERF_REG_ARM64_X13:
+		return "x13";
+	case PERF_REG_ARM64_X14:
+		return "x14";
+	case PERF_REG_ARM64_X15:
+		return "x15";
+	case PERF_REG_ARM64_X16:
+		return "x16";
+	case PERF_REG_ARM64_X17:
+		return "x17";
+	case PERF_REG_ARM64_X18:
+		return "x18";
+	case PERF_REG_ARM64_X19:
+		return "x19";
+	case PERF_REG_ARM64_X20:
+		return "x20";
+	case PERF_REG_ARM64_X21:
+		return "x21";
+	case PERF_REG_ARM64_X22:
+		return "x22";
+	case PERF_REG_ARM64_X23:
+		return "x23";
+	case PERF_REG_ARM64_X24:
+		return "x24";
+	case PERF_REG_ARM64_X25:
+		return "x25";
+	case PERF_REG_ARM64_X26:
+		return "x26";
+	case PERF_REG_ARM64_X27:
+		return "x27";
+	case PERF_REG_ARM64_X28:
+		return "x28";
+	case PERF_REG_ARM64_X29:
+		return "x29";
+	case PERF_REG_ARM64_SP:
+		return "sp";
+	case PERF_REG_ARM64_LR:
+		return "lr";
+	case PERF_REG_ARM64_PC:
+		return "pc";
+	default:
+		return NULL;
+	}
+
+	return NULL;
+}
+
+#endif /* ARCH_PERF_REGS_H */
diff --git a/tools/perf/arch/powerpc/util/dwarf-regs.c b/tools/perf/arch/arm64/util/dwarf-regs.c
similarity index 72%
copy from tools/perf/arch/powerpc/util/dwarf-regs.c
copy to tools/perf/arch/arm64/util/dwarf-regs.c
index 733151c..d49efeb 100644
--- a/tools/perf/arch/powerpc/util/dwarf-regs.c
+++ b/tools/perf/arch/arm64/util/dwarf-regs.c
@@ -1,18 +1,16 @@
 /*
  * Mapping of DWARF debug register numbers into register names.
  *
- * Copyright (C) 2010 Ian Munsie, IBM Corporation.
+ * Copyright (C) 2010 Will Deacon, ARM Ltd.
  *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
 
 #include <stddef.h>
 #include <dwarf-regs.h>
 
-
 struct pt_regs_dwarfnum {
 	const char *name;
 	unsigned int dwarfnum;
@@ -20,13 +18,13 @@ struct pt_regs_dwarfnum {
 
 #define STR(s) #s
 #define REG_DWARFNUM_NAME(r, num) {.name = r, .dwarfnum = num}
-#define GPR_DWARFNUM_NAME(num)	\
-	{.name = STR(%gpr##num), .dwarfnum = num}
+#define GPR_DWARFNUM_NAME(num) \
+	{.name = STR(%x##num), .dwarfnum = num}
 #define REG_DWARFNUM_END {.name = NULL, .dwarfnum = 0}
 
 /*
  * Reference:
- * http://refspecs.linuxfoundation.org/ELF/ppc64/PPC-elf64abi-1.9.html
+ * http://infocenter.arm.com/help/topic/com.arm.doc.ihi0057b/IHI0057B_aadwarf64.pdf
  */
 static const struct pt_regs_dwarfnum regdwarfnum_table[] = {
 	GPR_DWARFNUM_NAME(0),
@@ -59,14 +57,8 @@ static const struct pt_regs_dwarfnum regdwarfnum_table[] = {
 	GPR_DWARFNUM_NAME(27),
 	GPR_DWARFNUM_NAME(28),
 	GPR_DWARFNUM_NAME(29),
-	GPR_DWARFNUM_NAME(30),
-	GPR_DWARFNUM_NAME(31),
-	REG_DWARFNUM_NAME("%msr",   66),
-	REG_DWARFNUM_NAME("%ctr",   109),
-	REG_DWARFNUM_NAME("%link",  108),
-	REG_DWARFNUM_NAME("%xer",   101),
-	REG_DWARFNUM_NAME("%dar",   119),
-	REG_DWARFNUM_NAME("%dsisr", 118),
+	REG_DWARFNUM_NAME("%lr", 30),
+	REG_DWARFNUM_NAME("%sp", 31),
 	REG_DWARFNUM_END,
 };
 
diff --git a/tools/perf/arch/arm64/util/unwind-libunwind.c b/tools/perf/arch/arm64/util/unwind-libunwind.c
new file mode 100644
index 0000000..436ee43
--- /dev/null
+++ b/tools/perf/arch/arm64/util/unwind-libunwind.c
@@ -0,0 +1,82 @@
+
+#include <errno.h>
+#include <libunwind.h>
+#include "perf_regs.h"
+#include "../../util/unwind.h"
+
+int libunwind__arch_reg_id(int regnum)
+{
+	switch (regnum) {
+	case UNW_AARCH64_X0:
+		return PERF_REG_ARM64_X0;
+	case UNW_AARCH64_X1:
+		return PERF_REG_ARM64_X1;
+	case UNW_AARCH64_X2:
+		return PERF_REG_ARM64_X2;
+	case UNW_AARCH64_X3:
+		return PERF_REG_ARM64_X3;
+	case UNW_AARCH64_X4:
+		return PERF_REG_ARM64_X4;
+	case UNW_AARCH64_X5:
+		return PERF_REG_ARM64_X5;
+	case UNW_AARCH64_X6:
+		return PERF_REG_ARM64_X6;
+	case UNW_AARCH64_X7:
+		return PERF_REG_ARM64_X7;
+	case UNW_AARCH64_X8:
+		return PERF_REG_ARM64_X8;
+	case UNW_AARCH64_X9:
+		return PERF_REG_ARM64_X9;
+	case UNW_AARCH64_X10:
+		return PERF_REG_ARM64_X10;
+	case UNW_AARCH64_X11:
+		return PERF_REG_ARM64_X11;
+	case UNW_AARCH64_X12:
+		return PERF_REG_ARM64_X12;
+	case UNW_AARCH64_X13:
+		return PERF_REG_ARM64_X13;
+	case UNW_AARCH64_X14:
+		return PERF_REG_ARM64_X14;
+	case UNW_AARCH64_X15:
+		return PERF_REG_ARM64_X15;
+	case UNW_AARCH64_X16:
+		return PERF_REG_ARM64_X16;
+	case UNW_AARCH64_X17:
+		return PERF_REG_ARM64_X17;
+	case UNW_AARCH64_X18:
+		return PERF_REG_ARM64_X18;
+	case UNW_AARCH64_X19:
+		return PERF_REG_ARM64_X19;
+	case UNW_AARCH64_X20:
+		return PERF_REG_ARM64_X20;
+	case UNW_AARCH64_X21:
+		return PERF_REG_ARM64_X21;
+	case UNW_AARCH64_X22:
+		return PERF_REG_ARM64_X22;
+	case UNW_AARCH64_X23:
+		return PERF_REG_ARM64_X23;
+	case UNW_AARCH64_X24:
+		return PERF_REG_ARM64_X24;
+	case UNW_AARCH64_X25:
+		return PERF_REG_ARM64_X25;
+	case UNW_AARCH64_X26:
+		return PERF_REG_ARM64_X26;
+	case UNW_AARCH64_X27:
+		return PERF_REG_ARM64_X27;
+	case UNW_AARCH64_X28:
+		return PERF_REG_ARM64_X28;
+	case UNW_AARCH64_X29:
+		return PERF_REG_ARM64_X29;
+	case UNW_AARCH64_X30:
+		return PERF_REG_ARM64_LR;
+	case UNW_AARCH64_SP:
+		return PERF_REG_ARM64_SP;
+	case UNW_AARCH64_PC:
+		return PERF_REG_ARM64_PC;
+	default:
+		pr_err("unwind: invalid reg id %d\n", regnum);
+		return -EINVAL;
+	}
+
+	return -EINVAL;
+}
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index a71fb39..cd56869 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -29,11 +29,17 @@ ifeq ($(ARCH),x86)
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
 # So far there's only x86 libdw unwind support merged in perf.
 # Disable it on all other architectures in case libdw unwind
 # support is detected in system. Add supported architectures
@@ -363,7 +369,7 @@ else
 endif
 
 ifndef NO_LIBUNWIND
-  ifeq ($(ARCH),arm)
+  ifeq ($(ARCH),$(filter $(ARCH),arm arm64))
     $(call feature_check,libunwind-debug-frame)
     ifneq ($(feature-libunwind-debug-frame), 1)
       msg := $(warning No debug_frame support found in libunwind);
