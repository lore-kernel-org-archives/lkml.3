Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbaAHT1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:27:40 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54436 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750839AbaAHT1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:27:34 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: x86@kernel.org, linuxppc-dev@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: sudeep.holla@arm.com, Ashok Raj <ashok.raj@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH RFC 3/3] ARM: kernel: add outer cache support for cacheinfo implementation
Date: Wed,  8 Jan 2014 19:26:08 +0000
Message-Id: <1389209168-17189-4-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com>
References: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

In order to support outer cache in the cacheinfo infrastructure, a new
function 'get_info' is added to outer_cache_fns. This function is used
to get the outer cache information namely: line size, number of ways of
associativity and number of sets.

This patch adds 'get_info' supports to all L2 cache implementations on
ARM except Marvell's Feroceon L2 cache.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm/include/asm/outercache.h | 13 +++++++++++++
 arch/arm/kernel/cacheinfo.c       | 21 ++++++++++++++++++++-
 arch/arm/mm/cache-l2x0.c          | 14 ++++++++++++++
 arch/arm/mm/cache-tauros2.c       | 35 +++++++++++++++++++++++++++++++++++
 arch/arm/mm/cache-xsc3l2.c        | 15 +++++++++++++++
 5 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index f94784f..1471ff2 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -23,7 +23,14 @@
 
 #include <linux/types.h>
 
+struct outer_cache_info {
+	unsigned int num_ways;
+	unsigned int num_sets;
+	unsigned int line_size;
+};
+
 struct outer_cache_fns {
+	void (*get_info)(struct outer_cache_info *info);
 	void (*inv_range)(unsigned long, unsigned long);
 	void (*clean_range)(unsigned long, unsigned long);
 	void (*flush_range)(unsigned long, unsigned long);
@@ -41,6 +48,11 @@ extern struct outer_cache_fns outer_cache;
 
 #ifdef CONFIG_OUTER_CACHE
 
+static inline void outer_get_info(struct outer_cache_info *info)
+{
+	if (outer_cache.get_info)
+		outer_cache.get_info(info);
+}
 static inline void outer_inv_range(phys_addr_t start, phys_addr_t end)
 {
 	if (outer_cache.inv_range)
@@ -83,6 +95,7 @@ static inline void outer_resume(void)
 
 #else
 
+static inline void outer_get_info(struct outer_cache_info *info) { }
 static inline void outer_inv_range(phys_addr_t start, phys_addr_t end)
 { }
 static inline void outer_clean_range(phys_addr_t start, phys_addr_t end)
diff --git a/arch/arm/kernel/cacheinfo.c b/arch/arm/kernel/cacheinfo.c
index 5f8a89e..d3bcd05 100644
--- a/arch/arm/kernel/cacheinfo.c
+++ b/arch/arm/kernel/cacheinfo.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 
+#include <asm/outercache.h>
 #include <asm/processor.h>
 
 enum cache_type {
@@ -288,6 +289,21 @@ static void init_cache_level(unsigned int cpu)
 	} while (++level <= MAX_CACHE_LEVEL);
 	cache_levels(cpu) = level - 1;
 	cache_leaves(cpu) = leaves;
+	if (IS_ENABLED(CONFIG_OUTER_CACHE) && outer_cache.get_info)
+		cache_levels(cpu)++, cache_leaves(cpu)++;
+}
+
+static void __outer_cache_info_init(struct cache_info *this_leaf)
+{
+	struct outer_cache_info info;
+
+	outer_get_info(&info);
+
+	this_leaf->type = CACHE_TYPE_UNIFIED;/* record it as Unified */
+	this_leaf->ways_of_associativity = info.num_ways;
+	this_leaf->number_of_sets = info.num_sets;
+	this_leaf->coherency_line_size = info.line_size;
+	this_leaf->size = info.num_ways * info.num_sets * info.line_size;
 }
 
 static void cpu_cache_info_init(unsigned int cpu, enum cache_type type,
@@ -297,7 +313,10 @@ static void cpu_cache_info_init(unsigned int cpu, enum cache_type type,
 
 	this_leaf = CPU_CACHEINFO_IDX(cpu, index);
 	this_leaf->info.level = level;
-	__cpu_cache_info_init(type, &this_leaf->info);
+	if (type == CACHE_TYPE_NOCACHE)	/* must be outer cache */
+		__outer_cache_info_init(&this_leaf->info);
+	else
+		__cpu_cache_info_init(type, &this_leaf->info);
 }
 
 static void init_cache_leaves(unsigned int cpu)
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 447da6f..6f0d1fc 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -182,6 +182,15 @@ static void l2x0_inv_all(void)
 	raw_spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
+static void l2x0_getinfo(struct outer_cache_info *info)
+{
+	if (!info)
+		return;
+	info->num_ways = get_count_order(l2x0_way_mask);
+	info->line_size = CACHE_LINE_SIZE;
+	info->num_sets = l2x0_size / (info->num_ways * CACHE_LINE_SIZE);
+}
+
 static void l2x0_inv_range(unsigned long start, unsigned long end)
 {
 	void __iomem *base = l2x0_base;
@@ -415,6 +424,7 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 		outer_cache.flush_all = l2x0_flush_all;
 		outer_cache.inv_all = l2x0_inv_all;
 		outer_cache.disable = l2x0_disable;
+		outer_cache.get_info = l2x0_getinfo;
 	}
 
 	pr_info("%s cache controller enabled\n", type);
@@ -865,6 +875,7 @@ static const struct l2x0_of_data pl310_data = {
 		.flush_all   = l2x0_flush_all,
 		.inv_all     = l2x0_inv_all,
 		.disable     = l2x0_disable,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -880,6 +891,7 @@ static const struct l2x0_of_data l2x0_data = {
 		.flush_all   = l2x0_flush_all,
 		.inv_all     = l2x0_inv_all,
 		.disable     = l2x0_disable,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -895,6 +907,7 @@ static const struct l2x0_of_data aurora_with_outer_data = {
 		.flush_all   = l2x0_flush_all,
 		.inv_all     = l2x0_inv_all,
 		.disable     = l2x0_disable,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -918,6 +931,7 @@ static const struct l2x0_of_data bcm_l2x0_data = {
 		.flush_all   = l2x0_flush_all,
 		.inv_all     = l2x0_inv_all,
 		.disable     = l2x0_disable,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
diff --git a/arch/arm/mm/cache-tauros2.c b/arch/arm/mm/cache-tauros2.c
index 1be0f4e..3a43401 100644
--- a/arch/arm/mm/cache-tauros2.c
+++ b/arch/arm/mm/cache-tauros2.c
@@ -60,6 +60,7 @@ static inline void tauros2_inv_pa(unsigned long addr)
  * noninclusive.
  */
 #define CACHE_LINE_SIZE		32
+#define CACHE_LINE_SHIFT	5
 
 static void tauros2_inv_range(unsigned long start, unsigned long end)
 {
@@ -131,6 +132,38 @@ static void tauros2_resume(void)
 	"mcr	p15, 0, %0, c1, c0, 0 @Enable L2 Cache\n\t"
 	: : "r" (0x0));
 }
+
+/*
+ *  +----------------------------------------+
+ *  | 11 10 9  8 | 7  6  5  4  3 | 2 |  1  0 |
+ *  +----------------------------------------+
+ *  |  way size  | associativity | - |line_sz|
+ *  +----------------------------------------+
+ */
+#define L2CTR_ASSOCIAT_SHIFT	3
+#define L2CTR_ASSOCIAT_MASK	0x1F
+#define L2CTR_WAYSIZE_SHIFT	8
+#define L2CTR_WAYSIZE_MASK	0xF
+#define CACHE_WAY_PER_SET(l2ctr)	\
+	(((l2_ctr) >> L2CTR_ASSOCIAT_SHIFT) & L2CTR_ASSOCIAT_MASK)
+#define CACHE_WAY_SIZE(l2ctr)		\
+	(8192 << (((l2ctr) >> L2CTR_WAYSIZE_SHIFT) & L2CTR_WAYSIZE_MASK))
+#define CACHE_SET_SIZE(l2ctr)	(CACHE_WAY_SIZE(l2ctr) >> CACHE_LINE_SHIFT)
+
+static void tauros2_getinfo(struct outer_cache_info *info)
+{
+	unsigned int l2_ctr;
+
+	if (!info)
+		return;
+
+	__asm__("mrc p15, 1, %0, c0, c0, 1" : "=r" (l2_ctr));
+
+	info->line_size = CACHE_LINE_SIZE;
+	info->num_ways = CACHE_WAY_PER_SET(l2_ctr);
+	info->num_sets = CACHE_SET_SIZE(l2_ctr);
+}
+
 #endif
 
 static inline u32 __init read_extra_features(void)
@@ -226,6 +259,7 @@ static void __init tauros2_internal_init(unsigned int features)
 		outer_cache.flush_range = tauros2_flush_range;
 		outer_cache.disable = tauros2_disable;
 		outer_cache.resume = tauros2_resume;
+		outer_cache.get_info = tauros2_getinfo;
 	}
 #endif
 
@@ -253,6 +287,7 @@ static void __init tauros2_internal_init(unsigned int features)
 		outer_cache.flush_range = tauros2_flush_range;
 		outer_cache.disable = tauros2_disable;
 		outer_cache.resume = tauros2_resume;
+		outer_cache.get_info = tauros2_getinfo;
 	}
 #endif
 
diff --git a/arch/arm/mm/cache-xsc3l2.c b/arch/arm/mm/cache-xsc3l2.c
index 6c3edeb..353c642 100644
--- a/arch/arm/mm/cache-xsc3l2.c
+++ b/arch/arm/mm/cache-xsc3l2.c
@@ -201,6 +201,20 @@ static void xsc3_l2_flush_range(unsigned long start, unsigned long end)
 	dsb();
 }
 
+static void xsc3_l2_getinfo(struct outer_cache_info *info)
+{
+	unsigned long l2ctype;
+
+	if (!info)
+		return;
+
+	__asm__("mrc p15, 1, %0, c0, c0, 1" : "=r" (l2ctype));
+
+	info->num_ways = CACHE_WAY_PER_SET;
+	info->line_size = CACHE_LINE_SIZE;
+	info->num_sets = CACHE_SET_SIZE(l2ctype);
+}
+
 static int __init xsc3_l2_init(void)
 {
 	if (!cpu_is_xsc3() || !xsc3_l2_present())
@@ -213,6 +227,7 @@ static int __init xsc3_l2_init(void)
 		outer_cache.inv_range = xsc3_l2_inv_range;
 		outer_cache.clean_range = xsc3_l2_clean_range;
 		outer_cache.flush_range = xsc3_l2_flush_range;
+		outer_cache.get_info    = xsc3_l2_getinfo;
 	}
 
 	return 0;
-- 
1.8.3.2

