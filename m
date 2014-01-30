Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaA3Pp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:45:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbaA3PpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:45:25 -0500
Date: Thu, 30 Jan 2014 16:45:23 +0100
From: Jan Kara <jack@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] block: Stop abusing rq->csd.list in blk-softirq
Message-ID: <20140130154523.GC12687@quack.suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
 <1387831171-5264-3-git-send-email-jack@suse.cz>
 <20140130123917.GA5339@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130123917.GA5339@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Thu 30-01-14 13:39:18, Frederic Weisbecker wrote:
> I'm currently working on some cleanups on IPI code too and working on top
> of these patches, just have a few comments:
  Great, thanks!

> On Mon, Dec 23, 2013 at 09:39:23PM +0100, Jan Kara wrote:
> > Abusing rq->csd.list for a list of requests to complete is rather ugly.
> > Especially since using queuelist should be safe and much cleaner.
> 
> It would be nice to have a few more details that explain why doing so is safe
> wrt a block request lifecycle. At least something that tells why rq->queuelist
> can't be ever used concurrently by the time we send the IPI and we trigger/raise
> the softirq.
  Sure. Should I send the patch to you with an updated changelog and added
comment you requested?

> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  block/blk-softirq.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/block/blk-softirq.c b/block/blk-softirq.c
> > index 57790c1a97eb..7ea5534096d5 100644
> > --- a/block/blk-softirq.c
> > +++ b/block/blk-softirq.c
> > @@ -30,8 +30,8 @@ static void blk_done_softirq(struct softirq_action *h)
> >  	while (!list_empty(&local_list)) {
> >  		struct request *rq;
> >  
> > -		rq = list_entry(local_list.next, struct request, csd.list);
> > -		list_del_init(&rq->csd.list);
> > +		rq = list_entry(local_list.next, struct request, queuelist);
> > +		list_del_init(&rq->queuelist);
> >  		rq->q->softirq_done_fn(rq);
> >  	}
> >  }
> > @@ -45,9 +45,9 @@ static void trigger_softirq(void *data)
> >  
> >  	local_irq_save(flags);
> >  	list = this_cpu_ptr(&blk_cpu_done);
> > -	list_add_tail(&rq->csd.list, list);
> > +	list_add_tail(&rq->queuelist, list);
> 
> And given that's an alternate use of rq->queuelist, perhaps add a comment
> to unconfuse people.
  Good idea, will do.

								Honza

> >  
> > -	if (list->next == &rq->csd.list)
> > +	if (list->next == &rq->queuelist)
> >  		raise_softirq_irqoff(BLOCK_SOFTIRQ);
> >  
> >  	local_irq_restore(flags);
> > @@ -136,7 +136,7 @@ void __blk_complete_request(struct request *req)
> >  		struct list_head *list;
> >  do_local:
> >  		list = this_cpu_ptr(&blk_cpu_done);
> > -		list_add_tail(&req->csd.list, list);
> > +		list_add_tail(&req->queuelist, list);
> >  
> >  		/*
> >  		 * if the list only contains our just added request,
> > @@ -144,7 +144,7 @@ do_local:
> >  		 * entries there, someone already raised the irq but it
> >  		 * hasn't run yet.
> >  		 */
> > -		if (list->next == &req->csd.list)
> > +		if (list->next == &req->queuelist)
> >  			raise_softirq_irqoff(BLOCK_SOFTIRQ);
> >  	} else if (raise_blk_irq(ccpu, req))
> >  		goto do_local;
> > -- 
> > 1.8.1.4
> > 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
