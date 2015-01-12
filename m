Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbbALXJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:09:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbbALXJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:09:48 -0500
Date: Mon, 12 Jan 2015 15:09:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, willy@linux.intel.com
Subject: Re: [PATCH v12 07/20] dax,ext2: Replace ext2_clear_xip_target with
 dax_clear_blocks
Message-Id: <20150112150947.eb6ccb5c45edb4e83cd48b28@linux-foundation.org>
In-Reply-To: <1414185652-28663-8-git-send-email-matthew.r.wilcox@intel.com>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
	<1414185652-28663-8-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 17:20:39 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:

> This is practically generic code; other filesystems will want to call
> it from other places, but there's nothing ext2-specific about it.
> 
> Make it a little more generic by allowing it to take a count of the number
> of bytes to zero rather than fixing it to a single page.  Thanks to Dave
> Hansen for suggesting that I need to call cond_resched() if zeroing more
> than one page.
> 
> ...
>
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -20,8 +20,45 @@
>  #include <linux/fs.h>
>  #include <linux/genhd.h>
>  #include <linux/mutex.h>
> +#include <linux/sched.h>
>  #include <linux/uio.h>
>  
> +int dax_clear_blocks(struct inode *inode, sector_t block, long size)
> +{
> +	struct block_device *bdev = inode->i_sb->s_bdev;
> +	sector_t sector = block << (inode->i_blkbits - 9);
> +
> +	might_sleep();
> +	do {
> +		void *addr;
> +		unsigned long pfn;
> +		long count;
> +
> +		count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
> +		if (count < 0)
> +			return count;
> +		BUG_ON(size < count);
> +		while (count > 0) {
> +			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
> +			if (pgsz > count)
> +				pgsz = count;
> +			if (pgsz < PAGE_SIZE)
> +				memset(addr, 0, pgsz);
> +			else
> +				clear_page(addr);

Are there any cache issues in all this code? flush_dcache_page(addr)?

> +			addr += pgsz;
> +			size -= pgsz;
> +			count -= pgsz;
> +			BUG_ON(pgsz & 511);
> +			sector += pgsz / 512;
> +			cond_resched();
> +		}
> +	} while (size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_clear_blocks);
>
> ...
>
