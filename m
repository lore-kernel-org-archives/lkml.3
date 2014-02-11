Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaBKCSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:18:25 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57584 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaBKCSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:18:13 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-18-52f988629bff
From: Tarek Dakhran <t.dakhran@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: [PATCH v1 1/1] ARM: EXYNOS: enable boot all secondary cpus instead 2
Date: Tue, 11 Feb 2014 11:15:29 +0900
Message-id: <1392084929-14116-2-git-send-email-t.dakhran@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1392084929-14116-1-git-send-email-t.dakhran@samsung.com>
References: <1392084929-14116-1-git-send-email-t.dakhran@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xy7pJHT+DDN5t5bGYtO4Ak8XD9TdZ
	LPrfLGS1OPdqJaNF74KrbBabHl9jtbi8aw6bxYzz+5gsbl/mtVh6/SKTxYTpa1ksWvceYbf4
	3fOJ2WL981OMFutnvGaxmDrjB7uDgMeaeWsYPVqae9g8Lvf1Mnn8XfWC2WPnrLvsHiuXf2Hz
	2LSqk83jzrU9bB6bl9R79G1ZxejxeZNcAHcUl01Kak5mWWqRvl0CV8bbTb9YCz4qVny6o9PA
	uFG6i5GTQ0LAROLCo3+sELaYxIV769lAbCGBpYwSL9vcIexeJomGuYFdjBwcbALaElt2eIGE
	RQQUJDb3PgNrZRY4xiKxaEo+iC0s4Cux7FI/E4jNIqAqMf/hF7CRvAKuEoemTGeEWKUo0f1s
	AlicU8BNYvmZhVBrXSXOHNvFPIGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkAD/
	uoNx6TGrQ4wCHIxKPLwaX38ECbEmlhVX5h5ilOBgVhLhPWv3M0iINyWxsiq1KD++qDQntfgQ
	IxMHp1QDI/Nu8VL5Ky3ickmlS9rlrq06M+uzSMel2gB3zqb7x7q7ZF/6yUzQXHskrGNRv6WV
	ls1ugwUamg+LJnVM11tjVM9/+0qi983txacsSk7Xz4n8KcLfuE9WJE7lzNP/V3w/ZUdbiKyL
	fc8UcCth2RVmsWW/dpzWYtog3/LFosXZYVdJmtLWJT8blViKMxINtZiLihMBrPpggE4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions to boot secondary cpus added.
	exynos_core_power_up(unsigned int cpu) added for power up any cpu.
	exynos_core_power_down(unsigned int cpu) for power down any cpu.

Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c  |   11 ++++--
 arch/arm/mach-exynos/platsmp.c  |   75 ++++++++++++++++++++++++++++-----------
 arch/arm/mach-exynos/regs-pmu.h |    5 +++
 3 files changed, 68 insertions(+), 23 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 5eead53..71982fa 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -90,13 +90,18 @@ static inline void cpu_leave_lowpower(void)
 	  : "cc");
 }
 
+static void exynos_core_power_down(unsigned int cpu)
+{
+	writel_relaxed(0, S5P_ARM_CORE_CONFIGURATION(cpu));
+}
+
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 {
 	for (;;) {
 
-		/* make cpu1 to be turned off at next WFI command */
-		if (cpu == 1)
-			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
+		/* make cpu to be turned off at next WFI command */
+		if (cpu)
+			exynos_core_power_down(cpu);
 
 		/*
 		 * here's the WFI
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 8ea02f6..4008fc8 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -88,10 +88,61 @@ static void exynos_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
+/*
+ * core_power_state is used to get core power state.
+ * returns:
+ *        0x0 - powered off;
+ *        0x3 - powered on;
+ *        other values - in process;
+ */
+static unsigned int core_power_state(unsigned int cpu)
+{
+	unsigned int status = readl_relaxed(S5P_ARM_CORE_STATUS(cpu));
+
+	return status & CORE_PWR_STATE_MASK;
+}
+
+#define TIMEOUT 10
+#define DELAY_TIME 1
+
+static int wait_core_power_up(unsigned int cpu)
+{
+	int timeout = TIMEOUT;
+
+	do {
+		/* checking if power controller in reset */
+		if (core_power_state(cpu) == S5P_CORE_LOCAL_PWR_EN)
+				return 0;
+		mdelay(DELAY_TIME);
+		timeout -= DELAY_TIME;
+	} while (timeout > 0);
+
+	return -ETIMEDOUT; /* timeout */
+}
+
+static int exynos_core_power_up(unsigned int cpu)
+{
+	int ret;
+
+	if (core_power_state(cpu) != S5P_CORE_LOCAL_PWR_EN) {
+		writel_relaxed(S5P_CORE_LOCAL_PWR_EN,
+					S5P_ARM_CORE_CONFIGURATION(cpu));
+
+		ret = wait_core_power_up(cpu);
+		if (ret) {
+			pr_debug("timeout powering on CPU%d\n", cpu);
+			return ret; /* timeout */
+		}
+	}
+
+	return 0;
+}
+
 static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 	unsigned long phys_cpu = cpu_logical_map(cpu);
+	int ret;
 
 	/*
 	 * Set synchronisation state between this boot processor
@@ -109,26 +160,10 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	 */
 	write_pen_release(phys_cpu);
 
-	if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN)) {
-		__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-			     S5P_ARM_CORE1_CONFIGURATION);
-
-		timeout = 10;
-
-		/* wait max 10 ms until cpu1 is on */
-		while ((__raw_readl(S5P_ARM_CORE1_STATUS)
-			& S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN) {
-			if (timeout-- == 0)
-				break;
-
-			mdelay(1);
-		}
-
-		if (timeout == 0) {
-			printk(KERN_ERR "cpu1 power enable failed");
-			spin_unlock(&boot_lock);
-			return -ETIMEDOUT;
-		}
+	ret = exynos_core_power_up(cpu);
+	if (ret) {
+		spin_unlock(&boot_lock);
+		return ret;
 	}
 	/*
 	 * Send the secondary CPU a soft interrupt, thereby causing
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 7c029ce..4fc1e8f 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -104,6 +104,11 @@
 #define S5P_GPS_LOWPWR				S5P_PMUREG(0x139C)
 #define S5P_GPS_ALIVE_LOWPWR			S5P_PMUREG(0x13A0)
 
+#define CORE_PWR_STATE_MASK			0x3
+
+#define S5P_ARM_CORE_CONFIGURATION(_nr)	(S5P_PMUREG(0x2000) + ((_nr) * 0x80))
+#define S5P_ARM_CORE_STATUS(_nr)	(S5P_PMUREG(0x2004) + ((_nr) * 0x80))
+
 #define S5P_ARM_CORE1_CONFIGURATION		S5P_PMUREG(0x2080)
 #define S5P_ARM_CORE1_STATUS			S5P_PMUREG(0x2084)
 
-- 
1.7.10.4

