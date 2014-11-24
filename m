Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaKXNFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:05:55 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:47224 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaKXNDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:03:41 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-x86_64@vger.kernel.org, linux-s390"@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH/RFC 3/7] x86: Rework ACCESS_ONCE for spinlock code
Date: Mon, 24 Nov 2014 14:03:26 +0100
Message-Id: <1416834210-61738-4-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112413-0021-0000-0000-000001E3D229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Change the spinlock code to access the union members with
ACCESS_ONCE to avoid this problem.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/x86/include/asm/spinlock.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 9295016..168eb59 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -8,6 +8,7 @@
 #include <linux/compiler.h>
 #include <asm/paravirt.h>
 #include <asm/bitops.h>
+#include <asm/spinlock_types.h>
 
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
@@ -105,7 +106,7 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	arch_spinlock_t old, new;
 
-	old.tickets = ACCESS_ONCE(lock->tickets);
+	old.head_tail = ACCESS_ONCE(lock->head_tail);
 	if (old.tickets.head != (old.tickets.tail & ~TICKET_SLOWPATH_FLAG))
 		return 0;
 
@@ -162,16 +163,19 @@ static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
-	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+	arch_spinlock_t tmp = {};
 
-	return tmp.tail != tmp.head;
+	tmp.head_tail =ACCESS_ONCE(lock->head_tail);
+	return tmp.tickets.tail != tmp.tickets.head;
 }
 
 static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
-	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+	arch_spinlock_t tmp = {};
+
+	tmp.head_tail = ACCESS_ONCE(lock->head_tail);
+	return (__ticket_t)(tmp.tickets.tail - tmp.tickets.head) > TICKET_LOCK_INC;
 
-	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
 }
 #define arch_spin_is_contended	arch_spin_is_contended
 
-- 
1.9.3

