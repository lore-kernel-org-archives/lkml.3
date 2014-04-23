Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbaDWOYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:24:11 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:36115 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbaDWOYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:24:07 -0400
Message-ID: <5357CCEF.2000606@hp.com>
Date: Wed, 23 Apr 2014 10:23:43 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 05/19] qspinlock: Optimize for smaller NR_CPUS
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com> <1397747051-15401-6-git-send-email-Waiman.Long@hp.com> <20140417155649.GR11096@twins.programming.kicks-ass.net> <53504BB3.4010009@hp.com> <20140418082716.GZ11096@twins.programming.kicks-ass.net> <53516672.3010701@hp.com> <20140418190519.GA11182@twins.programming.kicks-ass.net> <53519BBF.7060506@hp.com>
In-Reply-To: <53519BBF.7060506@hp.com>
Content-Type: multipart/mixed;
 boundary="------------020601050200020304070000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020601050200020304070000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/18/2014 05:40 PM, Waiman Long wrote:
> On 04/18/2014 03:05 PM, Peter Zijlstra wrote:
>> On Fri, Apr 18, 2014 at 01:52:50PM -0400, Waiman Long wrote:
>>> I am confused by your notation.
>> Nah, I think I was confused :-) Make the 1 _Q_LOCKED_VAL though, as
>> that's the proper constant to use.
>
> Everyone gets confused once in a while:-) I have plenty of that myself.
>
> I will change 1 to _Q_LOCKED_VAL as suggested.
>
> -Longman


The attached patch file contains the additional changes that I had made 
to qspinlock.c file so far. Please let me know if you or others have any 
additional feedbacks or changes that will need to go to the next version 
of the patch series.

I am going to take vacation starting from tomorrow and will be back on 
5/5 (Mon). So I will not be able to respond to emails within this period.

BTW, is there any chance that this patch can be merged to 3.16?

-Longman

--------------020601050200020304070000
Content-Type: text/plain;
 name="qspinlock_extra_diff.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="qspinlock_extra_diff.patch"

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index be2adca..2e184b8 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -25,10 +25,6 @@
 #include <asm/byteorder.h>
 #include <asm/qspinlock.h>
 
-#if !defined(__LITTLE_ENDIAN) && !defined(__BIG_ENDIAN)
-#error "Missing either LITTLE_ENDIAN or BIG_ENDIAN definition."
-#endif
-
 /*
  * The basic principle of a queue-based spinlock can best be understood
  * by studying a classic queue-based spinlock implementation called the
@@ -200,7 +196,7 @@ clear_pending_set_locked(struct qspinlock *lock, u32 val)
 {
 	struct __qspinlock *l = (void *)lock;
 
-	ACCESS_ONCE(l->locked_pending) = 1;
+	ACCESS_ONCE(l->locked_pending) = _Q_LOCKED_VAL;
 }
 
 /*
@@ -567,16 +563,16 @@ static __always_inline int get_qlock(struct qspinlock *lock)
 /**
  * trylock_pending - try to acquire queue spinlock using the pending bit
  * @lock : Pointer to queue spinlock structure
- * @pval : Pointer to value of the queue spinlock 32-bit word
+ * @val  : Current value of the queue spinlock 32-bit word
  * Return: 1 if lock acquired, 0 otherwise
  *
  * The pending bit won't be set as soon as one or more tasks queue up.
  * This function should only be called when lock stealing will not happen.
  * Otherwise, it has to be disabled.
  */
-static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
+static inline int trylock_pending(struct qspinlock *lock, u32 val)
 {
-	u32 old, new, val = *pval;
+	u32 old, new;
 	int retry = 1;
 
 	/*
@@ -593,8 +589,7 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 		if (val & _Q_TAIL_MASK)
 			return 0;
 
-		if ((val & _Q_LOCKED_PENDING_MASK) ==
-		    (_Q_LOCKED_VAL|_Q_PENDING_VAL)) {
+		if (val == (_Q_LOCKED_VAL|_Q_PENDING_VAL)) {
 			/*
 			 * If both the lock and pending bits are set, we wait
 			 * a while to see if that either bit will be cleared.
@@ -605,9 +600,9 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 			retry--;
 			cpu_relax();
 			cpu_relax();
-			*pval = val = atomic_read(&lock->val);
+			val = atomic_read(&lock->val);
 			continue;
-		} else if ((val & _Q_LOCKED_PENDING_MASK) == _Q_PENDING_VAL) {
+		} else if (val == _Q_PENDING_VAL) {
 			/*
 			 * Pending bit is set, but not the lock bit.
 			 * Assuming that the pending bit holder is going to
@@ -615,7 +610,7 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 			 * it is better to wait than to exit at this point.
 			 */
 			cpu_relax();
-			*pval = val = atomic_read(&lock->val);
+			val = atomic_read(&lock->val);
 			continue;
 		}
 
@@ -627,7 +622,7 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 		if (old == val)
 			break;
 
-		*pval = val = old;
+		val = old;
 	}
 
 	/*
@@ -643,7 +638,7 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 	 *
 	 * this wait loop must be a load-acquire such that we match the
 	 * store-release that clears the locked bit and create lock
-	 * sequentiality; this because not all try_clear_pending_set_locked()
+	 * sequentiality; this because not all clear_pending_set_locked()
 	 * implementations imply full barriers.
 	 *
 	 * When PV qspinlock is enabled, exit the pending bit code path and
@@ -835,6 +830,10 @@ notify_next:
  * contended             :    (*,x,y) +--> (*,0,0) ---> (*,0,1) -'  :
  *   queue               :         ^--'                             :
  *
+ * The pending bit processing is in the trylock_pending() function whereas
+ * the uncontended and contended queue processing is in the
+ * queue_spin_lock_slowerpath() function.
+ *
  * This slowpath only contains the faster pending bit and trylock codes.
  * The slower queuing code is in the slowerpath function.
  */
@@ -845,7 +844,7 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
-	if (trylock_pending(lock, &val))
+	if (trylock_pending(lock, val))
 		return;	/* Lock acquired */
 
 	node = this_cpu_ptr(&qnodes[0]);
@@ -859,11 +858,11 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	pv_init_vars(&node->pv, cpu_nr);
 
 	/*
-	 * We touched a (possibly) cold cacheline; attempt the trylock once
-	 * more in the hope someone let go while we weren't watching as long
-	 * as no one was queuing.
+	 * We touched a (possibly) cold cacheline in the per-cpu queue node;
+	 * attempt the trylock once more in the hope someone let go while we
+	 * weren't watching.
 	 */
-	if ((val & _Q_TAIL_MASK) || !queue_spin_trylock(lock))
+	if (!queue_spin_trylock(lock))
 		queue_spin_lock_slowerpath(lock, node, tail);
 
 	/*

--------------020601050200020304070000--
