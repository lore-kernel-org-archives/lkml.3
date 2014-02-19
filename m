Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaBSQGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:06:46 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51383 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754348AbaBSQGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:06:43 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: linux-kernel@vger.kernel.org
Cc: sudeep.holla@arm.com, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH RFC/RFT v3 8/9] ARM: kernel: add support for cpu cache information
Date: Wed, 19 Feb 2014 16:06:15 +0000
Message-Id: <1392825976-17633-9-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

This patch adds support for cacheinfo on ARM platforms.

On ARMv7, the cache hierarchy can be identified through Cache Level ID
register(CLIDR) while the cache geometry is provided by Cache Size ID
register(CCSIDR).

On architecture versions before ARMv7, CLIDR and CCSIDR is not
implemented. The cache type register(CTR) provides both cache hierarchy
and geometry if implemented. For implementations that doesn't support
CTR, we need to list the probable value of CTR if it was implemented
along with the cpuid for the sake of simplicity to handle them.

Since the architecture doesn't provide any way of detecting the cpus
sharing particular cache, device tree is used fo the same purpose.
On non-DT platforms, first level caches are per-cpu while higher level
caches are assumed system-wide.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/Makefile    |   1 +
 arch/arm/kernel/cacheinfo.c | 228 ++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/Kconfig         |  13 +++
 3 files changed, 242 insertions(+)
 create mode 100644 arch/arm/kernel/cacheinfo.c

diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index a30fc9b..f86a4ff 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -29,6 +29,7 @@ obj-y		+= entry-v7m.o v7m.o
 else
 obj-y		+= entry-armv.o
 endif
+obj-$(CONFIG_CPU_HAS_CACHE) += cacheinfo.o
 
 obj-$(CONFIG_OC_ETM)		+= etm.o
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
diff --git a/arch/arm/kernel/cacheinfo.c b/arch/arm/kernel/cacheinfo.c
new file mode 100644
index 0000000..10045b7
--- /dev/null
+++ b/arch/arm/kernel/cacheinfo.c
@@ -0,0 +1,228 @@
+/*
+ *  ARM cacheinfo support
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
+#include <asm/cputype.h>
+#include <asm/processor.h>
+
+#if __LINUX_ARM_ARCH__ < 7 /* pre ARMv7 */
+
+#define MAX_CACHE_LEVEL		1	/* Only 1 level supported */
+#define CTR_CTYPE_SHIFT		24
+#define CTR_CTYPE_MASK		(1 << CTR_CTYPE_SHIFT)
+
+struct ctr_info {
+	unsigned int cpuid_id;
+	unsigned int ctr;
+};
+
+static struct ctr_info cache_ctr_list[] = {
+};
+
+static int get_unimplemented_ctr(unsigned int *ctr)
+{
+	int i, cpuid_id = read_cpuid_id();
+	for (i = 0; i < ARRAY_SIZE(cache_ctr_list); i++)
+		if (cache_ctr_list[i].cpuid_id == cpuid_id) {
+			*ctr = cache_ctr_list[i].ctr;
+			return 0;
+		}
+	return -ENOENT;
+}
+
+static unsigned int get_ctr(void)
+{
+	unsigned int ctr;
+	if (get_unimplemented_ctr(&ctr))
+		asm volatile ("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
+	return ctr;
+}
+
+static enum cache_type get_cache_type(int level)
+{
+	if (level > MAX_CACHE_LEVEL)
+		return CACHE_TYPE_NOCACHE;
+	return get_ctr() & CTR_CTYPE_MASK ?
+		CACHE_TYPE_SEPARATE : CACHE_TYPE_UNIFIED;
+}
+
+/*
+ *  +---------------------------------+
+ *  | 9  8  7  6 | 5  4  3 | 2 | 1  0 |
+ *  +---------------------------------+
+ *  |    size    |  assoc  | m |  len |
+ *  +---------------------------------+
+ * linelen        = 1 << (len + 3)
+ * multiplier     = 2 + m
+ * nsets          = 1 << (size + 6 - assoc - len)
+ * associativity  = multiplier << (assoc - 1)
+ * cache_size     = multiplier << (size + 8)
+ */
+#define CTR_LINESIZE_MASK	0x3
+#define CTR_MULTIPLIER_SHIFT	2
+#define CTR_MULTIPLIER_MASK	0x1
+#define CTR_ASSOCIAT_SHIFT	3
+#define CTR_ASSOCIAT_MASK	0x7
+#define CTR_SIZE_SHIFT		6
+#define CTR_SIZE_MASK		0xF
+#define CTR_DCACHE_SHIFT	12
+
+static void __ci_leaf_init(enum cache_type type,
+				  struct cache_info *this_leaf)
+{
+	unsigned int size, multiplier, assoc, len, tmp = get_ctr();
+
+	if (type == CACHE_TYPE_DATA)
+		tmp >>= CTR_DCACHE_SHIFT;
+
+	len = tmp & CTR_LINESIZE_MASK;
+	size = (tmp >> CTR_SIZE_SHIFT) & CTR_SIZE_MASK;
+	assoc = (tmp >> CTR_ASSOCIAT_SHIFT) & CTR_ASSOCIAT_MASK;
+	multiplier = ((tmp >> CTR_MULTIPLIER_SHIFT) & CTR_MULTIPLIER_MASK) + 2;
+
+	this_leaf->type = type;
+	this_leaf->coherency_line_size = 1 << (len + 3);
+	this_leaf->number_of_sets = 1 << (size + 6 - assoc - len);
+	this_leaf->ways_of_associativity = multiplier << (assoc - 1);
+	this_leaf->size = multiplier << (size + 8);
+}
+
+#else /* ARMv7 */
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
+	asm volatile ("mrc p15, 1, %0, c0, c0, 1" : "=r" (clidr));
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
+	asm volatile ("mcr p15, 2, %0, c0, c0, 0" : : "r" (csselr));
+	isb();
+	/* Read result out of CCSIDR */
+	asm volatile ("mrc p15, 1, %0, c0, c0, 0" : "=r" (ccsidr));
+
+	return ccsidr;
+}
+
+static void __ci_leaf_init(enum cache_type type,
+				  struct cache_info *this_leaf)
+{
+	bool is_instr_cache = type & CACHE_TYPE_INST;
+	u32 tmp = get_ccsidr((this_leaf->level - 1) << 1 | is_instr_cache);
+
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
+#endif
+
+static void ci_leaf_init(struct cache_info *this_leaf,
+			 enum cache_type type, unsigned int level)
+{
+	this_leaf->level = level;
+	__ci_leaf_init(type, this_leaf);
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
+
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
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 1f8fed9..c4abb89 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -495,30 +495,42 @@ config CPU_PABRT_V7
 # The cache model
 config CPU_CACHE_V4
 	bool
+	select CPU_HAS_CACHE
 
 config CPU_CACHE_V4WT
 	bool
+	select CPU_HAS_CACHE
 
 config CPU_CACHE_V4WB
 	bool
+	select CPU_HAS_CACHE
 
 config CPU_CACHE_V6
 	bool
+	select CPU_HAS_CACHE
 
 config CPU_CACHE_V7
 	bool
+	select CPU_HAS_CACHE
 
 config CPU_CACHE_NOP
 	bool
+	select CPU_HAS_CACHE
 
 config CPU_CACHE_VIVT
 	bool
+	select CPU_HAS_CACHE
 
 config CPU_CACHE_VIPT
 	bool
+	select CPU_HAS_CACHE
 
 config CPU_CACHE_FA
 	bool
+	select CPU_HAS_CACHE
+
+config CPU_HAS_CACHE
+	bool
 
 if MMU
 # The copy-page model
@@ -846,6 +858,7 @@ config DMA_CACHE_RWFO
 
 config OUTER_CACHE
 	bool
+	select CPU_HAS_CACHE
 
 config OUTER_CACHE_SYNC
 	bool
-- 
1.8.3.2

