Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaEUCg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:36:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58407 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaEUCg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:36:56 -0400
Date: Tue, 20 May 2014 19:36:32 -0700
From: tip-bot for Eyal Perry <tipbot@zytor.com>
Message-ID: <tip-f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        amirv@mellanox.com, yevgenyp@mellanox.com, bhutchings@solarflare.com,
        davem@davemloft.net, eyalpe@mellanox.com, ogerlitz@mellanox.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        amirv@mellanox.com, bhutchings@solarflare.com, yevgenyp@mellanox.com,
        davem@davemloft.net, ogerlitz@mellanox.com, eyalpe@mellanox.com,
        tglx@linutronix.de
In-Reply-To: <1400597820-30685-1-git-send-email-amirv@mellanox.com>
References: <1400597820-30685-1-git-send-email-amirv@mellanox.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq:
  Provide !SMP stub for irq_set_affinity_notifier()
Git-Commit-ID: f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de
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

Commit-ID:  f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de
Gitweb:     http://git.kernel.org/tip/f0ba3d05c9c647ab42ed6a0dbdfdeae42bfbd6de
Author:     Eyal Perry <eyalpe@mellanox.com>
AuthorDate: Tue, 20 May 2014 17:57:00 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 21 May 2014 11:31:51 +0900

genirq: Provide !SMP stub for irq_set_affinity_notifier()

Instead of requiring each consumer of the IRQ affinity notifier to have
themselves be explicitly dependent on CONFIG_SMP, make the definition of
struct irq_affinity_notify to exist independently of that config option
and introduce a stub for irq_set_affinity_notifier() under non SMP
configuration.

Fixes: 2eacc23 ("net/mlx4_core: Enforce irq affinity changes
immediatly")

Signed-off-by: Eyal Perry <eyalpe@mellanox.com>
Signed-off-by: Amir Vadai <amirv@mellanox.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Yevgeny Petrilin <yevgenyp@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/1400597820-30685-1-git-send-email-amirv@mellanox.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 97ac926..3f74c059 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -199,6 +199,26 @@ extern int check_wakeup_irqs(void);
 static inline int check_wakeup_irqs(void) { return 0; }
 #endif
 
+/**
+ * struct irq_affinity_notify - context for notification of IRQ affinity changes
+ * @irq:		Interrupt to which notification applies
+ * @kref:		Reference count, for internal use
+ * @work:		Work item, for internal use
+ * @notify:		Function to be called on change.  This will be
+ *			called in process context.
+ * @release:		Function to be called on release.  This will be
+ *			called in process context.  Once registered, the
+ *			structure must only be freed when this function is
+ *			called or later.
+ */
+struct irq_affinity_notify {
+	unsigned int irq;
+	struct kref kref;
+	struct work_struct work;
+	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
+	void (*release)(struct kref *ref);
+};
+
 #if defined(CONFIG_SMP)
 
 extern cpumask_var_t irq_default_affinity;
@@ -242,26 +262,6 @@ extern int irq_select_affinity(unsigned int irq);
 
 extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
 
-/**
- * struct irq_affinity_notify - context for notification of IRQ affinity changes
- * @irq:		Interrupt to which notification applies
- * @kref:		Reference count, for internal use
- * @work:		Work item, for internal use
- * @notify:		Function to be called on change.  This will be
- *			called in process context.
- * @release:		Function to be called on release.  This will be
- *			called in process context.  Once registered, the
- *			structure must only be freed when this function is
- *			called or later.
- */
-struct irq_affinity_notify {
-	unsigned int irq;
-	struct kref kref;
-	struct work_struct work;
-	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
-	void (*release)(struct kref *ref);
-};
-
 extern int
 irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
 
@@ -284,6 +284,12 @@ static inline int irq_set_affinity_hint(unsigned int irq,
 {
 	return -EINVAL;
 }
+
+static inline int
+irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
+{
+	return 0;
+}
 #endif /* CONFIG_SMP */
 
 /*
