Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaFYJbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:31:24 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51348 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755432AbaFYJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:28:59 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, eric.auger@linaro.org,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 5/9] irqchip: GICv3: Convert to EOImode == 1
Date: Wed, 25 Jun 2014 10:28:46 +0100
Message-Id: <1403688530-23273-6-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, GICv3 has been used in with EOImode == 0. The effect of this
mode is to perform the priority drop and the deactivation of the
interrupt at the same time.

While this works perfectly for Linux (we only have a single priority),
it causes issues when an interrupt is forwarded to a guest, and when
we want the guest to perform the EOI itself.

For this case, the GIC architecture provides EOImode == 1, where:
- A write to ICC_EOIR1_EL1 drops the priority of the interrupt and leaves
it active. Other interrupts at the same priority level can now be taken,
but the active interrupt cannot be taken again
- A write to ICC_DIR_EL1 marks the interrupt as inactive, meaning it can
now be taken again.

This patch converts the driver to this new mode, without any other feature.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c   | 1 +
 drivers/irqchip/irq-gic-v3.c       | 6 ++++--
 include/linux/irqchip/arm-gic-v3.h | 7 +++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 822f55e..922f228 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -616,6 +616,7 @@ static void its_unmask_irq(struct irq_data *d)
 static void its_eoi_irq(struct irq_data *d)
 {
 	gic_write_eoir(d->hwirq);
+	gic_write_dir(d->hwirq);
 }
 
 static int its_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 3ae53c1..26a08ce 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -238,6 +238,7 @@ static void gic_unmask_irq(struct irq_data *d)
 static void gic_eoi_irq(struct irq_data *d)
 {
 	gic_write_eoir(gic_irq(d));
+	gic_write_dir(gic_irq(d));
 }
 
 static int gic_set_type(struct irq_data *d, unsigned int type)
@@ -297,6 +298,7 @@ static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs
 		}
 		if (irqnr < 16) {
 			gic_write_eoir(irqnr);
+			gic_write_dir(irqnr);
 #ifdef CONFIG_SMP
 			handle_IPI(irqnr, regs);
 #else
@@ -400,8 +402,8 @@ static void gic_cpu_sys_reg_init(void)
 	/* Set priority mask register */
 	gic_write_pmr(DEFAULT_PMR_VALUE);
 
-	/* EOI deactivates interrupt too (mode 0) */
-	gic_write_ctlr(ICC_CTLR_EL1_EOImode_drop_dir);
+	/* EOI drops priority only (mode 1) */
+	gic_write_ctlr(ICC_CTLR_EL1_EOImode_drop);
 
 	/* ... and let's hit the road... */
 	gic_write_grpen1(1);
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 023b49d..a0bff2f 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -229,6 +229,7 @@
 
 #define ICC_EOIR1_EL1			S3_0_C12_C12_1
 #define ICC_IAR1_EL1			S3_0_C12_C12_0
+#define ICC_DIR_EL1			S3_0_C12_C11_1
 #define ICC_SGI1R_EL1			S3_0_C12_C11_5
 #define ICC_PMR_EL1			S3_0_C4_C6_0
 #define ICC_CTLR_EL1			S3_0_C12_C12_4
@@ -303,6 +304,12 @@ static inline void gic_write_eoir(u64 irq)
 	isb();
 }
 
+static inline void gic_write_dir(u64 irq)
+{
+	asm volatile("msr " __stringify(ICC_DIR_EL1) ", %0" : : "r" (irq));
+	isb();
+}
+
 int its_cpu_init(void);
 struct irq_chip *its_init(struct device_node *node, struct rdist *rdist,
 			  struct irq_domain *domain);
-- 
1.8.3.4

