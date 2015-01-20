Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbbATQxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:53:55 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:37957 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752480AbbATQxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:53:53 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: devicetree@vger.kernel.org, LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4] irqchip: gic: Allow interrupt level to be set for PPIs.
Date: Tue, 20 Jan 2015 16:52:59 +0000
Message-Id: <1421772779-25764-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During a recent cleanup of the arm64 DTs it has become clear that
the handling of PPIs in xxxx_set_type() is incorrect. The ARM TRMs
for GICv2 and later allow for "implementation defined" support for
setting the edge or level type of the PPI interrupts and don't restrict
the activation level of the signal. Current ARM implementations
do restrict the PPI level type to IRQ_TYPE_LEVEL_LOW, but licensees
of the IP can decide to shoot themselves in the foot at any time.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---

Changelog:
 v4: Re-enable the interrupt if it was disabled during the configuration
     change, even if we fail to set the new configuration.
 v3: Fixed the bit test logic from v2.
 v2: Update following comments from Russell King and Marc Zyngier.
     Thread here: https://lkml.org/lkml/2014/12/1/279
 v1: Initial version. https://lkml.org/lkml/2014/11/28/400

 Documentation/devicetree/bindings/arm/gic.txt |  8 ++++++--
 drivers/irqchip/irq-gic-common.c              | 18 ++++++++++++------
 drivers/irqchip/irq-gic-common.h              |  2 +-
 drivers/irqchip/irq-gic-v3.c                  |  8 ++++----
 drivers/irqchip/irq-gic.c                     |  9 ++++++---
 drivers/irqchip/irq-hip04.c                   |  9 ++++++---
 6 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index 8112d0c..c97484b 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -32,12 +32,16 @@ Main node required properties:
   The 3rd cell is the flags, encoded as follows:
 	bits[3:0] trigger type and level flags.
 		1 = low-to-high edge triggered
-		2 = high-to-low edge triggered
+		2 = high-to-low edge triggered (invalid for SPIs)
 		4 = active high level-sensitive
-		8 = active low level-sensitive
+		8 = active low level-sensitive (invalid for SPIs).
 	bits[15:8] PPI interrupt cpu mask.  Each bit corresponds to each of
 	the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
 	the interrupt is wired to that CPU.  Only valid for PPI interrupts.
+	Also note that the configurability of PPI interrupts is IMPLEMENTATION
+	DEFINED and as such not guaranteed to be present (most SoC available
+	in 2014 seem to ignore the setting of this flag and use the hardware
+	default value).
 
 - reg : Specifies base physical address(s) and size of the GIC registers. The
   first region is the GIC distributor register base and size. The 2nd region is
diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
index 61541ff..ad96ebb 100644
--- a/drivers/irqchip/irq-gic-common.c
+++ b/drivers/irqchip/irq-gic-common.c
@@ -21,7 +21,7 @@
 
 #include "irq-gic-common.h"
 
-void gic_configure_irq(unsigned int irq, unsigned int type,
+int gic_configure_irq(unsigned int irq, unsigned int type,
 		       void __iomem *base, void (*sync_access)(void))
 {
 	u32 enablemask = 1 << (irq % 32);
@@ -29,16 +29,17 @@ void gic_configure_irq(unsigned int irq, unsigned int type,
 	u32 confmask = 0x2 << ((irq % 16) * 2);
 	u32 confoff = (irq / 16) * 4;
 	bool enabled = false;
-	u32 val;
+	u32 val, oldval;
+	int ret = 0;
 
 	/*
 	 * Read current configuration register, and insert the config
 	 * for "irq", depending on "type".
 	 */
-	val = readl_relaxed(base + GIC_DIST_CONFIG + confoff);
-	if (type == IRQ_TYPE_LEVEL_HIGH)
+	val = oldval = readl_relaxed(base + GIC_DIST_CONFIG + confoff);
+	if (type & IRQ_TYPE_LEVEL_MASK)
 		val &= ~confmask;
-	else if (type == IRQ_TYPE_EDGE_RISING)
+	else if (type & IRQ_TYPE_EDGE_BOTH)
 		val |= confmask;
 
 	/*
@@ -54,15 +55,20 @@ void gic_configure_irq(unsigned int irq, unsigned int type,
 
 	/*
 	 * Write back the new configuration, and possibly re-enable
-	 * the interrupt.
+	 * the interrupt. If we tried to write a new configuration and failed,
+	 * return an error.
 	 */
 	writel_relaxed(val, base + GIC_DIST_CONFIG + confoff);
+	if (readl_relaxed(base + GIC_DIST_CONFIG + confoff) != val && val != oldval)
+		ret = -EINVAL;
 
 	if (enabled)
 		writel_relaxed(enablemask, base + GIC_DIST_ENABLE_SET + enableoff);
 
 	if (sync_access)
 		sync_access();
+
+	return ret;
 }
 
 void __init gic_dist_config(void __iomem *base, int gic_irqs,
diff --git a/drivers/irqchip/irq-gic-common.h b/drivers/irqchip/irq-gic-common.h
index b41f024..35a9884 100644
--- a/drivers/irqchip/irq-gic-common.h
+++ b/drivers/irqchip/irq-gic-common.h
@@ -20,7 +20,7 @@
 #include <linux/of.h>
 #include <linux/irqdomain.h>
 
-void gic_configure_irq(unsigned int irq, unsigned int type,
+int gic_configure_irq(unsigned int irq, unsigned int type,
                        void __iomem *base, void (*sync_access)(void));
 void gic_dist_config(void __iomem *base, int gic_irqs,
 		     void (*sync_access)(void));
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 1a146cc..6e50803 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -238,7 +238,9 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	if (irq < 16)
 		return -EINVAL;
 
-	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
+	/* SPIs have restrictions on the supported types */
+	if (irq >= 32 && type != IRQ_TYPE_LEVEL_HIGH &&
+			 type != IRQ_TYPE_EDGE_RISING)
 		return -EINVAL;
 
 	if (gic_irq_in_rdist(d)) {
@@ -249,9 +251,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 		rwp_wait = gic_dist_wait_for_rwp;
 	}
 
-	gic_configure_irq(irq, type, base, rwp_wait);
-
-	return 0;
+	return gic_configure_irq(irq, type, base, rwp_wait);
 }
 
 static u64 gic_mpidr_to_affinity(u64 mpidr)
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index d617ee5..4634cf7 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -188,12 +188,15 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 {
 	void __iomem *base = gic_dist_base(d);
 	unsigned int gicirq = gic_irq(d);
+	int ret;
 
 	/* Interrupt configuration for SGIs can't be changed */
 	if (gicirq < 16)
 		return -EINVAL;
 
-	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
+	/* SPIs have restrictions on the supported types */
+	if (gicirq >= 32 && type != IRQ_TYPE_LEVEL_HIGH &&
+			    type != IRQ_TYPE_EDGE_RISING)
 		return -EINVAL;
 
 	raw_spin_lock(&irq_controller_lock);
@@ -201,11 +204,11 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	if (gic_arch_extn.irq_set_type)
 		gic_arch_extn.irq_set_type(d, type);
 
-	gic_configure_irq(gicirq, type, base, NULL);
+	ret = gic_configure_irq(gicirq, type, base, NULL);
 
 	raw_spin_unlock(&irq_controller_lock);
 
-	return 0;
+	return ret;
 }
 
 static int gic_retrigger(struct irq_data *d)
diff --git a/drivers/irqchip/irq-hip04.c b/drivers/irqchip/irq-hip04.c
index 29b8f21..d059e66 100644
--- a/drivers/irqchip/irq-hip04.c
+++ b/drivers/irqchip/irq-hip04.c
@@ -120,21 +120,24 @@ static int hip04_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	void __iomem *base = hip04_dist_base(d);
 	unsigned int irq = hip04_irq(d);
+	int ret;
 
 	/* Interrupt configuration for SGIs can't be changed */
 	if (irq < 16)
 		return -EINVAL;
 
-	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
+	/* SPIs have restrictions on the supported types */
+	if (irq >= 32 && type != IRQ_TYPE_LEVEL_HIGH &&
+			 type != IRQ_TYPE_EDGE_RISING)
 		return -EINVAL;
 
 	raw_spin_lock(&irq_controller_lock);
 
-	gic_configure_irq(irq, type, base, NULL);
+	ret = gic_configure_irq(irq, type, base, NULL);
 
 	raw_spin_unlock(&irq_controller_lock);
 
-	return 0;
+	return ret;
 }
 
 #ifdef CONFIG_SMP
-- 
2.2.2

