Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696AbaGYQpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:45:14 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54131 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934611AbaGYQpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:45:11 -0400
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: sudeep.holla@arm.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 8/9] ARM: kernel: add support for cpu cache information
Date: Fri, 25 Jul 2014 17:44:51 +0100
Message-Id: <1406306692-7135-9-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com>
 <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>
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
 arch/arm/kernel/cacheinfo.c | 272 ++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/Kconfig         |  13 +++
 3 files changed, 286 insertions(+)
 create mode 100644 arch/arm/kernel/cacheinfo.c

--->8

Hi Russell,

Since for few CPUs like ARM11MP core which implements VMSAv6 + Advanced OS
Features, Linux returns cpu_architecture as armv7, I have added a list
for that as they are armv6 and don't implement CLIDR and group.
Let me know if there's any alternative to handle that.

This also depends on your patch
"ARM: make it easier to check the CPU part number correctly"

Regards,
Sudeep

diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 38ddd9f83d0e..2c5ff0efb670 100644
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
index 000000000000..427ba641b33a
--- /dev/null
+++ b/arch/arm/kernel/cacheinfo.c
@@ -0,0 +1,272 @@
+/*
+ *  ARM cacheinfo support
+ *
+ *  Copyright (C) 2014 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
+#include <asm/system_info.h>
+
+#define cache_is_armv7() \
+	(cpu_architecture() >= CPU_ARCH_ARMv7 && !armv6_extended())
+#define MAX_CACHE_LEVEL		(cache_is_armv7() ? 7 : 1)
+
+#define CTR_CTYPE_SHIFT		24
+#define CTR_CTYPE_MASK		(1 << CTR_CTYPE_SHIFT)
+
+struct ctr_info {
+	unsigned int cpuid_part;
+	unsigned int ctr;
+};
+/*
+ *  Cache Type Register
+ *  +---------------------------------+
+ *  | 31 29 | 28 25 |24| 23 12 | 11 0 |
+ *  +---------------------------------+
+ *  | 0 0 0 | Ctype | S| Dsize | Isize|
+ *  +---------------------------------+
+ * The table below encodes only Dsize and Isize
+ */
+static struct ctr_info cache_ctr_list[] = {
+	{0x4400a100, 0x0016A16A }, /* 32kB D$, 32kB I$ */
+	{0x4400a110, 0x0012A16A }, /* 16kB D$, 32kB I$ */
+	{0x6900b110, 0x0012A16A }, /* 16kB D$, 32kB I$ */
+};
+
+/*
+ * List of CPUs reported as ARMv7 but don't implement CLIDR,
+ * CSSELR and CCSIDR. Cache information is still available from CTR
+ */
+static int armv6_ext_cpuid_part[] = { 0x4100b020, };
+
+static bool armv6_extended(void)
+{
+	int i, cpuid_part = read_cpuid_part();
+
+	for (i = 0; i < ARRAY_SIZE(armv6_ext_cpuid_part); i++)
+		if (armv6_ext_cpuid_part[i] == cpuid_part)
+			return true;
+	return false;
+}
+
+static int get_unimplemented_ctr(unsigned int *ctr)
+{
+	int i, cpuid_part = read_cpuid_part();
+
+	for (i = 0; i < ARRAY_SIZE(cache_ctr_list); i++)
+		if (cache_ctr_list[i].cpuid_part == cpuid_part) {
+			*ctr = cache_ctr_list[i].ctr;
+			return 0;
+		}
+	return -ENOENT;
+}
+
+static unsigned int get_ctr(void)
+{
+	unsigned int ctr;
+
+	if (get_unimplemented_ctr(&ctr))
+		ctr = read_cpuid_cachetype();
+	return ctr;
+}
+
+static enum cache_type __get_cache_type(int level)
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
+static void __ci_leaf_init(enum cache_type type, struct cacheinfo *this_leaf)
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
+/* Ctypen, bits[3(n - 1) + 2 : 3(n - 1)], for n = 1 to 7 */
+#define CLIDR_CTYPE_SHIFT(level)	(3 * (level - 1))
+#define CLIDR_CTYPE_MASK(level)		(7 << CLIDR_CTYPE_SHIFT(level))
+#define CLIDR_CTYPE(clidr, level)	\
+	(((clidr) & CLIDR_CTYPE_MASK(level)) >> CLIDR_CTYPE_SHIFT(level))
+
+static inline enum cache_type __armv7_get_cache_type(int level)
+{
+	unsigned int clidr;
+
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
+#define CCSIDR_WRITE_THROUGH		BIT(31)
+#define CCSIDR_WRITE_BACK		BIT(30)
+#define CCSIDR_READ_ALLOCATE		BIT(29)
+#define CCSIDR_WRITE_ALLOCATE		BIT(28)
+#define CCSIDR_LINESIZE_MASK		0x7
+#define CCSIDR_ASSOCIATIVITY_SHIFT	3
+#define CCSIDR_ASSOCIATIVITY_MASK	0x3FF
+#define CCSIDR_NUMSETS_SHIFT		13
+#define CCSIDR_NUMSETS_MASK		0x7FF
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
+static void __armv7_ci_leaf_init(enum cache_type type,
+				 struct cacheinfo *this_leaf)
+{
+	bool is_instr_cache = type & CACHE_TYPE_INST;
+	u32 tmp = get_ccsidr((this_leaf->level - 1) << 1 | is_instr_cache);
+
+	this_leaf->type = type;
+	this_leaf->coherency_line_size =
+	    (1 << ((tmp & CCSIDR_LINESIZE_MASK) + 2)) * 4;
+	this_leaf->number_of_sets =
+	    ((tmp >> CCSIDR_NUMSETS_SHIFT) & CCSIDR_NUMSETS_MASK) + 1;
+	this_leaf->ways_of_associativity = ((tmp >> CCSIDR_ASSOCIATIVITY_SHIFT)
+					    & CCSIDR_ASSOCIATIVITY_MASK) + 1;
+	this_leaf->size = this_leaf->number_of_sets *
+	    this_leaf->coherency_line_size * this_leaf->ways_of_associativity;
+	this_leaf->attributes =
+		((tmp & CCSIDR_WRITE_THROUGH) ? CACHE_WRITE_THROUGH : 0) |
+		((tmp & CCSIDR_WRITE_BACK) ? CACHE_WRITE_BACK : 0) |
+		((tmp & CCSIDR_READ_ALLOCATE) ? CACHE_READ_ALLOCATE : 0) |
+		((tmp & CCSIDR_WRITE_ALLOCATE) ? CACHE_WRITE_ALLOCATE : 0);
+}
+
+static inline enum cache_type get_cache_type(int level)
+{
+	if (cache_is_armv7())
+		return __armv7_get_cache_type(level);
+	else
+		return __get_cache_type(level);
+}
+
+static void ci_leaf_init(struct cacheinfo *this_leaf,
+			 enum cache_type type, unsigned int level)
+{
+	this_leaf->level = level;
+	if (cache_is_armv7())
+		__armv7_ci_leaf_init(type, this_leaf);
+	else
+		__ci_leaf_init(type, this_leaf);
+}
+
+static int __init_cache_level(unsigned int cpu)
+{
+	unsigned int ctype, level, leaves;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+
+	for (level = 1, leaves = 0; level <= MAX_CACHE_LEVEL; level++) {
+		ctype = get_cache_type(level);
+		if (ctype == CACHE_TYPE_NOCACHE) {
+			level--;
+			break;
+		}
+		/* Separate instruction and data caches */
+		leaves += (ctype == CACHE_TYPE_SEPARATE) ? 2 : 1;
+	}
+
+	this_cpu_ci->num_levels = level;
+	this_cpu_ci->num_leaves = leaves;
+
+	return 0;
+}
+
+static int __populate_cache_leaves(unsigned int cpu)
+{
+	unsigned int level, idx;
+	enum cache_type type;
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct cacheinfo *this_leaf = this_cpu_ci->info_list;
+
+	for (idx = 0, level = 1; level <= this_cpu_ci->num_levels &&
+	     idx < this_cpu_ci->num_leaves; idx++, level++) {
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
+
+DEFINE_SMP_CALL_FUNCTION(init_cache_level)
+DEFINE_SMP_CALL_FUNCTION(populate_cache_leaves)
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index c348eaee7ee2..153abc3bac4e 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -494,30 +494,42 @@ config CPU_PABRT_V7
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
@@ -845,6 +857,7 @@ config DMA_CACHE_RWFO
 
 config OUTER_CACHE
 	bool
+	select CPU_HAS_CACHE
 
 config OUTER_CACHE_SYNC
 	bool
-- 
1.8.3.2

