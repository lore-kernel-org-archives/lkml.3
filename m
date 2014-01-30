Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaA3WMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:12:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbaA3WMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:12:43 -0500
Date: Thu, 30 Jan 2014 23:12:41 +0100
From: Jan Kara <jack@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] block: Stop abusing rq->csd.list in blk-softirq
Message-ID: <20140130221241.GB31225@quack.suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
 <1387831171-5264-3-git-send-email-jack@suse.cz>
 <20140130123917.GA5339@localhost.localdomain>
 <20140130154523.GC12687@quack.suse.cz>
 <20140130170119.GB5339@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20140130170119.GB5339@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 30-01-14 18:01:20, Frederic Weisbecker wrote:
> On Thu, Jan 30, 2014 at 04:45:23PM +0100, Jan Kara wrote:
> >   Hi,
> > 
> > On Thu 30-01-14 13:39:18, Frederic Weisbecker wrote:
> > > I'm currently working on some cleanups on IPI code too and working on top
> > > of these patches, just have a few comments:
> >   Great, thanks!
> > 
> > > On Mon, Dec 23, 2013 at 09:39:23PM +0100, Jan Kara wrote:
> > > > Abusing rq->csd.list for a list of requests to complete is rather ugly.
> > > > Especially since using queuelist should be safe and much cleaner.
> > > 
> > > It would be nice to have a few more details that explain why doing so is safe
> > > wrt a block request lifecycle. At least something that tells why rq->queuelist
> > > can't be ever used concurrently by the time we send the IPI and we trigger/raise
> > > the softirq.
> >   Sure. Should I send the patch to you with an updated changelog and added
> > comment you requested?
> 
> Yeah that would be nice!
  OK, the updated patch is attached.

> For more precision, I would like to apply these:
> 
> 1) block: Stop abusing csd.list for fifo_time
> 2) block: Stop abusing rq->csd.list in blk-softirq
> 3) kernel: use lockless list for smp_call_function_single()
> 4) smp: Teach __smp_call_function_single() to check for offline cpus
> 
> This is because I need to tweak a bit the IPI code for some nohz
> functionnality. I'm not sure about the result but in any case these
> llist based cleanups look very nice, so lets try to push them. I'm also
> working on some consolidation between __smp_call_function_single()
> and smp_call_function_single() since they share almost the same code.
> 
> Also this shouldn't conflict with Andrew's tree if he applies these as well
> since -mm is based on -next. And the printk part should still go through his
> tree I think.
  Sure, that should be no problem. Jens might have the patch somewhere in
the linux-block.git but any conflict should be easy to resolve.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--NzB8fVQJ5HfG6fxh
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-block-Stop-abusing-rq-csd.list-in-blk-softirq.patch"

>From a7782fa4cee73a0581eded978eacf52cb0db1ec7 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 17 Dec 2013 23:47:41 +0100
Subject: [PATCH] block: Stop abusing rq->csd.list in blk-softirq

Abusing rq->csd.list for a list of requests to complete is rather ugly.
We use rq->queuelist instead which is much cleaner. It is safe because
queuelist is used by the block layer only for requests waiting to be
submitted to a device. Thus it is unused when irq reports the request IO
is finished.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/blk-softirq.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 57790c1a97eb..b5c37d96cf0e 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -30,8 +30,8 @@ static void blk_done_softirq(struct softirq_action *h)
 	while (!list_empty(&local_list)) {
 		struct request *rq;
 
-		rq = list_entry(local_list.next, struct request, csd.list);
-		list_del_init(&rq->csd.list);
+		rq = list_entry(local_list.next, struct request, queuelist);
+		list_del_init(&rq->queuelist);
 		rq->q->softirq_done_fn(rq);
 	}
 }
@@ -45,9 +45,14 @@ static void trigger_softirq(void *data)
 
 	local_irq_save(flags);
 	list = this_cpu_ptr(&blk_cpu_done);
-	list_add_tail(&rq->csd.list, list);
+	/*
+	 * We reuse queuelist for a list of requests to process. Since the
+	 * queuelist is used by the block layer only for requests waiting to be
+	 * submitted to the device it is unused now.
+	 */
+	list_add_tail(&rq->queuelist, list);
 
-	if (list->next == &rq->csd.list)
+	if (list->next == &rq->queuelist)
 		raise_softirq_irqoff(BLOCK_SOFTIRQ);
 
 	local_irq_restore(flags);
@@ -136,7 +141,7 @@ void __blk_complete_request(struct request *req)
 		struct list_head *list;
 do_local:
 		list = this_cpu_ptr(&blk_cpu_done);
-		list_add_tail(&req->csd.list, list);
+		list_add_tail(&req->queuelist, list);
 
 		/*
 		 * if the list only contains our just added request,
@@ -144,7 +149,7 @@ do_local:
 		 * entries there, someone already raised the irq but it
 		 * hasn't run yet.
 		 */
-		if (list->next == &req->csd.list)
+		if (list->next == &req->queuelist)
 			raise_softirq_irqoff(BLOCK_SOFTIRQ);
 	} else if (raise_blk_irq(ccpu, req))
 		goto do_local;
-- 
1.8.1.4


--NzB8fVQJ5HfG6fxh--
