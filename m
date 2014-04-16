Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161548AbaDPO6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:58:03 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.174]:13859 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161089AbaDPO6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:58:01 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-3.tower-39.messagelabs.com!1397660278!17611386!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 16 Apr 2014 16:57:59 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <linux-kernel@vger.kernel.org>
CC: Johannes Thumshirn <Johannes.Thumshirn@men.de>,
        Thomas Schnuerer <thomas.schnuerer@men.de>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH] mcb: Add support for shared PCI IRQs
Date: Wed, 16 Apr 2014 16:57:47 +0200
Message-ID: <1397660267-23198-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for shared PCI IRQs to mcb and mcb-pci.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/mcb/mcb-core.c | 20 +++++++++++++++-----
 drivers/mcb/mcb-pci.c  | 17 ++++++++++++++++-
 include/linux/mcb.h    |  6 +++++-
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/mcb/mcb-core.c b/drivers/mcb/mcb-core.c
index bbe1293..9018ab8 100644
--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -183,14 +183,14 @@ EXPORT_SYMBOL_GPL(mcb_device_register);
  *
  * Allocate a new @mcb_bus.
  */
-struct mcb_bus *mcb_alloc_bus(void)
+struct mcb_bus *mcb_alloc_bus(struct device *carrier)
 {
 	struct mcb_bus *bus;
 	int bus_nr;
 
 	bus = kzalloc(sizeof(struct mcb_bus), GFP_KERNEL);
 	if (!bus)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	bus_nr = ida_simple_get(&mcb_ida, 0, 0, GFP_KERNEL);
 	if (bus_nr < 0) {
@@ -200,7 +200,7 @@ struct mcb_bus *mcb_alloc_bus(void)
 
 	INIT_LIST_HEAD(&bus->children);
 	bus->bus_nr = bus_nr;
-
+	bus->carrier = carrier;
 	return bus;
 }
 EXPORT_SYMBOL_GPL(mcb_alloc_bus);
@@ -378,6 +378,13 @@ void mcb_release_mem(struct resource *mem)
 }
 EXPORT_SYMBOL_GPL(mcb_release_mem);
 
+static int __mcb_get_irq(struct mcb_device *dev)
+{
+	struct resource *irq = &dev->irq;
+
+	return irq->start;
+}
+
 /**
  * mcb_get_irq() - Get device's IRQ number
  * @dev: The @mcb_device the IRQ is for
@@ -386,9 +393,12 @@ EXPORT_SYMBOL_GPL(mcb_release_mem);
  */
 int mcb_get_irq(struct mcb_device *dev)
 {
-	struct resource *irq = &dev->irq;
+	struct mcb_bus *bus = dev->bus;
 
-	return irq->start;
+	if (bus->get_irq)
+		return bus->get_irq(dev);
+
+	return __mcb_get_irq(dev);
 }
 EXPORT_SYMBOL_GPL(mcb_get_irq);
 
diff --git a/drivers/mcb/mcb-pci.c b/drivers/mcb/mcb-pci.c
index 99c742c..b591819 100644
--- a/drivers/mcb/mcb-pci.c
+++ b/drivers/mcb/mcb-pci.c
@@ -20,6 +20,15 @@ struct priv {
 	void __iomem *base;
 };
 
+static int mcb_pci_get_irq(struct mcb_device *mdev)
+{
+	struct mcb_bus *mbus = mdev->bus;
+	struct device *dev = mbus->carrier;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return pdev->irq;
+}
+
 static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct priv *priv;
@@ -67,7 +76,13 @@ static int mcb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, priv);
 
-	priv->bus = mcb_alloc_bus();
+	priv->bus = mcb_alloc_bus(&pdev->dev);
+	if (IS_ERR(priv->bus)) {
+		ret = PTR_ERR(priv->bus);
+		goto err_drvdata;
+	}
+
+	priv->bus->get_irq = mcb_pci_get_irq;
 
 	ret = chameleon_parse_cells(priv->bus, mapbase, priv->base);
 	if (ret < 0)
diff --git a/include/linux/mcb.h b/include/linux/mcb.h
index 2db284d..ed06e15 100644
--- a/include/linux/mcb.h
+++ b/include/linux/mcb.h
@@ -16,6 +16,7 @@
 #include <linux/irqreturn.h>
 
 struct mcb_driver;
+struct mcb_device;
 
 /**
  * struct mcb_bus - MEN Chameleon Bus
@@ -23,11 +24,14 @@ struct mcb_driver;
  * @dev: pointer to carrier device
  * @children: the child busses
  * @bus_nr: mcb bus number
+ * @get_irq: callback to get IRQ number
  */
 struct mcb_bus {
 	struct list_head children;
 	struct device dev;
+	struct device *carrier;
 	int bus_nr;
+	int (*get_irq)(struct mcb_device *dev);
 };
 #define to_mcb_bus(b) container_of((b), struct mcb_bus, dev)
 
@@ -105,7 +109,7 @@ extern void mcb_unregister_driver(struct mcb_driver *driver);
 	module_driver(__mcb_driver, mcb_register_driver, mcb_unregister_driver);
 extern void mcb_bus_add_devices(const struct mcb_bus *bus);
 extern int mcb_device_register(struct mcb_bus *bus, struct mcb_device *dev);
-extern struct mcb_bus *mcb_alloc_bus(void);
+extern struct mcb_bus *mcb_alloc_bus(struct device *carrier);
 extern struct mcb_bus *mcb_bus_get(struct mcb_bus *bus);
 extern void mcb_bus_put(struct mcb_bus *bus);
 extern struct mcb_device *mcb_alloc_dev(struct mcb_bus *bus);
-- 
1.9.2

