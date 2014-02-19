Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaBSJ1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:27:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbaBSJ1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:27:34 -0500
Date: Wed, 19 Feb 2014 10:27:31 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Derek Basehore <dbasehore@chromium.org>,
        Alexander Viro <viro@zento.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, bleung@chromium.org,
        sonnyrao@chromium.org, semenzato@chromium.org
Subject: Re: [PATCH] backing_dev: Fix hung task on sync
Message-ID: <20140219092731.GA4849@quack.suse.cz>
References: <1392437537-27392-1-git-send-email-dbasehore@chromium.org>
 <20140218225548.GI31892@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218225548.GI31892@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-02-14 17:55:48, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 14, 2014 at 08:12:17PM -0800, Derek Basehore wrote:
> > bdi_wakeup_thread_delayed used the mod_delayed_work function to schedule work
> > to writeback dirty inodes. The problem with this is that it can delay work that
> > is scheduled for immediate execution, such as the work from sync_inodes_sb.
> > This can happen since mod_delayed_work can now steal work from a work_queue.
> > This fixes the problem by using queue_delayed_work instead. This is a
> > regression from the move to the bdi workqueue design.
> > 
> > The reason that this causes a problem is that laptop-mode will change the
> > delay, dirty_writeback_centisecs, to 60000 (10 minutes) by default. In the case
> > that bdi_wakeup_thread_delayed races with sync_inodes_sb, sync will be stopped
> > for 10 minutes and trigger a hung task. Even if dirty_writeback_centisecs is
> > not long enough to cause a hung task, we still don't want to delay sync for
> > that long.
> 
> Oops.
> 
> > For the same reason, this also changes bdi_writeback_workfn to immediately
> > queue the work again in the case that the work_list is not empty. The same
> > problem can happen if the sync work is run on the rescue worker.
> > 
> > Signed-off-by: Derek Basehore <dbasehore@chromium.org>
> > ---
> >  fs/fs-writeback.c | 5 +++--
> >  mm/backing-dev.c  | 2 +-
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index e0259a1..95b7b8c 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -1047,8 +1047,9 @@ void bdi_writeback_workfn(struct work_struct *work)
> >  		trace_writeback_pages_written(pages_written);
> >  	}
> >  
> > -	if (!list_empty(&bdi->work_list) ||
> > -	    (wb_has_dirty_io(wb) && dirty_writeback_interval))
> > +	if (!list_empty(&bdi->work_list))
> > +		mod_delayed_work(bdi_wq, &wb->dwork, 0);
> > +	else if (wb_has_dirty_io(wb) && dirty_writeback_interval)
> >  		queue_delayed_work(bdi_wq, &wb->dwork,
> >  			msecs_to_jiffies(dirty_writeback_interval * 10));
> 
> Can you please add some comments explaining why the specific variants
> are being used here?
> 
> > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > index ce682f7..3fde024 100644
> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -294,7 +294,7 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
> >  	unsigned long timeout;
> >  
> >  	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
> > -	mod_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
> > +	queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
> 
> and here?
> 
> Hmmm.... but doesn't this create an opposite problem?  Now a flush
> queued for an earlier time may be overridden by something scheduled
> later, no?
  You are the workqueue expert so you may know better ;) But the way I
understand it is that queue_delayed_work() does nothing if the timer is
already running. Since we queue flusher work to run either immediately or
after dirty_writeback_interval we are safe to run queue_delayed_work()
whenever we want it to run after dirty_writeback_interval and
mod_delayed_work() whenever we want to run it immediately.

But it's subtle and some interface where we could say queue delayed work
after no later than X would be easier to grasp.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
