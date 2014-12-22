Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaLVHL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:11:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:44980 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLVHLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:11:24 -0500
X-AuditID: cbfee61a-f79c06d000004e71-81-5497c41ace61
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
 <20141222020317.GB3335@lcm>
In-reply-to: <20141222020317.GB3335@lcm>
Subject: RE: [RFC PATCH] f2fs: add extent cache base on rb-tree
Date: Mon, 22 Dec 2014 15:10:30 +0800
Message-id: <000001d01db6$7d718770$78549650$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIdrOZR/WghInHEXExEmQlsJ7ruVwGbtX4em/MRIbA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jQV2pI9NDDCbdlbe4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxsuLa9kK
	OsUr+o8uZWlgXCHUxcjJISFgIjH72Bd2CFtM4sK99WxdjFwcQgLTGSWOH5zJCuH8YJTo3PkX
	rIpNQEViecd/JhBbREBLYn9PNwuIzSyQJ3F+VgMriC0kEC6xfdkyRhCbU0BD4tu7R2D1wgL2
	EgvnvGMGsVkEVCV+3doCZvMKWEos3nsKyhaU+DH5HtRMLYn1O48zQdjyEpvXvGWGuFRBYsfZ
	14wQN1hJPF7ZyAhRIy6x8cgtlgmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgx
	t7g0L10vOT93EyM4Cp5J7WBc2WBxiFGAg1GJh5cjbXqIEGtiWXFl7iFGCQ5mJRHerd1AId6U
	xMqq1KL8+KLSnNTiQ4zSHCxK4rxK9m0hQgLpiSWp2ampBalFMFkmDk6pBsZ8hp+vlnI3i/Ax
	1P0U3ZblqHRmxe+n7YJ5kfHTlFTimAU3nXwx6Z9kdV/Dtieu2lqlvbUbF5xaM0Xr+kbWjQp8
	Z8RmB9S8Yf0r/Zk5IIFL/8U3dfXlR+c4yUSdnXnu0IqLVxIzkxdPu8KQKZ1a39pxufvT1+XS
	jXqXrRJP7eU9Ifb/q65xo4ESS3FGoqEWc1FxIgBtCK2WfgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changman,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@samsung.com]
> Sent: Monday, December 22, 2014 10:03 AM
> To: Chao Yu
> Cc: Jaegeuk Kim; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
> 
> Hi Yu,
> 
> Good approach.

Thank you. :)

> As you know, however, f2fs breaks extent itself due to COW.

Yes, and sometimes f2fs use IPU when override writing, in this condition,
by using this approach we can cache more contiguous mapping extent for better
performance.

> Unlike other filesystem like btrfs, minimum extent of f2fs could have 4KB granularity.
> So we would have lots of extents per inode and it could lead to overhead
> to manage extents.

Agree, the more number of extents are growing in one inode, the more memory
pressure and longer latency operating in rb-tree we are facing.
IMO, to solve this problem, we'd better to add limitation or shrink ability into
extent cache:
1.limit extent number per inode with the value set from sysfs and discard extent
from inode's extent lru list if we touch the limitation; (e.g. in FAT, max number
of mapping extent per inode is fixed: 8)
2.add all extents of inodes into a global lru list, we will try to shrink this list
if we're facing memory pressure.

How do you think? or any better ideas are welcome. :)

> 
> Anyway, mount option could be alternative for this patch.

Yes, will do.

Thanks,
Yu

> 
> On Fri, Dec 19, 2014 at 06:49:29PM +0800, Chao Yu wrote:
> > Now f2fs have page-block mapping cache which can cache only one extent mapping
> > between contiguous logical address and physical address.
> > Normally, this design will work well because f2fs will expand coverage area of
> > the mapping extent when we write forward sequentially. But when we write data
> > randomly in Out-Place-Update mode, the extent will be shorten and hardly be
> > expanded for most time as following reasons:
> > 1.The short part of extent will be discarded if we break contiguous mapping in
> > the middle of extent.
> > 2.The new mapping will be added into mapping cache only at head or tail of the
> > extent.
> > 3.We will drop the extent cache when the extent became very fragmented.
> > 4.We will not update the extent with mapping which we get from readpages or
> > readpage.
> >
> > To solve above problems, this patch adds extent cache base on rb-tree like other
> > filesystems (e.g.: ext4/btrfs) in f2fs. By this way, f2fs can support another
> > more effective cache between dnode page cache and disk. It will supply high hit
> > ratio in the cache with fewer memory when dnode page cache are reclaimed in
> > environment of low memory.
> >
> > Todo:
> > *introduce mount option for extent cache.
> > *add shrink ability for extent cache.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---


