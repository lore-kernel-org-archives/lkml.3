Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3AUSZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:25:58 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:35325 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3AUSZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:25:57 -0500
From: Matt Sealey <matt@genesi-usa.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org,
        Matt Sealey <matt@genesi-usa.com>, Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] mc13892: sanity check num_regulators parsed vs. registered
Date: Mon, 21 Jan 2013 12:25:45 -0600
Message-Id: <1358792745-1737-1-git-send-email-matt@genesi-usa.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imagine a situation where a device tree has a few regulators in an
appropriate node:

regulators {
	sw1 {
		..
	};

	vvideo {
		..
	};

	:

	vfake {
		..
	};

	vtypo {
		..
	};
};

In the above example, the node name "vfake" is an attempt to match a
regulator name inside the driver which just so happens to not exist. The
node name "vtypo" represents an accidental typographical error in a
regulator name which may have been introduced to a device tree.

In these cases, the number of regulators the mc13892 driver thinks it has
does not match the number of regulators it parsed and registered. Since
it will go over this array based on this number, it will actually
re-register regulator "0" (which happens to be SW1) over and over
again until it reaches the number, resulting in messages on the kernel
log such as these:

SW1: at 1100 mV
VVIDEO: at 2775mV
:
SW1: at 1100 mV
SW1: at 1100 mV

.. up to that number of "mismatched" regulators. Nobody using DT can/will
consume these regulators, so it should not be possible for it to cause any
real regulator problems or driver breakages, but it is an easy thing to
miss in a kernel log and is an immediate indication of a problem with the
device tree authoring.

This patch effectively sanity checks the number of counted children of
the regulators node vs. the number that actually matched driver names,
and sets the appropriate num_regulators value. It also gives a little
warning for device tree authors that they MAY have screwed something up,
such that this patch does not hide the device tree authoring problem.

Signed-off-by: Matt Sealey <matt@genesi-usa.com>
Tested-by: Steev Klimaszewski <steev@genesi-usa.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/mc13892-regulator.c      |   39 ++++++++++++++++++++++++++--
 drivers/regulator/mc13xxx-regulator-core.c |   10 +++++--
 drivers/regulator/mc13xxx.h                |    4 +--
 3 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index e4f2197..7c86040 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -535,15 +535,18 @@ static int mc13892_regulator_probe(struct platform_device *pdev)
 	struct mc13xxx_regulator_init_data *mc13xxx_data;
 	struct regulator_config config = { };
 	int i, ret;
-	int num_regulators = 0;
+	int num_regulators = 0, num_parsed;
 	u32 val;
 
 	num_regulators = mc13xxx_get_num_regulators_dt(pdev);
+
 	if (num_regulators <= 0 && pdata)
 		num_regulators = pdata->num_regulators;
 	if (num_regulators <= 0)
 		return -EINVAL;
 
+	num_parsed = num_regulators;
+
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv) +
 		num_regulators * sizeof(priv->regulators[0]),
 		GFP_KERNEL);
@@ -586,7 +589,39 @@ static int mc13892_regulator_probe(struct platform_device *pdev)
 		= mc13892_vcam_get_mode;
 
 	mc13xxx_data = mc13xxx_parse_regulators_dt(pdev, mc13892_regulators,
-					ARRAY_SIZE(mc13892_regulators));
+					ARRAY_SIZE(mc13892_regulators),
+					&num_parsed);
+
+	/*
+	 * Perform a little sanity check on the regulator tree - if we found
+	 * a number of regulators from mc13xxx_get_num_regulators_dt and
+	 * then parsed a smaller number in mc13xxx_parse_regulators_dt then
+	 * there is a regulator defined in the regulators node which has
+	 * not matched any usable regulator in the driver. In this case,
+	 * there is one missing and what will happen is the first regulator
+	 * will get registered again.
+	 *
+	 * Fix this by basically making our number of registerable regulators
+	 * equal to the number of regulators we parsed. We are allocating
+	 * too much memory for priv, but this is unavoidable at this point.
+	 *
+	 * As an example of how this can happen, try making a typo in your
+	 * regulators node (vviohi {} instead of viohi {}) so that the name
+	 * does not match..
+	 *
+	 * The check will basically pass for platform data (non-DT) because
+	 * mc13xxx_parse_regulators_dt for !CONFIG_OF will not touch num_parsed.
+	 *
+	 */
+	if (num_parsed != num_regulators) {
+		dev_warn(&pdev->dev,
+		"parsed %d != regulators %d - check your device tree!\n",
+			num_parsed, num_regulators);
+
+		num_regulators = num_parsed;
+		priv->num_regulators = num_regulators;
+	}
+
 	for (i = 0; i < num_regulators; i++) {
 		struct regulator_init_data *init_data;
 		struct regulator_desc *desc;
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 4ed89c6..2ecf1d8 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -181,12 +181,14 @@ EXPORT_SYMBOL_GPL(mc13xxx_get_num_regulators_dt);
 
 struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 	struct platform_device *pdev, struct mc13xxx_regulator *regulators,
-	int num_regulators)
+	int num_regulators, int *num_parsed)
 {
 	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
 	struct mc13xxx_regulator_init_data *data, *p;
 	struct device_node *parent, *child;
-	int i;
+	int i, parsed = 0;
+
+	*num_parsed = 0;
 
 	of_node_get(pdev->dev.parent->of_node);
 	parent = of_find_node_by_name(pdev->dev.parent->of_node, "regulators");
@@ -203,16 +205,20 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 		for (i = 0; i < num_regulators; i++) {
 			if (!of_node_cmp(child->name,
 					 regulators[i].desc.name)) {
+
 				p->id = i;
 				p->init_data = of_get_regulator_init_data(
 							&pdev->dev, child);
 				p->node = child;
 				p++;
+
+				parsed++;
 				break;
 			}
 		}
 	}
 
+	*num_parsed = parsed;
 	return data;
 }
 EXPORT_SYMBOL_GPL(mc13xxx_parse_regulators_dt);
diff --git a/drivers/regulator/mc13xxx.h b/drivers/regulator/mc13xxx.h
index 06c8903..007f833 100644
--- a/drivers/regulator/mc13xxx.h
+++ b/drivers/regulator/mc13xxx.h
@@ -39,7 +39,7 @@ extern int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev,
 extern int mc13xxx_get_num_regulators_dt(struct platform_device *pdev);
 extern struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 	struct platform_device *pdev, struct mc13xxx_regulator *regulators,
-	int num_regulators);
+	int num_regulators, int *num_parsed);
 #else
 static inline int mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 {
@@ -48,7 +48,7 @@ static inline int mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 
 static inline struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 	struct platform_device *pdev, struct mc13xxx_regulator *regulators,
-	int num_regulators)
+	int num_regulators, int *num_parsed)
 {
 	return NULL;
 }
-- 
1.7.10.4

