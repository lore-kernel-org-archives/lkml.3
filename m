Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaESMeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:34:21 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:56136 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbaESMeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:34:19 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2014 08:34:19 EDT
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net, jonas@southpole.se
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH] openrisc: irq: use irqchip framework
Date: Mon, 19 May 2014 15:25:28 +0300
Message-Id: <1400502328-23974-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to consolidating the or1k-pic initialization with
how other interrupt controllers are initialized, this makes
OpenRISC less tied to its on-cpu interrupt controller.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/kernel/irq.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/openrisc/kernel/irq.c b/arch/openrisc/kernel/irq.c
index 8ec77bc..f6f4683 100644
--- a/arch/openrisc/kernel/irq.c
+++ b/arch/openrisc/kernel/irq.c
@@ -19,10 +19,13 @@
 #include <linux/of.h>
 #include <linux/ftrace.h>
 #include <linux/irq.h>
+#include <linux/irqchip.h>
 #include <linux/export.h>
 #include <linux/irqdomain.h>
 #include <linux/irqflags.h>
 
+#include "../../drivers/irqchip/irqchip.h"
+
 /* read interrupt enabled status */
 unsigned long arch_local_save_flags(void)
 {
@@ -151,24 +154,22 @@ static const struct irq_domain_ops or1k_irq_domain_ops = {
  * 1000 CPU.  This is the "root" domain as these are the interrupts
  * that directly trigger an exception in the CPU.
  */
-static void __init or1k_irq_init(void)
+static int __init
+or1k_irq_init(struct device_node *intc,  struct device_node *parent)
 {
-	struct device_node *intc = NULL;
-
-	/* The interrupt controller device node is mandatory */
-	intc = of_find_compatible_node(NULL, NULL, "opencores,or1k-pic");
-	BUG_ON(!intc);
-
 	/* Disable all interrupts until explicitly requested */
 	mtspr(SPR_PICMR, (0UL));
 
 	root_domain = irq_domain_add_linear(intc, 32,
 					    &or1k_irq_domain_ops, NULL);
+
+	return 0;
 }
+IRQCHIP_DECLARE(or1k_pic, "opencores,or1k-pic", or1k_irq_init);
 
 void __init init_IRQ(void)
 {
-	or1k_irq_init();
+	irqchip_init();
 }
 
 void __irq_entry do_IRQ(struct pt_regs *regs)
-- 
1.8.3.2

