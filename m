Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbbAFTo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:44:27 -0500
Received: from mail.kernel.org ([198.145.29.136]:45457 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932693AbbAFToY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:44:24 -0500
Date: Tue, 6 Jan 2015 11:44:19 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: enable recover_xattr_data to avoid
 cp when fsync after operating xattr
Message-ID: <20150106194419.GB54001@jaegeuk-mac02>
References: <009401d0297a$41523580$c3f6a080$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009401d0297a$41523580$c3f6a080$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Tue, Jan 06, 2015 at 02:29:40PM +0800, Chao Yu wrote:
> Now if we call fsync() after we update the xattr date belongs to the file, f2fs
> will do checkpoint to keep data.
> This can cause low performance because checkpoint block most operation and write
> lots of blocks. So we'd better to avoid doing checkpoint by writing modified
> xattr node page to warm node segment, and then it can be recovered when we mount
> this device later on.

You're trying to change the writing policy as xattr blocks are written into
WARM_NODE area instead of COLD_NODE area.
I don't think xattrs are frequently changed between each fsync calls.

How do you think?

Thanks,

> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/f2fs.h     |  3 +--
>  fs/f2fs/file.c     |  3 ---
>  fs/f2fs/node.c     | 28 ++++++++++++++++------------
>  fs/f2fs/node.h     |  2 +-
>  fs/f2fs/recovery.c |  4 +++-
>  fs/f2fs/xattr.c    |  3 ---
>  6 files changed, 21 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index c48847e..dfbdd64 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -301,7 +301,6 @@ struct f2fs_inode_info {
>  	f2fs_hash_t chash;		/* hash value of given file name */
>  	unsigned int clevel;		/* maximum level of given file name */
>  	nid_t i_xattr_nid;		/* node id that contains xattrs */
> -	unsigned long long xattr_ver;	/* cp version of xattr modification */
>  	struct extent_info ext;		/* in-memory extent cache entry */
>  	struct inode_entry *dirty_dir;	/* the pointer of dirty dir */
>  
> @@ -1391,7 +1390,7 @@ bool alloc_nid(struct f2fs_sb_info *, nid_t *);
>  void alloc_nid_done(struct f2fs_sb_info *, nid_t);
>  void alloc_nid_failed(struct f2fs_sb_info *, nid_t);
>  void recover_inline_xattr(struct inode *, struct page *);
> -void recover_xattr_data(struct inode *, struct page *, block_t);
> +int recover_xattr_data(struct inode *, struct page *, block_t);
>  int recover_inode_page(struct f2fs_sb_info *, struct page *);
>  int restore_node_summary(struct f2fs_sb_info *, unsigned int,
>  				struct f2fs_summary_block *);
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index f172ddc4..fb26a43 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -129,8 +129,6 @@ static inline bool need_do_checkpoint(struct inode *inode)
>  		need_cp = true;
>  	else if (!is_checkpointed_node(sbi, F2FS_I(inode)->i_pino))
>  		need_cp = true;
> -	else if (F2FS_I(inode)->xattr_ver == cur_cp_version(F2FS_CKPT(sbi)))
> -		need_cp = true;
>  	else if (test_opt(sbi, FASTBOOT))
>  		need_cp = true;
>  	else if (sbi->active_logs == 2)
> @@ -156,7 +154,6 @@ static void try_to_fix_pino(struct inode *inode)
>  	nid_t pino;
>  
>  	down_write(&fi->i_sem);
> -	fi->xattr_ver = 0;
>  	if (file_wrong_pino(inode) && inode->i_nlink == 1 &&
>  			get_parent_ino(inode, &pino)) {
>  		fi->i_pino = pino;
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index a7cb0db..675fa65 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -863,9 +863,6 @@ int truncate_xattr_node(struct inode *inode, struct page *page)
>  
>  	F2FS_I(inode)->i_xattr_nid = 0;
>  
> -	/* need to do checkpoint during fsync */
> -	F2FS_I(inode)->xattr_ver = cur_cp_version(F2FS_CKPT(sbi));
> -
>  	set_new_dnode(&dn, inode, page, npage, nid);
>  
>  	if (page)
> @@ -1655,12 +1652,13 @@ update_inode:
>  	f2fs_put_page(ipage, 1);
>  }
>  
> -void recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
> +int recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
>  	nid_t prev_xnid = F2FS_I(inode)->i_xattr_nid;
>  	nid_t new_xnid = nid_of_node(page);
>  	struct node_info ni;
> +	struct page *xpage;
>  
>  	/* 1: invalidate the previous xattr nid */
>  	if (!prev_xnid)
> @@ -1674,21 +1672,27 @@ void recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
>  	set_node_addr(sbi, &ni, NULL_ADDR, false);
>  
>  recover_xnid:
> -	/* 2: allocate new xattr nid */
> +	/* 2: update xattr nid in inode */
> +	remove_free_nid(NM_I(sbi), new_xnid);
> +	F2FS_I(inode)->i_xattr_nid = new_xnid;
>  	if (unlikely(!inc_valid_node_count(sbi, inode)))
>  		f2fs_bug_on(sbi, 1);
> +	update_inode_page(inode);
> +
> +	/* 3: update and make xattr node page dirty */
> +	xpage = grab_cache_page(NODE_MAPPING(sbi), new_xnid);
> +	if (!xpage)
> +		return -ENOMEM;
> +
> +	memcpy(F2FS_NODE(xpage), F2FS_NODE(page), PAGE_CACHE_SIZE);
>  
> -	remove_free_nid(NM_I(sbi), new_xnid);
>  	get_node_info(sbi, new_xnid, &ni);
>  	ni.ino = inode->i_ino;
>  	set_node_addr(sbi, &ni, NEW_ADDR, false);
> -	F2FS_I(inode)->i_xattr_nid = new_xnid;
> +	set_page_dirty(xpage);
> +	f2fs_put_page(xpage, 1);
>  
> -	/* 3: update xattr blkaddr */
> -	refresh_sit_entry(sbi, NEW_ADDR, blkaddr);
> -	set_node_addr(sbi, &ni, blkaddr, false);
> -
> -	update_inode_page(inode);
> +	return 0;
>  }
>  
>  int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> index cac8a3d..55eb1e7 100644
> --- a/fs/f2fs/node.h
> +++ b/fs/f2fs/node.h
> @@ -300,7 +300,7 @@ static inline bool IS_DNODE(struct page *node_page)
>  	unsigned int ofs = ofs_of_node(node_page);
>  
>  	if (f2fs_has_xattr_block(ofs))
> -		return false;
> +		return true;
>  
>  	if (ofs == 3 || ofs == 4 + NIDS_PER_BLOCK ||
>  			ofs == 5 + 2 * NIDS_PER_BLOCK)
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index 9160a37..4f2c197 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -346,7 +346,9 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
>  	if (IS_INODE(page)) {
>  		recover_inline_xattr(inode, page);
>  	} else if (f2fs_has_xattr_block(ofs_of_node(page))) {
> -		recover_xattr_data(inode, page, blkaddr);
> +		err = recover_xattr_data(inode, page, blkaddr);
> +		if (!err)
> +			recovered++;
>  		goto out;
>  	}
>  
> diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
> index 5072bf9..3d13ca2 100644
> --- a/fs/f2fs/xattr.c
> +++ b/fs/f2fs/xattr.c
> @@ -391,9 +391,6 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
>  						sizeof(struct node_footer));
>  	set_page_dirty(xpage);
>  	f2fs_put_page(xpage, 1);
> -
> -	/* need to checkpoint during fsync */
> -	F2FS_I(inode)->xattr_ver = cur_cp_version(F2FS_CKPT(sbi));
>  	return 0;
>  }
>  
> -- 
> 2.2.1
