Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbaJXIZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:25:44 -0400
Received: from mail-bn1bon0097.outbound.protection.outlook.com ([157.56.111.97]:28288
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755488AbaJXIZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:25:37 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 13/29] nios2: Interrupt handling
Date: Fri, 24 Oct 2014 16:24:15 +0800
Message-ID: <1414139071-3818-14-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(104166001)(44976005)(19580395003)(19580405001)(86362001)(93916002)(87936001)(15975445006)(68736004)(42186005)(15202345003)(6806004)(77096002)(47776003)(64706001)(102836001)(4396001)(50226001)(95666004)(88136002)(89996001)(20776003)(92726001)(85852003)(87286001)(2201001)(92566001)(107046002)(105596002)(229853001)(106466001)(31966008)(84676001)(33646002)(48376002)(50466002)(36756003)(76482002)(97736003)(77156001)(76176999)(50986999)(46102003)(99396003)(62966002)(85306004)(80022003)(120916001)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB211;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB211;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for IRQ handling.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/nios2/include/asm/irq.h      | 28 ++++++++++++
 arch/nios2/include/asm/irqflags.h | 69 +++++++++++++++++++++++++++++
 arch/nios2/kernel/irq.c           | 93 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 190 insertions(+)
 create mode 100644 arch/nios2/include/asm/irq.h
 create mode 100644 arch/nios2/include/asm/irqflags.h
 create mode 100644 arch/nios2/kernel/irq.c

diff --git a/arch/nios2/include/asm/irq.h b/arch/nios2/include/asm/irq.h
new file mode 100644
index 0000000..8e40fd9
--- /dev/null
+++ b/arch/nios2/include/asm/irq.h
@@ -0,0 +1,28 @@
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
index 0000000..560cdf6
--- /dev/null
+++ b/arch/nios2/kernel/irq.c
@@ -0,0 +1,93 @@
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
+static u32 ienable;
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
+	ienable |= (1 << d->hwirq);
+	WRCTL(CTL_IENABLE, ienable);
+}
+
+static void chip_mask(struct irq_data *d)
+{
+	ienable &= ~(1 << d->hwirq);
+	WRCTL(CTL_IENABLE, ienable);
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
+	if (!node)
+		node = of_find_compatible_node(NULL, NULL, "altr,nios2-1.1");
+
+	BUG_ON(!node);
+
+	domain = irq_domain_add_linear(node, NIOS2_CPU_NR_IRQS, &irq_ops, NULL);
+	BUG_ON(!domain);
+
+	irq_set_default_host(domain);
+	of_node_put(node);
+	/* Load the intial ienable value */
+	ienable = RDCTL(CTL_IENABLE);
+}
-- 
1.8.2.1

