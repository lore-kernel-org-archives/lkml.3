Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaLCMeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:34:08 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25792 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaLCMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:34:04 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-6a-547f033a0f93
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Inki Dae <inki.dae@samsung.com>, Tobias Jakobi <Liquid.Acid@gmx.net>,
        Daniel Drake <drake@endlessm.com>, Andrzej Hajda <a.hajda@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v2 2/7] ARM: Exynos: add support for sub-power domains
Date: Wed, 03 Dec 2014 13:33:44 +0100
Message-id: <1417610024-29748-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1416814256-24288-3-git-send-email-a.hajda@samsung.com>
References: <1416814256-24288-3-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xq7pWzPUhBgdmGFjcWneO1aLhaojF
	o/mPmS2e3drLZDHp/gQWi/7Hr5ktNj2+xmpxedccNosZ5/cxWXT9/MlmsfbIXXaLRVu/sFus
	2vWH0eL42nAHPo9F37M8ds66y+6xeNN+No9NqzrZPO5c28PmcehwB6PH5iX1Hn1bVjF6fN4k
	F8AZxWWTkpqTWZZapG+XwJVxf+151oK/ghWnl1c0MP7g62Lk5JAQMJFYP283O4QtJnHh3nq2
	LkYuDiGBpYwSEzuvsEI4fUwSt24/ZwWpYhMwlOh628UGYosIZEv8+DaZBaSIWWALs8TcW//A
	RgkLuEns2PMNzGYRUJVYfnE7cxcjBwevgIfEj70xENvkJP6/XMEEYnMKuEg83fOEBcQWEnCW
	+LV2H/sERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUJC9+sOxqXHrA4xCnAwKvHw
	OryrCRFiTSwrrsw9xCjBwawkwvvsW12IEG9KYmVValF+fFFpTmrxIUYmDk6pBkYhnjgZlhr5
	k85T025nxz+vnqx74vqGoEnrpxzfd3L1DZlF/xYs5Kg5v7Jvq5SbKddz9qBTWZebGJbfyDte
	1WJcbiy5NO2A/67zdX+tLnfNCBTPvnGhWjNhxuL3vv5hYZ9ml8xPFtuvufPk7ynmyZFsN+Yv
	qWFNvSreusByWqVFO0vdOoM17u5KLMUZiYZazEXFiQCuP+nuOwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for making one power domain a sub-domain of
other domain. This is useful for modeling power dependences for devices
like TV Mixer or Camera ISP, which needs to have more than one power
domain enabled to be operational.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 Documentation/devicetree/bindings/arm/exynos/power_domain.txt |  2 ++
 arch/arm/mach-exynos/pm_domains.c                             | 11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
index abde1ea8a119..b884358ebb1a 100644
--- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
@@ -22,6 +22,8 @@ Optional Properties:
 	- pclkN, clkN: Pairs of parent of input clock and input clock to the
 		devices in this power domain. Maximum of 4 pairs (N = 0 to 3)
 		are supported currently.
+- samsung,power-domain: phandle to a master power domain that the given domain
+		       is a part of
 
 Node of a device using power domains must have a samsung,power-domain property
 defined with a phandle to respective power domain.
diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
index 20f267121b3e..fa9a47ddad81 100644
--- a/arch/arm/mach-exynos/pm_domains.c
+++ b/arch/arm/mach-exynos/pm_domains.c
@@ -108,7 +108,7 @@ static int exynos_pd_power_off(struct generic_pm_domain *domain)
 static __init int exynos4_pm_init_power_domain(void)
 {
 	struct platform_device *pdev;
-	struct device_node *np;
+	struct device_node *np, *master_np;
 
 	for_each_compatible_node(np, NULL, "samsung,exynos4210-pd") {
 		struct exynos_pm_domain *pd;
@@ -159,6 +159,15 @@ no_clk:
 
 		pm_genpd_init(&pd->pd, NULL, !on);
 		of_genpd_add_provider_simple(np, &pd->pd);
+
+		/* make master and slave hierarchy */
+		master_np = of_parse_phandle(np, "samsung,power-domain", 0);
+		if (!master_np)
+			master_np = of_parse_phandle(np, "power-domains", 0);
+		if (master_np) {
+			pm_genpd_add_subdomain_names(master_np->name, np->name);
+			of_node_put(master_np);
+		}
 	}
 
 	return 0;
-- 
1.9.2

