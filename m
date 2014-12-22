Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaLVXQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:16:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:41154 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbaLVXQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:16:08 -0500
Date: Mon, 22 Dec 2014 15:16:04 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
Message-ID: <20141222231604.GC8287@jaegeuk-mac02.mot.com>
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
 <20141222020317.GB3335@lcm>
 <000001d01db6$7d718770$78549650$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d01db6$7d718770$78549650$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Mon, Dec 22, 2014 at 03:10:30PM +0800, Chao Yu wrote:
> Hi Changman,
> 
> > -----Original Message-----
> > From: Changman Lee [mailto:cm224.lee@samsung.com]
> > Sent: Monday, December 22, 2014 10:03 AM
> > To: Chao Yu
> > Cc: Jaegeuk Kim; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > 
> > Hi Yu,
> > 
> > Good approach.
> 
> Thank you. :)
> 
> > As you know, however, f2fs breaks extent itself due to COW.
> 
> Yes, and sometimes f2fs use IPU when override writing, in this condition,
> by using this approach we can cache more contiguous mapping extent for better
> performance.

Hmm. When f2fs faces with this case, there is no chance to make an extent itself
at all.

> 
> > Unlike other filesystem like btrfs, minimum extent of f2fs could have 4KB granularity.
> > So we would have lots of extents per inode and it could lead to overhead
> > to manage extents.
> 
> Agree, the more number of extents are growing in one inode, the more memory
> pressure and longer latency operating in rb-tree we are facing.
> IMO, to solve this problem, we'd better to add limitation or shrink ability into
> extent cache:
> 1.limit extent number per inode with the value set from sysfs and discard extent
> from inode's extent lru list if we touch the limitation; (e.g. in FAT, max number
> of mapping extent per inode is fixed: 8)
> 2.add all extents of inodes into a global lru list, we will try to shrink this list
> if we're facing memory pressure.
> 
> How do you think? or any better ideas are welcome. :)

Historically, the reason that I added only one small extent cache is that I
wanted to avoid additional data structures having any overhead in critical data
write path.
Instead, I intended to use a well operating node page cache.

We need to consider what would be the benefit when using extent cache rather
than existing node page cache.

Thanks,

> 
> > 
> > Anyway, mount option could be alternative for this patch.
> 
> Yes, will do.
> 
> Thanks,
> Yu
> 
> > 
> > On Fri, Dec 19, 2014 at 06:49:29PM +0800, Chao Yu wrote:
> > > Now f2fs have page-block mapping cache which can cache only one extent mapping
> > > between contiguous logical address and physical address.
> > > Normally, this design will work well because f2fs will expand coverage area of
> > > the mapping extent when we write forward sequentially. But when we write data
> > > randomly in Out-Place-Update mode, the extent will be shorten and hardly be
> > > expanded for most time as following reasons:
> > > 1.The short part of extent will be discarded if we break contiguous mapping in
> > > the middle of extent.
> > > 2.The new mapping will be added into mapping cache only at head or tail of the
> > > extent.
> > > 3.We will drop the extent cache when the extent became very fragmented.
> > > 4.We will not update the extent with mapping which we get from readpages or
> > > readpage.
> > >
> > > To solve above problems, this patch adds extent cache base on rb-tree like other
> > > filesystems (e.g.: ext4/btrfs) in f2fs. By this way, f2fs can support another
> > > more effective cache between dnode page cache and disk. It will supply high hit
> > > ratio in the cache with fewer memory when dnode page cache are reclaimed in
> > > environment of low memory.
> > >
> > > Todo:
> > > *introduce mount option for extent cache.
> > > *add shrink ability for extent cache.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
