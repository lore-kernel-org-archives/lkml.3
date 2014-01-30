Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaA3Oam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:30:42 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:54621 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbaA3O3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:29:51 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, florian.vaussard@epfl.ch
Subject: [PATCH 3/5] can: sja1000: of: use devm_* APIs
Date: Thu, 30 Jan 2014 15:29:26 +0100
Message-Id: <1391092168-21246-4-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391092168-21246-1-git-send-email-florian.vaussard@epfl.ch>
References: <1391092168-21246-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify probe and remove functions by converting most of the resources
to use devm_* APIs.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/net/can/sja1000/sja1000_of_platform.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_of_platform.c b/drivers/net/can/sja1000/sja1000_of_platform.c
index 2f29eb9..8ebb4af 100644
--- a/drivers/net/can/sja1000/sja1000_of_platform.c
+++ b/drivers/net/can/sja1000/sja1000_of_platform.c
@@ -69,18 +69,11 @@ static void sja1000_ofp_write_reg(const struct sja1000_priv *priv,
 static int sja1000_ofp_remove(struct platform_device *ofdev)
 {
 	struct net_device *dev = platform_get_drvdata(ofdev);
-	struct sja1000_priv *priv = netdev_priv(dev);
-	struct device_node *np = ofdev->dev.of_node;
-	struct resource res;
 
 	unregister_sja1000dev(dev);
 	free_sja1000dev(dev);
-	iounmap(priv->reg_base);
 	irq_dispose_mapping(dev->irq);
 
-	of_address_to_resource(np, 0, &res);
-	release_mem_region(res.start, resource_size(&res));
-
 	return 0;
 }
 
@@ -102,23 +95,22 @@ static int sja1000_ofp_probe(struct platform_device *ofdev)
 
 	res_size = resource_size(&res);
 
-	if (!request_mem_region(res.start, res_size, DRV_NAME)) {
+	if (!devm_request_mem_region(&ofdev->dev,
+				     res.start, res_size, DRV_NAME)) {
 		dev_err(&ofdev->dev, "couldn't request %pR\n", &res);
 		return -EBUSY;
 	}
 
-	base = ioremap_nocache(res.start, res_size);
+	base = devm_ioremap_nocache(&ofdev->dev, res.start, res_size);
 	if (!base) {
 		dev_err(&ofdev->dev, "couldn't ioremap %pR\n", &res);
-		err = -ENOMEM;
-		goto exit_release_mem;
+		return -ENOMEM;
 	}
 
 	irq = irq_of_parse_and_map(np, 0);
 	if (irq == 0) {
 		dev_err(&ofdev->dev, "no irq found\n");
-		err = -ENODEV;
-		goto exit_unmap_mem;
+		return -ENODEV;
 	}
 
 	dev = alloc_sja1000dev(0);
@@ -191,10 +183,6 @@ exit_free_sja1000:
 	free_sja1000dev(dev);
 exit_dispose_irq:
 	irq_dispose_mapping(irq);
-exit_unmap_mem:
-	iounmap(base);
-exit_release_mem:
-	release_mem_region(res.start, res_size);
 
 	return err;
 }
-- 
1.8.1.2

