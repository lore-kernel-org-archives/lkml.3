Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaK1Efy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 23:35:54 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:64305 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaK1EdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 23:33:16 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V4 07/16] irqchip: bcm7120-l2: Add support for BCM3380-style controllers
Date: Thu, 27 Nov 2014 20:32:13 -0800
Message-Id: <1417149142-3756-8-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
References: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These controllers support multiple enable/status pairs (64+ IRQs),
can put the enable/status words at different offsets, and do not
support multiple parent IRQs.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 .../interrupt-controller/brcm,bcm3380-l2-intc.txt  | 41 ++++++++++++++++
 drivers/irqchip/irq-bcm7120-l2.c                   | 57 ++++++++++++++++++++--
 2 files changed, 93 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm3380-l2-intc.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm3380-l2-intc.txt b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm3380-l2-intc.txt
new file mode 100644
index 000000000000..8f48aad50868
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/brcm,bcm3380-l2-intc.txt
@@ -0,0 +1,41 @@
+Broadcom BCM3380-style Level 1 / Level 2 interrupt controller
+
+This interrupt controller shows up in various forms on many BCM338x/BCM63xx
+chipsets.  It has the following properties:
+
+- outputs a single interrupt signal to its interrupt controller parent
+
+- contains one or more enable/status word pairs, which often appear at
+  different offsets in different blocks
+
+- no atomic set/clear operations
+
+Required properties:
+
+- compatible: should be "brcm,bcm3380-l2-intc"
+- reg: specifies one or more enable/status pairs, in the following format:
+  <enable_reg 0x4 status_reg 0x4>...
+- interrupt-controller: identifies the node as an interrupt controller
+- #interrupt-cells: specifies the number of cells needed to encode an interrupt
+  source, should be 1.
+- interrupt-parent: specifies the phandle to the parent interrupt controller
+  this one is cascaded from
+- interrupts: specifies the interrupt line in the interrupt-parent controller
+  node, valid values depend on the type of parent interrupt controller
+
+Optional properties:
+
+- brcm,irq-can-wake: if present, this means the L2 controller can be used as a
+  wakeup source for system suspend/resume.
+
+Example:
+
+irq0_intc: interrupt-controller@10000020 {
+	compatible = "brcm,bcm3380-l2-intc";
+	reg = <0x10000024 0x4 0x1000002c 0x4>,
+	      <0x10000020 0x4 0x10000028 0x4>;
+	interrupt-controller;
+	#interrupt-cells = <1>;
+	interrupt-parent = <&cpu_intc>;
+	interrupts = <2>;
+};
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index 36014b27844a..561670cfb6d8 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kconfig.h>
+#include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
@@ -34,7 +35,7 @@
 #define IRQSTAT		0x04
 
 #define MAX_WORDS	4
-#define MAX_MAPPINGS	MAX_WORDS
+#define MAX_MAPPINGS	(MAX_WORDS * 2)
 #define IRQS_PER_WORD	32
 
 struct bcm7120_l2_intc_data {
@@ -120,10 +121,15 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
 	/* For multiple parent IRQs with multiple words, this looks like:
 	 * <irq0_w0 irq0_w1 irq1_w0 irq1_w1 ...>
 	 */
-	for (idx = 0; idx < data->n_words; idx++)
-		data->irq_map_mask[idx] |=
-			be32_to_cpup(data->map_mask_prop +
-				     irq * data->n_words + idx);
+	for (idx = 0; idx < data->n_words; idx++) {
+		if (data->map_mask_prop) {
+			data->irq_map_mask[idx] |=
+				be32_to_cpup(data->map_mask_prop +
+					     irq * data->n_words + idx);
+		} else {
+			data->irq_map_mask[idx] = 0xffffffff;
+		}
+	}
 
 	irq_set_handler_data(parent_irq, data);
 	irq_set_chained_handler(parent_irq, bcm7120_l2_intc_irq_handle);
@@ -165,6 +171,37 @@ static int __init bcm7120_l2_intc_iomap_7120(struct device_node *dn,
 	return 0;
 }
 
+static int __init bcm7120_l2_intc_iomap_3380(struct device_node *dn,
+					     struct bcm7120_l2_intc_data *data)
+{
+	unsigned int gc_idx;
+
+	for (gc_idx = 0; gc_idx < MAX_WORDS; gc_idx++) {
+		unsigned int map_idx = gc_idx * 2;
+		void __iomem *en = of_iomap(dn, map_idx + 0);
+		void __iomem *stat = of_iomap(dn, map_idx + 1);
+		void __iomem *base = min(en, stat);
+
+		data->map_base[map_idx + 0] = en;
+		data->map_base[map_idx + 1] = stat;
+
+		if (!base)
+			break;
+
+		data->pair_base[gc_idx] = base;
+		data->en_offset[gc_idx] = en - base;
+		data->stat_offset[gc_idx] = stat - base;
+	}
+
+	if (!gc_idx) {
+		pr_err("unable to map registers\n");
+		return -EINVAL;
+	}
+
+	data->n_words = gc_idx;
+	return 0;
+}
+
 int __init bcm7120_l2_intc_probe(struct device_node *dn,
 				 struct device_node *parent,
 				 int (*iomap_regs_fn)(struct device_node *,
@@ -279,5 +316,15 @@ int __init bcm7120_l2_intc_probe_7120(struct device_node *dn,
 				     "BCM7120 L2");
 }
 
+int __init bcm7120_l2_intc_probe_3380(struct device_node *dn,
+				      struct device_node *parent)
+{
+	return bcm7120_l2_intc_probe(dn, parent, bcm7120_l2_intc_iomap_3380,
+				     "BCM3380 L2");
+}
+
 IRQCHIP_DECLARE(bcm7120_l2_intc, "brcm,bcm7120-l2-intc",
 		bcm7120_l2_intc_probe_7120);
+
+IRQCHIP_DECLARE(bcm3380_l2_intc, "brcm,bcm3380-l2-intc",
+		bcm7120_l2_intc_probe_3380);
-- 
2.1.0

