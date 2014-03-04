Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaCDQls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:41:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41531 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCDQln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:41:43 -0500
Date: Tue, 4 Mar 2014 08:41:14 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-792d0018a5fe31ef8ef9d07a7a02081d4abdf6b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140223212737.422068876@linutronix.de>
References: <20140223212737.422068876@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add a kstat helper to increment irq stats
Git-Commit-ID: 792d0018a5fe31ef8ef9d07a7a02081d4abdf6b7
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

Commit-ID:  792d0018a5fe31ef8ef9d07a7a02081d4abdf6b7
Gitweb:     http://git.kernel.org/tip/792d0018a5fe31ef8ef9d07a7a02081d4abdf6b7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:14 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:53 +0100

genirq: Add a kstat helper to increment irq stats

There is a common pattern all over the place:

      kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));

This results in a call to core code anyway. So provide a function
which does the same thing in core.

While at it, replace the butt ugly macro with an inline.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140223212737.422068876@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kernel_stat.h | 12 +++++++-----
 kernel/irq/irqdesc.c        |  5 +++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 51c72be..54ec7e0 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -54,11 +54,13 @@ extern unsigned long long nr_context_switches(void);
 #include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
 
-#define kstat_incr_irqs_this_cpu(irqno, DESC)		\
-do {							\
-	__this_cpu_inc(*(DESC)->kstat_irqs);		\
-	__this_cpu_inc(kstat.irqs_sum);			\
-} while (0)
+static inline void kstat_incr_irqs_this_cpu(unsigned int irq, struct irq_desc *desc)
+{
+	__this_cpu_inc(*desc->kstat_irqs);
+	__this_cpu_inc(kstat.irqs_sum);
+}
+
+extern void kstat_incr_irq_this_cpu(unsigned int irq);
 
 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
 {
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 8ab8e93..a7174617 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -489,6 +489,11 @@ void dynamic_irq_cleanup(unsigned int irq)
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
+void kstat_incr_irq_this_cpu(unsigned int irq)
+{
+	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+}
+
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
