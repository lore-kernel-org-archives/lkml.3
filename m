Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaBCOse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:48:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaBCOsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:48:33 -0500
Date: Mon, 3 Feb 2014 15:48:29 +0100
From: Jan Kara <jack@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] block: Stop abusing csd.list for fifo_time
Message-ID: <20140203144829.GA2542@quack.suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
 <1387831171-5264-2-git-send-email-jack@suse.cz>
 <20140201164824.GA669@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140201164824.GA669@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 01-02-14 17:48:27, Frederic Weisbecker wrote:
> On Mon, Dec 23, 2013 at 09:39:22PM +0100, Jan Kara wrote:
> > Block layer currently abuses rq->csd.list.next for storing fifo_time.
> > That is a terrible hack and completely unnecessary as well. Union
> > achieves the same space saving in a cleaner way.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Hi Jan,
> 
> Taken as is, the patch is fine and it builds.
> But later when I finally get rid of csd->list in a subsequent patch,
> rq_fifo_clear() callers break the build.
> 
> This is because rq_fifo_clear() initialize the csd->list and I'm not
> sure how to fix that leftover because I am not clear about the purpose
> of that INIT_LIST_HEAD(): is it to reset fifo time or to prepare for
> an IPI to be queued?
  I'm convinced it is there to prepare IPI to be queued. So just removing
the initialization as you did should be the right thing to do. You can
easily verify that it is correct - you boot the kernel, switch to 'deadline'
IO scheduler by doing
  echo 'deadline' >/sys/block/sda/queue/scheduler
and then do some IO. If it doesn't blow up, it is correct.

> All in one it looks buggy because if this is to prepare for the IPI,
> it's useless as csd.list is not a list head but just a node. Otherwise if it
> is to reset fifo_time it's wrong because INIT_LIST_HEAD doesn't initialize
> to 0.
  Yup, I think it is useless.

									Honza

> Anyway so I did a braindead fix by removing the whole INIT_LIST_HEAD()
> from rq_fifo_clear(), see the patch below. Now to be honest I have no idea
> what I'm doing.
> 
> ---
> From 112bcbb73076dd1374541eec9b554410dd0e73e0 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Mon, 23 Dec 2013 21:39:22 +0100
> Subject: [PATCH] block: Stop abusing csd.list for fifo_time
> 
> Block layer currently abuses rq->csd.list.next for storing fifo_time.
> That is a terrible hack and completely unnecessary as well. Union
> achieves the same space saving in a cleaner way.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  block/cfq-iosched.c      |  8 ++++----
>  block/deadline-iosched.c |  8 ++++----
>  include/linux/blkdev.h   |  1 +
>  include/linux/elevator.h | 12 ++----------
>  4 files changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 744833b..5873e4a 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2367,10 +2367,10 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
>  	 * reposition in fifo if next is older than rq
>  	 */
>  	if (!list_empty(&rq->queuelist) && !list_empty(&next->queuelist) &&
> -	    time_before(rq_fifo_time(next), rq_fifo_time(rq)) &&
> +	    time_before(next->fifo_time, rq->fifo_time) &&
>  	    cfqq == RQ_CFQQ(next)) {
>  		list_move(&rq->queuelist, &next->queuelist);
> -		rq_set_fifo_time(rq, rq_fifo_time(next));
> +		rq->fifo_time = next->fifo_time;
>  	}
>  
>  	if (cfqq->next_rq == next)
> @@ -2814,7 +2814,7 @@ static struct request *cfq_check_fifo(struct cfq_queue *cfqq)
>  		return NULL;
>  
>  	rq = rq_entry_fifo(cfqq->fifo.next);
> -	if (time_before(jiffies, rq_fifo_time(rq)))
> +	if (time_before(jiffies, rq->fifo_time))
>  		rq = NULL;
>  
>  	cfq_log_cfqq(cfqq->cfqd, cfqq, "fifo=%p", rq);
> @@ -3927,7 +3927,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
>  	cfq_log_cfqq(cfqd, cfqq, "insert_request");
>  	cfq_init_prio_data(cfqq, RQ_CIC(rq));
>  
> -	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
> +	rq->fifo_time = jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)];
>  	list_add_tail(&rq->queuelist, &cfqq->fifo);
>  	cfq_add_rq_rb(rq);
>  	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group,
> diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
> index 9ef6640..a753df2 100644
> --- a/block/deadline-iosched.c
> +++ b/block/deadline-iosched.c
> @@ -106,7 +106,7 @@ deadline_add_request(struct request_queue *q, struct request *rq)
>  	/*
>  	 * set expire time and add to fifo list
>  	 */
> -	rq_set_fifo_time(rq, jiffies + dd->fifo_expire[data_dir]);
> +	rq->fifo_time = jiffies + dd->fifo_expire[data_dir];
>  	list_add_tail(&rq->queuelist, &dd->fifo_list[data_dir]);
>  }
>  
> @@ -174,9 +174,9 @@ deadline_merged_requests(struct request_queue *q, struct request *req,
>  	 * and move into next position (next will be deleted) in fifo
>  	 */
>  	if (!list_empty(&req->queuelist) && !list_empty(&next->queuelist)) {
> -		if (time_before(rq_fifo_time(next), rq_fifo_time(req))) {
> +		if (time_before(next->fifo_time, req->fifo_time)) {
>  			list_move(&req->queuelist, &next->queuelist);
> -			rq_set_fifo_time(req, rq_fifo_time(next));
> +			req->fifo_time = next->fifo_time;
>  		}
>  	}
>  
> @@ -230,7 +230,7 @@ static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
>  	/*
>  	 * rq is expired!
>  	 */
> -	if (time_after_eq(jiffies, rq_fifo_time(rq)))
> +	if (time_after_eq(jiffies, rq->fifo_time))
>  		return 1;
>  
>  	return 0;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 8678c43..dda98e3 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -99,6 +99,7 @@ struct request {
>  	union {
>  		struct call_single_data csd;
>  		struct work_struct mq_flush_data;
> +		unsigned long fifo_time;
>  	};
>  
>  	struct request_queue *q;
> diff --git a/include/linux/elevator.h b/include/linux/elevator.h
> index 306dd8c..0b87f4e 100644
> --- a/include/linux/elevator.h
> +++ b/include/linux/elevator.h
> @@ -202,17 +202,9 @@ enum {
>  #define rq_end_sector(rq)	(blk_rq_pos(rq) + blk_rq_sectors(rq))
>  #define rb_entry_rq(node)	rb_entry((node), struct request, rb_node)
>  
> -/*
> - * Hack to reuse the csd.list list_head as the fifo time holder while
> - * the request is in the io scheduler. Saves an unsigned long in rq.
> - */
> -#define rq_fifo_time(rq)	((unsigned long) (rq)->csd.list.next)
> -#define rq_set_fifo_time(rq,exp)	((rq)->csd.list.next = (void *) (exp))
>  #define rq_entry_fifo(ptr)	list_entry((ptr), struct request, queuelist)
> -#define rq_fifo_clear(rq)	do {		\
> -	list_del_init(&(rq)->queuelist);	\
> -	INIT_LIST_HEAD(&(rq)->csd.list);	\
> -	} while (0)
> +//CHECKME twice
> +#define rq_fifo_clear(rq)	list_del_init(&(rq)->queuelist);
>  
>  #else /* CONFIG_BLOCK */
>  
> -- 
> 1.8.3.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
