Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934423AbaHZKDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:03:53 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20515 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934266AbaHZKDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:03:49 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux@openrisc.net
Cc: linux@arm.linux.org.uk, shawn.guo@freescale.com, kernel@pengutronix.de,
        tony@atomide.com, catalin.marinas@arm.com, will.deacon@arm.com,
        jonas@southpole.se, tglx@linutronix.de, jason@lakedaemon.net,
        shc_work@mail.ru, baohua@kernel.org, maxime.ripard@free-electrons.com,
        marc.zyngier@arm.com, khilman@linaro.org, sboyd@codeaurora.org,
        lorenzo.pieralisi@arm.com, larry.bassel@linaro.org,
        mark.rutland@arm.com, sudeep.holla@arm.com,
        stefan.kristiansson@saunalahti.fi, vkale@apm.com,
        schwidefsky@de.ibm.com, Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v2 01/26] genirq: add irq_domain-aware core IRQ handler
Date: Tue, 26 Aug 2014 11:03:16 +0100
Message-Id: <1409047421-27649-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling irq_find_mapping from outside a irq_{enter,exit} section is
unsafe and produces ugly messages if CONFIG_PROVE_RCU is enabled:
If coming from the idle state, the rcu_read_lock call in irq_find_mapping
will generate an unpleasant warning:

<quote>
===============================
[ INFO: suspicious RCU usage. ]
3.16.0-rc1+ #135 Not tainted
-------------------------------
include/linux/rcupdate.h:871 rcu_read_lock() used illegally while idle!

other info that might help us debug this:

RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 0
RCU used illegally from extended quiescent state!
1 lock held by swapper/0/0:
 #0:  (rcu_read_lock){......}, at: [<ffffffc00010206c>]
irq_find_mapping+0x4c/0x198
</quote>

As this issue is fairly widespread and involves at least three
different architectures, a possible solution is to add a new
handle_domain_irq entry point into the generic IRQ code that
the interrupt controller code can call.

This new function takes an irq_domain, and calls into irq_find_domain
inside the irq_{enter,exit} block. An additional "lookup" parameter is
used to allow non-domain architecture code to be replaced by this as well.

Interrupt controllers can then be updated to use the new mechanism.

This code is sitting behind a new CONFIG_HANDLE_DOMAIN_IRQ, as not all
architectures implement set_irq_regs (yes, mn10300, I'm looking at you...).

Reported-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqdesc.h | 19 +++++++++++++++++++
 kernel/irq/Kconfig      |  3 +++
 kernel/irq/irqdesc.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 472c021..ff24667 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -12,6 +12,8 @@ struct irq_affinity_notify;
 struct proc_dir_entry;
 struct module;
 struct irq_desc;
+struct irq_domain;
+struct pt_regs;
 
 /**
  * struct irq_desc - interrupt descriptor
@@ -118,6 +120,23 @@ static inline void generic_handle_irq_desc(unsigned int irq, struct irq_desc *de
 
 int generic_handle_irq(unsigned int irq);
 
+#ifdef CONFIG_HANDLE_DOMAIN_IRQ
+/*
+ * Convert a HW interrupt number to a logical one using a IRQ domain,
+ * and handle the result interrupt number. Return -EINVAL if
+ * conversion failed. Providing a NULL domain indicates that the
+ * conversion has already been done.
+ */
+int __handle_domain_irq(struct irq_domain *domain, unsigned int hwirq,
+			bool lookup, struct pt_regs *regs);
+
+static inline int handle_domain_irq(struct irq_domain *domain,
+				    unsigned int hwirq, struct pt_regs *regs)
+{
+	return __handle_domain_irq(domain, hwirq, true, regs);
+}
+#endif
+
 /* Test to see if a driver has successfully requested an irq */
 static inline int irq_has_action(unsigned int irq)
 {
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index d269cec..225086b 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -55,6 +55,9 @@ config GENERIC_IRQ_CHIP
 config IRQ_DOMAIN
 	bool
 
+config HANDLE_DOMAIN_IRQ
+	bool
+
 config IRQ_DOMAIN_DEBUG
 	bool "Expose hardware/virtual IRQ mapping via debugfs"
 	depends on IRQ_DOMAIN && DEBUG_FS
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 1487a12..a1782f8 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -14,6 +14,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/radix-tree.h>
 #include <linux/bitmap.h>
+#include <linux/irqdomain.h>
 
 #include "internals.h"
 
@@ -336,6 +337,47 @@ int generic_handle_irq(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(generic_handle_irq);
 
+#ifdef CONFIG_HANDLE_DOMAIN_IRQ
+/**
+ * __handle_domain_irq - Invoke the handler for a HW irq belonging to a domain
+ * @domain:	The domain where to perform the lookup
+ * @hwirq:	The HW irq number to convert to a logical one
+ * @lookup:	Whether to perform the domain lookup or not
+ * @regs:	Register file coming from the low-level handling code
+ *
+ * Returns:	0 on success, or -EINVAL if conversion has failed
+ */
+int __handle_domain_irq(struct irq_domain *domain, unsigned int hwirq,
+			bool lookup, struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	unsigned int irq = hwirq;
+	int ret = 0;
+
+	irq_enter();
+
+#ifdef CONFIG_IRQ_DOMAIN
+	if (lookup)
+		irq = irq_find_mapping(domain, hwirq);
+#endif
+
+	/*
+	 * Some hardware gives randomly wrong interrupts.  Rather
+	 * than crashing, do something sensible.
+	 */
+	if (unlikely(!irq || irq >= nr_irqs)) {
+		ack_bad_irq(irq);
+		ret = -EINVAL;
+	} else {
+		generic_handle_irq(irq);
+	}
+
+	irq_exit();
+	set_irq_regs(old_regs);
+	return ret;
+}
+#endif
+
 /* Dynamic interrupt handling */
 
 /**
-- 
2.0.4

