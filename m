Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaKXWeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:34:21 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64570 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaKXWeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:34:15 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>, linux-i2c@vger.kernel.org
Subject: [PATCH v2 11/14] i2c/of: Factor out Devicetree registration code
Date: Mon, 24 Nov 2014 22:33:39 +0000
Message-Id: <1416868422-22103-12-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

Dynamically inserting i2c client device nodes requires the use
of a single device registration method. Factor out the loop body of
of_i2c_register_devices() so that it can be called for individual
device_nodes instead of for all the children of a node.

Note: The diff of this commit looks far more complicated than it
actually is due the indentation being changed for a large block of code.
When viewed using the diff -w flag to ignore whitespace changes it can
be seen that the change is actually quite simple.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
[grant.likely: Made new function static and removed changes to header]
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux-i2c@vger.kernel.org
---
 drivers/i2c/i2c-core.c | 97 +++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 45 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index f43b4e11647a..15ba6185dba5 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -49,6 +49,7 @@
 #include <linux/acpi.h>
 #include <linux/jump_label.h>
 #include <asm/uaccess.h>
+#include <linux/err.h>
 
 #include "i2c-core.h"
 
@@ -1368,63 +1369,69 @@ static void i2c_scan_static_board_info(struct i2c_adapter *adapter)
 /* OF support code */
 
 #if IS_ENABLED(CONFIG_OF)
-static void of_i2c_register_devices(struct i2c_adapter *adap)
+static struct i2c_client *of_i2c_register_device(struct i2c_adapter *adap,
+						 struct device_node *node)
 {
-	void *result;
-	struct device_node *node;
+	struct i2c_client *result;
+	struct i2c_board_info info = {};
+	struct dev_archdata dev_ad = {};
+	const __be32 *addr;
+	int len;
 
-	/* Only register child devices if the adapter has a node pointer set */
-	if (!adap->dev.of_node)
-		return;
+	dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
 
-	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
+	if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
+		dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
+			node->full_name);
+		return ERR_PTR(-EINVAL);
+	}
 
-	for_each_available_child_of_node(adap->dev.of_node, node) {
-		struct i2c_board_info info = {};
-		struct dev_archdata dev_ad = {};
-		const __be32 *addr;
-		int len;
+	addr = of_get_property(node, "reg", &len);
+	if (!addr || (len < sizeof(int))) {
+		dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
+			node->full_name);
+		return ERR_PTR(-EINVAL);
+	}
 
-		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
+	info.addr = be32_to_cpup(addr);
+	if (info.addr > (1 << 10) - 1) {
+		dev_err(&adap->dev, "of_i2c: invalid addr=%x on %s\n",
+			info.addr, node->full_name);
+		return ERR_PTR(-EINVAL);
+	}
 
-		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
-			dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
-				node->full_name);
-			continue;
-		}
+	info.irq = irq_of_parse_and_map(node, 0);
+	info.of_node = of_node_get(node);
+	info.archdata = &dev_ad;
 
-		addr = of_get_property(node, "reg", &len);
-		if (!addr || (len < sizeof(int))) {
-			dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
-				node->full_name);
-			continue;
-		}
+	if (of_get_property(node, "wakeup-source", NULL))
+		info.flags |= I2C_CLIENT_WAKE;
 
-		info.addr = be32_to_cpup(addr);
-		if (info.addr > (1 << 10) - 1) {
-			dev_err(&adap->dev, "of_i2c: invalid addr=%x on %s\n",
-				info.addr, node->full_name);
-			continue;
-		}
+	request_module("%s%s", I2C_MODULE_PREFIX, info.type);
 
-		info.irq = irq_of_parse_and_map(node, 0);
-		info.of_node = of_node_get(node);
-		info.archdata = &dev_ad;
+	result = i2c_new_device(adap, &info);
+	if (result == NULL) {
+		dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
+			node->full_name);
+		of_node_put(node);
+		irq_dispose_mapping(info.irq);
+		return ERR_PTR(-EINVAL);
+	}
+	return result;
+}
 
-		if (of_get_property(node, "wakeup-source", NULL))
-			info.flags |= I2C_CLIENT_WAKE;
+static void of_i2c_register_devices(struct i2c_adapter *adap)
+{
+	struct device_node *node;
 
-		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
+	/* Only register child devices if the adapter has a node pointer set */
+	if (!adap->dev.of_node)
+		return;
 
-		result = i2c_new_device(adap, &info);
-		if (result == NULL) {
-			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
-				node->full_name);
-			of_node_put(node);
-			irq_dispose_mapping(info.irq);
-			continue;
-		}
-	}
+	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
+
+	for_each_available_child_of_node(adap->dev.of_node, node)
+		of_i2c_register_device(adap, node);
 }
 
 static int of_dev_node_match(struct device *dev, void *data)
-- 
1.9.1

