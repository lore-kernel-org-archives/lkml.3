Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbaFZHN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:13:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48373 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbaFZHNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:13:24 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V4 03/16] irqchip: crossbar: Introduce ti,irqs-skip to skip irqs that bypass crossbar
Date: Thu, 26 Jun 2014 12:40:21 +0530
Message-ID: <1403766634-18543-4-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

When, in the system due to varied reasons, interrupts might be unusable
due to hardware behavior, but register maps do exist, then those interrupts
should be skipped while mapping irq to crossbars.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 .../devicetree/bindings/arm/omap/crossbar.txt      |    6 ++++++
 drivers/irqchip/irq-crossbar.c                     |   20 ++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
index fb88585..0795765 100644
--- a/Documentation/devicetree/bindings/arm/omap/crossbar.txt
+++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
@@ -17,6 +17,11 @@ Required properties:
 		 so crossbar bar driver should not consider them as free
 		 lines.
 
+Optional properties:
+- ti,irqs-skip: This is similar to "ti,irqs-reserved", but these are for
+  SOC-specific hard-wiring of those irqs which unexpectedly bypasses the
+  crossbar. These irqs have a crossbar register, but still cannot be used.
+
 Examples:
 		crossbar_mpu: @4a020000 {
 			compatible = "ti,irq-crossbar";
@@ -24,4 +29,5 @@ Examples:
 			ti,max-irqs = <160>;
 			ti,reg-size = <2>;
 			ti,irqs-reserved = <0 1 2 3 5 6 131 132 139 140>;
+			ti,irqs-skip = <10 133 139 140>;
 		};
diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 51d4b87..0533a71 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -18,6 +18,7 @@
 
 #define IRQ_FREE	-1
 #define IRQ_RESERVED	-2
+#define IRQ_SKIP	-3
 #define GIC_IRQ_START	32
 
 /*
@@ -160,6 +161,25 @@ static int __init crossbar_of_init(struct device_node *node)
 		}
 	}
 
+	/* Skip irqs hardwired to bypass the crossbar */
+	irqsr = of_get_property(node, "ti,irqs-skip", &size);
+	if (irqsr) {
+		size /= sizeof(__be32);
+
+		for (i = 0; i < size; i++) {
+			of_property_read_u32_index(node,
+						   "ti,irqs-skip",
+						   i, &entry);
+			if (entry > max) {
+				pr_err("Invalid skip entry\n");
+				ret = -EINVAL;
+				goto err3;
+			}
+			cb->irq_map[entry] = IRQ_SKIP;
+		}
+	}
+
+
 	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
 	if (!cb->register_offsets)
 		goto err3;
-- 
1.7.9.5

