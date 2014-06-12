Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920AbaFLMIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:08:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60459 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933469AbaFLL4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:56:10 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 03/19] irqchip: crossbar: Skip some irqs from getting mapped to crossbar
Date: Thu, 12 Jun 2014 17:23:11 +0530
Message-ID: <1402574007-13987-4-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
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
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/irqchip/irq-crossbar.c |   47 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 51d4b87..847f6e3 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -13,11 +13,13 @@
 #include <linux/io.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/irqchip/arm-gic.h>
 
 #define IRQ_FREE	-1
 #define IRQ_RESERVED	-2
+#define IRQ_SKIP	-3
 #define GIC_IRQ_START	32
 
 /*
@@ -34,6 +36,16 @@ struct crossbar_device {
 	void (*write) (int, int);
 };
 
+/**
+ * struct crossbar_data: Platform specific data
+ * @irqs_unused: array of irqs that cannot be used because of hw erratas
+ * @size: size of the irqs_unused array
+ */
+struct crossbar_data {
+	const uint *irqs_unused;
+	const uint size;
+};
+
 static struct crossbar_device *cb;
 
 static inline void crossbar_writel(int irq_no, int cb_no)
@@ -119,10 +131,12 @@ const struct irq_domain_ops routable_irq_domain_ops = {
 	.xlate = crossbar_domain_xlate
 };
 
-static int __init crossbar_of_init(struct device_node *node)
+static int __init crossbar_of_init(struct device_node *node,
+				   const struct crossbar_data *data)
 {
 	int i, size, max, reserved = 0, entry;
 	const __be32 *irqsr;
+	const int *irqsk = NULL;
 
 	cb = kzalloc(sizeof(*cb), GFP_KERNEL);
 
@@ -194,6 +208,22 @@ static int __init crossbar_of_init(struct device_node *node)
 		reserved += size;
 	}
 
+	/* Skip the ones marked as unused */
+	if (data) {
+		irqsk = data->irqs_unused;
+		size = data->size;
+
+		for (i = 0; i < size; i++) {
+			entry = irqsk[i];
+
+			if (entry > max) {
+				pr_err("Invalid skip entry\n");
+				goto err3;
+			}
+			cb->irq_map[entry] = IRQ_SKIP;
+		}
+	}
+
 	register_routable_domain_ops(&routable_irq_domain_ops);
 	return 0;
 
@@ -208,18 +238,27 @@ err1:
 	return -ENOMEM;
 }
 
+/* irq number 10 cannot be used because of hw bug */
+int dra_irqs_unused[] = { 10 };
+struct crossbar_data cb_dra_data = { dra_irqs_unused,
+				     ARRAY_SIZE(dra_irqs_unused) };
+
 static const struct of_device_id crossbar_match[] __initconst = {
-	{ .compatible = "ti,irq-crossbar" },
+	{ .compatible = "ti,irq-crossbar", .data = &cb_dra_data },
 	{}
 };
 
 int __init irqcrossbar_init(void)
 {
 	struct device_node *np;
-	np = of_find_matching_node(NULL, crossbar_match);
+	const struct of_device_id *of_id;
+	const struct crossbar_data *cdata;
+
+	np = of_find_matching_node_and_match(NULL, crossbar_match, &of_id);
 	if (!np)
 		return -ENODEV;
 
-	crossbar_of_init(np);
+	cdata = of_id->data;
+	crossbar_of_init(np, cdata);
 	return 0;
 }
-- 
1.7.9.5

