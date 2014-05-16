Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbaEPNit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:38:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480AbaEPNip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:38:45 -0400
Date: Fri, 16 May 2014 06:37:55 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-d8179bc0db8d0c9654d5de43de2874bf6d0a58fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <20140507154341.012847637@linutronix.de>
References: <20140507154341.012847637@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Remove dynamic_irq mess
Git-Commit-ID: d8179bc0db8d0c9654d5de43de2874bf6d0a58fa
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

Commit-ID:  d8179bc0db8d0c9654d5de43de2874bf6d0a58fa
Gitweb:     http://git.kernel.org/tip/d8179bc0db8d0c9654d5de43de2874bf6d0a58fa
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:23 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:22 +0200

genirq: Remove dynamic_irq mess

No more users. Get rid of the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140507154341.012847637@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h  | 10 ----------
 kernel/irq/irqdesc.c | 23 +++++++----------------
 2 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8ff71d1..0d998d8 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -525,16 +525,6 @@ static inline void irq_set_percpu_devid_flags(unsigned int irq)
 			     IRQ_NOPROBE | IRQ_PER_CPU_DEVID);
 }
 
-/*
- * Dynamic irq helper functions. Obsolete. Use irq_alloc_desc* and
- * irq_free_desc instead.
- */
-extern void dynamic_irq_cleanup(unsigned int irq);
-static inline void dynamic_irq_init(unsigned int irq)
-{
-	dynamic_irq_cleanup(irq);
-}
-
 /* Set/get chip/data for an IRQ: */
 extern int irq_set_chip(unsigned int irq, struct irq_chip *chip);
 extern int irq_set_handler_data(unsigned int irq, void *data);
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 7f26779..7339e42 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -278,7 +278,12 @@ EXPORT_SYMBOL(irq_to_desc);
 
 static void free_desc(unsigned int irq)
 {
-	dynamic_irq_cleanup(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	desc_set_defaults(irq, desc, desc_node(desc), NULL);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 static inline int alloc_descs(unsigned int start, unsigned int cnt, int node,
@@ -309,7 +314,7 @@ void irq_mark_irq(unsigned int irq)
 #ifdef CONFIG_GENERIC_IRQ_LEGACY
 void irq_init_desc(unsigned int irq)
 {
-	dynamic_irq_cleanup(irq);
+	free_desc(irq);
 }
 #endif
 
@@ -522,20 +527,6 @@ int irq_set_percpu_devid(unsigned int irq)
 	return 0;
 }
 
-/**
- * dynamic_irq_cleanup - cleanup a dynamically allocated irq
- * @irq:	irq number to initialize
- */
-void dynamic_irq_cleanup(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc_set_defaults(irq, desc, desc_node(desc), NULL);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-}
-
 void kstat_incr_irq_this_cpu(unsigned int irq)
 {
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
