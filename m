Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaAQS0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:26:38 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44866 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaAQS0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:26:33 -0500
Message-ID: <52D975D3.2010009@bjorling.me>
Date: Fri, 17 Jan 2014 10:26:27 -0800
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH]  fs null_blk: Null pointer deference problem in alloc_page_buffers
References: <1389950530-8903-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
In-Reply-To: <1389950530-8903-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 01:22 AM, Raghavendra K T wrote:
>
> diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
> index a2e69d2..6b0e049 100644
> --- a/drivers/block/null_blk.c
> +++ b/drivers/block/null_blk.c
> @@ -535,6 +535,11 @@ static int null_add_dev(void)
>   	if (!nullb)
>   		return -ENOMEM;
>
> +	if (bs > PAGE_SIZE) {
> +		WARN(1, "Invalid block size. Setting it to 4096\n");
> +		bs = 4096;
> +	}
> +

Use PAGESIZE instead, move it to null_init with the other checks and use 
pr_warn for issuing the warning.

>   	spin_lock_init(&nullb->lock);
>
>   	if (queue_mode == NULL_Q_MQ && use_per_node_hctx)
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 6024877..029c698 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -883,6 +883,7 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
>   	struct buffer_head *bh, *head;
>   	long offset;
>
> +	BUG_ON(size > PAGE_SIZE);
>   try_again:
>   	head = NULL;
>   	offset = PAGE_SIZE;
> @@ -1571,6 +1572,7 @@ void create_empty_buffers(struct page *page,
>   	struct buffer_head *bh, *head, *tail;
>
>   	head = alloc_page_buffers(page, blocksize, 1);
> +	BUG_ON(!head);
>   	bh = head;
>   	do {
>   		bh->b_state |= b_state;
>

It seems? that the physical sector size is always limited to the system 
page size.

Why not do the check in add_disk (or __blkdev_get) and fail there, 
instead of failing on the first partition check?



