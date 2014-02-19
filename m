Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaBSQGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:06:43 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51262 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754306AbaBSQGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:06:37 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: linux-kernel@vger.kernel.org
Cc: sudeep.holla@arm.com, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH RFC/RFT v3 7/9] ARM64: kernel: add support for cpu cache information
Date: Wed, 19 Feb 2014 16:06:14 +0000
Message-Id: <1392825976-17633-8-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

This patch adds support for cacheinfo on ARM64.

On ARMv8, the cache hierarchy can be identified through Cache Level ID
(CLIDR) register while the cache geometry is provided by Cache Size ID
(CCSIDR) register.

Since the architecture doesn't provide any way of detecting the cpus
sharing particular cache, device tree is used for the same purpose.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/kernel/Makefile    |   2 +-
 arch/arm64/kernel/cacheinfo.c | 134 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kernel/cacheinfo.c

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 2d4554b..7d94a51 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -9,7 +9,7 @@ AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
 			   entry-fpsimd.o process.o ptrace.o setup.o signal.o	\
 			   sys.o stacktrace.o time.o traps.o io.o vdso.o	\
-			   hyp-stub.o psci.o cpu_ops.o insn.o
+			   hyp-stub.o psci.o cpu_ops.o insn.o cacheinfo.o
 
 arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o
diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
new file mode 100644
index 0000000..5d8b840
--- /dev/null
+++ b/arch/arm64/kernel/cacheinfo.c
@@ -0,0 +1,134 @@
+/*
+ *  ARM64 cacheinfo support
+ *
+ *  Copyright (C) 2014 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bitops.h>
+#include <linux/cacheinfo.h>
+#include <linux/cpu.h>
+#include <linux/compiler.h>
+#include <linux/of.h>
+
+#include <asm/processor.h>
+
+#define MAX_CACHE_LEVEL			7	/* Max 7 level supported */
+/* Ctypen, bits[3(n - 1) + 2 : 3(n - 1)], for n = 1 to 7 */
+#define CLIDR_CTYPE_SHIFT(level)	(3 * (level - 1))
+#define CLIDR_CTYPE_MASK(level)		(7 << CLIDR_CTYPE_SHIFT(level))
+#define CLIDR_CTYPE(clidr, level)	\
+	(((clidr) & CLIDR_CTYPE_MASK(level)) >> CLIDR_CTYPE_SHIFT(level))
+
+static inline enum cache_type get_cache_type(int level)
+{
+	unsigned int clidr;
+	if (level > MAX_CACHE_LEVEL)
+		return CACHE_TYPE_NOCACHE;
+	asm volatile ("mrs     %0, clidr_el1" : "=r" (clidr));
+	return CLIDR_CTYPE(clidr, level);
+}
+
+/*
+ * NumSets, bits[27:13] - (Number of sets in cache) - 1
+ * Associativity, bits[12:3] - (Associativity of cache) - 1
+ * LineSize, bits[2:0] - (Log2(Number of words in cache line)) - 2
+ */
+#define CCSIDR_WRITE_THROUGH	BIT(31)
+#define CCSIDR_WRITE_BACK	BIT(30)
+#define CCSIDR_READ_ALLOCATE	BIT(29)
+#define CCSIDR_WRITE_ALLOCATE	BIT(28)
+#define CCSIDR_LINESIZE_MASK	0x7
+#define CCSIDR_ASSOCIAT_SHIFT	3
+#define CCSIDR_ASSOCIAT_MASK	0x3FF
+#define CCSIDR_NUMSETS_SHIFT	13
+#define CCSIDR_NUMSETS_MASK	0x7FF
+
+/*
+ * Which cache CCSIDR represents depends on CSSELR value
+ * Make sure no one else changes CSSELR during this
+ * smp_call_function_single prevents preemption for us
+ */
+static inline u32 get_ccsidr(u32 csselr)
+{
+	u32 ccsidr;
+
+	/* Put value into CSSELR */
+	asm volatile("msr csselr_el1, %x0" : : "r" (csselr));
+	isb();
+	/* Read result out of CCSIDR */
+	asm volatile("mrs %0, ccsidr_el1" : "=r" (ccsidr));
+
+	return ccsidr;
+}
+
+static void ci_leaf_init(struct cache_info *this_leaf,
+			 enum cache_type type, unsigned int level)
+{
+	bool is_instr_cache = type & CACHE_TYPE_INST;
+	u32 tmp = get_ccsidr((level - 1) << 1 | is_instr_cache);
+
+	this_leaf->level = level;
+	this_leaf->type = type;
+	this_leaf->coherency_line_size =
+	    (1 << ((tmp & CCSIDR_LINESIZE_MASK) + 2)) * 4;
+	this_leaf->number_of_sets =
+	    ((tmp >> CCSIDR_NUMSETS_SHIFT) & CCSIDR_NUMSETS_MASK) + 1;
+	this_leaf->ways_of_associativity =
+	    ((tmp >> CCSIDR_ASSOCIAT_SHIFT) & CCSIDR_ASSOCIAT_MASK) + 1;
+	this_leaf->size = this_leaf->number_of_sets *
+	    this_leaf->coherency_line_size * this_leaf->ways_of_associativity;
+	this_leaf->attributes =
+		((tmp & CCSIDR_WRITE_THROUGH) ? CACHE_WRITE_THROUGH : 0) |
+		((tmp & CCSIDR_WRITE_BACK) ? CACHE_WRITE_BACK : 0) |
+		((tmp & CCSIDR_READ_ALLOCATE) ? CACHE_READ_ALLOCATE : 0) |
+		((tmp & CCSIDR_WRITE_ALLOCATE) ? CACHE_WRITE_ALLOCATE : 0);
+}
+
+int init_cache_level(unsigned int cpu)
+{
+	unsigned int ctype, level = 1, leaves = 0;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+
+	if (!this_cpu_ci)
+		return -EINVAL;
+
+	do {
+		ctype = get_cache_type(level);
+		if (ctype == CACHE_TYPE_NOCACHE)
+			break;
+		/* Separate instruction and data caches */
+		leaves += (ctype == CACHE_TYPE_SEPARATE) ? 2 : 1;
+	} while (++level <= MAX_CACHE_LEVEL);
+
+	this_cpu_ci->num_levels = level - 1;
+	this_cpu_ci->num_leaves = leaves;
+	return 0;
+}
+
+int populate_cache_leaves(unsigned int cpu)
+{
+	unsigned int level, idx;
+	enum cache_type type;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cache_info *this_leaf = this_cpu_ci->info_list;
+
+	for (idx = 0, level = 1; level <= this_cpu_ci->num_levels &&
+			idx < this_cpu_ci->num_leaves; idx++, level++) {
+		if (!this_leaf)
+			return -EINVAL;
+
+		type = get_cache_type(level);
+		if (type == CACHE_TYPE_SEPARATE) {
+			ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
+			ci_leaf_init(this_leaf++, CACHE_TYPE_INST, level);
+		} else {
+			ci_leaf_init(this_leaf++, type, level);
+		}
+	}
+	return 0;
+}
-- 
1.8.3.2

