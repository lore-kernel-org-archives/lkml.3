Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbbAWBxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:53:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14640 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbbAWBx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:53:28 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-0f-54c1a996b7dd
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <000701d02e37$0b11cfa0$21356ee0$@samsung.com>
 <20150123002434.GC16473@jaegeuk-mac02>
In-reply-to: <20150123002434.GC16473@jaegeuk-mac02>
Subject: RE: [f2fs-dev][RFC PATCH 03/10] f2fs: introduce f2fs_map_bh to clean
 codes of check_extent_cache
Date: Fri, 23 Jan 2015 09:52:30 +0800
Message-id: <00e701d036af$5c0c6fc0$14254f40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKNCAJRWXV8a1Vc900AIzmZig0MowFNfEVqm0jiKxA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jQd1pKw+GGCx7z2txbV8jk8WT9bOY
	LS4tcre4vGsOmwOLx6ZVnWweuxd8ZvLo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujAfrMgpa
	5CtuX5rJ0sB4XbyLkZNDQsBEYt3WC0wQtpjEhXvr2boYuTiEBKYzSrzcvR4sISTwg1FixW5N
	EJtNQEViecd/sLiIgJpE774pQDYHB7NAkcSqFQIQ5UkStz+tZgaxOQWMJQ41PAUrFxbIlrhz
	djU7iM0ioCqx5dA5MJtXwFJi0uuVULagxI/J91hAbGYBLYn1O48zQdjyEpvXvGWGuFNBYsfZ
	14wQJ1hJzPn5mB2iRlxi45FbLBMYhWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFi
	bnFpXrpecn7uJkZw+D+T3sG4qsHiEKMAB6MSD29G8YEQIdbEsuLK3EOMEhzMSiK8BksOhgjx
	piRWVqUW5ccXleakFh9ilOZgURLnVbJvCxESSE8sSc1OTS1ILYLJMnFwSjUwttyJ4GG+Vn9+
	8eMNbm/6PjFOE2lS99+cc0aN76G5sVnq5+pDrvwsJmYh0tw5b3QrS4ylPWPsc3zUAp+VZ/Sb
	9b+vOXy0TGtWcPncDwm/y0JUNOKnSk7coyZVXh2fMF9l2c3NlW6mtQeW3vX+08Yvn/Fodenv
	w2mzSw853p+h+NaiPFjh9kwlluKMREMt5qLiRACVR8FCewIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Friday, January 23, 2015 8:25 AM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][RFC PATCH 03/10] f2fs: introduce f2fs_map_bh to clean codes of
> check_extent_cache
> 
> Hi Chao,
> 
> On Mon, Jan 12, 2015 at 03:11:04PM +0800, Chao Yu wrote:
> > This patch introduces f2fs_map_bh to clean codes of check_extent_cache.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/data.c | 42 ++++++++++++++++++++++++++++--------------
> >  1 file changed, 28 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 935a23b..5a3e489 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -248,8 +248,30 @@ int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
> >  	return err;
> >  }
> >
> > +static void f2fs_map_bh(struct inode *inode, pgoff_t pgofs,
> > +			struct extent_info *ei, struct buffer_head *bh_result)
> > +{
> > +	unsigned int blkbits = inode->i_sb->s_blocksize_bits;
> > +	pgoff_t start_fofs, end_fofs;
> > +	block_t start_blkaddr;
> > +	size_t count;
> > +
> > +	start_fofs = ei->fofs;
> > +	end_fofs = ei->fofs + ei->len - 1;
> > +	start_blkaddr = ei->blk;
> > +
> > +	clear_buffer_new(bh_result);
> > +	map_bh(bh_result, inode->i_sb,
> > +			start_blkaddr + pgofs - start_fofs);
> > +	count = end_fofs - pgofs + 1;
> 
> How about cleaning this codes like this?

Nice! I will use it.

Thanks,
Yu

> 
> static void f2fs_map_bh(struct super_block *sb, pgoff_t pgofs,
>                        struct extent_info *ei, struct buffer_head *bh_result)
> {
>        unsigned int blkbits = sb->s_blocksize_bits;
>        size_t count;
> 
>        clear_buffer_new(bh_result);
>        map_bh(bh_result, sb, ei->blk + pgofs - ei->fofs);
>        count = ei->fofs + ei->len  - pgofs;
>        if (count < (UINT_MAX >> blkbits))
>                bh_result->b_size = (count << blkbits);
>        else
>                bh_result->b_size = UINT_MAX;
> }
> 
> > +	if (count < (UINT_MAX >> blkbits))
> > +		bh_result->b_size = (count << blkbits);
> > +	else
> > +		bh_result->b_size = UINT_MAX;
> > +}
> > +
> >  static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
> > -					struct buffer_head *bh_result)
> > +					struct extent_info *ei)
> >  {
> >  	struct f2fs_inode_info *fi = F2FS_I(inode);
> >  	pgoff_t start_fofs, end_fofs;
> > @@ -271,18 +293,7 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
> >  	start_blkaddr = fi->ext.blk;
> >
> >  	if (pgofs >= start_fofs && pgofs <= end_fofs) {
> > -		unsigned int blkbits = inode->i_sb->s_blocksize_bits;
> > -		size_t count;
> > -
> > -		clear_buffer_new(bh_result);
> > -		map_bh(bh_result, inode->i_sb,
> > -				start_blkaddr + pgofs - start_fofs);
> > -		count = end_fofs - pgofs + 1;
> > -		if (count < (UINT_MAX >> blkbits))
> > -			bh_result->b_size = (count << blkbits);
> > -		else
> > -			bh_result->b_size = UINT_MAX;
> > -
> > +		*ei = fi->ext;
> >  		stat_inc_read_hit(inode->i_sb);
> >  		read_unlock(&fi->ext_lock);
> >  		return 1;
> > @@ -608,13 +619,16 @@ static int __get_data_block(struct inode *inode, sector_t iblock,
> >  	int mode = create ? ALLOC_NODE : LOOKUP_NODE_RA;
> >  	pgoff_t pgofs, end_offset;
> >  	int err = 0, ofs = 1;
> > +	struct extent_info ei;
> >  	bool allocated = false;
> >
> >  	/* Get the page offset from the block offset(iblock) */
> >  	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
> >
> > -	if (check_extent_cache(inode, pgofs, bh_result))
> > +	if (check_extent_cache(inode, pgofs, &ei)) {
> > +		f2fs_map_bh(inode, pgofs, &ei, bh_result);
> >  		goto out;
> > +	}
> >
> >  	if (create) {
> >  		f2fs_balance_fs(F2FS_I_SB(inode));
> > --
> > 2.2.1

