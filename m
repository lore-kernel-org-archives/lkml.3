Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaBKVIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:08:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaBKTE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:04:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ian Campbell <ijc@hellion.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.13 023/120] ARM: orion: provide C-style interrupt handler for MULTI_IRQ_HANDLER
Date: Tue, 11 Feb 2014 11:04:24 -0800
Message-Id: <20140211184824.204765321@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

commit f28d7de6bd4d41774744e011141945affa127da4 upstream.

DT-enabled Marvell Kirkwood and Dove SoCs make use of an irqchip
driver. As expected for irqchip drivers, it uses a C-style
interrupt handler and therefore selects MULTI_IRQ_HANDLER.

Now, compiling a kernel with both non-DT and DT support enabled,
selecting MULTI_IRQ_HANDLER will break ASM irq handler used by
non-DT boards.

Therefore, we provide a C-style irq handler even for non-DT boards,
if MULTI_IRQ_HANDLER is set. By installing the C-style irq handler
in orion_irq_init this is transparent to all non-DT board files.

While the regression report was filed on Marvell Kirkwood, also
Marvell Dove non-DT boards are affected and fixed by this patch.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Ian Campbell <ijc@hellion.org.uk>
Reported-by: Ian Campbell <ijc@hellion.org.uk>
Fixes: 2326f04321a9 ("ARM: kirkwood: convert to DT irqchip and clocksource")
Fixes: f07d73e33d0e ("ARM: dove: convert to DT irqchip and clocksource")
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-orion/irq.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

--- a/arch/arm/plat-orion/irq.c
+++ b/arch/arm/plat-orion/irq.c
@@ -15,8 +15,51 @@
 #include <linux/io.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <asm/exception.h>
 #include <plat/irq.h>
 #include <plat/orion-gpio.h>
+#include <mach/bridge-regs.h>
+
+#ifdef CONFIG_MULTI_IRQ_HANDLER
+/*
+ * Compiling with both non-DT and DT support enabled, will
+ * break asm irq handler used by non-DT boards. Therefore,
+ * we provide a C-style irq handler even for non-DT boards,
+ * if MULTI_IRQ_HANDLER is set.
+ *
+ * Notes:
+ * - this is prepared for Kirkwood and Dove only, update
+ *   accordingly if you add Orion5x or MV78x00.
+ * - Orion5x uses different macro names and has only one
+ *   set of CAUSE/MASK registers.
+ * - MV78x00 uses the same macro names but has a third
+ *   set of CAUSE/MASK registers.
+ *
+ */
+
+static void __iomem *orion_irq_base = IRQ_VIRT_BASE;
+
+asmlinkage void
+__exception_irq_entry orion_legacy_handle_irq(struct pt_regs *regs)
+{
+	u32 stat;
+
+	stat = readl_relaxed(orion_irq_base + IRQ_CAUSE_LOW_OFF);
+	stat &= readl_relaxed(orion_irq_base + IRQ_MASK_LOW_OFF);
+	if (stat) {
+		unsigned int hwirq = __fls(stat);
+		handle_IRQ(hwirq, regs);
+		return;
+	}
+	stat = readl_relaxed(orion_irq_base + IRQ_CAUSE_HIGH_OFF);
+	stat &= readl_relaxed(orion_irq_base + IRQ_MASK_HIGH_OFF);
+	if (stat) {
+		unsigned int hwirq = 32 + __fls(stat);
+		handle_IRQ(hwirq, regs);
+		return;
+	}
+}
+#endif
 
 void __init orion_irq_init(unsigned int irq_start, void __iomem *maskaddr)
 {
@@ -35,6 +78,10 @@ void __init orion_irq_init(unsigned int
 	ct->chip.irq_unmask = irq_gc_mask_set_bit;
 	irq_setup_generic_chip(gc, IRQ_MSK(32), IRQ_GC_INIT_MASK_CACHE,
 			       IRQ_NOREQUEST, IRQ_LEVEL | IRQ_NOPROBE);
+
+#ifdef CONFIG_MULTI_IRQ_HANDLER
+	set_handle_irq(orion_legacy_handle_irq);
+#endif
 }
 
 #ifdef CONFIG_OF


