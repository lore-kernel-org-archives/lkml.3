Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaJ2D7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:59:09 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60250 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ2D7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:59:06 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH 01/11] irqchip: Allow irq_reg_{readl,writel} to use __raw_{readl_writel}
Date: Tue, 28 Oct 2014 20:58:48 -0700
Message-Id: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On big-endian systems readl/writel may perform an unwanted endian swap,
breaking generic-chip.c.  Let the platform code opt to use the __raw_
variants by selecting RAW_IRQ_ACCESSORS.

This is required in order for bcm3384 to use GENERIC_IRQ_CHIP.  Several
existing irqchip drivers also use the __raw_ accessors directly, so it
is a reasonably common requirement.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/irqchip/Kconfig |  3 +++
 include/linux/irq.h     | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b21f12f..6f0e80b 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -2,6 +2,9 @@ config IRQCHIP
 	def_bool y
 	depends on OF_IRQ
 
+config RAW_IRQ_ACCESSORS
+	bool
+
 config ARM_GIC
 	bool
 	select IRQ_DOMAIN
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 03f48d9..ed1ea8a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -639,6 +639,17 @@ void arch_teardown_hwirq(unsigned int irq);
 void irq_init_desc(unsigned int irq);
 #endif
 
+#ifdef CONFIG_RAW_IRQ_ACCESSORS
+
+#ifndef irq_reg_writel
+# define irq_reg_writel(val, addr)	__raw_writel(val, addr)
+#endif
+#ifndef irq_reg_readl
+# define irq_reg_readl(addr)		__raw_readl(addr)
+#endif
+
+#else
+
 #ifndef irq_reg_writel
 # define irq_reg_writel(val, addr)	writel(val, addr)
 #endif
@@ -646,6 +657,8 @@ void irq_init_desc(unsigned int irq);
 # define irq_reg_readl(addr)		readl(addr)
 #endif
 
+#endif
+
 /**
  * struct irq_chip_regs - register offsets for struct irq_gci
  * @enable:	Enable register offset to reg_base
-- 
2.1.1

