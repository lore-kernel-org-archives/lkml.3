Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3EUSNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:13:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46901 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3EUSNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:13:43 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 21 May 2013 13:13:20 -0500
Message-Id: <1369160001-4019-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130521181230.GF1627@sirena.org.uk>
 <1369160001-4019-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 6/7] mfd: arizona: Support use of external DCVDD
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the device is used with an external DCVDD supply instead of the
internal LDO1 then an extra step is required when suspending and resuming
the device.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c       |   43 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/arizona/core.h |    2 ++
 2 files changed, 45 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index d8d30c0..437f199 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -22,6 +22,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
+#include <linux/regulator/machine.h>
 #include <linux/slab.h>
 
 #include <linux/mfd/arizona/core.h>
@@ -347,6 +348,17 @@ static int arizona_runtime_resume(struct device *dev)
 
 	switch (arizona->type) {
 	case WM5102:
+		if (arizona->external_dcvdd) {
+			ret = regmap_update_bits(arizona->regmap,
+						 ARIZONA_ISOLATION_CONTROL,
+						 ARIZONA_ISOLATE_DCVDD1, 0);
+			if (ret != 0) {
+				dev_err(arizona->dev,
+					"Failed to connect DCVDD: %d\n", ret);
+				goto err;
+			}
+		}
+
 		ret = wm5102_patch(arizona);
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to apply patch: %d\n",
@@ -368,6 +380,16 @@ static int arizona_runtime_resume(struct device *dev)
 			goto err;
 		}
 
+		if (arizona->external_dcvdd) {
+			ret = regmap_update_bits(arizona->regmap,
+						 ARIZONA_ISOLATION_CONTROL,
+						 ARIZONA_ISOLATE_DCVDD1, 0);
+			if (ret != 0) {
+				dev_err(arizona->dev,
+					"Failed to connect DCVDD: %d\n", ret);
+				goto err;
+			}
+		}
 		break;
 	}
 
@@ -400,9 +422,22 @@ err:
 static int arizona_runtime_suspend(struct device *dev)
 {
 	struct arizona *arizona = dev_get_drvdata(dev);
+	int ret;
 
 	dev_dbg(arizona->dev, "Entering AoD mode\n");
 
+	if (arizona->external_dcvdd) {
+		ret = regmap_update_bits(arizona->regmap,
+					 ARIZONA_ISOLATION_CONTROL,
+					 ARIZONA_ISOLATE_DCVDD1,
+					 ARIZONA_ISOLATE_DCVDD1);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to isolate DCVDD: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
 	regulator_disable(arizona->dcvdd);
 	regcache_cache_only(arizona->regmap, true);
 	regcache_mark_dirty(arizona->regmap);
@@ -771,6 +806,14 @@ int arizona_dev_init(struct arizona *arizona)
 			     arizona->pdata.gpio_defaults[i]);
 	}
 
+	/*
+	 * LDO1 can only be used to supply DCVDD so if it has no
+	 * consumers then DCVDD is supplied externally.
+	 */
+	if (arizona->pdata.ldo1 &&
+	    arizona->pdata.ldo1->num_consumer_supplies == 0)
+		arizona->external_dcvdd = true;
+
 	pm_runtime_set_autosuspend_delay(arizona->dev, 100);
 	pm_runtime_use_autosuspend(arizona->dev);
 	pm_runtime_enable(arizona->dev);
diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index cc28136..f797bb9 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -95,6 +95,8 @@ struct arizona {
 
 	struct arizona_pdata pdata;
 
+	unsigned int external_dcvdd:1;
+
 	int irq;
 	struct irq_domain *virq;
 	struct regmap_irq_chip_data *aod_irq_chip;
-- 
1.7.10.4

