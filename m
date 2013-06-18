Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3FRP1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:27:07 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35149 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3FRP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:27:04 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-f6-51c07c46073a
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, stable@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] ARM: EXYNOS: Fix incorrect usage of S5P_ARM_CORE1_* registers
Date: Tue, 18 Jun 2013 17:26:31 +0200
Message-id: <1371569191-2364-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.8.2.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xy7puNQcCDWasYbV4vGYxk8XlhZdY
	LZY0c1v0LrjKZnG26Q27xabH11gtLu+aw2Yx4/w+Jovbl3ktFmx8xGixfsZrFgduj5bmHjaP
	zUvqPfq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj68+bbAU75Svu/njM2MD4S7KLkZNDQsBE
	YsXi1YwQtpjEhXvr2boYuTiEBJYySsx6d5oFwuljkjj/9jFYFZuAmsTnhkdsILaIgKrE57YF
	7CBFzAKNzBJ/p+1nBUkIC/hJnDq/EMxmASqae3MKE4jNK+AocXr9T3aIdQoSx7dvY5zAyL2A
	kWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkgAfdnBuPiY1SFGAQ5GJR7eBLH9gUKsiWXF
	lbmHGCU4mJVEeBUSDwQK8aYkVlalFuXHF5XmpBYfYmTi4JRqYHSa5bvlL8MmtuS167oMG/0c
	XN1t5Vl/sWenez3a9tL590lXoYB7XoxtbaabYv/Ouqy83jEzfOHlM8p/z/JdnLkkTGBiyvb+
	re/eik148Yj17SM2n/QD7hqNvb2f/q6Q+Xt66ZqrvJMfZ05mbFX+8yqCNcTdXnhtx86XR+vE
	FNQ332z8sH2vZ7gSS3FGoqEWc1FxIgAOakwn/gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S5P_ARM_CORE1_* registers affect only core 1. To control further cores
properly another registers must be used.

This patch replaces S5P_ARM_CORE1_* register definitions with
S5P_ARM_CORE_*(x) macro which return addresses of registers for specified
core.

This fixes CPU hotplug on quad core Exynos SoCs on which currently
offlining CPUs 2 or 3 caused CPU 1 to be turned off. In addition,
bring-up of CPU 2 and 3 is fixed on boards where bootloader powers off
secondary cores by default.

Cc: stable@vger.kernel.org
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c               |  9 +++++----
 arch/arm/mach-exynos/include/mach/regs-pmu.h | 10 +++++++---
 arch/arm/mach-exynos/platsmp.c               |  9 +++++----
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index af90cfa..c089943 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -93,10 +93,11 @@ static inline void cpu_leave_lowpower(void)
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 {
 	for (;;) {
+		void __iomem *reg_base;
+		unsigned int phys_cpu = cpu_logical_map(cpu);
 
-		/* make cpu1 to be turned off at next WFI command */
-		if (cpu == 1)
-			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
+		reg_base = S5P_ARM_CORE_CONFIGURATION(phys_cpu);
+		__raw_writel(0, reg_base);
 
 		/*
 		 * here's the WFI
@@ -106,7 +107,7 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 		    :
 		    : "memory", "cc");
 
-		if (pen_release == cpu_logical_map(cpu)) {
+		if (pen_release == phys_cpu) {
 			/*
 			 * OK, proper wakeup, we're done
 			 */
diff --git a/arch/arm/mach-exynos/include/mach/regs-pmu.h b/arch/arm/mach-exynos/include/mach/regs-pmu.h
index 57344b7..cf40b86 100644
--- a/arch/arm/mach-exynos/include/mach/regs-pmu.h
+++ b/arch/arm/mach-exynos/include/mach/regs-pmu.h
@@ -125,10 +125,14 @@
 #define S5P_GPS_ALIVE_LOWPWR			S5P_PMUREG(0x13A0)
 
 #define S5P_ARM_CORE0_CONFIGURATION		S5P_PMUREG(0x2000)
+#define S5P_ARM_CORE0_STATUS			S5P_PMUREG(0x2004)
 #define S5P_ARM_CORE0_OPTION			S5P_PMUREG(0x2008)
-#define S5P_ARM_CORE1_CONFIGURATION		S5P_PMUREG(0x2080)
-#define S5P_ARM_CORE1_STATUS			S5P_PMUREG(0x2084)
-#define S5P_ARM_CORE1_OPTION			S5P_PMUREG(0x2088)
+#define S5P_ARM_CORE_CONFIGURATION(_nr)		\
+		(S5P_ARM_CORE0_CONFIGURATION + ((_nr) * 0x80))
+#define S5P_ARM_CORE_STATUS(_nr)		\
+		(S5P_ARM_CORE0_STATUS + ((_nr) * 0x80))
+#define S5P_ARM_CORE_OPTION(_nr)		\
+		(S5P_ARM_CORE0_OPTION + ((_nr) * 0x80))
 
 #define S5P_ARM_COMMON_OPTION			S5P_PMUREG(0x2408)
 #define S5P_TOP_PWR_OPTION			S5P_PMUREG(0x2C48)
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index d9c6d0a..2cbabc8 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -109,14 +109,15 @@ static int __cpuinit exynos_boot_secondary(unsigned int cpu, struct task_struct
 	 */
 	write_pen_release(phys_cpu);
 
-	if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN)) {
+	if (!(__raw_readl(S5P_ARM_CORE_STATUS(phys_cpu))
+	    & S5P_CORE_LOCAL_PWR_EN)) {
 		__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-			     S5P_ARM_CORE1_CONFIGURATION);
+			     S5P_ARM_CORE_CONFIGURATION(phys_cpu));
 
 		timeout = 10;
 
 		/* wait max 10 ms until cpu1 is on */
-		while ((__raw_readl(S5P_ARM_CORE1_STATUS)
+		while ((__raw_readl(S5P_ARM_CORE_STATUS(phys_cpu))
 			& S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN) {
 			if (timeout-- == 0)
 				break;
@@ -125,7 +126,7 @@ static int __cpuinit exynos_boot_secondary(unsigned int cpu, struct task_struct
 		}
 
 		if (timeout == 0) {
-			printk(KERN_ERR "cpu1 power enable failed");
+			printk(KERN_ERR "cpu%u power enable failed", cpu);
 			spin_unlock(&boot_lock);
 			return -ETIMEDOUT;
 		}
-- 
1.8.2.1

