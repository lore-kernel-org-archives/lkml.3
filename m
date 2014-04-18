Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaDRNNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:13:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaDRNNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:13:40 -0400
Date: Fri, 18 Apr 2014 06:13:03 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-xslfehiga1twbk5uk94rij1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,doc: Convert smp_mb__*()
Git-Commit-ID: 1b15611e1c30b37abe393d411c316cd659920bf5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b15611e1c30b37abe393d411c316cd659920bf5
Gitweb:     http://git.kernel.org/tip/1b15611e1c30b37abe393d411c316cd659920bf5
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:48 +0200

arch,doc: Convert smp_mb__*()

Update the documentation to reflect the change of barrier primitives.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/n/tip-xslfehiga1twbk5uk94rij1e@git.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/atomic_ops.txt      | 31 +++++++++++------------------
 Documentation/memory-barriers.txt | 42 ++++++++++-----------------------------
 2 files changed, 23 insertions(+), 50 deletions(-)

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index d9ca5be..68542fe 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -285,15 +285,13 @@ If a caller requires memory barrier semantics around an atomic_t
 operation which does not return a value, a set of interfaces are
 defined which accomplish this:
 
-	void smp_mb__before_atomic_dec(void);
-	void smp_mb__after_atomic_dec(void);
-	void smp_mb__before_atomic_inc(void);
-	void smp_mb__after_atomic_inc(void);
+	void smp_mb__before_atomic(void);
+	void smp_mb__after_atomic(void);
 
-For example, smp_mb__before_atomic_dec() can be used like so:
+For example, smp_mb__before_atomic() can be used like so:
 
 	obj->dead = 1;
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&obj->ref_count);
 
 It makes sure that all memory operations preceding the atomic_dec()
@@ -302,15 +300,10 @@ operation.  In the above example, it guarantees that the assignment of
 "1" to obj->dead will be globally visible to other cpus before the
 atomic counter decrement.
 
-Without the explicit smp_mb__before_atomic_dec() call, the
+Without the explicit smp_mb__before_atomic() call, the
 implementation could legally allow the atomic counter update visible
 to other cpus before the "obj->dead = 1;" assignment.
 
-The other three interfaces listed are used to provide explicit
-ordering with respect to memory operations after an atomic_dec() call
-(smp_mb__after_atomic_dec()) and around atomic_inc() calls
-(smp_mb__{before,after}_atomic_inc()).
-
 A missing memory barrier in the cases where they are required by the
 atomic_t implementation above can have disastrous results.  Here is
 an example, which follows a pattern occurring frequently in the Linux
@@ -487,12 +480,12 @@ Finally there is the basic operation:
 Which returns a boolean indicating if bit "nr" is set in the bitmask
 pointed to by "addr".
 
-If explicit memory barriers are required around clear_bit() (which
-does not return a value, and thus does not need to provide memory
-barrier semantics), two interfaces are provided:
+If explicit memory barriers are required around {set,clear}_bit() (which do
+not return a value, and thus does not need to provide memory barrier
+semantics), two interfaces are provided:
 
-	void smp_mb__before_clear_bit(void);
-	void smp_mb__after_clear_bit(void);
+	void smp_mb__before_atomic(void);
+	void smp_mb__after_atomic(void);
 
 They are used as follows, and are akin to their atomic_t operation
 brothers:
@@ -500,13 +493,13 @@ brothers:
 	/* All memory operations before this call will
 	 * be globally visible before the clear_bit().
 	 */
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit( ... );
 
 	/* The clear_bit() will be visible before all
 	 * subsequent memory operations.
 	 */
-	 smp_mb__after_clear_bit();
+	 smp_mb__after_atomic();
 
 There are two special bitops with lock barrier semantics (acquire/release,
 same as spinlocks). These operate in the same way as their non-_lock/unlock
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 556f951..46412bd 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1583,20 +1583,21 @@ There are some more advanced barrier functions:
      insert anything more than a compiler barrier in a UP compilation.
 
 
- (*) smp_mb__before_atomic_dec();
- (*) smp_mb__after_atomic_dec();
- (*) smp_mb__before_atomic_inc();
- (*) smp_mb__after_atomic_inc();
+ (*) smp_mb__before_atomic();
+ (*) smp_mb__after_atomic();
 
-     These are for use with atomic add, subtract, increment and decrement
-     functions that don't return a value, especially when used for reference
-     counting.  These functions do not imply memory barriers.
+     These are for use with atomic (such as add, subtract, increment and
+     decrement) functions that don't return a value, especially when used for
+     reference counting.  These functions do not imply memory barriers.
+
+     These are also used for atomic bitop functions that do not return a
+     value (such as set_bit and clear_bit).
 
      As an example, consider a piece of code that marks an object as being dead
      and then decrements the object's reference count:
 
 	obj->dead = 1;
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&obj->ref_count);
 
      This makes sure that the death mark on the object is perceived to be set
@@ -1606,27 +1607,6 @@ There are some more advanced barrier functions:
      operations" subsection for information on where to use these.
 
 
- (*) smp_mb__before_clear_bit(void);
- (*) smp_mb__after_clear_bit(void);
-
-     These are for use similar to the atomic inc/dec barriers.  These are
-     typically used for bitwise unlocking operations, so care must be taken as
-     there are no implicit memory barriers here either.
-
-     Consider implementing an unlock operation of some nature by clearing a
-     locking bit.  The clear_bit() would then need to be barriered like this:
-
-	smp_mb__before_clear_bit();
-	clear_bit( ... );
-
-     This prevents memory operations before the clear leaking to after it.  See
-     the subsection on "Locking Functions" with reference to RELEASE operation
-     implications.
-
-     See Documentation/atomic_ops.txt for more information.  See the "Atomic
-     operations" subsection for information on where to use these.
-
-
 MMIO WRITE BARRIER
 ------------------
 
@@ -2283,11 +2263,11 @@ operations:
 	change_bit();
 
 With these the appropriate explicit memory barrier should be used if necessary
-(smp_mb__before_clear_bit() for instance).
+(smp_mb__before_atomic() for instance).
 
 
 The following also do _not_ imply memory barriers, and so may require explicit
-memory barriers under some circumstances (smp_mb__before_atomic_dec() for
+memory barriers under some circumstances (smp_mb__before_atomic() for
 instance):
 
 	atomic_add();
