Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbaEPNdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:33:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaEPNdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:33:01 -0400
Date: Fri, 16 May 2014 06:31:47 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-7b6ef1262549f6afc5c881aaef80beb8fd15f908@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        cmetcalf@tilera.com, tony.luck@intel.com, fenghua.yu@intel.com,
        tglx@linutronix.de
In-Reply-To: <20140507154334.208629358@linutronix.de>
References: <20140507154334.208629358@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide generic hwirq allocation facility
Git-Commit-ID: 7b6ef1262549f6afc5c881aaef80beb8fd15f908
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

Commit-ID:  7b6ef1262549f6afc5c881aaef80beb8fd15f908
Gitweb:     http://git.kernel.org/tip/7b6ef1262549f6afc5c881aaef80beb8fd15f908
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:05 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:18 +0200

genirq: Provide generic hwirq allocation facility

Not really the solution to the problem, but at least it confines the
mess in the core code and allows to get rid of the create/destroy_irq
variants from hell, i.e. 3 implementations with different semantics
plus the x86 specific variants __create_irqs and create_irq_nr
which have been invented in another circle of hell.

x86 : x86 should be converted to irq domains and I'm deliberately
      making it impossible to do the multi-vector MSI support by
      adding more crap to the current mess. It's not that hard to do
      and I'm really tired of the trainwrecks which have been invented
      by baindaid engineering so far. Any attempt to do multi-vector
      MSI or ioapic hotplug without converting to irq domains is NAKed
      hereby.

tile: Might use irq domains as well, but it has a very limited
      interrupt space, so handling it via this functionality might be
      the right thing to do even in the long run.

ia64: That's an hopeless case, as I doubt that anyone has the stomach
      to rewrite the homebrewn dynamic allocation facilities. I stared
      at it for a couple of hours and gave up. The create/destroy_irq
      mess could be made private to itanic right away if there
      wouldn't be the iommu/dmar driver being shared with x86. So to
      do that I'm going to add a separate ia64 specific implementation
      later in order not to deep-six itanic right away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20140507154334.208629358@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/irq.h  | 15 +++++++++++++++
 kernel/irq/Kconfig   |  5 +++++
 kernel/irq/irqdesc.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 5c57efb..c75dd16 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -637,6 +637,21 @@ static inline int irq_reserve_irq(unsigned int irq)
 	return irq_reserve_irqs(irq, 1);
 }
 
+#ifdef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
+unsigned int irq_alloc_hwirqs(int cnt, int node);
+static inline unsigned int irq_alloc_hwirq(int node)
+{
+	return irq_alloc_hwirqs(1, node);
+}
+void irq_free_hwirqs(unsigned int from, int cnt);
+static inline void irq_free_hwirq(unsigned int irq)
+{
+	return irq_free_hwirqs(irq, 1);
+}
+int arch_setup_hwirq(unsigned int irq, int node);
+void arch_teardown_hwirq(unsigned int irq);
+#endif
+
 #ifndef irq_reg_writel
 # define irq_reg_writel(val, addr)	writel(val, addr)
 #endif
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 07cbdfe..a83f10e 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -17,6 +17,11 @@ config GENERIC_IRQ_SHOW
 config GENERIC_IRQ_SHOW_LEVEL
        bool
 
+# Facility to allocate a hardware interrupt. This is legacy support
+# and should not be used in new code. Use irq domains instead.
+config GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
+       bool
+
 # Support for delayed migration from interrupt context
 config GENERIC_PENDING_IRQ
 	bool
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index bb07f29..f388ade 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -396,6 +396,57 @@ err:
 }
 EXPORT_SYMBOL_GPL(__irq_alloc_descs);
 
+#ifdef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
+/**
+ * irq_alloc_hwirqs - Allocate an irq descriptor and initialize the hardware
+ * @cnt:	number of interrupts to allocate
+ * @node:	node on which to allocate
+ *
+ * Returns an interrupt number > 0 or 0, if the allocation fails.
+ */
+unsigned int irq_alloc_hwirqs(int cnt, int node)
+{
+	int i, irq = __irq_alloc_descs(-1, 0, cnt, node, NULL);
+
+	if (irq < 0)
+		return 0;
+
+	for (i = irq; cnt > 0; i++, cnt--) {
+		if (arch_setup_hwirq(i, node))
+			goto err;
+		irq_clear_status_flags(i, _IRQ_NOREQUEST);
+	}
+	return irq;
+
+err:
+	for (i--; i >= irq; i--) {
+		irq_set_status_flags(i, _IRQ_NOREQUEST | _IRQ_NOPROBE);
+		arch_teardown_hwirq(i);
+	}
+	irq_free_descs(irq, cnt);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_alloc_hwirqs);
+
+/**
+ * irq_free_hwirqs - Free irq descriptor and cleanup the hardware
+ * @from:	Free from irq number
+ * @cnt:	number of interrupts to free
+ *
+ */
+void irq_free_hwirqs(unsigned int from, int cnt)
+{
+	int i;
+
+	for (i = from; cnt > 0; i++, cnt--) {
+		irq_set_status_flags(i, _IRQ_NOREQUEST | _IRQ_NOPROBE);
+		arch_teardown_hwirq(i);
+	}
+	irq_free_descs(from, cnt);
+}
+EXPORT_SYMBOL_GPL(irq_free_hwirqs);
+#endif
+
 /**
  * irq_reserve_irqs - mark irqs allocated
  * @from:	mark from irq number
