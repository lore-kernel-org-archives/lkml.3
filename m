Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbaKTPMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:12:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52799 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbaKTPM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:12:26 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-20-546e04d80ad7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>, Kukjin Kim <kgene@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 2/4] ARM: EXYNOS: add code for setting/clearing boot flag
Date: Thu, 20 Nov 2014 16:11:47 +0100
Message-id: <1416496309-27602-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1416496309-27602-1-git-send-email-b.zolnierkie@samsung.com>
References: <1416496309-27602-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t9jQd0bLHkhBrcfSllsnLGe1WLeZ1mL
	3gVX2Sz6H79mtjjb9IbdYtPja6wWl3fNYbP43HuE0WLG+X1MFqt2/WF04PLYOesuu8emVZ1s
	Hneu7WHz2Lyk3qNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyZn2fyVKwhL/i/fJ/7A2ML3i6
	GDk5JARMJBY+WMsIYYtJXLi3nq2LkYtDSGA6o8SqpRdZIJwuJok9V/4xgVSxCVhJTGxfBdYh
	IuAqMefKJEaQImaBhUwSs94+Ye9i5OAQFvCUWNSqAFLDIqAq8X/6fLBeXgEPiUXz/7NAbFOU
	6H42gQ2knBOo/PamHJCwEFDJ86YljBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93E
	CA68Z9I7GFc1WBxiFOBgVOLhTbDIDRFiTSwrrsw9xCjBwawkwrvwPVCINyWxsiq1KD++qDQn
	tfgQozQHi5I4742bQCmB9MSS1OzU1ILUIpgsEwenVAPj5Mk9bT6RqY9PrD3t5uA/PVhcYM6z
	fu/mhvIJPZ+uaClcuVn/0SLkYLTTjGiBGbcuXT5VLnjxlnyAs5fS00nudht3uDi9uXe1Tzyw
	WmFJavJvlaQN9Se/ZTHcm8jOaXkoMXXjltYdx3/VvRbVO7bq/tSkPXtmh4Y8eOXjrufKL5+9
	ef4idW87JZbijERDLeai4kQA8lfkuzgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is needed for cpuidle (W-)AFTR mode support on Exynos3250.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/common.h |  6 ++++++
 arch/arm/mach-exynos/exynos.c | 25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 431be1b..155f019 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -119,6 +119,12 @@ extern void __iomem *sysram_base_addr;
 extern void __iomem *pmu_base_addr;
 void exynos_sysram_init(void);
 
+/* CPU BOOT mode flag */
+#define C2_STATE	(1 << 3)
+
+void exynos_set_boot_flag(unsigned int cpu, unsigned int mode);
+void exynos_clear_boot_flag(unsigned int cpu, unsigned int mode);
+
 enum {
 	FW_DO_IDLE_SLEEP,
 	FW_DO_IDLE_AFTR,
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 8f638ad..847cd0a 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -148,6 +148,31 @@ static void __init exynos_init_late(void)
 	exynos_pm_init();
 }
 
+#define REG_CPU_STATE_ADDR	(sysram_ns_base_addr + 0x28)
+#define BOOT_MODE_MASK		0x1f
+
+void exynos_set_boot_flag(unsigned int cpu, unsigned int mode)
+{
+	unsigned int tmp;
+
+	tmp = __raw_readl(REG_CPU_STATE_ADDR + cpu * 4);
+
+	if (mode & BOOT_MODE_MASK)
+		tmp &= ~BOOT_MODE_MASK;
+
+	tmp |= mode;
+	__raw_writel(tmp, REG_CPU_STATE_ADDR + cpu * 4);
+}
+
+void exynos_clear_boot_flag(unsigned int cpu, unsigned int mode)
+{
+	unsigned int tmp;
+
+	tmp = __raw_readl(REG_CPU_STATE_ADDR + cpu * 4);
+	tmp &= ~mode;
+	__raw_writel(tmp, REG_CPU_STATE_ADDR + cpu * 4);
+}
+
 static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
 					int depth, void *data)
 {
-- 
1.8.2.3

