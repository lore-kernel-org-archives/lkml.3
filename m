Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3HMM1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:27:35 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:37646 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3HMM0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:26:14 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 4/5] PCI: mvebu: add support for reset on GPIO
Date: Tue, 13 Aug 2013 14:25:23 +0200
Message-Id: <1376396724-32048-5-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check for DT passed reset-gpios property and deasserts/
asserts reset pin on probe/remove with configurable delay. Corresponding
binding documentation is also updated.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- use reset API compatible bindings (Reported by Kumar Gala and Thierry
  Reding)
- add gpio properties to DT examples (Reported by Kumar Gala)
- only fail (return) on EPROBE_DEFER and skip port parsing otherwise
- use us delay instead of ms delay

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pci@vger.kernel.org
---
 .../devicetree/bindings/pci/mvebu-pci.txt          |    6 ++++
 drivers/pci/host/pci-mvebu.c                       |   33 +++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pci/mvebu-pci.txt b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
index 638673a..8bb3245 100644
--- a/Documentation/devicetree/bindings/pci/mvebu-pci.txt
+++ b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
@@ -76,6 +76,8 @@ and the following optional properties:
 - marvell,pcie-lane: the physical PCIe lane number, for ports having
   multiple lanes. If this property is not found, we assume that the
   value is 0.
+- reset-gpios: optional gpio to PERST#
+- reset-delay-us: delay in us to wait after reset de-assertion
 
 Example:
 
@@ -138,6 +140,10 @@ pcie-controller {
 		interrupt-map = <0 0 0 0 &mpic 58>;
 		marvell,pcie-port = <0>;
 		marvell,pcie-lane = <0>;
+		/* low-active PERST# reset on GPIO 25 */
+		reset-gpios = <&gpio0 25 1>;
+		/* wait 20ms for device settle after reset deassertion */
+		reset-delay-us = <20000>;
 		clocks = <&gateclk 5>;
 		status = "disabled";
 	};
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index bd7092a..a9ad4b3 100644
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
@@ -857,6 +863,7 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 	i = 0;
 	for_each_child_of_node(pdev->dev.of_node, child) {
 		struct mvebu_pcie_port *port = &pcie->ports[i];
+		enum of_gpio_flags flags;
 
 		if (!of_device_is_available(child))
 			continue;
@@ -897,6 +904,30 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 			continue;
 		}
 
+		port->reset_gpio = of_get_named_gpio_flags(child,
+						   "reset-gpios", 0, &flags);
+		if (gpio_is_valid(port->reset_gpio)) {
+			u32 reset_udelay = 20000;
+
+			port->reset_active_low = flags & OF_GPIO_ACTIVE_LOW;
+			port->reset_name = kasprintf(GFP_KERNEL,
+				     "pcie%d.%d-reset", port->port, port->lane);
+			of_property_read_u32(child, "reset-delay-us",
+					     &reset_udelay);
+
+			ret = devm_gpio_request_one(&pdev->dev,
+			    port->reset_gpio, GPIOF_DIR_OUT, port->reset_name);
+			if (ret) {
+				if (ret == -EPROBE_DEFER)
+					return ret;
+				continue;
+			}
+
+			gpio_set_value(port->reset_gpio,
+				       (port->reset_active_low) ? 1 : 0);
+			udelay(reset_udelay);
+		}
+
 		port->clk = of_clk_get_by_name(child, NULL);
 		if (IS_ERR(port->clk)) {
 			dev_err(&pdev->dev, "PCIe%d.%d: cannot get clock\n",
-- 
1.7.10.4

