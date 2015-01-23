Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbbAWB4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:56:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:35350 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbbAWB4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:56:47 -0500
X-AuditID: cbfee61a-f79c06d000004e71-4e-54c1aa5dfffd
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <000801d02e37$31be79f0$953b6dd0$@samsung.com>
 <20150123003652.GD16473@jaegeuk-mac02>
In-reply-to: <20150123003652.GD16473@jaegeuk-mac02>
Subject: RE: [f2fs-dev][RFC PATCH 04/10] f2fs: introduce universal
 lookup/update interface for extent cache
Date: Fri, 23 Jan 2015 09:55:56 +0800
Message-id: <00e801d036af$d5563dc0$8002b940$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQENdbnIHBbsUAGfNlMsec1zrVI+RwHKYR8rnkQgBwA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd3YVQdDDJZMNbe4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxp2dM9kL
	NjhW/Gh/w9rAONu4i5GTQ0LARGLj7ylsELaYxIV764FsLg4hgUWMEoeWHYRyfjBKfN81mRGk
	ik1ARWJ5x38mEFtEQE2id98UIJuDg1mgSGLVCgGQsJBAksT9+5+YQWxOAWOJyUuPsoLYwgK5
	EicndYHZLAKqEmtONoMt5hWwlNj3bw0rhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5khDlWQ
	2HH2NSPECVYSV5ctgKoRl9h45BbLBEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERwDz6R2MK5ssDjEKMDBqMTDm1F8IESINbGsuDL3EKMEB7OSCK/BkoMh
	QrwpiZVVqUX58UWlOanFhxilOViUxHmV7NtChATSE0tSs1NTC1KLYLJMHJxSDYwaVy49/b7x
	3YLLfu/KHzZZTI3rDTLgcP/0+ICZUFL7X944hzsaYXuSw1Z+qGPY/Sl0vt9J23YVwfDN7Ick
	47m3d198fEjZ4GqrnUlRTSDrm0dCVz9b7ONxuOtRuqlu5xaLNQ+aDvnK5H9XMXYqehgiM+3X
	j/e99+aYTNjpduz/3RWGm6NUrZ8rsRRnJBpqMRcVJwIASYafen0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Friday, January 23, 2015 8:37 AM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][RFC PATCH 04/10] f2fs: introduce universal lookup/update interface for
> extent cache
> 
> Hi Chao,
> 
> On Mon, Jan 12, 2015 at 03:12:13PM +0800, Chao Yu wrote:
> > In this patch, we do these jobs:
> > 1. rename {check,update}_extent_cache to f2fs_{lookup,update}_extent_info;
> > 2. introduce universal lookup/update interface of extent cache:
> > f2fs_{lookup,update}_extent_cache including above two real functions, then
> > export them to function callers.
> >
> > So after above cleanup, we can add new rb-tree based extent cache into exported
> > interfaces.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/data.c     | 66 +++++++++++++++++++++++++++++++++---------------------
> >  fs/f2fs/f2fs.h     |  2 +-
> >  fs/f2fs/file.c     |  2 +-
> >  fs/f2fs/inline.c   |  2 +-
> >  fs/f2fs/recovery.c |  2 +-
> >  5 files changed, 44 insertions(+), 30 deletions(-)
> >
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 5a3e489..4f5b871e 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -270,20 +270,20 @@ static void f2fs_map_bh(struct inode *inode, pgoff_t pgofs,
> >  		bh_result->b_size = UINT_MAX;
> >  }
> >
> > -static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
> > -					struct extent_info *ei)
> > +static bool f2fs_lookup_extent_info(struct inode *inode, pgoff_t pgofs,
> > +							struct extent_info *ei)
> 
> This is a static function, so I think it would be good to remove "f2fs_".

OK, I will fix this.

> 
> >  {
> >  	struct f2fs_inode_info *fi = F2FS_I(inode);
> >  	pgoff_t start_fofs, end_fofs;
> >  	block_t start_blkaddr;
> >
> >  	if (is_inode_flag_set(fi, FI_NO_EXTENT))
> > -		return 0;
> > +		return false;
> >
> >  	read_lock(&fi->ext_lock);
> >  	if (fi->ext.len == 0) {
> >  		read_unlock(&fi->ext_lock);
> > -		return 0;
> > +		return false;
> >  	}
> >
> >  	stat_inc_total_hit(inode->i_sb);
> > @@ -296,29 +296,22 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
> >  		*ei = fi->ext;
> >  		stat_inc_read_hit(inode->i_sb);
> >  		read_unlock(&fi->ext_lock);
> > -		return 1;
> > +		return true;
> >  	}
> >  	read_unlock(&fi->ext_lock);
> > -	return 0;
> > +	return false;
> >  }
> >
> > -void update_extent_cache(struct dnode_of_data *dn)
> > +static bool f2fs_update_extent_info(struct inode *inode, pgoff_t fofs,
> > +								block_t blkaddr)
> 
> Ditto.

I see.

Thanks,
Yu

> 
> Thanks,
> 
> >  {
> > -	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
> > -	pgoff_t fofs, start_fofs, end_fofs;
> > +	struct f2fs_inode_info *fi = F2FS_I(inode);
> > +	pgoff_t start_fofs, end_fofs;
> >  	block_t start_blkaddr, end_blkaddr;
> >  	int need_update = true;
> >
> > -	f2fs_bug_on(F2FS_I_SB(dn->inode), dn->data_blkaddr == NEW_ADDR);
> > -
> > -	/* Update the page address in the parent node */
> > -	__set_data_blkaddr(dn);
> > -
> >  	if (is_inode_flag_set(fi, FI_NO_EXTENT))
> > -		return;
> > -
> > -	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
> > -							dn->ofs_in_node;
> > +		return false;
> >
> >  	write_lock(&fi->ext_lock);
> >
> > @@ -333,16 +326,16 @@ void update_extent_cache(struct dnode_of_data *dn)
> >
> >  	/* Initial extent */
> >  	if (fi->ext.len == 0) {
> > -		if (dn->data_blkaddr != NULL_ADDR) {
> > +		if (blkaddr != NULL_ADDR) {
> >  			fi->ext.fofs = fofs;
> > -			fi->ext.blk = dn->data_blkaddr;
> > +			fi->ext.blk = blkaddr;
> >  			fi->ext.len = 1;
> >  		}
> >  		goto end_update;
> >  	}
> >
> >  	/* Front merge */
> > -	if (fofs == start_fofs - 1 && dn->data_blkaddr == start_blkaddr - 1) {
> > +	if (fofs == start_fofs - 1 && blkaddr == start_blkaddr - 1) {
> >  		fi->ext.fofs--;
> >  		fi->ext.blk--;
> >  		fi->ext.len++;
> > @@ -350,7 +343,7 @@ void update_extent_cache(struct dnode_of_data *dn)
> >  	}
> >
> >  	/* Back merge */
> > -	if (fofs == end_fofs + 1 && dn->data_blkaddr == end_blkaddr + 1) {
> > +	if (fofs == end_fofs + 1 && blkaddr == end_blkaddr + 1) {
> >  		fi->ext.len++;
> >  		goto end_update;
> >  	}
> > @@ -377,9 +370,30 @@ void update_extent_cache(struct dnode_of_data *dn)
> >  	}
> >  end_update:
> >  	write_unlock(&fi->ext_lock);
> > -	if (need_update)
> > +	return need_update;
> > +}
> > +
> > +static bool f2fs_lookup_extent_cache(struct inode *inode, pgoff_t pgofs,
> > +							struct extent_info *ei)
> > +{
> > +	return f2fs_lookup_extent_info(inode, pgofs, ei);
> > +}
> > +
> > +void f2fs_update_extent_cache(struct dnode_of_data *dn)
> > +{
> > +	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
> > +	pgoff_t fofs;
> > +
> > +	f2fs_bug_on(F2FS_I_SB(dn->inode), dn->data_blkaddr == NEW_ADDR);
> > +
> > +	/* Update the page address in the parent node */
> > +	__set_data_blkaddr(dn);
> > +
> > +	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
> > +							dn->ofs_in_node;
> > +
> > +	if (f2fs_update_extent_info(dn->inode, fofs, dn->data_blkaddr))
> >  		sync_inode_page(dn);
> > -	return;
> >  }
> >
> >  struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
> > @@ -625,7 +639,7 @@ static int __get_data_block(struct inode *inode, sector_t iblock,
> >  	/* Get the page offset from the block offset(iblock) */
> >  	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
> >
> > -	if (check_extent_cache(inode, pgofs, &ei)) {
> > +	if (f2fs_lookup_extent_cache(inode, pgofs, &ei)) {
> >  		f2fs_map_bh(inode, pgofs, &ei, bh_result);
> >  		goto out;
> >  	}
> > @@ -792,7 +806,7 @@ int do_write_data_page(struct page *page, struct f2fs_io_info *fio)
> >  		set_inode_flag(F2FS_I(inode), FI_UPDATE_WRITE);
> >  	} else {
> >  		write_data_page(page, &dn, fio);
> > -		update_extent_cache(&dn);
> > +		f2fs_update_extent_cache(&dn);
> >  		set_inode_flag(F2FS_I(inode), FI_APPEND_WRITE);
> >  	}
> >  out_writepage:
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index a74ad85..eb9ffae 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -1475,7 +1475,7 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *, struct page *,
> >  						struct f2fs_io_info *);
> >  int reserve_new_block(struct dnode_of_data *);
> >  int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
> > -void update_extent_cache(struct dnode_of_data *);
> > +void f2fs_update_extent_cache(struct dnode_of_data *);
> >  struct page *find_data_page(struct inode *, pgoff_t, bool);
> >  struct page *get_lock_data_page(struct inode *, pgoff_t);
> >  struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index 5df3367..0dcd9fb 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -430,7 +430,7 @@ int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
> >  			continue;
> >
> >  		dn->data_blkaddr = NULL_ADDR;
> > -		update_extent_cache(dn);
> > +		f2fs_update_extent_cache(dn);
> >  		invalidate_blocks(sbi, blkaddr);
> >  		nr_free++;
> >  	}
> > diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> > index fa2aa2f..9f6c745 100644
> > --- a/fs/f2fs/inline.c
> > +++ b/fs/f2fs/inline.c
> > @@ -116,7 +116,7 @@ no_update:
> >  	set_page_writeback(page);
> >  	fio.blk_addr = dn->data_blkaddr;
> >  	write_data_page(page, dn, &fio);
> > -	update_extent_cache(dn);
> > +	f2fs_update_extent_cache(dn);
> >  	f2fs_wait_on_page_writeback(page, DATA);
> >  	if (dirty)
> >  		inode_dec_dirty_pages(dn->inode);
> > diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> > index c4211a5..a7adbdb 100644
> > --- a/fs/f2fs/recovery.c
> > +++ b/fs/f2fs/recovery.c
> > @@ -397,7 +397,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
> >  			/* write dummy data page */
> >  			recover_data_page(sbi, NULL, &sum, src, dest);
> >  			dn.data_blkaddr = dest;
> > -			update_extent_cache(&dn);
> > +			f2fs_update_extent_cache(&dn);
> >  			recovered++;
> >  		}
> >  		dn.ofs_in_node++;
> > --
> > 2.2.1

