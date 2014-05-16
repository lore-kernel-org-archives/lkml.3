Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbaEPNh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:37:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54342 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718AbaEPNhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:55 -0400
Date: Fri, 16 May 2014 06:37:07 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-f63b6a05f2b11537612266a8b27a61f412344a1d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <20140507154340.061990194@linutronix.de>
References: <20140507154340.061990194@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Replace reserve_irqs in core code
Git-Commit-ID: f63b6a05f2b11537612266a8b27a61f412344a1d
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

Commit-ID:  f63b6a05f2b11537612266a8b27a61f412344a1d
Gitweb:     http://git.kernel.org/tip/f63b6a05f2b11537612266a8b27a61f412344a1d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:21 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:22 +0200

genirq: Replace reserve_irqs in core code

We want to get rid of the public interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140507154340.061990194@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c      | 5 ++---
 kernel/irq/internals.h | 6 ++++++
 kernel/irq/irqdesc.c   | 7 +++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6397df2..a2b28a2 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -40,10 +40,9 @@ int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 	irq_put_desc_unlock(desc, flags);
 	/*
 	 * For !CONFIG_SPARSE_IRQ make the irq show up in
-	 * allocated_irqs. For the CONFIG_SPARSE_IRQ case, it is
-	 * already marked, and this call is harmless.
+	 * allocated_irqs.
 	 */
-	irq_reserve_irq(irq);
+	irq_mark_irq(irq);
 	return 0;
 }
 EXPORT_SYMBOL(irq_set_chip);
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index ddf1ffe..c4065e3 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -76,6 +76,12 @@ extern void mask_irq(struct irq_desc *desc);
 extern void unmask_irq(struct irq_desc *desc);
 extern void unmask_threaded_irq(struct irq_desc *desc);
 
+#ifdef CONFIG_SPARSE_IRQ
+static inline void irq_mark_irq(unsigned int irq) { }
+#else
+extern void irq_mark_irq(unsigned int irq);
+#endif
+
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
 irqreturn_t handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action);
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index f388ade..2402934 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -299,6 +299,13 @@ static int irq_expand_nr_irqs(unsigned int nr)
 	return -ENOMEM;
 }
 
+void irq_mark_irq(unsigned int irq)
+{
+	mutex_lock(&sparse_irq_lock);
+	bitmap_set(allocated_irqs, irq, 1);
+	mutex_unlock(&sparse_irq_lock);
+}
+
 #endif /* !CONFIG_SPARSE_IRQ */
 
 /**
