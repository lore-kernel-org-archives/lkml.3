Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaJRJ7x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 05:59:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52655 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaJRJ7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 05:59:50 -0400
MIME-Version: 1.0
In-Reply-To: <87siio6o7g.fsf@openvz.org>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
	<1413281035-6483-2-git-send-email-dmonakhov@openvz.org>
	<CACVXFVNnyohjC6nXWxj+Ni4KBqsXFiDcQrBVXkFUMwb4DRr4bQ@mail.gmail.com>
	<87siio6o7g.fsf@openvz.org>
Date: Sat, 18 Oct 2014 17:59:47 +0800
Message-ID: <CACVXFVMEDWwVwM90tGrsWaLt+iNHa-2LMtYzmZm+B+PF_maE0Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] blkdev: add flush generation counter
From: Ming Lei <ming.lei@canonical.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 5:14 PM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Ming Lei <ming.lei@canonical.com> writes:
>
>> On Tue, Oct 14, 2014 at 12:03 PM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>>> PROF:
>>> *Flush machinery addumptions
>>> C1. At any given time, only one flush shall be in progress.  This is
>>>     double buffering sufficient.
>>> C2. Flush is deferred if any request is executing DATA of its ence.
>>>     This avoids issuing separate POSTFLUSHes for requests which ed
>>>     PREFLUSH.
>>> C3. The second condition is ignored if there is a request which has
>>>     waited longer than FLUSH_PENDING_TIMEOUT.  This is to avoid
>>>     starvation in the unlikely case where there are continuous am of
>>>     FUA (without FLUSH) requests.
>>>
>>> So if we will increment flush_tag counter in two places:
>>> blk_kick_flush: the place where flush request is issued
>>> flush_end_io : the place where flush is completed
>>> And by using rule (C1) we can guarantee that:
>>> if (flush_tag & 0x1 == 1) then flush_tag  is in progress
>>> if (flush_tag & 0x1 == 0) then (flush_tag & ~(0x1)) completed
>>> In other words we can define it as:
>>>
>>> FLUSH_TAG_IDX    = (flush_tag +1) & ~0x1
>>> FLUSH_TAG_STATE  = flush_tag & 0x1 ? IN_PROGRESS : COMPLETED
>>>
>>> After that we can define rules for flush optimization:
>>> We can be sure that our data was flushed only if:
>>> 1) data's bio was completed before flush request was QUEUED
>>>    and COMPLETED
>>> So in terms of formulas we can write it like follows:
>>> is_data_flushed = (blkdev->flush_tag & ~(0x1)) >
>>>                   ((data->flush_tag + 0x1) & (~0x1))
>>
>> Looks you are just trying to figure out if the 'data' is flushed or not,
>> so care to explain a bit what the optimization is?
> Indeed I try to understand whenever data was flushed or not.
> inodes on filesystem may update this  ID inside ->end_io callback.
> Later if user called fsync/fdatasync we may figure out that inode's
> data was flushed already so we do not have to issue explicit barrier.
> This helps for intensive multi-file dio-aio/fsync workloads
> chunk servers, virt-disk images, mail server, etc.
>
> for (i=0;i<fd_num;i++)
>     pwrite(fd[i], buf, 4096, 0)
> for (i=0;i<fd_num;i++)
>     fdatasync(fd[i])
> Before this optimization we have to issue a barrier to each fdatasync
> one by one, and send only one when optimization enabled.

Could you share some performance data about the optimization?

The flush command itself shouldn't be very expensive, but flushing
cache to storage from drive should be. Maybe the following simple
optimization can be done in blk-flush for your dio case:

- only issue flush command to drive if there are writes completed since
last flush.

>>>
>>>
>>> In order to support stacked block devices (especially linear dm)
>>> I've implemented get_flush_idx function as queue's callback.
>>>
>>> *Mutli-Queue scalability notes*
>>> This implementation try to makes global optimization for all hw-queues
>>> for a device which require read from each hw-queue like follows:
>>>  queue_for_each_hw_ctx(q, hctx, i)
>>>       fid +=  ACCESS_ONCE(hctx->fq->flush_idx)
>>
>> I am wondering if it can work, suppose request A is submitted
>> to hw_queue 0, and request B is submitted to hw_queue 1, then
>> you may thought request A has been flushed out when request
>> B is just flushed via hctx 1.
> Correct, because we know that at the moment A and B was completed
> at least one barrier was issued and completed (even via hwctx 2)
> Flush has blkdev/request_queue-wide guarantee regardless to hwctx.
> If it not the case for MQ then all filesystem are totally broken,
> and blkdev_issue_flush MUST be changed to flush all hwctx.

It is my fault, your approach is correct.


Thanks,
>>
>>>
>>> In my tests I do not see any visiable difference on performance on
>>> my hardware (W2600CR: 8cores x 2 sockets, 2numa nodes).
>>> Really fast HW may prefer to return flush_id for a single hw-queue
>>> in order to do so we have to encode flush_id with hw_queue_id
>>> like follows:
>>> fid_t = (hctx->fq->flush_id << MQ_SHIFT) | hctx->id
>>> #define MQ_ID(fid) (fid & ((1 << MQ_SHIFT) -1))
>>> Later blk_flush_idx_is_stable() can assumes fid_t as unstable if
>>> if was obtained from another hw-queue:
>>>
>>> bool blk_flush_idx_is_stable(struct request_queue *q, fid_t fid)
>>> {
>>>         int difference;
>>>         fid_t cur = blk_get_flush_idx(q, false);
>>>         if (MQ_ID(fid) != MQ_ID(fid))
>>>              return 0;
>>>
>>>         difference = (blk_get_flush_idx(q, false) - id);
>>>         return (difference > 0);
>>>
>>> }
>>> Please let me know if you prefer that design to global one.
>>>
>>> CC: Jens Axboe <axboe@kernel.dk>
>>> CC: Christoph Hellwig <hch@lst.de>
>>> CC: Ming Lei <ming.lei@canonical.com>
>>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>>> ---
>>>  block/blk-core.c       |    1 +
>>>  block/blk-flush.c      |   50 +++++++++++++++++++++++++++++++++++++++++++++++-
>>>  block/blk-mq.c         |    5 ++-
>>>  block/blk-settings.c   |    6 +++++
>>>  block/blk-sysfs.c      |   11 ++++++++++
>>>  block/blk.h            |    1 +
>>>  include/linux/blkdev.h |   17 ++++++++++++++++
>>>  7 files changed, 88 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index ffcb47a..78c7e64 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -714,6 +714,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
>>>         q->request_fn           = rfn;
>>>         q->prep_rq_fn           = NULL;
>>>         q->unprep_rq_fn         = NULL;
>>> +       q->get_flush_idx_fn     = get_flush_idx;
>>>         q->queue_flags          |= QUEUE_FLAG_DEFAULT;
>>>
>>>         /* Override internal queue lock with supplied lock pointer */
>>> diff --git a/block/blk-flush.c b/block/blk-flush.c
>>> index 20badd7..e264af8 100644
>>> --- a/block/blk-flush.c
>>> +++ b/block/blk-flush.c
>>> @@ -147,6 +147,46 @@ static bool blk_flush_queue_rq(struct request *rq, bool add_front)
>>>  }
>>>
>>>  /**
>>> + * get_flush_idx - return stable flush epoch index for a given queue
>>> + * @q: request_queue
>>> + * @queued: return index of latests queued flush
>>> + *
>>> + * Any bio which was completed before some flush request was QUEUED
>>> + * and COMPLETED is already in permanent store.  Upper layer may use this
>>> + * feature and skip explicit flush if already does that
>>> + *
>>> + * fq->flush_idx counter incremented in two places:
>>> + * 1)blk_kick_flush: the place where flush request is issued
>>> + * 2)flush_end_io  : the place where flush is completed
>>> + * And by using rule (C1) we can guarantee that:
>>> + * if (fq->flush_idx & 0x1 == 1) then flush_idx is in QUEUED
>>> + * if (fq->flush_idx & 0x1 == 0) then (flush_idx & ~(0x1)) COMPLETED
>>> + *
>>> + * In other words we can define it as:
>>> + * FLUSH_IDX    = (flush_idx +1) & ~0x1
>>> + * FLUSH_STATE  = flush_idx & 0x1 ? IN_PROGRESS : COMPLETED
>>> + *
>>> + */
>>> +unsigned get_flush_idx(struct request_queue *q, bool queued)
>>> +{
>>> +       struct blk_mq_hw_ctx *hctx;
>>> +       unsigned int i;
>>> +       unsigned fid = 0;
>>> +       unsigned diff = 0;
>>> +
>>> +       if (queued)
>>> +               diff = 0x1;
>>> +       if (!q->mq_ops) {
>>> +               fid = (ACCESS_ONCE(q->fq->flush_idx) + diff) >> 1;
>>> +       } else {
>>> +               queue_for_each_hw_ctx(q, hctx, i)
>>> +                       fid += (ACCESS_ONCE(hctx->fq->flush_idx) + diff) >> 1;
>>> +       }
>>> +       return fid;
>>> +}
>>> +EXPORT_SYMBOL(get_flush_idx);
>>> +
>>> +/**
>>>   * blk_flush_complete_seq - complete flush sequence
>>>   * @rq: FLUSH/FUA request being sequenced
>>>   * @fq: flush queue
>>> @@ -232,9 +272,15 @@ static void flush_end_io(struct request *flush_rq, int error)
>>>
>>>         running = &fq->flush_queue[fq->flush_running_idx];
>>>         BUG_ON(fq->flush_pending_idx == fq->flush_running_idx);
>>> -
>>> +       BUG_ON(!(fq->flush_idx & 0x1));
>>>         /* account completion of the flush request */
>>>         fq->flush_running_idx ^= 1;
>>> +       /* In case of error we have to restore original flush_idx
>>> +        * which was incremented kick_flush */
>>> +       if (unlikely(error))
>>> +               fq->flush_idx--;
>>> +       else
>>> +               fq->flush_idx++;
>>>
>>>         if (!q->mq_ops)
>>>                 elv_completed_request(q, flush_rq);
>>> @@ -303,6 +349,7 @@ static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq)
>>>          * different from running_idx, which means flush is in flight.
>>>          */
>>>         fq->flush_pending_idx ^= 1;
>>> +       fq->flush_idx++;
>>>
>>>         blk_rq_init(q, flush_rq);
>>>
>>> @@ -509,6 +556,7 @@ struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q,
>>>         INIT_LIST_HEAD(&fq->flush_queue[0]);
>>>         INIT_LIST_HEAD(&fq->flush_queue[1]);
>>>         INIT_LIST_HEAD(&fq->flush_data_in_flight);
>>> +       fq->flush_idx = 0;
>>>
>>>         return fq;
>>>
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index 4e7a314..3b60daf 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -1624,9 +1624,10 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
>>>                         break;
>>>         }
>>>
>>> -       if (i == q->nr_hw_queues)
>>> +       if (i == q->nr_hw_queues) {
>>> +               q->get_flush_idx_fn = get_flush_idx;
>>>                 return 0;
>>> -
>>> +       }
>>>         /*
>>>          * Init failed
>>>          */
>>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>>> index aa02247..1b192dc 100644
>>> --- a/block/blk-settings.c
>>> +++ b/block/blk-settings.c
>>> @@ -99,6 +99,12 @@ void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn)
>>>  }
>>>  EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
>>>
>>> +void blk_queue_get_flush_idx(struct request_queue *q, get_flush_idx_fn *fn)
>>> +{
>>> +       q->get_flush_idx_fn = fn;
>>> +}
>>> +EXPORT_SYMBOL_GPL(blk_queue_get_flush_idx);
>>> +
>>>  /**
>>>   * blk_set_default_limits - reset limits to default values
>>>   * @lim:  the queue_limits structure to reset
>>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>>> index e8f38a3..533fc0c 100644
>>> --- a/block/blk-sysfs.c
>>> +++ b/block/blk-sysfs.c
>>> @@ -94,6 +94,11 @@ queue_ra_store(struct request_queue *q, const char *page, size_t count)
>>>         return ret;
>>>  }
>>>
>>> +static ssize_t queue_flush_idx_show(struct request_queue *q, char *page)
>>> +{
>>> +       return sprintf(page, "%u\n", blk_get_flush_idx(q, false));
>>> +}
>>> +
>>>  static ssize_t queue_max_sectors_show(struct request_queue *q, char *page)
>>>  {
>>>         int max_sectors_kb = queue_max_sectors(q) >> 1;
>>> @@ -374,6 +379,11 @@ static struct queue_sysfs_entry queue_write_same_max_entry = {
>>>         .show = queue_write_same_max_show,
>>>  };
>>>
>>> +static struct queue_sysfs_entry queue_flush_idx_entry = {
>>> +       .attr = {.name = "flush_index", .mode = S_IRUGO },
>>> +       .show = queue_flush_idx_show,
>>> +};
>>> +
>>>  static struct queue_sysfs_entry queue_nonrot_entry = {
>>>         .attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
>>>         .show = queue_show_nonrot,
>>> @@ -422,6 +432,7 @@ static struct attribute *default_attrs[] = {
>>>         &queue_discard_max_entry.attr,
>>>         &queue_discard_zeroes_data_entry.attr,
>>>         &queue_write_same_max_entry.attr,
>>> +       &queue_flush_idx_entry.attr,
>>>         &queue_nonrot_entry.attr,
>>>         &queue_nomerges_entry.attr,
>>>         &queue_rq_affinity_entry.attr,
>>> diff --git a/block/blk.h b/block/blk.h
>>> index 43b0361..f4fa503 100644
>>> --- a/block/blk.h
>>> +++ b/block/blk.h
>>> @@ -18,6 +18,7 @@ struct blk_flush_queue {
>>>         unsigned int            flush_queue_delayed:1;
>>>         unsigned int            flush_pending_idx:1;
>>>         unsigned int            flush_running_idx:1;
>>> +       unsigned int            flush_idx;
>>>         unsigned long           flush_pending_since;
>>>         struct list_head        flush_queue[2];
>>>         struct list_head        flush_data_in_flight;
>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>>> index 5546392..6fb7bab 100644
>>> --- a/include/linux/blkdev.h
>>> +++ b/include/linux/blkdev.h
>>> @@ -237,6 +237,7 @@ typedef void (request_fn_proc) (struct request_queue *q);
>>>  typedef void (make_request_fn) (struct request_queue *q, struct bio *bio);
>>>  typedef int (prep_rq_fn) (struct request_queue *, struct request *);
>>>  typedef void (unprep_rq_fn) (struct request_queue *, struct request *);
>>> +typedef unsigned (get_flush_idx_fn) (struct request_queue *q, bool queued);
>>>
>>>  struct bio_vec;
>>>  struct bvec_merge_data {
>>> @@ -332,6 +333,7 @@ struct request_queue {
>>>         rq_timed_out_fn         *rq_timed_out_fn;
>>>         dma_drain_needed_fn     *dma_drain_needed;
>>>         lld_busy_fn             *lld_busy_fn;
>>> +       get_flush_idx_fn        *get_flush_idx_fn;
>>>
>>>         struct blk_mq_ops       *mq_ops;
>>>
>>> @@ -1030,6 +1032,7 @@ extern int blk_queue_dma_drain(struct request_queue *q,
>>>                                dma_drain_needed_fn *dma_drain_needed,
>>>                                void *buf, unsigned int size);
>>>  extern void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn);
>>> +extern void blk_queue_get_flush_idx(struct request_queue *q, get_flush_idx_fn *fn);
>>>  extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
>>>  extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
>>>  extern void blk_queue_unprep_rq(struct request_queue *, unprep_rq_fn *ufn);
>>> @@ -1180,6 +1183,20 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
>>>                                     nr_blocks << (sb->s_blocksize_bits - 9),
>>>                                     gfp_mask);
>>>  }
>>> +extern unsigned get_flush_idx(struct request_queue *q, bool queued);
>>> +static inline unsigned blk_get_flush_idx(struct request_queue *q, bool queued)
>>> +{
>>> +       if (unlikely(!q || !q->get_flush_idx_fn))
>>> +               return 0;
>>> +
>>> +       return q->get_flush_idx_fn(q, queued);
>>> +}
>>> +static inline bool blk_flush_idx_is_stable(struct request_queue *q, unsigned id)
>>> +{
>>> +       int difference = (blk_get_flush_idx(q, false) - id);
>>> +
>>> +       return (difference > 0);
>>> +}
>>>
>>>  extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
>>>
>>> --
>>> 1.7.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
