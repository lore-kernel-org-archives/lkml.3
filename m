Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbaIOXwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:52:46 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:33542 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbaIOXvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:47 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/24] irqchip: mips-gic: Remove unnecessary globals
Date: Mon, 15 Sep 2014 16:51:25 -0700
Message-Id: <1410825087-5497-23-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all GIC interrupt routing and handling logic is in the GIC
driver itself, un-export variables/functions which are no longer used
outside the GIC driver.  This also allows us to remove gic_compare_int
and combine gic_get_int_mask with gic_get_int since these interfaces
are no longer used.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/gic.h    |  5 -----
 drivers/irqchip/irq-mips-gic.c | 28 ++++------------------------
 2 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/arch/mips/include/asm/gic.h b/arch/mips/include/asm/gic.h
index 6b99610..727b7bf 100644
--- a/arch/mips/include/asm/gic.h
+++ b/arch/mips/include/asm/gic.h
@@ -364,13 +364,11 @@
 extern unsigned int gic_present;
 extern unsigned int gic_frequency;
 extern unsigned long _gic_base;
-extern unsigned int gic_cpu_pin;
 
 extern void gic_init(unsigned long gic_base_addr,
 	unsigned long gic_addrspace_size, unsigned int cpu_vec,
 	unsigned int irqbase);
 extern void gic_clocksource_init(unsigned int);
-extern unsigned int gic_compare_int (void);
 extern cycle_t gic_read_count(void);
 extern cycle_t gic_read_compare(void);
 extern void gic_write_compare(cycle_t cnt);
@@ -378,10 +376,7 @@ extern void gic_write_cpu_compare(cycle_t cnt, int cpu);
 extern void gic_send_ipi(unsigned int intr);
 extern unsigned int plat_ipi_call_int_xlate(unsigned int);
 extern unsigned int plat_ipi_resched_int_xlate(unsigned int);
-extern void gic_bind_eic_interrupt(int irq, int set);
 extern unsigned int gic_get_timer_pending(void);
-extern void gic_get_int_mask(unsigned long *dst, const unsigned long *src);
-extern unsigned int gic_get_int(void);
 extern int gic_get_c0_compare_int(void);
 extern int gic_get_c0_perfcount_int(void);
 #endif /* _ASM_GICREGS_H */
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 3abe310..845affb 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -24,7 +24,6 @@
 unsigned int gic_frequency;
 unsigned int gic_present;
 unsigned long _gic_base;
-unsigned int gic_cpu_pin;
 
 struct gic_pcpu_mask {
 	DECLARE_BITMAP(pcpu_mask, GIC_MAX_INTRS);
@@ -44,6 +43,7 @@ static struct gic_intrmask_regs intrmask_regs[NR_CPUS];
 static struct irq_domain *gic_irq_domain;
 static int gic_shared_intrs;
 static int gic_vpes;
+static unsigned int gic_cpu_pin;
 static struct irq_chip gic_level_irq_controller, gic_edge_irq_controller;
 
 static void __gic_irq_dispatch(void);
@@ -132,7 +132,7 @@ unsigned int gic_get_timer_pending(void)
 	return (vpe_pending & GIC_VPE_PEND_TIMER_MSK);
 }
 
-void gic_bind_eic_interrupt(int irq, int set)
+static void gic_bind_eic_interrupt(int irq, int set)
 {
 	/* Convert irq vector # to hw int # */
 	irq -= GIC_PIN_TO_VEC_OFFSET;
@@ -146,17 +146,6 @@ void gic_send_ipi(unsigned int intr)
 	GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), 0x80000000 | intr);
 }
 
-unsigned int gic_compare_int(void)
-{
-	unsigned int pending;
-
-	GICREAD(GIC_REG(VPE_LOCAL, GIC_VPE_PEND), pending);
-	if (pending & GIC_VPE_PEND_CMP_MSK)
-		return 1;
-	else
-		return 0;
-}
-
 int gic_get_c0_compare_int(void)
 {
 	if (!gic_local_irq_is_routable(GIC_LOCAL_INT_TIMER))
@@ -177,7 +166,7 @@ int gic_get_c0_perfcount_int(void)
 				  GIC_LOCAL_TO_HWIRQ(GIC_LOCAL_INT_PERFCTR));
 }
 
-void gic_get_int_mask(unsigned long *dst, const unsigned long *src)
+static unsigned int gic_get_int(void)
 {
 	unsigned int i;
 	unsigned long *pending, *intrmask, *pcpu_mask;
@@ -202,17 +191,8 @@ void gic_get_int_mask(unsigned long *dst, const unsigned long *src)
 
 	bitmap_and(pending, pending, intrmask, gic_shared_intrs);
 	bitmap_and(pending, pending, pcpu_mask, gic_shared_intrs);
-	bitmap_and(dst, src, pending, gic_shared_intrs);
-}
-
-unsigned int gic_get_int(void)
-{
-	DECLARE_BITMAP(interrupts, GIC_MAX_INTRS);
-
-	bitmap_fill(interrupts, gic_shared_intrs);
-	gic_get_int_mask(interrupts, interrupts);
 
-	return find_first_bit(interrupts, gic_shared_intrs);
+	return find_first_bit(pending, gic_shared_intrs);
 }
 
 static void gic_mask_irq(struct irq_data *d)
-- 
2.1.0.rc2.206.gedb03e5

