Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbbAELuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:50:55 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50307 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbbAELuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:50:51 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-77-54aa7a98f38f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 2/5] regulator: Allow parsing custom properties when using
 simplified DT parsing
Date: Mon, 05 Jan 2015 12:48:42 +0100
Message-id: <1420458525-22576-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
References: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e/4Zd0ZVatCDA6uVrLYOGM9q8XUh0/Y
	LOYfOcdq8fqFoUX/49fMFmeb3rBbfLvSwWSx6fE1VovLu+awWcw4v4/Jgctj56y77B6bVnWy
	eWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6dglcGe/uXmMuWKBScWzJZZYGxvcyXYycHBIC
	JhKLmnazQNhiEhfurWfrYuTiEBJYyiixZvomJginj0niwrxd7CBVbALGEpuXLwGrEhH4wCix
	atIPVhCHWWAao8SFU9+ZQaqEBVIl5jxrYAKxWQRUJb4evQO2g1fAXWLGr+lQ++QkTh6bzApi
	cwp4SHQ9/QTWKwRUM21nM/MERt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUKC7ssO
	xsXHrA4xCnAwKvHwepxYGSLEmlhWXJl7iFGCg1lJhPdV+qoQId6UxMqq1KL8+KLSnNTiQ4xM
	HJxSDYzpE7d4Ff3RF12wQ9k7Yt479RztTU8MnrPGnYh19/JQ+vP50VG2ymiW2kr7qem10TuP
	z3jKnetkkmrkll7Alj5tj9KjlUw/mPZ63BZ3yOy0vJTaM1Hqa/5yu5DD7Jq6MrzvF/5lY5eY
	uOG99NqKy1J+qlya3kZ+IvcZd26wiJ0W3vBpnqdutRJLcUaioRZzUXEiADqjsxUYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When drivers use simplified DT parsing method (they provide
'regulator_desc.of_match') they still may want to parse custom
properties for some of the regulators. For example some of the
regulators support GPIO enable control.

Add a driver-supplied callback for such case. This way the regulator
core parses common bindings offloading a lot of code from drivers and
still custom properties may be used.

The callback, called for each parsed regulator, may modify the
'regulator_config' initially passed to regulator_register().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/core.c         |  2 +-
 drivers/regulator/internal.h     |  2 ++
 drivers/regulator/of_regulator.c | 11 +++++++++++
 include/linux/regulator/driver.h | 13 +++++++++++++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c13b557a560e..5fae8cabd254 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3635,7 +3635,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	init_data = regulator_of_get_init_data(dev, regulator_desc,
+	init_data = regulator_of_get_init_data(dev, regulator_desc, config,
 					       &rdev->dev.of_node);
 	if (!init_data) {
 		init_data = config->init_data;
diff --git a/drivers/regulator/internal.h b/drivers/regulator/internal.h
index 80ba2a35a04b..c74ac8734023 100644
--- a/drivers/regulator/internal.h
+++ b/drivers/regulator/internal.h
@@ -38,11 +38,13 @@ struct regulator {
 #ifdef CONFIG_OF
 struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
 			         const struct regulator_desc *desc,
+				 struct regulator_config *config,
 				 struct device_node **node);
 #else
 static inline struct regulator_init_data *
 regulator_of_get_init_data(struct device *dev,
 			   const struct regulator_desc *desc,
+			   struct regulator_config *config,
 			   struct device_node **node)
 {
 	return NULL;
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 91eaaf010524..24e812c48d93 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -270,6 +270,7 @@ EXPORT_SYMBOL_GPL(of_regulator_match);
 
 struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
 					    const struct regulator_desc *desc,
+					    struct regulator_config *config,
 					    struct device_node **node)
 {
 	struct device_node *search, *child;
@@ -307,6 +308,16 @@ struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
 			break;
 		}
 
+		if (desc->of_parse_cb) {
+			if (desc->of_parse_cb(child, desc, config)) {
+				dev_err(dev,
+					"driver callback failed to parse DT for regulator %s\n",
+					child->name);
+				init_data = NULL;
+				break;
+			}
+		}
+
 		of_node_get(child);
 		*node = child;
 		break;
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 5f1e9ca47417..d4ad5b5a02bb 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -21,6 +21,7 @@
 
 struct regmap;
 struct regulator_dev;
+struct regulator_config;
 struct regulator_init_data;
 struct regulator_enable_gpio;
 
@@ -205,6 +206,15 @@ enum regulator_type {
  * @supply_name: Identifying the regulator supply
  * @of_match: Name used to identify regulator in DT.
  * @regulators_node: Name of node containing regulator definitions in DT.
+ * @of_parse_cb: Optional callback called only if of_match is present.
+ *               Will be called for each regulator parsed from DT, during
+ *               init_data parsing.
+ *               The regulator_config passed as argument to the callback will
+ *               be a copy of config passed to regulator_register, valid only
+ *               for this particular call. Callback may freely change the
+ *               config but it cannot store it for later usage.
+ *               Callback should return 0 on success or negative ERRNO
+ *               indicating failure.
  * @id: Numerical identifier for the regulator.
  * @ops: Regulator operations table.
  * @irq: Interrupt number for the regulator.
@@ -251,6 +261,9 @@ struct regulator_desc {
 	const char *supply_name;
 	const char *of_match;
 	const char *regulators_node;
+	int (*of_parse_cb)(struct device_node *,
+			    const struct regulator_desc *,
+			    struct regulator_config *);
 	int id;
 	bool continuous_voltage_range;
 	unsigned n_voltages;
-- 
1.9.1

