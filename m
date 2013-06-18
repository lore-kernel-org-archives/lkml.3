Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3FRGsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:48:53 -0400
Received: from mout.gmx.net ([212.227.15.18]:57054 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab3FRGsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:48:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19mucNH7+Rm1f1ATZwf3ihYoGPiDN5eCN87sZZIkf
	ITMnXAwB6LS3yP
Message-ID: <1371538123.6091.87.camel@marge.simpson.net>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Jun 2013 08:48:43 +0200
In-Reply-To: <51BC4B99.4050506@colorfullife.com>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
	 <51BB38FA.6080607@colorfullife.com>
	 <1371236750.5796.54.camel@marge.simpson.net>
	 <51BC4B99.4050506@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-15 at 13:10 +0200, Manfred Spraul wrote: 
> On 06/14/2013 09:05 PM, Mike Galbraith wrote:
> > # Events: 802K cycles
> > #
> > # Overhead                                      Symbol
> > # ........  ..........................................
> > #
> >      18.42%  [k] SYSC_semtimedop
> >      15.39%  [k] sem_lock
> >      10.26%  [k] _raw_spin_lock
> >       9.00%  [k] perform_atomic_semop
> >       7.89%  [k] system_call
> >       7.70%  [k] ipc_obtain_object_check
> >       6.95%  [k] ipcperms
> >       6.62%  [k] copy_user_generic_string
> >       4.16%  [.] __semop
> >       2.57%  [.] worker_thread(void*)
> >       2.30%  [k] copy_from_user
> >       1.75%  [k] sem_unlock
> >       1.25%  [k] ipc_obtain_object
> ~ 280 mio ops.
> 2.3% copy_from_user,
> 9% perform_atomic_semop.
> 
> > # Events: 802K cycles
> > #
> > # Overhead                           Symbol
> > # ........  ...............................
> > #
> >      17.38%  [k] SYSC_semtimedop
> >      13.26%  [k] system_call
> >      11.31%  [k] copy_user_generic_string
> >       7.62%  [.] __semop
> >       7.18%  [k] _raw_spin_lock
> >       5.66%  [k] ipcperms
> >       5.40%  [k] sem_lock
> >       4.65%  [k] perform_atomic_semop
> >       4.22%  [k] ipc_obtain_object_check
> >       4.08%  [.] worker_thread(void*)
> >       4.06%  [k] copy_from_user
> >       2.40%  [k] ipc_obtain_object
> >       1.98%  [k] pid_vnr
> >       1.45%  [k] wake_up_sem_queue_do
> >       1.39%  [k] sys_semop
> >       1.35%  [k] sys_semtimedop
> >       1.30%  [k] sem_unlock
> >       1.14%  [k] security_ipc_permission
> ~ 700 mio ops.
> 4% copy_from_user -> as expected a bit more
> 4.6% perform_atomic_semop --> less.
> 
> Thus: Could you send the oprofile output from perform_atomic_semop()?
> 
> Perhaps that gives us a hint.
> 
> My current guess:
> sem_lock() somehow ends up in lock_array.
> Lock_array scans all struct sem -> transfer of that cacheline from all 
> cpus to the cpu that does the lock_array..
> Then the next write by the "correct" cpu causes a transfer back when 
> setting sem->pid.

Profiling sem_lock(), observe sma->complex_count.

         :       again:
         :              if (nsops == 1 && !sma->complex_count) {
    0.00 :      ffffffff81258a64:       75 5a                   jne    ffffffff81258ac0 <sem_lock+0x80>
    0.50 :      ffffffff81258a66:       41 8b 44 24 7c          mov    0x7c(%r12),%eax
   23.04 :      ffffffff81258a6b:       85 c0                   test   %eax,%eax
    0.00 :      ffffffff81258a6d:       75 51                   jne    ffffffff81258ac0 <sem_lock+0x80>
         :                      struct sem *sem = sma->sem_base + sops->sem_num;
    0.01 :      ffffffff81258a6f:       41 0f b7 1e             movzwl (%r14),%ebx
    0.48 :      ffffffff81258a73:       48 c1 e3 06             shl    $0x6,%rbx
    0.52 :      ffffffff81258a77:       49 03 5c 24 40          add    0x40(%r12),%rbx
         :              raw_spin_lock_init(&(_lock)->rlock);            \
         :      } while (0)
         :
         :      static inline void spin_lock(spinlock_t *lock)
         :      {
         :              raw_spin_lock(&lock->rlock);
    1.45 :      ffffffff81258a7c:       4c 8d 6b 08             lea    0x8(%rbx),%r13
    0.47 :      ffffffff81258a80:       4c 89 ef                mov    %r13,%rdi
    0.50 :      ffffffff81258a83:       e8 08 4f 35 00          callq  ffffffff815ad990 <_raw_spin_lock>
         :
         :                      /*
         :                       * If sma->complex_count was set while we were spinning,
         :                       * we may need to look at things we did not lock here.
         :                       */
         :                      if (unlikely(sma->complex_count)) {
    0.53 :      ffffffff81258a88:       41 8b 44 24 7c          mov    0x7c(%r12),%eax
   34.33 :      ffffffff81258a8d:       85 c0                   test   %eax,%eax
    0.02 :      ffffffff81258a8f:       75 29                   jne    ffffffff81258aba <sem_lock+0x7a>
         :              __add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
         :      }
         :

We're taking cache misses for _both_ reads, so I speculated that
somebody somewhere has to be banging on that structure, so I tried
putting complex_count on a different cache line, and indeed, the
overhead disappeared, and box started scaling linearly and reliably so
to 32 cores.  64 is still unstable, but 32 became rock solid.

Moving ____cacheline_aligned_in_smp upward one at a time to try to find
out which field was causing trouble, I ended up at sem_base.. a pointer
that's not modified.  That makes zero sense to me, does anybody have an
idea why having sem_base and complex_count in the same cache line would
cause this?

---
 include/linux/sem.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/sem.h
===================================================================
--- linux-2.6.orig/include/linux/sem.h
+++ linux-2.6/include/linux/sem.h
@@ -10,10 +10,10 @@ struct task_struct;

 /* One sem_array data structure for each set of semaphores in the system. */
 struct sem_array {
-       struct kern_ipc_perm    ____cacheline_aligned_in_smp
-                               sem_perm;       /* permissions .. see ipc.h */
+       struct kern_ipc_perm    sem_perm;       /* permissions .. see ipc.h */
        time_t                  sem_ctime;      /* last change time */
-       struct sem              *sem_base;      /* ptr to first semaphore in array */
+       struct sem              ____cacheline_aligned_in_smp
+                               *sem_base;      /* ptr to first semaphore in array */
        struct list_head        pending_alter;  /* pending operations */
                                                /* that alter the array */
        struct list_head        pending_const;  /* pending complex operations */
@@ -21,7 +21,7 @@ struct sem_array {
        struct list_head        list_id;        /* undo requests on this array */
        int                     sem_nsems;      /* no. of semaphores in array */
        int                     complex_count;  /* pending complex operations */
-};
+} ____cacheline_aligned_in_smp;

 #ifdef CONFIG_SYSVIPC

If I put the ____cacheline_aligned_in_smp any place below sem_base, the
overhead goes *poof* gone.  For a 64 core run, massive overhead
reappears, but at spin_is_locked(), and we thrash badly again, with the
characteristic wildly uneven distribution.. but we still perform much
better than without the move in total throughput.

In -rt, even without moving complex_count, only using my livelock free
version of sem_lock(), we magically scale to 64 cores with your patches,
returning a 650 fold throughput improvement for sem-waitzero.  I say
"magically" because that patch should not have the effect it does, but
it has that same effect on mainline up to 32 cores.   Changing memory
access patterns around a little has a wild and fully repeatable impact
on throughput.

Something is rotten in Denmark, any ideas out there as to what that
something might be?  HTH can moving that pointer have the effect it
does?  How can my livelock fix for -rt have the same effect on mainline
as moving complex_count, and much more effect for -rt, to the point that
we start scaling perfectly to 64 cores?  AFAIKT, it should be noop or
maybe cost a bit, but it's confused, insists that it's a performance
patch, when it's really only a remove the darn livelockable loop patch.

-Mike

