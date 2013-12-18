Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab3LRUuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:50:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab3LRUuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:50:37 -0500
Date: Wed, 18 Dec 2013 21:50:34 +0100
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] block: Stop abusing csd.list for fifo_time
Message-ID: <20131218205034.GB13685@quack.suse.cz>
References: <1387387418-10005-1-git-send-email-jack@suse.cz>
 <1387387418-10005-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387387418-10005-2-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18-12-13 18:23:33, Jan Kara wrote:
> Block layer currently abuses rq->csd.list.next for storing fifo_time.
> That is a terrible hack and completely unnecessary as well. Union
> achieves the same space saving in a cleaner way.
  This is the correct patch 1/3.

								Honza
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  block/cfq-iosched.c      | 8 ++++----
>  block/deadline-iosched.c | 8 ++++----
>  include/linux/blkdev.h   | 1 +
>  include/linux/elevator.h | 6 ------
>  4 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 4d5cec1ad80d..37ea6045fdc6 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2382,10 +2382,10 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
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
> @@ -2829,7 +2829,7 @@ static struct request *cfq_check_fifo(struct cfq_queue *cfqq)
>  		return NULL;
>  
>  	rq = rq_entry_fifo(cfqq->fifo.next);
> -	if (time_before(jiffies, rq_fifo_time(rq)))
> +	if (time_before(jiffies, rq->fifo_time))
>  		rq = NULL;
>  
>  	cfq_log_cfqq(cfqq->cfqd, cfqq, "fifo=%p", rq);
> @@ -3942,7 +3942,7 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
>  	cfq_log_cfqq(cfqd, cfqq, "insert_request");
>  	cfq_init_prio_data(cfqq, RQ_CIC(rq));
>  
> -	rq_set_fifo_time(rq, jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)]);
> +	rq->fifo_time = jiffies + cfqd->cfq_fifo_expire[rq_is_sync(rq)];
>  	list_add_tail(&rq->queuelist, &cfqq->fifo);
>  	cfq_add_rq_rb(rq);
>  	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group,
> diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
> index 9ef66406c625..a753df2b3fc2 100644
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
> index 1b135d49b279..744b5fb13a9b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -102,6 +102,7 @@ struct request {
>  	union {
>  		struct call_single_data csd;
>  		struct work_struct mq_flush_data;
> +		unsigned long fifo_time;
>  	};
>  
>  	struct request_queue *q;
> diff --git a/include/linux/elevator.h b/include/linux/elevator.h
> index 306dd8cd0b6f..0bdfd46f4735 100644
> --- a/include/linux/elevator.h
> +++ b/include/linux/elevator.h
> @@ -202,12 +202,6 @@ enum {
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
>  #define rq_fifo_clear(rq)	do {		\
>  	list_del_init(&(rq)->queuelist);	\
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
