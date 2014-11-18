Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaKRHdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:33:52 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54131 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaKRHdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:33:03 -0500
From: Lina Iyer <lina.iyer@linaro.org>
To: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Cc: Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH v4/RFC 3/4] irq: Add irq_get_affinity() api
Date: Tue, 18 Nov 2014 00:31:49 -0700
Message-Id: <1416295910-40433-4-git-send-email-lina.iyer@linaro.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416295910-40433-1-git-send-email-lina.iyer@linaro.org>
References: <1416295910-40433-1-git-send-email-lina.iyer@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export irq_get_affinity API for drivers to read the smp affinity of an
IRQ safely.

Signed-off-by: Lina Iyer <lina.iyer@linaro.org>
---
 include/linux/interrupt.h |  8 ++++++++
 kernel/irq/manage.c       | 18 ++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 69517a2..fff619c 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -260,6 +260,8 @@ extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
 extern int
 irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
 
+extern int irq_get_affinity(unsigned int irq, struct cpumask *mask);
+
 #else /* CONFIG_SMP */
 
 static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
@@ -290,6 +292,12 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 {
 	return 0;
 }
+
+static inline int irq_get_affinity(unsigned int irq, struct cpumask *mask)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_SMP */
 
 /*
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a9104b..2d17098 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -246,6 +246,24 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
 
+int irq_get_affinity(unsigned int irq, struct cpumask *mask)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	if (!mask)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	if (!irqd_irq_disabled(&desc->irq_data))
+		cpumask_copy(mask, desc->irq_data.affinity);
+	else
+		cpumask_clear(mask);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	return 0;
+}
+
 static void irq_affinity_notify(struct work_struct *work)
 {
 	struct irq_affinity_notify *notify =
-- 
2.1.0

