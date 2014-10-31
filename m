Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaJaE1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 00:27:52 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36062 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaJaE1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 00:27:23 -0400
From: Tim Harvey <tharvey@gateworks.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Christian Hemp <c.hemp@phytec.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Iain Paton <ipaton0@gmail.com>
Subject: [PATCH 4/5] cpufreq: imx6q: add ldo-bypass support
Date: Thu, 30 Oct 2014 21:27:10 -0700
Message-Id: <1414729631-11005-5-git-send-email-tharvey@gateworks.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
References: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an external PMIC is used for VDD_SOC and VDD_ARM you can save power by
bypassing the internal LDO's provided by the anantop regulator as long as
you are running less than 1.2GHz. If running at 1.2GHz the IMX6 datasheets
state that you must use the internal LDO's to reduce ripple on the suplies.

A failure to bypass the LDO's when using an external PMIC will result in an
extra voltage drop (~125mV) between VDD_ARM_IN and VDD_ARM and VDD_SOC_IN and
VDD_SOC which violates the voltages specificed by the datasheets.

Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/cpufreq/imx6q-cpufreq.c | 51 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index c2d3076..fc69f36 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -159,6 +159,9 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	int num, ret;
 	const struct property *prop;
 	const __be32 *val;
+	struct regulator *anatop_arm_reg = NULL;
+	struct regulator *anatop_pu_reg = NULL;
+	struct regulator *anatop_soc_reg = NULL;
 	u32 nr, i, j;
 
 	cpu_dev = get_cpu_device(0);
@@ -167,6 +170,20 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-anatop");
+	if (np) {
+		anatop_arm_reg = regulator_get(&pdev->dev, "vddarm");
+		anatop_pu_reg = regulator_get(&pdev->dev, "vddpu");
+		anatop_soc_reg = regulator_get(&pdev->dev, "vddsoc");
+		if (PTR_ERR(anatop_arm_reg) == -EPROBE_DEFER ||
+		    PTR_ERR(anatop_pu_reg) == -EPROBE_DEFER ||
+		    PTR_ERR(anatop_soc_reg) == -EPROBE_DEFER) {
+				ret = -EPROBE_DEFER;
+				goto put_reg;
+		}
+		of_node_put(np);
+	}
+
 	np = of_node_get(cpu_dev->of_node);
 	if (!np) {
 		dev_err(cpu_dev, "failed to find cpu0 node\n");
@@ -301,7 +318,41 @@ soc_opp_out:
 		goto free_freq_table;
 	}
 
+	/* enable LDO bypass mode if anatop regs are not being used for core */
+	if ((!IS_ERR(anatop_arm_reg) &&
+	     !IS_ERR(anatop_pu_reg) &&
+	     !IS_ERR(anatop_soc_reg) &&
+	     regulator_is_same(arm_reg, anatop_arm_reg) &&
+	     regulator_is_same(pu_reg, anatop_pu_reg) &&
+	     regulator_is_same(soc_reg, anatop_soc_reg)) ||
+            (freq_table[num].frequency == FREQ_1P2_GHZ / 1000))
+	{
+		printk("Using anatop regulators: LDO enabled\n");
+	} else {
+		int puvolt = regulator_get_voltage(anatop_pu_reg);
+
+		printk("Not using anatop LDO's: enabling LDO bypass\n");
+		regulator_allow_bypass(anatop_arm_reg, true);
+		regulator_allow_bypass(anatop_pu_reg, true);
+		if (regulator_is_same(pu_reg, anatop_pu_reg))
+			regulator_allow_bypass(pu_reg, true);
+		regulator_allow_bypass(anatop_soc_reg, true);
+		if (!regulator_is_bypass(anatop_arm_reg) ||
+		    !regulator_is_bypass(anatop_pu_reg) ||
+		    !regulator_is_bypass(anatop_soc_reg))
+			dev_err(cpu_dev, "failed to set LDO bypass\n");
+		else {
+			if (puvolt == 0)
+				regulator_set_voltage(anatop_pu_reg, 0, 0);
+		}
+
+	}
+	regulator_put(anatop_arm_reg);
+	regulator_put(anatop_pu_reg);
+	regulator_put(anatop_soc_reg);
+
 	of_node_put(np);
+
 	return 0;
 
 free_freq_table:
-- 
1.8.3.2

