Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaLJNgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:36:24 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:56099 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbaLJNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:36:22 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ingo Molnar <mingo@redhat.com>, linux-gpio@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] [RFC] genirq: Set IRQCHIP_SKIP_SET_WAKE for no_irq_chip and dummy_irq_chip
Date: Wed, 10 Dec 2014 14:36:15 +0100
Message-Id: <1418218575-17694-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418218575-17694-1-git-send-email-geert+renesas@glider.be>
References: <1418218575-17694-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no_irq_chip or dummy_irq_chip are used for wake up (e.g. gpio-keys
with a simple GPIO controller), the following warning is printed on
resume from s2ram:

    WANING: CPU: 0 PID: 1046 at kernel/irq/manage.c:537 irq_set_irq_wake+0x9c/0xf8()
    Unbalanced IRQ 113 wake disable

This happens because no_irq_chip and dummy_irq_chip do not implement
irq_chip.irq_set_wake(), causing set_irq_wake_real() to return -ENXIO,
and irq_set_irq_wake() to reset the wake_depth to zero.

Set IRQCHIP_SKIP_SET_WAKE to indicate that irq_chip.irq_set_wake() is
not implemented.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Alternatively, can't we remove IRQCHIP_SKIP_SET_WAKE, and just check for
the presence of irq_chip.irq_set_wake()?
I'll be happy to send a patch to do that instead...

Is there anything that relies on this -ENXIO error code?
All irq_chip implementations that set IRQCHIP_SKIP_SET_WAKE do not
implement irq_chip.irq_set_wake(). There are probably more of them that
forgot to set IRQCHIP_SKIP_SET_WAKE though.
Am I missing something?
Commit 60f96b41f71d2a13 ("genirq: Add IRQCHIP_SKIP_SET_WAKE flag")
doesn't explain why adding the flag was chosen.

Thanks!
---
 kernel/irq/dummychip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/dummychip.c b/kernel/irq/dummychip.c
index 988dc58e8847f6eb..326a67f2410bf95c 100644
--- a/kernel/irq/dummychip.c
+++ b/kernel/irq/dummychip.c
@@ -42,6 +42,7 @@ struct irq_chip no_irq_chip = {
 	.irq_enable	= noop,
 	.irq_disable	= noop,
 	.irq_ack	= ack_bad,
+	.flags		= IRQCHIP_SKIP_SET_WAKE,
 };
 
 /*
@@ -57,5 +58,6 @@ struct irq_chip dummy_irq_chip = {
 	.irq_ack	= noop,
 	.irq_mask	= noop,
 	.irq_unmask	= noop,
+	.flags		= IRQCHIP_SKIP_SET_WAKE,
 };
 EXPORT_SYMBOL_GPL(dummy_irq_chip);
-- 
1.9.1

