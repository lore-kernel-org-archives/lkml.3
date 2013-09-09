Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab3IIKBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:01:21 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56624 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3IIKAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:00:46 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 2/3] ARM: perf: wire up perf_regs and unwind support for ARM
Date: Mon,  9 Sep 2013 12:00:14 +0200
Message-Id: <1378720815-23964-3-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378720815-23964-1-git-send-email-jean.pihet@linaro.org>
References: <1378720815-23964-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

This patch hooks in the perf_regs and libunwind code for ARM.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/arch/arm/Makefile            |  3 ++
 tools/perf/arch/arm/include/perf_regs.h | 54 +++++++++++++++++++++++++++++++++
 tools/perf/arch/arm/util/unwind.c       | 48 +++++++++++++++++++++++++++++
 tools/perf/config/Makefile              |  7 +++--
 4 files changed, 110 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/arch/arm/include/perf_regs.h
 create mode 100644 tools/perf/arch/arm/util/unwind.c

diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 15130b5..fe9b61e 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -2,3 +2,6 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+ifndef NO_LIBUNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
+endif
diff --git a/tools/perf/arch/arm/include/perf_regs.h b/tools/perf/arch/arm/include/perf_regs.h
new file mode 100644
index 0000000..2a1cfde
--- /dev/null
+++ b/tools/perf/arch/arm/include/perf_regs.h
@@ -0,0 +1,54 @@
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
+	case PERF_REG_ARM_R0:
+		return "r0";
+	case PERF_REG_ARM_R1:
+		return "r1";
+	case PERF_REG_ARM_R2:
+		return "r2";
+	case PERF_REG_ARM_R3:
+		return "r3";
+	case PERF_REG_ARM_R4:
+		return "r4";
+	case PERF_REG_ARM_R5:
+		return "r5";
+	case PERF_REG_ARM_R6:
+		return "r6";
+	case PERF_REG_ARM_R7:
+		return "r7";
+	case PERF_REG_ARM_R8:
+		return "r8";
+	case PERF_REG_ARM_R9:
+		return "r9";
+	case PERF_REG_ARM_R10:
+		return "r10";
+	case PERF_REG_ARM_FP:
+		return "fp";
+	case PERF_REG_ARM_IP:
+		return "ip";
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
diff --git a/tools/perf/arch/arm/util/unwind.c b/tools/perf/arch/arm/util/unwind.c
new file mode 100644
index 0000000..da3dc95
--- /dev/null
+++ b/tools/perf/arch/arm/util/unwind.c
@@ -0,0 +1,48 @@
+
+#include <errno.h>
+#include <libunwind.h>
+#include "perf_regs.h"
+#include "../../util/unwind.h"
+
+int unwind__arch_reg_id(int regnum)
+{
+	switch (regnum) {
+	case UNW_ARM_R0:
+		return PERF_REG_ARM_R0;
+	case UNW_ARM_R1:
+		return PERF_REG_ARM_R1;
+	case UNW_ARM_R2:
+		return PERF_REG_ARM_R2;
+	case UNW_ARM_R3:
+		return PERF_REG_ARM_R3;
+	case UNW_ARM_R4:
+		return PERF_REG_ARM_R4;
+	case UNW_ARM_R5:
+		return PERF_REG_ARM_R5;
+	case UNW_ARM_R6:
+		return PERF_REG_ARM_R6;
+	case UNW_ARM_R7:
+		return PERF_REG_ARM_R7;
+	case UNW_ARM_R8:
+		return PERF_REG_ARM_R8;
+	case UNW_ARM_R9:
+		return PERF_REG_ARM_R9;
+	case UNW_ARM_R10:
+		return PERF_REG_ARM_R10;
+	case UNW_ARM_R11:
+		return PERF_REG_ARM_FP;
+	case UNW_ARM_R12:
+		return PERF_REG_ARM_IP;
+	case UNW_ARM_R13:
+		return PERF_REG_ARM_SP;
+	case UNW_ARM_R14:
+		return PERF_REG_ARM_LR;
+	case UNW_ARM_R15:
+		return PERF_REG_ARM_PC;
+	default:
+		pr_err("unwind: invalid reg id %d\n", regnum);
+		return -EINVAL;
+	}
+
+	return -EINVAL;
+}
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index b5d9238..7014373 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -29,6 +29,10 @@ ifeq ($(ARCH),x86_64)
   NO_PERF_REGS := 0
   LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
 endif
+ifeq ($(ARCH),arm)
+  NO_PERF_REGS := 0
+  LIBUNWIND_LIBS = -lunwind -lunwind-arm
+endif
 
 ifeq ($(NO_PERF_REGS),0)
   CFLAGS += -DHAVE_PERF_REGS
@@ -204,8 +208,7 @@ ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
 endif # try-cc
 endif # NO_LIBELF
 
-# There's only x86 (both 32 and 64) support for CFI unwind so far
-ifneq ($(ARCH),x86)
+ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 endif
 
-- 
1.7.11.7

