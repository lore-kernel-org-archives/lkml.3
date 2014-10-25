Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaJYWNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 18:13:33 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:46038 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJYWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 18:13:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: I2C OF IRQ parsing issue due to probe ordering
Date: Sun, 26 Oct 2014 01:13:31 +0300
Message-ID: <2287003.09eTeKUr1V@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I recently ran into an issue with the OF IRQ parsing code in the I2C core
(of_i2c_register_devices in drivers/i2c/i2c-core.c).

My DT contains the following nodes.

        gpio1: gpio@e6051000 {
                ...
                #interrupt-cells = <2>;
                interrupt-controller;
                clocks = <&mstp9_clks R8A7790_CLK_GPIO1>;
        };

        iic2: i2c@e6520000 {
                #address-cells = <1>;
                #size-cells = <0>;
                ...
                hdmi@39 {
                        compatible = "adi,adv7511w";
                        reg = <0x39>;
                        interrupt-parent = <&gpio1>;
                        interrupts = <15 IRQ_TYPE_EDGE_FALLING>;
                        ...
                };
        };

        mstp9_clks: mstp9_clks@e6150994 {
                ...
        };

The i2c@e6520000 node is probed before the gpio@e6051000 node. The
of_i2c_register_devices() function tries to register all children, including
hdmi@39. It tries to parse and map the I2C client IRQ by calling
irq_of_parse_and_map(), which returns 0 as the interrupt controller isn't
probed yet. The adv7511 driver later probes the hdmi@39 device and gets
client->irq set to 0.

We can't control the probe order. One option to solve the problem would be to
defer probing of the I2C client until the interrupt control is available. The
following patch is a naive implementation. Before turning it into a real
upstream candidate (changing the return type of irq_create_of_mapping without
checking the callers is a no-go) I'd like to get feedback on the approach.

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 2f90ac6a7f79..73ff1e7d2382 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -631,6 +631,14 @@ static int i2c_device_probe(struct device *dev)
 	if (!client)
 		return 0;
 
+	if (!client->irq && dev->of_node) {
+		int irq = irq_of_parse_and_map(dev->of_node, 0);
+		if (irq < 0)
+			return irq;
+
+		client->irq = irq;
+	}
+
 	driver = to_i2c_driver(dev->driver);
 	if (!driver->probe || !driver->id_table)
 		return -ENODEV;
@@ -1409,7 +1417,6 @@ static void of_i2c_register_devices(struct i2c_adapter *adap)
 			continue;
 		}
 
-		info.irq = irq_of_parse_and_map(node, 0);
 		info.of_node = of_node_get(node);
 		info.archdata = &dev_ad;
 
@@ -1423,7 +1430,6 @@ static void of_i2c_register_devices(struct i2c_adapter *adap)
 			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
 				node->full_name);
 			of_node_put(node);
-			irq_dispose_mapping(info.irq);
 			continue;
 		}
 	}
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index bfec136a6d1e..81a14d89a5bd 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -34,7 +34,7 @@ static inline int of_irq_parse_oldworld(struct device_node *device, int index,
 extern int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq);
 extern int of_irq_parse_one(struct device_node *device, int index,
 			  struct of_phandle_args *out_irq);
-extern unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data);
+extern int irq_create_of_mapping(struct of_phandle_args *irq_data);
 extern int of_irq_to_resource(struct device_node *dev, int index,
 			      struct resource *r);
 extern int of_irq_to_resource_table(struct device_node *dev,
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 6534ff6ce02e..386fd09f4c85 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -466,7 +466,7 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
 }
 EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
 
-unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
+int irq_create_of_mapping(struct of_phandle_args *irq_data)
 {
 	struct irq_domain *domain;
 	irq_hw_number_t hwirq;
@@ -477,7 +477,7 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 	if (!domain) {
 		pr_warn("no irq domain found for %s !\n",
 			of_node_full_name(irq_data->np));
-		return 0;
+		return -EPROBE_DEFER;
 	}
 
 	/* If domain has no translation, then we assume interrupt line */

-- 
Regards,

Laurent Pinchart

