Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbbAMW1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:27:25 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10908 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751609AbbAMW1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:27:23 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19d/VbvsjwYQ6gKtWMLTj1W
From: Tony Lindgren <tony@atomide.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Brian Hutchinson <b.hutchman@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 1/2] irqchip: omap-intc: Fix support for dm814 and dm816
Date: Tue, 13 Jan 2015 14:23:25 -0800
Message-Id: <1421187806-6804-2-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421187806-6804-1-git-send-email-tony@atomide.com>
References: <1421187806-6804-1-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On dm81xx we have 128 interrupts like am33xx has. Let's add
compatible flags for dm814x and dm816x, and document the
existing binding.

As the dm81xx are booting in device tree only mode, we can now
also remove ti81xx_init_irq() legacy function.

Cc: Brian Hutchinson <b.hutchman@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 .../interrupt-controller/ti,omap-intc-irq.txt      | 28 ++++++++++++++++++++++
 drivers/irqchip/irq-omap-intc.c                    | 14 ++++-------
 include/linux/irqchip/irq-omap-intc.h              |  1 -
 3 files changed, 33 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/ti,omap-intc-irq.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/ti,omap-intc-irq.txt b/Documentation/devicetree/bindings/interrupt-controller/ti,omap-intc-irq.txt
new file mode 100644
index 0000000..38ce5d03
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/ti,omap-intc-irq.txt
@@ -0,0 +1,28 @@
+Omap2/3 intc controller
+
+On TI omap2 and 3 the intc interrupt controller can provide
+96 or 128 IRQ signals to the ARM host depending on the SoC.
+
+Required Properties:
+- compatible: should be one of
+			"ti,omap2-intc"
+			"ti,omap3-intc"
+			"ti,dm814-intc"
+			"ti,dm816-intc"
+			"ti,am33xx-intc"
+
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode interrupt
+		     source, should be 1 for intc
+- interrupts: interrupt reference to primary interrupt controller
+
+Please refer to interrupts.txt in this directory for details of the common
+Interrupt Controllers bindings used by client devices.
+
+Example:
+	intc: interrupt-controller@48200000 {
+		compatible = "ti,omap3-intc";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0x48200000 0x1000>;
+	};
diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-intc.c
index 28718d3..b75a44a 100644
--- a/drivers/irqchip/irq-omap-intc.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -364,14 +364,6 @@ void __init omap3_init_irq(void)
 	set_handle_irq(omap_intc_handle_irq);
 }
 
-void __init ti81xx_init_irq(void)
-{
-	omap_nr_irqs = 96;
-	omap_nr_pending = 4;
-	omap_init_irq(OMAP34XX_IC_BASE, NULL);
-	set_handle_irq(omap_intc_handle_irq);
-}
-
 static int __init intc_of_init(struct device_node *node,
 			     struct device_node *parent)
 {
@@ -383,7 +375,9 @@ static int __init intc_of_init(struct device_node *node,
 	if (WARN_ON(!node))
 		return -ENODEV;
 
-	if (of_device_is_compatible(node, "ti,am33xx-intc")) {
+	if (of_device_is_compatible(node, "ti,dm814-intc") ||
+	    of_device_is_compatible(node, "ti,dm816-intc") ||
+	    of_device_is_compatible(node, "ti,am33xx-intc")) {
 		omap_nr_irqs = 128;
 		omap_nr_pending = 4;
 	}
@@ -399,4 +393,6 @@ static int __init intc_of_init(struct device_node *node,
 
 IRQCHIP_DECLARE(omap2_intc, "ti,omap2-intc", intc_of_init);
 IRQCHIP_DECLARE(omap3_intc, "ti,omap3-intc", intc_of_init);
+IRQCHIP_DECLARE(dm814x_intc, "ti,dm814-intc", intc_of_init);
+IRQCHIP_DECLARE(dm816x_intc, "ti,dm816-intc", intc_of_init);
 IRQCHIP_DECLARE(am33xx_intc, "ti,am33xx-intc", intc_of_init);
diff --git a/include/linux/irqchip/irq-omap-intc.h b/include/linux/irqchip/irq-omap-intc.h
index e06b370..bda426a 100644
--- a/include/linux/irqchip/irq-omap-intc.h
+++ b/include/linux/irqchip/irq-omap-intc.h
@@ -20,7 +20,6 @@
 
 void omap2_init_irq(void);
 void omap3_init_irq(void);
-void ti81xx_init_irq(void);
 
 int omap_irq_pending(void);
 void omap_intc_save_context(void);
-- 
2.1.4

