Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaG3TpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:45:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:2739 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaG3TpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:45:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,766,1400050800"; 
   d="scan'208";a="463299525"
Date: Wed, 30 Jul 2014 15:45:03 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 04/22] Change direct_access calling convention
Message-ID: <20140730194503.GQ6754@linux.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <b78b33d94b669a5fbd02e06f2493b43dd5d77698.1406058387.git.matthew.r.wilcox@intel.com>
 <53D9174C.7040906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D9174C.7040906@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 07:03:24PM +0300, Boaz Harrosh wrote:
> > +long bdev_direct_access(struct block_device *bdev, sector_t sector,
> > +			void **addr, unsigned long *pfn, long size)
> > +{
> > +	const struct block_device_operations *ops = bdev->bd_disk->fops;
> > +	if (!ops->direct_access)
> > +		return -EOPNOTSUPP;
> 
> You need to check alignment on PAGE_SIZE since this API requires it, do
> to pfn defined to a page_number.
> 
> (Unless you want to define another output-param like page_offset.
>  but this exercise can be left to the caller)
> 
> You also need to check against the partition boundary. so something like:
> 
> + 	if (sector & (PAGE_SECTORS-1))
> + 		return -EINVAL;

Mmm.  PAGE_SECTORS is private to brd (and also private to bcache!) at
this point.  We've got a real mess of defines of SECTOR_SIZE, SECTORSIZE,
SECTOR_SHIFT and so on, dotted throughout various random include files.
I am not the river to flush those Augean stables today.

I'll go with this, from the dcssblk driver:

        if (sector % (PAGE_SIZE / 512))
                return -EINVAL;

> +	if (unlikely(sector + size > part_nr_sects_read(bdev->bd_part)))
> + 		return -ERANGE;
> 
> Then perhaps you can remove that check from drivers

As noted in your followup, size is in terms of bytes.  Perhaps it should
be named 'length' to make it more clear that it's a byte count, not a
sector count?

In any case, this looks best to me:

        if ((sector + DIV_ROUND_UP(size, 512)) >
                                        part_nr_sects_read(bdev->bd_part))
                return -ERANGE;


> Style: Need a space between declaration and code (have you check-patch)

That's a bullshit check.  I don't know why it's in checkpatch.

> > +	if (size < 0)
> 
> 	if(size < PAGE_SIZE), No?

No, absolutely not.  PAGE_SIZE is unsigned long, which (if I understand
my C integer promotions correctly) means that 'size' gets promoted to
an unsigned long, and we compare them unsigned, so errors will never be
caught by this check.

