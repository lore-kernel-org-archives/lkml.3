Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935399AbaDJOQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:16:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:44835 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934295AbaDJOQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:16:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,834,1389772800"; 
   d="scan'208";a="518521340"
Date: Thu, 10 Apr 2014 10:16:30 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 11/22] Replace ext2_clear_xip_target with
 dax_clear_blocks
Message-ID: <20140410141630.GH5727@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <b94af75d7123feced8ea8ba42d1d0e7c740d5009.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409094644.GD32103@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409094644.GD32103@quack.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 11:46:44AM +0200, Jan Kara wrote:
>   Another day, some more review ;) Comments below.

I'm really grateful for all this review!  It's killing me, though ;-)

> > +int dax_clear_blocks(struct inode *inode, sector_t block, long size)
> > +{
> > +	struct block_device *bdev = inode->i_sb->s_bdev;
> > +	const struct block_device_operations *ops = bdev->bd_disk->fops;
> > +	sector_t sector = block << (inode->i_blkbits - 9);
> > +	unsigned long pfn;
> > +
> > +	might_sleep();
> > +	do {
> > +		void *addr;
> > +		long count = ops->direct_access(bdev, sector, &addr, &pfn,
> > +									size);
>   So do you assume blocksize == PAGE_SIZE here? If not, addr could be in
> the middle of the page AFAICT.

You're right.  Depending on how clear_page() is implemented, that
might go badly wrong.  Of course, both ext2 & ext4 require block_size
== PAGE_SIZE right now, so anything else is by definition untested.
I've been trying to keep DAX free from that assumption, but obviously
haven't caught all the places.

How does this look?

typedef long (*direct_access_t)(struct block_device *, sector_t, void **,
                                unsigned long *pfn, long size);

int dax_clear_blocks(struct inode *inode, sector_t block, long size)
{
        struct block_device *bdev = inode->i_sb->s_bdev;
        direct_access_t direct_access = bdev->bd_disk->fops->direct_access;
        sector_t sector = block << (inode->i_blkbits - 9);
        unsigned long pfn;

        might_sleep();
        do {
                void *addr;
                long count = direct_access(bdev, sector, &addr, &pfn, size);
                if (count < 0)
                        return count;
                while (count > 0) {
                        unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
                        if (pgsz > count)
                                pgsz = count;
                        if (pgsz < PAGE_SIZE)
                                memset(addr, 0, pgsz);
                        else
                                clear_page(addr);
                        addr += pgsz;
                        size -= pgsz;
                        count -= pgsz;
                        sector += pgsz / 512;
                        cond_resched();
                }
        } while (size);

        return 0;
}
EXPORT_SYMBOL_GPL(dax_clear_blocks);

> >  	if (IS_DAX(inode)) {
> >  		/*
> > -		 * we need to clear the block
> > +		 * block must be initialised before we put it in the tree
> > +		 * so that it's not found by another thread before it's
> > +		 * initialised
> >  		 */
> > -		err = ext2_clear_xip_target (inode,
> > -			le32_to_cpu(chain[depth-1].key));
> > +		err = dax_clear_blocks(inode, le32_to_cpu(chain[depth-1].key),
> > +						count << inode->i_blkbits);
>   Umm 'count' looks wrong here. You want to clear only one block, don't
> you?

I think I got confused between ext2 and ext4 here.  I do want to clear
only one block.
