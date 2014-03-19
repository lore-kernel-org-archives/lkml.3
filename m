Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbaCSBqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:46:19 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34956 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbaCSBqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:46:18 -0400
Date: Wed, 19 Mar 2014 09:45:57 +0800
From: Shaohua Li <shli@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        agk@redhat.com
Subject: Re: [patch v3]DM: dm-insitu-comp: a compressed DM target for SSD
Message-ID: <20140319014557.GA1631@kernel.org>
References: <20140218101304.GA24889@kernel.org>
 <20140307075733.GB21790@kernel.org>
 <20140310135256.GA28665@redhat.com>
 <20140314094008.GA2386@kernel.org>
 <20140314224444.GA18027@redhat.com>
 <20140317095653.GA1014@kernel.org>
 <20140317200039.GC3269@redhat.com>
 <20140318074145.GA14397@kernel.org>
 <20140318212842.GA10850@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318212842.GA10850@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 05:28:43PM -0400, Mike Snitzer wrote:
> On Tue, Mar 18 2014 at  3:41am -0400,
> Shaohua Li <shli@kernel.org> wrote:
> 
> > On Mon, Mar 17, 2014 at 04:00:40PM -0400, Mike Snitzer wrote:
> > > 
> > > I folded your changes in, and then committed a patch ontop that cleans
> > > some code up.  But added 2 FIXMEs that still speak to pretty fundamental
> > > problems with the architecture of the dm-insitu-comp target, see:
> > > https://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=for-3.15-insitu-comp&id=8565ab6b04837591d03c94851c2f9f9162ce12f4
> > > 
> > > Unfortunately the single insitu_comp_wq workqueue that all insitu-comp
> > > targets are to share isn't a workable solution.  Each target needs to
> > > have resource isolation from other targets (imagine insitu-comp used for
> > > multiple SSDs).  This is important for suspend too because you'll need
> > > to flush/stop the workqueue.
> > 
> > Is this just because of suspend? I didn't see fundamental reason why the
> > workqueue can't be shared even for several targets.
> 
> I'm not seeing how you are guaranteeing that all queued work is
> completed during suspend.  insitu_comp_queue_req() just calls
> queue_work_on().
> 
> BTW, queue_work_on()'s comment above its implementation says:
> "We queue the work to a specific CPU, the caller must ensure it can't go
> away." -- you're not able to insure a cpu isn't hotplugged so... but I
> also see you've used it in your raid5 perf improvement changes so you
> obviously have experience with using this interface.

Good point, I did miss this. the raid5 case hold a lock, while this case
doesn't. A fix is attached below.

> > > You introduced a state machine for tracking suspending, suspended,
> > > resumed.  This really isn't necessary.  During suspend you need to
> > > flush_workqueue().  On resume you shouldn't need to do anything special.
> > > 
> > > As I noted in the commit, the thin and cache targets can serve as
> > > references for how you can manage the workqueue across suspend/resume
> > > and the lifetime of these workqueues relative to .ctr and .dtr.
> > 
> > As far as I checking the code, .postsuspend is called after all requests are
> > finished. This already guarantees no pending requests running in insitu-comp
> > workqueue.
> 
> I could easily be missing something obvious, but I don't see where that
> guarantee is implemented.

Alright, so this is the divergence. dm_suspend() calls dm_wait_for_completion()
and then dm_table_postsuspend_targets(). As far as I understand,
dm_wait_for_completion() will wait all pending requests to finish. The comments
declaim this too. Am I missing anything?

Basically the two kinds of IO. IO requests from upper layer, which
dm_wait_for_completion() will guarantee they are finished. Metadata IO
requests, which .postsuspend should make sure they are finished.
 
> > Doing a workqueue flush isn't required. The writeback thread is
> > running in background and waiting for requests completion can't guarantee the
> > thread isn't running, so we must make sure it is safely parked.
> 
> Sure, but you don't need a state machine to do that.  The DM core takes
> care of calling these hooks, so you just need to stop the writeback
> thread during suspend and (re)start/kick it on resume (preresume).

Yep, I need wait the writeback thread finish all pending metadata IO, the state
machine works well here.


---
 drivers/md/dm-insitu-comp.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/drivers/md/dm-insitu-comp.c
===================================================================
--- linux.orig/drivers/md/dm-insitu-comp.c	2014-03-17 17:40:01.106660303 +0800
+++ linux/drivers/md/dm-insitu-comp.c	2014-03-19 08:49:12.314627050 +0800
@@ -704,14 +704,19 @@ static void insitu_comp_queue_req(struct
 				  struct insitu_comp_req *req)
 {
 	unsigned long flags;
-	struct insitu_comp_io_worker *worker =
-		&insitu_comp_io_workers[req->cpu];
+	struct insitu_comp_io_worker *worker;
+
+	preempt_disable();
+	if (!cpu_online(req->cpu))
+		req->cpu = cpumask_any(cpu_online_mask);
+	worker = &insitu_comp_io_workers[req->cpu];
 
 	spin_lock_irqsave(&worker->lock, flags);
 	list_add_tail(&req->sibling, &worker->pending);
 	spin_unlock_irqrestore(&worker->lock, flags);
 
 	queue_work_on(req->cpu, insitu_comp_wq, &worker->work);
+	preempt_enable();
 }
 
 static void insitu_comp_queue_req_list(struct insitu_comp_info *info,
