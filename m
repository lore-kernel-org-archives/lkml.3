Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3JKTC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:02:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3JKTC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:02:28 -0400
Date: Fri, 11 Oct 2013 12:02:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Weijie Yang <weijie.yang.kh@gmail.com>, Bob Liu <bob.liu@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shaohua Li <shli@fusionio.com>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] swap: fix set_blocksize race during swapon/swapoff
Message-Id: <20131011120226.1f4bb32569f370b57b841e79@linux-foundation.org>
In-Reply-To: <1381485262-16792-1-git-send-email-k.kozlowski@samsung.com>
References: <1381485262-16792-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc Hugh)

On Fri, 11 Oct 2013 11:54:22 +0200 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:

> Swapoff used old_block_size from swap_info which could be overwritten by
> concurrent swapon.
> 
> Reported-by: Weijie Yang <weijie.yang.kh@gmail.com>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
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

I find it worrying that a swapon can run concurrently with any of this
swapoff code.  It just seem to be asking for trouble and the code
really isn't set up for this and races here will be poorly tested for

I'm wondering if we should just extend swapon_mutex a lot and eliminate
the concurrency?

