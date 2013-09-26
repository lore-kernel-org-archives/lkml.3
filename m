Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3IZQZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:25:16 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63390 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3IZQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:25:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/8] irq: Optimize softirq stack selection in irq exit
Date: Thu, 26 Sep 2013 18:24:44 +0200
Message-Id: <1380212686-25897-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
References: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If irq_exit() is called on the arch's specified irq stack,
it should be safe to run softirqs inline under that same
irq stack as it is near empty by the time we call irq_exit().

For example if we use the same stack for both hard and soft irqs here,
the worst case scenario is:
hardirq -> softirq -> hardirq. But then the softirq supersedes the
first hardirq as the stack user since irq_exit() is called in
a mostly empty stack. So the stack merge in this case looks acceptable.

Stack overrun still have a chance to happen if hardirqs have more
opportunities to nest, but then it's another problem to solve.

So lets adapt the irq exit's softirq stack on top of a new Kconfig symbol
that can be defined when irq_exit() runs on the irq stack. That way
we can spare some stack switch on irq processing and all the cache
issues that come along.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@au1.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@au1.ibm.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/Kconfig     | 10 ++++++++++
 kernel/softirq.c | 14 ++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1feb169..5293e8a 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -393,6 +393,16 @@ config HAVE_UNDERSCORE_SYMBOL_PREFIX
 	  Some architectures generate an _ in front of C symbols; things like
 	  module loading and assembly files need to know about this.
 
+config HAVE_IRQ_EXIT_ON_IRQ_STACK
+	bool
+	help
+	  Architecture doesn't only execute the irq handler on the irq stack
+	  but also irq_exit(). This way we can process softirqs on this irq
+	  stack instead of switching to a new one when we call __do_softirq()
+	  in the end of an hardirq.
+	  This spares a stack switch and improves cache usage on softirq
+	  processing.
+
 #
 # ABI hall of shame
 #
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 2b4328e..dacd0ab 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -332,15 +332,21 @@ void irq_enter(void)
 static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads) {
+#ifdef CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK
 		/*
 		 * We can safely execute softirq on the current stack if
 		 * it is the irq stack, because it should be near empty
-		 * at this stage. But we have no way to know if the arch
-		 * calls irq_exit() on the irq stack. So call softirq
-		 * in its own stack to prevent from any overrun on top
-		 * of a potentially deep task stack.
+		 * at this stage.
+		 */
+		__do_softirq();
+#else
+		/*
+		 * Otherwise, irq_exit() is called on the task stack that can
+		 * be potentially deep already. So call softirq in its own stack
+		 * to prevent from any overrun.
 		 */
 		do_softirq_own_stack();
+#endif
 	} else {
 		wakeup_softirqd();
 	}
-- 
1.8.3.1

