Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbaJ3OAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:00:09 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:50723 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760214AbaJ3N7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:59:41 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 3/3] i2c: core: Map OF IRQ at probe time
Date: Thu, 30 Oct 2014 15:59:38 +0200
Message-Id: <1414677578-27412-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C clients instantiated from OF get their IRQ mapped at device
registration time. This leads to the IRQ being silently ignored if the
related irqchip hasn't been proved yet.

Fix this by moving IRQ mapping at probe time using of_get_irq(). The
function operates as irq_of_parse_and_map() but additionally returns
-EPROBE_DEFER if the irqchip isn't available, allowing us to defer I2C
client probing.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/i2c/i2c-core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 258765b29684..c6694f232240 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -631,6 +631,15 @@ static int i2c_device_probe(struct device *dev)
 	if (!client)
 		return 0;
 
+	if (!client->irq && dev->of_node) {
+		int irq = of_irq_get(dev->of_node, 0);
+
+		if (irq < 0)
+			return irq;
+
+		client->irq = irq;
+	}
+
 	driver = to_i2c_driver(dev->driver);
 	if (!driver->probe || !driver->id_table)
 		return -ENODEV;
@@ -1412,7 +1421,6 @@ static void of_i2c_register_devices(struct i2c_adapter *adap)
 			continue;
 		}
 
-		info.irq = irq_of_parse_and_map(node, 0);
 		info.of_node = of_node_get(node);
 		info.archdata = &dev_ad;
 
@@ -1426,7 +1434,6 @@ static void of_i2c_register_devices(struct i2c_adapter *adap)
 			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
 				node->full_name);
 			of_node_put(node);
-			irq_dispose_mapping(info.irq);
 			continue;
 		}
 	}
-- 
2.0.4

