Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab3FFHnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:43:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:29559 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab3FFHna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:43:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,813,1363158000"; 
   d="scan'208";a="325105121"
From: shuox.liu@intel.com
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, gregkh@linuxfoundation.org, fweisbec@gmail.com,
        sedat.dilek@gmail.com, yanmin_zhang@linux.intel.com,
        srivatsa.bhat@linux.vnet.ibm.com,
        Zhang Yanmin <yanmin.zhang@intel.com>, Liu ShuoX <shuox.liu@intel.com>
Subject: [PATCH] irq: add a new function irq_in_progress to check pending IRQ handlers
Date: Thu,  6 Jun 2013 15:38:16 +0800
Message-Id: <1370504296-24389-1-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanmin <yanmin.zhang@intel.com>

synchronize_irq waits pending IRQ handlers to be finished. If using this
function while holding a resource, the IRQ handler may cause deadlock.

Here we add a new function irq_in_progress which doesn't wait for the handlers
to be finished.

A typical use case at suspend-to-ram:

device driver's irq handler is complicated and might hold a mutex at rare cases.
Its suspend function is called and a suspended flag is set.
In case its IRQ handler is running, suspend function calls irq_in_progress. if
handler is running, abort suspend.
The irq handler checks the suspended flag. If the device is suspended, irq handler
either ignores the interrupt, or wakes up the whole system, and the driver's
resume function could deal with the delayed interrupt handling.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 include/linux/hardirq.h |    5 +++++
 kernel/irq/manage.c     |   27 +++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index c1d6555..3bd5417 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -124,8 +124,13 @@
 
 #if defined(CONFIG_SMP) || defined(CONFIG_GENERIC_HARDIRQS)
 extern void synchronize_irq(unsigned int irq);
+extern int irq_in_progress(unsigned int irq);
 #else
 # define synchronize_irq(irq)	barrier()
+static inline int irq_in_progress(unsigned int irq)
+{
+	return 0;
+}
 #endif
 
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fa17855..df18450 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -76,6 +76,33 @@ void synchronize_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(synchronize_irq);
 
+/**
+ *	irq_in_progress - check pending IRQ handlers (on other CPUs)
+ *	@irq: interrupt number to check
+ *
+ *	This function checks any pending IRQ handlers for this interrupt.
+ *	The function does not wait for the IRQ handlers to be finished.
+ */
+int irq_in_progress(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	int inprogress;
+
+	if (!desc)
+		return 0;
+
+	inprogress = irqd_irq_inprogress(&desc->irq_data);
+	if (!inprogress) {
+		/*
+		 * We made sure that no hardirq handler is running. Now verify
+		 * that no threaded handlers are active.
+		 */
+		inprogress =  atomic_read(&desc->threads_active);
+	}
+	return inprogress;
+}
+EXPORT_SYMBOL(irq_in_progress);
+
 #ifdef CONFIG_SMP
 cpumask_var_t irq_default_affinity;
 
-- 
1.7.1

