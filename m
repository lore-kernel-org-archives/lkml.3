Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbbANAWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:22:22 -0500
Received: from mail.kernel.org ([198.145.29.136]:54754 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbbANAWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:22:21 -0500
Date: Tue, 13 Jan 2015 16:22:15 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: enable recover_xattr_data to avoid
 cp when fsync after operating xattr
Message-ID: <20150114002215.GA4930@jaegeuk-mac02.mot.com>
References: <009401d0297a$41523580$c3f6a080$@samsung.com>
 <20150106194419.GB54001@jaegeuk-mac02>
 <000101d02cce$4bed1c60$e3c75520$@samsung.com>
 <20150111053212.GB91790@jaegeuk-mac02.hsd1.ca.comcast.net>
 <000301d02e4b$e768bbd0$b63a3370$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301d02e4b$e768bbd0$b63a3370$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 05:40:28PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Sunday, January 11, 2015 1:32 PM
> > To: Chao Yu
> > Cc: 'Changman Lee'; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: enable recover_xattr_data to avoid cp when fsync after
> > operating xattr
> > 
> > On Sat, Jan 10, 2015 at 08:08:33PM +0800, Chao Yu wrote:
> > > Hi Jaegeuk,
> > >
> > > > -----Original Message-----
> > > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > > Sent: Wednesday, January 07, 2015 3:44 AM
> > > > To: Chao Yu
> > > > Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> > > > Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: enable recover_xattr_data to avoid cp when fsync
> > after
> > > > operating xattr
> > > >
> > > > Hi Chao,
> > > >
> > > > On Tue, Jan 06, 2015 at 02:29:40PM +0800, Chao Yu wrote:
> > > > > Now if we call fsync() after we update the xattr date belongs to the file, f2fs
> > > > > will do checkpoint to keep data.
> > > > > This can cause low performance because checkpoint block most operation and write
> > > > > lots of blocks. So we'd better to avoid doing checkpoint by writing modified
> > > > > xattr node page to warm node segment, and then it can be recovered when we mount
> > > > > this device later on.
> > > >
> > > > You're trying to change the writing policy as xattr blocks are written into
> > > > WARM_NODE area instead of COLD_NODE area.
> > > > I don't think xattrs are frequently changed between each fsync calls.
> > > >
> > > > How do you think?
> > >
> > > I'm not sure whether there is a scenario that setxattr and fsync are invoked
> > > alternately, but if there is, our performance will decrease obviously.
> > >
> > > If you don't want to change writing policy, how about writing xattr node with
> > > fsync flag into cold node segment when fsync() is called, then try to recover
> > > it from cold node chain when recovery after abnormally pow-cut, this way can
> > > avoid cp frequently in above scenario.
> > 
> > Firt of all, I don't think this scenario is frequent enough that we have to
> > break the exisiting writing and recovery procedures.
> > Moreover, if xattr entries are covered by inline_xattr, it doesn't trigger
> > checkpoint.
> 
> Agree, that's a good solution.
> 
> > 
> > Let me know, if I'm missing something.
> > 
> > If you try to change the recovery procedure, it needs to think about the
> > disk full condition. (i.e., space_for_roll_forward())
> > And, I don't want to search cold node chain.
> 
> OK, if we keep writing policy and recovery procedure as it is, then, shouldn't our
> recover_xattr_data be dropped because it will be not used from any call path?
> How do you think of below patch?

Hi Chao,

Nice catch.
But, IIRC, this code was remained for backward compatibility, since long time
ago, xattr blocks were written into the warm node chain.
So, I couldn't remove this.

Thanks,

> 
> >From 4fee238292aa0198a1530492afbd529e84e83141 Mon Sep 17 00:00:00 2001
> From: Chao Yu <chao2.yu@samsung.com>
> Date: Mon, 12 Jan 2015 17:25:44 +0800
> Subject: [PATCH] f2fs: drop recover_xattr_data
> 
> Because xattr node will be written to cold node segment, so in current procedure
> it's wrong that we try to find and recover it from warm node chain in
> recover_xattr_data.
> 
> Let's drop this related function and invoking.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/f2fs.h     |  1 -
>  fs/f2fs/node.c     | 36 ------------------------------------
>  fs/f2fs/recovery.c |  8 ++------
>  3 files changed, 2 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 209532c..3b18072 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1392,7 +1392,6 @@ bool alloc_nid(struct f2fs_sb_info *, nid_t *);
>  void alloc_nid_done(struct f2fs_sb_info *, nid_t);
>  void alloc_nid_failed(struct f2fs_sb_info *, nid_t);
>  void recover_inline_xattr(struct inode *, struct page *);
> -void recover_xattr_data(struct inode *, struct page *, block_t);
>  int recover_inode_page(struct f2fs_sb_info *, struct page *);
>  int restore_node_summary(struct f2fs_sb_info *, unsigned int,
>  				struct f2fs_summary_block *);
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index d7c1436..75aa233 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1656,42 +1656,6 @@ update_inode:
>  	f2fs_put_page(ipage, 1);
>  }
>  
> -void recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
> -{
> -	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
> -	nid_t prev_xnid = F2FS_I(inode)->i_xattr_nid;
> -	nid_t new_xnid = nid_of_node(page);
> -	struct node_info ni;
> -
> -	/* 1: invalidate the previous xattr nid */
> -	if (!prev_xnid)
> -		goto recover_xnid;
> -
> -	/* Deallocate node address */
> -	get_node_info(sbi, prev_xnid, &ni);
> -	f2fs_bug_on(sbi, ni.blk_addr == NULL_ADDR);
> -	invalidate_blocks(sbi, ni.blk_addr);
> -	dec_valid_node_count(sbi, inode);
> -	set_node_addr(sbi, &ni, NULL_ADDR, false);
> -
> -recover_xnid:
> -	/* 2: allocate new xattr nid */
> -	if (unlikely(!inc_valid_node_count(sbi, inode)))
> -		f2fs_bug_on(sbi, 1);
> -
> -	remove_free_nid(NM_I(sbi), new_xnid);
> -	get_node_info(sbi, new_xnid, &ni);
> -	ni.ino = inode->i_ino;
> -	set_node_addr(sbi, &ni, NEW_ADDR, false);
> -	F2FS_I(inode)->i_xattr_nid = new_xnid;
> -
> -	/* 3: update xattr blkaddr */
> -	refresh_sit_entry(sbi, NEW_ADDR, blkaddr);
> -	set_node_addr(sbi, &ni, blkaddr, false);
> -
> -	update_inode_page(inode);
> -}
> -
>  int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
>  {
>  	struct f2fs_inode *src, *dst;
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index c4211a5..f70c2e7 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -342,13 +342,9 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
>  	struct node_info ni;
>  	int err = 0, recovered = 0;
>  
> -	/* step 1: recover xattr */
> -	if (IS_INODE(page)) {
> +	/* step 1: recover inline xattr */
> +	if (IS_INODE(page))
>  		recover_inline_xattr(inode, page);
> -	} else if (f2fs_has_xattr_block(ofs_of_node(page))) {
> -		recover_xattr_data(inode, page, blkaddr);
> -		goto out;
> -	}
>  
>  	/* step 2: recover inline data */
>  	if (recover_inline_data(inode, page))
> -- 
> 2.2.1
> 
> 
> > 
> > Thanks,
> > 
> > >
> > > Thanks,
> > > Yu
