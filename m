Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936210Ab3DHVRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:17:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936188Ab3DHVRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:17:12 -0400
Date: Mon, 8 Apr 2013 14:17:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] mm: remove compressed copy from zram in-memory
Message-Id: <20130408141710.1a1f76a0054bba49a42c76ca@linux-foundation.org>
In-Reply-To: <1365400862-9041-1-git-send-email-minchan@kernel.org>
References: <1365400862-9041-1-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Apr 2013 15:01:02 +0900 Minchan Kim <minchan@kernel.org> wrote:

> Swap subsystem does lazy swap slot free with expecting the page
> would be swapped out again so we can avoid unnecessary write.

Is that correct?  How can it save a write?

> But the problem in in-memory swap(ex, zram) is that it consumes
> memory space until vm_swap_full(ie, used half of all of swap device)
> condition meet. It could be bad if we use multiple swap device,
> small in-memory swap and big storage swap or in-memory swap alone.
> 
> This patch makes swap subsystem free swap slot as soon as swap-read
> is completed and make the swapcache page dirty so the page should
> be written out the swap device to reclaim it.
> It means we never lose it.

>From my reading of the patch, that isn't how it works?  It changed
end_swap_bio_read() to call zram_slot_free_notify(), which appears to
free the underlying compressed page.  I have a feeling I'm hopelessly
confused.

> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -20,6 +20,7 @@
>  #include <linux/buffer_head.h>
>  #include <linux/writeback.h>
>  #include <linux/frontswap.h>
> +#include <linux/blkdev.h>
>  #include <asm/pgtable.h>
>  
>  static struct bio *get_swap_bio(gfp_t gfp_flags,
> @@ -81,8 +82,30 @@ void end_swap_bio_read(struct bio *bio, int err)
>  				iminor(bio->bi_bdev->bd_inode),
>  				(unsigned long long)bio->bi_sector);
>  	} else {
> +		/*
> +		 * There is no reason to keep both uncompressed data and
> +		 * compressed data in memory.
> +		 */
> +		struct swap_info_struct *sis;
> +
>  		SetPageUptodate(page);
> +		sis = page_swap_info(page);
> +		if (sis->flags & SWP_BLKDEV) {
> +			struct gendisk *disk = sis->bdev->bd_disk;
> +			if (disk->fops->swap_slot_free_notify) {
> +				swp_entry_t entry;
> +				unsigned long offset;
> +
> +				entry.val = page_private(page);
> +				offset = swp_offset(entry);
> +
> +				SetPageDirty(page);
> +				disk->fops->swap_slot_free_notify(sis->bdev,
> +						offset);
> +			}
> +		}
>  	}
> +
>  	unlock_page(page);
>  	bio_put(bio);

The new code is wasted space if CONFIG_BLOCK=n, yes?

Also, what's up with the SWP_BLKDEV test?  zram doesn't support
SWP_FILE?  Why on earth not?

Putting swap_slot_free_notify() into block_device_operations seems
rather wrong.  It precludes zram-over-swapfiles for all time and means
that other subsystems cannot get notifications for swap slot freeing
for swapfile-backed swap.

