Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaIENwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:52:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35515 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273AbaIENwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:52:21 -0400
X-AuditID: cbfee61a-f79e46d00000134f-e8-5409c0128ccb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v6 1/5] ARM: EXYNOS: PM: replace EXYNOS_BOOT_VECTOR_* macros by
 static inlines
Date: Fri, 05 Sep 2014 15:51:24 +0200
Message-id: <1409925088-4705-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
References: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jAV2hA5whBrM22lhsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PFxq8eDjwe
	d67tYfPYvKTe4/a/x8weW662s3j0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxsLzZ1gK9gtV
	nNhznrmB8SZ/FyMnh4SAicT8Q7dYIGwxiQv31rN1MXJxCAksYpToWf+MtYuRA8jpYpJYUgtS
	wyZgJTGxfRUjiC0ioCbRs3grI0g9s8BsZolXDx+ADRIWSJD48bqBDcRmEVCVWHbnNTOIzSvg
	LvF6/wRmiGWKEt3PJoDVcAp4SEx58AUsLgRUs7P7JssERt4FjAyrGEVTC5ILipPScw31ihNz
	i0vz0vWS83M3MYJD8ZnUDsaVDRaHGAU4GJV4eBd85ggRYk0sK67MPcQowcGsJMJru5szRIg3
	JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAPj9rxN+17eypvH
	vyJtvYXELeHJxrbLw78oN+ltvfb2oHtzy1SlxT7mdpnvzgfcllnqm5YQcrLT7Y3OsfKV3Vnp
	Lmalk7fPe7ghyHZj8nrnKf8yLUSfKsSeTfB9ti5g6/7cNWUL9qtwC/9Sb/9yvELne+FcFmv7
	zyHHevSf/gpU5PQ6K7bxv9cBJZbijERDLeai4kQAENiMa0ECAAA=
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
v6:
- no changes

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

