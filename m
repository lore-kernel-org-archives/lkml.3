Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaIXMbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:31:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46573 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaIXMbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:31:02 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e1-5422b9830de5
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3] ARM: EXYNOS: SWRESET is needed to boot secondary CPU on
 Exynos3250
Date: Wed, 24 Sep 2014 14:30:51 +0200
Message-id: <1411561851-13764-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xq7rNO5VCDJ6t1LfYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbrNr1h9GBy6OluYfNY+esu+we
	m5fUe/RtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGw3k7WAqOiVe8+HCRvYFxg3AXIyeHhICJ
	xI9X25kgbDGJC/fWs3UxcnEICSxllDjRMZ0Zwuljkni54AA7SBWbgLHE5uVLwKpEBHYwSiy/
	d5kdxGEWeMMo0btnIgtIlbBAhMSS9rOMXYwcHCwCqhKPlzmChHkF3CWerLvGBrFOTuLkscms
	Exi5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQICaCvOxiXHrM6xCjAwajEwztRXClE
	iDWxrLgy9xCjBAezkggvDzD8hHhTEiurUovy44tKc1KLDzEycXBKNTCKSvsVFjBN/31hS6uE
	bLy0q9nv+SxHNyiu+MK16tCNU48kK9t+XRc+2XbCzer1AcE+hlqFrelGPV8iPWJ4yhZ9OvNG
	ZPm/a6UzzH7+FP6/jnn5t5aeSfpHo/rXXc0vD3Tbw3f25aajLGoG/b/79SYdefu0U0bvGw93
	Hpecp1XtJX52xnsLA74rsRRnJBpqMRcVJwIA+1CuhP4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without software reset the secondary CPU does not power up and
exynos_boot_secondary() ends with pen_release equal to 1. This can be
observed in dmesg:
	CPU1: failed to come online
	Brought up 1 CPUs
	SMP: Total of 1 processors activated.
	CPU: All CPU(s) started in SVC mode.

When booting the secondary CPU on Exynos3250 execute also software
reset for core 1.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>

---

Changes since v2:
1. Rebase on Kukjin's for-next tree from 24th of September
(v3.17-rc3-97-gbcf20e084a4b)

Changes since v1:
1. Removed inline keyword and change if statement to early return as
   Tomasz suggested.
2. Added reviewed-by Tomasz Figa.
---
 arch/arm/mach-exynos/platsmp.c  | 23 +++++++++++++++++++++++
 arch/arm/mach-exynos/regs-pmu.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 41ae28d69e6f..8543064dc445 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -121,6 +121,26 @@ static inline void __iomem *cpu_boot_reg(int cpu)
 }
 
 /*
+ * Set wake up by local power mode and execute software reset for given core.
+ *
+ * Currently this is needed only when booting secondary CPU on Exynos3250.
+ */
+static void exynos_core_restart(u32 core_id)
+{
+	u32 val;
+
+	if (!of_machine_is_compatible("samsung,exynos3250"))
+		return;
+
+	val = pmu_raw_readl(EXYNOS_ARM_CORE_STATUS(core_id));
+	val |= S5P_CORE_WAKEUP_FROM_LOCAL_CFG;
+	pmu_raw_writel(val, EXYNOS_ARM_CORE_STATUS(core_id));
+
+	pr_info("CPU%u: Software reset\n", core_id);
+	pmu_raw_writel(EXYNOS_CORE_PO_RESET(core_id), EXYNOS_SWRESET);
+}
+
+/*
  * Write pen_release in a way that is guaranteed to be visible to all
  * observers, irrespective of whether they're taking part in coherency
  * or not.  This is necessary for the hotplug code to work reliably.
@@ -196,6 +216,9 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 			return -ETIMEDOUT;
 		}
 	}
+
+	exynos_core_restart(core_id);
+
 	/*
 	 * Send the secondary CPU a soft interrupt, thereby causing
 	 * the boot monitor to read the system wide flags register,
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 30c03017aa6a..4ea5e320c6d1 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -21,6 +21,7 @@
 #define S5P_USE_STANDBY_WFI0			(1 << 16)
 #define S5P_USE_STANDBY_WFE0			(1 << 24)
 
+#define EXYNOS_CORE_PO_RESET(n)			((1 << 4) << n)
 #define EXYNOS_WAKEUP_FROM_LOWPWR		(1 << 28)
 #define EXYNOS_SWRESET				0x0400
 #define EXYNOS5440_SWRESET			0x00C4
@@ -125,6 +126,7 @@
 #define S5P_PAD_RET_EBIB_OPTION			0x31A8
 
 #define S5P_CORE_LOCAL_PWR_EN			0x3
+#define S5P_CORE_WAKEUP_FROM_LOCAL_CFG		(0x3 << 8)
 
 /* Only for EXYNOS4210 */
 #define S5P_CMU_CLKSTOP_LCD1_LOWPWR	0x1154
-- 
1.9.1

