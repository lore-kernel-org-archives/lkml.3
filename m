Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3BRAG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 19:06:28 -0500
Received: from gloria.sntech.de ([95.129.55.99]:44703 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab3BRAG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 19:06:26 -0500
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: [PATCH v2 2/3] irqchip: irq-s3c24xx: add devicetree support
Date: Mon, 18 Feb 2013 01:06:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201302180103.53084.heiko@sntech.de>
In-Reply-To: <201302180103.53084.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302180106.18124.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds devicetree parsing of the controller-data for the
interrupt controllers on S3C24XX architectures.

As the interrupts and their parent differ on all s3c24xx SoCs the
interrupt-list and parent-relationship is read from a list in the
devicetree data.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../interrupt-controller/samsung,s3c24xx-irq.txt   |   53 ++++++++
 drivers/irqchip/Makefile                           |    2 +-
 drivers/irqchip/irq-s3c24xx.c                      |  128 ++++++++++++++++++++
 3 files changed, 182 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/samsung,s3c24xx-irq.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/samsung,s3c24xx-irq.txt b/Documentation/devicetree/bindings/interrupt-controller/samsung,s3c24xx-irq.txt
new file mode 100644
index 0000000..3f6600e
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/samsung,s3c24xx-irq.txt
@@ -0,0 +1,53 @@
+Samsung S3C24XX Interrupt Controllers
+
+The S3C24XX SoCs contain custom set of interrupt controllers providing a
+varying number of interrupt sources.
+
+The set consists of a main- and a sub-controller as well as a controller
+for the external interrupts and on newer SoCs even a second main controller.
+
+The bit-to-interrupt and parent mapping of the controllers is not fixed
+over all SoCs and therefore must be defined in the controller description.
+
+Required properties:
+- compatible: Compatible property value should be "samsung,s3c24xx-irq".
+
+- reg: Physical base address of the controller and length of memory mapped
+  region.
+
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source. The value shall be 2.
+
+- s3c24xx,irqlist : List of irqtypes found on this controller as
+  two-value pairs consisting of irqtype and parent-irq number
+
+  parent-irq is always the list position of the irq in the irqlist
+  of the parent controller (0..31)
+
+  irqtypes are:
+  - 0 .. none
+  - 1 .. external interrupts
+  - 2 .. edge irq
+  - 3 .. level irq
+
+Optional properties:
+- interrupt_parent : The parent interrupt controller
+
+Example:
+
+	intc2:interrupt-controller@4a000040 {
+		compatible = "samsung,s3c24xx-irq";
+		reg = <0x4a000040 0x18>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+
+		s3c24xx,irqlist = <2 0 /* 2D */
+				   2 0 /* IIC1 */
+				   0 0 /* reserved */
+				   0 0 /* reserved */
+				   2 0 /* PCM0 */
+				   2 0 /* PCM1 */
+				   2 0 /* I2S0 */
+				   2 0>; /* I2S1 */
+	};
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 073324c..7ce9f05 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
 obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-combiner.o
-obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.c
+obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
 obj-$(CONFIG_ARM_GIC)			+= irq-gic.o
diff --git a/drivers/irqchip/irq-s3c24xx.c b/drivers/irqchip/irq-s3c24xx.c
index 3f3de74..2a02de3 100644
--- a/drivers/irqchip/irq-s3c24xx.c
+++ b/drivers/irqchip/irq-s3c24xx.c
@@ -25,6 +25,9 @@
 #include <linux/ioport.h>
 #include <linux/device.h>
 #include <linux/irqdomain.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
 
 #include <asm/mach/irq.h>
 
@@ -35,6 +38,8 @@
 #include <plat/regs-irqtype.h>
 #include <plat/pm.h>
 
+#include "irqchip.h"
+
 #define S3C_IRQTYPE_NONE	0
 #define S3C_IRQTYPE_EINT	1
 #define S3C_IRQTYPE_EDGE	2
@@ -1066,3 +1071,126 @@ void __init s3c2443_init_irq(void)
 	s3c24xx_init_intc(NULL, &init_s3c2443subint[0], main_intc, 0x4a000018);
 }
 #endif
+
+#ifdef CONFIG_OF
+int __init s3c24xx_init_intc_of(struct device_node *np,
+				 struct device_node *interrupt_parent)
+{
+	struct s3c_irq_intc *intc;
+	struct s3c_irq_intc *parent;
+	struct s3c_irq_data *irq_data;
+	struct property *intc_prop;
+	const __be32 *p;
+	unsigned long address;
+	int ret;
+	int i;
+	int cnt;
+	u32 val;
+
+	p = of_get_address(np, 0, NULL, NULL);
+	if (!p) {
+		pr_err("irq: register address missing\n");
+		return -EINVAL;
+	}
+
+	address = of_translate_address(np, p);
+
+	intc_prop = of_find_property(np, "s3c24xx,irqlist", NULL);
+	if (!intc_prop) {
+		pr_err("irq: irqlist not found\n");
+		return -EINVAL;
+	}
+
+	irq_data = kzalloc(sizeof(struct s3c_irq_data) * 32, GFP_KERNEL);
+	if (!irq_data)
+		return -ENOMEM;
+
+	/* build the irq_data list */
+	p = NULL;
+	cnt = 0;
+	for (i = 0; i < 32; i++) {
+		p = of_prop_next_u32(intc_prop, p, &val);
+
+		/* when we hit the first non-valid element, assume it's
+		 * the end of the list. The rest of the fields are
+		 * already of type S3C_IRQTYPE_NONE (value 0)
+		 */
+		if (!p)
+			break;
+
+		irq_data[i].type = val;
+
+		p = of_prop_next_u32(intc_prop, p, &val);
+		if (!p) {
+			pr_warn("irq: uneven number of elements in irqlist, last interrupt will be dropped\n");
+			irq_data[i].type = 0;
+			break;
+		}
+
+		irq_data[i].parent_irq = val;
+
+		pr_debug("irq: found hwirq %d with type %d and parent %lu\n",
+			 i, irq_data[i].type, irq_data[i].parent_irq);
+		cnt++;
+	}
+
+	/* if we haven't found any irq definition at all,
+	 * something is very wrong.
+	 */
+	if (!cnt) {
+		pr_err("irq: empty irq definition\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (interrupt_parent) {
+		parent = (struct s3c_irq_intc *)of_get_property(
+				      interrupt_parent, "s3c-irq-intc", NULL);
+		if (!parent) {
+			pr_err("irq: no parent for non-root controller found\n");
+			ret = -EINVAL;
+			goto err;
+		}
+	} else {
+		parent = NULL;
+	}
+
+	intc = s3c24xx_init_intc(np, irq_data, parent, address);
+	if (IS_ERR(intc)) {
+		ret = PTR_ERR(intc);
+		goto err;
+	}
+
+	/* put the intc as property into the dt, so we can access it
+	 * as the interrupt_parent later
+	 */
+	intc_prop = kzalloc(sizeof(struct property), GFP_KERNEL);
+	if (!intc_prop) {
+		pr_err("irq: could not allocate memory for dt property\n");
+
+		/* the interrupt controller was already added, so don't
+		 * remove the created structures.
+		 */
+		return -ENOMEM;
+	}
+
+	intc_prop->name = kstrdup("s3c-irq-intc", GFP_KERNEL);
+	intc_prop->value = intc;
+	intc_prop->length = sizeof(struct s3c_irq_intc);
+
+	ret = of_add_property(np, intc_prop);
+	if (ret) {
+		pr_err("irq: failed to add dt property\n");
+		kfree(intc_prop);
+		return ret;
+	}
+
+	return 0;
+
+err:
+	kfree(irq_data);
+
+	return ret;
+}
+IRQCHIP_DECLARE(s3c24xx_irq, "samsung,s3c24xx-irq", s3c24xx_init_intc_of);
+#endif
-- 
1.7.2.3

