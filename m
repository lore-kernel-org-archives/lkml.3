Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbaIOXwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:52:14 -0400
Received: from mail-vc0-f201.google.com ([209.85.220.201]:48480 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210AbaIOXvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:39 -0400
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
Subject: [PATCH 08/24] MIPS: Remove gic_{enable,disable}_interrupt()
Date: Mon, 15 Sep 2014 16:51:11 -0700
Message-Id: <1410825087-5497-9-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing calls gic_{enable,disable}_interrupt() any more.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/gic.h     |  2 --
 arch/mips/mti-malta/malta-int.c | 10 ----------
 arch/mips/mti-sead3/sead3-int.c | 34 ----------------------------------
 3 files changed, 46 deletions(-)

diff --git a/arch/mips/include/asm/gic.h b/arch/mips/include/asm/gic.h
index d7699cf..022d831 100644
--- a/arch/mips/include/asm/gic.h
+++ b/arch/mips/include/asm/gic.h
@@ -376,8 +376,6 @@ extern void gic_bind_eic_interrupt(int irq, int set);
 extern unsigned int gic_get_timer_pending(void);
 extern void gic_get_int_mask(unsigned long *dst, const unsigned long *src);
 extern unsigned int gic_get_int(void);
-extern void gic_enable_interrupt(int irq_vec);
-extern void gic_disable_interrupt(int irq_vec);
 extern void gic_irq_ack(struct irq_data *d);
 extern void gic_finish_irq(struct irq_data *d);
 extern void gic_platform_init(int irqs, struct irq_chip *irq_controller);
diff --git a/arch/mips/mti-malta/malta-int.c b/arch/mips/mti-malta/malta-int.c
index e4f43ba..5c31208 100644
--- a/arch/mips/mti-malta/malta-int.c
+++ b/arch/mips/mti-malta/malta-int.c
@@ -715,16 +715,6 @@ int malta_be_handler(struct pt_regs *regs, int is_fixup)
 	return retval;
 }
 
-void gic_enable_interrupt(int irq_vec)
-{
-	GIC_SET_INTR_MASK(irq_vec);
-}
-
-void gic_disable_interrupt(int irq_vec)
-{
-	GIC_CLR_INTR_MASK(irq_vec);
-}
-
 void gic_irq_ack(struct irq_data *d)
 {
 	int irq = (d->irq - gic_irq_base);
diff --git a/arch/mips/mti-sead3/sead3-int.c b/arch/mips/mti-sead3/sead3-int.c
index 6a560ac..9d5b5bd 100644
--- a/arch/mips/mti-sead3/sead3-int.c
+++ b/arch/mips/mti-sead3/sead3-int.c
@@ -85,40 +85,6 @@ void __init arch_init_irq(void)
 			ARRAY_SIZE(gic_intr_map), MIPS_GIC_IRQ_BASE);
 }
 
-void gic_enable_interrupt(int irq_vec)
-{
-	unsigned int i, irq_source;
-
-	/* enable all the interrupts associated with this vector */
-	for (i = 0; i < gic_shared_intr_map[irq_vec].num_shared_intr; i++) {
-		irq_source = gic_shared_intr_map[irq_vec].intr_list[i];
-		GIC_SET_INTR_MASK(irq_source);
-	}
-	/* enable all local interrupts associated with this vector */
-	if (gic_shared_intr_map[irq_vec].local_intr_mask) {
-		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), 0);
-		GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_SMASK),
-			gic_shared_intr_map[irq_vec].local_intr_mask);
-	}
-}
-
-void gic_disable_interrupt(int irq_vec)
-{
-	unsigned int i, irq_source;
-
-	/* disable all the interrupts associated with this vector */
-	for (i = 0; i < gic_shared_intr_map[irq_vec].num_shared_intr; i++) {
-		irq_source = gic_shared_intr_map[irq_vec].intr_list[i];
-		GIC_CLR_INTR_MASK(irq_source);
-	}
-	/* disable all local interrupts associated with this vector */
-	if (gic_shared_intr_map[irq_vec].local_intr_mask) {
-		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_OTHER_ADDR), 0);
-		GICWRITE(GIC_REG(VPE_OTHER, GIC_VPE_RMASK),
-			gic_shared_intr_map[irq_vec].local_intr_mask);
-	}
-}
-
 void gic_irq_ack(struct irq_data *d)
 {
 	GIC_CLR_INTR_MASK(d->irq - gic_irq_base);
-- 
2.1.0.rc2.206.gedb03e5

