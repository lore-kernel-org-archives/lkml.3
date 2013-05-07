Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab3EGNrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:47:13 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42118 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933621Ab3EGNqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:37 -0400
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: Alex Shi <alex.shi@intel.com>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 13/14] x86 rwsem: avoid taking slow path when stealing write lock
Date: Tue,  7 May 2013 06:46:01 -0700
Message-Id: <1367934362-10433-14-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367934362-10433-1-git-send-email-walken@google.com>
References: <1367934362-10433-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modify __down_write[_nested] and __down_write_trylock to grab the write
lock whenever the active count is 0, even if there are queued waiters
(they must be writers pending wakeup, since the active count is 0).

Note that this is an optimization only; architectures without this
optimization will still work fine:

- __down_write() would take the slow path which would take the wait_lock
  and then try stealing the lock (as in the spinlocked rwsem implementation)

- __down_write_trylock() would fail, but callers must be ready to deal
  with that - since there are some writers pending wakeup, they could
  have raced with us and obtained the lock before we steal it.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 arch/x86/include/asm/rwsem.h | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 2dbe4a721ce5..cad82c9c2fde 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -105,8 +105,8 @@ static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 	asm volatile("# beginning down_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* adds 0xffff0001, returns the old value */
-		     "  test      %1,%1\n\t"
-		     /* was the count 0 before? */
+		     "  test " __ASM_SEL(%w1,%k1) "," __ASM_SEL(%w1,%k1) "\n\t"
+		     /* was the active mask 0 before? */
 		     "  jz        1f\n"
 		     "  call call_rwsem_down_write_failed\n"
 		     "1:\n"
@@ -126,11 +126,25 @@ static inline void __down_write(struct rw_semaphore *sem)
  */
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	long ret = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
-			   RWSEM_ACTIVE_WRITE_BIAS);
-	if (ret == RWSEM_UNLOCKED_VALUE)
-		return 1;
-	return 0;
+	long result, tmp;
+	asm volatile("# beginning __down_write_trylock\n\t"
+		     "  mov          %0,%1\n\t"
+		     "1:\n\t"
+		     "  test " __ASM_SEL(%w1,%k1) "," __ASM_SEL(%w1,%k1) "\n\t"
+		     /* was the active mask 0 before? */
+		     "  jnz          2f\n\t"
+		     "  mov          %1,%2\n\t"
+		     "  add          %3,%2\n\t"
+		     LOCK_PREFIX "  cmpxchg  %2,%0\n\t"
+		     "  jnz	     1b\n\t"
+		     "2:\n\t"
+		     "  sete         %b1\n\t"
+		     "  movzbl       %b1, %k1\n\t"
+		     "# ending __down_write_trylock\n\t"
+		     : "+m" (sem->count), "=&a" (result), "=&r" (tmp)
+		     : "er" (RWSEM_ACTIVE_WRITE_BIAS)
+		     : "memory", "cc");
+	return result;
 }
 
 /*
-- 
1.8.2.1

