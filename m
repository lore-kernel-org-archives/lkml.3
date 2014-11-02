Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaKBBHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 21:07:53 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50888 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaKBBEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 21:04:54 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org
Cc: linux-sh@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH V3 05/14] irqchip: brcmstb-l2: Eliminate dependency on ARM code
Date: Sat,  1 Nov 2014 18:03:52 -0700
Message-Id: <1414890241-9938-6-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414890241-9938-1-git-send-email-cernekee@gmail.com>
References: <1414890241-9938-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq-brcmstb-l2 driver has a single dependency on the ARM code, the
do_bad_IRQ macro.  Expand this macro in-place so that the driver can be
built on non-ARM platforms.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/irqchip/irq-brcmstb-l2.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index c15c840..c9bdf20 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/spinlock.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
@@ -30,8 +31,6 @@
 #include <linux/irqchip.h>
 #include <linux/irqchip/chained_irq.h>
 
-#include <asm/mach/irq.h>
-
 #include "irqchip.h"
 
 /* Register offsets in the L2 interrupt controller */
@@ -63,7 +62,9 @@ static void brcmstb_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
 		~(__raw_readl(b->base + CPU_MASK_STATUS));
 
 	if (status == 0) {
-		do_bad_IRQ(irq, desc);
+		raw_spin_lock(&desc->lock);
+		handle_bad_irq(irq, desc);
+		raw_spin_unlock(&desc->lock);
 		goto out;
 	}
 
-- 
2.1.1

