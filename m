Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3LRPqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:46:36 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:29232 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3LRPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:46:34 -0500
Message-ID: <1387381587.2797.33.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] ipc: introduce ipc_valid_object() helper to sort out
 IPC_RMID races
From: Davidlohr Bueso <davidlohr@hp.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Greg Thelen <gthelen@google.com>
Date: Wed, 18 Dec 2013 07:46:27 -0800
In-Reply-To: <20131218125059.GF19025@localhost.localdomain>
References: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com>
	 <9710122c2aa978165609c0940e2087b074cd26ea.1387322182.git.aquini@redhat.com>
	 <52B190F1.9050505@colorfullife.com>
	 <20131218125059.GF19025@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 10:51 -0200, Rafael Aquini wrote:
> On Wed, Dec 18, 2013 at 01:11:29PM +0100, Manfred Spraul wrote:
> > On 12/18/2013 12:28 AM, Rafael Aquini wrote:
> > >After the locking semantics for the SysV IPC API got improved, a couple of
> > >IPC_RMID race windows were opened because we ended up dropping the
> > >'kern_ipc_perm.deleted' check performed way down in ipc_lock().
> > >The spotted races got sorted out by re-introducing the old test within
> > >the racy critical sections.
> > >
> > >This patch introduces ipc_valid_object() to consolidate the way we cope with
> > >IPC_RMID races by using the same abstraction across the API implementation.
> > >
> > >Signed-off-by: Rafael Aquini <aquini@redhat.com>
> > >Acked-by: Rik van Riel <riel@redhat.com>
> > >Acked-by: Greg Thelen <gthelen@google.com>
> > >---
> > >Changelog:
> > >* v2:
> > >  - drop assert_spin_locked() from ipc_valid_object() for less overhead
> > a) sysv ipc is lockless whereever possible, without writing to any
> > shared cachelines.
> > Therefore my first reaction was: No, please leave the assert in. It
> > will help us to catch bugs.
> > 
> > b) then I noticed: the assert would be a bug, the comment in front
> > of ipc_valid_object() that the caller must hold _perm.lock is wrong:
> > >@@ -1846,7 +1846,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
> > >  	error = -EIDRM;
> > >  	locknum = sem_lock(sma, sops, nsops);
> > >-	if (sma->sem_perm.deleted)
> > >+	if (!ipc_valid_object(&sma->sem_perm))
> > >  		goto out_unlock_free;
> > simple semtimedop() operation do not acquire sem_perm.lock, they
> > only acquire the per-semaphore lock and check that sem_perm.lock is
> > not held. This is sufficient to prevent races with RMID.
> > 
> > Could you update the comment?
> 
> The comment for ipc_valid_object() is not entirely wrong, as holding the spinlock 
> is clearly necessary for all cases except for this one you pointed above. 
> When I dropped the assert as Davilohr suggested, I then could have this one exception 
> case (where the check can, eventually, be done lockless) converted too, but I did not include 
> an exception comment at that particular checkpoint. Perhaps, that's what I should have done, or
> perhaps the best thing is to just let all that as is sits right now.

Yeah, Manfred is entirely correct - I didn't mention that sem_lock()
tries to be fine grained about its locking, so semaphores can in fact
not take the larger ipc lock (kern perm), but just the sem->lock
instead. This means that ipc_valid_object() must be called either way
with some lock held, but that assertion is indeed incorrect, not just
redundant like I suggested before. So, I think that if you update the
comment mentioning this corner case, then it should be ok.

Thanks,
Davidlohr

