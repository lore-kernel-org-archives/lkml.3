Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbaFKPb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:31:58 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37896 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbaFKPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:30:35 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-64-53987618206e
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
Subject: [PATCH 4/5] ARM: EXYNOS: Add .write_sec outer cache callback for
 L2C-310
Date: Wed, 11 Jun 2014 17:30:11 +0200
Message-id: <1402500612-4778-5-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
References: <1402500612-4778-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xy7qSZTOCDZYvYLTon9bBatG74Cqb
	xfbOGewWU/4sZ7LY9Pgaq8XlXXPYLGYv6WexmHF+H5PF7cu8Fq/71jBbrJ/xmsVi1a4/jBb7
	r3g58Hq0NPeweXz7OonF43JfL5PHzll32T3uXNvD5rF5Sb1H35ZVjB53r79k8jh+YzuTx+dN
	cgFcUVw2Kak5mWWpRfp2CVwZb6Y9Yyy4KFbR/amDsYHxqFAXIyeHhICJRPf758wQtpjEhXvr
	2boYuTiEBJYySkxquc8E4fQxSby++oQNpIpNQE3ic8MjMFtEQFXic9sCdpAiZoG9zBJnZtxg
	7GLk4BAWCJY4vlsNxGQBqrnwMRWknFfAUeL477OMEMvkJHq3vQFbzCngJPH0ci9YXAioZtX6
	i8wTGHkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJ3i87GBcfszrEKMDBqMTDy6Ez
	LViINbGsuDL3EKMEB7OSCG9B4YxgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzzn5qoL3OZysQd
	vGzT/cx/D+12no8O57S28zq45XTRrM99gR+617KUW+aI/O9vdM96G3qGeese9S0zTzPcfb60
	6t5PLzvtXBf2lCuWc32OfXmiZxI1Y7KAzLmKa7lbbxqvaWWa+JytvGfG6Ze/n0ht/7HoU/uc
	w1NXJ7gcX3Ts45lZK49tPFO9VImlOCPRUIu5qDgRAAmIg9w8AgAA
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
 arch/arm/mach-exynos/firmware.c | 61 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index eb91d23..34f7798 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -14,7 +14,9 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 
+#include <asm/cputype.h>
 #include <asm/firmware.h>
+#include <asm/hardware/cache-l2x0.h>
 
 #include <mach/map.h>
 
@@ -70,6 +72,55 @@ static const struct firmware_ops exynos_firmware_ops = {
 	.cpu_boot		= exynos_cpu_boot,
 };
 
+static void exynos_l2_write_sec(void __iomem *base, unsigned long val,
+				unsigned reg)
+{
+	switch (reg) {
+	case L2X0_CTRL:
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
@@ -89,4 +140,14 @@ void __init exynos_firmware_init(void)
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

