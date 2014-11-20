Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaKTP1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:27:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaKTP1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:27:08 -0500
Date: Thu, 20 Nov 2014 16:27:02 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz,
        Wu Fengguang <fengguang.wu@intel.com>, drbd-dev@lists.linbit.com,
        Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 01/10] writeback: move backing_dev_info->state into
 bdi_writeback
Message-ID: <20141120152702.GF2330@quack.suse.cz>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
 <1416299848-22112-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416299848-22112-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-11-14 03:37:19, Tejun Heo wrote:
> Currently, a bdi (backing_dev_info) embeds single wb (bdi_writeback)
> and the role of the separation is unclear.  For cgroup support for
> writeback IOs, a bdi will be updated to host multiple wb's where each
> wb serves writeback IOs of a different cgroup on the bdi.  To achieve
> that, a wb should carry all states necessary for servicing writeback
> IOs for a cgroup independently.
> 
> This patch moves bdi->state into wb.
> 
> * enum bdi_state is renamed to wb_state and the prefix of all enums is
>   changed from BDI_ to WB_.
> 
> * Explicit zeroing of bdi->state is removed without adding zeoring of
>   wb->state as the whole data structure is zeroed on init anyway.
> 
> * As there's still only one bdi_writeback per backing_dev_info, all
>   uses of bdi->state are mechanically replaced with bdi->wb.state
>   introducing no behavior changes.
  Hum, does it make sense to convert BDI_sync_congested and
BDI_async_congested? It contains information whether the *device* is
congested and cannot take more work. I understand that in a cgroup world
you want to throttle IO from a cgroup to a device so when you take
bdi_writeback to be a per-cgroup structure you want some indication there
that a particular cgroup cannot push more to the device. But is it that
e.g. mdraid cares about a cgroup and not about the device?

								Honza
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: drbd-dev@lists.linbit.com
> Cc: Neil Brown <neilb@suse.de>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-core.c               |  1 -
>  drivers/block/drbd/drbd_main.c | 10 +++++-----
>  drivers/md/dm.c                |  2 +-
>  drivers/md/raid1.c             |  4 ++--
>  drivers/md/raid10.c            |  2 +-
>  fs/fs-writeback.c              | 14 +++++++-------
>  include/linux/backing-dev.h    | 24 ++++++++++++------------
>  mm/backing-dev.c               | 21 ++++++++++-----------
>  8 files changed, 38 insertions(+), 40 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 0421b53..8801682 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -584,7 +584,6 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
>  
>  	q->backing_dev_info.ra_pages =
>  			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
> -	q->backing_dev_info.state = 0;
>  	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
>  	q->backing_dev_info.name = "block";
>  	q->node = node_id;
> diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
> index 1fc8342..61b00aa 100644
> --- a/drivers/block/drbd/drbd_main.c
> +++ b/drivers/block/drbd/drbd_main.c
> @@ -2360,7 +2360,7 @@ static void drbd_cleanup(void)
>   * @congested_data:	User data
>   * @bdi_bits:		Bits the BDI flusher thread is currently interested in
>   *
> - * Returns 1<<BDI_async_congested and/or 1<<BDI_sync_congested if we are congested.
> + * Returns 1<<WB_async_congested and/or 1<<WB_sync_congested if we are congested.
>   */
>  static int drbd_congested(void *congested_data, int bdi_bits)
>  {
> @@ -2377,14 +2377,14 @@ static int drbd_congested(void *congested_data, int bdi_bits)
>  	}
>  
>  	if (test_bit(CALLBACK_PENDING, &first_peer_device(device)->connection->flags)) {
> -		r |= (1 << BDI_async_congested);
> +		r |= (1 << WB_async_congested);
>  		/* Without good local data, we would need to read from remote,
>  		 * and that would need the worker thread as well, which is
>  		 * currently blocked waiting for that usermode helper to
>  		 * finish.
>  		 */
>  		if (!get_ldev_if_state(device, D_UP_TO_DATE))
> -			r |= (1 << BDI_sync_congested);
> +			r |= (1 << WB_sync_congested);
>  		else
>  			put_ldev(device);
>  		r &= bdi_bits;
> @@ -2400,9 +2400,9 @@ static int drbd_congested(void *congested_data, int bdi_bits)
>  			reason = 'b';
>  	}
>  
> -	if (bdi_bits & (1 << BDI_async_congested) &&
> +	if (bdi_bits & (1 << WB_async_congested) &&
>  	    test_bit(NET_CONGESTED, &first_peer_device(device)->connection->flags)) {
> -		r |= (1 << BDI_async_congested);
> +		r |= (1 << WB_async_congested);
>  		reason = reason == 'b' ? 'a' : 'n';
>  	}
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 58f3927..c4c53af 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1950,7 +1950,7 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
>  			 * the query about congestion status of request_queue
>  			 */
>  			if (dm_request_based(md))
> -				r = md->queue->backing_dev_info.state &
> +				r = md->queue->backing_dev_info.wb.state &
>  				    bdi_bits;
>  			else
>  				r = dm_table_any_congested(map, bdi_bits);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 40b35be..aad1482 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -739,7 +739,7 @@ int md_raid1_congested(struct mddev *mddev, int bits)
>  	struct r1conf *conf = mddev->private;
>  	int i, ret = 0;
>  
> -	if ((bits & (1 << BDI_async_congested)) &&
> +	if ((bits & (1 << WB_async_congested)) &&
>  	    conf->pending_count >= max_queued_requests)
>  		return 1;
>  
> @@ -754,7 +754,7 @@ int md_raid1_congested(struct mddev *mddev, int bits)
>  			/* Note the '|| 1' - when read_balance prefers
>  			 * non-congested targets, it can be removed
>  			 */
> -			if ((bits & (1<<BDI_async_congested)) || 1)
> +			if ((bits & (1<<WB_async_congested)) || 1)
>  				ret |= bdi_congested(&q->backing_dev_info, bits);
>  			else
>  				ret &= bdi_congested(&q->backing_dev_info, bits);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 32e282f..5180e75 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -915,7 +915,7 @@ int md_raid10_congested(struct mddev *mddev, int bits)
>  	struct r10conf *conf = mddev->private;
>  	int i, ret = 0;
>  
> -	if ((bits & (1 << BDI_async_congested)) &&
> +	if ((bits & (1 << WB_async_congested)) &&
>  	    conf->pending_count >= max_queued_requests)
>  		return 1;
>  
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2d609a5..a797bda 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -62,7 +62,7 @@ struct wb_writeback_work {
>   */
>  int writeback_in_progress(struct backing_dev_info *bdi)
>  {
> -	return test_bit(BDI_writeback_running, &bdi->state);
> +	return test_bit(WB_writeback_running, &bdi->wb.state);
>  }
>  EXPORT_SYMBOL(writeback_in_progress);
>  
> @@ -94,7 +94,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(wbc_writepage);
>  static void bdi_wakeup_thread(struct backing_dev_info *bdi)
>  {
>  	spin_lock_bh(&bdi->wb_lock);
> -	if (test_bit(BDI_registered, &bdi->state))
> +	if (test_bit(WB_registered, &bdi->wb.state))
>  		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
>  	spin_unlock_bh(&bdi->wb_lock);
>  }
> @@ -105,7 +105,7 @@ static void bdi_queue_work(struct backing_dev_info *bdi,
>  	trace_writeback_queue(bdi, work);
>  
>  	spin_lock_bh(&bdi->wb_lock);
> -	if (!test_bit(BDI_registered, &bdi->state)) {
> +	if (!test_bit(WB_registered, &bdi->wb.state)) {
>  		if (work->done)
>  			complete(work->done);
>  		goto out_unlock;
> @@ -1007,7 +1007,7 @@ static long wb_do_writeback(struct bdi_writeback *wb)
>  	struct wb_writeback_work *work;
>  	long wrote = 0;
>  
> -	set_bit(BDI_writeback_running, &wb->bdi->state);
> +	set_bit(WB_writeback_running, &wb->state);
>  	while ((work = get_next_work_item(bdi)) != NULL) {
>  
>  		trace_writeback_exec(bdi, work);
> @@ -1029,7 +1029,7 @@ static long wb_do_writeback(struct bdi_writeback *wb)
>  	 */
>  	wrote += wb_check_old_data_flush(wb);
>  	wrote += wb_check_background_flush(wb);
> -	clear_bit(BDI_writeback_running, &wb->bdi->state);
> +	clear_bit(WB_writeback_running, &wb->state);
>  
>  	return wrote;
>  }
> @@ -1049,7 +1049,7 @@ void bdi_writeback_workfn(struct work_struct *work)
>  	current->flags |= PF_SWAPWRITE;
>  
>  	if (likely(!current_is_workqueue_rescuer() ||
> -		   !test_bit(BDI_registered, &bdi->state))) {
> +		   !test_bit(WB_registered, &wb->state))) {
>  		/*
>  		 * The normal path.  Keep writing back @bdi until its
>  		 * work_list is empty.  Note that this path is also taken
> @@ -1211,7 +1211,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  			spin_unlock(&inode->i_lock);
>  			spin_lock(&bdi->wb.list_lock);
>  			if (bdi_cap_writeback_dirty(bdi)) {
> -				WARN(!test_bit(BDI_registered, &bdi->state),
> +				WARN(!test_bit(WB_registered, &bdi->wb.state),
>  				     "bdi-%s not registered\n", bdi->name);
>  
>  				/*
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 5da6012..a356ccd 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -25,13 +25,13 @@ struct device;
>  struct dentry;
>  
>  /*
> - * Bits in backing_dev_info.state
> + * Bits in bdi_writeback.state
>   */
> -enum bdi_state {
> -	BDI_async_congested,	/* The async (write) queue is getting full */
> -	BDI_sync_congested,	/* The sync queue is getting full */
> -	BDI_registered,		/* bdi_register() was done */
> -	BDI_writeback_running,	/* Writeback is in progress */
> +enum wb_state {
> +	WB_async_congested,	/* The async (write) queue is getting full */
> +	WB_sync_congested,	/* The sync queue is getting full */
> +	WB_registered,		/* bdi_register() was done */
> +	WB_writeback_running,	/* Writeback is in progress */
>  };
>  
>  typedef int (congested_fn)(void *, int);
> @@ -49,6 +49,7 @@ enum bdi_stat_item {
>  struct bdi_writeback {
>  	struct backing_dev_info *bdi;	/* our parent bdi */
>  
> +	unsigned long state;		/* Always use atomic bitops on this */
>  	unsigned long last_old_flush;	/* last old data flush */
>  
>  	struct delayed_work dwork;	/* work item used for writeback */
> @@ -61,7 +62,6 @@ struct bdi_writeback {
>  struct backing_dev_info {
>  	struct list_head bdi_list;
>  	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
> -	unsigned long state;	/* Always use atomic bitops on this */
>  	unsigned int capabilities; /* Device capabilities */
>  	congested_fn *congested_fn; /* Function pointer if device is md/dm */
>  	void *congested_data;	/* Pointer to aux data for congested func */
> @@ -276,23 +276,23 @@ static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
>  {
>  	if (bdi->congested_fn)
>  		return bdi->congested_fn(bdi->congested_data, bdi_bits);
> -	return (bdi->state & bdi_bits);
> +	return (bdi->wb.state & bdi_bits);
>  }
>  
>  static inline int bdi_read_congested(struct backing_dev_info *bdi)
>  {
> -	return bdi_congested(bdi, 1 << BDI_sync_congested);
> +	return bdi_congested(bdi, 1 << WB_sync_congested);
>  }
>  
>  static inline int bdi_write_congested(struct backing_dev_info *bdi)
>  {
> -	return bdi_congested(bdi, 1 << BDI_async_congested);
> +	return bdi_congested(bdi, 1 << WB_async_congested);
>  }
>  
>  static inline int bdi_rw_congested(struct backing_dev_info *bdi)
>  {
> -	return bdi_congested(bdi, (1 << BDI_sync_congested) |
> -				  (1 << BDI_async_congested));
> +	return bdi_congested(bdi, (1 << WB_sync_congested) |
> +				  (1 << WB_async_congested));
>  }
>  
>  enum {
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 0ae0df5..62f3b33 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -17,7 +17,6 @@ static atomic_long_t bdi_seq = ATOMIC_LONG_INIT(0);
>  struct backing_dev_info default_backing_dev_info = {
>  	.name		= "default",
>  	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
> -	.state		= 0,
>  	.capabilities	= BDI_CAP_MAP_COPY,
>  };
>  EXPORT_SYMBOL_GPL(default_backing_dev_info);
> @@ -111,7 +110,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
>  		   nr_dirty,
>  		   nr_io,
>  		   nr_more_io,
> -		   !list_empty(&bdi->bdi_list), bdi->state);
> +		   !list_empty(&bdi->bdi_list), bdi->wb.state);
>  #undef K
>  
>  	return 0;
> @@ -298,7 +297,7 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
>  
>  	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
>  	spin_lock_bh(&bdi->wb_lock);
> -	if (test_bit(BDI_registered, &bdi->state))
> +	if (test_bit(WB_registered, &bdi->wb.state))
>  		queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
>  	spin_unlock_bh(&bdi->wb_lock);
>  }
> @@ -333,7 +332,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
>  	bdi->dev = dev;
>  
>  	bdi_debug_register(bdi, dev_name(dev));
> -	set_bit(BDI_registered, &bdi->state);
> +	set_bit(WB_registered, &bdi->wb.state);
>  
>  	spin_lock_bh(&bdi_lock);
>  	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
> @@ -365,7 +364,7 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
>  
>  	/* Make sure nobody queues further work */
>  	spin_lock_bh(&bdi->wb_lock);
> -	clear_bit(BDI_registered, &bdi->state);
> +	clear_bit(WB_registered, &bdi->wb.state);
>  	spin_unlock_bh(&bdi->wb_lock);
>  
>  	/*
> @@ -543,11 +542,11 @@ static atomic_t nr_bdi_congested[2];
>  
>  void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
>  {
> -	enum bdi_state bit;
> +	enum wb_state bit;
>  	wait_queue_head_t *wqh = &congestion_wqh[sync];
>  
> -	bit = sync ? BDI_sync_congested : BDI_async_congested;
> -	if (test_and_clear_bit(bit, &bdi->state))
> +	bit = sync ? WB_sync_congested : WB_async_congested;
> +	if (test_and_clear_bit(bit, &bdi->wb.state))
>  		atomic_dec(&nr_bdi_congested[sync]);
>  	smp_mb__after_atomic();
>  	if (waitqueue_active(wqh))
> @@ -557,10 +556,10 @@ EXPORT_SYMBOL(clear_bdi_congested);
>  
>  void set_bdi_congested(struct backing_dev_info *bdi, int sync)
>  {
> -	enum bdi_state bit;
> +	enum wb_state bit;
>  
> -	bit = sync ? BDI_sync_congested : BDI_async_congested;
> -	if (!test_and_set_bit(bit, &bdi->state))
> +	bit = sync ? WB_sync_congested : WB_async_congested;
> +	if (!test_and_set_bit(bit, &bdi->wb.state))
>  		atomic_inc(&nr_bdi_congested[sync]);
>  }
>  EXPORT_SYMBOL(set_bdi_congested);
> -- 
> 1.9.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
