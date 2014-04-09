Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbaDITD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:03:27 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:54053 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481AbaDITDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:03:25 -0400
Message-ID: <1397070203.2608.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Stancek <jstancek@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Larry Woodman <lwoodman@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>
Date: Wed, 09 Apr 2014 12:03:23 -0700
In-Reply-To: <CA+55aFx3vx+A1nmbUikDv1ddy-wJNGYzGDjSaiQz0BoXjLEEzA@mail.gmail.com>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
	 <CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
	 <CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com>
	 <20140408181305.GT10526@twins.programming.kicks-ass.net>
	 <CA+55aFz+yMdXfsb-t3JzDhj6=M=-ggjDDGAQSbtfEcNhgyoopA@mail.gmail.com>
	 <1860555101.1890107.1396990941681.JavaMail.zimbra@redhat.com>
	 <CA+55aFzYwNde4ZyKgy_raRx9nz4+8he1-Fk9+_DDhWs-7fBbjw@mail.gmail.com>
	 <1096300004.2306764.1397043990013.JavaMail.zimbra@redhat.com>
	 <CA+55aFx3vx+A1nmbUikDv1ddy-wJNGYzGDjSaiQz0BoXjLEEzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 08:12 -0700, Linus Torvalds wrote:
> On Wed, Apr 9, 2014 at 4:46 AM, Jan Stancek <jstancek@redhat.com> wrote:
> >
> >
> > I'm running reproducer with this patch applied on 3 systems:
> > - two s390x systems where this can be reproduced within seconds
> > - x86_64 Intel(R) Xeon(R) CPU E5240 @ 3.00GHz, where I could
> >   reproduce it on average in ~3 minutes.
> >
> > It's running without failure over 4 hours now.
> 
> Ok. I committed my second patch.

As things stand now, we *really* need to update our documentation before
time passes and our brain goes somewhere else just to get back to the
code and get (more) headaches. Either now, or sometime before 3.15 is
out. Anyway, here's my suggestion.

8<-------------------

From: Davidlohr Bueso <davidlohr@hp.com>
Date: Wed, 9 Apr 2014 11:55:07 -0700
Subject: [PATCH] futex: update documentation for ordering guarantees

Commits 11d4616bd07f (futex: revert back to the explicit waiter counting code)
and 69cd9eba3886 (futex: avoid race between requeue and wake) changed some of
the finer details of how we think about futexes. One was a late fix and the
other a consequence of overlooking the whole requeuing logic. The first change
caused our documentation to be incorrect, and the second made us aware that
we need to explicitly add more details to it.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/futex.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6801b37..5f58927 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -70,7 +70,10 @@
 #include "locking/rtmutex_common.h"
 
 /*
- * Basic futex operation and ordering guarantees:
+ * READ this before attempting to hack on futexes!
+ *
+ * Basic futex operation and ordering guarantees
+ * =============================================
  *
  * The waiter reads the futex value in user space and calls
  * futex_wait(). This function computes the hash bucket and acquires
@@ -119,7 +122,7 @@
  * sys_futex(WAIT, futex, val);
  *   futex_wait(futex, val);
  *
- *   waiters++;
+ *   waiters++; (a)
  *   mb(); (A) <-- paired with -.
  *                              |
  *   lock(hash_bucket(futex));  |
@@ -135,14 +138,14 @@
  *     unlock(hash_bucket(futex));
  *     schedule();                         if (waiters)
  *                                           lock(hash_bucket(futex));
- *                                           wake_waiters(futex);
- *                                           unlock(hash_bucket(futex));
+ *   else                                    wake_waiters(futex);
+ *     waiters--; (b)                        unlock(hash_bucket(futex));
  *
- * Where (A) orders the waiters increment and the futex value read -- this
- * is guaranteed by the head counter in the hb spinlock; and where (B)
- * orders the write to futex and the waiters read -- this is done by the
- * barriers in get_futex_key_refs(), through either ihold or atomic_inc,
- * depending on the futex type.
+ * Where (A) orders the waiters increment and the futex value read through
+ * atomic operations (see hb_waiters_inc) and where (B) orders the write
+ * to futex and the waiters read -- this is done by the barriers in
+ * get_futex_key_refs(), through either ihold or atomic_inc, depending on the
+ * futex type.
  *
  * This yields the following case (where X:=waiters, Y:=futex):
  *
@@ -155,6 +158,17 @@
  * Which guarantees that x==0 && y==0 is impossible; which translates back into
  * the guarantee that we cannot both miss the futex variable change and the
  * enqueue.
+ *
+ * Note that a new waiter is accounted for in (a) even when it is possible that
+ * the wait call can return error, in which case we backtrack from it in (b).
+ * Refer to the comment in queue_lock().
+ *
+ * Similarly, in order to account for waiters being requeued on another
+ * address we always increment the waiters for the destination bucket before
+ * acquiring the lock. It then decrements them again  after releasing it -
+ * the code that actually moves the futex(es) between hash buckets (requeue_futex)
+ * will do the additional required waiter count housekeeping. This is done for
+ * double_lock_hb() and double_unlock_hb(), respectively.
  */
 
 #ifndef CONFIG_HAVE_FUTEX_CMPXCHG
-- 
1.8.1.4



