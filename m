Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaJHPhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:37:51 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:48075 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaJHPht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:37:49 -0400
Message-ID: <1412782664.5179.75.camel@marge.simpson.net>
Subject: bisected: futex regression >= 3.14 - was - Slowdown due to threads
 bouncing between HT cores
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 08 Oct 2014 17:37:44 +0200
In-Reply-To: <20141003194428.GA27084@sesse.net>
References: <20141003194428.GA27084@sesse.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems you opened a can of futex worms...

On Fri, 2014-10-03 at 21:44 +0200, Steinar H. Gunderson wrote: 
> Hi,
> 
> I did a chess benchmark of my new machine (2x E5-2650v3, so 20x2.3GHz
> Haswell-EP), and it performed a bit worse than comparable Windows setups.
> It looks like the scheduler somehow doesn't perform as well with
> hyperthreading; HT is on in the BIOS, but I'm only using 20 threads
> (chess scales sublinearly, so using all 40 usually isn't a good idea),
> so really, the threads should just get one core each and that's it.
> It looks like they are bouncing between cores, reducing overall performance
> by ~20% for some reason. (The machine is otherwise generally idle.)
> 
> First some details to reproduce more easily. Kernel version is 3.16.3, 64-bit
> x86, Debian stable (so gcc 4.7.2). The benchmark binary is a chess engine
> knows as Stockfish; this is the compile I used (because that's what everyone
> else is benchmarking with):
> 
>   http://abrok.eu/stockfish/builds/dbd6156fceaf9bec8e9ff14f99c325c36b284079/linux64modernsse/stockfish_13111907_x64_modern_sse42
> 
> Stockfish is GPL, so the source is readily available if you should need it.
> 
> The benchmark is run with by just running the binary, then giving it these
> commands one by one:
> 
> uci
> setoption name Threads value 20
> setoption name Hash value 1024
> position fen rnbq1rk1/pppnbppp/4p3/3pP1B1/3P3P/2N5/PPP2PP1/R2QKBNR w KQ – 0 7
> go wtime 7200000 winc 30000 btime 7200000 binc 30000
> 
> After ~3 minutes, it will output “bestmove d1g4 ponder f8e8”. A few lines
> above that, you'll see a line with something similar to “nps 13266463”.
> That's nodes per second, and you want it to be higher.
> 
> So, benchmark:
> 
>  - Default: 13266 kN/sec
>  - Change from ondemand to performance on all cores: 14600 kN/sec
>  - taskset -c 0-19 (locking affinity to only one set of hyperthreads):
>    17512 kN/sec
> 
> There is some local variation, but it's typically within a few percent.
> Does anyone know what's going on? I have CONFIG_SCHED_SMT=y and
> CONFIG_SCHED_MC=y.
> 
> /* Steinar */

I don't see that on the 2 x E5-2697 box I borrowed to take a peek.  Once
I got stockfish to actually run to completion by hunting down and brute
force reverting the below, I see ~32 million nodes/sec throughput with
3.17 whether I use taskset or just let it do its thing.

Without the revert, the thing starts up fine, runs for 5 seconds or so,
then comes to a screeching halt with one thread looping endlessly...

1412780609.892144 futex(0xd3ed18, FUTEX_WAKE_PRIVATE, 1) = 0 <0.000034>
1412780609.892216 futex(0xd3ed44, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 248307, {1412780609, 897000000}, ffffffff) = -1 ETIMEDOUT (Connection timed out) <0.004857>
1412780609.897144 futex(0xd3ed18, FUTEX_WAKE_PRIVATE, 1) = 0 <0.000021>
1412780609.897202 futex(0xd3ed44, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 248309, {1412780609, 902000000}, ffffffff) = -1 ETIMEDOUT (Connection timed out) <0.004862>
1412780609.902157 futex(0xd3ed18, FUTEX_WAKE_PRIVATE, 1) = 0 <0.000025>
1412780609.902226 futex(0xd3ed44, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 248311, {1412780609, 907000000}, ffffffff) = -1 ETIMEDOUT (Connection timed out) <0.004845>
1412780609.907144 futex(0xd3ed18, FUTEX_WAKE_PRIVATE, 1) = 0 <0.000021>
1412780609.907202 futex(0xd3ed44, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 248313, {1412780609, 912000000}, ffffffff^CProcess 2756 detached
 <detached ...>

I have not seen this on my little single socket E5620 box, nor on my 8
socket 64 core DL980, but the DL980 is a poor crippled thing (8GB ram,
interleaved), so may be too much of a slug (race? me? really!?!) to make
anything bad happen.  The 2 socket E5-2697 (28 core) box OTOH is a fully
repeatable fail.

#!/bin/sh

stockfish <<%EOF
uci
setoption name Threads value 28
setoption name Hash value 1024
position fen rnbq1rk1/pppnbppp/4p3/3pP1B1/3P3P/2N5/PPP2PP1/R2QKBNR w KQ – 0 7
go wtime 7200000 winc 30000 btime 7200000 binc 30000

%EOF

11d4616bd07f38d496bd489ed8fad1dc4d928823 is the first bad commit
commit 11d4616bd07f38d496bd489ed8fad1dc4d928823
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Mar 20 22:11:17 2014 -0700

    futex: revert back to the explicit waiter counting code
    
    Srikar Dronamraju reports that commit b0c29f79ecea ("futexes: Avoid
    taking the hb->lock if there's nothing to wake up") causes java threads
    getting stuck on futexes when runing specjbb on a power7 numa box.
    
    The cause appears to be that the powerpc spinlocks aren't using the same
    ticket lock model that we use on x86 (and other) architectures, which in
    turn result in the "spin_is_locked()" test in hb_waiters_pending()
    occasionally reporting an unlocked spinlock even when there are pending
    waiters.
    
    So this reinstates Davidlohr Bueso's original explicit waiter counting
    code, which I had convinced Davidlohr to drop in favor of figuring out
    the pending waiters by just using the existing state of the spinlock and
    the wait queue.
    
    Reported-and-tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    Original-code-by: Davidlohr Bueso <davidlohr@hp.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 6db0586dfa6e007f8feb4d230b5dfa70751a74e2 3c77ee44544ac3e9dfd17abac706cd4ebbacdd51 M	kernel


git bisect start
# good: [d8ec26d7f8287f5788a494f56e8814210f0e64be] Linux 3.13
git bisect good d8ec26d7f8287f5788a494f56e8814210f0e64be
# bad: [455c6fdbd219161bd09b1165f11699d6d73de11c] Linux 3.14
git bisect bad 455c6fdbd219161bd09b1165f11699d6d73de11c
# good: [82c477669a4665eb4e52030792051e0559ee2a36] Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 82c477669a4665eb4e52030792051e0559ee2a36
# good: [ca2a650f3dfdc30d71d21bcbb04d2d057779f3f9] Merge branch 'for-linus' of git://git.infradead.org/users/vkoul/slave-dma
git bisect good ca2a650f3dfdc30d71d21bcbb04d2d057779f3f9
# good: [f2de3a159937bfb1ab1ca671e0f2d06cda286a24] Merge tag 'sound-3.14-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good f2de3a159937bfb1ab1ca671e0f2d06cda286a24
# good: [9b3e7c9b9ab5c2827c1ecd45327b851a1bd01c2a] Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 9b3e7c9b9ab5c2827c1ecd45327b851a1bd01c2a
# good: [52a4c6404f91f2d2c5592ee6365a8418c4565f53] selinux: add gfp argument to security_xfrm_policy_alloc and fix callers
git bisect good 52a4c6404f91f2d2c5592ee6365a8418c4565f53
# good: [53611c0ce9f6e2fa2e31f9ab4ad8c08c512085ba] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good 53611c0ce9f6e2fa2e31f9ab4ad8c08c512085ba
# bad: [b37199e626b31e1175fb06764c5d1d687723aac2] rcuwalk: recheck mount_lock after mountpoint crossing attempts
git bisect bad b37199e626b31e1175fb06764c5d1d687723aac2
# good: [004e5cf743086990e5fc04a14437b3966d7fa9a2] Merge branch 'exynos-drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos into drm-fixes
git bisect good 004e5cf743086990e5fc04a14437b3966d7fa9a2
# good: [7c3895383fea48dab2374b04a936de4717a85a81] Merge branch 'for-3.14-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
git bisect good 7c3895383fea48dab2374b04a936de4717a85a81
# good: [477cc48484ea0bfdee9e8319259b35a0ec03f332] Merge tag 'trace-fixes-v3.14-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect good 477cc48484ea0bfdee9e8319259b35a0ec03f332
# bad: [084c6c5013af3c62f1c344435214496f5ac999f2] Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect bad 084c6c5013af3c62f1c344435214496f5ac999f2
# bad: [08edb33c4e1b810011f21d7705811b7b9a0535f0] Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
git bisect bad 08edb33c4e1b810011f21d7705811b7b9a0535f0
# bad: [708f04d2abf4e90abee61d9ffb1f165038017ecf] block: free q->flush_rq in blk_init_allocated_queue error paths
git bisect bad 708f04d2abf4e90abee61d9ffb1f165038017ecf
# bad: [11d4616bd07f38d496bd489ed8fad1dc4d928823] futex: revert back to the explicit waiter counting code
git bisect bad 11d4616bd07f38d496bd489ed8fad1dc4d928823
# first bad commit: [11d4616bd07f38d496bd489ed8fad1dc4d928823] futex: revert back to the explicit waiter counting code


Bend spindle mutilate like so, and it works:

 kernel/futex.c | 58 ++++++++++------------------------------------------------
 1 file changed, 10 insertions(+), 48 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 815d7af..cbb9fc4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -250,7 +250,6 @@ static const struct futex_q futex_q_init = {
  * waiting on a futex.
  */
 struct futex_hash_bucket {
-	atomic_t waiters;
 	spinlock_t lock;
 	struct plist_head chain;
 } ____cacheline_aligned_in_smp;
@@ -270,37 +269,22 @@ static inline void futex_get_mm(union futex_key *key)
 	smp_mb__after_atomic();
 }
 
-/*
- * Reflects a new waiter being added to the waitqueue.
- */
-static inline void hb_waiters_inc(struct futex_hash_bucket *hb)
+static inline bool hb_waiters_pending(struct futex_hash_bucket *hb)
 {
 #ifdef CONFIG_SMP
-	atomic_inc(&hb->waiters);
 	/*
-	 * Full barrier (A), see the ordering comment above.
+	 * Tasks trying to enter the critical region are most likely
+	 * potential waiters that will be added to the plist. Ensure
+	 * that wakers won't miss to-be-slept tasks in the window between
+	 * the wait call and the actual plist_add.
 	 */
-	smp_mb__after_atomic();
-#endif
-}
-
-/*
- * Reflects a waiter being removed from the waitqueue by wakeup
- * paths.
- */
-static inline void hb_waiters_dec(struct futex_hash_bucket *hb)
-{
-#ifdef CONFIG_SMP
-	atomic_dec(&hb->waiters);
-#endif
-}
+	if (spin_is_locked(&hb->lock))
+		return true;
+	smp_rmb(); /* Make sure we check the lock state first */
 
-static inline int hb_waiters_pending(struct futex_hash_bucket *hb)
-{
-#ifdef CONFIG_SMP
-	return atomic_read(&hb->waiters);
+	return !plist_head_empty(&hb->chain);
 #else
-	return 1;
+	return true;
 #endif
 }
 
@@ -1071,7 +1055,6 @@ static void __unqueue_futex(struct futex_q *q)
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
 	plist_del(&q->list, &hb->chain);
-	hb_waiters_dec(hb);
 }
 
 /*
@@ -1356,9 +1339,7 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 	 */
 	if (likely(&hb1->chain != &hb2->chain)) {
 		plist_del(&q->list, &hb1->chain);
-		hb_waiters_dec(hb1);
 		plist_add(&q->list, &hb2->chain);
-		hb_waiters_inc(hb2);
 		q->lock_ptr = &hb2->lock;
 	}
 	get_futex_key_refs(key2);
@@ -1549,7 +1530,6 @@ retry:
 	hb2 = hash_futex(&key2);
 
 retry_private:
-	hb_waiters_inc(hb2);
 	double_lock_hb(hb1, hb2);
 
 	if (likely(cmpval != NULL)) {
@@ -1559,7 +1539,6 @@ retry_private:
 
 		if (unlikely(ret)) {
 			double_unlock_hb(hb1, hb2);
-			hb_waiters_dec(hb2);
 
 			ret = get_user(curval, uaddr1);
 			if (ret)
@@ -1618,7 +1597,6 @@ retry_private:
 			break;
 		case -EFAULT:
 			double_unlock_hb(hb1, hb2);
-			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
 			put_futex_key(&key1);
 			ret = fault_in_user_writeable(uaddr2);
@@ -1633,7 +1611,6 @@ retry_private:
 			 * - The user space value changed.
 			 */
 			double_unlock_hb(hb1, hb2);
-			hb_waiters_dec(hb2);
 			put_futex_key(&key2);
 			put_futex_key(&key1);
 			cond_resched();
@@ -1709,7 +1686,6 @@ retry_private:
 
 out_unlock:
 	double_unlock_hb(hb1, hb2);
-	hb_waiters_dec(hb2);
 
 	/*
 	 * drop_futex_key_refs() must be called outside the spinlocks. During
@@ -1737,17 +1713,6 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 	struct futex_hash_bucket *hb;
 
 	hb = hash_futex(&q->key);
-
-	/*
-	 * Increment the counter before taking the lock so that
-	 * a potential waker won't miss a to-be-slept task that is
-	 * waiting for the spinlock. This is safe as all queue_lock()
-	 * users end up calling queue_me(). Similarly, for housekeeping,
-	 * decrement the counter at queue_unlock() when some error has
-	 * occurred and we don't end up adding the task to the list.
-	 */
-	hb_waiters_inc(hb);
-
 	q->lock_ptr = &hb->lock;
 
 	spin_lock(&hb->lock); /* implies MB (A) */
@@ -1759,7 +1724,6 @@ queue_unlock(struct futex_hash_bucket *hb)
 	__releases(&hb->lock)
 {
 	spin_unlock(&hb->lock);
-	hb_waiters_dec(hb);
 }
 
 /**
@@ -2482,7 +2446,6 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * Unqueue the futex_q and determine which it was.
 		 */
 		plist_del(&q->list, &hb->chain);
-		hb_waiters_dec(hb);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
@@ -3035,7 +2998,6 @@ static int __init futex_init(void)
 	futex_detect_cmpxchg();
 
 	for (i = 0; i < futex_hashsize; i++) {
-		atomic_set(&futex_queues[i].waiters, 0);
 		plist_head_init(&futex_queues[i].chain);
 		spin_lock_init(&futex_queues[i].lock);
 	}



