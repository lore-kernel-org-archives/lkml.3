Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaG1VSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:18:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33669 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbaG1VRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:43 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 26/35] arm: omap: irq: remove nr_irqs argument
Date: Mon, 28 Jul 2014 16:16:14 -0500
Message-ID: <1406582183-696-27-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we can set our global omap_nr_irqs early on
and drop the extra argument to omap_init_irq().

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index a405b96..44d9cf4 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -207,8 +207,7 @@ omap_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
 				IRQ_NOREQUEST | IRQ_NOPROBE, 0);
 }
 
-static void __init omap_init_irq(u32 base, int nr_irqs,
-				 struct device_node *node)
+static void __init omap_init_irq(u32 base, struct device_node *node)
 {
 	int j, irq_base;
 
@@ -216,15 +215,13 @@ static void __init omap_init_irq(u32 base, int nr_irqs,
 	if (WARN_ON(!omap_irq_base))
 		return;
 
-	omap_nr_irqs = nr_irqs;
-
-	irq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
+	irq_base = irq_alloc_descs(-1, 0, omap_nr_irqs, 0);
 	if (irq_base < 0) {
 		pr_warn("Couldn't allocate IRQ numbers\n");
 		irq_base = 0;
 	}
 
-	domain = irq_domain_add_legacy(node, nr_irqs, irq_base, 0,
+	domain = irq_domain_add_legacy(node, omap_nr_irqs, irq_base, 0,
 			&irq_domain_simple_ops, NULL);
 
 	omap_irq_soft_reset();
@@ -278,19 +275,22 @@ out:
 
 void __init omap2_init_irq(void)
 {
-	omap_init_irq(OMAP24XX_IC_BASE, 96, NULL);
+	omap_nr_irqs = 96;
+	omap_init_irq(OMAP24XX_IC_BASE, NULL);
 	set_handle_irq(omap_intc_handle_irq);
 }
 
 void __init omap3_init_irq(void)
 {
-	omap_init_irq(OMAP34XX_IC_BASE, 96, NULL);
+	omap_nr_irqs = 96;
+	omap_init_irq(OMAP34XX_IC_BASE, NULL);
 	set_handle_irq(omap_intc_handle_irq);
 }
 
 void __init ti81xx_init_irq(void)
 {
-	omap_init_irq(OMAP34XX_IC_BASE, 128, NULL);
+	omap_nr_irqs = 96;
+	omap_init_irq(OMAP34XX_IC_BASE, NULL);
 	set_handle_irq(omap_intc_handle_irq);
 }
 
@@ -298,7 +298,8 @@ static int __init intc_of_init(struct device_node *node,
 			     struct device_node *parent)
 {
 	struct resource res;
-	u32 nr_irq = 96;
+
+	omap_nr_irqs = 96;
 
 	if (WARN_ON(!node))
 		return -ENODEV;
@@ -309,9 +310,9 @@ static int __init intc_of_init(struct device_node *node,
 	}
 
 	if (of_device_is_compatible(node, "ti,am33xx-intc"))
-		nr_irq = 128;
+		omap_nr_irqs = 128;
 
-	omap_init_irq(res.start, nr_irq, of_node_get(node));
+	omap_init_irq(res.start, of_node_get(node));
 
 	set_handle_irq(omap_intc_handle_irq);
 
-- 
2.0.1.563.g66f467c

