Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3BURqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:46:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab3BURqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:46:50 -0500
Date: Thu, 21 Feb 2013 09:45:03 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-630e7580f681475d92d87e78373e4136096e12f2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linuxfoundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: paulmck@linux.vnet.ibm.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        torvalds@linuxfoundation.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.02.1302202155320.22263@ionos>
References: <alpine.LFD.2.02.1302202155320.22263@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irq: Ensure irq_exit()
  code runs with interrupts disabled
Git-Commit-ID: 630e7580f681475d92d87e78373e4136096e12f2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Feb 2013 09:45:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  630e7580f681475d92d87e78373e4136096e12f2
Gitweb:     http://git.kernel.org/tip/630e7580f681475d92d87e78373e4136096e12f2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 20 Feb 2013 22:00:48 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 21 Feb 2013 18:32:44 +0100

irq: Ensure irq_exit() code runs with interrupts disabled

We had already a few problems with code called from irq_exit() when
interrupted from a nesting interrupt. This can happen on architectures
which do not define __ARCH_IRQ_EXIT_IRQS_DISABLED.

__ARCH_IRQ_EXIT_IRQS_DISABLED should go away and we want to make it
mandatory to call irq_exit() with interrupts disabled.

As a temporary protection disable interrupts for those architectures
which do not define __ARCH_IRQ_EXIT_IRQS_DISABLED and add a WARN_ONCE
when an architecture which defines __ARCH_IRQ_EXIT_IRQS_DISABLED calls
irq_exit() with interrupts enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1302202155320.22263@ionos

---
 kernel/softirq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index f5cc25f..d1f7943 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -341,6 +341,14 @@ static inline void invoke_softirq(void)
  */
 void irq_exit(void)
 {
+#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
+	unsigned long flags;
+
+	local_irq_save(flags);
+#else
+	WARN_ON_ONCE(!irqs_disabled();
+#endif
+
 	account_irq_exit_time(current);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
@@ -354,6 +362,9 @@ void irq_exit(void)
 #endif
 	rcu_irq_exit();
 	sched_preempt_enable_no_resched();
+#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
+	local_irq_restore(flags);
+#endif
 }
 
 /*
