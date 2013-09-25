Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab3IYQSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:18:32 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:53581 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3IYQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:18:30 -0400
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
Subject: [PATCH 6/7] irq: Optimize softirq stack selection in irq exit
Date: Wed, 25 Sep 2013 18:18:05 +0200
Message-Id: <1380125886-10341-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
References: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If irq_exit() is called on the arch's specified irq stack,
it should be safe to run softirqs inline under that same
irq stack as it is near empty by the time we call irq_exit().

Hardirqs can nest but irq exit's processing of softirqs only
happen in the inner most hardirq.

So if we use the same stack for both the worst case scenario is:
hardirq -> softirq -> hardirq. But then the first hardirq can be
ignored as its stack is mostly empty. So the stack merge in this
case looks acceptable.

So lets adapt the irq exit's softirq stack on top of a new arch symbol
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
 kernel/softirq.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 2b4328e..317778c 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -332,15 +332,21 @@ void irq_enter(void)
 static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads) {
+#ifdef __ARCH_IRQ_EXIT_ON_IRQ_STACK
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

