Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161198AbaKNPzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:55:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63800 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965710AbaKNPyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:54:43 -0500
From: Andre Przywara <andre.przywara@arm.com>
To: will.deacon@arm.com, catalin.marinas@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] arm64: detect silicon revisions and set cap bits accordingly
Date: Fri, 14 Nov 2014 15:54:09 +0000
Message-Id: <1415980452-20366-4-git-send-email-andre.przywara@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
References: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After each CPU has been started, we iterate through a list of
CPU features or bugs to detect CPUs which need (or could benefit
from) kernel code patches.
For each feature/bug there is a function which checks if that
particular CPU is affected. We will later provide some more generic
functions for common things like testing for certain MIDR ranges.
We do this for every CPU to cover big.LITTLE systems properly as
well.
If a certain feature/bug has been detected, the capability bit will
be set, so that later the call to apply_alternatives() will trigger
the actual code patching.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |    2 ++
 arch/arm64/kernel/Makefile          |    2 +-
 arch/arm64/kernel/cpu_errata.c      |   59 +++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c         |    3 ++
 4 files changed, 65 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kernel/cpu_errata.c

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 20b2b3d6..744eaf7 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -46,4 +46,6 @@ static inline void cpus_set_cap(unsigned int num)
 		__set_bit(num, cpu_hwcaps);
 }
 
+void check_local_cpu_errata(void);
+
 #endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 65b5a8e..da22728 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -15,7 +15,7 @@ arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
 			   entry-fpsimd.o process.o ptrace.o setup.o signal.o	\
 			   sys.o stacktrace.o time.o traps.o io.o vdso.o	\
 			   hyp-stub.o psci.o cpu_ops.o insn.o return_address.o	\
-			   cpuinfo.o alternative.o
+			   cpuinfo.o cpu_errata.o alternative.o
 
 arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
new file mode 100644
index 0000000..9332cf7
--- /dev/null
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -0,0 +1,59 @@
+/*
+ * Contains CPU specific errata definitions
+ *
+ * Copyright (C) 2014 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) "alternative: " fmt
+
+#include <linux/types.h>
+#include <asm/cpu.h>
+#include <asm/cputype.h>
+#include <asm/cpufeature.h>
+
+/*
+ * Add a struct or another datatype to the union below if you need
+ * different means to detect an affected CPU.
+ */
+struct arm64_cpu_capabilities {
+	const char *desc;
+	u16 capability;
+	bool (*is_affected)(struct arm64_cpu_capabilities *);
+	union {
+		struct {
+			u32 midr_model;
+			u32 midr_range_min, midr_range_max;
+		};
+	};
+};
+
+struct arm64_cpu_capabilities arm64_errata[] = {
+	{}
+};
+
+void check_local_cpu_errata(void)
+{
+	struct arm64_cpu_capabilities *cpus = arm64_errata;
+	int i;
+
+	for (i = 0; cpus[i].desc; i++) {
+		if (!cpus[i].is_affected(&cpus[i]))
+			continue;
+
+		if (!cpus_have_cap(cpus[i].capability))
+			pr_info("enabling workaround for %s\n", cpus[i].desc);
+		cpus_set_cap(cpus[i].capability);
+	}
+}
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 504fdaa..16d6d03 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -18,6 +18,7 @@
 #include <asm/cachetype.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
+#include <asm/cpufeature.h>
 
 #include <linux/bitops.h>
 #include <linux/bug.h>
@@ -186,6 +187,8 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_pfr1 = read_cpuid(ID_PFR1_EL1);
 
 	cpuinfo_detect_icache_policy(info);
+
+	check_local_cpu_errata();
 }
 
 void cpuinfo_store_cpu(void)
-- 
1.7.9.5

