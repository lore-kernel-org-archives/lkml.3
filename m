Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaGDBy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:54:58 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:36556 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaGDBy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:54:57 -0400
Message-ID: <1404438890.8764.125.camel@j-VirtualBox>
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
From: Jason Low <jason.low2@hp.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 03 Jul 2014 18:54:50 -0700
In-Reply-To: <1404438366.8764.121.camel@j-VirtualBox>
References: <1404413420.8764.42.camel@j-VirtualBox>
	 <20140704010147.GY4453@dastard> <1404438366.8764.121.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 18:46 -0700, Jason Low wrote:
> On Fri, 2014-07-04 at 11:01 +1000, Dave Chinner wrote:

> > FWIW, the rwsems in the struct xfs_inode are often heavily
> > read/write contended, so there are lots of IO related workloads that
> > are going to regress on XFS without this optimisation...
> > 
> > Anyway, consider the patch:
> > 
> > Tested-by: Dave Chinner <dchinner@redhat.com>
> 
> Hi Dave,
> 
> Thanks for testing. I'll update the patch with an actual changelog.

---
Subject: [PATCH] rwsem: In rwsem_can_spin_on_owner(), return false if no owner

It was found that the rwsem optimistic spinning feature can potentially degrade
performance when there are readers. Perf profiles indicate in some workloads
that significant time can be spent spinning on !owner. This is because we don't
set the lock owner when readers(s) obtain the rwsem.

In this patch, we'll modify rwsem_can_spin_on_owner() such that we'll return
false if there is no lock owner. The rationale is that if we just entered the
slowpath, yet there is no lock owner, then there is a possibility that a reader
has the lock. To be conservative, we'll avoid spinning in these situations.

Dave Chinner found performance benefits with this patch in the xfs_repair
workload, where the total run time went from approximately 4 minutes 24 seconds,
down to approximately 1 minute 26 seconds with the patch.

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



