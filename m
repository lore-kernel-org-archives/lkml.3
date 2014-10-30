Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbaJ3CTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:19:53 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44875 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbaJ3CTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:19:48 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: arnd@arndb.de, f.fainelli@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org, lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: [PATCH V2 06/15] genirq: Generic chip: Optimize for fixed-endian systems
Date: Wed, 29 Oct 2014 19:17:59 -0700
Message-Id: <1414635488-14137-7-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the compiler to inline an LE MMIO access if the configuration only
supports LE registers, or a BE MMIO access if the configuration only
supports BE registers.  If the configuration supports both (possibly
a multiplatform kernel) then make the decision at runtime.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 kernel/irq/Kconfig        |  5 +++++
 kernel/irq/Makefile       |  1 +
 kernel/irq/generic-chip.c | 10 +++++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 225086b..6283c8c 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -51,6 +51,11 @@ config GENERIC_IRQ_CHIP
        bool
        select IRQ_DOMAIN
 
+# Same as above, but use big-endian MMIO accesses
+config GENERIC_IRQ_CHIP_BE
+       bool
+       select IRQ_DOMAIN
+
 # Generic irq_domain hw <--> linux irq number translation
 config IRQ_DOMAIN
 	bool
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index fff1738..34c2b0f 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -1,6 +1,7 @@
 
 obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o
 obj-$(CONFIG_GENERIC_IRQ_CHIP) += generic-chip.o
+obj-$(CONFIG_GENERIC_IRQ_CHIP_BE) += generic-chip.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_IRQ_DOMAIN) += irqdomain.o
 obj-$(CONFIG_PROC_FS) += proc.o
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index c1890bb..457ea48 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -9,6 +9,7 @@
 #include <linux/export.h>
 #include <linux/irqdomain.h>
 #include <linux/interrupt.h>
+#include <linux/kconfig.h>
 #include <linux/kernel_stat.h>
 #include <linux/syscore_ops.h>
 
@@ -19,7 +20,14 @@ static DEFINE_RAW_SPINLOCK(gc_lock);
 
 static int is_big_endian(struct irq_chip_generic *gc)
 {
-	return !!(gc->domain->gc->gc_flags & IRQ_GC_BE_IO);
+	if (IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP) &&
+	    !IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE))
+		return 0;
+	else if (IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP_BE) &&
+		 !IS_ENABLED(CONFIG_GENERIC_IRQ_CHIP))
+		return 1;
+	else
+		return !!(gc->domain->gc->gc_flags & IRQ_GC_BE_IO);
 }
 
 static void irq_reg_writel(struct irq_chip_generic *gc,
-- 
2.1.1

