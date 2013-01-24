Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3AXLI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:08:27 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:51381 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab3AXLIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:08:19 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v3 15/71] ARC: Interrupt Handling
Date: Thu, 24 Jan 2013 16:35:55 +0530
Message-ID: <1359025589-22277-12-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This contains:
-bootup arch IRQ init: init_IRQ(), arc_init_IRQ()
-generic IRQ subsystem glue: arch_do_IRQ()
-basic IRQ chip setup for in-core intc

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arc/include/asm/arcregs.h |    3 +
 arch/arc/include/asm/hw_irq.h  |    7 +++
 arch/arc/include/asm/irq.h     |   22 ++++++++
 arch/arc/kernel/irq.c          |  107 +++++++++++++++++++++++++++++++++++++++-
 arch/arc/plat-arcfpga/irq.c    |   15 ++++++
 5 files changed, 152 insertions(+), 2 deletions(-)
 create mode 100644 arch/arc/include/asm/hw_irq.h
 create mode 100644 arch/arc/include/asm/irq.h
 create mode 100644 arch/arc/plat-arcfpga/irq.c

diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
index 8ca8faf..3fccb04 100644
--- a/arch/arc/include/asm/arcregs.h
+++ b/arch/arc/include/asm/arcregs.h
@@ -11,6 +11,9 @@
 
 #ifdef __KERNEL__
 
+/* Build Configuration Registers */
+#define ARC_REG_VECBASE_BCR	0x68
+
 /* status32 Bits Positions */
 #define STATUS_H_BIT		0	/* CPU Halted */
 #define STATUS_E1_BIT		1	/* Int 1 enable */
diff --git a/arch/arc/include/asm/hw_irq.h b/arch/arc/include/asm/hw_irq.h
new file mode 100644
index 0000000..fd565ab
--- /dev/null
+++ b/arch/arc/include/asm/hw_irq.h
@@ -0,0 +1,7 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
new file mode 100644
index 0000000..ca4aeba
--- /dev/null
+++ b/arch/arc/include/asm/irq.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_IRQ_H
+#define __ASM_ARC_IRQ_H
+
+/* Platform Independent IRQs */
+#define TIMER0_IRQ      3
+#define TIMER1_IRQ      4
+
+#include <asm-generic/irq.h>
+
+extern void __init arc_init_IRQ(void);
+extern void __init plat_init_IRQ(void);
+extern int __init get_hw_config_num_irq(void);
+
+#endif
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index c4e9b25..2f399eb 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -9,8 +9,111 @@
 
 #include <linux/interrupt.h>
 #include <linux/module.h>
-#include <asm/irqflags.h>
-#include <asm/arcregs.h>
+#include <asm/sections.h>
+#include <asm/irq.h>
+
+/*
+ * Early Hardware specific Interrupt setup
+ * -Called very early (start_kernel -> setup_arch -> setup_processor)
+ * -Platform Independent (must for any ARC700)
+ * -Needed for each CPU (hence not foldable into init_IRQ)
+ *
+ * what it does ?
+ * -setup Vector Table Base Reg - in case Linux not linked at 0x8000_0000
+ * -Disable all IRQs (on CPU side)
+ */
+void __init arc_init_IRQ(void)
+{
+	int level_mask = level_mask;
+
+	write_aux_reg(AUX_INTR_VEC_BASE, _int_vec_base_lds);
+
+	/* Disable all IRQs: enable them as devices request */
+	write_aux_reg(AUX_IENABLE, 0);
+}
+
+/*
+ * ARC700 core includes a simple on-chip intc supporting
+ * -per IRQ enable/disable
+ * -2 levels of interrupts (high/low)
+ * -all interrupts being level triggered
+ *
+ * To reduce platform code, we assume all IRQs directly hooked-up into intc.
+ * Platforms with external intc, hence cascaded IRQs, are free to over-ride
+ * below, per IRQ.
+ */
+
+static void arc_mask_irq(struct irq_data *data)
+{
+	arch_mask_irq(data->irq);
+}
+
+static void arc_unmask_irq(struct irq_data *data)
+{
+	arch_unmask_irq(data->irq);
+}
+
+static struct irq_chip onchip_intc = {
+	.name           = "ARC In-core Intc",
+	.irq_mask	= arc_mask_irq,
+	.irq_unmask	= arc_unmask_irq,
+};
+
+void __init init_onchip_IRQ(void)
+{
+	int i;
+
+	for (i = 0; i < NR_IRQS; i++)
+		irq_set_chip_and_handler(i, &onchip_intc, handle_level_irq);
+
+#ifdef CONFIG_SMP
+	irq_set_chip_and_handler(TIMER0_IRQ, &onchip_intc, handle_percpu_irq);
+#endif
+}
+
+/*
+ * Late Interrupt system init called from start_kernel for Boot CPU only
+ *
+ * Since slab must already be initialized, platforms can start doing any
+ * needed request_irq( )s
+ */
+void __init init_IRQ(void)
+{
+	init_onchip_IRQ();
+	plat_init_IRQ();
+}
+
+/*
+ * "C" Entry point for any ARC ISR, called from low level vector handler
+ * @irq is the vector number read from ICAUSE reg of on-chip intc
+ */
+void arch_do_IRQ(unsigned int irq, struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+	generic_handle_irq(irq);
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+
+int __init get_hw_config_num_irq(void)
+{
+	uint32_t val = read_aux_reg(ARC_REG_VECBASE_BCR);
+
+	switch (val & 0x03) {
+	case 0:
+		return 16;
+	case 1:
+		return 32;
+	case 2:
+		return 8;
+	default:
+		return 0;
+	}
+
+	return 0;
+}
 
 void arch_local_irq_enable(void)
 {
diff --git a/arch/arc/plat-arcfpga/irq.c b/arch/arc/plat-arcfpga/irq.c
new file mode 100644
index 0000000..ed72636
--- /dev/null
+++ b/arch/arc/plat-arcfpga/irq.c
@@ -0,0 +1,15 @@
+/*
+ * ARC FPGA Platform IRQ hookups
+ *
+ * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+
+void __init plat_init_IRQ(void)
+{
+}
-- 
1.7.4.1

