Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3IWLh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:37:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab3IWLh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:37:26 -0400
Date: Mon, 23 Sep 2013 13:37:23 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] blktrace: Send BLK_TN_PROCESS events to all running
 traces
Message-ID: <20130923113723.GA9623@quack.suse.cz>
References: <1379449831-6710-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379449831-6710-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 17-09-13 22:30:31, Jan Kara wrote:
> Currently each task sends BLK_TN_PROCESS event to the first traced
> device it interacts with after a new trace is started. When there are
> several traced devices and the task accesses more devices, this logic
> can result in BLK_TN_PROCESS being sent several times to some devices
> while it is never sent to other devices. Thus blkparse doesn't display
> command name when parsing some blktrace files.
> 
> Fix the problem by sending BLK_TN_PROCESS event to all traced devices
> when a task interacts with any of them.
  Jens, any opinion about this?

								Honza

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/blktrace_api.h |  2 ++
>  kernel/trace/blktrace.c      | 33 +++++++++++++++++++++++++++------
>  2 files changed, 29 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
> index 7c2e030..a12f6ed 100644
> --- a/include/linux/blktrace_api.h
> +++ b/include/linux/blktrace_api.h
> @@ -5,6 +5,7 @@
>  #include <linux/relay.h>
>  #include <linux/compat.h>
>  #include <uapi/linux/blktrace_api.h>
> +#include <linux/list.h>
>  
>  #if defined(CONFIG_BLK_DEV_IO_TRACE)
>  
> @@ -23,6 +24,7 @@ struct blk_trace {
>  	struct dentry *dir;
>  	struct dentry *dropped_file;
>  	struct dentry *msg_file;
> +	struct list_head running_list;
>  	atomic_t dropped;
>  };
>  
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index b8b8560..7f727b3 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -26,6 +26,7 @@
>  #include <linux/export.h>
>  #include <linux/time.h>
>  #include <linux/uaccess.h>
> +#include <linux/list.h>
>  
>  #include <trace/events/block.h>
>  
> @@ -38,6 +39,9 @@ static unsigned int blktrace_seq __read_mostly = 1;
>  static struct trace_array *blk_tr;
>  static bool blk_tracer_enabled __read_mostly;
>  
> +static LIST_HEAD(running_trace_list);
> +static __cacheline_aligned_in_smp DEFINE_SPINLOCK(running_trace_lock);
> +
>  /* Select an alternative, minimalistic output than the original one */
>  #define TRACE_BLK_OPT_CLASSIC	0x1
>  
> @@ -107,10 +111,18 @@ record_it:
>   * Send out a notify for this process, if we haven't done so since a trace
>   * started
>   */
> -static void trace_note_tsk(struct blk_trace *bt, struct task_struct *tsk)
> +static void trace_note_tsk(struct task_struct *tsk)
>  {
> +	unsigned long flags;
> +	struct blk_trace *bt;
> +
>  	tsk->btrace_seq = blktrace_seq;
> -	trace_note(bt, tsk->pid, BLK_TN_PROCESS, tsk->comm, sizeof(tsk->comm));
> +	spin_lock_irqsave(&running_trace_lock, flags);
> +	list_for_each_entry(bt, &running_trace_list, running_list) {
> +		trace_note(bt, tsk->pid, BLK_TN_PROCESS, tsk->comm,
> +			   sizeof(tsk->comm));
> +	}
> +	spin_unlock_irqrestore(&running_trace_lock, flags);
>  }
>  
>  static void trace_note_time(struct blk_trace *bt)
> @@ -229,16 +241,15 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  		goto record_it;
>  	}
>  
> +	if (unlikely(tsk->btrace_seq != blktrace_seq))
> +		trace_note_tsk(tsk);
> +
>  	/*
>  	 * A word about the locking here - we disable interrupts to reserve
>  	 * some space in the relay per-cpu buffer, to prevent an irq
>  	 * from coming in and stepping on our toes.
>  	 */
>  	local_irq_save(flags);
> -
> -	if (unlikely(tsk->btrace_seq != blktrace_seq))
> -		trace_note_tsk(bt, tsk);
> -
>  	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
>  	if (t) {
>  		sequence = per_cpu_ptr(bt->sequence, cpu);
> @@ -477,6 +488,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
>  	bt->dir = dir;
>  	bt->dev = dev;
>  	atomic_set(&bt->dropped, 0);
> +	INIT_LIST_HEAD(&bt->running_list);
>  
>  	ret = -EIO;
>  	bt->dropped_file = debugfs_create_file("dropped", 0444, dir, bt,
> @@ -601,6 +613,9 @@ int blk_trace_startstop(struct request_queue *q, int start)
>  			blktrace_seq++;
>  			smp_mb();
>  			bt->trace_state = Blktrace_running;
> +			spin_lock_irq(&running_trace_lock);
> +			list_add(&bt->running_list, &running_trace_list);
> +			spin_unlock_irq(&running_trace_lock);
>  
>  			trace_note_time(bt);
>  			ret = 0;
> @@ -608,6 +623,9 @@ int blk_trace_startstop(struct request_queue *q, int start)
>  	} else {
>  		if (bt->trace_state == Blktrace_running) {
>  			bt->trace_state = Blktrace_stopped;
> +			spin_lock_irq(&running_trace_lock);
> +			list_del_init(&bt->running_list);
> +			spin_unlock_irq(&running_trace_lock);
>  			relay_flush(bt->rchan);
>  			ret = 0;
>  		}
> @@ -1472,6 +1490,9 @@ static int blk_trace_remove_queue(struct request_queue *q)
>  	if (atomic_dec_and_test(&blk_probes_ref))
>  		blk_unregister_tracepoints();
>  
> +	spin_lock_irq(&running_trace_lock);
> +	list_del(&bt->running_list);
> +	spin_unlock_irq(&running_trace_lock);
>  	blk_trace_free(bt);
>  	return 0;
>  }
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
