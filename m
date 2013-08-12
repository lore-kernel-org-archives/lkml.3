Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3HLStp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:49:45 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:42865 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3HLSrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:47:04 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 4/9] PCI: mvebu: add support for reset on GPIO
Date: Mon, 12 Aug 2013 20:46:50 +0200
Message-Id: <1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check for DT passed reset-gpios property and deasserts/
asserts reset pin on probe/remove with configurable delay. Corresponding
binding documentation is also updated.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pci@vger.kernel.org
---
 .../devicetree/bindings/pci/mvebu-pci.txt          |    2 ++
 drivers/pci/host/pci-mvebu.c                       |   33 +++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pci/mvebu-pci.txt b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
index 638673a..f2fa261 100644
--- a/Documentation/devicetree/bindings/pci/mvebu-pci.txt
+++ b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
@@ -76,6 +76,8 @@ and the following optional properties:
 - marvell,pcie-lane: the physical PCIe lane number, for ports having
   multiple lanes. If this property is not found, we assume that the
   value is 0.
+- reset-gpios: optional gpio to PERST#
+- reset-delay-ms: delay in ms to wait after reset de-assertion
 
 Example:
 
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 2370b59..bdad4d4 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -9,14 +9,17 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
 #include <linux/module.h>
 #include <linux/mbus.h>
 #include <linux/msi.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/of_address.h>
-#include <linux/of_pci.h>
 #include <linux/of_irq.h>
+#include <linux/of_gpio.h>
+#include <linux/of_pci.h>
 #include <linux/of_platform.h>
 
 /*
@@ -126,6 +129,9 @@ struct mvebu_pcie_port {
 	unsigned int io_target;
 	unsigned int io_attr;
 	struct clk *clk;
+	int reset_gpio;
+	int reset_active_low;
+	char *reset_name;
 	struct mvebu_sw_pci_bridge bridge;
 	struct device_node *dn;
 	struct mvebu_pcie *pcie;
@@ -856,6 +862,7 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 
 	for_each_child_of_node(pdev->dev.of_node, child) {
 		struct mvebu_pcie_port *port = &pcie->ports[pcie->nports];
+		enum of_gpio_flags flags;
 
 		if (!of_device_is_available(child))
 			continue;
@@ -896,6 +903,25 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 			continue;
 		}
 
+		port->reset_gpio = of_get_named_gpio_flags(child,
+						   "reset-gpios", 0, &flags);
+		if (gpio_is_valid(port->reset_gpio)) {
+			u32 reset_mdelay = 20;
+			port->reset_active_low = flags & OF_GPIO_ACTIVE_LOW;
+			port->reset_name = kasprintf(GFP_KERNEL,
+				     "pcie%d.%d-reset", port->port, port->lane);
+			ret = devm_gpio_request_one(&pdev->dev,
+			    port->reset_gpio, GPIOF_DIR_OUT, port->reset_name);
+			if (ret)
+				return ret;
+			gpio_set_value(port->reset_gpio,
+				       (port->reset_active_low) ? 1 : 0);
+
+			of_property_read_u32(child, "reset-delay-ms",
+					     &reset_mdelay);
+			mdelay(reset_mdelay);
+		}
+
 		port->clk = of_clk_get_by_name(child, NULL);
 		if (IS_ERR(port->clk)) {
 			dev_err(&pdev->dev, "PCIe%d.%d: cannot get clock\n",
@@ -945,6 +971,11 @@ static int mvebu_pcie_remove(struct platform_device *pdev)
 	int i;
 
 	for (i = 0; i < pcie->nports; i++, port++) {
+		if (gpio_is_valid(port->reset_gpio)) {
+			gpio_set_value(port->reset_gpio,
+			       (port->reset_active_low) ? 0 : 1);
+			kfree(port->reset_name);
+		}
 		clk_disable_unprepare(port->clk);
 		kfree(port->name);
 	}
-- 
1.7.10.4

