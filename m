Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaJTTHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:07:05 -0400
Received: from mail-qg0-f74.google.com ([209.85.192.74]:55482 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaJTTEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:12 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/19] irqchip: mips-gic: Remove gic_{pending,itrmask}_regs
Date: Mon, 20 Oct 2014 12:03:56 -0700
Message-Id: <1413831846-32100-10-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason for the pending and masked interrupt bitmasks
to be global.  Just declare them on the stack in gic_get_int()
since they only consume (256*2)/8 = 64 bytes.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/irqchip/irq-mips-gic.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index a1ccde6..188760c 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -25,18 +25,8 @@ struct gic_pcpu_mask {
 	DECLARE_BITMAP(pcpu_mask, GIC_MAX_INTRS);
 };
 
-struct gic_pending_regs {
-	DECLARE_BITMAP(pending, GIC_MAX_INTRS);
-};
-
-struct gic_intrmask_regs {
-	DECLARE_BITMAP(intrmask, GIC_MAX_INTRS);
-};
-
 static void __iomem *gic_base;
 static struct gic_pcpu_mask pcpu_masks[NR_CPUS];
-static struct gic_pending_regs pending_regs[NR_CPUS];
-static struct gic_intrmask_regs intrmask_regs[NR_CPUS];
 static DEFINE_SPINLOCK(gic_lock);
 static struct irq_domain *gic_irq_domain;
 static int gic_shared_intrs;
@@ -242,12 +232,12 @@ int gic_get_c0_perfcount_int(void)
 static unsigned int gic_get_int(void)
 {
 	unsigned int i;
-	unsigned long *pending, *intrmask, *pcpu_mask;
+	unsigned long *pcpu_mask;
 	unsigned long pending_reg, intrmask_reg;
+	DECLARE_BITMAP(pending, GIC_MAX_INTRS);
+	DECLARE_BITMAP(intrmask, GIC_MAX_INTRS);
 
 	/* Get per-cpu bitmaps */
-	pending = pending_regs[smp_processor_id()].pending;
-	intrmask = intrmask_regs[smp_processor_id()].intrmask;
 	pcpu_mask = pcpu_masks[smp_processor_id()].pcpu_mask;
 
 	pending_reg = GIC_REG(SHARED, GIC_SH_PEND);
-- 
2.1.0.rc2.206.gedb03e5

