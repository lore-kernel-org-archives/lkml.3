Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab3LXAlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:41:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47624 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab3LXAkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:40:01 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 8/9] ARM: msm: Add SMP support for KPSSv2
Date: Mon, 23 Dec 2013 16:39:52 -0800
Message-Id: <1387845593-10050-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

Implement support for the Krait CPU release sequence when the
CPUs are part of the second version of the Krait processor
subsystem.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/platsmp.c | 123 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 4b13cd8..f07ad9d 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -38,7 +38,15 @@
 #define L2DT_SLP		BIT(3)
 #define CLAMP			BIT(0)
 
+#define APC_PWR_GATE_CTL	0x14
+#define BHS_CNT_SHIFT		24
+#define LDO_PWR_DWN_SHIFT	16
+#define LDO_BYP_SHIFT		8
+#define BHS_SEG_SHIFT		1
+#define BHS_EN			BIT(0)
+
 #define APCS_SAW2_VCTL		0x14
+#define APCS_SAW2_2_VCTL	0x1c
 
 extern void secondary_startup(void);
 
@@ -157,6 +165,106 @@ out_acc:
 	return ret;
 }
 
+static int kpssv2_release_secondary(unsigned int cpu)
+{
+	void __iomem *reg;
+	struct device_node *cpu_node, *l2_node, *acc_node, *saw_node;
+	void __iomem *l2_saw_base;
+	unsigned reg_val;
+	int ret;
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
+	l2_node = of_parse_phandle(cpu_node, "next-level-cache", 0);
+	if (!l2_node) {
+		ret = -ENODEV;
+		goto out_l2;
+	}
+
+	saw_node = of_parse_phandle(l2_node, "qcom,saw", 0);
+	if (!saw_node) {
+		ret = -ENODEV;
+		goto out_saw;
+	}
+
+	reg = of_iomap(acc_node, 0);
+	if (!reg) {
+		ret = -ENOMEM;
+		goto out_map;
+	}
+
+	l2_saw_base = of_iomap(saw_node, 0);
+	if (!l2_saw_base) {
+		ret = -ENOMEM;
+		goto out_saw_map;
+	}
+
+	/* Turn on the BHS, turn off LDO Bypass and power down LDO */
+	reg_val = (64 << BHS_CNT_SHIFT) | (0x3f << LDO_PWR_DWN_SHIFT) | BHS_EN;
+	writel_relaxed(reg_val, reg + APC_PWR_GATE_CTL);
+	mb();
+	/* wait for the BHS to settle */
+	udelay(1);
+
+	/* Turn on BHS segments */
+	reg_val |= 0x3f << BHS_SEG_SHIFT;
+	writel_relaxed(reg_val, reg + APC_PWR_GATE_CTL);
+	mb();
+	 /* wait for the BHS to settle */
+	udelay(1);
+
+	/* Finally turn on the bypass so that BHS supplies power */
+	reg_val |= 0x3f << LDO_BYP_SHIFT;
+	writel_relaxed(reg_val, reg + APC_PWR_GATE_CTL);
+
+	/* enable max phases */
+	writel_relaxed(0x10003, l2_saw_base + APCS_SAW2_2_VCTL);
+	mb();
+	udelay(50);
+
+	reg_val = COREPOR_RST | CLAMP;
+	writel_relaxed(reg_val, reg + APCS_CPU_PWR_CTL);
+	mb();
+	udelay(2);
+
+	reg_val &= ~CLAMP;
+	writel_relaxed(reg_val, reg + APCS_CPU_PWR_CTL);
+	mb();
+	udelay(2);
+
+	reg_val &= ~COREPOR_RST;
+	writel_relaxed(reg_val, reg + APCS_CPU_PWR_CTL);
+	mb();
+
+	reg_val |= CORE_PWRD_UP;
+	writel_relaxed(reg_val, reg + APCS_CPU_PWR_CTL);
+	mb();
+
+	ret = 0;
+
+	iounmap(l2_saw_base);
+out_saw_map:
+	iounmap(reg);
+out_map:
+	of_node_put(saw_node);
+out_saw:
+	of_node_put(l2_node);
+out_l2:
+	of_node_put(acc_node);
+out_acc:
+	of_node_put(cpu_node);
+
+	return ret;
+}
+
 static DEFINE_PER_CPU(int, cold_boot_done);
 
 static int msm_boot_secondary(unsigned int cpu, int (*func)(unsigned int))
@@ -201,6 +309,11 @@ static int kpssv1_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	return msm_boot_secondary(cpu, kpssv1_release_secondary);
 }
 
+static int kpssv2_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	return msm_boot_secondary(cpu, kpssv2_release_secondary);
+}
+
 static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
 {
 	int cpu, map;
@@ -250,3 +363,13 @@ static struct smp_operations msm_smp_kpssv1_ops __initdata = {
 #endif
 };
 CPU_METHOD_OF_DECLARE(msm_smp_kpssv1, "qcom,kpss-acc-v1", &msm_smp_kpssv1_ops);
+
+static struct smp_operations msm_smp_kpssv2_ops __initdata = {
+	.smp_prepare_cpus	= msm_smp_prepare_cpus,
+	.smp_secondary_init	= msm_secondary_init,
+	.smp_boot_secondary	= kpssv2_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= msm_cpu_die,
+#endif
+};
+CPU_METHOD_OF_DECLARE(msm_smp_kpssv2, "qcom,kpss-acc-v2", &msm_smp_kpssv2_ops);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

