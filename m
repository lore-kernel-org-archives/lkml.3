Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab3DCONq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:13:46 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:49136 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3DCONp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:13:45 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <tglx@linutronix.de>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Robert Love <rml@tech9.net>, <kpreempt-tech@lists.sourceforge.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for !PREEMPT_COUNT
Date: Wed, 3 Apr 2013 19:41:22 +0530
Message-ID: <1364998282-21437-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <alpine.LFD.2.02.1304031433350.21884@ionos>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spinlocks built in a !PREEMPT_COUNT config don't have the compiler
barrier provided by preempt_* routines. This can break lot of code which
relies on barrier semantics.

This manifested as random crashes in timer code when stress testing
ARC Linux (3.9-rc3): !SMP && !PREEMPT_COUNT

Here's the exact sequence which caused this:
(0). tv1[x] <----> t1 <---> t2
(1). mod_timer(t1) interrupted after it calls timer_pending()
(2). mod_timer(t2) completes
(3). mod_timer(t1) resumes but messes up the list.
(4). __runt_timers( ) uses bogus timer_list entry / crashes in
     timer->function

when mod_timer() races against itself, the spinlock rightly serializes
the tv1[] timer link list, however timer_pending() called outside the
spinlock accesses timer's link list element, cached in a register.
With low register pressure (and a deep register file), there's nothing
forcing gcc to reload the element across the spinlock, causing a stale
value in register in case of race - ensuing a list corruption.

And the ARcompact disassembly which shows the culprit generated code:

mod_timer:
    push_s blink
    mov_s r13,r0	# timer, timer

..
    ###### timer_pending( )
    ld_s r3,[r13]       # <------ <variable>.entry.next LOADED
    brne r3, 0, @.L163

.L163:
..
    ###### spin_lock_irq( )
    lr  r5, [status32]  # flags
    bic r4, r5, 6       # temp, flags,
    and.f 0, r5, 6      # flags,
    flag.nz r4

    ###### detach_if_pending( ) begins

    tst_s r3,r3  <--------------
			# timer_pending( ) checks timer->entry.next
                        # r3 is NOT reloaded by gcc, using stale value
    beq.d @.L169
    mov.eq r0,0

    #####  detach_timer( ): __list_del( )

    ld r4,[r13,4]    	# <variable>.entry.prev, D.31439
    st r4,[r3,4]     	# <variable>.prev, D.31439

    st r3,[r4]       	# <variable>.next, D.30246

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Reported-by: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Pierrick Hascoet <pierrick.hascoet@abilis.com>
Cc: Robert Love <rml@tech9.net>
Cc: kpreempt-tech@lists.sourceforge.net
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 include/linux/preempt.h |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 5a710b9..354d6e3 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -93,14 +93,19 @@ do { \
 
 #else /* !CONFIG_PREEMPT_COUNT */
 
-#define preempt_disable()		do { } while (0)
-#define sched_preempt_enable_no_resched()	do { } while (0)
-#define preempt_enable_no_resched()	do { } while (0)
-#define preempt_enable()		do { } while (0)
-
-#define preempt_disable_notrace()		do { } while (0)
-#define preempt_enable_no_resched_notrace()	do { } while (0)
-#define preempt_enable_notrace()		do { } while (0)
+/*
+ * compiler barrier needed to ensure that spinlocks provide the barrier
+ * semantics despite !CONFIG_PREEMPT_COUNT.
+ * See commit log for actual bug which forced this change
+ */
+#define preempt_disable()			do { barrier(); } while (0)
+#define sched_preempt_enable_no_resched()	do { barrier(); } while (0)
+#define preempt_enable_no_resched()		do { barrier(); } while (0)
+#define preempt_enable()			do { barrier(); } while (0)
+
+#define preempt_disable_notrace()		do { barrier(); } while (0)
+#define preempt_enable_no_resched_notrace()	do { barrier(); } while (0)
+#define preempt_enable_notrace()		do { barrier(); } while (0)
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
-- 
1.7.10.4

