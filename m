Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbaIOXwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:52:00 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:49827 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172AbaIOXvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:38 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/24] MIPS: i8259: Use IRQ domains
Date: Mon, 15 Sep 2014 16:51:08 -0700
Message-Id: <1410825087-5497-6-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a legacy IRQ domain for the 16 i8259 interrupts.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/Kconfig        |  1 +
 arch/mips/kernel/i8259.c | 24 +++++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 9fc335c..de72c92 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -971,6 +971,7 @@ config SYS_SUPPORTS_HOTPLUG_CPU
 
 config I8259
 	bool
+	select IRQ_DOMAIN
 
 config MIPS_BONITO64
 	bool
diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
index 50b3648..a74ec3a 100644
--- a/arch/mips/kernel/i8259.c
+++ b/arch/mips/kernel/i8259.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/syscore_ops.h>
@@ -308,6 +309,19 @@ static struct resource pic2_io_resource = {
 	.flags = IORESOURCE_BUSY
 };
 
+static int i8259A_irq_domain_map(struct irq_domain *d, unsigned int virq,
+				 irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(virq, &i8259A_chip, handle_level_irq);
+	irq_set_probe(virq);
+	return 0;
+}
+
+static struct irq_domain_ops i8259A_ops = {
+	.map = i8259A_irq_domain_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
 /*
  * On systems with i8259-style interrupt controllers we assume for
  * driver compatibility reasons interrupts 0 - 15 to be the i8259
@@ -315,17 +329,17 @@ static struct resource pic2_io_resource = {
  */
 void __init init_i8259_irqs(void)
 {
-	int i;
+	struct irq_domain *domain;
 
 	insert_resource(&ioport_resource, &pic1_io_resource);
 	insert_resource(&ioport_resource, &pic2_io_resource);
 
 	init_8259A(0);
 
-	for (i = I8259A_IRQ_BASE; i < I8259A_IRQ_BASE + 16; i++) {
-		irq_set_chip_and_handler(i, &i8259A_chip, handle_level_irq);
-		irq_set_probe(i);
-	}
+	domain = irq_domain_add_legacy(NULL, 16, I8259A_IRQ_BASE, 0,
+				       &i8259A_ops, NULL);
+	if (!domain)
+		panic("Failed to add i8259 IRQ domain");
 
 	setup_irq(I8259A_IRQ_BASE + PIC_CASCADE_IR, &irq2);
 }
-- 
2.1.0.rc2.206.gedb03e5

