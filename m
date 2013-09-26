Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3IZQZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:25:13 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60234 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab3IZQZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:25:06 -0400
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
Subject: [PATCH 5/8] irq: Justify the various softirq stack choices
Date: Thu, 26 Sep 2013 18:24:43 +0200
Message-Id: <1380212686-25897-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
References: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For clarity, comment the various stack choices for softirqs
processing, whether we execute them from ksoftirqd or
local_irq_enable() calls.

Their use on irq_exit() is already commented.

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
 kernel/softirq.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 9f8092b..2b4328e 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -170,8 +170,13 @@ static inline void _local_bh_enable_ip(unsigned long ip)
  	 */
 	sub_preempt_count(SOFTIRQ_DISABLE_OFFSET - 1);
 
-	if (unlikely(!in_interrupt() && local_softirq_pending()))
+	if (unlikely(!in_interrupt() && local_softirq_pending())) {
+		/*
+		 * Run softirq if any pending. And do it in its own stack
+		 * as we may be calling this deep in a task call stack already.
+		 */
 		do_softirq();
+	}
 
 	dec_preempt_count();
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -769,6 +774,10 @@ static void run_ksoftirqd(unsigned int cpu)
 {
 	local_irq_disable();
 	if (local_softirq_pending()) {
+		/*
+		 * We can safely run softirq on inline stack, as we are not deep
+		 * in the task stack here.
+		 */
 		__do_softirq();
 		rcu_note_context_switch(cpu);
 		local_irq_enable();
-- 
1.8.3.1

