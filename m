Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835AbaGYQqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:46:51 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54117 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934542AbaGYQpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:45:08 -0400
From: Sudeep Holla <sudeep.holla@arm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: sudeep.holla@arm.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 9/9] ARM: kernel: add outer cache support for cacheinfo implementation
Date: Fri, 25 Jul 2014 17:44:52 +0100
Message-Id: <1406306692-7135-10-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com>
 <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>
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
 arch/arm/include/asm/outercache.h |  9 +++++++++
 arch/arm/kernel/cacheinfo.c       | 14 +++++++++++++-
 arch/arm/mm/cache-l2x0.c          | 35 ++++++++++++++++++++++++++++++++++-
 arch/arm/mm/cache-tauros2.c       | 35 +++++++++++++++++++++++++++++++++++
 arch/arm/mm/cache-xsc3l2.c        | 16 ++++++++++++++++
 5 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index 891a56b35bcf..2765c8c61c8c 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -23,7 +23,10 @@
 
 #include <linux/types.h>
 
+struct cacheinfo;
+
 struct outer_cache_fns {
+	void (*get_info)(struct cacheinfo *info);
 	void (*inv_range)(unsigned long, unsigned long);
 	void (*clean_range)(unsigned long, unsigned long);
 	void (*flush_range)(unsigned long, unsigned long);
@@ -112,6 +115,11 @@ static inline void outer_resume(void)
 		outer_cache.resume();
 }
 
+static inline void outer_get_info(struct cacheinfo *info)
+{
+	if (outer_cache.get_info)
+		outer_cache.get_info(info);
+}
 #else
 
 static inline void outer_inv_range(phys_addr_t start, phys_addr_t end)
@@ -123,6 +131,7 @@ static inline void outer_flush_range(phys_addr_t start, phys_addr_t end)
 static inline void outer_flush_all(void) { }
 static inline void outer_disable(void) { }
 static inline void outer_resume(void) { }
+static inline void outer_get_info(struct outer_cache_info *info) { }
 
 #endif
 
diff --git a/arch/arm/kernel/cacheinfo.c b/arch/arm/kernel/cacheinfo.c
index 427ba641b33a..9a516e43bbf5 100644
--- a/arch/arm/kernel/cacheinfo.c
+++ b/arch/arm/kernel/cacheinfo.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 
 #include <asm/cputype.h>
+#include <asm/outercache.h>
 #include <asm/processor.h>
 #include <asm/system_info.h>
 
@@ -217,11 +218,19 @@ static inline enum cache_type get_cache_type(int level)
 		return __get_cache_type(level);
 }
 
+static inline void __outer_ci_leaf_init(struct cacheinfo *this_leaf)
+{
+	outer_get_info(this_leaf);
+	BUG_ON(this_leaf->type == CACHE_TYPE_SEPARATE);
+}
+
 static void ci_leaf_init(struct cacheinfo *this_leaf,
 			 enum cache_type type, unsigned int level)
 {
 	this_leaf->level = level;
-	if (cache_is_armv7())
+	if (type == CACHE_TYPE_NOCACHE)	/* must be outer cache */
+		__outer_ci_leaf_init(this_leaf);
+	else if (cache_is_armv7())
 		__armv7_ci_leaf_init(type, this_leaf);
 	else
 		__ci_leaf_init(type, this_leaf);
@@ -245,6 +254,9 @@ static int __init_cache_level(unsigned int cpu)
 	this_cpu_ci->num_levels = level;
 	this_cpu_ci->num_leaves = leaves;
 
+	if (IS_ENABLED(CONFIG_OUTER_CACHE) && outer_cache.get_info)
+		this_cpu_ci->num_leaves++, this_cpu_ci->num_levels++;
+
 	return 0;
 }
 
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 7c3fb41a462e..503bafdeb25b 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -17,6 +17,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 #include <linux/cpu.h>
+#include <linux/cacheinfo.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/smp.h>
@@ -105,6 +106,22 @@ static inline void l2c_unlock(void __iomem *base, unsigned num)
 	}
 }
 
+static void __l2x0_getinfo(struct cacheinfo *this_leaf)
+{
+	unsigned int assoc = get_count_order(l2x0_way_mask);
+
+	this_leaf->size = l2x0_size;
+	this_leaf->coherency_line_size = CACHE_LINE_SIZE;
+	this_leaf->ways_of_associativity = assoc;
+	this_leaf->number_of_sets = l2x0_size / (assoc * CACHE_LINE_SIZE);
+}
+
+static void l2x0_getinfo(struct cacheinfo *this_leaf)
+{
+	this_leaf->type = CACHE_TYPE_UNIFIED;
+	__l2x0_getinfo(this_leaf);
+}
+
 /*
  * Enable the L2 cache controller.  This function must only be
  * called when the cache controller is known to be disabled.
@@ -309,6 +326,7 @@ static const struct l2c_init_data l2c210_data __initconst = {
 		.disable = l2c_disable,
 		.sync = l2c210_sync,
 		.resume = l2c210_resume,
+		.get_info = l2x0_getinfo,
 	},
 };
 
@@ -466,6 +484,7 @@ static const struct l2c_init_data l2c220_data = {
 		.disable = l2c_disable,
 		.sync = l2c220_sync,
 		.resume = l2c210_resume,
+		.get_info = l2x0_getinfo,
 	},
 };
 
@@ -814,6 +833,7 @@ static const struct l2c_init_data l2c310_init_fns __initconst = {
 		.disable = l2c310_disable,
 		.sync = l2c210_sync,
 		.resume = l2c310_resume,
+		.get_info = l2x0_getinfo,
 	},
 };
 
@@ -894,7 +914,6 @@ static void __init __l2c_init(const struct l2c_init_data *data,
 		data->enable(l2x0_base, aux, data->num_lock);
 
 	outer_cache = fns;
-
 	/*
 	 * It is strange to save the register state before initialisation,
 	 * but hey, this is what the DT implementations decided to do.
@@ -994,6 +1013,7 @@ static const struct l2c_init_data of_l2c210_data __initconst = {
 		.disable     = l2c_disable,
 		.sync        = l2c210_sync,
 		.resume      = l2c210_resume,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -1012,6 +1032,7 @@ static const struct l2c_init_data of_l2c220_data __initconst = {
 		.disable     = l2c_disable,
 		.sync        = l2c220_sync,
 		.resume      = l2c210_resume,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -1065,6 +1086,7 @@ static const struct l2c_init_data of_l2c310_data __initconst = {
 		.disable     = l2c310_disable,
 		.sync        = l2c210_sync,
 		.resume      = l2c310_resume,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -1092,6 +1114,7 @@ static const struct l2c_init_data of_l2c310_coherent_data __initconst = {
 		.flush_all   = l2c210_flush_all,
 		.disable     = l2c310_disable,
 		.resume      = l2c310_resume,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -1255,6 +1278,12 @@ static void __init aurora_of_parse(const struct device_node *np,
 	*aux_mask &= ~mask;
 }
 
+static void aurora_no_outer_data_getinfo(struct cacheinfo *this_leaf)
+{
+	this_leaf->type = CACHE_TYPE_INST;
+	__l2x0_getinfo(this_leaf);
+}
+
 static const struct l2c_init_data of_aurora_with_outer_data __initconst = {
 	.type = "Aurora",
 	.way_size_0 = SZ_4K,
@@ -1271,6 +1300,7 @@ static const struct l2c_init_data of_aurora_with_outer_data __initconst = {
 		.disable     = l2x0_disable,
 		.sync        = l2x0_cache_sync,
 		.resume      = aurora_resume,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -1284,6 +1314,7 @@ static const struct l2c_init_data of_aurora_no_outer_data __initconst = {
 	.save  = aurora_save,
 	.outer_cache = {
 		.resume      = aurora_resume,
+		.get_info    = aurora_no_outer_data_getinfo,
 	},
 };
 
@@ -1439,6 +1470,7 @@ static const struct l2c_init_data of_bcm_l2x0_data __initconst = {
 		.disable     = l2c310_disable,
 		.sync        = l2c210_sync,
 		.resume      = l2c310_resume,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
@@ -1475,6 +1507,7 @@ static const struct l2c_init_data of_tauros3_data __initconst = {
 	/* Tauros3 broadcasts L1 cache operations to L2 */
 	.outer_cache = {
 		.resume      = tauros3_resume,
+		.get_info    = l2x0_getinfo,
 	},
 };
 
diff --git a/arch/arm/mm/cache-tauros2.c b/arch/arm/mm/cache-tauros2.c
index b273739e6359..98efe3d12d94 100644
--- a/arch/arm/mm/cache-tauros2.c
+++ b/arch/arm/mm/cache-tauros2.c
@@ -60,6 +60,7 @@ static inline void tauros2_inv_pa(unsigned long addr)
  * noninclusive.
  */
 #define CACHE_LINE_SIZE		32
+#define CACHE_LINE_SHIFT	5
 
 static void tauros2_inv_range(unsigned long start, unsigned long end)
 {
@@ -131,6 +132,39 @@ static void tauros2_resume(void)
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
+static void tauros2_getinfo(struct cacheinfo *info)
+{
+	unsigned int l2_ctr;
+
+	__asm__("mrc p15, 1, %0, c0, c0, 1" : "=r" (l2_ctr));
+
+	this_leaf->type = CACHE_TYPE_UNIFIED;
+	this_leaf->coherency_line_size = CACHE_LINE_SIZE;
+	this_leaf->ways_of_associativity = CACHE_WAY_PER_SET(l2_ctr);
+	this_leaf->number_of_sets = CACHE_SET_SIZE(l2_ctr);
+	this_leaf->size = this_leaf->coherency_line_size *
+			  this_leaf->number_of_sets *
+			  this_leaf->ways_of_associativity;
+}
+
 #endif
 
 static inline u32 __init read_extra_features(void)
@@ -226,6 +260,7 @@ static void __init tauros2_internal_init(unsigned int features)
 		outer_cache.flush_range = tauros2_flush_range;
 		outer_cache.disable = tauros2_disable;
 		outer_cache.resume = tauros2_resume;
+		outer_cache.get_info = tauros2_getinfo;
 	}
 #endif
 
diff --git a/arch/arm/mm/cache-xsc3l2.c b/arch/arm/mm/cache-xsc3l2.c
index 6c3edeb66e74..0f8ad0431a1b 100644
--- a/arch/arm/mm/cache-xsc3l2.c
+++ b/arch/arm/mm/cache-xsc3l2.c
@@ -201,6 +201,21 @@ static void xsc3_l2_flush_range(unsigned long start, unsigned long end)
 	dsb();
 }
 
+static void xsc3_l2_getinfo(struct outer_cache_info *info)
+{
+	unsigned long l2ctype;
+
+	__asm__("mrc p15, 1, %0, c0, c0, 1" : "=r" (l2ctype));
+
+	this_leaf->type = CACHE_TYPE_UNIFIED;
+	this_leaf->coherency_line_size = CACHE_LINE_SIZE;
+	this_leaf->ways_of_associativity = CACHE_WAY_PER_SET;
+	this_leaf->number_of_sets = CACHE_SET_SIZE(l2ctype);
+	this_leaf->size = this_leaf->coherency_line_size *
+			  this_leaf->number_of_sets *
+			  this_leaf->ways_of_associativity;
+}
+
 static int __init xsc3_l2_init(void)
 {
 	if (!cpu_is_xsc3() || !xsc3_l2_present())
@@ -213,6 +228,7 @@ static int __init xsc3_l2_init(void)
 		outer_cache.inv_range = xsc3_l2_inv_range;
 		outer_cache.clean_range = xsc3_l2_clean_range;
 		outer_cache.flush_range = xsc3_l2_flush_range;
+		outer_cache.get_info    = xsc3_l2_getinfo;
 	}
 
 	return 0;
-- 
1.8.3.2

