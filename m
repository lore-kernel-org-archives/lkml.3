Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966887Ab3HHXUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 19:20:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966455Ab3HHXUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 19:20:47 -0400
Date: Thu, 8 Aug 2013 16:19:29 -0700
From: tip-bot for Jeremy Fitzhardinge <tipbot@zytor.com>
Message-ID: <tip-c1230bf0bf6c93ff2db93ba0b66839068f498e8b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com, attilio.rao@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com, attilio.rao@citrix.com
In-Reply-To: <20130806114120.20643.87847.sendpatchset@codeblue.in.ibm.com>
References: <20130806114120.20643.87847.sendpatchset@codeblue.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, ticketlock:
  Collapse a layer of functions
Git-Commit-ID: c1230bf0bf6c93ff2db93ba0b66839068f498e8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 08 Aug 2013 16:19:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1230bf0bf6c93ff2db93ba0b66839068f498e8b
Gitweb:     http://git.kernel.org/tip/c1230bf0bf6c93ff2db93ba0b66839068f498e8b
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Tue, 6 Aug 2013 17:11:20 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 8 Aug 2013 16:06:30 -0700

x86, ticketlock: Collapse a layer of functions

Now that the paravirtualization layer doesn't exist at the spinlock
level any more, we can collapse the __ticket_ functions into the arch_
functions.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Link: http://lkml.kernel.org/r/20130806114120.20643.87847.sendpatchset@codeblue.in.ibm.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Attilio Rao <attilio.rao@citrix.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/spinlock.h | 35 +++++------------------------------
 1 file changed, 5 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 4d54244..7442410 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -76,7 +76,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
  * in the high part, because a wide xadd increment of the low part would carry
  * up and contaminate the high part.
  */
-static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
+static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
 {
 	register struct __raw_tickets inc = { .tail = 1 };
 
@@ -96,7 +96,7 @@ static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
 out:	barrier();	/* make sure nothing creeps before the lock is taken */
 }
 
-static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
+static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	arch_spinlock_t old, new;
 
@@ -110,7 +110,7 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
 }
 
-static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
+static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	__ticket_t next = lock->tickets.head + 1;
 
@@ -118,46 +118,21 @@ static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 	__ticket_unlock_kick(lock, next);
 }
 
-static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
 	return tmp.tail != tmp.head;
 }
 
-static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
+static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
 	return (__ticket_t)(tmp.tail - tmp.head) > 1;
 }
-
-static inline int arch_spin_is_locked(arch_spinlock_t *lock)
-{
-	return __ticket_spin_is_locked(lock);
-}
-
-static inline int arch_spin_is_contended(arch_spinlock_t *lock)
-{
-	return __ticket_spin_is_contended(lock);
-}
 #define arch_spin_is_contended	arch_spin_is_contended
 
-static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
-{
-	__ticket_spin_lock(lock);
-}
-
-static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
-{
-	return __ticket_spin_trylock(lock);
-}
-
-static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
-{
-	__ticket_spin_unlock(lock);
-}
-
 static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 						  unsigned long flags)
 {
