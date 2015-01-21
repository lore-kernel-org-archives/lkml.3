Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbbAUFaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:30:07 -0500
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:37322 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbAUFaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:30:05 -0500
X-Greylist: delayed 2041 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2015 00:30:04 EST
X-AuditID: 85900ec0-be8f3b9000002d32-f9-54bf31344780
Message-ID: <54BF315F.5090709@hitachi.com>
Date: Wed, 21 Jan 2015 13:55:59 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [patch] cfq-iosched: fix incorrect filing of rt async cfqq
References: <x494mrvu4wi.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x494mrvu4wi.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for the patch, Jeff!

(2015/01/13 5:21), Jeff Moyer wrote:
> Hi,
>
> If you can manage to submit an async write as the first async I/O from
> the context of a process with realtime scheduling priority, then a
> cfq_queue is allocated, but filed into the wrong async_cfqq bucket.  It
> ends up in the best effort array, but actually has realtime I/O
> scheduling priority set in cfqq->ioprio.

Actually, this bug causes a severe I/O starvation in the following scenario
(we've experienced):

1. RT demon issues an O_SYNC write to an ext2 filesystem early in the
   boot sequence (this is an example which causes the first async write
   to a device in an RT process context)

2. Do heavy buffered writes to the device (these writes will be
   treated as RT class)

3. Issue a sync I/O to the device, and it will take over tens seconds
   to be prevented by many RT class I/Os

I confirmed Jeff's patch solves the above problem.

Tested-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

>
> The reason is that cfq_get_queue assumes the default scheduling class and
> priority when there is no information present (i.e. when the async cfqq
> is created):
>
> static struct cfq_queue *
> cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
> 	      struct bio *bio, gfp_t gfp_mask)
> {
> 	const int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
> 	const int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
>
> cic->ioprio starts out as 0, which is "invalid".  So, class of 0
> (IOPRIO_CLASS_NONE) is passed to cfq_async_queue_prio like so:
>
> 		async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class, ioprio);
>
> static struct cfq_queue **
> cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
> {
>         switch (ioprio_class) {
>         case IOPRIO_CLASS_RT:
>                 return &cfqd->async_cfqq[0][ioprio];
>         case IOPRIO_CLASS_NONE:
>                 ioprio = IOPRIO_NORM;
>                 /* fall through */
>         case IOPRIO_CLASS_BE:
>                 return &cfqd->async_cfqq[1][ioprio];
>         case IOPRIO_CLASS_IDLE:
>                 return &cfqd->async_idle_cfqq;
>         default:
>                 BUG();
>         }
> }
>
> Here, instead of returning a class mapped from the process' scheduling
> priority, we get back the bucket associated with IOPRIO_CLASS_BE.
>
> Now, there is no queue allocated there yet, so we create it:
>
> 		cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio, gfp_mask);
>
> That function ends up doing this:
>
> 			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
> 			cfq_init_prio_data(cfqq, cic);
>
> cfq_init_cfqq marks the priority as having changed.  Then, cfq_init_prio
> data does this:
>
> 	ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
> 	switch (ioprio_class) {
> 	default:
> 		printk(KERN_ERR "cfq: bad prio %x\n", ioprio_class);
> 	case IOPRIO_CLASS_NONE:
> 		/*
> 		 * no prio set, inherit CPU scheduling settings
> 		 */
> 		cfqq->ioprio = task_nice_ioprio(tsk);
> 		cfqq->ioprio_class = task_nice_ioclass(tsk);
> 		break;
>
> So we basically have two code paths that treat IOPRIO_CLASS_NONE
> differently, which results in an RT async cfqq filed into a best effort
> bucket.
>
> Attached is a patch which fixes the problem.  I'm not sure how to make
> it cleaner.  Suggestions would be welcome.
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 6f2751d..b9abdca 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3656,12 +3656,17 @@ static struct cfq_queue *
>  cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
>  	      struct bio *bio, gfp_t gfp_mask)
>  {
> -	const int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
> -	const int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
> +	int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
> +	int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
>  	struct cfq_queue **async_cfqq = NULL;
>  	struct cfq_queue *cfqq = NULL;
>  
>  	if (!is_sync) {
> +		if (!ioprio_valid(cic->ioprio)) {
> +			struct task_struct *tsk = current;
> +			ioprio = task_nice_ioprio(tsk);
> +			ioprio_class = task_nice_ioclass(tsk);
> +		}
>  		async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class, ioprio);
>  		cfqq = *async_cfqq;
>  	}
>
>


--
Hidehiro Kawai
Hitachi, Yokohama Research Laboratory

