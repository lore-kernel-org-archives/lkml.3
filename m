Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaCKOmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbaCKOmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:42:20 -0400
Date: Tue, 11 Mar 2014 14:51:38 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu_ida: Handle out-of-tags gracefully
Message-ID: <20140311135137.GA22995@dhcp-26-207.brq.redhat.com>
References: <531DC851.5060400@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531DC851.5060400@acm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 03:12:33PM +0100, Bart Van Assche wrote:
> Avoid that percpu_ida_alloc() hangs or crashes if there are still
> tags are available. Wait until a tag becomes available instead of
> giving up when running out of tags temporarily. This patch fixes
> the following kernel bug:

Hi Bart,

Few comments below, but the changelog does not correspond to the
actual change in 'Wait until a tag becomes available'.

> ------------[ cut here ]------------
> kernel BUG at lib/percpu_ida.c:81!
> invalid opcode: 0000 [#1] SMP
> RIP: 0010:[<ffffffff8120f00e>]  [<ffffffff8120f00e>] percpu_ida_alloc+0x33e/0x370
> Call Trace:
>  [<ffffffff811ef95f>] blk_mq_get_tag+0x2f/0x50
>  [<ffffffff811ed79c>] blk_mq_alloc_rq.isra.17+0x1c/0x90
>  [<ffffffff811eeb9b>] blk_mq_alloc_request_pinned+0x9b/0x110
>  [<ffffffff811ef4c6>] blk_mq_make_request+0x426/0x480
>  [<ffffffff811e28f0>] generic_make_request+0xc0/0x110
>  [<ffffffff811e29ab>] submit_bio+0x6b/0x140
>  [<ffffffff8117aabb>] _submit_bh+0x13b/0x220
>  [<ffffffff8117d70f>] block_read_full_page+0x1ff/0x300
>  [<ffffffff81181128>] blkdev_readpage+0x18/0x20
>  [<ffffffff811067b7>] __do_page_cache_readahead+0x277/0x280
>  [<ffffffff81106d1d>] force_page_cache_readahead+0x8d/0xc0
>  [<ffffffff81106d9b>] page_cache_sync_readahead+0x4b/0x50
>  [<ffffffff810fdf05>] generic_file_aio_read+0x4c5/0x700
>  [<ffffffff8118147b>] blkdev_aio_read+0x4b/0x70
>  [<ffffffff8114a28a>] do_sync_read+0x5a/0x90
>  [<ffffffff8114a8cb>] vfs_read+0x9b/0x160
>  [<ffffffff8114b389>] SyS_read+0x49/0xa0
>  [<ffffffff81416049>] tracesys+0xd0/0xd5
> ---[ end trace cdd1a8a7968266cf ]---
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Alexander Gordeev <agordeev@redhat.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  lib/percpu_ida.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
> index 93d145e..170d27c 100644
> --- a/lib/percpu_ida.c
> +++ b/lib/percpu_ida.c
> @@ -73,7 +73,7 @@ static inline void steal_tags(struct percpu_ida *pool,
>  		if (cpu >= nr_cpu_ids) {
>  			cpu = cpumask_first(&pool->cpus_have_tags);
>  			if (cpu >= nr_cpu_ids)
> -				BUG();
> +				break;

I assume the BUG() above hits? If so, I am failing to understand how
the code gets here. Mind elaborate?

>  		}
>  
>  		pool->cpu_last_stolen = cpu;
> @@ -189,6 +189,9 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
>  		spin_unlock(&pool->lock);
>  		local_irq_restore(flags);
>  
> +		if (tags->nr_free)
> +			wake_up(&pool->wait);
> +

How 'tags->nr_free' could be checked out of locks?
Why waking up another thread instead of returning the tag on this CPU?
Why 'percpu_max_size' threshold is ignored?

Anyway, IMHO the above BUG() indicates a problem elsewhere.

>  		if (tag >= 0 || state == TASK_RUNNING)
>  			break;
>  
> -- 
> 1.8.4.5
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
