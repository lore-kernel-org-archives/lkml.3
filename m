Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbaHZOSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:18:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23792 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758304AbaHZOSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:18:09 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d1-53fc971e7482
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v4 1/7] ARM: l2c: Refactor the driver to use commit-like
 interface
Date: Tue, 26 Aug 2014 16:17:54 +0200
Message-id: <1409062680-15906-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
In-reply-to: <1409062680-15906-1-git-send-email-t.figa@samsung.com>
References: <1409062680-15906-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xK7py0/8EG5y4w2nxaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtTi3fQuLxdojd9ktXvetYbZY
	P+M1i8WqXX8YLfZf8XLg92hp7mHz+PZ1EovH5b5eJo9F37M8ds66y+5x59oeNo/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGecXTGAuuFxd8W72LdYGxi9JXYycHBICJhKd
	S56yQ9hiEhfurWfrYuTiEBJYyiixvuU5E4TTxyRxZf13sCo2ATWJzw2P2EBsEQFVic9tC8Di
	zAIHmCXaVwZ0MXJwCAuESDS+SQMJswCVHPz5B6ycV8BJ4vXta2wQy+QkVm3cxwRicwo4S+z5
	0scMYgsB1TzZv499AiPvAkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxgh4fxlB+PiY1aH
	GAU4GJV4eD+U/A4WYk0sK67MPcQowcGsJML7I+lPsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG
	KSJmRWILH54oNbX5ea3XtbJb5e/xqt466ePRDCKMJQ2rbBx1nY27bl+96ObbLeW5/8LWPLEA
	g2/L6zNnVi0QPBxhcOy7f9OWtVucj74VD01u2SC1XKet6P9ugYIZLgucbRdJl/EWPZi7JtOc
	26VTLvepq/3Zx+cULU7/mjozgH3+j8plDYVKLMUZiYZazEXFiQBEEdjERQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain implementations of secure hypervisors (namely the one found on
Samsung Exynos-based boards) do not provide access to individual L2C
registers. This makes the .write_sec()-based interface insufficient and
provoking ugly hacks.

This patch is first step to make the driver not rely on availability of
writes to individual registers. This is achieved by refactoring the
driver to use a commit-like operation scheme: all register values are
prepared first and stored in an instance of l2x0_regs struct and then a
single callback is responsible to flush those values to the hardware.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mm/cache-l2x0.c | 210 ++++++++++++++++++++++++++---------------------
 1 file changed, 115 insertions(+), 95 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 5f2c988..b073563 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -40,12 +40,14 @@ struct l2c_init_data {
 	void (*enable)(void __iomem *, u32, unsigned);
 	void (*fixup)(void __iomem *, u32, struct outer_cache_fns *);
 	void (*save)(void __iomem *);
+	void (*configure)(void __iomem *);
 	struct outer_cache_fns outer_cache;
 };
 
 #define CACHE_LINE_SIZE		32
 
 static void __iomem *l2x0_base;
+static const struct l2c_init_data *l2x0_data;
 static DEFINE_RAW_SPINLOCK(l2x0_lock);
 static u32 l2x0_way_mask;	/* Bitmask of active ways */
 static u32 l2x0_size;
@@ -105,6 +107,14 @@ static inline void l2c_unlock(void __iomem *base, unsigned num)
 	}
 }
 
+static void l2c_configure(void __iomem *base)
+{
+	if (l2x0_data->configure)
+		l2x0_data->configure(base);
+
+	l2c_write_sec(l2x0_saved_regs.aux_ctrl, base, L2X0_AUX_CTRL);
+}
+
 /*
  * Enable the L2 cache controller.  This function must only be
  * called when the cache controller is known to be disabled.
@@ -113,7 +123,12 @@ static void l2c_enable(void __iomem *base, u32 aux, unsigned num_lock)
 {
 	unsigned long flags;
 
-	l2c_write_sec(aux, base, L2X0_AUX_CTRL);
+	/* Do not touch the controller if already enabled. */
+	if (readl_relaxed(base + L2X0_CTRL) & L2X0_CTRL_EN)
+		return;
+
+	l2x0_saved_regs.aux_ctrl = aux;
+	l2c_configure(base);
 
 	l2c_unlock(base, num_lock);
 
@@ -207,6 +222,11 @@ static void l2c_save(void __iomem *base)
 	l2x0_saved_regs.aux_ctrl = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
 }
 
+static void l2c_resume(void)
+{
+	l2c_enable(l2x0_base, l2x0_saved_regs.aux_ctrl, l2x0_data->num_lock);
+}
+
 /*
  * L2C-210 specific code.
  *
@@ -287,14 +307,6 @@ static void l2c210_sync(void)
 	__l2c210_cache_sync(l2x0_base);
 }
 
-static void l2c210_resume(void)
-{
-	void __iomem *base = l2x0_base;
-
-	if (!(readl_relaxed(base + L2X0_CTRL) & L2X0_CTRL_EN))
-		l2c_enable(base, l2x0_saved_regs.aux_ctrl, 1);
-}
-
 static const struct l2c_init_data l2c210_data __initconst = {
 	.type = "L2C-210",
 	.way_size_0 = SZ_8K,
@@ -308,7 +320,7 @@ static const struct l2c_init_data l2c210_data __initconst = {
 		.flush_all = l2c210_flush_all,
 		.disable = l2c_disable,
 		.sync = l2c210_sync,
-		.resume = l2c210_resume,
+		.resume = l2c_resume,
 	},
 };
 
@@ -465,7 +477,7 @@ static const struct l2c_init_data l2c220_data = {
 		.flush_all = l2c220_flush_all,
 		.disable = l2c_disable,
 		.sync = l2c220_sync,
-		.resume = l2c210_resume,
+		.resume = l2c_resume,
 	},
 };
 
@@ -614,39 +626,29 @@ static void __init l2c310_save(void __iomem *base)
 							L310_POWER_CTRL);
 }
 
-static void l2c310_resume(void)
+static void l2c310_configure(void __iomem *base)
 {
-	void __iomem *base = l2x0_base;
+	unsigned revision;
 
-	if (!(readl_relaxed(base + L2X0_CTRL) & L2X0_CTRL_EN)) {
-		unsigned revision;
-
-		/* restore pl310 setup */
-		writel_relaxed(l2x0_saved_regs.tag_latency,
-			       base + L310_TAG_LATENCY_CTRL);
-		writel_relaxed(l2x0_saved_regs.data_latency,
-			       base + L310_DATA_LATENCY_CTRL);
-		writel_relaxed(l2x0_saved_regs.filter_end,
-			       base + L310_ADDR_FILTER_END);
-		writel_relaxed(l2x0_saved_regs.filter_start,
-			       base + L310_ADDR_FILTER_START);
-
-		revision = readl_relaxed(base + L2X0_CACHE_ID) &
-				L2X0_CACHE_ID_RTL_MASK;
-
-		if (revision >= L310_CACHE_ID_RTL_R2P0)
-			l2c_write_sec(l2x0_saved_regs.prefetch_ctrl, base,
-				      L310_PREFETCH_CTRL);
-		if (revision >= L310_CACHE_ID_RTL_R3P0)
-			l2c_write_sec(l2x0_saved_regs.pwr_ctrl, base,
-				      L310_POWER_CTRL);
-
-		l2c_enable(base, l2x0_saved_regs.aux_ctrl, 8);
-
-		/* Re-enable full-line-of-zeros for Cortex-A9 */
-		if (l2x0_saved_regs.aux_ctrl & L310_AUX_CTRL_FULL_LINE_ZERO)
-			set_auxcr(get_auxcr() | BIT(3) | BIT(2) | BIT(1));
-	}
+	/* restore pl310 setup */
+	writel_relaxed(l2x0_saved_regs.tag_latency,
+		       base + L310_TAG_LATENCY_CTRL);
+	writel_relaxed(l2x0_saved_regs.data_latency,
+		       base + L310_DATA_LATENCY_CTRL);
+	writel_relaxed(l2x0_saved_regs.filter_end,
+		       base + L310_ADDR_FILTER_END);
+	writel_relaxed(l2x0_saved_regs.filter_start,
+		       base + L310_ADDR_FILTER_START);
+
+	revision = readl_relaxed(base + L2X0_CACHE_ID) &
+				 L2X0_CACHE_ID_RTL_MASK;
+
+	if (revision >= L310_CACHE_ID_RTL_R2P0)
+		l2c_write_sec(l2x0_saved_regs.prefetch_ctrl, base,
+			      L310_PREFETCH_CTRL);
+	if (revision >= L310_CACHE_ID_RTL_R3P0)
+		l2c_write_sec(l2x0_saved_regs.pwr_ctrl, base,
+			      L310_POWER_CTRL);
 }
 
 static int l2c310_cpu_enable_flz(struct notifier_block *nb, unsigned long act, void *data)
@@ -698,6 +700,23 @@ static void __init l2c310_enable(void __iomem *base, u32 aux, unsigned num_lock)
 		aux &= ~(L310_AUX_CTRL_FULL_LINE_ZERO | L310_AUX_CTRL_EARLY_BRESP);
 	}
 
+	/* r3p0 or later has power control register */
+	if (rev >= L310_CACHE_ID_RTL_R3P0)
+		l2x0_saved_regs.pwr_ctrl = L310_DYNAMIC_CLK_GATING_EN |
+						L310_STNDBY_MODE_EN;
+
+	/*
+	 * Always enable non-secure access to the lockdown registers -
+	 * we write to them as part of the L2C enable sequence so they
+	 * need to be accessible.
+	 */
+	aux |= L310_AUX_CTRL_NS_LOCKDOWN;
+
+	l2c_enable(base, aux, num_lock);
+
+	/* Read back resulting AUX_CTRL value as it could have been altered. */
+	aux = readl_relaxed(base + L2X0_AUX_CTRL);
+
 	if (aux & (L310_AUX_CTRL_DATA_PREFETCH | L310_AUX_CTRL_INSTR_PREFETCH)) {
 		u32 prefetch = readl_relaxed(base + L310_PREFETCH_CTRL);
 
@@ -711,23 +730,12 @@ static void __init l2c310_enable(void __iomem *base, u32 aux, unsigned num_lock)
 	if (rev >= L310_CACHE_ID_RTL_R3P0) {
 		u32 power_ctrl;
 
-		l2c_write_sec(L310_DYNAMIC_CLK_GATING_EN | L310_STNDBY_MODE_EN,
-			      base, L310_POWER_CTRL);
 		power_ctrl = readl_relaxed(base + L310_POWER_CTRL);
 		pr_info("L2C-310 dynamic clock gating %sabled, standby mode %sabled\n",
 			power_ctrl & L310_DYNAMIC_CLK_GATING_EN ? "en" : "dis",
 			power_ctrl & L310_STNDBY_MODE_EN ? "en" : "dis");
 	}
 
-	/*
-	 * Always enable non-secure access to the lockdown registers -
-	 * we write to them as part of the L2C enable sequence so they
-	 * need to be accessible.
-	 */
-	aux |= L310_AUX_CTRL_NS_LOCKDOWN;
-
-	l2c_enable(base, aux, num_lock);
-
 	if (aux & L310_AUX_CTRL_FULL_LINE_ZERO) {
 		set_auxcr(get_auxcr() | BIT(3) | BIT(2) | BIT(1));
 		cpu_notifier(l2c310_cpu_enable_flz, 0);
@@ -759,11 +767,11 @@ static void __init l2c310_fixup(void __iomem *base, u32 cache_id,
 
 	if (revision >= L310_CACHE_ID_RTL_R3P0 &&
 	    revision < L310_CACHE_ID_RTL_R3P2) {
-		u32 val = readl_relaxed(base + L310_PREFETCH_CTRL);
+		u32 val = l2x0_saved_regs.prefetch_ctrl;
 		/* I don't think bit23 is required here... but iMX6 does so */
 		if (val & (BIT(30) | BIT(23))) {
 			val &= ~(BIT(30) | BIT(23));
-			l2c_write_sec(val, base, L310_PREFETCH_CTRL);
+			l2x0_saved_regs.prefetch_ctrl = val;
 			errata[n++] = "752271";
 		}
 	}
@@ -799,6 +807,15 @@ static void l2c310_disable(void)
 	l2c_disable();
 }
 
+static void l2c310_resume(void)
+{
+	l2c_resume();
+
+	/* Re-enable full-line-of-zeros for Cortex-A9 */
+	if (l2x0_saved_regs.aux_ctrl & L310_AUX_CTRL_FULL_LINE_ZERO)
+		set_auxcr(get_auxcr() | BIT(3) | BIT(2) | BIT(1));
+}
+
 static const struct l2c_init_data l2c310_init_fns __initconst = {
 	.type = "L2C-310",
 	.way_size_0 = SZ_8K,
@@ -806,6 +823,7 @@ static const struct l2c_init_data l2c310_init_fns __initconst = {
 	.enable = l2c310_enable,
 	.fixup = l2c310_fixup,
 	.save = l2c310_save,
+	.configure = l2c310_configure,
 	.outer_cache = {
 		.inv_range = l2c210_inv_range,
 		.clean_range = l2c210_clean_range,
@@ -817,7 +835,7 @@ static const struct l2c_init_data l2c310_init_fns __initconst = {
 	},
 };
 
-static void __init __l2c_init(const struct l2c_init_data *data,
+static int __init __l2c_init(const struct l2c_init_data *data,
 	u32 aux_val, u32 aux_mask, u32 cache_id)
 {
 	struct outer_cache_fns fns;
@@ -825,6 +843,14 @@ static void __init __l2c_init(const struct l2c_init_data *data,
 	u32 aux, old_aux;
 
 	/*
+	 * Save the pointer globally so that callbacks which do not receive
+	 * context from callers can access the structure.
+	 */
+	l2x0_data = kmemdup(data, sizeof(*data), GFP_KERNEL);
+	if (!l2x0_data)
+		return -ENOMEM;
+
+	/*
 	 * Sanity check the aux values.  aux_mask is the bits we preserve
 	 * from reading the hardware register, and aux_val is the bits we
 	 * set.
@@ -909,6 +935,8 @@ static void __init __l2c_init(const struct l2c_init_data *data,
 		data->type, ways, l2x0_size >> 10);
 	pr_info("%s: CACHE_ID 0x%08x, AUX_CTRL 0x%08x\n",
 		data->type, cache_id, aux);
+
+	return 0;
 }
 
 void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
@@ -935,6 +963,10 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 		break;
 	}
 
+	/* Read back current (default) hardware configuration */
+	if (data->save)
+		data->save(l2x0_base);
+
 	__l2c_init(data, aux_val, aux_mask, cache_id);
 }
 
@@ -993,7 +1025,7 @@ static const struct l2c_init_data of_l2c210_data __initconst = {
 		.flush_all   = l2c210_flush_all,
 		.disable     = l2c_disable,
 		.sync        = l2c210_sync,
-		.resume      = l2c210_resume,
+		.resume      = l2c_resume,
 	},
 };
 
@@ -1011,7 +1043,7 @@ static const struct l2c_init_data of_l2c220_data __initconst = {
 		.flush_all   = l2c220_flush_all,
 		.disable     = l2c_disable,
 		.sync        = l2c220_sync,
-		.resume      = l2c210_resume,
+		.resume      = l2c_resume,
 	},
 };
 
@@ -1024,28 +1056,26 @@ static void __init l2c310_of_parse(const struct device_node *np,
 
 	of_property_read_u32_array(np, "arm,tag-latency", tag, ARRAY_SIZE(tag));
 	if (tag[0] && tag[1] && tag[2])
-		writel_relaxed(
+		l2x0_saved_regs.tag_latency =
 			L310_LATENCY_CTRL_RD(tag[0] - 1) |
 			L310_LATENCY_CTRL_WR(tag[1] - 1) |
-			L310_LATENCY_CTRL_SETUP(tag[2] - 1),
-			l2x0_base + L310_TAG_LATENCY_CTRL);
+			L310_LATENCY_CTRL_SETUP(tag[2] - 1);
 
 	of_property_read_u32_array(np, "arm,data-latency",
 				   data, ARRAY_SIZE(data));
 	if (data[0] && data[1] && data[2])
-		writel_relaxed(
+		l2x0_saved_regs.data_latency =
 			L310_LATENCY_CTRL_RD(data[0] - 1) |
 			L310_LATENCY_CTRL_WR(data[1] - 1) |
-			L310_LATENCY_CTRL_SETUP(data[2] - 1),
-			l2x0_base + L310_DATA_LATENCY_CTRL);
+			L310_LATENCY_CTRL_SETUP(data[2] - 1);
 
 	of_property_read_u32_array(np, "arm,filter-ranges",
 				   filter, ARRAY_SIZE(filter));
 	if (filter[1]) {
-		writel_relaxed(ALIGN(filter[0] + filter[1], SZ_1M),
-			       l2x0_base + L310_ADDR_FILTER_END);
-		writel_relaxed((filter[0] & ~(SZ_1M - 1)) | L310_ADDR_FILTER_EN,
-			       l2x0_base + L310_ADDR_FILTER_START);
+		l2x0_saved_regs.filter_end =
+					ALIGN(filter[0] + filter[1], SZ_1M);
+		l2x0_saved_regs.filter_start = (filter[0] & ~(SZ_1M - 1))
+					| L310_ADDR_FILTER_EN;
 	}
 }
 
@@ -1057,6 +1087,7 @@ static const struct l2c_init_data of_l2c310_data __initconst = {
 	.enable = l2c310_enable,
 	.fixup = l2c310_fixup,
 	.save  = l2c310_save,
+	.configure = l2c310_configure,
 	.outer_cache = {
 		.inv_range   = l2c210_inv_range,
 		.clean_range = l2c210_clean_range,
@@ -1085,6 +1116,7 @@ static const struct l2c_init_data of_l2c310_coherent_data __initconst = {
 	.enable = l2c310_enable,
 	.fixup = l2c310_fixup,
 	.save  = l2c310_save,
+	.configure = l2c310_configure,
 	.outer_cache = {
 		.inv_range   = l2c210_inv_range,
 		.clean_range = l2c210_clean_range,
@@ -1199,16 +1231,6 @@ static void aurora_save(void __iomem *base)
 	l2x0_saved_regs.aux_ctrl = readl_relaxed(base + L2X0_AUX_CTRL);
 }
 
-static void aurora_resume(void)
-{
-	void __iomem *base = l2x0_base;
-
-	if (!(readl(base + L2X0_CTRL) & L2X0_CTRL_EN)) {
-		writel_relaxed(l2x0_saved_regs.aux_ctrl, base + L2X0_AUX_CTRL);
-		writel_relaxed(l2x0_saved_regs.ctrl, base + L2X0_CTRL);
-	}
-}
-
 /*
  * For Aurora cache in no outer mode, enable via the CP15 coprocessor
  * broadcasting of cache commands to L2.
@@ -1270,7 +1292,7 @@ static const struct l2c_init_data of_aurora_with_outer_data __initconst = {
 		.flush_all   = l2x0_flush_all,
 		.disable     = l2x0_disable,
 		.sync        = l2x0_cache_sync,
-		.resume      = aurora_resume,
+		.resume      = l2c_resume,
 	},
 };
 
@@ -1283,7 +1305,7 @@ static const struct l2c_init_data of_aurora_no_outer_data __initconst = {
 	.fixup = aurora_fixup,
 	.save  = aurora_save,
 	.outer_cache = {
-		.resume      = aurora_resume,
+		.resume      = l2c_resume,
 	},
 };
 
@@ -1431,6 +1453,7 @@ static const struct l2c_init_data of_bcm_l2x0_data __initconst = {
 	.of_parse = l2c310_of_parse,
 	.enable = l2c310_enable,
 	.save  = l2c310_save,
+	.configure = l2c310_configure,
 	.outer_cache = {
 		.inv_range   = bcm_inv_range,
 		.clean_range = bcm_clean_range,
@@ -1452,18 +1475,12 @@ static void __init tauros3_save(void __iomem *base)
 		readl_relaxed(base + L310_PREFETCH_CTRL);
 }
 
-static void tauros3_resume(void)
+static void tauros3_configure(void __iomem *base)
 {
-	void __iomem *base = l2x0_base;
-
-	if (!(readl_relaxed(base + L2X0_CTRL) & L2X0_CTRL_EN)) {
-		writel_relaxed(l2x0_saved_regs.aux2_ctrl,
-			       base + TAUROS3_AUX2_CTRL);
-		writel_relaxed(l2x0_saved_regs.prefetch_ctrl,
-			       base + L310_PREFETCH_CTRL);
-
-		l2c_enable(base, l2x0_saved_regs.aux_ctrl, 8);
-	}
+	writel_relaxed(l2x0_saved_regs.aux2_ctrl,
+		       base + TAUROS3_AUX2_CTRL);
+	writel_relaxed(l2x0_saved_regs.prefetch_ctrl,
+		       base + L310_PREFETCH_CTRL);
 }
 
 static const struct l2c_init_data of_tauros3_data __initconst = {
@@ -1472,9 +1489,10 @@ static const struct l2c_init_data of_tauros3_data __initconst = {
 	.num_lock = 8,
 	.enable = l2c_enable,
 	.save  = tauros3_save,
+	.configure = tauros3_configure,
 	/* Tauros3 broadcasts L1 cache operations to L2 */
 	.outer_cache = {
-		.resume      = tauros3_resume,
+		.resume      = l2c_resume,
 	},
 };
 
@@ -1530,6 +1548,10 @@ int __init l2x0_of_init(u32 aux_val, u32 aux_mask)
 	if (!of_property_read_bool(np, "cache-unified"))
 		pr_err("L2C: device tree omits to specify unified cache\n");
 
+	/* Read back current (default) hardware configuration */
+	if (data->save)
+		data->save(l2x0_base);
+
 	/* L2 configuration can only be changed if the cache is disabled */
 	if (!(readl_relaxed(l2x0_base + L2X0_CTRL) & L2X0_CTRL_EN))
 		if (data->of_parse)
@@ -1540,8 +1562,6 @@ int __init l2x0_of_init(u32 aux_val, u32 aux_mask)
 	else
 		cache_id = readl_relaxed(l2x0_base + L2X0_CACHE_ID);
 
-	__l2c_init(data, aux_val, aux_mask, cache_id);
-
-	return 0;
+	return __l2c_init(data, aux_val, aux_mask, cache_id);
 }
 #endif
-- 
2.0.4

