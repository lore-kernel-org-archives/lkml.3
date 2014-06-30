Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaF3I6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:58:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56756 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaF3I6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:58:16 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: [PATCH v7 1/4] arm: fiq: Add callbacks to manage FIQ routings
Date: Mon, 30 Jun 2014 09:53:08 +0100
Message-Id: <1404118391-3850-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
References: <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org>
 <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently enable_fiq/disable_fiq use a simple offset to convert an IRQ
virq into a FIQ virq. This is too inflexible for multi-platform kernels
and makes runtime error checking impossible.

We solve this by introducing a flexible mapping that allows interrupt
controllers that support FIQ to register those mappings. This, in turn,
makes it much possible for drivers in DT kernels to install FIQ handlers
without knowing anything about the interrupt controller.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/include/asm/fiq.h |   8 ++++
 arch/arm/kernel/fiq.c      | 103 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/fiq.h b/arch/arm/include/asm/fiq.h
index d493d0b..ed44528 100644
--- a/arch/arm/include/asm/fiq.h
+++ b/arch/arm/include/asm/fiq.h
@@ -16,8 +16,14 @@
 #ifndef __ASM_FIQ_H
 #define __ASM_FIQ_H
 
+#include <linux/irq.h>
 #include <asm/ptrace.h>
 
+struct fiq_chip {
+	void (*fiq_enable)(struct irq_data *data);
+	void (*fiq_disable)(struct irq_data *data);
+};
+
 struct fiq_handler {
 	struct fiq_handler *next;
 	/* Name
@@ -38,6 +44,8 @@ extern void release_fiq(struct fiq_handler *f);
 extern void set_fiq_handler(void *start, unsigned int length);
 extern void enable_fiq(int fiq);
 extern void disable_fiq(int fiq);
+extern bool has_fiq(int fiq);
+extern void fiq_register_mapping(int irq, struct fiq_chip *chip);
 
 /* helpers defined in fiqasm.S: */
 extern void __set_fiq_regs(unsigned long const *regs);
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 918875d..5d831cf 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -40,6 +40,9 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/seq_file.h>
+#include <linux/irq.h>
+#include <linux/radix-tree.h>
+#include <linux/slab.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
@@ -52,7 +55,15 @@
 		(unsigned)&vector_fiq_offset;		\
 	})
 
+struct fiq_data {
+	struct fiq_chip *fiq_chip;
+	struct irq_data *irq_data;
+};
+
 static unsigned long no_fiq_insn;
+static int fiq_start = -1;
+static RADIX_TREE(fiq_data_tree, GFP_KERNEL);
+static DEFINE_MUTEX(fiq_data_mutex);
 
 /* Default reacquire function
  * - we always relinquish FIQ control
@@ -127,18 +138,65 @@ void release_fiq(struct fiq_handler *f)
 	while (current_fiq->fiq_op(current_fiq->dev_id, 0));
 }
 
-static int fiq_start;
+static struct fiq_data *lookup_fiq_data(int fiq)
+{
+	struct fiq_data *data;
+
+	rcu_read_lock();
+	data = radix_tree_lookup(&fiq_data_tree, fiq);
+	rcu_read_unlock();
+
+	return data;
+}
 
 void enable_fiq(int fiq)
 {
+	struct fiq_data *data = lookup_fiq_data(fiq);
+
+	if (data) {
+		if (data->fiq_chip->fiq_enable)
+			data->fiq_chip->fiq_enable(data->irq_data);
+		enable_irq(fiq);
+		return;
+	}
+
+	if (WARN_ON(fiq_start == -1))
+		return;
+
 	enable_irq(fiq + fiq_start);
 }
 
 void disable_fiq(int fiq)
 {
+	struct fiq_data *data = lookup_fiq_data(fiq);
+
+	if (data) {
+		if (data->fiq_chip->fiq_disable)
+			data->fiq_chip->fiq_disable(data->irq_data);
+		disable_irq(fiq);
+		return;
+	}
+
+	if (WARN_ON(fiq_start == -1))
+		return;
+
 	disable_irq(fiq + fiq_start);
 }
 
+bool has_fiq(int fiq)
+{
+	struct fiq_data *data = lookup_fiq_data(fiq);
+
+	if (data)
+		return true;
+
+	if (fiq_start == -1)
+		return false;
+
+	return fiq >= fiq_start;
+}
+EXPORT_SYMBOL(has_fiq);
+
 EXPORT_SYMBOL(set_fiq_handler);
 EXPORT_SYMBOL(__set_fiq_regs);	/* defined in fiqasm.S */
 EXPORT_SYMBOL(__get_fiq_regs);	/* defined in fiqasm.S */
@@ -147,9 +205,50 @@ EXPORT_SYMBOL(release_fiq);
 EXPORT_SYMBOL(enable_fiq);
 EXPORT_SYMBOL(disable_fiq);
 
+/*
+ * Add a mapping from a Linux irq to the fiq data.
+ */
+void fiq_register_mapping(int irq, struct fiq_chip *chip)
+{
+	struct fiq_data *fiq_data = NULL;
+	int res;
+
+	/* fiq_register_mapping can't be mixed with init_FIQ */
+	BUG_ON(fiq_start != -1);
+
+	fiq_data = kmalloc(sizeof(*fiq_data), GFP_KERNEL);
+	if (!fiq_data)
+		goto err;
+
+	fiq_data->fiq_chip = chip;
+	fiq_data->irq_data = irq_get_irq_data(irq);
+	BUG_ON(!fiq_data->irq_data);
+
+	mutex_lock(&fiq_data_mutex);
+	res = radix_tree_insert(&fiq_data_tree, irq, fiq_data);
+	mutex_unlock(&fiq_data_mutex);
+	if (res)
+		goto err;
+
+	return;
+
+err:
+	kfree(fiq_data);
+	pr_err("fiq: Cannot register mapping %d\n", irq);
+}
+
+/*
+ * Set the offset between normal IRQs and their FIQ shadows.
+ */
 void __init init_FIQ(int start)
 {
+	fiq_start = start;
+}
+
+static int __init init_default_fiq_handler(void)
+{
 	unsigned offset = FIQ_OFFSET;
 	no_fiq_insn = *(unsigned long *)(0xffff0000 + offset);
-	fiq_start = start;
+	return 0;
 }
+pure_initcall(init_default_fiq_handler);
-- 
1.9.3

