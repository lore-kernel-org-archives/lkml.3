Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbaEPNfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:35:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaEPNe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:34:58 -0400
Date: Fri, 16 May 2014 06:34:07 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-54859f59fc18e5c104a4095420b3fcef8bc3ae63@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <20140507154336.760446122@linutronix.de>
References: <20140507154336.760446122@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: Remove create/destroy_irq()
Git-Commit-ID: 54859f59fc18e5c104a4095420b3fcef8bc3ae63
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54859f59fc18e5c104a4095420b3fcef8bc3ae63
Gitweb:     http://git.kernel.org/tip/54859f59fc18e5c104a4095420b3fcef8bc3ae63
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:12 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:20 +0200

x86: Remove create/destroy_irq()

No more users. Remove the cruft

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20140507154336.760446122@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 106 +----------------------------------------
 include/linux/irq.h            |   4 --
 2 files changed, 1 insertion(+), 109 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index be3b574..efda2f6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -281,18 +281,6 @@ static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 	return cfg;
 }
 
-static int alloc_irqs_from(unsigned int from, unsigned int count, int node)
-{
-	return irq_alloc_descs_from(from, count, node);
-}
-
-static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
-{
-	free_irq_cfg(at, cfg);
-	irq_free_desc(at);
-}
-
-
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -2916,100 +2904,8 @@ static int __init ioapic_init_ops(void)
 device_initcall(ioapic_init_ops);
 
 /*
- * Dynamic irq allocate and deallocation
+ * Dynamic irq allocate and deallocation. Should be replaced by irq domains!
  */
-unsigned int __create_irqs(unsigned int from, unsigned int count, int node)
-{
-	struct irq_cfg **cfg;
-	unsigned long flags;
-	int irq, i;
-
-	if (from < nr_irqs_gsi)
-		from = nr_irqs_gsi;
-
-	cfg = kzalloc_node(count * sizeof(cfg[0]), GFP_KERNEL, node);
-	if (!cfg)
-		return 0;
-
-	irq = alloc_irqs_from(from, count, node);
-	if (irq < 0)
-		goto out_cfgs;
-
-	for (i = 0; i < count; i++) {
-		cfg[i] = alloc_irq_cfg(irq + i, node);
-		if (!cfg[i])
-			goto out_irqs;
-	}
-
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	for (i = 0; i < count; i++)
-		if (__assign_irq_vector(irq + i, cfg[i], apic->target_cpus()))
-			goto out_vecs;
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-
-	for (i = 0; i < count; i++) {
-		irq_set_chip_data(irq + i, cfg[i]);
-		irq_clear_status_flags(irq + i, IRQ_NOREQUEST);
-	}
-
-	kfree(cfg);
-	return irq;
-
-out_vecs:
-	for (i--; i >= 0; i--)
-		__clear_irq_vector(irq + i, cfg[i]);
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-out_irqs:
-	for (i = 0; i < count; i++)
-		free_irq_at(irq + i, cfg[i]);
-out_cfgs:
-	kfree(cfg);
-	return 0;
-}
-
-unsigned int create_irq_nr(unsigned int from, int node)
-{
-	return __create_irqs(from, 1, node);
-}
-
-int create_irq(void)
-{
-	int node = cpu_to_node(0);
-	unsigned int irq_want;
-	int irq;
-
-	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want, node);
-
-	if (irq == 0)
-		irq = -1;
-
-	return irq;
-}
-
-void destroy_irq(unsigned int irq)
-{
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
-	unsigned long flags;
-
-	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
-
-	free_remapped_irq(irq);
-
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq, cfg);
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-	free_irq_at(irq, cfg);
-}
-
-void destroy_irqs(unsigned int irq, unsigned int count)
-{
-	unsigned int i;
-
-	for (i = 0; i < count; i++)
-		destroy_irq(irq + i);
-}
-
 int arch_setup_hwirq(unsigned int irq, int node)
 {
 	struct irq_cfg *cfg;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index c75dd16..7549ed5 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -526,12 +526,8 @@ static inline void irq_set_percpu_devid_flags(unsigned int irq)
 }
 
 /* Handle dynamic irq creation and destruction */
-extern unsigned int create_irq_nr(unsigned int irq_want, int node);
-extern unsigned int __create_irqs(unsigned int from, unsigned int count,
-				  int node);
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
-extern void destroy_irqs(unsigned int irq, unsigned int count);
 
 /*
  * Dynamic irq helper functions. Obsolete. Use irq_alloc_desc* and
