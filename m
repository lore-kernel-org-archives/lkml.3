Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966138Ab3DQJrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:47:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11760 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965887Ab3DQJr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:47:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 17 Apr 2013 02:45:41 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <sameo@linux.intel.com>, <gg@slimlogic.co.uk>, <ian@slimlogic.co.uk>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/3] regulator: palmas: add support for LDO8 tracking mode
Date: Wed, 17 Apr 2013 15:13:13 +0530
Message-ID: <1366191793-13934-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com>
References: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LDO8 of Palma device like tps65913 support the tracking mode
on which LDO8 track the SMPS45 voltage when SMPS45 is ON
and use the LDO8.VOLTAGE_SEL register when SMPS45 is OFF.

On track mode, the steps of voltage change for LDO8 is 25mV
where in non-tracking mode it is 50mV. Set the steps accordingly.
Number of voltage count is still same for both the cases.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/palmas-regulator.c |   53 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/palmas.h           |    3 ++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 28080a7..d6efaf1 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -572,6 +572,46 @@ static int palmas_extreg_init(struct palmas *palmas, int id,
 	return 0;
 }
 
+static void palmas_enable_ldo8_track(struct palmas *palmas)
+{
+	unsigned int reg;
+	unsigned int addr;
+	int ret;
+
+	addr = palmas_regs_info[PALMAS_REG_LDO8].ctrl_addr;
+
+	ret = palmas_ldo_read(palmas, addr, &reg);
+	if (ret) {
+		dev_err(palmas->dev, "Error in reading ldo8 control reg\n");
+		return;
+	}
+
+	reg |= PALMAS_LDO8_CTRL_LDO_TRACKING_EN;
+	ret = palmas_ldo_write(palmas, addr, reg);
+	if (ret < 0) {
+		dev_err(palmas->dev, "Error in enabling tracking mode\n");
+		return;
+	}
+	/*
+	 * When SMPS45 is set to off and LDO8 tracking is enabled, the LDO8
+	 * output is defined by the LDO8_VOLTAGE.VSEL register divided by two,
+	 * and can be set from 0.45 to 1.65 V.
+	 */
+	addr = palmas_regs_info[PALMAS_REG_LDO8].vsel_addr;
+	ret = palmas_ldo_read(palmas, addr, &reg);
+	if (ret) {
+		dev_err(palmas->dev, "Error in reading ldo8 voltage reg\n");
+		return;
+	}
+
+	reg = (reg << 1) & PALMAS_LDO8_VOLTAGE_VSEL_MASK;
+	ret = palmas_ldo_write(palmas, addr, reg);
+	if (ret < 0)
+		dev_err(palmas->dev, "Error in setting ldo8 voltage reg\n");
+
+	return;
+}
+
 static struct of_regulator_match palmas_matches[] = {
 	{ .name = "smps12", },
 	{ .name = "smps123", },
@@ -657,6 +697,11 @@ static void palmas_dt_to_pdata(struct device *dev,
 		if (ret)
 			pdata->reg_init[idx]->vsel =
 				PALMAS_SMPS12_VOLTAGE_RANGE;
+
+		if (idx == PALMAS_REG_LDO8)
+			pdata->enable_ldo8_tracking = of_property_read_bool(
+						palmas_matches[idx].of_node,
+						"ti,enable-ldo8-tracking");
 	}
 
 	pdata->ldo6_vibrator = of_property_read_bool(node, "ti,ldo6-vibrator");
@@ -836,6 +881,13 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 						palmas_regs_info[id].ctrl_addr);
 			pmic->desc[id].enable_mask =
 					PALMAS_LDO1_CTRL_MODE_ACTIVE;
+
+			/* Check if LDO8 is in tracking mode or not */
+			if (pdata && (id == PALMAS_REG_LDO8) &&
+					pdata->enable_ldo8_tracking) {
+				palmas_enable_ldo8_track(palmas);
+				pmic->desc[id].uV_step = 25000;
+			}
 		} else {
 			pmic->desc[id].n_voltages = 1;
 			pmic->desc[id].ops = &palmas_ops_extreg;
@@ -884,6 +936,7 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 		}
 	}
 
+
 	return 0;
 
 err_unregister_regulator:
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index fb04d07..12d8a62 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -187,6 +187,9 @@ struct palmas_pmic_platform_data {
 
 	/* use LDO6 for vibrator control */
 	int ldo6_vibrator;
+
+	/* Enable tracking mode of LDO8 */
+	bool enable_ldo8_tracking;
 };
 
 struct palmas_usb_platform_data {
-- 
1.7.1.1

