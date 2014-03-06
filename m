Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaCFEmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:42:20 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59772 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaCFEmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:42:18 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 2/3] power: perf tool: Add libunwind support for Power
Date: Wed,  5 Mar 2014 20:41:58 -0800
Message-Id: <1394080919-17957-3-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394080919-17957-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1394080919-17957-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030604-1542-0000-0000-00000024F865
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ability to link with libunwind on Power.

This is based on similar changes in x86 and arm. Basically, implement
accessor functions that libunwind can call into while building the
backtrace from the user stack (which the kernel saved in a perf sample
- in previous commit).

Tested on Fedora-20 with libunwind and libunwind-devel libdwarf packages
installed.

TODO:
	- Not sure if we need to list all the Power registers or restrict
	  to only those that libunwind needs.
	- Check about perf_reg_abi()
	- Build for 32-bit

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/arch/powerpc/Makefile            |    5 ++
 tools/perf/arch/powerpc/include/perf_regs.h |   69 +++++++++++++++++++++++++++
 tools/perf/arch/powerpc/util/unwind.c       |   63 ++++++++++++++++++++++++
 tools/perf/config/Makefile                  |    7 +++
 4 files changed, 144 insertions(+)
 create mode 100644 tools/perf/arch/powerpc/include/perf_regs.h
 create mode 100644 tools/perf/arch/powerpc/util/unwind.c

diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 744e629..9d3b8ce 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -2,4 +2,9 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+
+ifndef NO_LIBUNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
+endif
+
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/powerpc/include/perf_regs.h b/tools/perf/arch/powerpc/include/perf_regs.h
new file mode 100644
index 0000000..d5667da
--- /dev/null
+++ b/tools/perf/arch/powerpc/include/perf_regs.h
@@ -0,0 +1,69 @@
+#ifndef ARCH_PERF_REGS_H
+#define ARCH_PERF_REGS_H
+
+#include <asm/perf_regs.h>
+
+#define PERF_REGS_MASK	((1ULL << PERF_REG_POWERPC_MAX) - 1)
+#define PERF_REG_IP	PERF_REG_POWERPC_NIP
+#define PERF_REG_SP	PERF_REG_POWERPC_GPR1
+
+static inline const char *perf_reg_name(int id)
+{
+	switch (id) {
+		case PERF_REG_POWERPC_GPR0: 		return "R0";
+		case PERF_REG_POWERPC_GPR1: 		return "R1";
+		case PERF_REG_POWERPC_GPR2: 		return "R2";
+		case PERF_REG_POWERPC_GPR3: 		return "R3";
+		case PERF_REG_POWERPC_GPR4: 		return "R4";
+		case PERF_REG_POWERPC_GPR5: 		return "R5";
+		case PERF_REG_POWERPC_GPR6: 		return "R6";
+		case PERF_REG_POWERPC_GPR7: 		return "R7";
+		case PERF_REG_POWERPC_GPR8: 		return "R8";
+		case PERF_REG_POWERPC_GPR9: 		return "R9";
+		case PERF_REG_POWERPC_GPR10: 		return "R10";
+		case PERF_REG_POWERPC_GPR11: 		return "R11";
+		case PERF_REG_POWERPC_GPR12: 		return "R12";
+		case PERF_REG_POWERPC_GPR13: 		return "R13";
+		case PERF_REG_POWERPC_GPR14: 		return "R14";
+		case PERF_REG_POWERPC_GPR15: 		return "R15";
+		case PERF_REG_POWERPC_GPR16: 		return "R16";
+		case PERF_REG_POWERPC_GPR17: 		return "R17";
+		case PERF_REG_POWERPC_GPR18: 		return "R18";
+		case PERF_REG_POWERPC_GPR19: 		return "R19";
+		case PERF_REG_POWERPC_GPR20: 		return "R20";
+		case PERF_REG_POWERPC_GPR21: 		return "R21";
+		case PERF_REG_POWERPC_GPR22: 		return "R22";
+		case PERF_REG_POWERPC_GPR23: 		return "R23";
+		case PERF_REG_POWERPC_GPR24: 		return "R24";
+		case PERF_REG_POWERPC_GPR25: 		return "R25";
+		case PERF_REG_POWERPC_GPR26: 		return "R26";
+		case PERF_REG_POWERPC_GPR27: 		return "R27";
+		case PERF_REG_POWERPC_GPR28: 		return "R28";
+		case PERF_REG_POWERPC_GPR29: 		return "R29";
+		case PERF_REG_POWERPC_GPR30: 		return "R30";
+		case PERF_REG_POWERPC_GPR31: 		return "R31";
+
+		case PERF_REG_POWERPC_NIP: 		return "NIP";
+		case PERF_REG_POWERPC_MSR: 		return "MSR";
+		case PERF_REG_POWERPC_ORIG_GPR3:	return "ORIG_GPR3";
+		case PERF_REG_POWERPC_CTR: 		return "CTR";
+		case PERF_REG_POWERPC_LINK: 		return "LINK";
+		case PERF_REG_POWERPC_XER: 		return "XER";
+		case PERF_REG_POWERPC_CCR: 		return "CCR";
+
+#ifdef __powerpc64__
+		case PERF_REG_POWERPC_SOFTE: 		return "SOFTE";
+#else
+		case PERF_REG_POWERPC_MQ: 		return "MQ";
+#endif
+		case PERF_REG_POWERPC_TRAP: 		return "TRAP";
+		case PERF_REG_POWERPC_DAR: 		return "DAR";
+		case PERF_REG_POWERPC_DSISR: 		return "DSISR";
+		case PERF_REG_POWERPC_RESULT: 		return "RESULT";
+
+		default: 				return NULL;
+	}
+	return NULL;
+}
+
+#endif /* ARCH_PERF_REGS_H */
diff --git a/tools/perf/arch/powerpc/util/unwind.c b/tools/perf/arch/powerpc/util/unwind.c
new file mode 100644
index 0000000..ba73399
--- /dev/null
+++ b/tools/perf/arch/powerpc/util/unwind.c
@@ -0,0 +1,63 @@
+#ifdef HAVE_ARCH_POWERPC_SUPPORT
+#include <libunwind.h>			/* UNW_PPC64* macros */
+#include <asm/perf_regs.h>		/* PERF_REG* macros */
+#include "../../util/unwind.h"		/* unwind__arch_reg_id() prototype */
+#include <errno.h>
+
+/*
+ * Map Libunwind's "UNWIND" register ids to "PERF" register ids. 
+ *
+ * One place where this mapping is used is when unwinding the user
+ * stack saved in a perf-sample by the kernel. The kernel uses the
+ * "PERF" register ids to find offset of the register in 'struct
+ * pt_regs'. When using libunwind, we find the "PERF" register id
+ * and use it to retrieve the register contents from the sample.
+ */
+int unwind__arch_reg_id(int regnum)
+{
+	switch (regnum) {
+	case UNW_PPC64_R0: return PERF_REG_POWERPC_GPR0;
+	case UNW_PPC64_R1: return PERF_REG_POWERPC_GPR1;
+	case UNW_PPC64_R2: return PERF_REG_POWERPC_GPR2;
+	case UNW_PPC64_R3: return PERF_REG_POWERPC_GPR3;
+	case UNW_PPC64_R4: return PERF_REG_POWERPC_GPR4;
+	case UNW_PPC64_R5: return PERF_REG_POWERPC_GPR5;
+	case UNW_PPC64_R6: return PERF_REG_POWERPC_GPR6;
+	case UNW_PPC64_R7: return PERF_REG_POWERPC_GPR7;
+	case UNW_PPC64_R8: return PERF_REG_POWERPC_GPR8;
+	case UNW_PPC64_R9: return PERF_REG_POWERPC_GPR9;
+	case UNW_PPC64_R10: return PERF_REG_POWERPC_GPR9;
+	case UNW_PPC64_R11: return PERF_REG_POWERPC_GPR11;
+	case UNW_PPC64_R12: return PERF_REG_POWERPC_GPR12;
+	case UNW_PPC64_R13: return PERF_REG_POWERPC_GPR13;
+	case UNW_PPC64_R14: return PERF_REG_POWERPC_GPR14;
+	case UNW_PPC64_R15: return PERF_REG_POWERPC_GPR15;
+	case UNW_PPC64_R16: return PERF_REG_POWERPC_GPR16;
+	case UNW_PPC64_R17: return PERF_REG_POWERPC_GPR17;
+	case UNW_PPC64_R18: return PERF_REG_POWERPC_GPR18;
+	case UNW_PPC64_R19: return PERF_REG_POWERPC_GPR19;
+	case UNW_PPC64_R20: return PERF_REG_POWERPC_GPR20;
+	case UNW_PPC64_R21: return PERF_REG_POWERPC_GPR21;
+	case UNW_PPC64_R22: return PERF_REG_POWERPC_GPR22;
+	case UNW_PPC64_R23: return PERF_REG_POWERPC_GPR23;
+	case UNW_PPC64_R24: return PERF_REG_POWERPC_GPR24;
+	case UNW_PPC64_R25: return PERF_REG_POWERPC_GPR25;
+	case UNW_PPC64_R26: return PERF_REG_POWERPC_GPR26;
+	case UNW_PPC64_R27: return PERF_REG_POWERPC_GPR27;
+	case UNW_PPC64_R28: return PERF_REG_POWERPC_GPR28;
+	case UNW_PPC64_R29: return PERF_REG_POWERPC_GPR29;
+	case UNW_PPC64_R30: return PERF_REG_POWERPC_GPR30;
+	case UNW_PPC64_R31: return PERF_REG_POWERPC_GPR31;
+
+	case UNW_PPC64_LR: return PERF_REG_POWERPC_LINK;
+	case UNW_PPC64_CTR: return PERF_REG_POWERPC_CTR;
+	case UNW_PPC64_XER: return PERF_REG_POWERPC_XER;
+	case UNW_PPC64_NIP: return PERF_REG_POWERPC_NIP;
+
+	default:
+		pr_err("unwind: invalid reg id %d\n", regnum);
+		return -EINVAL;
+	}
+	return -EINVAL;
+}
+#endif /* HAVE_ARCH_POWERPC_SUPPORT */
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c48d449..6446afd 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -29,11 +29,18 @@ ifeq ($(ARCH),x86)
   endif
   NO_PERF_REGS := 0
 endif
+
 ifeq ($(ARCH),arm)
   NO_PERF_REGS := 0
   LIBUNWIND_LIBS = -lunwind -lunwind-arm
 endif
 
+ifeq ($(ARCH),powerpc)
+  CFLAGS += -DHAVE_ARCH_POWERPC_SUPPORT
+  NO_PERF_REGS := 0
+  LIBUNWIND_LIBS = -lunwind -lunwind-ppc64
+endif
+
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
-- 
1.7.9.5

