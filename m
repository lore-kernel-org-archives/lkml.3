Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbaLDPM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:12:28 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:59341 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaLDPM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:12:26 -0500
Date: Thu, 4 Dec 2014 10:12:23 -0500
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH workqueue/for-3.18-fixes 2/2] workqueue: allow rescuer thread
 to do more work
Message-ID: <20141204151223.GE15219@htj.dyndns.org>
References: <545C368C.5040704@cn.fujitsu.com>
 <20141110162848.6f2246bb@notabene.brown>
 <20141110085250.GB15948@quack.suse.cz>
 <20141111090402.35fa0700@notabene.brown>
 <20141118152754.60b0c75e@notabene.brown>
 <20141202204304.GR10918@htj.dyndns.org>
 <20141203114011.5d02dc43@notabene.brown>
 <20141203172010.GC5013@htj.dyndns.org>
 <20141203180241.GD5013@htj.dyndns.org>
 <20141204151104.GD15219@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204151104.GD15219@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

When there is serious memory pressure, all workers in a pool could be
blocked, and a new thread cannot be created because it requires memory
allocation.

In this situation a WQ_MEM_RECLAIM workqueue will wake up the
rescuer thread to do some work.

The rescuer will only handle requests that are already on ->worklist.
If max_requests is 1, that means it will handle a single request.

The rescuer will be woken again in 100ms to handle another max_requests
requests.

I've seen a machine (running a 3.0 based "enterprise" kernel) with
thousands of requests queued for xfslogd, which has a max_requests of
1, and is needed for retiring all 'xfs' write requests.  When one of
the worker pools gets into this state, it progresses extremely slowly
and possibly never recovers (only waited an hour or two).

With this patch we leave a pool_workqueue on mayday list
until it is clearly no longer in need of assistance.  This allows
all requests to be handled in a timely fashion.

We keep each pool_workqueue on the mayday list until
need_to_create_worker() is false, and no work for this workqueue is
found in the pool.

I have tested this in combination with a (hackish) patch which forces
all work items to be handled by the rescuer thread.  In that context
it significantly improves performance.  A similar patch for a 3.0
kernel significantly improved performance on a heavy work load.

Thanks to Jan Kara for some design ideas, and to Dongsu Park for
some comments and testing.

tj: Inverted the lock order between wq_mayday_lock and pool->lock with
    a preceding patch and simplified this patch.  Added comment and
    updated changelog accordingly.  Dongsu spotted missing get_pwq()
    in the simplified code.

Cc: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello,

I'll apply these two patches to workqueue/for-3.18-fixes.  It'd be
great if other ppl can also confirm this actually works.

Thanks.

 kernel/workqueue.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2251,7 +2251,25 @@ repeat:
 			if (get_work_pwq(work) == pwq)
 				move_linked_works(work, scheduled, &n);
 
-		process_scheduled_works(rescuer);
+		if (!list_empty(scheduled)) {
+			process_scheduled_works(rescuer);
+
+			/*
+			 * The above execution of rescued work items could
+			 * have created more to rescue through
+			 * pwq_activate_first_delayed() or chained
+			 * queueing.  Let's put @pwq back on mayday list so
+			 * that such back-to-back work items, which may be
+			 * being used to relieve memory pressure, don't
+			 * incur MAYDAY_INTERVAL delay inbetween.
+			 */
+			if (need_to_create_worker(pool)) {
+				spin_lock(&wq_mayday_lock);
+				get_pwq(pwq);
+				list_move_tail(&pwq->mayday_node, &wq->maydays);
+				spin_unlock(&wq_mayday_lock);
+			}
+		}
 
 		/*
 		 * Put the reference grabbed by send_mayday().  @pool won't
