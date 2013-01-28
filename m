Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3A1P65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:58:57 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:13148 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442Ab3A1P6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:58:54 -0500
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] cfq: fix lock imbalance with failed allocations
Date: Mon, 28 Jan 2013 19:58:47 +0400
Message-Id: <1359388727-28147-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>

While stress-running very-small container scenarios with the Kernel
Memory Controller, I've run into a lockdep-detected lock imbalance in
cfq-iosched.c.

I'll apologize beforehand for not posting a backlog: I didn't anticipate
it would be so hard to reproduce, so I didn't save my serial output and
went directly on debugging. Turns out that it did not happen again in
more than 20 runs, making it a quite rare pattern.

But here is my analysis:

When we are in very low-memory situations, we will arrive at
cfq_find_alloc_queue and may not find a queue, having to resort to the
oom queue, in an rcu-locked condition:

  if (!cfqq || cfqq == &cfqd->oom_cfqq)
      [ ... ]

Next, we will release the rcu lock, and try to allocate a queue,
retrying if we succeed:

  rcu_read_unlock();
  spin_unlock_irq(cfqd->queue->queue_lock);
  new_cfqq = kmem_cache_alloc_node(cfq_pool,
                  gfp_mask | __GFP_ZERO,
                  cfqd->queue->node);
   spin_lock_irq(cfqd->queue->queue_lock);
   if (new_cfqq)
       goto retry;

We are unlocked at this point, but it should be fine, since we will
reacquire the rcu_read_lock when we retry.

Except of course, that we may not retry: the allocation may very well
fail and we'll keep on going through the flow:

The next branch is:

    if (cfqq) {
	[ ... ]
    } else
        cfqq = &cfqd->oom_cfqq;

And right before exiting, we'll issue rcu_read_unlock().

Being already unlocked, this is the likely source of our imbalance.
Since cfqq is either already NULL or made NULL in the first statement of
the outter branch, the only viable alternative here seems to be to
return the oom queue right away in case of allocation failure.

Please review the following patch and apply if you agree with my
analysis.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fb52df9..d52437a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3205,6 +3205,8 @@ retry:
 			spin_lock_irq(cfqd->queue->queue_lock);
 			if (new_cfqq)
 				goto retry;
+			else
+				return &cfqd->oom_cfqq;
 		} else {
 			cfqq = kmem_cache_alloc_node(cfq_pool,
 					gfp_mask | __GFP_ZERO,
-- 
1.8.1

