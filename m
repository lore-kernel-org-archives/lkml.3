Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaA3RB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:01:27 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:39080 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaA3RB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:01:26 -0500
Date: Thu, 30 Jan 2014 18:01:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] block: Stop abusing rq->csd.list in blk-softirq
Message-ID: <20140130170119.GB5339@localhost.localdomain>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
 <1387831171-5264-3-git-send-email-jack@suse.cz>
 <20140130123917.GA5339@localhost.localdomain>
 <20140130154523.GC12687@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130154523.GC12687@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 04:45:23PM +0100, Jan Kara wrote:
>   Hi,
> 
> On Thu 30-01-14 13:39:18, Frederic Weisbecker wrote:
> > I'm currently working on some cleanups on IPI code too and working on top
> > of these patches, just have a few comments:
>   Great, thanks!
> 
> > On Mon, Dec 23, 2013 at 09:39:23PM +0100, Jan Kara wrote:
> > > Abusing rq->csd.list for a list of requests to complete is rather ugly.
> > > Especially since using queuelist should be safe and much cleaner.
> > 
> > It would be nice to have a few more details that explain why doing so is safe
> > wrt a block request lifecycle. At least something that tells why rq->queuelist
> > can't be ever used concurrently by the time we send the IPI and we trigger/raise
> > the softirq.
>   Sure. Should I send the patch to you with an updated changelog and added
> comment you requested?

Yeah that would be nice!

For more precision, I would like to apply these:

1) block: Stop abusing csd.list for fifo_time
2) block: Stop abusing rq->csd.list in blk-softirq
3) kernel: use lockless list for smp_call_function_single()
4) smp: Teach __smp_call_function_single() to check for offline cpus

This is because I need to tweak a bit the IPI code for some nohz
functionnality. I'm not sure about the result but in any case these
llist based cleanups look very nice, so lets try to push them. I'm also
working on some consolidation between __smp_call_function_single()
and smp_call_function_single() since they share almost the same code.

Also this shouldn't conflict with Andrew's tree if he applies these as well
since -mm is based on -next. And the printk part should still go through his
tree I think.

> 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > >  block/blk-softirq.c | 12 ++++++------
> > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/block/blk-softirq.c b/block/blk-softirq.c
> > > index 57790c1a97eb..7ea5534096d5 100644
> > > --- a/block/blk-softirq.c
> > > +++ b/block/blk-softirq.c
> > > @@ -30,8 +30,8 @@ static void blk_done_softirq(struct softirq_action *h)
> > >  	while (!list_empty(&local_list)) {
> > >  		struct request *rq;
> > >  
> > > -		rq = list_entry(local_list.next, struct request, csd.list);
> > > -		list_del_init(&rq->csd.list);
> > > +		rq = list_entry(local_list.next, struct request, queuelist);
> > > +		list_del_init(&rq->queuelist);
> > >  		rq->q->softirq_done_fn(rq);
> > >  	}
> > >  }
> > > @@ -45,9 +45,9 @@ static void trigger_softirq(void *data)
> > >  
> > >  	local_irq_save(flags);
> > >  	list = this_cpu_ptr(&blk_cpu_done);
> > > -	list_add_tail(&rq->csd.list, list);
> > > +	list_add_tail(&rq->queuelist, list);
> > 
> > And given that's an alternate use of rq->queuelist, perhaps add a comment
> > to unconfuse people.
>   Good idea, will do.

Thanks!
