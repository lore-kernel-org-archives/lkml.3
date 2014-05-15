Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaEOLWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:22:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48591 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaEOLWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:22:22 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-52-5374a366a72c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: EXYNOS: SWRESET is needed to boot secondary CPU on
 Exynos3250
Date: Thu, 15 May 2014 13:18:11 +0200
Message-id: <1400152691-29705-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xa7ppi0uCDe6uk7DYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbrJ/xmsWBy6OluYfNY/OSeo++
	LasYPT5vkgtgieKySUnNySxLLdK3S+DKmNq2jLmgSbRi19k9jA2MiwS7GDk5JARMJH7s/cIK
	YYtJXLi3nq2LkYtDSGApo8TKtg3MEE4fk0TH4ztMIFVsAsYSm5cvAasSEdjBKLH83mV2kASz
	wHNGiaffw0FsYYFQiZ2zP7OA2CwCqhKd6y+CNfMKuEssvPyIDWKdnMTJY5NZJzByL2BkWMUo
	mlqaXFCclJ5rqFecmFtcmpeul5yfu4kREjZfdjAuPmZ1iFGAg1GJh7djf3GwEGtiWXFl7iFG
	CQ5mJRHexuklwUK8KYmVValF+fFFpTmpxYcYmTg4pRoY+6veazxWjf0+tSFMe/sblVcJc+a7
	fVHef56/N2/hBRGWwK4de/Nv99QocJjb2ddsXh70gHsBT0mPzMf/ep8ijO+Zb33d8uXUl0Pf
	042f9Zb/X39XxKXXhLXz7Brzk8+u5sXa6yWoW95wXOjw45fGcrZF926cVpzbbHzt4qv2C3d3
	zms7abn5rhJLcUaioRZzUXEiAAHEMSL5AQAA
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
---
 arch/arm/mach-exynos/platsmp.c  | 22 ++++++++++++++++++++++
 arch/arm/mach-exynos/regs-pmu.h |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 8b88eb2f077b..64ec5ca18f60 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -76,6 +76,25 @@ static inline void __iomem *cpu_boot_reg(int cpu)
 }
 
 /*
+ * Set wake up by local power mode and execute software reset for given core.
+ *
+ * Currently this is needed only when booting secondary CPU on Exynos3250.
+ */
+static inline void exynos_core_restart(u32 core_id)
+{
+	if (of_machine_is_compatible("samsung,exynos3250")) {
+		u32 val;
+
+		val = __raw_readl(S5P_ARM_CORE_STATUS(core_id));
+		val |= S5P_CORE_WAKEUP_FROM_LOCAL_CFG;
+		__raw_writel(val, S5P_ARM_CORE_STATUS(core_id));
+
+		pr_info("CPU%u: Software reset\n", core_id);
+		__raw_writel(EXYNOS_CORE_PO_RESET(core_id), EXYNOS_SWRESET);
+	}
+}
+
+/*
  * Write pen_release in a way that is guaranteed to be visible to all
  * observers, irrespective of whether they're taking part in coherency
  * or not.  This is necessary for the hotplug code to work reliably.
@@ -155,6 +174,9 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
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
index d94bbc85d7e0..3ecbb4fe227b 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -26,6 +26,8 @@
 #define S5P_USE_STANDBY_WFI0			(1 << 16)
 #define S5P_USE_STANDBY_WFE0			(1 << 24)
 
+#define EXYNOS_CORE_PO_RESET(n)			((1 << 4) << n)
+
 #define EXYNOS_SWRESET				S5P_PMUREG(0x0400)
 #define EXYNOS5440_SWRESET			S5P_PMUREG(0x00C4)
 
@@ -117,6 +119,7 @@
 #define S5P_PAD_RET_EBIB_OPTION			S5P_PMUREG(0x31A8)
 
 #define S5P_CORE_LOCAL_PWR_EN			0x3
+#define S5P_CORE_WAKEUP_FROM_LOCAL_CFG		(0x3 << 8)
 #define S5P_INT_LOCAL_PWR_EN			0x7
 
 #define S5P_CHECK_SLEEP				0x00000BAD
-- 
1.9.1

