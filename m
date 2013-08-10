Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966234Ab3HJQOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:14:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808Ab3HJQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:14:44 -0400
Date: Sat, 10 Aug 2013 09:14:27 -0700
From: tip-bot for Jeremy Fitzhardinge <tipbot@zytor.com>
Message-ID: <tip-4a1ed4ca681e7df38ed1b609a11aab38cbc515b3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com, attilio.rao@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com, attilio.rao@citrix.com
In-Reply-To: <1376058122-8248-9-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1376058122-8248-9-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, pvticketlock:
  When paravirtualizing ticket locks, increment by 2
Git-Commit-ID: 4a1ed4ca681e7df38ed1b609a11aab38cbc515b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 10 Aug 2013 09:14:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a1ed4ca681e7df38ed1b609a11aab38cbc515b3
Gitweb:     http://git.kernel.org/tip/4a1ed4ca681e7df38ed1b609a11aab38cbc515b3
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Fri, 9 Aug 2013 19:51:56 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Aug 2013 07:53:50 -0700

x86, pvticketlock: When paravirtualizing ticket locks, increment by 2

Increment ticket head/tails by 2 rather than 1 to leave the LSB free
to store a "is in slowpath state" bit.  This halves the number
of possible CPUs for a given ticket size, but this shouldn't matter
in practice - kernels built for 32k+ CPU systems are probably
specially built for the hardware rather than a generic distro
kernel.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Link: http://lkml.kernel.org/r/1376058122-8248-9-git-send-email-raghavendra.kt@linux.vnet.ibm.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Attilio Rao <attilio.rao@citrix.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/spinlock.h       | 10 +++++-----
 arch/x86/include/asm/spinlock_types.h | 10 +++++++++-
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 7442410..04a5cd5 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -78,7 +78,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
  */
 static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
 {
-	register struct __raw_tickets inc = { .tail = 1 };
+	register struct __raw_tickets inc = { .tail = TICKET_LOCK_INC };
 
 	inc = xadd(&lock->tickets, inc);
 
@@ -104,7 +104,7 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 	if (old.tickets.head != old.tickets.tail)
 		return 0;
 
-	new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
+	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
 
 	/* cmpxchg is a full barrier, so nothing can move before it */
 	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
@@ -112,9 +112,9 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 
 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
-	__ticket_t next = lock->tickets.head + 1;
+	__ticket_t next = lock->tickets.head + TICKET_LOCK_INC;
 
-	__add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
+	__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);
 	__ticket_unlock_kick(lock, next);
 }
 
@@ -129,7 +129,7 @@ static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return (__ticket_t)(tmp.tail - tmp.head) > 1;
+	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
 }
 #define arch_spin_is_contended	arch_spin_is_contended
 
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 83fd3c7..e96fcbd 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -3,7 +3,13 @@
 
 #include <linux/types.h>
 
-#if (CONFIG_NR_CPUS < 256)
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#define __TICKET_LOCK_INC	2
+#else
+#define __TICKET_LOCK_INC	1
+#endif
+
+#if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
 typedef u8  __ticket_t;
 typedef u16 __ticketpair_t;
 #else
@@ -11,6 +17,8 @@ typedef u16 __ticket_t;
 typedef u32 __ticketpair_t;
 #endif
 
+#define TICKET_LOCK_INC	((__ticket_t)__TICKET_LOCK_INC)
+
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
 
 typedef struct arch_spinlock {
