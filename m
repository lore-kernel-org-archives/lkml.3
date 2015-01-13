Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbbAMQhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:37:25 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35640 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbbAMQf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:35:58 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: [RFC PATCH 2/5] irq: Allow interrupts to routed to NMI (or similar)
Date: Tue, 13 Jan 2015 16:35:28 +0000
Message-Id: <1421166931-14134-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some combinations of architectures and interrupt controllers make it
possible for abitrary interrupt signals to be selectively made immune to
masking by local_irq_disable(). For example, on ARM platforms, many
interrupt controllers allow interrupts to be routed to FIQ rather than IRQ.

These features could be exploited to implement debug and tracing features
that can be implemented using NMI on x86 platforms (perf, hard lockup,
kgdb).

This patch assumes that the management of the NMI handler itself will be
architecture specific (maybe notifier list like x86, hard coded like ARM,
or something else entirely). The generic layer can still manage the irq
as normal (affinity, enable/disable, free) but is not responsible for
dispatching.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 include/linux/interrupt.h | 20 ++++++++++++++++++++
 include/linux/irq.h       |  2 ++
 kernel/irq/manage.c       | 29 +++++++++++++++++++++++++++--
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index d9b05b5bf8c7..b95dc28f4cc3 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -57,6 +57,9 @@
  * IRQF_NO_THREAD - Interrupt cannot be threaded
  * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
  *                resume time.
+ * __IRQF_NMI - Route the interrupt to an NMI or some similar signal that is not
+ *              masked by local_irq_disable(). Used internally by
+ *              request_nmi_irq().
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SHARED		0x00000080
@@ -70,6 +73,7 @@
 #define IRQF_FORCE_RESUME	0x00008000
 #define IRQF_NO_THREAD		0x00010000
 #define IRQF_EARLY_RESUME	0x00020000
+#define __IRQF_NMI		0x00040000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
@@ -139,6 +143,22 @@ extern int __must_check
 request_percpu_irq(unsigned int irq, irq_handler_t handler,
 		   const char *devname, void __percpu *percpu_dev_id);
 
+static inline int __must_check request_nmi_irq(unsigned int irq,
+					       unsigned long flags,
+					       const char *name, void *dev_id)
+{
+	/*
+	 * no_action unconditionally returns IRQ_NONE which is exactly
+	 * what we need. The handler might be expected to be unreachable
+	 * but some controllers may spuriously ack the NMI from the IRQ
+	 * handling code. When this happens it occurs very rarely, thus
+	 * by returning IRQ_NONE we can rely on the spurious interrupt
+	 * logic to do the right thing.
+	 */
+	return request_irq(irq, no_action, flags | IRQF_NO_THREAD | __IRQF_NMI,
+			   name, dev_id);
+}
+
 extern void free_irq(unsigned int, void *);
 extern void free_percpu_irq(unsigned int, void __percpu *);
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d09ec7a1243e..695eb37f04ae 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -307,6 +307,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  * @irq_eoi:		end of interrupt
  * @irq_set_affinity:	set the CPU affinity on SMP machines
  * @irq_retrigger:	resend an IRQ to the CPU
+ * @irq_set_nmi_routing:set whether interrupt can act like NMI
  * @irq_set_type:	set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
  * @irq_set_wake:	enable/disable power-management wake-on of an IRQ
  * @irq_bus_lock:	function to lock access to slow bus (i2c) chips
@@ -341,6 +342,7 @@ struct irq_chip {
 
 	int		(*irq_set_affinity)(struct irq_data *data, const struct cpumask *dest, bool force);
 	int		(*irq_retrigger)(struct irq_data *data);
+	int		(*irq_set_nmi_routing)(struct irq_data *data, unsigned int nmi);
 	int		(*irq_set_type)(struct irq_data *data, unsigned int flow_type);
 	int		(*irq_set_wake)(struct irq_data *data, unsigned int on);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 80692373abd6..8e669051759d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -571,6 +571,17 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 	return canrequest;
 }
 
+int __irq_set_nmi_routing(struct irq_desc *desc, unsigned int irq,
+			   unsigned int nmi)
+{
+	struct irq_chip *chip = desc->irq_data.chip;
+
+	if (!chip || !chip->irq_set_nmi_routing)
+		return -EINVAL;
+
+	return chip->irq_set_nmi_routing(&desc->irq_data, nmi);
+}
+
 int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		      unsigned long flags)
 {
@@ -1058,11 +1069,12 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 * the same type (level, edge, polarity). So both flag
 		 * fields must have IRQF_SHARED set and the bits which
 		 * set the trigger type must match. Also all must
-		 * agree on ONESHOT.
+		 * agree on ONESHOT and NMI
 		 */
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
 		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
-		    ((old->flags ^ new->flags) & IRQF_ONESHOT))
+		    ((old->flags ^ new->flags) & IRQF_ONESHOT) ||
+		    ((old->flags ^ new->flags) & __IRQF_NMI))
 			goto mismatch;
 
 		/* All handlers must agree on per-cpuness */
@@ -1153,6 +1165,19 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 		init_waitqueue_head(&desc->wait_for_threads);
 
+		if (new->flags & __IRQF_NMI) {
+			ret = __irq_set_nmi_routing(desc, irq, true);
+			if (ret != 1)
+				goto out_mask;
+		} else {
+			ret = __irq_set_nmi_routing(desc, irq, false);
+			if (ret == 1) {
+				pr_err("Failed to disable NMI routing for irq %d\n",
+				       irq);
+				goto out_mask;
+			}
+		}
+
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
 			ret = __irq_set_trigger(desc, irq,
-- 
1.9.3

