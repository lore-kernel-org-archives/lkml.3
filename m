Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbaFKPag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:30:36 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37896 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaFKPae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:30:34 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-36-53987617feae
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>, Robin Holt <holt@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 1/5] ARM: mm: cache-l2x0: Add base address argument to
 write_sec callback
Date: Wed, 11 Jun 2014 17:30:08 +0200
Message-id: <1402500612-4778-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
References: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xy7riZTOCDS7c57Ton9bBatG74Cqb
	xfbOGewWU/4sZ7LY9Pgaq8XlXXPYLGYv6WexmHF+H5PF7cu8Fq/71jBbrJ/xmsVi1a4/jBb7
	r3g58Hq0NPeweXz7OonF43JfL5PHzll32T3uXNvD5rF5Sb1H35ZVjB53r79k8jh+YzuTx+dN
	cgFcUVw2Kak5mWWpRfp2CVwZyz5OYiqYJVfR2n2atYFxnmQXIyeHhICJxNTpF5khbDGJC/fW
	s4HYQgJLGSXmNft2MXIB2X1MEid27mABSbAJqEl8bngEViQioCrxuW0BO0gRs8BeZokzM24w
	giSEBaIlDt35AjaVBajoxsdF7CA2r4CjxIvbe6C2yUn0bnsDZnMKOEk8vdzLCLHZUWLV+ovM
	Exh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQICd+vOxiXHrM6xCjAwajEw2vgPy1Y
	iDWxrLgy9xCjBAezkghvQeGMYCHelMTKqtSi/Pii0pzU4kOMTBycUg2MV1/K3ZJcdOGecD/z
	zT1cy6I/3K1bxDxthdkvhYDdQYHhrZz286vvrvx7qUB0ddzEpWzLjbXb5glq/L92aOajrS9r
	Nu95cE89uKb86ariq+v0pAOfz+Y0Tjj7Qflm7Okv4UKsziGXGR4+WHzzzv5sJYazcxkK5prV
	Nko7J+isW5NX1xySvtRovhJLcUaioRZzUXEiAKVtxDY9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For certain platforms (e.g. Exynos) it is necessary to read back some
values from registers before they can be written (i.e. SMC calls that
set multiple registers per call), so base address of L2C controller is
needed for .write_sec operation. This patch adds base argument to
.write_sec callback so that its implementation can also access registers
directly.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/include/asm/mach/arch.h   | 3 ++-
 arch/arm/include/asm/outercache.h  | 2 +-
 arch/arm/mach-highbank/highbank.c  | 3 ++-
 arch/arm/mach-omap2/omap4-common.c | 3 ++-
 arch/arm/mach-ux500/cache-l2x0.c   | 3 ++-
 arch/arm/mm/cache-l2x0.c           | 2 +-
 6 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 060a75e..ddaebcd 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -46,7 +46,8 @@ struct machine_desc {
 	enum reboot_mode	reboot_mode;	/* default restart mode	*/
 	unsigned		l2c_aux_val;	/* L2 cache aux value	*/
 	unsigned		l2c_aux_mask;	/* L2 cache aux mask	*/
-	void			(*l2c_write_sec)(unsigned long, unsigned);
+	void			(*l2c_write_sec)(void __iomem *,
+						 unsigned long, unsigned);
 	struct smp_operations	*smp;		/* SMP operations	*/
 	bool			(*smp_init)(void);
 	void			(*fixup)(struct tag *, char **);
diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index 891a56b..5cc703b 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -35,7 +35,7 @@ struct outer_cache_fns {
 	void (*resume)(void);
 
 	/* This is an ARM L2C thing */
-	void (*write_sec)(unsigned long, unsigned);
+	void (*write_sec)(void __iomem *, unsigned long, unsigned);
 };
 
 extern struct outer_cache_fns outer_cache;
diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 8c35ae4..2bd3243 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -51,7 +51,8 @@ static void __init highbank_scu_map_io(void)
 }
 
 
-static void highbank_l2c310_write_sec(unsigned long val, unsigned reg)
+static void highbank_l2c310_write_sec(void __iomem *base,
+				      unsigned long val, unsigned reg)
 {
 	if (reg == L2X0_CTRL)
 		highbank_smc1(0x102, val);
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 326cd98..bdbe658 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -167,7 +167,8 @@ void __iomem *omap4_get_l2cache_base(void)
 	return l2cache_base;
 }
 
-static void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
+static void omap4_l2c310_write_sec(void __iomem *base,
+				   unsigned long val, unsigned reg)
 {
 	unsigned smc_op;
 
diff --git a/arch/arm/mach-ux500/cache-l2x0.c b/arch/arm/mach-ux500/cache-l2x0.c
index 842ebed..35c2623 100644
--- a/arch/arm/mach-ux500/cache-l2x0.c
+++ b/arch/arm/mach-ux500/cache-l2x0.c
@@ -35,7 +35,8 @@ static int __init ux500_l2x0_unlock(void)
 	return 0;
 }
 
-static void ux500_l2c310_write_sec(unsigned long val, unsigned reg)
+static void ux500_l2c310_write_sec(void __iomem *base,
+				   unsigned long val, unsigned reg)
 {
 	/*
 	 * We can't write to secure registers as we are in non-secure
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index efc5cab..1695eab 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -72,7 +72,7 @@ static void l2c_write_sec(unsigned long val, void __iomem *base, unsigned reg)
 	if (val == readl_relaxed(base + reg))
 		return;
 	if (outer_cache.write_sec)
-		outer_cache.write_sec(val, reg);
+		outer_cache.write_sec(base, val, reg);
 	else
 		writel_relaxed(val, base + reg);
 }
-- 
1.9.3

