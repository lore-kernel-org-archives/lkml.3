Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3B1UDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:03:38 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:64648 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3B1UDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:03:01 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 2/2] irq: Don't re-enable interrupts at the end of irq_exit
Date: Thu, 28 Feb 2013 21:02:47 +0100
Message-Id: <1362081767-30684-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1362081767-30684-1-git-send-email-fweisbec@gmail.com>
References: <1362081767-30684-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 74eed0163d0def3fce27228d9ccf3d36e207b286
"irq: Ensure irq_exit() code runs with interrupts disabled"
restore interrupts flags in the end of irq_exit() for archs
that don't define __ARCH_IRQ_EXIT_IRQS_DISABLED.

However always returning from irq_exit() with interrupts
disabled should not be a problem for these archs. Prior to
this commit this was already happening anytime we processed
pending softirqs anyway.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/softirq.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index f42ff97..dce38fa 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -334,9 +334,7 @@ static inline void invoke_softirq(void)
 void irq_exit(void)
 {
 #ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
-	unsigned long flags;
-
-	local_irq_save(flags);
+	local_irq_disable();
 #else
 	WARN_ON_ONCE(!irqs_disabled());
 #endif
@@ -353,9 +351,6 @@ void irq_exit(void)
 		tick_nohz_irq_exit();
 #endif
 	rcu_irq_exit();
-#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
-	local_irq_restore(flags);
-#endif
 }
 
 /*
-- 
1.7.5.4

