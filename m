Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaIAAsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:48:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42281 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaIAArr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:47:47 -0400
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C2EC7D@G9W0745.americas.hpqcorp.net>
References: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
	<1409414907-22238-4-git-send-email-ming.lei@canonical.com>
	<94D0CD8314A33A4D9D801C0FE68B402958C2EC7D@G9W0745.americas.hpqcorp.net>
Date: Mon, 1 Sep 2014 08:47:43 +0800
Message-ID: <CACVXFVMv+r-GvwwgjOXj=SGaw_T8spArBdRTeN570tuvv5Qwdw@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] block: loop: convert to blk-mq
From: Ming Lei <ming.lei@canonical.com>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Great thanks for your so detailed review.

On Sun, Aug 31, 2014 at 6:03 AM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>
>
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Ming Lei
>> Sent: Saturday, 30 August, 2014 11:08 AM
>> To: Jens Axboe; linux-kernel@vger.kernel.org; Dave Kleikamp
>> Cc: Zach Brown; Christoph Hellwig; Maxim Patlasov; Ming Lei
>> Subject: [PATCH v2 3/6] block: loop: convert to blk-mq
>>
> ...
>> -static inline void loop_handle_bio(struct loop_device *lo, struct
>> bio *bio)
>> +static inline int loop_handle_bio(struct loop_device *lo, struct bio
>> *bio)
>>  {
>> -     if (unlikely(!bio->bi_bdev)) {
>> -             do_loop_switch(lo, bio->bi_private);
>> -             bio_put(bio);
>> -     } else {
>> -             int ret = do_bio_filebacked(lo, bio);
>> -             bio_endio(bio, ret);
>> -     }
>> +     int ret = do_bio_filebacked(lo, bio);
>> +     return ret;
>
> No need for the temporary variable; just return the function
> call.
>
> ...
>> +static int loop_prepare_hctxs(struct loop_device *lo)
>> +{
>> +     struct request_queue *q = lo->lo_queue;
>> +     struct blk_mq_hw_ctx *hctx;
>> +     struct loop_hctx_data *data;
>> +     unsigned int i;
>> +
>> +     queue_for_each_hw_ctx(q, hctx, i) {
>> +             BUG_ON(i >= lo->tag_set.nr_hw_queues);
>
> If something goes bad in the loop driver like that, is it
> necessary to crash the whole kernel?

Actually, the BUG_ON() shouldn't have been added, will remove it.

>
>> +             data = hctx->driver_data;
>> +
>> +             data->lo = lo;
>> +             init_kthread_worker(&data->worker);
>> +             data->worker_task = kthread_run(kthread_worker_fn,
>> +                             &data->worker, "loop%d-%d",
>> +                             lo->lo_number, i);
>> +             if (IS_ERR(data->worker_task)) {
>> +                     loop_unprepare_hctxs(lo, i);
>> +                     return -ENOMEM;
>> +             }
>> +             set_user_nice(data->worker_task, MIN_NICE);
>> +             sched_getaffinity(data->worker_task->pid, hctx->cpumask);
>
> Is that supposed to be sched_setaffinity?  It looks like
> getaffinity does have a side-effect of updating the CPU mask
> based on the current active cpus, but there won't be a CPU mask
> to update unless setaffinity was called.

Hmm, it is a typo, and I meant sched_setaffinity(), but it isn't exported,
so set_cpus_allowed_ptr() should be used.

>
> ...
>> @@ -906,14 +848,10 @@ static int loop_set_fd(struct loop_device *lo,
>> fmode_t mode,
>>
>>       set_blocksize(bdev, lo_blocksize);
>>
>> -     lo->lo_thread = kthread_create(loop_thread, lo, "loop%d",
>> -                                             lo->lo_number);
>> -     if (IS_ERR(lo->lo_thread)) {
>> -             error = PTR_ERR(lo->lo_thread);
>> +     if ((error = loop_prepare_hctxs(lo)) != 0)
>>               goto out_clr;
>
> I've been told that linux kernel style is:
>         error = x();
>         if (error)
>
> ...
>> @@ -1014,7 +951,7 @@ static int loop_clr_fd(struct loop_device *lo)
>>       lo->lo_state = Lo_rundown;
>>       spin_unlock_irq(&lo->lo_lock);
>>
>> -     kthread_stop(lo->lo_thread);
>> +     loop_unprepare_hctxs(lo, lo->tag_set.nr_hw_queues);
>>
>>       spin_lock_irq(&lo->lo_lock);
>>       lo->lo_backing_file = NULL;
> ...
>> +
>> +static int loop_prepare_flush_rq(void *data, struct request_queue
>> *q,
>> +             struct request *flush_rq,
>> +             const struct request *src_rq)
>> +{
>> +     /* borrow initialization helper for common rq */
>> +     loop_init_request(data, flush_rq, 0, -1, NUMA_NO_NODE);
>> +     return 0;
>> +}
>
> In patch 2/6 that function is called with:
>         if (orig_rq->q->mq_ops->prepare_flush_rq)
>                 ret = orig_rq->q->mq_ops->prepare_flush_rq(
>                                 orig_rq->q->tag_set->driver_data,
>                                 orig_rq->q, flush_rq, orig_rq);
>
>
> The src_rq argument is not used in this new function.
> Do you anticipate it might be necessary in other drivers?

Yes, sooner or later the problem will be triggered in blk-mq
conversion for current drivers, and current default behaviour is to
copy pdu of src_rq to q->flush_rq, that is why the src_rq is passed.

> Is this new function allowed to modify *data, *flush_rq,
> or *src_rq?  If not, const might be good to add.

Instance pointed by data and src_rq shouldn't be modified.

>
> If orig_rq is always passed, then this function could
> decode orig_rq->q and orig_rq->q->tag_set_>driver_data
> on its own, eliminating the need for the first two arguments.

Looks a good idea.

>
> Similarly, in the unprepare_flush_rq function in patch 2,
> which is not provided by the loop driver in this patch:
>
> +               if (q->mq_ops->unprepare_flush_rq)
> +                       q->mq_ops->unprepare_flush_rq(
> +                               q->tag_set->driver_data,
> +                               q, q->flush_rq);
>
> if q is always passed, then that function could calculate
> q->tag_set_driver_data and q->flush_rq itself, eliminating
> two arguments.

I suggest to keep 'q' and 'q->flush_rq' because the callback
is closely related with flush req.

>
>> +
>> +static int loop_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
>> +             unsigned int index)
>> +{
>> +     hctx->driver_data = kmalloc(sizeof(struct loop_hctx_data),
>> +                     GFP_KERNEL);
>
> hctx->numa_node has been set before this; how about passing it
> along to kmalloc_node in case it has a useful value?

Yes, it is a good point.

> blk_mq_init_hw_queues sets it before calling this function:
>                 node = hctx->numa_node;
>                 if (node == NUMA_NO_NODE)
>                         node = hctx->numa_node = set->numa_node;
> ...
>                if (set->ops->init_hctx &&
>                     set->ops->init_hctx(hctx, set->driver_data, i))
>                         break;
>
> loop_add (down lower) just sets set->numa_node to NUMA_NO_NODE
> now, but it could hold a more interesting value in the future.

If nr_hw_queues is more than one, it has been set a more useful
value in blk_mq_init_cpu_queues().

>
>> +     if (!hctx->driver_data)
>> +             return -ENOMEM;
>> +     return 0;
>> +}
>> +
>> +static void loop_exit_hctx(struct blk_mq_hw_ctx *hctx, unsigned int
>> index)
>> +{
>> +     kfree(hctx->driver_data);
>> +}
>
> Setting hctx->driver_data to NULL after kfree would reduce the risk
> of the stale pointer ever being used.

If it is true, I suggest to do that in blk-mq.c instead of drivers.

>
>> +
>> +static struct blk_mq_ops loop_mq_ops = {
>> +     .queue_rq       = loop_queue_rq,
>> +     .map_queue      = blk_mq_map_queue,
>> +     .init_request   = loop_init_request,
>> +     .init_hctx      = loop_init_hctx,
>> +     .exit_hctx      = loop_exit_hctx,
>> +     .prepare_flush_rq  = loop_prepare_flush_rq,
>> +};
>> +
>>  static int loop_add(struct loop_device **l, int i)
>>  {
>>       struct loop_device *lo;
>> @@ -1627,15 +1646,20 @@ static int loop_add(struct loop_device **l,
>> int i)
>>       i = err;
>>
>>       err = -ENOMEM;
>> -     lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
>> -     if (!lo->lo_queue)
>> +     lo->tag_set.ops = &loop_mq_ops;
>> +     lo->tag_set.nr_hw_queues = nr_queues;
>> +     lo->tag_set.queue_depth = 128;
>> +     lo->tag_set.numa_node = NUMA_NO_NODE;
>
> scsi-mq also uses NUMA_NO_NODE right now.  Is there a better
> choice?

They should be in same situation wrt. this problem.

>
>> +     lo->tag_set.cmd_size = sizeof(struct loop_cmd);
>> +     lo->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>
> scsi-mq includes BLK_MQ_F_SG_MERGE.  Should this driver?

That is an interesting question, and maybe it is better to not do it
in loop and just depend on back file's.

>
>
>> +     lo->tag_set.driver_data = lo;
>> +
>> +     if (blk_mq_alloc_tag_set(&lo->tag_set))
>>               goto out_free_idr;
>
> Use:
>         err = blk_mq_alloc_tag_set(&lo->tag_set);
>         if (err)
> so the return value is propagated out of this function
> (the function ends with "return err;")

Right.

>>
>> -     /*
>> -      * set queue make_request_fn
>> -      */
>> -     blk_queue_make_request(lo->lo_queue, loop_make_request);
>> -     lo->lo_queue->queuedata = lo;
>> +     lo->lo_queue = blk_mq_init_queue(&lo->tag_set);
>> +     if (!lo->lo_queue)
>> +             goto out_cleanup_tags;
>
> That needs to be IS_ERR(lo->lo_queue) because blk_mq_init_queue
> returns ERR_PTR(-ENOMEM) on some errors.  scsi_mq_alloc_queue
> does that.

Good catch.

>
> ...
>> @@ -1680,6 +1701,8 @@ static int loop_add(struct loop_device **l, int
>> i)
>>
>>  out_free_queue:
>>       blk_cleanup_queue(lo->lo_queue);
>> +out_cleanup_tags:
>> +     blk_mq_free_tag_set(&lo->tag_set);
>
> Although lo is freed a few lines below, setting lo->tag_set to
> NULL would reduce the window in which a stale pointer could be used.

No, lo->tag_set isn't a pointer and the case needn't to worry about since
the queue has been cleaned up already.

>
>>  out_free_idr:
>>       idr_remove(&loop_index_idr, i);
>>  out_free_dev:
>> @@ -1692,6 +1715,7 @@ static void loop_remove(struct loop_device *lo)
>>  {
>>       del_gendisk(lo->lo_disk);
>>       blk_cleanup_queue(lo->lo_queue);
>> +     blk_mq_free_tag_set(&lo->tag_set);
>
> Although lo is freed a few lines below, setting lo->tag_set to
> NULL would reduce the window in which a stale pointer could be used.

Same with above.

>
>>       put_disk(lo->lo_disk);
>>       kfree(lo);
>>  }


Thanks,
--
Ming Lei
