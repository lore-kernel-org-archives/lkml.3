Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731AbaEFBfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:35:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29224 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933643AbaEFBeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:34:02 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: [PATCH v3 4/8] s390: Mark bits in allocated_irqs in general code
Date: Mon,  5 May 2014 18:33:22 -0700
Message-Id: <1399340006-31550-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
References: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second irq_reserve_irqs calling is from arch s390, and
s390 does not use SPARSE_IRQ yet.

We could set bits for legacy bits early in !SPARSE_IRQ version
early_irq_init() directly instead of calling irq_reserve_irqs later.

Adding weak version arch_proble_early_allocate_nr_irqs() for
!SPARESE_IRQ, and let s390 to have specific version to
pass correct irq number that need to be marked in allocated_irqs.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
---
 arch/s390/kernel/irq.c |  6 +++++-
 include/linux/irq.h    |  1 +
 kernel/irq/irqdesc.c   | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index c7463aa..47e29be 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -90,9 +90,13 @@ static const struct irq_class irqclass_sub_desc[NR_ARCH_IRQS] = {
 	[CPU_RST]    = {.name = "RST", .desc = "[CPU] CPU Restart"},
 };
 
+int arch_probe_early_allocate_nr_irqs(void)
+{
+	return THIN_INTERRUPT;
+}
+
 void __init init_IRQ(void)
 {
-	irq_reserve_irqs(0, THIN_INTERRUPT);
 	init_cio_interrupts();
 	init_airq_interrupts();
 	init_ext_interrupts();
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 10a0b1a..28cbd3e 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -624,6 +624,7 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 
 void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
+int arch_probe_early_allocate_nr_irqs(void);
 
 static inline void irq_free_desc(unsigned int irq)
 {
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index a7174617..dfb971c 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -248,10 +248,16 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	}
 };
 
+int __weak arch_probe_early_allocate_nr_irqs(void)
+{
+	return 0;
+}
+
 int __init early_irq_init(void)
 {
 	int count, i, node = first_online_node;
 	struct irq_desc *desc;
+	int nr = arch_probe_early_allocate_nr_irqs();
 
 	init_irq_default_affinity();
 
@@ -267,6 +273,10 @@ int __init early_irq_init(void)
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		desc_set_defaults(i, &desc[i], node, NULL);
 	}
+
+	for (i = 0; i < nr; i++)
+		set_bit(i, allocated_irqs);
+
 	return arch_early_irq_init();
 }
 
-- 
1.8.4.5

