Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbbAZKoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:44:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbbAZKob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:44:31 -0500
Date: Mon, 26 Jan 2015 02:44:13 -0800
From: tip-bot for Tony Lindgren <tipbot@zytor.com>
Message-ID: <tip-19f92b237b1700d30b788f00b16a627ffbfdf0e5@git.kernel.org>
Cc: tony@atomide.com, tglx@linutronix.de, balbi@ti.com, jason@lakedaemon.net,
        mingo@kernel.org, hpa@zytor.com, b.hutchman@gmail.com,
        linux-kernel@vger.kernel.org
Reply-To: balbi@ti.com, tglx@linutronix.de, tony@atomide.com, mingo@kernel.org,
        jason@lakedaemon.net, hpa@zytor.com, linux-kernel@vger.kernel.org,
        b.hutchman@gmail.com
In-Reply-To: <1421187806-6804-2-git-send-email-tony@atomide.com>
References: <1421187806-6804-2-git-send-email-tony@atomide.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: omap-intc:
  Fix support for dm814 and dm816
Git-Commit-ID: 19f92b237b1700d30b788f00b16a627ffbfdf0e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19f92b237b1700d30b788f00b16a627ffbfdf0e5
Gitweb:     http://git.kernel.org/tip/19f92b237b1700d30b788f00b16a627ffbfdf0e5
Author:     Tony Lindgren <tony@atomide.com>
AuthorDate: Tue, 13 Jan 2015 14:23:25 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 26 Jan 2015 11:38:23 +0100

irqchip: omap-intc: Fix support for dm814 and dm816

On dm81xx we have 128 interrupts like am33xx has. Let's add
compatible flags for dm814x and dm816x, and document the
existing binding.

As the dm81xx are booting in device tree only mode, we can now
also remove ti81xx_init_irq() legacy function.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Cc: Brian Hutchinson <b.hutchman@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Link: http://lkml.kernel.org/r/1421187806-6804-2-git-send-email-tony@atomide.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 .../interrupt-controller/ti,omap-intc-irq.txt      | 28 ++++++++++++++++++++++
 drivers/irqchip/irq-omap-intc.c                    | 14 ++++-------
 include/linux/irqchip/irq-omap-intc.h              |  1 -
 3 files changed, 33 insertions(+), 10 deletions(-)

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
index c03f140..b444d0e 100644
--- a/drivers/irqchip/irq-omap-intc.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -380,14 +380,6 @@ void __init omap3_init_irq(void)
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
@@ -399,7 +391,9 @@ static int __init intc_of_init(struct device_node *node,
 	if (WARN_ON(!node))
 		return -ENODEV;
 
-	if (of_device_is_compatible(node, "ti,am33xx-intc")) {
+	if (of_device_is_compatible(node, "ti,dm814-intc") ||
+	    of_device_is_compatible(node, "ti,dm816-intc") ||
+	    of_device_is_compatible(node, "ti,am33xx-intc")) {
 		omap_nr_irqs = 128;
 		omap_nr_pending = 4;
 	}
@@ -415,4 +409,6 @@ static int __init intc_of_init(struct device_node *node,
 
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
