Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaCNMzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:55:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaCNMza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:55:30 -0400
Date: Fri, 14 Mar 2014 05:55:12 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-328a4978df833249b099c9875738d7b72042ffe1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
In-Reply-To: <1394733834-26839-2-git-send-email-hdegoede@redhat.com>
References: <1394733834-26839-2-git-send-email-hdegoede@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add a new IRQCHIP_EOI_THREADED flag
Git-Commit-ID: 328a4978df833249b099c9875738d7b72042ffe1
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

Commit-ID:  328a4978df833249b099c9875738d7b72042ffe1
Gitweb:     http://git.kernel.org/tip/328a4978df833249b099c9875738d7b72042ffe1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 13 Mar 2014 19:03:51 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 14 Mar 2014 13:43:33 +0100

genirq: Add a new IRQCHIP_EOI_THREADED flag

The flag is necessary for interrupt chips which require an ACK/EOI
after the handler has run. In case of threaded handlers this needs to
happen after the threaded handler has completed before the unmask of
the interrupt.

The flag is only unseful in combination with the handle_fasteoi_irq
flow control handler.

It can be combined with the flag IRQCHIP_EOI_IF_HANDLED, so the EOI is
not issued when the interrupt is disabled or in progress.

Tested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@googlegroups.com
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Link: http://lkml.kernel.org/r/1394733834-26839-2-git-send-email-hdegoede@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |  2 ++
 kernel/irq/chip.c      | 48 ++++++++++++++++++++++++++++++++++++++++--------
 kernel/irq/internals.h |  1 +
 kernel/irq/manage.c    |  2 +-
 4 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 67ace7a..d278838 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -356,6 +356,7 @@ struct irq_chip {
  *				when irq enabled
  * IRQCHIP_SKIP_SET_WAKE:	Skip chip.irq_set_wake(), for this irq chip
  * IRQCHIP_ONESHOT_SAFE:	One shot does not require mask/unmask
+ * IRQCHIP_EOI_THREADED:	Chip requires eoi() on unmask in threaded mode
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
@@ -364,6 +365,7 @@ enum {
 	IRQCHIP_ONOFFLINE_ENABLED	= (1 <<  3),
 	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
 	IRQCHIP_ONESHOT_SAFE		= (1 <<  5),
+	IRQCHIP_EOI_THREADED		= (1 <<  6),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc04c16..6397df2 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -281,6 +281,19 @@ void unmask_irq(struct irq_desc *desc)
 	}
 }
 
+void unmask_threaded_irq(struct irq_desc *desc)
+{
+	struct irq_chip *chip = desc->irq_data.chip;
+
+	if (chip->flags & IRQCHIP_EOI_THREADED)
+		chip->irq_eoi(&desc->irq_data);
+
+	if (chip->irq_unmask) {
+		chip->irq_unmask(&desc->irq_data);
+		irq_state_clr_masked(desc);
+	}
+}
+
 /*
  *	handle_nested_irq - Handle a nested irq from a irq thread
  *	@irq:	the interrupt number
@@ -435,6 +448,27 @@ static inline void preflow_handler(struct irq_desc *desc)
 static inline void preflow_handler(struct irq_desc *desc) { }
 #endif
 
+static void cond_unmask_eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
+{
+	if (!(desc->istate & IRQS_ONESHOT)) {
+		chip->irq_eoi(&desc->irq_data);
+		return;
+	}
+	/*
+	 * We need to unmask in the following cases:
+	 * - Oneshot irq which did not wake the thread (caused by a
+	 *   spurious interrupt or a primary handler handling it
+	 *   completely).
+	 */
+	if (!irqd_irq_disabled(&desc->irq_data) &&
+	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot) {
+		chip->irq_eoi(&desc->irq_data);
+		unmask_irq(desc);
+	} else if (!(chip->flags & IRQCHIP_EOI_THREADED)) {
+		chip->irq_eoi(&desc->irq_data);
+	}
+}
+
 /**
  *	handle_fasteoi_irq - irq handler for transparent controllers
  *	@irq:	the interrupt number
@@ -448,6 +482,8 @@ static inline void preflow_handler(struct irq_desc *desc) { }
 void
 handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
+	struct irq_chip *chip = desc->irq_data.chip;
+
 	raw_spin_lock(&desc->lock);
 
 	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
@@ -473,18 +509,14 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	preflow_handler(desc);
 	handle_irq_event(desc);
 
-	if (desc->istate & IRQS_ONESHOT)
-		cond_unmask_irq(desc);
+	cond_unmask_eoi_irq(desc, chip);
 
-out_eoi:
-	desc->irq_data.chip->irq_eoi(&desc->irq_data);
-out_unlock:
 	raw_spin_unlock(&desc->lock);
 	return;
 out:
-	if (!(desc->irq_data.chip->flags & IRQCHIP_EOI_IF_HANDLED))
-		goto out_eoi;
-	goto out_unlock;
+	if (!(chip->flags & IRQCHIP_EOI_IF_HANDLED))
+		chip->irq_eoi(&desc->irq_data);
+	raw_spin_unlock(&desc->lock);
 }
 
 /**
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 17b6717..ddf1ffe 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -74,6 +74,7 @@ extern void irq_percpu_enable(struct irq_desc *desc, unsigned int cpu);
 extern void irq_percpu_disable(struct irq_desc *desc, unsigned int cpu);
 extern void mask_irq(struct irq_desc *desc);
 extern void unmask_irq(struct irq_desc *desc);
+extern void unmask_threaded_irq(struct irq_desc *desc);
 
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index de1a8ed..2486a4c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -748,7 +748,7 @@ again:
 
 	if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_data) &&
 	    irqd_irq_masked(&desc->irq_data))
-		unmask_irq(desc);
+		unmask_threaded_irq(desc);
 
 out_unlock:
 	raw_spin_unlock_irq(&desc->lock);
