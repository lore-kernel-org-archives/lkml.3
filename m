Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaK0SmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:42:13 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:32684 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaK0SmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:42:12 -0500
X-ME-Helo: beldin.home
X-ME-Date: Thu, 27 Nov 2014 19:42:10 +0100
X-ME-IP: 90.11.113.15
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: pxa: fix lubbock interrupts handling
Date: Thu, 27 Nov 2014 19:42:01 +0100
Message-Id: <1417113721-9062-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When gpio-pxa was moved to drivers/pxa, it became a driver, and its
initialization and probing happen at postcore initcall. The lubbock code
used to install the chained lubbock interrupt handler at init_irq()
time.

The consequence of the gpio-pxa change is that the installed chained irq
handler lubbock_irq_handler() was overwritten in pxa_gpio_probe(_dt)(),
removing :
 - the handler
 - the falling edge detection setting of GPIO0, which revealed the
   interrupt request from the lubbock IO board.

As a fix, move the gpio0 chained handler setup to a place where we have
the guarantee that pxa_gpio_probe() was called before, so that lubbock
handler becomes the true IRQ chained handler of GPIO0, demuxing the
lubbock IO board interrupts.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
For Thomas: as a side note, I'm not very happy with this patch. What
            makes me unhappy is that I don't know how to express the
            dependency between gpio-pxa probe time and
            irq_set_chained_handler(irq, lubbock_irq_handler).

            At the moment I rely on the fact that
            lubbock_irq_device_init() is called as device initcall while
            pxa_gpio_probe() is called as postcore initcall.

            If you have a better idea I'm all ears.
---
 arch/arm/mach-pxa/lubbock.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-pxa/lubbock.c b/arch/arm/mach-pxa/lubbock.c
index d8a1be6..1f138f9 100644
--- a/arch/arm/mach-pxa/lubbock.c
+++ b/arch/arm/mach-pxa/lubbock.c
@@ -172,9 +172,6 @@ static void __init lubbock_init_irq(void)
 					 handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
-
-	irq_set_chained_handler(PXA_GPIO_TO_IRQ(0), lubbock_irq_handler);
-	irq_set_irq_type(PXA_GPIO_TO_IRQ(0), IRQ_TYPE_EDGE_FALLING);
 }
 
 #ifdef CONFIG_PM
@@ -190,7 +187,13 @@ static struct syscore_ops lubbock_irq_syscore_ops = {
 
 static int __init lubbock_irq_device_init(void)
 {
+	int irq;
+
 	if (machine_is_lubbock()) {
+		irq = PXA_GPIO_TO_IRQ(0);
+		irq_set_chained_handler(irq, lubbock_irq_handler);
+		irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
+
 		register_syscore_ops(&lubbock_irq_syscore_ops);
 		return 0;
 	}
-- 
2.1.0

