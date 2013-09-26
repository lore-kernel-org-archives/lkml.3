Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3IZQZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:25:09 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53026 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3IZQZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:25:03 -0400
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
Subject: [PATCH 4/8] irq: Improve a bit softirq debugging
Date: Thu, 26 Sep 2013 18:24:42 +0200
Message-Id: <1380212686-25897-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
References: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_softirq() has a debug check that verifies that it is not nesting
on softirqs processing, nor miscounting the softirq part of the preempt
count.

But making sure that softirqs processing don't nest is actually a more
generic concern that applies to any caller of __do_softirq().

Do take it one step further and generalize that debug check to
any softirq processing.

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
 kernel/softirq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 17c5cd2..9f8092b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -133,7 +133,6 @@ EXPORT_SYMBOL(local_bh_disable);
 
 static void __local_bh_enable(unsigned int cnt)
 {
-	WARN_ON_ONCE(in_irq());
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (softirq_count() == cnt)
@@ -148,6 +147,7 @@ static void __local_bh_enable(unsigned int cnt)
  */
 void _local_bh_enable(void)
 {
+	WARN_ON_ONCE(in_irq());
 	__local_bh_enable(SOFTIRQ_DISABLE_OFFSET);
 }
 
@@ -279,6 +279,7 @@ restart:
 
 	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
+	WARN_ON_ONCE(in_interrupt());
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
 
@@ -299,7 +300,6 @@ asmlinkage void do_softirq(void)
 	if (pending)
 		do_softirq_own_stack();
 
-	WARN_ON_ONCE(softirq_count());
 	local_irq_restore(flags);
 }
 
-- 
1.8.3.1

