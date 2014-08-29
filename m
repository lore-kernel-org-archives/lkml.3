Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaH2WPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:15:51 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:65083 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaH2WOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:14:50 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] MIPS: GIC: Use local interrupts for timer
Date: Fri, 29 Aug 2014 15:14:38 -0700
Message-Id: <1409350479-19108-12-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using GIC interrupt 0 for the timer (which was not even
handled correctly by the GIC irqchip code and could conflict with an
actual external interrupt), use the designated local interrupt for
the GIC timer.

Also, since the timer is a per-CPU interrupt, initialize it with
setup_percpu_irq() and enable it with enable_percpu_irq() instead
of using direct register writes.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/kernel/cevt-gic.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/mips/kernel/cevt-gic.c b/arch/mips/kernel/cevt-gic.c
index 6093716..cae72a4 100644
--- a/arch/mips/kernel/cevt-gic.c
+++ b/arch/mips/kernel/cevt-gic.c
@@ -68,7 +68,7 @@ int gic_clockevent_init(void)
 	if (!cpu_has_counter || !gic_frequency)
 		return -ENXIO;
 
-	irq = MIPS_GIC_IRQ_BASE;
+	irq = MIPS_GIC_LOCAL_IRQ_BASE + GIC_LOCAL_INTR_COMPARE;
 
 	cd = &per_cpu(gic_clockevent_device, cpu);
 
@@ -91,15 +91,13 @@ int gic_clockevent_init(void)
 
 	clockevents_register_device(cd);
 
-	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_MAP), 0x80000002);
-	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_SMASK), GIC_VPE_SMASK_CMP_MSK);
+	if (!gic_timer_irq_installed) {
+		setup_percpu_irq(irq, &gic_compare_irqaction);
+		irq_set_handler(irq, handle_percpu_irq);
+		gic_timer_irq_installed = 1;
+	}
 
-	if (gic_timer_irq_installed)
-		return 0;
+	enable_percpu_irq(irq, 0);
 
-	gic_timer_irq_installed = 1;
-
-	setup_irq(irq, &gic_compare_irqaction);
-	irq_set_handler(irq, handle_percpu_irq);
 	return 0;
 }
-- 
2.1.0.rc2.206.gedb03e5

