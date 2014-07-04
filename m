Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaGDHGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:06:24 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:47483 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaGDHGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:06:22 -0400
Message-ID: <1404457579.8764.161.camel@j-VirtualBox>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
From: Jason Low <jason.low2@hp.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 04 Jul 2014 00:06:19 -0700
In-Reply-To: <20140704061306.GK9508@dastard>
References: <1404413420.8764.42.camel@j-VirtualBox>
	 <20140704010147.GY4453@dastard> <1404438366.8764.121.camel@j-VirtualBox>
	 <1404438890.8764.125.camel@j-VirtualBox> <20140704061306.GK9508@dastard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 16:13 +1000, Dave Chinner wrote:
> On Thu, Jul 03, 2014 at 06:54:50PM -0700, Jason Low wrote:
> > On Thu, 2014-07-03 at 18:46 -0700, Jason Low wrote:
> > > On Fri, 2014-07-04 at 11:01 +1000, Dave Chinner wrote:
> > 
> > > > FWIW, the rwsems in the struct xfs_inode are often heavily
> > > > read/write contended, so there are lots of IO related workloads that
> > > > are going to regress on XFS without this optimisation...
> > > > 
> > > > Anyway, consider the patch:
> > > > 
> > > > Tested-by: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Hi Dave,
> > > 
> > > Thanks for testing. I'll update the patch with an actual changelog.
> > 
> > ---
> > Subject: [PATCH] rwsem: In rwsem_can_spin_on_owner(), return false if no owner
> > 
> > It was found that the rwsem optimistic spinning feature can potentially degrade
> > performance when there are readers. Perf profiles indicate in some workloads
> > that significant time can be spent spinning on !owner. This is because we don't
> > set the lock owner when readers(s) obtain the rwsem.
> 
> I don't think you're being a little shifty with the truth here.
> There's no "potentially degrade performance" here - I reported a
> massive real world performance regression caused by optimistic
> spinning.

Sure, though I mainly used the word "potentially" since there can be
other workloads out there where spinning even when readers have the lock
is a positive thing.

And agreed that the changelog can be modified to try reflecting more on
it being a "regression fix" then a "new performance" addition.

So how about the following?

---
Subject: [PATCH] rwsem: In rwsem_can_spin_on_owner(), return false if no owner

Commit 4fc828e24cd9 ("locking/rwsem: Support optimistic spinning")
introduced a major performance regression for workloads such as
xfs_repair which mix read and write locking of the mmap_sem across
many threads. The result was xfs_repair ran 5x slower on 3.16-rc2
than on 3.15 and using 20x more system CPU time.

Perf profiles indicate in some workloads that significant time can
be spent spinning on !owner. This is because we don't set the lock
owner when readers(s) obtain the rwsem.

In this patch, we'll modify rwsem_can_spin_on_owner() such that we'll
return false if there is no lock owner. The rationale is that if we
just entered the slowpath, yet there is no lock owner, then there is
a possibility that a reader has the lock. To be conservative, we'll
avoid spinning in these situations.

This patch reduced the total run time of the xfs_repair workload from
about 4 minutes 24 seconds down to approximately 1 minute 26 seconds,
back to close to the same performance as on 3.15.

Tested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/rwsem-xadd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index dacc321..c40c7d2 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -285,10 +285,10 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
 static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 {
 	struct task_struct *owner;
-	bool on_cpu = true;
+	bool on_cpu = false;
 
 	if (need_resched())
-		return 0;
+		return false;
 
 	rcu_read_lock();
 	owner = ACCESS_ONCE(sem->owner);
@@ -297,9 +297,9 @@ static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 	rcu_read_unlock();
 
 	/*
-	 * If sem->owner is not set, the rwsem owner may have
-	 * just acquired it and not set the owner yet or the rwsem
-	 * has been released.
+	 * If sem->owner is not set, yet we have just recently entered the
+	 * slowpath, then there is a possibility reader(s) may have the lock.
+	 * To be safe, avoid spinning in these situations.
 	 */
 	return on_cpu;
 }
-- 
1.7.9.5



