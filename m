Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaK1EgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 23:36:23 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43112 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaK1EdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 23:33:14 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V4 06/16] irqchip: bcm7120-l2: Split STB-specific logic into its own function
Date: Thu, 27 Nov 2014 20:32:12 -0800
Message-Id: <1417149142-3756-7-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
References: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCM7xxx instances of this block (listed in the register manual as
simply "IRQ0") all have the following items in common:

 - brcm,int-map-mask: for routing different bits in the L2 to different
   parent IRQs

 - brcm,int-fwd-mask: for hardwiring certain IRQs to bypass the L2 and
   use dedicated L1 lines

 - one enable/status pair (32 bits only)

Much of the driver code can be shared with BCM3380-style controllers, but
in order to do this cleanly, let's split out the BCM7xxx-specific logic
first.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  12 +-
 drivers/irqchip/irq-bcm7120-l2.c                   | 121 ++++++++++++---------
 2 files changed, 70 insertions(+), 63 deletions(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
index bae1f2187226..44a9bb15dd56 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
+++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
@@ -13,8 +13,7 @@ Such an interrupt controller has the following hardware design:
   or if they will output an interrupt signal at this 2nd level interrupt
   controller, in particular for UARTs
 
-- typically has one 32-bit enable word and one 32-bit status word, but on
-  some hardware may have more than one enable/status pair
+- has one 32-bit enable word and one 32-bit status word
 
 - no atomic set/clear operations
 
@@ -53,9 +52,7 @@ The typical hardware layout for this controller is represented below:
 Required properties:
 
 - compatible: should be "brcm,bcm7120-l2-intc"
-- reg: specifies the base physical address and size of the registers;
-  multiple pairs may be specified, with the first pair handling IRQ offsets
-  0..31 and the second pair handling 32..63
+- reg: specifies the base physical address and size of the registers
 - interrupt-controller: identifies the node as an interrupt controller
 - #interrupt-cells: specifies the number of cells needed to encode an interrupt
   source, should be 1.
@@ -66,10 +63,7 @@ Required properties:
 - brcm,int-map-mask: 32-bits bit mask describing how many and which interrupts
   are wired to this 2nd level interrupt controller, and how they match their
   respective interrupt parents. Should match exactly the number of interrupts
-  specified in the 'interrupts' property, multiplied by the number of
-  enable/status register pairs implemented by this controller.  For
-  multiple parent IRQs with multiple enable/status words, this looks like:
-  <irq0_w0 irq0_w1 irq1_w0 irq1_w1 ...>
+  specified in the 'interrupts' property.
 
 Optional properties:
 
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index da5b5745003c..36014b27844a 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -47,6 +47,8 @@ struct bcm7120_l2_intc_data {
 	bool can_wake;
 	u32 irq_fwd_mask[MAX_WORDS];
 	u32 irq_map_mask[MAX_WORDS];
+	int num_parent_irqs;
+	const __be32 *map_mask_prop;
 };
 
 static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
@@ -104,7 +106,7 @@ static void bcm7120_l2_intc_resume(struct irq_data *d)
 
 static int bcm7120_l2_intc_init_one(struct device_node *dn,
 					struct bcm7120_l2_intc_data *data,
-					int irq, const __be32 *map_mask)
+					int irq)
 {
 	int parent_irq;
 	unsigned int idx;
@@ -120,7 +122,8 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
 	 */
 	for (idx = 0; idx < data->n_words; idx++)
 		data->irq_map_mask[idx] |=
-			be32_to_cpup(map_mask + irq * data->n_words + idx);
+			be32_to_cpup(data->map_mask_prop +
+				     irq * data->n_words + idx);
 
 	irq_set_handler_data(parent_irq, data);
 	irq_set_chained_handler(parent_irq, bcm7120_l2_intc_irq_handle);
@@ -128,74 +131,76 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
 	return 0;
 }
 
-int __init bcm7120_l2_intc_of_init(struct device_node *dn,
-					struct device_node *parent)
+static int __init bcm7120_l2_intc_iomap_7120(struct device_node *dn,
+					     struct bcm7120_l2_intc_data *data)
+{
+	int ret;
+
+	data->map_base[0] = of_iomap(dn, 0);
+	if (!data->map_base[0]) {
+		pr_err("unable to map registers\n");
+		return -ENOMEM;
+	}
+
+	data->pair_base[0] = data->map_base[0];
+	data->en_offset[0] = IRQEN;
+	data->stat_offset[0] = IRQSTAT;
+	data->n_words = 1;
+
+	ret = of_property_read_u32_array(dn, "brcm,int-fwd-mask",
+					 data->irq_fwd_mask, data->n_words);
+	if (ret != 0 && ret != -EINVAL) {
+		/* property exists but has the wrong number of words */
+		pr_err("invalid brcm,int-fwd-mask property\n");
+		return -EINVAL;
+	}
+
+	data->map_mask_prop = of_get_property(dn, "brcm,int-map-mask", &ret);
+	if (!data->map_mask_prop ||
+	    (ret != (sizeof(__be32) * data->num_parent_irqs * data->n_words))) {
+		pr_err("invalid brcm,int-map-mask property\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int __init bcm7120_l2_intc_probe(struct device_node *dn,
+				 struct device_node *parent,
+				 int (*iomap_regs_fn)(struct device_node *,
+					struct bcm7120_l2_intc_data *),
+				 const char *intc_name)
 {
 	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
 	struct bcm7120_l2_intc_data *data;
 	struct irq_chip_generic *gc;
 	struct irq_chip_type *ct;
-	const __be32 *map_mask;
-	int num_parent_irqs;
-	int ret = 0, len;
+	int ret = 0;
 	unsigned int idx, irq, flags;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	for (idx = 0; idx < MAX_WORDS; idx++) {
-		data->map_base[idx] = of_iomap(dn, idx);
-		if (!data->map_base[idx])
-			break;
-
-		data->pair_base[idx] = data->map_base[idx];
-		data->en_offset[idx] = IRQEN;
-		data->stat_offset[idx] = IRQSTAT;
-
-		data->n_words = idx + 1;
-	}
-	if (!data->n_words) {
-		pr_err("failed to remap intc L2 registers\n");
-		ret = -ENOMEM;
-		goto out_unmap;
-	}
-
-	/* Enable all interrupts specified in the interrupt forward mask;
-	 * disable all others.  If the property doesn't exist (-EINVAL),
-	 * assume all zeroes.
-	 */
-	ret = of_property_read_u32_array(dn, "brcm,int-fwd-mask",
-					 data->irq_fwd_mask, data->n_words);
-	if (ret == 0 || ret == -EINVAL) {
-		for (idx = 0; idx < data->n_words; idx++)
-			__raw_writel(data->irq_fwd_mask[idx],
-				     data->pair_base[idx] +
-				     data->en_offset[idx]);
-	} else {
-		/* property exists but has the wrong number of words */
-		pr_err("invalid int-fwd-mask property\n");
-		ret = -EINVAL;
-		goto out_unmap;
-	}
-
-	num_parent_irqs = of_irq_count(dn);
-	if (num_parent_irqs <= 0) {
+	data->num_parent_irqs = of_irq_count(dn);
+	if (data->num_parent_irqs <= 0) {
 		pr_err("invalid number of parent interrupts\n");
 		ret = -ENOMEM;
 		goto out_unmap;
 	}
 
-	map_mask = of_get_property(dn, "brcm,int-map-mask", &len);
-	if (!map_mask ||
-	    (len != (sizeof(*map_mask) * num_parent_irqs * data->n_words))) {
-		pr_err("invalid brcm,int-map-mask property\n");
-		ret = -EINVAL;
+	ret = iomap_regs_fn(dn, data);
+	if (ret < 0)
 		goto out_unmap;
+
+	for (idx = 0; idx < data->n_words; idx++) {
+		__raw_writel(data->irq_fwd_mask[idx],
+			     data->pair_base[idx] +
+			     data->en_offset[idx]);
 	}
 
-	for (irq = 0; irq < num_parent_irqs; irq++) {
-		ret = bcm7120_l2_intc_init_one(dn, data, irq, map_mask);
+	for (irq = 0; irq < data->num_parent_irqs; irq++) {
+		ret = bcm7120_l2_intc_init_one(dn, data, irq);
 		if (ret)
 			goto out_unmap;
 	}
@@ -251,8 +256,8 @@ int __init bcm7120_l2_intc_of_init(struct device_node *dn,
 		}
 	}
 
-	pr_info("registered BCM7120 L2 intc (mem: 0x%p, parent IRQ(s): %d)\n",
-			data->map_base[0], num_parent_irqs);
+	pr_info("registered %s intc (mem: 0x%p, parent IRQ(s): %d)\n",
+			intc_name, data->map_base[0], data->num_parent_irqs);
 
 	return 0;
 
@@ -266,5 +271,13 @@ out_unmap:
 	kfree(data);
 	return ret;
 }
+
+int __init bcm7120_l2_intc_probe_7120(struct device_node *dn,
+				      struct device_node *parent)
+{
+	return bcm7120_l2_intc_probe(dn, parent, bcm7120_l2_intc_iomap_7120,
+				     "BCM7120 L2");
+}
+
 IRQCHIP_DECLARE(bcm7120_l2_intc, "brcm,bcm7120-l2-intc",
-		bcm7120_l2_intc_of_init);
+		bcm7120_l2_intc_probe_7120);
-- 
2.1.0

