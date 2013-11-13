Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab3KMTmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:42:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab3KMTms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:42:48 -0500
Date: Wed, 13 Nov 2013 11:42:28 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-b39898cd4077f4b6ec706e717c938751c34e1dc4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        geert@linux-m68k.org, tglx@linutronix.de, schmitzmic@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, tglx@linutronix.de, schmitzmic@gmail.com
In-Reply-To: <alpine.DEB.2.02.1311061149250.23353@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1311061149250.23353@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq:
  Prevent spurious detection for unconditionally polled interrupts
Git-Commit-ID: b39898cd4077f4b6ec706e717c938751c34e1dc4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 11:42:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b39898cd4077f4b6ec706e717c938751c34e1dc4
Gitweb:     http://git.kernel.org/tip/b39898cd4077f4b6ec706e717c938751c34e1dc4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 6 Nov 2013 12:30:07 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Nov 2013 16:03:02 +0100

genirq: Prevent spurious detection for unconditionally polled interrupts

On a 68k platform a couple of interrupts are demultiplexed and
"polled" from a top level interrupt. Unfortunately there is no way to
determine which of the sub interrupts raised the top level interrupt,
so all of the demultiplexed interrupt handlers need to be
invoked. Given a high enough frequency this can trigger the spurious
interrupt detection mechanism, if one of the demultiplex interrupts
returns IRQ_NONE continuously. But this is a false positive as the
polling causes this behaviour and not buggy hardware/software.

Introduce IRQ_POLLED which can be set at interrupt chip setup time via
irq_set_status_flags(). The flag excludes the interrupt from the
spurious detector and from all core polling activities.

Reported-and-tested-by: Michael Schmitz <schmitzmic@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1311061149250.23353@ionos.tec.linutronix.de
---
 include/linux/irq.h   |  7 ++++++-
 kernel/irq/settings.h |  7 +++++++
 kernel/irq/spurious.c | 12 +++++++++---
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 56bb0dc..7dc1003 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -70,6 +70,9 @@ typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
  * IRQ_MOVE_PCNTXT		- Interrupt can be migrated from process context
  * IRQ_NESTED_TRHEAD		- Interrupt nests into another thread
  * IRQ_PER_CPU_DEVID		- Dev_id is a per-cpu variable
+ * IRQ_IS_POLLED		- Always polled by another interrupt. Exclude
+ *				  it from the spurious interrupt detection
+ *				  mechanism and from core side polling.
  */
 enum {
 	IRQ_TYPE_NONE		= 0x00000000,
@@ -94,12 +97,14 @@ enum {
 	IRQ_NESTED_THREAD	= (1 << 15),
 	IRQ_NOTHREAD		= (1 << 16),
 	IRQ_PER_CPU_DEVID	= (1 << 17),
+	IRQ_IS_POLLED		= (1 << 18),
 };
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
 	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_NO_BALANCING | \
-	 IRQ_PER_CPU | IRQ_NESTED_THREAD | IRQ_NOTHREAD | IRQ_PER_CPU_DEVID)
+	 IRQ_PER_CPU | IRQ_NESTED_THREAD | IRQ_NOTHREAD | IRQ_PER_CPU_DEVID | \
+	 IRQ_IS_POLLED)
 
 #define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
 
diff --git a/kernel/irq/settings.h b/kernel/irq/settings.h
index 1162f10..3320b84 100644
--- a/kernel/irq/settings.h
+++ b/kernel/irq/settings.h
@@ -14,6 +14,7 @@ enum {
 	_IRQ_NO_BALANCING	= IRQ_NO_BALANCING,
 	_IRQ_NESTED_THREAD	= IRQ_NESTED_THREAD,
 	_IRQ_PER_CPU_DEVID	= IRQ_PER_CPU_DEVID,
+	_IRQ_IS_POLLED		= IRQ_IS_POLLED,
 	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
 };
 
@@ -26,6 +27,7 @@ enum {
 #define IRQ_NOAUTOEN		GOT_YOU_MORON
 #define IRQ_NESTED_THREAD	GOT_YOU_MORON
 #define IRQ_PER_CPU_DEVID	GOT_YOU_MORON
+#define IRQ_IS_POLLED		GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
 #define IRQF_MODIFY_MASK	GOT_YOU_MORON
 
@@ -147,3 +149,8 @@ static inline bool irq_settings_is_nested_thread(struct irq_desc *desc)
 {
 	return desc->status_use_accessors & _IRQ_NESTED_THREAD;
 }
+
+static inline bool irq_settings_is_polled(struct irq_desc *desc)
+{
+	return desc->status_use_accessors & _IRQ_IS_POLLED;
+}
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 7b5f012..a1d8cc6 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -67,8 +67,13 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 
 	raw_spin_lock(&desc->lock);
 
-	/* PER_CPU and nested thread interrupts are never polled */
-	if (irq_settings_is_per_cpu(desc) || irq_settings_is_nested_thread(desc))
+	/*
+	 * PER_CPU, nested thread interrupts and interrupts explicitely
+	 * marked polled are excluded from polling.
+	 */
+	if (irq_settings_is_per_cpu(desc) ||
+	    irq_settings_is_nested_thread(desc) ||
+	    irq_settings_is_polled(desc))
 		goto out;
 
 	/*
@@ -268,7 +273,8 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
-	if (desc->istate & IRQS_POLL_INPROGRESS)
+	if (desc->istate & IRQS_POLL_INPROGRESS ||
+	    irq_settings_is_polled(desc))
 		return;
 
 	/* we get here again via the threaded handler */
