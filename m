Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaCCQCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:02:53 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34497 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaCCQCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:02:48 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v2 07/11] ARM: s3c64xx: pm: Add device tree based power domain instantiation
Date: Mon,  3 Mar 2014 17:02:12 +0100
Message-Id: <1393862536-9842-8-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for registering power domains of S3C64xx SoCs
and binding devices to them using device tree.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/mach-s3c64xx/pm.c                      | 71 +++++++++++++++++++++----
 include/dt-bindings/arm/s3c64xx-power-domains.h | 26 +++++++++
 2 files changed, 88 insertions(+), 9 deletions(-)
 create mode 100644 include/dt-bindings/arm/s3c64xx-power-domains.h

diff --git a/arch/arm/mach-s3c64xx/pm.c b/arch/arm/mach-s3c64xx/pm.c
index b422eed..cebbd44 100644
--- a/arch/arm/mach-s3c64xx/pm.c
+++ b/arch/arm/mach-s3c64xx/pm.c
@@ -17,8 +17,11 @@
 #include <linux/serial_core.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
 #include <linux/pm_domain.h>
 
+#include <dt-bindings/arm/s3c64xx-power-domains.h>
+
 #include <mach/map.h>
 #include <mach/irqs.h>
 
@@ -165,17 +168,63 @@ static struct s3c64xx_pm_domain s3c64xx_pm_v = {
 	},
 };
 
-static struct s3c64xx_pm_domain *s3c64xx_pm_domains[] = {
-	&s3c64xx_pm_irom,
-	&s3c64xx_pm_etm,
-	&s3c64xx_pm_g,
-	&s3c64xx_pm_v,
-	&s3c64xx_pm_i,
-	&s3c64xx_pm_p,
-	&s3c64xx_pm_s,
-	&s3c64xx_pm_f,
+static struct s3c64xx_pm_domain *s3c64xx_pm_domains[NR_DOMAINS] = {
+	[DOMAIN_V] = &s3c64xx_pm_v,
+	[DOMAIN_G] = &s3c64xx_pm_g,
+	[DOMAIN_I] = &s3c64xx_pm_i,
+	[DOMAIN_P] = &s3c64xx_pm_p,
+	[DOMAIN_F] = &s3c64xx_pm_f,
+	[DOMAIN_S] = &s3c64xx_pm_s,
+	[DOMAIN_ETM] = &s3c64xx_pm_etm,
+	[DOMAIN_IROM] = &s3c64xx_pm_irom,
+};
+
+#ifdef CONFIG_OF
+static struct of_device_id s3c64xx_pd_matches[] = {
+	{ .compatible = "samsung,s3c6400-clock", },
+	{ .compatible = "samsung,s3c6410-clock", },
+	{ },
 };
 
+static struct genpd_onecell_data pd_data;
+
+static int s3c64xx_pm_parse_domains(void)
+{
+	struct device_node *np;
+	int i;
+
+	np = of_find_matching_node(NULL, s3c64xx_pd_matches);
+	if (!np)
+		return -ENODEV;
+
+	pd_data.domains = kcalloc(ARRAY_SIZE(s3c64xx_pm_domains),
+				  sizeof(*pd_data.domains), GFP_KERNEL);
+	if (!pd_data.domains)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(s3c64xx_pm_domains); ++i) {
+		struct s3c64xx_pm_domain *pd = s3c64xx_pm_domains[i];
+		struct dev_power_governor *gov = NULL;
+		int on;
+
+		on = __raw_readl(S3C64XX_NORMAL_CFG) & pd->ena;
+
+		if (pd->always_on)
+			gov = &pm_domain_always_on_gov;
+
+		pm_genpd_init(&pd->pd, gov, !on);
+		pd_data.domains[i] = &pd->pd;
+
+		pr_debug("%s: registered domain %s\n", __func__, pd->pd.name);
+	}
+
+	pd_data.domain_num = ARRAY_SIZE(s3c64xx_pm_domains);
+	of_genpd_add_provider(np, of_genpd_xlate_onecell, &pd_data);
+
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_S3C_PM_DEBUG_LED_SMDK
 void s3c_pm_debug_smdkled(u32 set, u32 clear)
 {
@@ -312,6 +361,10 @@ int __init s3c64xx_pm_init(void)
 
 	s3c_pm_init();
 
+#ifdef CONFIG_OF
+	if (of_have_populated_dt())
+		return s3c64xx_pm_parse_domains();
+#endif
 
 	for (i = 0; i < ARRAY_SIZE(s3c64xx_pm_domains); i++) {
 		struct s3c64xx_pm_domain *pd = s3c64xx_pm_domains[i];
diff --git a/include/dt-bindings/arm/s3c64xx-power-domains.h b/include/dt-bindings/arm/s3c64xx-power-domains.h
new file mode 100644
index 0000000..ce39bef
--- /dev/null
+++ b/include/dt-bindings/arm/s3c64xx-power-domains.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2014 Tomasz Figa <tomasz.figa at gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Device Tree binding constants for Samsung S3C64xx power domains.
+*/
+
+#ifndef _DT_BINDINGS_ARM_S3C64XX_POWER_DOMAINS_H
+#define _DT_BINDINGS_ARM_S3C64XX_POWER_DOMAINS_H
+
+#define DOMAIN_V		0
+#define DOMAIN_G		1
+#define DOMAIN_I		2
+#define DOMAIN_P		3
+#define DOMAIN_F		4
+#define DOMAIN_S		5
+#define DOMAIN_ETM		6
+#define DOMAIN_IROM		7
+
+/* Total number of clocks. */
+#define NR_DOMAINS		(DOMAIN_IROM + 1)
+
+#endif /* _DT_BINDINGS_ARM_S3C64XX_POWER_DOMAINS_H */
-- 
1.9.0

