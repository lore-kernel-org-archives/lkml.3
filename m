Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab3JOOSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:18:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758902Ab3JOOSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:18:15 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: Send BLK_TN_PROCESS events to all running traces
References: <1379449831-6710-1-git-send-email-jack@suse.cz>
	<20130923113723.GA9623@quack.suse.cz>
	<20131015094035.GA12416@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 15 Oct 2013 10:18:11 -0400
In-Reply-To: <20131015094035.GA12416@quack.suse.cz> (Jan Kara's message of
	"Tue, 15 Oct 2013 11:40:35 +0200")
Message-ID: <x49siw2pqho.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Mon 23-09-13 13:37:23, Jan Kara wrote:
>> On Tue 17-09-13 22:30:31, Jan Kara wrote:
>> > Currently each task sends BLK_TN_PROCESS event to the first traced
>> > device it interacts with after a new trace is started. When there are
>> > several traced devices and the task accesses more devices, this logic
>> > can result in BLK_TN_PROCESS being sent several times to some devices
>> > while it is never sent to other devices. Thus blkparse doesn't display
>> > command name when parsing some blktrace files.
>> > 
>> > Fix the problem by sending BLK_TN_PROCESS event to all traced devices
>> > when a task interacts with any of them.
>>   Jens, any opinion about this?
>   Jens, ping? I guess this patch fell through cracks...

This has my reviewed-by, FWIW.

Cheers,
Jeff

>
> 								Honza
>> > Signed-off-by: Jan Kara <jack@suse.cz>
>> > ---
>> >  include/linux/blktrace_api.h |  2 ++
>> >  kernel/trace/blktrace.c      | 33 +++++++++++++++++++++++++++------
>> >  2 files changed, 29 insertions(+), 6 deletions(-)
>> > 
>> > diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
>> > index 7c2e030..a12f6ed 100644
>> > --- a/include/linux/blktrace_api.h
>> > +++ b/include/linux/blktrace_api.h
>> > @@ -5,6 +5,7 @@
>> >  #include <linux/relay.h>
>> >  #include <linux/compat.h>
>> >  #include <uapi/linux/blktrace_api.h>
>> > +#include <linux/list.h>
>> >  
>> >  #if defined(CONFIG_BLK_DEV_IO_TRACE)
>> >  
>> > @@ -23,6 +24,7 @@ struct blk_trace {
>> >  	struct dentry *dir;
>> >  	struct dentry *dropped_file;
>> >  	struct dentry *msg_file;
>> > +	struct list_head running_list;
>> >  	atomic_t dropped;
>> >  };
>> >  
>> > diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
>> > index b8b8560..7f727b3 100644
>> > --- a/kernel/trace/blktrace.c
>> > +++ b/kernel/trace/blktrace.c
>> > @@ -26,6 +26,7 @@
>> >  #include <linux/export.h>
>> >  #include <linux/time.h>
>> >  #include <linux/uaccess.h>
>> > +#include <linux/list.h>
>> >  
>> >  #include <trace/events/block.h>
>> >  
>> > @@ -38,6 +39,9 @@ static unsigned int blktrace_seq __read_mostly = 1;
>> >  static struct trace_array *blk_tr;
>> >  static bool blk_tracer_enabled __read_mostly;
>> >  
>> > +static LIST_HEAD(running_trace_list);
>> > +static __cacheline_aligned_in_smp DEFINE_SPINLOCK(running_trace_lock);
>> > +
>> >  /* Select an alternative, minimalistic output than the original one */
>> >  #define TRACE_BLK_OPT_CLASSIC	0x1
>> >  
>> > @@ -107,10 +111,18 @@ record_it:
>> >   * Send out a notify for this process, if we haven't done so since a trace
>> >   * started
>> >   */
>> > -static void trace_note_tsk(struct blk_trace *bt, struct task_struct *tsk)
>> > +static void trace_note_tsk(struct task_struct *tsk)
>> >  {
>> > +	unsigned long flags;
>> > +	struct blk_trace *bt;
>> > +
>> >  	tsk->btrace_seq = blktrace_seq;
>> > -	trace_note(bt, tsk->pid, BLK_TN_PROCESS, tsk->comm, sizeof(tsk->comm));
>> > +	spin_lock_irqsave(&running_trace_lock, flags);
>> > +	list_for_each_entry(bt, &running_trace_list, running_list) {
>> > +		trace_note(bt, tsk->pid, BLK_TN_PROCESS, tsk->comm,
>> > +			   sizeof(tsk->comm));
>> > +	}
>> > +	spin_unlock_irqrestore(&running_trace_lock, flags);
>> >  }
>> >  
>> >  static void trace_note_time(struct blk_trace *bt)
>> > @@ -229,16 +241,15 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>> >  		goto record_it;
>> >  	}
>> >  
>> > +	if (unlikely(tsk->btrace_seq != blktrace_seq))
>> > +		trace_note_tsk(tsk);
>> > +
>> >  	/*
>> >  	 * A word about the locking here - we disable interrupts to reserve
>> >  	 * some space in the relay per-cpu buffer, to prevent an irq
>> >  	 * from coming in and stepping on our toes.
>> >  	 */
>> >  	local_irq_save(flags);
>> > -
>> > -	if (unlikely(tsk->btrace_seq != blktrace_seq))
>> > -		trace_note_tsk(bt, tsk);
>> > -
>> >  	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
>> >  	if (t) {
>> >  		sequence = per_cpu_ptr(bt->sequence, cpu);
>> > @@ -477,6 +488,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
>> >  	bt->dir = dir;
>> >  	bt->dev = dev;
>> >  	atomic_set(&bt->dropped, 0);
>> > +	INIT_LIST_HEAD(&bt->running_list);
>> >  
>> >  	ret = -EIO;
>> >  	bt->dropped_file = debugfs_create_file("dropped", 0444, dir, bt,
>> > @@ -601,6 +613,9 @@ int blk_trace_startstop(struct request_queue *q, int start)
>> >  			blktrace_seq++;
>> >  			smp_mb();
>> >  			bt->trace_state = Blktrace_running;
>> > +			spin_lock_irq(&running_trace_lock);
>> > +			list_add(&bt->running_list, &running_trace_list);
>> > +			spin_unlock_irq(&running_trace_lock);
>> >  
>> >  			trace_note_time(bt);
>> >  			ret = 0;
>> > @@ -608,6 +623,9 @@ int blk_trace_startstop(struct request_queue *q, int start)
>> >  	} else {
>> >  		if (bt->trace_state == Blktrace_running) {
>> >  			bt->trace_state = Blktrace_stopped;
>> > +			spin_lock_irq(&running_trace_lock);
>> > +			list_del_init(&bt->running_list);
>> > +			spin_unlock_irq(&running_trace_lock);
>> >  			relay_flush(bt->rchan);
>> >  			ret = 0;
>> >  		}
>> > @@ -1472,6 +1490,9 @@ static int blk_trace_remove_queue(struct request_queue *q)
>> >  	if (atomic_dec_and_test(&blk_probes_ref))
>> >  		blk_unregister_tracepoints();
>> >  
>> > +	spin_lock_irq(&running_trace_lock);
>> > +	list_del(&bt->running_list);
>> > +	spin_unlock_irq(&running_trace_lock);
>> >  	blk_trace_free(bt);
>> >  	return 0;
>> >  }
>> > -- 
>> > 1.8.1.4
>> > 
>> -- 
>> Jan Kara <jack@suse.cz>
>> SUSE Labs, CR
