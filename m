Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab3LRRe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:34:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3LRRez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:34:55 -0500
Date: Wed, 18 Dec 2013 15:34:43 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v2] ipc: introduce ipc_valid_object() helper to sort out
 IPC_RMID races
Message-ID: <20131218173442.GA16621@localhost.localdomain>
References: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com>
 <9710122c2aa978165609c0940e2087b074cd26ea.1387322182.git.aquini@redhat.com>
 <52B190F1.9050505@colorfullife.com>
 <20131218125059.GF19025@localhost.localdomain>
 <1387381587.2797.33.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387381587.2797.33.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 07:46:27AM -0800, Davidlohr Bueso wrote:
> On Wed, 2013-12-18 at 10:51 -0200, Rafael Aquini wrote:
> > On Wed, Dec 18, 2013 at 01:11:29PM +0100, Manfred Spraul wrote:
> > > On 12/18/2013 12:28 AM, Rafael Aquini wrote:
> > > >After the locking semantics for the SysV IPC API got improved, a couple of
> > > >IPC_RMID race windows were opened because we ended up dropping the
> > > >'kern_ipc_perm.deleted' check performed way down in ipc_lock().
> > > >The spotted races got sorted out by re-introducing the old test within
> > > >the racy critical sections.
> > > >
> > > >This patch introduces ipc_valid_object() to consolidate the way we cope with
> > > >IPC_RMID races by using the same abstraction across the API implementation.
> > > >
> > > >Signed-off-by: Rafael Aquini <aquini@redhat.com>
> > > >Acked-by: Rik van Riel <riel@redhat.com>
> > > >Acked-by: Greg Thelen <gthelen@google.com>
> > > >---
> > > >Changelog:
> > > >* v2:
> > > >  - drop assert_spin_locked() from ipc_valid_object() for less overhead
> > > a) sysv ipc is lockless whereever possible, without writing to any
> > > shared cachelines.
> > > Therefore my first reaction was: No, please leave the assert in. It
> > > will help us to catch bugs.
> > > 
> > > b) then I noticed: the assert would be a bug, the comment in front
> > > of ipc_valid_object() that the caller must hold _perm.lock is wrong:
> > > >@@ -1846,7 +1846,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
> > > >  	error = -EIDRM;
> > > >  	locknum = sem_lock(sma, sops, nsops);
> > > >-	if (sma->sem_perm.deleted)
> > > >+	if (!ipc_valid_object(&sma->sem_perm))
> > > >  		goto out_unlock_free;
> > > simple semtimedop() operation do not acquire sem_perm.lock, they
> > > only acquire the per-semaphore lock and check that sem_perm.lock is
> > > not held. This is sufficient to prevent races with RMID.
> > > 
> > > Could you update the comment?
> > 
> > The comment for ipc_valid_object() is not entirely wrong, as holding the spinlock 
> > is clearly necessary for all cases except for this one you pointed above. 
> > When I dropped the assert as Davilohr suggested, I then could have this one exception 
> > case (where the check can, eventually, be done lockless) converted too, but I did not include 
> > an exception comment at that particular checkpoint. Perhaps, that's what I should have done, or
> > perhaps the best thing is to just let all that as is sits right now.
> 
> Yeah, Manfred is entirely correct - I didn't mention that sem_lock()
> tries to be fine grained about its locking, so semaphores can in fact
> not take the larger ipc lock (kern perm), but just the sem->lock
> instead. This means that ipc_valid_object() must be called either way
> with some lock held, but that assertion is indeed incorrect, not just
> redundant like I suggested before. So, I think that if you update the
> comment mentioning this corner case, then it should be ok.
>

Folks,

Before I re-submit the v3 with the commentary changes requested, I'm pasting
here what I'm planning to amend to v2 patch:
---
diff --git a/ipc/sem.c b/ipc/sem.c
index ed0057a..23379b6 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1846,6 +1846,14 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __u
 
        error = -EIDRM;
        locknum = sem_lock(sma, sops, nsops);
+       /*
+        * We eventually might perform the following check in a lockless
+        * fashion here, considering ipc_valid_object() locking constraints.
+        * If nsops == 1 and there's no contention for sem_perm.lock, then
+        * only a per-semaphore lock is held and it's OK to go on the check
+        * below. More details on the fine grained locking scheme entangled
+        * here, and why it's RMID race safe on comments at sem_lock()
+        */
        if (!ipc_valid_object(&sma->sem_perm))
                goto out_unlock_free;
        /*
diff --git a/ipc/util.h b/ipc/util.h
index 071ed58..d05b708 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -190,7 +190,8 @@ static inline void ipc_unlock(struct kern_ipc_perm *perm)
  * where the respective ipc_ids.rwsem is not being held down.
  * Checks whether the ipc object is still around or if it's gone already, as
  * ipc_rmid() may have already freed the ID while the ipc lock was spinning.
- * Needs to be called with kern_ipc_perm.lock held.
+ * Needs to be called with kern_ipc_perm.lock held -- exception made for one
+ * checkpoint case at sys_semtimedop() as noted in code commentary.
  */
 static inline bool ipc_valid_object(struct kern_ipc_perm *perm)
 {
---

Do we need to change somthing else?
Looking forward your thoughts!
-- Rafael

