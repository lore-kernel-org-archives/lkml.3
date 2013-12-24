Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3LXAlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:41:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47616 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3LXAkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:40:01 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 7/9] ARM: msm: Add SMP support for KPSSv1
Date: Mon, 23 Dec 2013 16:39:51 -0800
Message-Id: <1387845593-10050-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

Implement support for the Krait CPU release sequence when the
CPUs are part of the first version of the krait processor
subsystem.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/platsmp.c  | 106 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/scm-boot.h |   8 ++--
 2 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 11c6239..4b13cd8 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -30,6 +30,16 @@
 #define SCSS_CPU1CORE_RESET		0x2d80
 #define SCSS_DBG_STATUS_CORE_PWRDUP	0x2e64
 
+#define APCS_CPU_PWR_CTL	0x04
+#define PLL_CLAMP		BIT(8)
+#define CORE_PWRD_UP		BIT(7)
+#define COREPOR_RST		BIT(5)
+#define CORE_RST		BIT(4)
+#define L2DT_SLP		BIT(3)
+#define CLAMP			BIT(0)
+
+#define APCS_SAW2_VCTL		0x14
+
 extern void secondary_startup(void);
 
 static DEFINE_SPINLOCK(boot_lock);
@@ -68,6 +78,85 @@ static int scss_release_secondary(unsigned int cpu)
 	return 0;
 }
 
+static int kpssv1_release_secondary(unsigned int cpu)
+{
+	int ret = 0;
+	void __iomem *reg, *saw_reg;
+	struct device_node *cpu_node, *acc_node, *saw_node;
+	u32 val;
+
+	cpu_node = of_get_cpu_node(cpu, NULL);
+	if (!cpu_node)
+		return -ENODEV;
+
+	acc_node = of_parse_phandle(cpu_node, "qcom,acc", 0);
+	if (!acc_node) {
+		ret = -ENODEV;
+		goto out_acc;
+	}
+
+	saw_node = of_parse_phandle(cpu_node, "qcom,saw", 0);
+	if (!saw_node) {
+		ret = -ENODEV;
+		goto out_saw;
+	}
+
+	reg = of_iomap(acc_node, 0);
+	if (!reg) {
+		ret = -ENOMEM;
+		goto out_acc_map;
+	}
+
+	saw_reg = of_iomap(saw_node, 0);
+	if (!saw_reg) {
+		ret = -ENOMEM;
+		goto out_saw_map;
+	}
+
+	/* Turn on CPU rail */
+	writel_relaxed(0xA4, saw_reg + APCS_SAW2_VCTL);
+	mb();
+	udelay(512);
+
+	/* Krait bring-up sequence */
+	val = PLL_CLAMP | L2DT_SLP | CLAMP;
+	writel_relaxed(val, reg + APCS_CPU_PWR_CTL);
+	val &= ~L2DT_SLP;
+	writel_relaxed(val, reg + APCS_CPU_PWR_CTL);
+	mb();
+	ndelay(300);
+
+	val |= COREPOR_RST;
+	writel_relaxed(val, reg + APCS_CPU_PWR_CTL);
+	mb();
+	udelay(2);
+
+	val &= ~CLAMP;
+	writel_relaxed(val, reg + APCS_CPU_PWR_CTL);
+	mb();
+	udelay(2);
+
+	val &= ~COREPOR_RST;
+	writel_relaxed(val, reg + APCS_CPU_PWR_CTL);
+	mb();
+	udelay(100);
+
+	val |= CORE_PWRD_UP;
+	writel_relaxed(val, reg + APCS_CPU_PWR_CTL);
+	mb();
+
+	iounmap(saw_reg);
+out_saw_map:
+	iounmap(reg);
+out_acc_map:
+	of_node_put(saw_node);
+out_saw:
+	of_node_put(acc_node);
+out_acc:
+	of_node_put(cpu_node);
+	return ret;
+}
+
 static DEFINE_PER_CPU(int, cold_boot_done);
 
 static int msm_boot_secondary(unsigned int cpu, int (*func)(unsigned int))
@@ -107,6 +196,11 @@ static int msm8660_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	return msm_boot_secondary(cpu, scss_release_secondary);
 }
 
+static int kpssv1_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	return msm_boot_secondary(cpu, kpssv1_release_secondary);
+}
+
 static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
 {
 	int cpu, map;
@@ -114,6 +208,8 @@ static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
 	static const int cold_boot_flags[] = {
 		0,
 		SCM_FLAG_COLDBOOT_CPU1,
+		SCM_FLAG_COLDBOOT_CPU2,
+		SCM_FLAG_COLDBOOT_CPU3,
 	};
 
 	for_each_present_cpu(cpu) {
@@ -144,3 +240,13 @@ static struct smp_operations msm_smp_8660_ops __initdata = {
 #endif
 };
 CPU_METHOD_OF_DECLARE(msm_smp, "qcom,gcc-msm8660", &msm_smp_8660_ops);
+
+static struct smp_operations msm_smp_kpssv1_ops __initdata = {
+	.smp_prepare_cpus	= msm_smp_prepare_cpus,
+	.smp_secondary_init	= msm_secondary_init,
+	.smp_boot_secondary	= kpssv1_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= msm_cpu_die,
+#endif
+};
+CPU_METHOD_OF_DECLARE(msm_smp_kpssv1, "qcom,kpss-acc-v1", &msm_smp_kpssv1_ops);
diff --git a/arch/arm/mach-msm/scm-boot.h b/arch/arm/mach-msm/scm-boot.h
index 7be32ff..6aabb24 100644
--- a/arch/arm/mach-msm/scm-boot.h
+++ b/arch/arm/mach-msm/scm-boot.h
@@ -13,9 +13,11 @@
 #define __MACH_SCM_BOOT_H
 
 #define SCM_BOOT_ADDR			0x1
-#define SCM_FLAG_COLDBOOT_CPU1		0x1
-#define SCM_FLAG_WARMBOOT_CPU1		0x2
-#define SCM_FLAG_WARMBOOT_CPU0		0x4
+#define SCM_FLAG_COLDBOOT_CPU1		0x01
+#define SCM_FLAG_COLDBOOT_CPU2		0x08
+#define SCM_FLAG_COLDBOOT_CPU3		0x20
+#define SCM_FLAG_WARMBOOT_CPU0		0x04
+#define SCM_FLAG_WARMBOOT_CPU1		0x02
 
 int scm_set_boot_addr(phys_addr_t addr, int flags);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

