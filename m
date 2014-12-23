Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaLWDCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:02:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:17972 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaLWDCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:02:31 -0500
X-AuditID: cbfee61a-f79c06d000004e71-c1-5498db453aeb
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
 <20141222020317.GB3335@lcm> <000001d01db6$7d718770$78549650$@samsung.com>
 <20141222231604.GC8287@jaegeuk-mac02.mot.com>
In-reply-to: <20141222231604.GC8287@jaegeuk-mac02.mot.com>
Subject: RE: [RFC PATCH] f2fs: add extent cache base on rb-tree
Date: Tue, 23 Dec 2014 11:01:39 +0800
Message-id: <002a01d01e5c$e2ba0250$a82e06f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIdrOZR/WghInHEXExEmQlsJ7ruVwGbtX4eAhoxsdwBAAx8a5vbmH8A
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAV3X2zNCDE4eFLS4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxuKjN5gK
	pqhVbF8+k7GB8a5sFyMHh4SAicTsWfVdjJxAppjEhXvr2boYuTiEBBYxSnx8+g/K+cEosXfz
	RyaQKjYBFYnlHf/BbBEBNYnefVOYQAYxCxRJrFohAFG/lVGif1czM0gNp4CVxMpFTawgtrCA
	vcTCOe/A4iwCqhLtUy6wgdi8ApYS2z9eYoewBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8Sl
	ChI7zr5mhLjBTWL1koeMEDXiEhuP3GKZwCg0C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9Jz
	DfWKE3OLS/PS9ZLzczcxgmPgmdQOxpUNFocYBTgYlXh4F5yZESLEmlhWXJl7iFGCg1lJhFe9
	FSjEm5JYWZValB9fVJqTWnyIUZqDRUmcV8m+LURIID2xJDU7NbUgtQgmy8TBKdXAmP/rsqbg
	lc3TZDfd3ZSnrhvmcbV+ig4f527ZX5mVEuovgjol7/I7yXmuNWNr11/4dtHTzld21V9f62aL
	Lkk/P0Hz0qrp+xWPz+bckDKvc7Lo9Q8CF+dfFNGe6LYsN3qi6N6J3xx2OeudmiIYmbt2o1rj
	0dz9i48FxOUXGT37spUrIdXE/4TpLiWW4oxEQy3mouJEAIIdUZZ9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Tuesday, December 23, 2014 7:16 AM
> To: Chao Yu
> Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> 
> Hi Chao,
> 
> On Mon, Dec 22, 2014 at 03:10:30PM +0800, Chao Yu wrote:
> > Hi Changman,
> >
> > > -----Original Message-----
> > > From: Changman Lee [mailto:cm224.lee@samsung.com]
> > > Sent: Monday, December 22, 2014 10:03 AM
> > > To: Chao Yu
> > > Cc: Jaegeuk Kim; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > > Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> > >
> > > Hi Yu,
> > >
> > > Good approach.
> >
> > Thank you. :)
> >
> > > As you know, however, f2fs breaks extent itself due to COW.
> >
> > Yes, and sometimes f2fs use IPU when override writing, in this condition,
> > by using this approach we can cache more contiguous mapping extent for better
> > performance.
> 
> Hmm. When f2fs faces with this case, there is no chance to make an extent itself
> at all.

With new implementation of this patch f2fs will build extent cache when readpage/readpages.

> 
> >
> > > Unlike other filesystem like btrfs, minimum extent of f2fs could have 4KB granularity.
> > > So we would have lots of extents per inode and it could lead to overhead
> > > to manage extents.
> >
> > Agree, the more number of extents are growing in one inode, the more memory
> > pressure and longer latency operating in rb-tree we are facing.
> > IMO, to solve this problem, we'd better to add limitation or shrink ability into
> > extent cache:
> > 1.limit extent number per inode with the value set from sysfs and discard extent
> > from inode's extent lru list if we touch the limitation; (e.g. in FAT, max number
> > of mapping extent per inode is fixed: 8)
> > 2.add all extents of inodes into a global lru list, we will try to shrink this list
> > if we're facing memory pressure.
> >
> > How do you think? or any better ideas are welcome. :)
> 
> Historically, the reason that I added only one small extent cache is that I
> wanted to avoid additional data structures having any overhead in critical data
> write path.

Thank you for telling me the history of original extent cache.

> Instead, I intended to use a well operating node page cache.
> 
> We need to consider what would be the benefit when using extent cache rather
> than existing node page cache.

IMO, node page cache belongs to system level cache, filesystem sub system can
not control it completely, cached uptodate node page will be invalidated by
using drop_caches from sysfs, or reclaimer of mm, result in more IO when we need
these node page next time.
New extent cache belongs to filesystem level cache, it is completely controlled
by filesystem itself. What we can profit is: on the one hand, it is used as
first level cache above the node page cache, which can also increase the cache
hit ratio. On the other hand, it is more instable and controllable than node page
cache.

Thanks,
Yu

> 
> Thanks,
> 
> >
> > >
> > > Anyway, mount option could be alternative for this patch.
> >
> > Yes, will do.
> >
> > Thanks,
> > Yu
> >
> > >
> > > On Fri, Dec 19, 2014 at 06:49:29PM +0800, Chao Yu wrote:
> > > > Now f2fs have page-block mapping cache which can cache only one extent mapping
> > > > between contiguous logical address and physical address.
> > > > Normally, this design will work well because f2fs will expand coverage area of
> > > > the mapping extent when we write forward sequentially. But when we write data
> > > > randomly in Out-Place-Update mode, the extent will be shorten and hardly be
> > > > expanded for most time as following reasons:
> > > > 1.The short part of extent will be discarded if we break contiguous mapping in
> > > > the middle of extent.
> > > > 2.The new mapping will be added into mapping cache only at head or tail of the
> > > > extent.
> > > > 3.We will drop the extent cache when the extent became very fragmented.
> > > > 4.We will not update the extent with mapping which we get from readpages or
> > > > readpage.
> > > >
> > > > To solve above problems, this patch adds extent cache base on rb-tree like other
> > > > filesystems (e.g.: ext4/btrfs) in f2fs. By this way, f2fs can support another
> > > > more effective cache between dnode page cache and disk. It will supply high hit
> > > > ratio in the cache with fewer memory when dnode page cache are reclaimed in
> > > > environment of low memory.
> > > >
> > > > Todo:
> > > > *introduce mount option for extent cache.
> > > > *add shrink ability for extent cache.
> > > >
> > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > > ---

