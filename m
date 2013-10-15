Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab3JOJqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:46:09 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51633 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab3JOJqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:46:06 -0400
Date: Tue, 15 Oct 2013 02:45:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Weijie Yang <weijie.yang.kh@gmail.com>,
        Bob Liu <bob.liu@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shaohua Li <shli@fusionio.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] swap: fix set_blocksize race during swapon/swapoff
In-Reply-To: <1381485262-16792-1-git-send-email-k.kozlowski@samsung.com>
Message-ID: <alpine.LNX.2.00.1310150235110.6194@eggly.anvils>
References: <1381485262-16792-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013, Krzysztof Kozlowski wrote:

> Swapoff used old_block_size from swap_info which could be overwritten by
> concurrent swapon.
> 
> Reported-by: Weijie Yang <weijie.yang.kh@gmail.com>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Hugh Dickins <hughd@google.com>

Yes, this is straightforward: it was relying on p->old_block_size
after it had given up its hold on *p: a use-after-free (though
those slots are not freed back to a lower-level allocator).

What is not obvious is why swapon needs to use set_blocksize() at all:
if I knew once upon a time, I've forgotten now: because a bdev starts
out with blocksize 0 and someone needs to set it non-0??

> ---
>  mm/swapfile.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 3963fc2..de7c904 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1824,6 +1824,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  	struct filename *pathname;
>  	int i, type, prev;
>  	int err;
> +	unsigned int old_block_size;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -1914,6 +1915,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  	}
>  
>  	swap_file = p->swap_file;
> +	old_block_size = p->old_block_size;
>  	p->swap_file = NULL;
>  	p->max = 0;
>  	swap_map = p->swap_map;
> @@ -1938,7 +1940,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  	inode = mapping->host;
>  	if (S_ISBLK(inode->i_mode)) {
>  		struct block_device *bdev = I_BDEV(inode);
> -		set_blocksize(bdev, p->old_block_size);
> +		set_blocksize(bdev, old_block_size);
>  		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
>  	} else {
>  		mutex_lock(&inode->i_mutex);
> -- 
> 1.7.9.5
