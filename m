Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936411Ab3DIBCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:02:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52647 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763340Ab3DIBCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:02:38 -0400
X-AuditID: 9c930197-b7b50ae00000018c-10-516368ab7ae0
Date: Tue, 9 Apr 2013 10:02:31 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] mm: remove compressed copy from zram in-memory
Message-ID: <20130409010231.GA3467@blaptop>
References: <1365400862-9041-1-git-send-email-minchan@kernel.org>
 <20130408141710.1a1f76a0054bba49a42c76ca@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408141710.1a1f76a0054bba49a42c76ca@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, Apr 08, 2013 at 02:17:10PM -0700, Andrew Morton wrote:
> On Mon,  8 Apr 2013 15:01:02 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > Swap subsystem does lazy swap slot free with expecting the page
> > would be swapped out again so we can avoid unnecessary write.
> 
> Is that correct?  How can it save a write?

Correct.

The add_to_swap makes the page dirty and we must pageout only if the page is
dirty. If a anon page is already charged into swapcache, we skip writeout
the page in shrink_page_list, then just remove the page from swapcache and
free it by __remove_mapping.

I did received same question multiple time so it would be good idea to
write down it in vmscan.c somewhere.

> 
> > But the problem in in-memory swap(ex, zram) is that it consumes
> > memory space until vm_swap_full(ie, used half of all of swap device)
> > condition meet. It could be bad if we use multiple swap device,
> > small in-memory swap and big storage swap or in-memory swap alone.
> > 
> > This patch makes swap subsystem free swap slot as soon as swap-read
> > is completed and make the swapcache page dirty so the page should
> > be written out the swap device to reclaim it.
> > It means we never lose it.
> 
> >From my reading of the patch, that isn't how it works?  It changed
> end_swap_bio_read() to call zram_slot_free_notify(), which appears to
> free the underlying compressed page.  I have a feeling I'm hopelessly
> confused.

You understand right totally.
Selecting swap slot in my description was totally miss.
Need to rewrite the description.

> 
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/buffer_head.h>
> >  #include <linux/writeback.h>
> >  #include <linux/frontswap.h>
> > +#include <linux/blkdev.h>
> >  #include <asm/pgtable.h>
> >  
> >  static struct bio *get_swap_bio(gfp_t gfp_flags,
> > @@ -81,8 +82,30 @@ void end_swap_bio_read(struct bio *bio, int err)
> >  				iminor(bio->bi_bdev->bd_inode),
> >  				(unsigned long long)bio->bi_sector);
> >  	} else {
> > +		/*
> > +		 * There is no reason to keep both uncompressed data and
> > +		 * compressed data in memory.
> > +		 */
> > +		struct swap_info_struct *sis;
> > +
> >  		SetPageUptodate(page);
> > +		sis = page_swap_info(page);
> > +		if (sis->flags & SWP_BLKDEV) {
> > +			struct gendisk *disk = sis->bdev->bd_disk;
> > +			if (disk->fops->swap_slot_free_notify) {
> > +				swp_entry_t entry;
> > +				unsigned long offset;
> > +
> > +				entry.val = page_private(page);
> > +				offset = swp_offset(entry);
> > +
> > +				SetPageDirty(page);
> > +				disk->fops->swap_slot_free_notify(sis->bdev,
> > +						offset);
> > +			}
> > +		}
> >  	}
> > +
> >  	unlock_page(page);
> >  	bio_put(bio);
> 
> The new code is wasted space if CONFIG_BLOCK=n, yes?

CONFIG_SWAP is already dependent on CONFIG_BLOCK.

> 
> Also, what's up with the SWP_BLKDEV test?  zram doesn't support
> SWP_FILE?  Why on earth not?
> 
> Putting swap_slot_free_notify() into block_device_operations seems
> rather wrong.  It precludes zram-over-swapfiles for all time and means
> that other subsystems cannot get notifications for swap slot freeing
> for swapfile-backed swap.

Zram is just pseudo-block device so anyone can format it with any FSes
and swapon a file. In such case, he can't get a benefit from
swap_slot_free_notify. But I think it's not a severe problem because
there is no reason to use a file-swap on zram. If anyone want to use it,
I'd like to know the reason. If it's reasonable, we have to rethink a
wheel and it's another story, IMHO.


> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
