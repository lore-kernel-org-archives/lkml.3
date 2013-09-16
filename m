Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab3IPIdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:33:37 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:34008 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab3IPIdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:33:33 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 8/9] of/i2c: Resolve interrupt references at probe time
Date: Mon, 16 Sep 2013 10:32:05 +0200
Message-Id: <1379320326-13241-9-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379320326-13241-1-git-send-email-treding@nvidia.com>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of resolving interrupt references at device creation time, delay
resolution until probe time. At device creation time, there is nothing
that can be done if an interrupt parent isn't ready yet, and the device
will end up with an invalid interrupt number (0).

If the interrupt reference is resolved at probe time, the device's probe
can be deferred, so that it's interrupt resolution can be retried after
more devices (possibly including its interrupt parent) have been probed.

However, individual drivers shouldn't be required to do that themselves,
over and over again, so this commit implements this functionality within
the I2C core.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/i2c/i2c-core.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 29d3f04..163a1e8 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -236,6 +236,21 @@ int i2c_recover_bus(struct i2c_adapter *adap)
 	return adap->bus_recovery_info->recover_bus(adap);
 }
 
+static int of_i2c_probe(struct i2c_client *client)
+{
+	struct device_node *np = client->dev.of_node;
+	int ret;
+
+	/* skip if the device node specifies no interrupts */
+	if (of_get_property(np, "interrupts", NULL)) {
+		ret = of_irq_get(client->dev.of_node, 0, &client->irq);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int i2c_device_probe(struct device *dev)
 {
 	struct i2c_client	*client = i2c_verify_client(dev);
@@ -254,6 +269,12 @@ static int i2c_device_probe(struct device *dev)
 					client->flags & I2C_CLIENT_WAKE);
 	dev_dbg(dev, "probe\n");
 
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
+		status = of_i2c_probe(client);
+		if (status)
+			return status;
+	}
+
 	status = driver->probe(client, i2c_match_id(driver->id_table, client));
 	if (status) {
 		client->driver = NULL;
@@ -1002,7 +1023,6 @@ static void of_i2c_register_devices(struct i2c_adapter *adap)
 			continue;
 		}
 
-		info.irq = irq_of_parse_and_map(node, 0);
 		info.of_node = of_node_get(node);
 		info.archdata = &dev_ad;
 
@@ -1016,7 +1036,6 @@ static void of_i2c_register_devices(struct i2c_adapter *adap)
 			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
 				node->full_name);
 			of_node_put(node);
-			irq_dispose_mapping(info.irq);
 			continue;
 		}
 	}
-- 
1.8.4

