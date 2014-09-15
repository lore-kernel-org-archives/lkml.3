Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbaIOXwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:52:49 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:56399 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbaIOXvr (ORCPT
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
Subject: [PATCH 23/24] MIPS: Malta: Use generic plat_irq_dispatch
Date: Mon, 15 Sep 2014 16:51:26 -0700
Message-Id: <1410825087-5497-24-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic plat_irq_dispatch provided in irq_cpu.c is sufficient for
dispatching interrupts on Malta in legacy and vectored interrupt modes.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/mti-malta/malta-int.c | 92 -----------------------------------------
 1 file changed, 92 deletions(-)

diff --git a/arch/mips/mti-malta/malta-int.c b/arch/mips/mti-malta/malta-int.c
index c6b3548..bcab0b1 100644
--- a/arch/mips/mti-malta/malta-int.c
+++ b/arch/mips/mti-malta/malta-int.c
@@ -190,92 +190,6 @@ static irqreturn_t corehi_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static inline int clz(unsigned long x)
-{
-	__asm__(
-	"	.set	push					\n"
-	"	.set	mips32					\n"
-	"	clz	%0, %1					\n"
-	"	.set	pop					\n"
-	: "=r" (x)
-	: "r" (x));
-
-	return x;
-}
-
-/*
- * Version of ffs that only looks at bits 12..15.
- */
-static inline unsigned int irq_ffs(unsigned int pending)
-{
-#if defined(CONFIG_CPU_MIPS32) || defined(CONFIG_CPU_MIPS64)
-	return -clz(pending) + 31 - CAUSEB_IP;
-#else
-	unsigned int a0 = 7;
-	unsigned int t0;
-
-	t0 = pending & 0xf000;
-	t0 = t0 < 1;
-	t0 = t0 << 2;
-	a0 = a0 - t0;
-	pending = pending << t0;
-
-	t0 = pending & 0xc000;
-	t0 = t0 < 1;
-	t0 = t0 << 1;
-	a0 = a0 - t0;
-	pending = pending << t0;
-
-	t0 = pending & 0x8000;
-	t0 = t0 < 1;
-	/* t0 = t0 << 2; */
-	a0 = a0 - t0;
-	/* pending = pending << t0; */
-
-	return a0;
-#endif
-}
-
-/*
- * IRQs on the Malta board look basically (barring software IRQs which we
- * don't use at all and all external interrupt sources are combined together
- * on hardware interrupt 0 (MIPS IRQ 2)) like:
- *
- *	MIPS IRQ	Source
- *	--------	------
- *	       0	Software (ignored)
- *	       1	Software (ignored)
- *	       2	Combined hardware interrupt (hw0)
- *	       3	Hardware (ignored)
- *	       4	Hardware (ignored)
- *	       5	Hardware (ignored)
- *	       6	Hardware (ignored)
- *	       7	R4k timer (what we use)
- *
- * We handle the IRQ according to _our_ priority which is:
- *
- * Highest ----	    R4k Timer
- * Lowest  ----	    Combined hardware interrupt
- *
- * then we just return, if multiple IRQs are pending then we will just take
- * another exception, big deal.
- */
-
-asmlinkage void plat_irq_dispatch(void)
-{
-	unsigned int pending = read_c0_cause() & read_c0_status() & ST0_IM;
-	int irq;
-
-	if (unlikely(!pending)) {
-		spurious_interrupt();
-		return;
-	}
-
-	irq = irq_ffs(pending);
-
-	do_IRQ(MIPS_CPU_IRQ_BASE + irq);
-}
-
 #ifdef CONFIG_MIPS_MT_SMP
 
 #define MIPS_CPU_IPI_RESCHED_IRQ 0	/* SW int 0 for resched */
@@ -438,12 +352,6 @@ void __init arch_init_irq(void)
 			cpu_ipi_resched_irq = MSC01E_INT_SW0;
 			cpu_ipi_call_irq = MSC01E_INT_SW1;
 		} else {
-			if (cpu_has_vint) {
-				set_vi_handler (MIPS_CPU_IPI_RESCHED_IRQ,
-					ipi_resched_dispatch);
-				set_vi_handler (MIPS_CPU_IPI_CALL_IRQ,
-					ipi_call_dispatch);
-			}
 			cpu_ipi_resched_irq = MIPS_CPU_IRQ_BASE +
 				MIPS_CPU_IPI_RESCHED_IRQ;
 			cpu_ipi_call_irq = MIPS_CPU_IRQ_BASE +
-- 
2.1.0.rc2.206.gedb03e5

