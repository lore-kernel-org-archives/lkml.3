Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaKKNeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:34:06 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50876 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbaKKNeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:34:04 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Kevin Hilman <khilman@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-sh@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        linux-mips@linux-mips.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH] irqchip: atmel-aic: fix irqdomain initialization
Date: Tue, 11 Nov 2014 14:33:36 +0100
Message-Id: <1415712816-9202-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20141110230301.GV4068@piout.net>
References: <20141110230301.GV4068@piout.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all IRQCHIP_SKIP_SET_WAKE is not a valid irq_gc_flags and thus
should not be passed as the last argument of
irq_alloc_domain_generic_chips.

Then pass the correct handler (handle_fasteoi_irq) to
irq_alloc_domain_generic_chips instead of manually re-setting it in the
initialization loop.

And eventually initialize default irq flags to the pseudo standard:
IRQ_REQUEST | IRQ_PROBE | IRQ_AUTOEN.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
Hello Kevin,

This patch has not been tested yet but it should solve the issue you've
experienced with the IRQ_GC_BE_IO flag and the atmel-aic driver.

I'll test it tomorrow and let you know if it actually works.

Regards,

Boris

 drivers/irqchip/irq-atmel-aic-common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-atmel-aic-common.c b/drivers/irqchip/irq-atmel-aic-common.c
index 656cfe3..d111ac7 100644
--- a/drivers/irqchip/irq-atmel-aic-common.c
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -243,8 +243,9 @@ struct irq_domain *__init aic_common_of_init(struct device_node *node,
 	}
 
 	ret = irq_alloc_domain_generic_chips(domain, 32, 1, name,
-					     handle_level_irq, 0, 0,
-					     IRQCHIP_SKIP_SET_WAKE);
+					     handle_fasteoi_irq,
+					     IRQ_NOREQUEST | IRQ_NOPROBE |
+					     IRQ_NOAUTOEN, 0, 0);
 	if (ret)
 		goto err_domain_remove;
 
@@ -256,7 +257,6 @@ struct irq_domain *__init aic_common_of_init(struct device_node *node,
 		gc->unused = 0;
 		gc->wake_enabled = ~0;
 		gc->chip_types[0].type = IRQ_TYPE_SENSE_MASK;
-		gc->chip_types[0].handler = handle_fasteoi_irq;
 		gc->chip_types[0].chip.irq_eoi = irq_gc_eoi;
 		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
 		gc->chip_types[0].chip.irq_shutdown = aic_common_shutdown;
-- 
1.9.1

