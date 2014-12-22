Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaLVJHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:07:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27858 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaLVJHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:07:42 -0500
X-AuditID: cbfee61a-f79c06d000004e71-27-5497df5cce72
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
 <20141222020317.GB3335@lcm>
In-reply-to: <20141222020317.GB3335@lcm>
Subject: RE: [RFC PATCH] f2fs: add extent cache base on rb-tree
Date: Mon, 22 Dec 2014 17:06:52 +0800
Message-id: <000401d01dc6$bce92330$36bb6990$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIdrOZR/WghInHEXExEmQlsJ7ruVwGbtX4em/NRpNA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jQd2Y+9NDDP6s1bC4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXRtu2g+wF
	a0Urbmw0bWD8IdDFyMkhIWAicebUQkYIW0ziwr31bF2MXBxCAtMZJSau+g3l/GCUmPD6OStI
	FZuAisTyjv9MILaIgJbE/p5uFhCbWSBP4vysBrAaIYFwie3LloFN5RTQkPj27hFYvbCAvcTC
	Oe+YQWwWAVWJy/2XwWxeAUuJ8/1rWCFsQYkfk+9BzdSSWL/zOBOELS+xec1bZohLFSR2nH3N
	CHGDlcSTyR3MEDXiEhuP3GKZwCg0C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxgmPgmdQOxpUNFocYBTgYlXh4OdKmhwixJpYVV+YeYpTgYFYS4d3aDRTiTUms
	rEotyo8vKs1JLT7EKM3BoiTOq2TfFiIkkJ5YkpqdmlqQWgSTZeLglGpgtBR49JfxnwBv6db9
	sxZqd/5m8L0X/yJm1e505vtZRr7nz/wIWCOj9pTj+OGFmS9KQ64bpm6+F1KskGn25tvVA692
	W6mrzPHKu+7p5WL138izy07oGFPy5/l/n8TzHnBPZjy3NO5pZF1j75L782bcDtH5k6hhofHh
	57l8s5ZtUsWrBV/dZ5qdqsRSnJFoqMVcVJwIAH9TjEt9AgAA
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
> As you know, however, f2fs breaks extent itself due to COW.
> Unlike other filesystem like btrfs, minimum extent of f2fs could have 4KB granularity.
> So we would have lots of extents per inode and it could lead to overhead
> to manage extents.
> 
> Anyway, mount option could be alternative for this patch.
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

[snip]

> > +static void __try_merge_extent(struct inode *inode, struct extent_info *ei)
> > +{
> > +	struct rb_root *root = &F2FS_I(inode)->ei_tree.root;
> > +	struct extent_info *pei = NULL;
> > +	struct rb_node *node;
> > +
> > +	node = rb_prev(&ei->rb_node);
> > +	if (node) {
> > +		pei = rb_entry(node, struct extent_info, rb_node);
> > +		if (ei->blk == pei->blk + pei->len) {
> 
> Shouldn't we check below together, too?
> if (ei->fofs == pei->fofs + pei->len)

Yes, you're right.
The following "if (ei->blk + 1 == pei->blk)" has the same problem.
I will fix this issue, thanks for your review!

Regards,
Yu


