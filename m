Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaJYVvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:51:20 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:53815 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbaJYVvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:51:17 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] irqchip: GICv3: Convert to EOImode == 1
Date: Sat, 25 Oct 2014 12:06:55 +0100
Message-Id: <1414235215-10468-4-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com>
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com>
X-SA-Exim-Connect-IP: 90.219.10.17
X-SA-Exim-Rcpt-To: tglx@linutronix.de, jason@lakedaemon.net, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, GICv3 has been used in with EOImode == 0. The effect of this
mode is to perform the priority drop and the deactivation of the
interrupt at the same time.

While this works perfectly for Linux (we only have a single priority),
it causes issues when an interrupt is forwarded to a guest, and when
we want the guest to perform the EOI itself. This is also rather
inefficient for threaded interrupts, as it forces us to hit the
distributor (which is slower, specially when using virtualization).

For this case, the GIC architecture provides EOImode == 1, where:
- A write to ICC_EOIR1_EL1 drops the priority of the interrupt and leaves
it active. Other interrupts at the same priority level can now be taken,
but the active interrupt cannot be taken again
- A write to ICC_DIR_EL1 marks the interrupt as inactive, meaning it can
now be taken again.

This patch converts the driver to this new mode when virtualization is
enabled.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c       | 30 ++++++++++++++++++++++++++++--
 include/linux/irqchip/arm-gic-v3.h | 10 ++++++++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 666c14e..c7f8a25 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -30,6 +30,7 @@
 #include <asm/cputype.h>
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
+#include <asm/virt.h>
 
 #include "irq-gic-common.h"
 #include "irqchip.h"
@@ -45,6 +46,7 @@ struct gic_chip_data {
 };
 
 static struct gic_chip_data gic_data __read_mostly;
+static bool supports_deactivate = false;
 
 #define gic_data_rdist()		(this_cpu_ptr(gic_data.rdist))
 #define gic_data_rdist_rd_base()	(*gic_data_rdist())
@@ -289,6 +291,16 @@ static void gic_eoi_irq(struct irq_data *d)
 	gic_write_eoir(gic_irq(d));
 }
 
+static void gic_priority_drop_irq(struct irq_data *d)
+{
+	gic_write_eoir(gic_irq(d));
+}
+
+static void gic_deactivate_irq(struct irq_data *d)
+{
+	gic_write_dir(gic_irq(d));
+}
+
 static int gic_set_type(struct irq_data *d, unsigned int type)
 {
 	unsigned int irq = gic_irq(d);
@@ -345,6 +357,8 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 		}
 		if (irqnr < 16) {
 			gic_write_eoir(irqnr);
+			if (supports_deactivate)
+				gic_write_dir(irqnr);
 #ifdef CONFIG_SMP
 			handle_IPI(irqnr, regs);
 #else
@@ -441,8 +455,13 @@ static void gic_cpu_sys_reg_init(void)
 	/* Set priority mask register */
 	gic_write_pmr(DEFAULT_PMR_VALUE);
 
-	/* EOI deactivates interrupt too (mode 0) */
-	gic_write_ctlr(ICC_CTLR_EL1_EOImode_drop_dir);
+	if (supports_deactivate) {
+		/* EOI drops priority only (mode 1) */
+		gic_write_ctlr(ICC_CTLR_EL1_EOImode_drop);
+	} else {
+		/* EOI deactivates interrupt too (mode 0) */
+		gic_write_ctlr(ICC_CTLR_EL1_EOImode_drop_dir);
+	}
 
 	/* ... and let's hit the road... */
 	gic_write_grpen1(1);
@@ -738,6 +757,13 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 	if (of_property_read_u64(node, "redistributor-stride", &redist_stride))
 		redist_stride = 0;
 
+	if (is_hyp_mode_available()) {
+		supports_deactivate = true;
+		gic_chip.flags			= IRQCHIP_EOI_THREADED,
+		gic_chip.irq_priority_drop	= gic_priority_drop_irq;
+		gic_chip.irq_eoi		= gic_deactivate_irq;
+	}
+
 	gic_data.dist_base = dist_base;
 	gic_data.redist_base = redist_base;
 	gic_data.redist_regions = redist_regions;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 03a4ea3..9875502 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -74,6 +74,9 @@
 #define GICR_SYNCR			0x00C0
 #define GICR_MOVLPIR			0x0100
 #define GICR_MOVALLR			0x0110
+#define GICR_ISACTIVER			GICD_ISACTIVER
+#define GICR_ICACTIVER			GICD_ICACTIVER
+#define GICR_IDREGS			GICD_IDREGS
 #define GICR_PIDR2			GICD_PIDR2
 
 #define GICR_WAKER_ProcessorSleep	(1U << 1)
@@ -128,6 +131,7 @@
 #define ICH_VMCR_PMR_MASK		(0xffUL << ICH_VMCR_PMR_SHIFT)
 
 #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
+#define ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
 #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
 #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
 #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
@@ -195,6 +199,12 @@ static inline void gic_write_eoir(u64 irq)
 	isb();
 }
 
+static inline void gic_write_dir(u64 irq)
+{
+	asm volatile("msr_s " __stringify(ICC_DIR_EL1) ", %0" : : "r" (irq));
+	isb();
+}
+
 #endif
 
 #endif
-- 
2.1.0

