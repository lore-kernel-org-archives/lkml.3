Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535AbaJUUXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:23:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41268 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933434AbaJUUWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:22:55 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/2] ARM: OMAP4+: PM: Centralize static dependency mapping table
Date: Tue, 21 Oct 2014 15:22:29 -0500
Message-ID: <1413922949-22300-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413922949-22300-1-git-send-email-nm@ti.com>
References: <1413922949-22300-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we add more static dependency mapping for various errata, the logic
gets clunkier. Since it is a simple lookup and map logic, centralize the
same and provide the mapping as  a simple list.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/pm44xx.c |  117 ++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 60 deletions(-)

diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index e7f823b..d697cec 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -37,6 +37,16 @@ struct power_state {
 	struct list_head node;
 };
 
+/**
+ * struct static_dep_map - Static dependency map
+ * @from:	from clockdomain
+ * @to:		to clockdomain
+  */
+struct static_dep_map {
+	const char *from;
+	const char *to;
+};
+
 static u32 cpu_suspend_state = PWRDM_POWER_OFF;
 
 static LIST_HEAD(pwrst_list);
@@ -148,74 +158,61 @@ static void omap_default_idle(void)
 	omap_do_wfi();
 }
 
-/**
- * omap4_init_static_deps - Add OMAP4 static dependencies
- *
- * Add needed static clockdomain dependencies on OMAP4 devices.
- * Return: 0 on success or 'err' on failures
+/*
+ * The dynamic dependency between MPUSS -> MEMIF and
+ * MPUSS -> L4_PER/L3_* and DUCATI -> L3_* doesn't work as
+ * expected. The hardware recommendation is to enable static
+ * dependencies for these to avoid system lock ups or random crashes.
+ * The L4 wakeup depedency is added to workaround the OCP sync hardware
+ * BUG with 32K synctimer which lead to incorrect timer value read
+ * from the 32K counter. The BUG applies for GPTIMER1 and WDT2 which
+ * are part of L4 wakeup clockdomain.
  */
-static inline int omap4_init_static_deps(void)
-{
-	struct clockdomain *emif_clkdm, *mpuss_clkdm, *l3_1_clkdm;
-	struct clockdomain *ducati_clkdm, *l3_2_clkdm;
-	int ret = 0;
-
-	/*
-	 * The dynamic dependency between MPUSS -> MEMIF and
-	 * MPUSS -> L4_PER/L3_* and DUCATI -> L3_* doesn't work as
-	 * expected. The hardware recommendation is to enable static
-	 * dependencies for these to avoid system lock ups or random crashes.
-	 * The L4 wakeup depedency is added to workaround the OCP sync hardware
-	 * BUG with 32K synctimer which lead to incorrect timer value read
-	 * from the 32K counter. The BUG applies for GPTIMER1 and WDT2 which
-	 * are part of L4 wakeup clockdomain.
-	 */
-	mpuss_clkdm = clkdm_lookup("mpuss_clkdm");
-	emif_clkdm = clkdm_lookup("l3_emif_clkdm");
-	l3_1_clkdm = clkdm_lookup("l3_1_clkdm");
-	l3_2_clkdm = clkdm_lookup("l3_2_clkdm");
-	ducati_clkdm = clkdm_lookup("ducati_clkdm");
-	if ((!mpuss_clkdm) || (!emif_clkdm) || (!l3_1_clkdm) ||
-		(!l3_2_clkdm) || (!ducati_clkdm))
-		return -EINVAL;
-
-	ret = clkdm_add_wkdep(mpuss_clkdm, emif_clkdm);
-	ret |= clkdm_add_wkdep(mpuss_clkdm, l3_1_clkdm);
-	ret |= clkdm_add_wkdep(mpuss_clkdm, l3_2_clkdm);
-	ret |= clkdm_add_wkdep(ducati_clkdm, l3_1_clkdm);
-	ret |= clkdm_add_wkdep(ducati_clkdm, l3_2_clkdm);
-	if (ret) {
-		pr_err("Failed to add MPUSS -> L3/EMIF/L4PER, DUCATI -> L3 wakeup dependency\n");
-		return -EINVAL;
-	}
+static const struct static_dep_map omap4_static_dep_map[] = {
+	{.from = "mpuss_clkdm", .to = "l3_emif_clkdm"},
+	{.from = "mpuss_clkdm", .to = "l3_1_clkdm"},
+	{.from = "mpuss_clkdm", .to = "l3_2_clkdm"},
+	{.from = "ducati_clkdm", .to = "l3_1_clkdm"},
+	{.from = "ducati_clkdm", .to = "l3_2_clkdm"},
+	{.from  = NULL} /* TERMINATION */
+};
 
-	return ret;
-}
+static const struct static_dep_map omap5_dra7_static_dep_map[] = {
+	{.from = "mpu_clkdm", .to = "emif_clkdm"},
+	{.from  = NULL} /* TERMINATION */
+};
 
 /**
- * omap5_dra7_init_static_deps - Init static clkdm dependencies on OMAP5 and
- *				 DRA7
- *
- * The dynamic dependency between MPUSS -> EMIF is broken and has
- * not worked as expected. The hardware recommendation is to
- * enable static dependencies for these to avoid system
- * lock ups or random crashes.
+ * omap4plus_init_static_deps() - Initialize a static dependency map
+ * @map:	Mapping of clock domains
  */
-static inline int omap5_dra7_init_static_deps(void)
+static inline int omap4plus_init_static_deps(const struct static_dep_map *map)
 {
-	struct clockdomain *mpuss_clkdm, *emif_clkdm;
 	int ret;
+	struct clockdomain *from, *to;
 
-	mpuss_clkdm = clkdm_lookup("mpu_clkdm");
-	emif_clkdm = clkdm_lookup("emif_clkdm");
-	if (!mpuss_clkdm || !emif_clkdm)
-		return -EINVAL;
+	if (!map)
+		return 0;
+
+	while (map->from) {
+		from = clkdm_lookup(map->from);
+		to = clkdm_lookup(map->to);
+		if (!from || !to) {
+			pr_err("Failed lookup %s or %s for wakeup dependency\n",
+			       map->from, map->to);
+			return -EINVAL;
+		}
+		ret = clkdm_add_wkdep(from, to);
+		if (ret) {
+			pr_err("Failed to add %s -> %s wakeup dependency(%d)\n",
+			       map->from, map->to, ret);
+			return ret;
+		}
 
-	ret = clkdm_add_wkdep(mpuss_clkdm, emif_clkdm);
-	if (ret)
-		pr_err("Failed to add MPUSS -> EMIF wakeup dependency\n");
+		map++;
+	};
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -268,9 +265,9 @@ int __init omap4_pm_init(void)
 	}
 
 	if (cpu_is_omap44xx())
-		ret = omap4_init_static_deps();
+		ret = omap4plus_init_static_deps(omap4_static_dep_map);
 	else if (soc_is_omap54xx() || soc_is_dra7xx())
-		ret = omap5_dra7_init_static_deps();
+		ret = omap4plus_init_static_deps(omap5_dra7_static_dep_map);
 
 	if (ret) {
 		pr_err("Failed to initialise static dependencies.\n");
-- 
1.7.9.5

