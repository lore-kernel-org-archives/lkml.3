Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089Ab3ARI0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:26:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:30162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3ARI0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:26:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,490,1355126400"; 
   d="scan'208";a="248904737"
Date: Fri, 18 Jan 2013 16:27:20 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v7 3/4] block: implement runtime pm strategy
Message-ID: <20130118082720.GA12599@aaronlu.sh.intel.com>
References: <20130117051325.GA31469@aaronlu.sh.intel.com>
 <Pine.LNX.4.44L0.1301171005560.1339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301171005560.1339-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:11:31AM -0500, Alan Stern wrote:
> On Thu, 17 Jan 2013, Aaron Lu wrote:
> 
> > > > @@ -515,6 +516,27 @@ void elv_bio_merged(struct request_queue *q, struct request *rq,
> > > >  		e->type->ops.elevator_bio_merged_fn(q, rq, bio);
> > > >  }
> > > >  
> > > > +#ifdef CONFIG_PM_RUNTIME
> > > > +static void blk_pm_requeue_request(struct request *rq)
> > > > +{
> > > > +	if (!(rq->cmd_flags & REQ_PM))
> > > > +		rq->q->nr_pending--;
> > > > +}
> > > 
> > > You don't check q->dev here.  That's okay, but it means that
> > > q->nr_pending will be meaningless or wrong if any I/O takes place
> > > before blk_pm_runtime_init is called.
> > 
> > Right, so I had better check q->dev here too.
> > 
> > > 
> > > Therefore the kerneldoc for blk_pm_runtime_init should mention that it
> > > must not be called after any requests have been submitted.  Also
> > 
> > So with the q->dev check added above, I believe this is not needed.
> 
> No, it is still needed.  With the q->dev check added, q->nr_pending 
> will always be 0 before blk_pm_runtime_init is called.  But if I/O is 
> taking place then the number of pending requests really isn't 0.

Right, we can't allow I/O to happen when blk_pm_runtime_init is
executing, or we will have an incorrect nr_pending.

> 
> Either you have to make sure the q->nr_pending is always correct, even 
> when runtime PM isn't being used, or else the caller has to make sure 
> that no I/O takes place before blk_pm_runtime_init is called.

I think we can say:
blk_pm_runtime_init can't be called after any requests have been
submitted but not finished.
Sounds more accurate?

Thanks,
Aaron

> 
> > ------------
> > > mention that blk_pm_runtime_init enables runtime PM for q->dev, so the
> > > caller shouldn't do it.
> > 
> > I may misunderstandd this in last email.
> > 
> > We didn't enable runtime PM for the device in blk_pm_runtime_init, just
> > some auto suspend related settings.
> 
> Sorry, yes, you are right.  In fact, the caller has to make sure that 
> runtime PM is enabled before calling blk_pm_runtime_init; otherwise the 
> autosuspend timer might not work right.
> 
> Alan Stern
> 
