Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaAUUVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:21:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaAUUVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:21:12 -0500
Date: Tue, 21 Jan 2014 12:21:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Matias Bjorling <m@bjorling.me>,
        Jens Axboe <axboe@kernel.dk>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Jeff <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V3 2/2] fs : Add sanity checks for block size >
 PAGE_SIZE
Message-Id: <20140121122110.4a74f04f43d2fdc0a8ae35bf@linux-foundation.org>
In-Reply-To: <1390303800-22422-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1390303800-22422-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
	<1390303800-22422-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014 17:00:00 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

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

alloc_page_buffers() will always return NULL if passed size >=
PAGE_SIZE.  So if we're going to add a check, it would be better to add
it to alloc_page_buffers() because that will catch errors from the
widest range of callsites.

But alloc_page_buffers() is pretty frequently called and I'd be
inclined to not add any check - most callers will just go oops and that
will provide basically the same information.

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

This is unneeded.

- bs > PAGE_SIZE can be checked elsewhere in a direct fashion

- low memory case can't happen - we passed retry=1

- create_empty_buffers() will immediately go oops if head==NULL. 
  That oops contains the same info as is presented by a BUG().

