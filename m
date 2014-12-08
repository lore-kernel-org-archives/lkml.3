Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbaLHQtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:49:51 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56696 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbaLHQtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:49:50 -0500
Message-ID: <5485D6B0.3060901@kernel.dk>
Date: Mon, 08 Dec 2014 09:49:52 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Christoph Hellwig <hch@lst.de>, Robert Elliott <Elliott@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: Avoid that I/O hangs in bt_get()
References: <54328A97.3030201@acm.org> <5432D414.4060408@kernel.dk> <5432E524.90407@kernel.dk> <5433A85E.2070207@acm.org> <545B7A6D.8040208@acm.org> <5485BBD2.4040103@acm.org>
In-Reply-To: <5485BBD2.4040103@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 07:55 AM, Bart Van Assche wrote:
> On 11/06/14 14:41, Bart Van Assche wrote:
>> With kernel 3.18-rc3 and with can_queue=62 I can trigger a hang in
>> bt_get() easily.
>
> (once more replying to my own e-mail)
>
> Hello Jens,
>
> Finally I found the time to look further into this. The patch below
> seems to be sufficient to prevent this hang. However, I'm not a block
> layer expert so it's not clear to me whether the patch below makes sense ?
>
> Thanks,
>
> Bart.
>
> [PATCH] blk-mq: Fix bt_get() hang
>
> Avoid that if there are fewer hardware queues than CPU threads that
> bt_get() can hang. The symptoms of the hang were as follows:
> * All tags allocated for a particular hardware queue.
> * (nr_tags) pending commands for that hardware queue.
> * No pending commands for the software queues associated with that
>    hardware queue.
> ---
>   block/blk-mq-tag.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 67ab88b..e88af88 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -256,6 +256,8 @@ static int bt_get(struct blk_mq_alloc_data *data,
>               break;
>           }
>
> +        blk_mq_run_hw_queue(hctx, false);
> +
>           blk_mq_put_ctx(data->ctx);
>
>           io_schedule();

Ah yes, that could be an issue for some cases, we do need to run the 
queue there. For a tag map shared across hardware queues, we might need 
to run more than just the current queue, however. For now we can safely 
assume that we allocate fairly, so it should not be an issue.

It might be worth experimenting with doing a __bt_get() after the queue 
run before going to sleep, in case the queue run found completions as well.

-- 
Jens Axboe

