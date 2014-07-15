Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbaGOIsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:48:25 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:54743
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758138AbaGOIsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:48:21 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v2 12/29] nios2: Interrupt handling
Date: Tue, 15 Jul 2014 16:45:39 +0800
Message-ID: <1405413956-2772-13-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405413956-2772-1-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(15202345003)(50226001)(93916002)(21056001)(86362001)(92566001)(81342001)(47776003)(15975445006)(95666004)(87936001)(83322001)(44976005)(68736004)(4396001)(19580395003)(76176999)(88136002)(50986999)(87286001)(33646002)(2201001)(36756003)(6806004)(85306003)(102836001)(105596002)(31966008)(106466001)(62966002)(77982001)(80022001)(42186005)(74502001)(92726001)(81542001)(79102001)(19580405001)(85852003)(64706001)(48376002)(84676001)(89996001)(20776003)(83072002)(97736001)(104166001)(74662001)(99396002)(77096002)(76482001)(107046002)(77156001)(46102001)(229853001)(2004002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB040;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for IRQ handling.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/irq.h      | 34 +++++++++++++++
 arch/nios2/include/asm/irqflags.h | 69 ++++++++++++++++++++++++++++++
 arch/nios2/kernel/irq.c           | 90 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 193 insertions(+)
 create mode 100644 arch/nios2/include/asm/irq.h
 create mode 100644 arch/nios2/include/asm/irqflags.h
 create mode 100644 arch/nios2/kernel/irq.c

diff --git a/arch/nios2/include/asm/irq.h b/arch/nios2/include/asm/irq.h
new file mode 100644
index 0000000..f7e94b9
--- /dev/null
+++ b/arch/nios2/include/asm/irq.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#ifndef _ASM_NIOS2_IRQ_H
+#define _ASM_NIOS2_IRQ_H
+
+#define NIOS2_CPU_NR_IRQS	32
+/* Reserve 32 additional interrupts for GPIO IRQs */
+#define NR_IRQS			(NIOS2_CPU_NR_IRQS + 32)
+
+#ifndef NO_IRQ
+#define NO_IRQ			(-1)
+#endif
+
+#include <asm-generic/irq.h>
+#include <linux/irqdomain.h>
+
+#endif
diff --git a/arch/nios2/include/asm/irqflags.h b/arch/nios2/include/asm/irqflags.h
new file mode 100644
index 0000000..e91f4f0
--- /dev/null
+++ b/arch/nios2/include/asm/irqflags.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2010 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#ifndef _ASM_IRQFLAGS_H
+#define _ASM_IRQFLAGS_H
+
+#include <asm/registers.h>
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	return RDCTL(CTL_STATUS);
+}
+
+/*
+ * This will restore ALL status register flags, not only the interrupt
+ * mask flag.
+ */
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	WRCTL(CTL_STATUS, flags);
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	unsigned long flags;
+	flags = arch_local_save_flags();
+	arch_local_irq_restore(flags & ~STATUS_PIE);
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	unsigned long flags;
+	flags = arch_local_save_flags();
+	arch_local_irq_restore(flags | STATUS_PIE);
+}
+
+static inline int arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & STATUS_PIE) == 0;
+}
+
+static inline int arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+	flags = arch_local_save_flags();
+	arch_local_irq_restore(flags & ~STATUS_PIE);
+	return flags;
+}
+
+#endif /* _ASM_IRQFLAGS_H */
diff --git a/arch/nios2/kernel/irq.c b/arch/nios2/kernel/irq.c
new file mode 100644
index 0000000..8770d50
--- /dev/null
+++ b/arch/nios2/kernel/irq.c
@@ -0,0 +1,90 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2008 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * based on irq.c from m68k which is:
+ *
+ * Copyright (C) 2007 Greg Ungerer <gerg@snapgear.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+
+asmlinkage void do_IRQ(int hwirq, struct pt_regs *regs)
+{
+	struct pt_regs *oldregs = set_irq_regs(regs);
+	int irq;
+
+	irq_enter();
+	irq = irq_find_mapping(NULL, hwirq);
+	generic_handle_irq(irq);
+	irq_exit();
+
+	set_irq_regs(oldregs);
+}
+
+static void chip_unmask(struct irq_data *d)
+{
+	u32 ien;
+	ien = RDCTL(CTL_IENABLE);
+	ien |= (1 << d->hwirq);
+	WRCTL(CTL_IENABLE, ien);
+}
+
+static void chip_mask(struct irq_data *d)
+{
+	u32 ien;
+	ien = RDCTL(CTL_IENABLE);
+	ien &= ~(1 << d->hwirq);
+	WRCTL(CTL_IENABLE, ien);
+}
+
+static struct irq_chip m_irq_chip = {
+	.name		= "NIOS2-INTC",
+	.irq_unmask	= chip_unmask,
+	.irq_mask	= chip_mask,
+};
+
+static int irq_map(struct irq_domain *h, unsigned int virq,
+				irq_hw_number_t hw_irq_num)
+{
+	irq_set_chip_and_handler(virq, &m_irq_chip, handle_level_irq);
+
+	return 0;
+}
+
+static struct irq_domain_ops irq_ops = {
+	.map	= irq_map,
+	.xlate	= irq_domain_xlate_onecell,
+};
+
+void __init init_IRQ(void)
+{
+	struct irq_domain *domain;
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "altr,nios2-1.0");
+	BUG_ON(!node);
+
+	domain = irq_domain_add_linear(node, NIOS2_CPU_NR_IRQS, &irq_ops, NULL);
+	BUG_ON(!domain);
+
+	irq_set_default_host(domain);
+	of_node_put(node);
+}
-- 
1.8.2.1

