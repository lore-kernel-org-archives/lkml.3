Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbaAURNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:13:50 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48120 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaAURNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:13:46 -0500
Message-ID: <52DEAAC7.7070903@bjorling.me>
Date: Tue, 21 Jan 2014 09:13:43 -0800
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Jeff <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V3 2/2] fs : Add sanity checks for block size > PAGE_SIZE
References: <1390303800-22422-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <1390303800-22422-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
In-Reply-To: <1390303800-22422-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 03:30 AM, Raghavendra K T wrote:
> We could hit null pointer dereference error during alloc_page_buffers
> in : (1) block size > PAGE_SIZE (2) low memory.
> Add sanity check for that.
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  fs/block_dev.c | 1 +
>  fs/buffer.c    | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 1e86823..2481d42 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1027,6 +1027,7 @@ void bd_set_size(struct block_device *bdev, loff_t size)
>  			break;
>  		bsize <<= 1;
>  	}
> +	BUG_ON(bsize > PAGE_SIZE);
>  	bdev->bd_block_size = bsize;
>  	bdev->bd_inode->i_blkbits = blksize_bits(bsize);
>  }
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 6024877..b039b15 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1571,6 +1571,12 @@ void create_empty_buffers(struct page *page,
>  	struct buffer_head *bh, *head, *tail;
>  
>  	head = alloc_page_buffers(page, blocksize, 1);
> +
> +	/*
> + 	 * alloc_page_buffers() could return NULL on (1) bs > PAGE_SIZE
> + 	 * (2) low memory case. Ensure that we don't dereference null ptr
> + 	 */  
> +	BUG_ON(!head);
>  	bh = head;
>  	do {
>  		bh->b_state |= b_state;
> 

Reviewed-by: Matias Bjorling <m@bjorling.me>
