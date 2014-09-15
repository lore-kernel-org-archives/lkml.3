Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbaIOXvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:51:37 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:49957 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaIOXvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:35 -0400
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
Subject: [PATCH 01/24] MIPS: Always use IRQ domains for CPU IRQs
Date: Mon, 15 Sep 2014 16:51:04 -0700
Message-Id: <1410825087-5497-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an IRQ domain for the 8 CPU IRQs in both the DT and non-DT cases.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/Kconfig          |  1 +
 arch/mips/kernel/irq_cpu.c | 36 +++++++++++-------------------------
 2 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 900c7e5..9fc335c 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1051,6 +1051,7 @@ config MIPS_HUGE_TLB_SUPPORT
 
 config IRQ_CPU
 	bool
+	select IRQ_DOMAIN
 
 config IRQ_CPU_RM7K
 	bool
diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
index e498f2b..b097f7d 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -94,28 +94,6 @@ static struct irq_chip mips_mt_cpu_irq_controller = {
 	.irq_eoi	= unmask_mips_irq,
 };
 
-void __init mips_cpu_irq_init(void)
-{
-	int irq_base = MIPS_CPU_IRQ_BASE;
-	int i;
-
-	/* Mask interrupts. */
-	clear_c0_status(ST0_IM);
-	clear_c0_cause(CAUSEF_IP);
-
-	/* Software interrupts are used for MT/CMT IPI */
-	for (i = irq_base; i < irq_base + 2; i++)
-		irq_set_chip_and_handler(i, cpu_has_mipsmt ?
-					 &mips_mt_cpu_irq_controller :
-					 &mips_cpu_irq_controller,
-					 handle_percpu_irq);
-
-	for (i = irq_base + 2; i < irq_base + 8; i++)
-		irq_set_chip_and_handler(i, &mips_cpu_irq_controller,
-					 handle_percpu_irq);
-}
-
-#ifdef CONFIG_IRQ_DOMAIN
 static int mips_cpu_intc_map(struct irq_domain *d, unsigned int irq,
 			     irq_hw_number_t hw)
 {
@@ -138,8 +116,7 @@ static const struct irq_domain_ops mips_cpu_intc_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
-int __init mips_cpu_intc_init(struct device_node *of_node,
-			      struct device_node *parent)
+static void __init __mips_cpu_irq_init(struct device_node *of_node)
 {
 	struct irq_domain *domain;
 
@@ -151,7 +128,16 @@ int __init mips_cpu_intc_init(struct device_node *of_node,
 				       &mips_cpu_intc_irq_domain_ops, NULL);
 	if (!domain)
 		panic("Failed to add irqdomain for MIPS CPU");
+}
+
+void __init mips_cpu_irq_init(void)
+{
+	__mips_cpu_irq_init(NULL);
+}
 
+int __init mips_cpu_intc_init(struct device_node *of_node,
+			      struct device_node *parent)
+{
+	__mips_cpu_irq_init(of_node);
 	return 0;
 }
-#endif /* CONFIG_IRQ_DOMAIN */
-- 
2.1.0.rc2.206.gedb03e5

