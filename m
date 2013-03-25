Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688Ab3CYWlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:41:55 -0400
Received: from mout.gmx.net ([212.227.17.20]:53999 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570Ab3CYWly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:41:54 -0400
X-Authenticated: #20192376
X-Provags-ID: V01U2FsdGVkX1/Sg7A7T17SX01Njgulk1KvY2hrfkc6DJMAFz5+2i
	4Mr1r38WIFXUo0
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 1/1] irq: get_irq_disable_depth.
Date: Mon, 25 Mar 2013 23:41:35 +0100
Message-Id: <1364251295-26358-1-git-send-email-andreas.fenkart@streamunlimited.com>
X-Mailer: git-send-email 1.7.10.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used to verify invariant in omap_hsmmc, were a gpio is used to detect
sdio irqs during suspend phase. The ref count from irq_enable/irq_disable
is used to control when the irq should be effectively enabled.

                 irq en     irq dis
            ------------------------
  pm suspend  |    0     |   1
  pm default  |    1     |   2

              irq disable depth

When the sdio irq is enabled AND the module is in runtime suspend,
the ref must be zero so the irq is effectively enabled.

This function helps to verify, that the disable depth has the
right value at different driver states.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 include/linux/interrupt.h |    1 +
 kernel/irq/manage.c       |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5fa5afe..d02816b 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -219,6 +219,7 @@ extern void disable_irq(unsigned int irq);
 extern void disable_percpu_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
 extern void enable_percpu_irq(unsigned int irq, unsigned int type);
+extern int get_irq_disable_depth(unsigned int irq);
 
 /* The following three functions are for the core kernel use only. */
 #ifdef CONFIG_GENERIC_HARDIRQS
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fa17855..d151868 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -417,6 +417,23 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
+int get_irq_disable_depth(unsigned int irq)
+{
+	int depth;
+	unsigned long flags;
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags,
+						     IRQ_GET_DESC_CHECK_GLOBAL);
+
+	if (!desc)
+		return -1;
+
+	depth = desc->depth;
+
+	irq_put_desc_busunlock(desc, flags);
+	return depth;
+}
+EXPORT_SYMBOL(get_irq_disable_depth);
+
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
 	if (resume) {
-- 
1.7.10.4

