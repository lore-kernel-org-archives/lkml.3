Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab3CLPFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:05:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab3CLPFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:05:14 -0400
Date: Tue, 12 Mar 2013 16:05:10 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com,
        linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH 3/4] writeback: replace custom worker pool
 implementation with unbound workqueue
Message-ID: <20130312150510.GF13152@quack.suse.cz>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
 <1362692649-25570-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362692649-25570-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-03-13 13:44:08, Tejun Heo wrote:
> Writeback implements its own worker pool - each bdi can be associated
> with a worker thread which is created and destroyed dynamically.  The
> worker thread for the default bdi is always present and serves as the
> "forker" thread which forks off worker threads for other bdis.
> 
> there's no reason for writeback to implement its own worker pool when
> using unbound workqueue instead is much simpler and more efficient.
> This patch replaces custom worker pool implementation in writeback
> with an unbound workqueue.
> 
> The conversion isn't too complicated but the followings are worth
> mentioning.
> 
> * bdi_writeback->last_active, task and wakeup_timer are removed.
>   delayed_work ->dwork is added instead.  Explicit timer handling is
>   no longer necessary.  Everything works by either queueing / modding
>   / flushing / canceling the delayed_work item.
> 
> * bdi_writeback_thread() becomes bdi_writeback_workfn() which runs off
>   bdi_writeback->dwork.  On each execution, it processes
>   bdi->work_list and reschedules itself if there are more things to
>   do.
> 
>   The function also handles low-mem condition, which used to be
>   handled by the forker thread.  If the function is running off a
>   rescuer thread, it only writes out limited number of pages so that
>   the rescuer can serve other bdis too.  This preserves the flusher
>   creation failure behavior of the forker thread.
> 
> * INIT_LIST_HEAD(&bdi->bdi_list) is used to tell
>   bdi_writeback_workfn() about on-going bdi unregistration so that it
>   always drains work_list even if it's running off the rescuer.  Note
>   that the original code was broken in this regard.  Under memory
>   pressure, a bdi could finish unregistration with non-empty
>   work_list.
> 
> * The default bdi is no longer special.  It now is treated the same as
>   any other bdi and bdi_cap_flush_forker() is removed.
> 
> * BDI_pending is no longer used.  Removed.
> 
> * Some tracepoints become non-applicable.  The following TPs are
>   removed - writeback_nothread, writeback_wake_thread,
>   writeback_wake_forker_thread, writeback_thread_start,
>   writeback_thread_stop.
> 
> Everything, including devices coming and going away and rescuer
> operation under simulated memory pressure, seems to work fine in my
> test setup.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
  The conversion looks OK. So you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c                | 102 +++++-----------
>  include/linux/backing-dev.h      |  15 +--
>  include/trace/events/writeback.h |   5 -
>  mm/backing-dev.c                 | 255 +++++----------------------------------
>  4 files changed, 65 insertions(+), 312 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 21f46fb..8067d37 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -22,7 +22,6 @@
>  #include <linux/mm.h>
>  #include <linux/pagemap.h>
>  #include <linux/kthread.h>
> -#include <linux/freezer.h>
>  #include <linux/writeback.h>
>  #include <linux/blkdev.h>
>  #include <linux/backing-dev.h>
> @@ -88,20 +87,6 @@ static inline struct inode *wb_inode(struct list_head *head)
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/writeback.h>
>  
> -/* Wakeup flusher thread or forker thread to fork it. Requires bdi->wb_lock. */
> -static void bdi_wakeup_flusher(struct backing_dev_info *bdi)
> -{
> -	if (bdi->wb.task) {
> -		wake_up_process(bdi->wb.task);
> -	} else {
> -		/*
> -		 * The bdi thread isn't there, wake up the forker thread which
> -		 * will create and run it.
> -		 */
> -		wake_up_process(default_backing_dev_info.wb.task);
> -	}
> -}
> -
>  static void bdi_queue_work(struct backing_dev_info *bdi,
>  			   struct wb_writeback_work *work)
>  {
> @@ -109,10 +94,9 @@ static void bdi_queue_work(struct backing_dev_info *bdi,
>  
>  	spin_lock_bh(&bdi->wb_lock);
>  	list_add_tail(&work->list, &bdi->work_list);
> -	if (!bdi->wb.task)
> -		trace_writeback_nothread(bdi, work);
> -	bdi_wakeup_flusher(bdi);
>  	spin_unlock_bh(&bdi->wb_lock);
> +
> +	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
>  }
>  
>  static void
> @@ -127,10 +111,8 @@ __bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
>  	 */
>  	work = kzalloc(sizeof(*work), GFP_ATOMIC);
>  	if (!work) {
> -		if (bdi->wb.task) {
> -			trace_writeback_nowork(bdi);
> -			wake_up_process(bdi->wb.task);
> -		}
> +		trace_writeback_nowork(bdi);
> +		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
>  		return;
>  	}
>  
> @@ -177,9 +159,7 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi)
>  	 * writeback as soon as there is no other work to do.
>  	 */
>  	trace_writeback_wake_background(bdi);
> -	spin_lock_bh(&bdi->wb_lock);
> -	bdi_wakeup_flusher(bdi);
> -	spin_unlock_bh(&bdi->wb_lock);
> +	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
>  }
>  
>  /*
> @@ -1020,66 +1000,48 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
>  
>  /*
>   * Handle writeback of dirty data for the device backed by this bdi. Also
> - * wakes up periodically and does kupdated style flushing.
> + * reschedules periodically and does kupdated style flushing.
>   */
> -int bdi_writeback_thread(void *data)
> +void bdi_writeback_workfn(struct work_struct *work)
>  {
> -	struct bdi_writeback *wb = data;
> +	struct bdi_writeback *wb = container_of(to_delayed_work(work),
> +						struct bdi_writeback, dwork);
>  	struct backing_dev_info *bdi = wb->bdi;
>  	long pages_written;
>  
>  	current->flags |= PF_SWAPWRITE;
> -	set_freezable();
> -	wb->last_active = jiffies;
> -
> -	/*
> -	 * Our parent may run at a different priority, just set us to normal
> -	 */
> -	set_user_nice(current, 0);
> -
> -	trace_writeback_thread_start(bdi);
>  
> -	while (!kthread_freezable_should_stop(NULL)) {
> +	if (likely(!current_is_workqueue_rescuer() ||
> +		   list_empty(&bdi->bdi_list))) {
>  		/*
> -		 * Remove own delayed wake-up timer, since we are already awake
> -		 * and we'll take care of the periodic write-back.
> +		 * The normal path.  Keep writing back @bdi until its
> +		 * work_list is empty.  Note that this path is also taken
> +		 * if @bdi is shutting down even when we're running off the
> +		 * rescuer as work_list needs to be drained.
>  		 */
> -		del_timer(&wb->wakeup_timer);
> -
> -		pages_written = wb_do_writeback(wb, 0);
> -
> +		do {
> +			pages_written = wb_do_writeback(wb, 0);
> +			trace_writeback_pages_written(pages_written);
> +		} while (!list_empty(&bdi->work_list));
> +	} else {
> +		/*
> +		 * bdi_wq can't get enough workers and we're running off
> +		 * the emergency worker.  Don't hog it.  Hopefully, 1024 is
> +		 * enough for efficient IO.
> +		 */
> +		pages_written = writeback_inodes_wb(&bdi->wb, 1024,
> +						    WB_REASON_FORKER_THREAD);
>  		trace_writeback_pages_written(pages_written);
> -
> -		if (pages_written)
> -			wb->last_active = jiffies;
> -
> -		set_current_state(TASK_INTERRUPTIBLE);
> -		if (!list_empty(&bdi->work_list) || kthread_should_stop()) {
> -			__set_current_state(TASK_RUNNING);
> -			continue;
> -		}
> -
> -		if (wb_has_dirty_io(wb) && dirty_writeback_interval)
> -			schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
> -		else {
> -			/*
> -			 * We have nothing to do, so can go sleep without any
> -			 * timeout and save power. When a work is queued or
> -			 * something is made dirty - we will be woken up.
> -			 */
> -			schedule();
> -		}
>  	}
>  
> -	/* Flush any work that raced with us exiting */
> -	if (!list_empty(&bdi->work_list))
> -		wb_do_writeback(wb, 1);
> +	if (!list_empty(&bdi->work_list) ||
> +	    (wb_has_dirty_io(wb) && dirty_writeback_interval))
> +		queue_delayed_work(bdi_wq, &wb->dwork,
> +			msecs_to_jiffies(dirty_writeback_interval * 10));
>  
> -	trace_writeback_thread_stop(bdi);
> -	return 0;
> +	current->flags &= ~PF_SWAPWRITE;
>  }
>  
> -
>  /*
>   * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
>   * the whole world.
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index a5ef27f..c388155 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -18,6 +18,7 @@
>  #include <linux/writeback.h>
>  #include <linux/atomic.h>
>  #include <linux/sysctl.h>
> +#include <linux/workqueue.h>
>  
>  struct page;
>  struct device;
> @@ -27,7 +28,6 @@ struct dentry;
>   * Bits in backing_dev_info.state
>   */
>  enum bdi_state {
> -	BDI_pending,		/* On its way to being activated */
>  	BDI_wb_alloc,		/* Default embedded wb allocated */
>  	BDI_async_congested,	/* The async (write) queue is getting full */
>  	BDI_sync_congested,	/* The sync queue is getting full */
> @@ -53,10 +53,8 @@ struct bdi_writeback {
>  	unsigned int nr;
>  
>  	unsigned long last_old_flush;	/* last old data flush */
> -	unsigned long last_active;	/* last time bdi thread was active */
>  
> -	struct task_struct *task;	/* writeback thread */
> -	struct timer_list wakeup_timer; /* used for delayed bdi thread wakeup */
> +	struct delayed_work dwork;	/* work item used for writeback */
>  	struct list_head b_dirty;	/* dirty inodes */
>  	struct list_head b_io;		/* parked for writeback */
>  	struct list_head b_more_io;	/* parked for more writeback */
> @@ -123,7 +121,7 @@ int bdi_setup_and_register(struct backing_dev_info *, char *, unsigned int);
>  void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
>  			enum wb_reason reason);
>  void bdi_start_background_writeback(struct backing_dev_info *bdi);
> -int bdi_writeback_thread(void *data);
> +void bdi_writeback_workfn(struct work_struct *work);
>  int bdi_has_dirty_io(struct backing_dev_info *bdi);
>  void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
>  void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2);
> @@ -131,6 +129,8 @@ void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2);
>  extern spinlock_t bdi_lock;
>  extern struct list_head bdi_list;
>  
> +extern struct workqueue_struct *bdi_wq;
> +
>  static inline int wb_has_dirty_io(struct bdi_writeback *wb)
>  {
>  	return !list_empty(&wb->b_dirty) ||
> @@ -335,11 +335,6 @@ static inline bool bdi_cap_swap_backed(struct backing_dev_info *bdi)
>  	return bdi->capabilities & BDI_CAP_SWAP_BACKED;
>  }
>  
> -static inline bool bdi_cap_flush_forker(struct backing_dev_info *bdi)
> -{
> -	return bdi == &default_backing_dev_info;
> -}
> -
>  static inline bool mapping_cap_writeback_dirty(struct address_space *mapping)
>  {
>  	return bdi_cap_writeback_dirty(mapping->backing_dev_info);
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index 6a16fd2..464ea82 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -183,7 +183,6 @@ DECLARE_EVENT_CLASS(writeback_work_class,
>  DEFINE_EVENT(writeback_work_class, name, \
>  	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_work *work), \
>  	TP_ARGS(bdi, work))
> -DEFINE_WRITEBACK_WORK_EVENT(writeback_nothread);
>  DEFINE_WRITEBACK_WORK_EVENT(writeback_queue);
>  DEFINE_WRITEBACK_WORK_EVENT(writeback_exec);
>  DEFINE_WRITEBACK_WORK_EVENT(writeback_start);
> @@ -222,12 +221,8 @@ DEFINE_EVENT(writeback_class, name, \
>  
>  DEFINE_WRITEBACK_EVENT(writeback_nowork);
>  DEFINE_WRITEBACK_EVENT(writeback_wake_background);
> -DEFINE_WRITEBACK_EVENT(writeback_wake_thread);
> -DEFINE_WRITEBACK_EVENT(writeback_wake_forker_thread);
>  DEFINE_WRITEBACK_EVENT(writeback_bdi_register);
>  DEFINE_WRITEBACK_EVENT(writeback_bdi_unregister);
> -DEFINE_WRITEBACK_EVENT(writeback_thread_start);
> -DEFINE_WRITEBACK_EVENT(writeback_thread_stop);
>  
>  DECLARE_EVENT_CLASS(wbc_class,
>  	TP_PROTO(struct writeback_control *wbc, struct backing_dev_info *bdi),
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 657569b..2857d4f 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -37,6 +37,9 @@ static struct class *bdi_class;
>  DEFINE_SPINLOCK(bdi_lock);
>  LIST_HEAD(bdi_list);
>  
> +/* bdi_wq serves all asynchronous writeback tasks */
> +struct workqueue_struct *bdi_wq;
> +
>  void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2)
>  {
>  	if (wb1 < wb2) {
> @@ -255,6 +258,11 @@ static int __init default_bdi_init(void)
>  {
>  	int err;
>  
> +	bdi_wq = alloc_workqueue("writeback", WQ_MEM_RECLAIM | WQ_FREEZABLE |
> +					      WQ_UNBOUND, 0);
> +	if (!bdi_wq)
> +		return -ENOMEM;
> +
>  	err = bdi_init(&default_backing_dev_info);
>  	if (!err)
>  		bdi_register(&default_backing_dev_info, NULL, "default");
> @@ -269,26 +277,6 @@ int bdi_has_dirty_io(struct backing_dev_info *bdi)
>  	return wb_has_dirty_io(&bdi->wb);
>  }
>  
> -static void wakeup_timer_fn(unsigned long data)
> -{
> -	struct backing_dev_info *bdi = (struct backing_dev_info *)data;
> -
> -	spin_lock_bh(&bdi->wb_lock);
> -	if (bdi->wb.task) {
> -		trace_writeback_wake_thread(bdi);
> -		wake_up_process(bdi->wb.task);
> -	} else if (bdi->dev) {
> -		/*
> -		 * When bdi tasks are inactive for long time, they are killed.
> -		 * In this case we have to wake-up the forker thread which
> -		 * should create and run the bdi thread.
> -		 */
> -		trace_writeback_wake_forker_thread(bdi);
> -		wake_up_process(default_backing_dev_info.wb.task);
> -	}
> -	spin_unlock_bh(&bdi->wb_lock);
> -}
> -
>  /*
>   * This function is used when the first inode for this bdi is marked dirty. It
>   * wakes-up the corresponding bdi thread which should then take care of the
> @@ -305,176 +293,7 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
>  	unsigned long timeout;
>  
>  	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
> -	mod_timer(&bdi->wb.wakeup_timer, jiffies + timeout);
> -}
> -
> -/*
> - * Calculate the longest interval (jiffies) bdi threads are allowed to be
> - * inactive.
> - */
> -static unsigned long bdi_longest_inactive(void)
> -{
> -	unsigned long interval;
> -
> -	interval = msecs_to_jiffies(dirty_writeback_interval * 10);
> -	return max(5UL * 60 * HZ, interval);
> -}
> -
> -/*
> - * Clear pending bit and wakeup anybody waiting for flusher thread creation or
> - * shutdown
> - */
> -static void bdi_clear_pending(struct backing_dev_info *bdi)
> -{
> -	clear_bit(BDI_pending, &bdi->state);
> -	smp_mb__after_clear_bit();
> -	wake_up_bit(&bdi->state, BDI_pending);
> -}
> -
> -static int bdi_forker_thread(void *ptr)
> -{
> -	struct bdi_writeback *me = ptr;
> -
> -	current->flags |= PF_SWAPWRITE;
> -	set_freezable();
> -
> -	/*
> -	 * Our parent may run at a different priority, just set us to normal
> -	 */
> -	set_user_nice(current, 0);
> -
> -	for (;;) {
> -		struct task_struct *task = NULL;
> -		struct backing_dev_info *bdi;
> -		enum {
> -			NO_ACTION,   /* Nothing to do */
> -			FORK_THREAD, /* Fork bdi thread */
> -			KILL_THREAD, /* Kill inactive bdi thread */
> -		} action = NO_ACTION;
> -
> -		/*
> -		 * Temporary measure, we want to make sure we don't see
> -		 * dirty data on the default backing_dev_info
> -		 */
> -		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list)) {
> -			del_timer(&me->wakeup_timer);
> -			wb_do_writeback(me, 0);
> -		}
> -
> -		spin_lock_bh(&bdi_lock);
> -		/*
> -		 * In the following loop we are going to check whether we have
> -		 * some work to do without any synchronization with tasks
> -		 * waking us up to do work for them. Set the task state here
> -		 * so that we don't miss wakeups after verifying conditions.
> -		 */
> -		set_current_state(TASK_INTERRUPTIBLE);
> -
> -		list_for_each_entry(bdi, &bdi_list, bdi_list) {
> -			bool have_dirty_io;
> -
> -			if (!bdi_cap_writeback_dirty(bdi) ||
> -			     bdi_cap_flush_forker(bdi))
> -				continue;
> -
> -			WARN(!test_bit(BDI_registered, &bdi->state),
> -			     "bdi %p/%s is not registered!\n", bdi, bdi->name);
> -
> -			have_dirty_io = !list_empty(&bdi->work_list) ||
> -					wb_has_dirty_io(&bdi->wb);
> -
> -			/*
> -			 * If the bdi has work to do, but the thread does not
> -			 * exist - create it.
> -			 */
> -			if (!bdi->wb.task && have_dirty_io) {
> -				/*
> -				 * Set the pending bit - if someone will try to
> -				 * unregister this bdi - it'll wait on this bit.
> -				 */
> -				set_bit(BDI_pending, &bdi->state);
> -				action = FORK_THREAD;
> -				break;
> -			}
> -
> -			spin_lock(&bdi->wb_lock);
> -
> -			/*
> -			 * If there is no work to do and the bdi thread was
> -			 * inactive long enough - kill it. The wb_lock is taken
> -			 * to make sure no-one adds more work to this bdi and
> -			 * wakes the bdi thread up.
> -			 */
> -			if (bdi->wb.task && !have_dirty_io &&
> -			    time_after(jiffies, bdi->wb.last_active +
> -						bdi_longest_inactive())) {
> -				task = bdi->wb.task;
> -				bdi->wb.task = NULL;
> -				spin_unlock(&bdi->wb_lock);
> -				set_bit(BDI_pending, &bdi->state);
> -				action = KILL_THREAD;
> -				break;
> -			}
> -			spin_unlock(&bdi->wb_lock);
> -		}
> -		spin_unlock_bh(&bdi_lock);
> -
> -		/* Keep working if default bdi still has things to do */
> -		if (!list_empty(&me->bdi->work_list))
> -			__set_current_state(TASK_RUNNING);
> -
> -		switch (action) {
> -		case FORK_THREAD:
> -			__set_current_state(TASK_RUNNING);
> -			task = kthread_create(bdi_writeback_thread, &bdi->wb,
> -					      "flush-%s", dev_name(bdi->dev));
> -			if (IS_ERR(task)) {
> -				/*
> -				 * If thread creation fails, force writeout of
> -				 * the bdi from the thread. Hopefully 1024 is
> -				 * large enough for efficient IO.
> -				 */
> -				writeback_inodes_wb(&bdi->wb, 1024,
> -						    WB_REASON_FORKER_THREAD);
> -			} else {
> -				/*
> -				 * The spinlock makes sure we do not lose
> -				 * wake-ups when racing with 'bdi_queue_work()'.
> -				 * And as soon as the bdi thread is visible, we
> -				 * can start it.
> -				 */
> -				spin_lock_bh(&bdi->wb_lock);
> -				bdi->wb.task = task;
> -				spin_unlock_bh(&bdi->wb_lock);
> -				wake_up_process(task);
> -			}
> -			bdi_clear_pending(bdi);
> -			break;
> -
> -		case KILL_THREAD:
> -			__set_current_state(TASK_RUNNING);
> -			kthread_stop(task);
> -			bdi_clear_pending(bdi);
> -			break;
> -
> -		case NO_ACTION:
> -			if (!wb_has_dirty_io(me) || !dirty_writeback_interval)
> -				/*
> -				 * There are no dirty data. The only thing we
> -				 * should now care about is checking for
> -				 * inactive bdi threads and killing them. Thus,
> -				 * let's sleep for longer time, save energy and
> -				 * be friendly for battery-driven devices.
> -				 */
> -				schedule_timeout(bdi_longest_inactive());
> -			else
> -				schedule_timeout(msecs_to_jiffies(dirty_writeback_interval * 10));
> -			try_to_freeze();
> -			break;
> -		}
> -	}
> -
> -	return 0;
> +	mod_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
>  }
>  
>  /*
> @@ -487,6 +306,9 @@ static void bdi_remove_from_list(struct backing_dev_info *bdi)
>  	spin_unlock_bh(&bdi_lock);
>  
>  	synchronize_rcu_expedited();
> +
> +	/* bdi_list is now unused, clear it to mark @bdi dying */
> +	INIT_LIST_HEAD(&bdi->bdi_list);
>  }
>  
>  int bdi_register(struct backing_dev_info *bdi, struct device *parent,
> @@ -506,20 +328,6 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
>  
>  	bdi->dev = dev;
>  
> -	/*
> -	 * Just start the forker thread for our default backing_dev_info,
> -	 * and add other bdi's to the list. They will get a thread created
> -	 * on-demand when they need it.
> -	 */
> -	if (bdi_cap_flush_forker(bdi)) {
> -		struct bdi_writeback *wb = &bdi->wb;
> -
> -		wb->task = kthread_run(bdi_forker_thread, wb, "bdi-%s",
> -						dev_name(dev));
> -		if (IS_ERR(wb->task))
> -			return PTR_ERR(wb->task);
> -	}
> -
>  	bdi_debug_register(bdi, dev_name(dev));
>  	set_bit(BDI_registered, &bdi->state);
>  
> @@ -543,8 +351,6 @@ EXPORT_SYMBOL(bdi_register_dev);
>   */
>  static void bdi_wb_shutdown(struct backing_dev_info *bdi)
>  {
> -	struct task_struct *task;
> -
>  	if (!bdi_cap_writeback_dirty(bdi))
>  		return;
>  
> @@ -554,22 +360,20 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
>  	bdi_remove_from_list(bdi);
>  
>  	/*
> -	 * If setup is pending, wait for that to complete first
> +	 * Drain work list and shutdown the delayed_work.  At this point,
> +	 * @bdi->bdi_list is empty telling bdi_Writeback_workfn() that @bdi
> +	 * is dying and its work_list needs to be drained no matter what.
>  	 */
> -	wait_on_bit(&bdi->state, BDI_pending, bdi_sched_wait,
> -			TASK_UNINTERRUPTIBLE);
> +	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
> +	flush_delayed_work(&bdi->wb.dwork);
> +	WARN_ON(!list_empty(&bdi->work_list));
>  
>  	/*
> -	 * Finally, kill the kernel thread. We don't need to be RCU
> -	 * safe anymore, since the bdi is gone from visibility.
> +	 * This shouldn't be necessary unless @bdi for some reason has
> +	 * unflushed dirty IO after work_list is drained.  Do it anyway
> +	 * just in case.
>  	 */
> -	spin_lock_bh(&bdi->wb_lock);
> -	task = bdi->wb.task;
> -	bdi->wb.task = NULL;
> -	spin_unlock_bh(&bdi->wb_lock);
> -
> -	if (task)
> -		kthread_stop(task);
> +	cancel_delayed_work_sync(&bdi->wb.dwork);
>  }
>  
>  /*
> @@ -595,10 +399,8 @@ void bdi_unregister(struct backing_dev_info *bdi)
>  		bdi_set_min_ratio(bdi, 0);
>  		trace_writeback_bdi_unregister(bdi);
>  		bdi_prune_sb(bdi);
> -		del_timer_sync(&bdi->wb.wakeup_timer);
>  
> -		if (!bdi_cap_flush_forker(bdi))
> -			bdi_wb_shutdown(bdi);
> +		bdi_wb_shutdown(bdi);
>  		bdi_debug_unregister(bdi);
>  
>  		spin_lock_bh(&bdi->wb_lock);
> @@ -620,7 +422,7 @@ static void bdi_wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
>  	INIT_LIST_HEAD(&wb->b_io);
>  	INIT_LIST_HEAD(&wb->b_more_io);
>  	spin_lock_init(&wb->list_lock);
> -	setup_timer(&wb->wakeup_timer, wakeup_timer_fn, (unsigned long)bdi);
> +	INIT_DELAYED_WORK(&wb->dwork, bdi_writeback_workfn);
>  }
>  
>  /*
> @@ -693,12 +495,11 @@ void bdi_destroy(struct backing_dev_info *bdi)
>  	bdi_unregister(bdi);
>  
>  	/*
> -	 * If bdi_unregister() had already been called earlier, the
> -	 * wakeup_timer could still be armed because bdi_prune_sb()
> -	 * can race with the bdi_wakeup_thread_delayed() calls from
> -	 * __mark_inode_dirty().
> +	 * If bdi_unregister() had already been called earlier, the dwork
> +	 * could still be pending because bdi_prune_sb() can race with the
> +	 * bdi_wakeup_thread_delayed() calls from __mark_inode_dirty().
>  	 */
> -	del_timer_sync(&bdi->wb.wakeup_timer);
> +	cancel_delayed_work_sync(&bdi->wb.dwork);
>  
>  	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
>  		percpu_counter_destroy(&bdi->bdi_stat[i]);
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
