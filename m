Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab3CNKxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:53:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4061 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab3CNKxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:53:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Mar 2013 03:47:02 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <sameo@linux.intel.com>
CC: <gg@slimlogic.co.uk>, <ldewangan@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>, <ian@slimlogic.co.uk>,
        <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH 1/1] mfd: palmas: Add power off control
Date: Thu, 14 Mar 2013 03:58:00 -0700
Message-ID: <1363258680-12600-1-git-send-email-bilhuang@nvidia.com>
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

Based on work by:
Mallikarjun Kasoju <mkasoju@nvidia.com>

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 drivers/mfd/palmas.c       |   25 +++++++++++++++++++++++--
 include/linux/mfd/palmas.h |    1 +
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index bbdbc50..ee8180d 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -283,6 +283,22 @@ static void palmas_dt_to_pdata(struct device_node *node,
 		pdata->power_ctrl = PALMAS_POWER_CTRL_NSLEEP_MASK |
 					PALMAS_POWER_CTRL_ENABLE1_MASK |
 					PALMAS_POWER_CTRL_ENABLE2_MASK;
+
+	pdata->pm_off = of_property_read_bool(node,
+			"ti,system-power-controller");
+}
+
+static struct palmas *palmas_dev;
+static void palmas_power_off(void)
+{
+	unsigned int addr;
+
+	if (!palmas_dev)
+		return;
+
+	addr = PALMAS_BASE_TO_REG(PALMAS_PMU_CONTROL_BASE, PALMAS_DEV_CTRL);
+
+	regmap_update_bits(palmas_dev->regmap[0], addr, 1, 0);
 }
 
 static int palmas_i2c_probe(struct i2c_client *i2c,
@@ -435,10 +451,15 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	 */
 	if (node) {
 		ret = of_platform_populate(node, NULL, NULL, &i2c->dev);
-		if (ret < 0)
+		if (ret < 0) {
 			goto err_irq;
-		else
+		} else {
+			if (pdata->pm_off && !pm_power_off) {
+				palmas_dev = palmas;
+				pm_power_off = palmas_power_off;
+			}
 			return ret;
+		}
 	}
 
 	children = kmemdup(palmas_children, sizeof(palmas_children),
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index a4d13d7..a447e54 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -232,6 +232,7 @@ struct palmas_platform_data {
 	 */
 	int mux_from_pdata;
 	u8 pad1, pad2;
+	bool pm_off;
 
 	struct palmas_pmic_platform_data *pmic_pdata;
 	struct palmas_gpadc_platform_data *gpadc_pdata;
-- 
1.7.9.5

