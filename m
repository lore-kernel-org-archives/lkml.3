Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895Ab3HHMAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 08:00:52 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12460 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794Ab3HHMAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 08:00:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 08 Aug 2013 05:00:48 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <sameo@linux.intel.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>, <rob@landley.net>,
        <lee.jones@linaro.org>, <broonie@linaro.org>, <nm@ti.com>,
        <j-keerthy@ti.com>, <grant.likely@linaro.org>, <ian@slimlogic.co.uk>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bill Huang <bilhuang@nvidia.com>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: [PATCH RESEND v2 1/1] mfd: palmas: Add power off control
Date: Thu, 8 Aug 2013 04:45:05 -0700
Message-ID: <1375962305-7438-1-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook up "pm_power_off" to palmas power off routine if there is DT
property "ti,system-power-controller" defined, so platform which is
powered by this regulator can be powered off properly.

Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +++
 drivers/mfd/palmas.c                               |   33 ++++++++++++++++++--
 include/linux/mfd/palmas.h                         |    1 +
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
index 30b0581..4adca2a 100644
--- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
+++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
@@ -36,6 +36,9 @@ Optional nodes:
 	       ti,smps-range - OTP has the wrong range set for the hardware so override
 	       0 - low range, 1 - high range.
 
+- ti,system-power-controller: Telling whether or not this pmic is controlling
+			      the system power.
+
 Example:
 
 #include <dt-bindings/interrupt-controller/irq.h>
@@ -48,6 +51,8 @@ pmic {
 
 	ti,ldo6-vibrator;
 
+	ti,system-power-controller;
+
 	regulators {
 		smps12_reg : smps12 {
 			regulator-name = "smps12";
diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index e4d1c70..220a34d 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -229,6 +229,32 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
 					PALMAS_POWER_CTRL_ENABLE2_MASK;
 	if (i2c->irq)
 		palmas_set_pdata_irq_flag(i2c, pdata);
+
+	pdata->pm_off = of_property_read_bool(node,
+			"ti,system-power-controller");
+}
+
+static struct palmas *palmas_dev;
+static void palmas_power_off(void)
+{
+	unsigned int addr;
+	int ret, slave;
+
+	if (!palmas_dev)
+		return;
+
+	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PMU_CONTROL_BASE);
+	addr = PALMAS_BASE_TO_REG(PALMAS_PMU_CONTROL_BASE, PALMAS_DEV_CTRL);
+
+	ret = regmap_update_bits(
+			palmas_dev->regmap[slave],
+			addr,
+			PALMAS_DEV_CTRL_DEV_ON,
+			0);
+
+	if (ret)
+		pr_err("%s: Unable to write to DEV_CTRL_DEV_ON: %d\n",
+				__func__, ret);
 }
 
 static unsigned int palmas_features = PALMAS_PMIC_FEATURE_SMPS10_BOOST;
@@ -423,10 +449,13 @@ no_irq:
 	 */
 	if (node) {
 		ret = of_platform_populate(node, NULL, NULL, &i2c->dev);
-		if (ret < 0)
+		if (ret < 0) {
 			goto err_irq;
-		else
+		} else if (pdata->pm_off && !pm_power_off) {
+			palmas_dev = palmas;
+			pm_power_off = palmas_power_off;
 			return ret;
+		}
 	}
 
 	return ret;
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 1a8dd7a..061cce0 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -258,6 +258,7 @@ struct palmas_platform_data {
 	 */
 	int mux_from_pdata;
 	u8 pad1, pad2;
+	bool pm_off;
 
 	struct palmas_pmic_platform_data *pmic_pdata;
 	struct palmas_gpadc_platform_data *gpadc_pdata;
-- 
1.7.9.5

