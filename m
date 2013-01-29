Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3A2P1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:27:15 -0500
Received: from zmc.proxad.net ([212.27.53.206]:49585 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab3A2P1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:27:09 -0500
From: Florian Fainelli <florian@openwrt.org>
To: davem@davemloft.net
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Florian Fainelli <florian@openwrt.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: [PATCH 4/5] net: mvmdio: allow Device Tree and platform device to coexist
Date: Tue, 29 Jan 2013 16:24:07 +0100
Message-Id: <1359473048-26551-5-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359473048-26551-1-git-send-email-florian@openwrt.org>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the Marvell MDIO driver to be registered by using
both Device Tree and platform device methods. The driver voluntarily
does not use devm_ioremap() to share the same error path for Device Tree
and non-Device Tree cases.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/net/ethernet/marvell/mvmdio.c |   46 +++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index cada794..10c593c 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -190,6 +190,7 @@ static irqreturn_t orion_mdio_err_irq(int irq, void *dev_id)
 static int orion_mdio_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct resource *r = NULL;
 	struct mii_bus *bus;
 	struct orion_mdio_dev *dev;
 	int i, ret;
@@ -219,18 +220,31 @@ static int orion_mdio_probe(struct platform_device *pdev)
 		bus->irq[i] = PHY_POLL;
 
 	dev = bus->priv;
-	dev->regs = of_iomap(pdev->dev.of_node, 0);
-	if (!dev->regs) {
-		dev_err(&pdev->dev, "No SMI register address given in DT\n");
-		kfree(bus->irq);
-		mdiobus_free(bus);
-		return -ENODEV;
-	}
-
 	dev->err_interrupt = NO_IRQ;
 	init_waitqueue_head(&dev->smi_busy_wait);
 
-	dev->err_interrupt = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	if (pdev->dev.of_node) {
+		dev->regs = of_iomap(pdev->dev.of_node, 0);
+		if (!dev->regs) {
+			dev_err(&pdev->dev, "No SMI register address given in DT\n");
+			ret = -ENODEV;
+			goto out_free;
+		}
+
+		dev->err_interrupt = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	} else {
+		r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+		dev->regs = ioremap(r->start, resource_size(r));
+		if (!dev->regs) {
+			dev_err(&pdev->dev, "No SMI register address given\n");
+			ret = -ENODEV;
+			goto out_free;
+		}
+
+		dev->err_interrupt = platform_get_irq(pdev, 0);
+	}
+
 	if (dev->err_interrupt != NO_IRQ) {
 		ret = devm_request_irq(&pdev->dev, dev->err_interrupt,
 					orion_mdio_err_irq,
@@ -242,18 +256,24 @@ static int orion_mdio_probe(struct platform_device *pdev)
 
 	mutex_init(&dev->lock);
 
-	ret = of_mdiobus_register(bus, np);
+	if (np)
+		ret = of_mdiobus_register(bus, np);
+	else
+		ret = mdiobus_register(bus);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
 		iounmap(dev->regs);
-		kfree(bus->irq);
-		mdiobus_free(bus);
-		return ret;
+		goto out_free;
 	}
 
 	platform_set_drvdata(pdev, bus);
 
 	return 0;
+
+out_free:
+	kfree(bus->irq);
+	mdiobus_free(bus);
+	return ret;
 }
 
 static int orion_mdio_remove(struct platform_device *pdev)
-- 
1.7.10.4

