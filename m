Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaG3N4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:56:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5950 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaG3N4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:56:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 30 Jul 2014 06:48:01 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] regulator: userspace-consumer: add DT support
Date: Wed, 30 Jul 2014 19:23:59 +0530
Message-ID: <1406728440-17837-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT support of the regulator driver userspace-consumer.
The supply names for this driver is provided through DT properties
so that proper regulator handle can be acquired.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/userspace-consumer.c | 48 ++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/regulator/userspace-consumer.c b/drivers/regulator/userspace-consumer.c
index 765acc1..91d50a2 100644
--- a/drivers/regulator/userspace-consumer.c
+++ b/drivers/regulator/userspace-consumer.c
@@ -23,6 +23,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/userspace-consumer.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 struct userspace_consumer_data {
 	const char *name;
@@ -105,6 +106,41 @@ static const struct attribute_group attr_group = {
 	.attrs	= attributes,
 };
 
+static struct regulator_userspace_consumer_data *get_pdata_from_dt_node(
+		struct platform_device *pdev)
+{
+	struct regulator_userspace_consumer_data *pdata;
+	struct device_node *np = pdev->dev.of_node;
+	struct property *prop;
+	const char *supply;
+	int num_supplies;
+	int count = 0;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	pdata->name = of_get_property(np, "regulator-name", NULL);
+	pdata->init_on = of_property_read_bool(np, "regulator-boot-on");
+
+	num_supplies = of_property_count_strings(np, "regulator-supplies");
+	if (num_supplies < 0) {
+		dev_err(&pdev->dev,
+			"could not parse property regulator-supplies\n");
+		return ERR_PTR(-EINVAL);
+	}
+	pdata->num_supplies = num_supplies;
+	pdata->supplies = devm_kzalloc(&pdev->dev, num_supplies *
+				sizeof(*pdata->supplies), GFP_KERNEL);
+	if (!pdata->supplies)
+		return ERR_PTR(-ENOMEM);
+
+	of_property_for_each_string(np, "regulator-supplies", prop, supply)
+		pdata->supplies[count++].supply = supply;
+
+	return pdata;
+}
+
 static int regulator_userspace_consumer_probe(struct platform_device *pdev)
 {
 	struct regulator_userspace_consumer_data *pdata;
@@ -112,6 +148,11 @@ static int regulator_userspace_consumer_probe(struct platform_device *pdev)
 	int ret;
 
 	pdata = dev_get_platdata(&pdev->dev);
+	if (!pdata && pdev->dev.of_node) {
+		pdata = get_pdata_from_dt_node(pdev);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+	}
 	if (!pdata)
 		return -EINVAL;
 
@@ -171,11 +212,18 @@ static int regulator_userspace_consumer_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id regulator_userspace_consumer_of_match[] = {
+	{ .compatible = "reg-userspace-consumer", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, regulator_userspace_consumer_of_match);
+
 static struct platform_driver regulator_userspace_consumer_driver = {
 	.probe		= regulator_userspace_consumer_probe,
 	.remove		= regulator_userspace_consumer_remove,
 	.driver		= {
 		.name		= "reg-userspace-consumer",
+		.of_match_table = regulator_userspace_consumer_of_match,
 	},
 };
 
-- 
1.8.1.5

