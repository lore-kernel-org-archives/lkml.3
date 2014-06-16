Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaFPL2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:28:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47848 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434AbaFPL0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:26:45 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V3 13/16] irqchip: crossbar: introduce ti,max-crossbar-sources to identify valid crossbar mapping
Date: Mon, 16 Jun 2014 16:53:13 +0530
Message-ID: <1402917796-31574-14-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

Currently we attempt to map any crossbar value to an IRQ, however,
this is not correct from hardware perspective. There is a max crossbar
event number upto which hardware supports. So describe the same in
device tree using 'ti,max-crossbar-sources' property and use it to
validate requests.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 .../devicetree/bindings/arm/omap/crossbar.txt      |    2 ++
 drivers/irqchip/irq-crossbar.c                     |   21 ++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
index e54d1fb..41aef44 100644
--- a/Documentation/devicetree/bindings/arm/omap/crossbar.txt
+++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
@@ -10,6 +10,7 @@ Required properties:
 - compatible : Should be "ti,irq-crossbar"
 - reg: Base address and the size of the crossbar registers.
 - ti,max-irqs: Total number of irqs available at the interrupt controller.
+- ti,max-crossbar-sources: Maximum number of crossbar sources that can be routed.
 - ti,reg-size: Size of a individual register in bytes. Every individual
 	    register is assumed to be of same size. Valid sizes are 1, 2, 4.
 - ti,irqs-reserved: List of the reserved irq lines that are not muxed using
@@ -29,6 +30,7 @@ Examples:
 			compatible = "ti,irq-crossbar";
 			reg = <0x4a002a48 0x130>;
 			ti,max-irqs = <160>;
+			ti,max-crossbar-sources = <400>;
 			ti,reg-size = <2>;
 			ti,irqs-reserved = <0 1 2 3 5 6 131 132 139 140>;
 		};
diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index df16ef8..c46e14b 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -26,6 +26,7 @@
  * struct crossbar_device - crossbar device description
  * @int_max: maximum number of supported interrupts
  * @safe_map: safe default value to initialize the crossbar
+ * @max_crossbar_sources: Maximum number of crossbar sources
  * @irq_map: array of interrupts to crossbar number mapping
  * @crossbar_base: crossbar base address
  * @register_offsets: offsets for each irq number
@@ -34,6 +35,7 @@
 struct crossbar_device {
 	uint int_max;
 	uint safe_map;
+	uint max_crossbar_sources;
 	uint *irq_map;
 	void __iomem *crossbar_base;
 	int *register_offsets;
@@ -117,12 +119,19 @@ static int crossbar_domain_xlate(struct irq_domain *d,
 				 unsigned int *out_type)
 {
 	int ret;
+	int req_num = intspec[1];
 
-	ret = get_prev_map_irq(intspec[1]);
+	if (req_num >= cb->max_crossbar_sources) {
+		pr_err("%s: requested crossbar number %d > max %d\n",
+		       __func__, req_num, cb->max_crossbar_sources);
+		return -EINVAL;
+	}
+
+	ret = get_prev_map_irq(req_num);
 	if (ret >= 0)
 		goto found;
 
-	ret = allocate_free_irq(intspec[1]);
+	ret = allocate_free_irq(req_num);
 
 	if (ret < 0)
 		return ret;
@@ -153,6 +162,14 @@ static int __init crossbar_of_init(struct device_node *node)
 	if (!cb->crossbar_base)
 		goto err_cb;
 
+	of_property_read_u32(node, "ti,max-crossbar-sources",
+			     &cb->max_crossbar_sources);
+	if (!cb->max_crossbar_sources) {
+		pr_err("missing 'ti,max-crossbar-sources' property\n");
+		ret = -EINVAL;
+		goto err_base;
+	}
+
 	of_property_read_u32(node, "ti,max-irqs", &max);
 	if (!max) {
 		pr_err("missing 'ti,max-irqs' property\n");
-- 
1.7.9.5

