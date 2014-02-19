Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaBSQHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:07:00 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51411 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754423AbaBSQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:06:45 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: linux-kernel@vger.kernel.org
Cc: sudeep.holla@arm.com, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH RFC/RFT v3 9/9] ARM: kernel: add outer cache support for cacheinfo implementation
Date: Wed, 19 Feb 2014 16:06:16 +0000
Message-Id: <1392825976-17633-10-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
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
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/include/asm/outercache.h | 13 +++++++++++++
 arch/arm/kernel/cacheinfo.c       | 22 +++++++++++++++++++++-
 arch/arm/mm/cache-l2x0.c          | 14 ++++++++++++++
 arch/arm/mm/cache-tauros2.c       | 35 +++++++++++++++++++++++++++++++++++
 arch/arm/mm/cache-xsc3l2.c        | 15 +++++++++++++++
 5 files changed, 98 insertions(+), 1 deletion(-)

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
index 10045b7..4463833 100644
--- a/arch/arm/kernel/cacheinfo.c
+++ b/arch/arm/kernel/cacheinfo.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 
 #include <asm/cputype.h>
+#include <asm/outercache.h>
 #include <asm/processor.h>
 
 #if __LINUX_ARM_ARCH__ < 7 /* pre ARMv7 */
@@ -175,11 +176,27 @@ static void __ci_leaf_init(enum cache_type type,
 
 #endif
 
+static void __outer_ci_leaf_init(struct cache_info *this_leaf)
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
+}
+
 static void ci_leaf_init(struct cache_info *this_leaf,
 			 enum cache_type type, unsigned int level)
 {
 	this_leaf->level = level;
-	__ci_leaf_init(type, this_leaf);
+	if (type == CACHE_TYPE_NOCACHE)	/* must be outer cache */
+		__outer_ci_leaf_init(this_leaf);
+	else
+		__ci_leaf_init(type, this_leaf);
 }
 
 int init_cache_level(unsigned int cpu)
@@ -201,6 +218,9 @@ int init_cache_level(unsigned int cpu)
 	this_cpu_ci->num_levels = level - 1;
 	this_cpu_ci->num_leaves = leaves;
 
+	if (IS_ENABLED(CONFIG_OUTER_CACHE) && outer_cache.get_info)
+		this_cpu_ci->num_leaves++, this_cpu_ci->num_levels++;
+
 	return 0;
 }
 
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 7abde2ce..b850771 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -183,6 +183,15 @@ static void l2x0_inv_all(void)
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
@@ -416,6 +425,7 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 		outer_cache.flush_all = l2x0_flush_all;
 		outer_cache.inv_all = l2x0_inv_all;
 		outer_cache.disable = l2x0_disable;
+		outer_cache.get_info = l2x0_getinfo;
 	}
 
 	pr_info("%s cache controller enabled\n", type);
@@ -886,6 +896,7 @@ static const struct l2x0_of_data pl310_data = {
 		.flush_all   = l2x0_flush_all,
 		.inv_all     = l2x0_inv_all,
 		.disable     = l2x0_disable,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -901,6 +912,7 @@ static const struct l2x0_of_data l2x0_data = {
 		.flush_all   = l2x0_flush_all,
 		.inv_all     = l2x0_inv_all,
 		.disable     = l2x0_disable,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -916,6 +928,7 @@ static const struct l2x0_of_data aurora_with_outer_data = {
 		.flush_all   = l2x0_flush_all,
 		.inv_all     = l2x0_inv_all,
 		.disable     = l2x0_disable,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -948,6 +961,7 @@ static const struct l2x0_of_data bcm_l2x0_data = {
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

