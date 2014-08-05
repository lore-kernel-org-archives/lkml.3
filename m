Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaHENes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:34:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41569 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaHENeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:34:44 -0400
X-AuditID: cbfee61b-f79f86d00000144c-3e-53e0dd7246b5
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v5 1/5] ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by
 static inlines
Date: Tue, 05 Aug 2014 15:34:22 +0200
Message-id: <1407245666-20016-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd2iuw+CDW7M5LLYOGM9q8W8z7IW
	vQuuslmcbXrDbvH+0DNmi02Pr7FaXN41h83ic+8RRosZ5/cxWZw5fYnV4uSfXkaL9TNes1hs
	/OrhwOtx59oeNo/NS+o9bv97zOyx5Wo7i0ffllWMHp83yQWwRXHZpKTmZJalFunbJXBl3Dwy
	lalglVBF75QJrA2MZ/i7GDk5JARMJHr/XGCBsMUkLtxbz9bFyMUhJLCIUWLJhumMEE4Xk0T7
	nlawKjYBK4mJ7asYQWwRATWJnsVbwYqYBfYySyzt3sQOkhAWSJB427qOGcRmEVCVmHLmFVgz
	r4CHxKIvEDUSAooS3c8msIHYnAKeEo3XnoHVCwHVbL6ym2kCI+8CRoZVjKKpBckFxUnpuUZ6
	xYm5xaV56XrJ+bmbGMGB+Ux6B+OqBotDjAIcjEo8vAJq94OFWBPLiitzDzFKcDArifCy334Q
	LMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoGx76xL+xWm
	cqEzm2c1SHVtr/xhnak7bZ+PR9a24mWh6/0jVI41rw359C9jh+XRX0fe/Vc5aN21LbXV0qM0
	7N9SrnSTS5mfuhV2dU17w6ncebxERfumldLMg+EpoZfO1M9k2D3jmnfuxIvVFj1y8plfbZZX
	pRldNT6tsFxtb9ACb9tvhsd/T3VUYinOSDTUYi4qTgQAESIY1kgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXYNOS_BOOT_VECTOR_ADDR and EXYNOS_BOOT_VECTOR_FLAG macros
by exynos_boot_vector_addr() and exynos_boot_vector_flag() static
inlines.

This patch shouldn't cause any functionality changes.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-exynos/pm.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 454c1cc..78e50ed 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -101,16 +101,23 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 	return -ENOENT;
 }
 
-#define EXYNOS_BOOT_VECTOR_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			pmu_base_addr + S5P_INFORM7 : \
-			(samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(sysram_base_addr + 0x24) : \
-			pmu_base_addr + S5P_INFORM0))
-#define EXYNOS_BOOT_VECTOR_FLAG	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
-			pmu_base_addr + S5P_INFORM6 : \
-			(samsung_rev() == EXYNOS4210_REV_1_0 ? \
-			(sysram_base_addr + 0x20) : \
-			pmu_base_addr + S5P_INFORM1))
+static inline void __iomem *exynos_boot_vector_addr(void)
+{
+	if (samsung_rev() == EXYNOS4210_REV_1_1)
+		return pmu_base_addr + S5P_INFORM7;
+	else if (samsung_rev() == EXYNOS4210_REV_1_0)
+		return sysram_base_addr + 0x24;
+	return pmu_base_addr + S5P_INFORM0;
+}
+
+static inline void __iomem *exynos_boot_vector_flag(void)
+{
+	if (samsung_rev() == EXYNOS4210_REV_1_1)
+		return pmu_base_addr + S5P_INFORM6;
+	else if (samsung_rev() == EXYNOS4210_REV_1_0)
+		return sysram_base_addr + 0x20;
+	return pmu_base_addr + S5P_INFORM1;
+}
 
 #define S5P_CHECK_AFTR  0xFCBA0D10
 #define S5P_CHECK_SLEEP 0x00000BAD
@@ -195,8 +202,9 @@ static void exynos_set_wakeupmask(long mask)
 
 static void exynos_cpu_set_boot_vector(long flags)
 {
-	__raw_writel(virt_to_phys(exynos_cpu_resume), EXYNOS_BOOT_VECTOR_ADDR);
-	__raw_writel(flags, EXYNOS_BOOT_VECTOR_FLAG);
+	__raw_writel(virt_to_phys(exynos_cpu_resume),
+		     exynos_boot_vector_addr());
+	__raw_writel(flags, exynos_boot_vector_flag());
 }
 
 static int exynos_aftr_finisher(unsigned long flags)
-- 
1.8.2.3

