Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3KAWJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:09:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48587 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab3KAWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:09:05 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 09/11] ARM: msm: Add SMP support for KPSSv2
Date: Fri,  1 Nov 2013 15:08:57 -0700
Message-Id: <1383343739-23080-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2.564.g0d6cf24
In-Reply-To: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
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
 arch/arm/mach-msm/platsmp.c | 86 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index e187c6e..87e4fdc 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -32,8 +32,10 @@
 #define SCSS_DBG_STATUS_CORE_PWRDUP	0x2e64
 
 #define APCS_CPU_PWR_CTL	0x04
+#define APC_PWR_GATE_CTL	0x14
 
 #define APCS_SAW2_VCTL		0x14
+#define L2_SAW2_VCTL		0x1c
 
 extern void secondary_startup(void);
 
@@ -119,6 +121,89 @@ static int kpssv1_release_secondary(struct device_node *node, unsigned int cpu)
 	return 0;
 }
 
+static int kpssv2_release_secondary(struct device_node *node, unsigned int cpu)
+{
+	u32 off;
+	struct resource res;
+	void __iomem *reg;
+	struct device_node *l2_node;
+	void __iomem *l2_saw_base;
+	unsigned reg_val;
+	int err;
+
+	if (of_property_read_u32(node, "cpu-offset", &off))
+		return -EINVAL;
+
+	if (of_address_to_resource(node, 0, &res))
+		return -EINVAL;
+
+	l2_node = of_find_compatible_node(NULL, NULL, "qcom,l2-saw2");
+	if (!l2_node)
+		return -ENODEV;
+
+	reg = ioremap(res.start + off + (SZ_64K * cpu), resource_size(&res));
+	if (!reg) {
+		err = -ENOMEM;
+		goto err_map;
+	}
+
+	l2_saw_base = of_iomap(l2_node, 0);
+	if (!l2_saw_base) {
+		err = -ENOMEM;
+		goto err_l2_map;
+	}
+
+	/* Turn on the BHS, turn off LDO Bypass and power down LDO */
+	reg_val =  0x403f0001;
+	writel_relaxed(reg_val, reg + APC_PWR_GATE_CTL);
+
+	/* complete the above write before the delay */
+	mb();
+	/* wait for the bhs to settle */
+	udelay(1);
+
+	/* Turn on BHS segments */
+	reg_val |= 0x3f << 1;
+	writel_relaxed(reg_val, reg + APC_PWR_GATE_CTL);
+
+	/* complete the above write before the delay */
+	mb();
+	 /* wait for the bhs to settle */
+	udelay(1);
+
+	/* Finally turn on the bypass so that BHS supplies power */
+	reg_val |= 0x3f << 8;
+	writel_relaxed(reg_val, reg + APC_PWR_GATE_CTL);
+
+	/* enable max phases */
+	writel_relaxed(0x10003, l2_saw_base + L2_SAW2_VCTL);
+	mb();
+	udelay(50);
+
+	iounmap(l2_saw_base);
+
+	writel_relaxed(0x021, reg + APCS_CPU_PWR_CTL);
+	mb();
+	udelay(2);
+
+	writel_relaxed(0x020, reg + APCS_CPU_PWR_CTL);
+	mb();
+	udelay(2);
+
+	writel_relaxed(0x000, reg + APCS_CPU_PWR_CTL);
+	mb();
+
+	writel_relaxed(0x080, reg + APCS_CPU_PWR_CTL);
+	mb();
+
+	err = 0;
+err_l2_map:
+	iounmap(reg);
+err_map:
+	of_node_put(l2_node);
+	return err;
+}
+
 static DEFINE_PER_CPU(int, cold_boot_done);
 
 static int boot_cold_cpu(unsigned int cpu)
@@ -131,6 +216,7 @@ static int boot_cold_cpu(unsigned int cpu)
 	static const struct of_device_id match_table[] = {
 		M("qcom,gcc-8660", scss_release_secondary),
 		M("qcom,kpss-acc-v1", kpssv1_release_secondary),
+		M("qcom,kpss-acc-v2", kpssv2_release_secondary),
 	};
 #undef M
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

