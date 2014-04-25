Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaDYMdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:33:50 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:59888 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbaDYMds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:33:48 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Rob Herring <robherring2@gmail.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: [RFC PATCH] mfd: pm8x41: Naive function devices registration
Date: Fri, 25 Apr 2014 15:32:51 +0300
Message-Id: <1398429171-8566-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Currently functions that exist in both the controller at the
same address offset can not be specified with the same names.

Adding Unique Slave ID device address to prefix function
device names fixes this.

Function devices are SPMI devices, so register them on
SPMI bus.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/mfd/pm8x41.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/pm8x41.c b/drivers/mfd/pm8x41.c
index c85e0d6..29bc1e7 100644
--- a/drivers/mfd/pm8x41.c
+++ b/drivers/mfd/pm8x41.c
@@ -11,9 +11,10 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/spmi.h>
+#include <linux/of.h>
 #include <linux/regmap.h>
-#include <linux/of_platform.h>
+#include <linux/slab.h>
+#include <linux/spmi.h>

 static const struct regmap_config pm8x41_regmap_config = {
 	.reg_bits	= 16,
@@ -23,7 +24,7 @@ static const struct regmap_config pm8x41_regmap_config = {

 static int pm8x41_remove_child(struct device *dev, void *unused)
 {
-	platform_device_unregister(to_platform_device(dev));
+	device_unregister(dev);
 	return 0;
 }

@@ -32,9 +33,40 @@ static void pm8x41_remove(struct spmi_device *sdev)
 	device_for_each_child(&sdev->dev, NULL, pm8x41_remove_child);
 }

+static struct spmi_device *pm8x41_function_alloc(struct spmi_controller *ctrl,
+					       struct spmi_device *parent,
+					       struct device_node *node)
+{
+	struct spmi_device *function;
+	u32 reg;
+	int err;
+
+	err = of_property_read_u32(node, "reg", &reg);
+	if (err) {
+		dev_err(&parent->dev,
+			"node %s err (%d) does not have 'reg' property\n",
+			node->full_name, err);
+		return NULL;
+	}
+
+	function = spmi_device_alloc(ctrl);
+	if (!function)
+		return NULL;
+
+	function->dev.parent = &parent->dev;
+	function->dev.of_node = node;
+	function->usid = parent->usid;
+
+	dev_set_name(&function->dev, "%02x-%04x", function->usid, reg);
+
+	return function;
+}
+
 static int pm8x41_probe(struct spmi_device *sdev)
 {
+	struct device_node *node;
 	struct regmap *regmap;
+	int err = 0;

 	regmap = devm_regmap_init_spmi_ext(sdev, &pm8x41_regmap_config);
 	if (IS_ERR(regmap)) {
@@ -42,7 +74,24 @@ static int pm8x41_probe(struct spmi_device *sdev)
 		return PTR_ERR(regmap);
 	}

-	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
+	for_each_available_child_of_node(sdev->dev.of_node, node) {
+		struct spmi_device *function;
+
+		dev_dbg(&sdev->dev, "adding child %s\n", node->full_name);
+
+		function = pm8x41_function_alloc(sdev->ctrl, sdev, node);
+		if (!function)
+			continue;
+
+		err = device_add(&function->dev);
+		if (err < 0) {
+			dev_err(&function->dev, "Can't add %s, status %d\n",
+				dev_name(&function->dev), err);
+			break;
+		}
+	}
+
+	return err;
 }

 static const struct of_device_id pm8x41_id_table[] = {
@@ -61,3 +110,7 @@ static struct spmi_driver pm8x41_driver = {
 	},
 };
 module_spmi_driver(pm8x41_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Qualcomm SPMI PMIC core driver");
+MODULE_ALIAS("spmi:pm8x41");
--
1.8.3.2

