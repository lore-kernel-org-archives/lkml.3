Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaCDQnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:43:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbaCDQnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:43:43 -0500
Date: Tue, 4 Mar 2014 08:43:10 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-8f945a3325bbe0dd651e2f496a53df9b06fc6d07@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140223212739.124207133@linutronix.de>
References: <20140223212739.124207133@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Move kstat_incr_irqs_this_cpu() to core
Git-Commit-ID: 8f945a3325bbe0dd651e2f496a53df9b06fc6d07
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

Commit-ID:  8f945a3325bbe0dd651e2f496a53df9b06fc6d07
Gitweb:     http://git.kernel.org/tip/8f945a3325bbe0dd651e2f496a53df9b06fc6d07
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:23 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:54 +0100

genirq: Move kstat_incr_irqs_this_cpu() to core

No more users outside the core code. Put it into the poison
cabinet. That also gets rid of the linux/irq.h include in
kernel_stat.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140223212739.124207133@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kernel_stat.h | 8 --------
 kernel/irq/internals.h      | 7 +++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 54ec7e0..c3fbda7 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -51,15 +51,7 @@ DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 
 extern unsigned long long nr_context_switches(void);
 
-#include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
-
-static inline void kstat_incr_irqs_this_cpu(unsigned int irq, struct irq_desc *desc)
-{
-	__this_cpu_inc(*desc->kstat_irqs);
-	__this_cpu_inc(kstat.irqs_sum);
-}
-
 extern void kstat_incr_irq_this_cpu(unsigned int irq);
 
 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index d61ac29..17b6717 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -6,6 +6,7 @@
  * of this file for your non core code.
  */
 #include <linux/irqdesc.h>
+#include <linux/kernel_stat.h>
 
 #ifdef CONFIG_SPARSE_IRQ
 # define IRQ_BITMAP_BITS	(NR_IRQS + 8196)
@@ -180,3 +181,9 @@ static inline bool irqd_has_set(struct irq_data *d, unsigned int mask)
 {
 	return d->state_use_accessors & mask;
 }
+
+static inline void kstat_incr_irqs_this_cpu(unsigned int irq, struct irq_desc *desc)
+{
+	__this_cpu_inc(*desc->kstat_irqs);
+	__this_cpu_inc(kstat.irqs_sum);
+}
