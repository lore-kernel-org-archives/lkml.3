Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaJ2EBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 00:01:51 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62221 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaJ2D7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:59:08 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH 02/11] irqchip: brcmstb-l2: Eliminate dependency on ARM code
Date: Tue, 28 Oct 2014 20:58:49 -0700
Message-Id: <1414555138-6500-2-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq-brcmstb-l2 driver has a single dependency on the ARM code, the
do_bad_IRQ macro.  Expand this macro in-place so that the driver can be
built on non-ARM platforms.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
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

