Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbaLKOF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:05:29 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:50071 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802AbaLKOF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:05:26 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, George Spelvin <linux@horizon.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 3/8] x86/spinlock: Replace ACCESS_ONCE with READ_ONCE
Date: Thu, 11 Dec 2014 15:05:06 +0100
Message-Id: <1418306712-17245-4-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
References: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121114-0021-0000-0000-0000021A74E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Change the spinlock code to replace ACCESS_ONCE with READ_ONCE.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/x86/include/asm/spinlock.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 9295016..12a69b4 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -92,7 +92,7 @@ static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
 		unsigned count = SPIN_THRESHOLD;
 
 		do {
-			if (ACCESS_ONCE(lock->tickets.head) == inc.tail)
+			if (READ_ONCE(lock->tickets.head) == inc.tail)
 				goto out;
 			cpu_relax();
 		} while (--count);
@@ -105,7 +105,7 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	arch_spinlock_t old, new;
 
-	old.tickets = ACCESS_ONCE(lock->tickets);
+	old.tickets = READ_ONCE(lock->tickets);
 	if (old.tickets.head != (old.tickets.tail & ~TICKET_SLOWPATH_FLAG))
 		return 0;
 
@@ -162,14 +162,14 @@ static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
-	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+	struct __raw_tickets tmp = READ_ONCE(lock->tickets);
 
 	return tmp.tail != tmp.head;
 }
 
 static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
-	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+	struct __raw_tickets tmp = READ_ONCE(lock->tickets);
 
 	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
 }
-- 
1.9.3

