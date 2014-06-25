Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbaFYNjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:39:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57284 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbaFYNiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:38:21 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5c-53aad0ca9642
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 5/6] ARM: EXYNOS: Add .write_sec outer cache callback for
 L2C-310
Date: Wed, 25 Jun 2014 15:37:30 +0200
Message-id: <1403703451-12233-6-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
References: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t/xK7qnLqwKNvj+Td7i0fzHzBa9C66y
	WWzvnMFuMeXPciaLTY+vsVpc3jWHzWL2kn4Wixnn9zFZ3L7Ma7H2yF12i9d9a5gt1s94zWKx
	atcfRov9V7wc+DxamnvYPL59ncTicbmvl8lj0fcsj52z7rJ73Lm2h81j85J6j74tqxg9jt/Y
	zuTxeZNcAFcUl01Kak5mWWqRvl0CV8arM7UFs8Ur7p2aw9jA2CDcxcjJISFgItHXfp4VwhaT
	uHBvPVsXIxeHkMBSRon32+8ygySEBPqYJKYvTwOx2QTUJD43PGIDsUUEVCU+ty1gB2lgFmhg
	kbjSeh0sISwQJtHWeY8dxGYBKjr4fyZYnFfASeLf2kvMENvkJHq3vQGzOQWcJS7M+8MKscxJ
	Yt6TI4wTGHkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJ4i87GBcfszrEKMDBqMTD
	G8CzKliINbGsuDL3EKMEB7OSCK/7fqAQb0piZVVqUX58UWlOavEhRiYOTqkGRu3wJQKl7Zv6
	J8dwdbdct2iedI9PNdeCyU4lJZX3VEmXatXa4j33WFjC3hm8PqD4tdWe3yLDZYmJk4OPs0hr
	+tHZxrPPHrn7Z6FSYdzUyB6n3qVXBA/ErCq0uf8ognvexY1P9ZWObdyyQcrYzdW4vvHm4pRV
	h18YJixUXh9RONkttlnKWCJFiaU4I9FQi7moOBEAeBOJzEACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos4 SoCs equipped with an L2C-310 cache controller and running under
secure firmware require certain registers of aforementioned IP to be
accessed only from secure mode. This means that SMC calls are required
for certain register writes. To handle this, an implementation of
.write_sec callback is provided by this patch.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 63 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index eb91d23..def7bb4 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -14,7 +14,9 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 
+#include <asm/cputype.h>
 #include <asm/firmware.h>
+#include <asm/hardware/cache-l2x0.h>
 
 #include <mach/map.h>
 
@@ -70,6 +72,57 @@ static const struct firmware_ops exynos_firmware_ops = {
 	.cpu_boot		= exynos_cpu_boot,
 };
 
+static void exynos_l2_write_sec(unsigned long val, void __iomem *base,
+				unsigned reg)
+{
+	switch (reg) {
+	case L2X0_CTRL:
+		if (val & L2X0_CTRL_EN)
+			exynos_smc(SMC_CMD_L2X0INVALL, 0, 0, 0);
+		exynos_smc(SMC_CMD_L2X0CTRL, val, 0, 0);
+		break;
+
+	case L2X0_AUX_CTRL:
+		exynos_smc(SMC_CMD_L2X0SETUP2,
+				readl_relaxed(base + L310_POWER_CTRL),
+				val, 0);
+		break;
+
+	case L2X0_DEBUG_CTRL:
+		exynos_smc(SMC_CMD_L2X0DEBUG, val, 0, 0);
+		break;
+
+	case L310_TAG_LATENCY_CTRL:
+		exynos_smc(SMC_CMD_L2X0SETUP1,
+				val,
+				readl_relaxed(base + L310_DATA_LATENCY_CTRL),
+				readl_relaxed(base + L310_PREFETCH_CTRL));
+		break;
+
+	case L310_DATA_LATENCY_CTRL:
+		exynos_smc(SMC_CMD_L2X0SETUP1,
+				readl_relaxed(base + L310_TAG_LATENCY_CTRL),
+				val,
+				readl_relaxed(base + L310_PREFETCH_CTRL));
+		break;
+
+	case L310_PREFETCH_CTRL:
+		exynos_smc(SMC_CMD_L2X0SETUP1,
+				readl_relaxed(base + L310_TAG_LATENCY_CTRL),
+				readl_relaxed(base + L310_DATA_LATENCY_CTRL),
+				val);
+		break;
+
+	case L310_POWER_CTRL:
+		exynos_smc(SMC_CMD_L2X0SETUP2, val,
+				readl_relaxed(base + L2X0_AUX_CTRL), 0);
+		break;
+
+	default:
+		WARN_ONCE(1, "%s: ignoring write to reg 0x%x\n", __func__, reg);
+	}
+}
+
 void __init exynos_firmware_init(void)
 {
 	struct device_node *nd;
@@ -89,4 +142,14 @@ void __init exynos_firmware_init(void)
 	pr_info("Running under secure firmware.\n");
 
 	register_firmware_ops(&exynos_firmware_ops);
+
+	/*
+	 * Exynos 4 SoCs (based on Cortex A9 and equipped with L2C-310),
+	 * running under secure firmware, require certain registers of L2
+	 * cache controller to be written in secure mode. Here .write_sec
+	 * callback is provided to perform necessary SMC calls.
+	 */
+	if (IS_ENABLED(CONFIG_CACHE_L2X0)
+	    && read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
+		outer_cache.write_sec = exynos_l2_write_sec;
 }
-- 
1.9.3

