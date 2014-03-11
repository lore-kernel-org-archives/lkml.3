Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaCKXNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:13:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbaCKXNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:13:41 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo.caione@gmail.com>
Subject: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flag
Date: Wed, 12 Mar 2014 00:13:03 +0100
Message-Id: <1394579583-29316-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases we want to do an ack right before the unmask of an irq.

A typical example of such a case is having an i2c device which uses a level
interrupt. Such devices usually have an interrupt status register with
write to clear status bits. This means that the interrupt handler needs to
sleep to do i2c transfers to read / write the interrupt status register.

This means using a threaded interrupt handler and IRQF_ONESHOT so that the
interrupt does not re-trigger while the interrupt handler is waiting for the
i2c transfer.

Without ack-before-unmask the sequence of a single interrupt in this setup
looks like this:

i2c-device raises interrupt line
interrupt gets triggered
interrupt gets masked
interrupt gets acked
interrupt handling thread starts running
interrupt handling thread does its stuff, write-clears irq-status register
 in i2c-device
i2c-device lowers interrupt line (note this happens after the ack!)
interrupt handling thread is done
interrupt gets unmasked
interrupt immediately retriggers again, because the line has been high
 after the ack
interrupt gets masked
interrupt gets acked
interrupt handling thread starts running
interrupt handling thread reads irq-status register, has nothing todo
interrupt handling thread is done
interrupt gets unmasked

So in essence we get and handle 2 interrupts for what is 1 interrupt from
the i2c-device pov. By doing an ack before the unmask, the second interrupt
is avoided since at the point of the unmask the irq-thread has done its
job and cleared the interrupt source.

Note that things work fine without this patch, the purpose of this patch is
soley to avoid the second unneeded interrupt.

This patch uses an interrupt flag for this and not an irqchip flag because
the need for ack before unmask is based on the device and not on the irqchip.

Cc: Carlo Caione <carlo.caione@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 include/linux/interrupt.h | 2 ++
 kernel/irq/chip.c         | 4 ++++
 kernel/irq/internals.h    | 2 ++
 kernel/irq/manage.c       | 5 ++++-
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a2678d3..c252344 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -57,6 +57,7 @@
  * IRQF_NO_THREAD - Interrupt cannot be threaded
  * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
  *                resume time.
+ * IRQF_ACK_BEFORE_UNMASK - IRQ must be acked before an unmask
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SHARED		0x00000080
@@ -70,6 +71,7 @@
 #define IRQF_FORCE_RESUME	0x00008000
 #define IRQF_NO_THREAD		0x00010000
 #define IRQF_EARLY_RESUME	0x00020000
+#define IRQF_ACK_BEFORE_UNMASK	0x00040000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc04c16..b6ed2fb 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -275,6 +275,10 @@ void mask_irq(struct irq_desc *desc)
 
 void unmask_irq(struct irq_desc *desc)
 {
+	if ((desc->istate & IRQS_ACK_BEFORE_UNMASK) &&
+	                desc->irq_data.chip->irq_ack)
+		desc->irq_data.chip->irq_ack(&desc->irq_data);
+
 	if (desc->irq_data.chip->irq_unmask) {
 		desc->irq_data.chip->irq_unmask(&desc->irq_data);
 		irq_state_clr_masked(desc);
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 001fa5b..cd68190 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -43,6 +43,7 @@ enum {
  * IRQS_WAITING			- irq is waiting
  * IRQS_PENDING			- irq is pending and replayed later
  * IRQS_SUSPENDED		- irq is suspended
+ * IRQS_ACK_BEFORE_UNMASK	- irq must be acked before an unmask
  */
 enum {
 	IRQS_AUTODETECT		= 0x00000001,
@@ -53,6 +54,7 @@ enum {
 	IRQS_WAITING		= 0x00000080,
 	IRQS_PENDING		= 0x00000200,
 	IRQS_SUSPENDED		= 0x00000800,
+	IRQS_ACK_BEFORE_UNMASK	= 0x00001000,
 };
 
 #include "debug.h"
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 481a13c..fd105ce 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1104,7 +1104,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		}
 
 		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \
-				  IRQS_ONESHOT | IRQS_WAITING);
+			IRQS_ONESHOT | IRQS_WAITING | IRQS_ACK_BEFORE_UNMASK);
 		irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 
 		if (new->flags & IRQF_PERCPU) {
@@ -1140,6 +1140,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 				   irq, nmsk, omsk);
 	}
 
+	if (new->flags & IRQF_ACK_BEFORE_UNMASK)
+		desc->istate |= IRQS_ACK_BEFORE_UNMASK;
+
 	new->irq = irq;
 	*old_ptr = new;
 
-- 
1.8.4.2

