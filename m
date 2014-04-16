Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaDPM7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:59:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64588 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbaDPM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:59:48 -0400
Date: Wed, 16 Apr 2014 14:59:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fix
Message-ID: <20140416125943.GA11427@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

   # HEAD: f6da9fe45c3074b909084ae9da5f55034ebffeb4 irqchip: vic: Properly chain the cascaded IRQs

ARM VIC (Vectored Irq Controller) irqchip driver fix.

 Thanks,

	Ingo

------------------>
Linus Walleij (1):
      irqchip: vic: Properly chain the cascaded IRQs


 drivers/irqchip/irq-vic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index 37dab0b..7d35287 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -228,12 +229,17 @@ static int handle_one_vic(struct vic_device *vic, struct pt_regs *regs)
 static void vic_handle_irq_cascaded(unsigned int irq, struct irq_desc *desc)
 {
 	u32 stat, hwirq;
+	struct irq_chip *host_chip = irq_desc_get_chip(desc);
 	struct vic_device *vic = irq_desc_get_handler_data(desc);
 
+	chained_irq_enter(host_chip, desc);
+
 	while ((stat = readl_relaxed(vic->base + VIC_IRQ_STATUS))) {
 		hwirq = ffs(stat) - 1;
 		generic_handle_irq(irq_find_mapping(vic->domain, hwirq));
 	}
+
+	chained_irq_exit(host_chip, desc);
 }
 
 /*
