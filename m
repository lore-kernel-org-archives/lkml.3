Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960Ab3BMMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:09:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36569 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933821Ab3BMMJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:09:57 -0500
Date: Wed, 13 Feb 2013 04:08:34 -0800
From: tip-bot for Rik van Riel <riel@redhat.com>
Message-ID: <tip-4cf780c77b5ef7e3170f68820bc239a689c16d5b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, riel@redhat.com,
        aquini@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        walken@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        aquini@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        walken@google.com
In-Reply-To: <20130206150529.43150afa@cuia.bos.redhat.com>
References: <20130206150529.43150afa@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86/smp:
  Auto tune spinlock backoff delay factor
Git-Commit-ID: 4cf780c77b5ef7e3170f68820bc239a689c16d5b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 13 Feb 2013 04:08:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cf780c77b5ef7e3170f68820bc239a689c16d5b
Gitweb:     http://git.kernel.org/tip/4cf780c77b5ef7e3170f68820bc239a689c16d5b
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Wed, 6 Feb 2013 15:05:29 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Feb 2013 09:06:30 +0100

x86/smp: Auto tune spinlock backoff delay factor

Many spinlocks are embedded in data structures; having many CPUs
pounce on the cache line the lock is in will slow down the lock
holder, and can cause system performance to fall off a cliff.

The paper "Non-scalable locks are dangerous" is a good
reference:

	http://pdos.csail.mit.edu/papers/linux:lock.pdf

In the Linux kernel, spinlocks are optimized for the case of
there not being contention. After all, if there is contention,
the data structure can be improved to reduce or eliminate
lock contention.

Likewise, the spinlock API should remain simple, and the
common case of the lock not being contended should remain
as fast as ever.

However, since spinlock contention should be fairly uncommon,
we can add functionality into the spinlock slow path that keeps
system performance from falling off a cliff when there is lock
contention.

Proportional delay in ticket locks is delaying the time between
checking the ticket based on a delay factor, and the number of
CPUs ahead of us in the queue for this lock. Checking the lock
less often allows the lock holder to continue running, resulting
in better throughput and preventing performance from dropping
off a cliff.

Proportional spinlock delay with a high delay factor works well
when there is lots contention on a lock. Likewise, a smaller
delay factor works well when a lock is lightly contended.

Making the code auto-tune the delay factor results in a system
that performs well with both light and heavy lock contention.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Cc: eric.dumazet@gmail.com
Cc: lwoodman@redhat.com
Cc: knoel@redhat.com
Cc: chegu_vinod@hp.com
Cc: raghavendra.kt@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130206150529.43150afa@cuia.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smp.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index aa743e9..c1fce41 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -112,13 +112,34 @@
 static atomic_t stopping_cpu = ATOMIC_INIT(-1);
 static bool smp_no_nmi_ipi = false;
 
+#define DELAY_SHIFT			8
+#define DELAY_FIXED_1			(1<<DELAY_SHIFT)
+#define MIN_SPINLOCK_DELAY		(1 * DELAY_FIXED_1)
+#define MAX_SPINLOCK_DELAY		(16000 * DELAY_FIXED_1)
 /*
- * Wait on a congested ticket spinlock.
+ * Wait on a congested ticket spinlock. Many spinlocks are embedded in
+ * data structures; having many CPUs pounce on the cache line with the
+ * spinlock simultaneously can slow down the lock holder, and the system
+ * as a whole.
+ *
+ * To prevent total performance collapse in case of bad spinlock contention,
+ * perform proportional backoff. The per-cpu value of delay is automatically
+ * tuned to limit the number of times spinning CPUs poll the lock before
+ * obtaining it. This limits the amount of cross-CPU traffic required to obtain
+ * a spinlock, and keeps system performance from dropping off a cliff.
+ *
+ * There is a tradeoff. If we poll too often, the whole system is slowed
+ * down. If we sleep too long, the lock will go unused for a period of
+ * time. The solution is to go for a fast spin if we are at the head of
+ * the queue, to slowly increase the delay if we sleep for too short a
+ * time, and to decrease the delay if we slept for too long.
  */
+DEFINE_PER_CPU(unsigned, spinlock_delay) = { MIN_SPINLOCK_DELAY };
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
 	__ticket_t head = inc.head, ticket = inc.tail;
 	__ticket_t waiters_ahead;
+	unsigned delay = __this_cpu_read(spinlock_delay);
 	unsigned loops;
 
 	for (;;) {
@@ -133,14 +154,28 @@ void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 			} while (ACCESS_ONCE(lock->tickets.head) != ticket);
 			break;
 		}
-		loops = 50 * waiters_ahead;
+
+		/* Aggressively increase delay, to minimize lock accesses. */
+		if (delay < MAX_SPINLOCK_DELAY)
+			delay += DELAY_FIXED_1 / 7;
+
+		loops = (delay * waiters_ahead) >> DELAY_SHIFT;
 		while (loops--)
 			cpu_relax();
 
 		head = ACCESS_ONCE(lock->tickets.head);
-		if (head == ticket)
+		if (head == ticket) {
+			/*
+			 * We overslept, and do not know by how much.
+			 * Exponentially decay the value of delay,
+			 * to get it back to a good value quickly.
+			 */
+			if (delay >= 2 * DELAY_FIXED_1)
+				delay -= max(delay/32, DELAY_FIXED_1);
 			break;
+		}
 	}
+	__this_cpu_write(spinlock_delay, delay);
 }
 
 /*
