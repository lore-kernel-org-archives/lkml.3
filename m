Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaDQVkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:40:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaDQVkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:40:12 -0400
Date: Thu, 17 Apr 2014 14:39:41 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-01f8fa4f01d8362358eb90e412bd7ae18a3ec1ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        k.kozlowski@samsung.com, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, tglx@linutronix.de
In-Reply-To: <20140416143315.717251504@linutronix.de>
References: <20140416143315.717251504@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Allow forcing cpu affinity of interrupts
Git-Commit-ID: 01f8fa4f01d8362358eb90e412bd7ae18a3ec1ad
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

Commit-ID:  01f8fa4f01d8362358eb90e412bd7ae18a3ec1ad
Gitweb:     http://git.kernel.org/tip/01f8fa4f01d8362358eb90e412bd7ae18a3ec1ad
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 16 Apr 2014 14:36:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 17 Apr 2014 23:36:27 +0200

genirq: Allow forcing cpu affinity of interrupts

The current implementation of irq_set_affinity() refuses rightfully to
route an interrupt to an offline cpu.

But there is a special case, where this is actually desired. Some of
the ARM SoCs have per cpu timers which require setting the affinity
during cpu startup where the cpu is not yet in the online mask.

If we can't do that, then the local timer interrupt for the about to
become online cpu is routed to some random online cpu.

The developers of the affected machines tried to work around that
issue, but that results in a massive mess in that timer code.

We have a yet unused argument in the set_affinity callbacks of the irq
chips, which I added back then for a similar reason. It was never
required so it got not used. But I'm happy that I never removed it.

That allows us to implement a sane handling of the above scenario. So
the affected SoC drivers can add the required force handling to their
interrupt chip, switch the timer code to irq_force_affinity() and
things just work.

This does not affect any existing user of irq_set_affinity().

Tagged for stable to allow a simple fix of the affected SoC clock
event drivers.

Reported-and-tested-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20140416143315.717251504@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/cavium-octeon/octeon-irq.c |  2 +-
 include/linux/interrupt.h            | 35 ++++++++++++++++++++++++++++++++++-
 include/linux/irq.h                  |  3 ++-
 kernel/irq/manage.c                  | 17 ++++++-----------
 4 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index c2bb4f8..3aa5b46 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -635,7 +635,7 @@ static void octeon_irq_cpu_offline_ciu(struct irq_data *data)
 		cpumask_clear(&new_affinity);
 		cpumask_set_cpu(cpumask_first(cpu_online_mask), &new_affinity);
 	}
-	__irq_set_affinity_locked(data, &new_affinity);
+	irq_set_affinity_locked(data, &new_affinity, false);
 }
 
 static int octeon_irq_ciu_set_affinity(struct irq_data *data,
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c7bfac1..8834a7e 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -203,7 +203,40 @@ static inline int check_wakeup_irqs(void) { return 0; }
 
 extern cpumask_var_t irq_default_affinity;
 
-extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
+/* Internal implementation. Use the helpers below */
+extern int __irq_set_affinity(unsigned int irq, const struct cpumask *cpumask,
+			      bool force);
+
+/**
+ * irq_set_affinity - Set the irq affinity of a given irq
+ * @irq:	Interrupt to set affinity
+ * @mask:	cpumask
+ *
+ * Fails if cpumask does not contain an online CPU
+ */
+static inline int
+irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+{
+	return __irq_set_affinity(irq, cpumask, false);
+}
+
+/**
+ * irq_force_affinity - Force the irq affinity of a given irq
+ * @irq:	Interrupt to set affinity
+ * @mask:	cpumask
+ *
+ * Same as irq_set_affinity, but without checking the mask against
+ * online cpus.
+ *
+ * Solely for low level cpu hotplug code, where we need to make per
+ * cpu interrupts affine before the cpu becomes online.
+ */
+static inline int
+irq_force_affinity(unsigned int irq, const struct cpumask *cpumask)
+{
+	return __irq_set_affinity(irq, cpumask, true);
+}
+
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d278838..10a0b1a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -394,7 +394,8 @@ extern void remove_percpu_irq(unsigned int irq, struct irqaction *act);
 
 extern void irq_cpu_online(void);
 extern void irq_cpu_offline(void);
-extern int __irq_set_affinity_locked(struct irq_data *data,  const struct cpumask *cpumask);
+extern int irq_set_affinity_locked(struct irq_data *data,
+				   const struct cpumask *cpumask, bool force);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
 void irq_move_irq(struct irq_data *data);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2486a4c..d34131c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -180,7 +180,7 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	int ret;
 
-	ret = chip->irq_set_affinity(data, mask, false);
+	ret = chip->irq_set_affinity(data, mask, force);
 	switch (ret) {
 	case IRQ_SET_MASK_OK:
 		cpumask_copy(data->affinity, mask);
@@ -192,7 +192,8 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
-int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
+int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
+			    bool force)
 {
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	struct irq_desc *desc = irq_data_to_desc(data);
@@ -202,7 +203,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 		return -EINVAL;
 
 	if (irq_can_move_pcntxt(data)) {
-		ret = irq_do_set_affinity(data, mask, false);
+		ret = irq_do_set_affinity(data, mask, force);
 	} else {
 		irqd_set_move_pending(data);
 		irq_copy_pending(desc, mask);
@@ -217,13 +218,7 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 	return ret;
 }
 
-/**
- *	irq_set_affinity - Set the irq affinity of a given irq
- *	@irq:		Interrupt to set affinity
- *	@mask:		cpumask
- *
- */
-int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
+int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -233,7 +228,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *mask)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	ret =  __irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask);
+	ret = irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask, force);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
